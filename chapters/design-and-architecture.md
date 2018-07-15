# Design and Architecture



## The Nodes

Nodes are the central part of scenery and represent all the entities that can be rendered on-screen. These nodes are organised into an ordered, acyclic graph of parent-child relationships. Operations, such as mathematical transformations -- such as translations, rotations, or scalings -- are automatically propagated to a `Node`s `children`. This way of organising scene contents is called a _scene graph_ and is a standard way in computer graphics to organise scenes hierarchically by their relationship with each other. 

For actually organising nodes into a scene, a special node type exists, the `Scene`. `Node`s attached to a top-level `Scene` element as `children` become the top-level elements of the scene, and can in turn have their own `children`.

As a short example, a `Scene` might contain a `Node` _Cell_, which has children _Nucleus_ and _ER_. The transformations of _Nucleus_ and _ER_ are then relative to _Cell_, and when the _Cell_ moves, so will _Nucleus_ and _ER_.

### Transforms

A `Node` can have the following transforms:

* `position` -- the position of the `Node` in 3D space
* `scale` -- scaling along the X, Y, and Z axis
* `rotation` -- a quaternion[^quatnote] describing the `Node`s orientation in space.
* `model` -- local transforms how this `Node` is positioned with respect so its parent
* `world` -- global transforms that include the `model` transform, as well as the `parent`s `world` transform

The transforms are calculated by a `Node`s `updateWorld(recursive: Boolean, force: Boolean)` routine, and stored to the `model` and `world` properties. If `recursive` is specified, the routine will descend to all children, calculate their transforms, and mark them as updated. If any of the transforms of a `Node` change during runtime, it will get its `needsUpdate` and `needsUpdateWorld` flag set, to be picked up on the next update run.

\TODO{Add scene graph figure}

[^quatnote]: Quaternions are a 4-dimensional extension of complex numbers, that can also describe rotations in space. While rotations may as well be represented as matrices, such representations suffer from two problems: a) they cannot be smoothly interpolated and b) they may lead to _gimbal locking_, where the sine or cosine of an angle in a rotation matrix lead to a zero entry, making the transformation loose a degree of freedom. Quaternions are free of both problems, they are however not as intuitive as e.g. Euler angles. In scenery, helper routines are provided to convert Euler angles and matrices to quaternions for user convenience.

## The Hub

The hub is the communication backbone of scenery. All of the subsystems register with a hub, and a hub can be queried for the presence of a subsystem. In this way, it is possible to also realise completely headless applications, that run logic, but do not produce any visual output, and do not take any input.

Hubs can be queried by `Hub.get(e: SceneryElement)`. This routine will return the `SceneryElement` is has been asked for, or `null` if it does not exist.

A new `SceneryElement` may be added to a hub via `Hub.add(e: SceneryElement, obj: Any)`.

## Input Handling

Input handling is done using using Tobias Pietzsch's _ui-behaviour_ library \TODO{Cite!}. This library provides an distinction of input events into `InputTriggers` and `Behaviours`. An `InputTrigger` is the causal event, such as a key press, or a mouse movement/scroll/click. A `Behaviour` is the triggered action. By default, ui-behaviour is able to handle AWT input events. For scenery, we have extended the library to also be able to handle events originating from within JOGL, GLFW, or JavaFX. Further, custom mappings are available for buttons of hand-held controller devices, or VRPN devices.

Spatial input, such as HMD positioning and rotations, are handled by the specific implementation of a `TriggerInput`, such as an `OpenVRHMD`, or a `VRPNTracker`. Multiple of these inputs can coexist peacefully, and will not interfere with each other, but rather augment.

## The Renderers

In scenery, the contract with the renderer is a relatively thin one:

```kotlin
abstract class Renderer : Hubable {
    abstract fun initializeScene()
    abstract fun render()
    abstract var shouldClose: Boolean
    abstract var initialized: Boolean
        protected set
    abstract var settings: Settings
    abstract var window: SceneryWindow
    abstract var embedIn: SceneryPanel?
    abstract fun close()
    fun screenshot() {
        screenshot("")
    }

    abstract fun screenshot(filename: String = "")
    abstract fun reshape(newWidth: Int, newHeight: Int)
    abstract fun setRenderingQuality(quality: RenderConfigReader.RenderingQuality)
    abstract var pushMode: Boolean
    abstract val managesRenderLoop: Boolean

    abstract var lastFrameTime: Float
    abstract var renderConfigFile: String

    ...
}
```

Basically, a renderer needs to be able to render something, take screenshots, resize a (potentially not existing) viewport, and take screenshots. This design decision was made such that scenery can support a variety of different rendering backends, after discovering that OpenGL -- which scenery started with as only renderer -- and Vulkan do not map well to each other. With this architecture it is possible to extend rendering support in the future to e.g. software renderers, or external ray tracing frameworks.

A renderer may also run in its own thread, but must indicate that properly by setting `managesRenderLoop`, as e.g. done by the OpenGL renderer. In the opposite case, the renderer will run syncronous with scenery's main loop.

A renderer may store its own metadata related to a `Node` in its `metadata` field. This field must be cleared upon the removal of a `Node` from the scene. The `metadata` must be uniquely named, such that renderers running in parallel do not interfere with each other's `metadata`.

At the time of writing, scenery includes an OpenGL renderer, and a Vulkan renderer.

### Windowing Systems

On the JavaVM, the main options for drawing (to) windows and related elements are AWT, Swing, and JavaFX. Rendering to AWT and Swing is only supported by the OpenGL renderer, while both renderers support JavaFX. The Vulkan renderer by default uses GLFW to create and interact with windows, GLFW however is not compatible with AWT or Swing, because both have very similar ideas about how event handling should be done in which thread, therefore clashing about it, and leading to software instability.

JavaFX is now the predominant mode for building scenery-based applications. However, in OpenGL, buffer copies from the current framebuffer to a JavaFX texture are necessary and incur a performance penalty. With Vulkan, this problem does not exist, as Vulkan exhibits a feature called _permanently mapped buffers_, which are accessible by both the host and device via DMA, and do not require copying, alleviating the pressure on the PCI express bus incurred by a copy. These PMBs then are ping-ponged for double buffering and provide a very good user and developer experience.

### Rendering with OpenGL

When using OpenGL, the initialisation of the renderer proceeds in the following way:

1. the presence of a virtual reality HMD is checked.
2. the `RenderConfig` is parsed from a file.
2. it is checked whether the renderer will be embedded in a `SceneryPanel` for rendering with JavaFX, or if a drawable surface already exists. If both are not the case, a window owned by the renderer is created. After this, a separate animator thread takes over the initialisation.
3. an OpenGL 4.1 context is initialised. 
4. a default set of buffers is initialised for:
	* Uniform Buffer Objects (UBOs)[^ubonote]
	* light parameters
	* rendering parameters
	* Shader Properties
	* Shader Parameters
5. a default set of textures is initialised to provide textures in case a `Node`'s textures cannot be found.
6. the render passes defined by the `RenderConfig` are created, with the necessary framebuffers and attachments.
7. a heartbeat timer is initialised to record GPU usage (only on Nvidia cards running on Windows) and record performance data.

The renderer then proceeds with scene initialisation, initialising each `Node` in the scene in this way:

1. The `Node` is locked.
2. a new instance of `OpenGLObjectState` is attached to the `Node`'s `metadata` field
3. vertex buffers[^vbonote] and vertex array objects[^vaonote] are created.
4. custom shaders and material properties are initialised.
5. UBOs for transformations and material properties are initialised.
6. the renderer checks whether the `Node`'s definition includes any `@ShaderProperty` annotations, for which an additional UBO would be created. \TODO{Add reference to chapter}
7. The `Node` is marked as initialised and unlocked.

[^ubonote]: Uniform Buffer Objects are collections of properties that are used in the shader, similar to C-style structs. Before, single uniform variables have been stored and updated individually, but UBOs provide a performance benefit due to reduced API overhead and syncronised updates.
[^vbonote]: Vertex Buffer Objects are the buffers on the GPU that actually contain the vertices of a Node's geometry. In scenery, they are stored in a strided format, meaning that vertices and normals are not stored as `V1V2V3N1N2N3...`, but rather as `V1N1V2N2V3N3`, for improved cache locality.
[^vaonote]: Vertex Array Objects describe which buffers a rendered object in OpenGL uses, and what the data layouts of these buffers are.

### Rendering with Vulkan

When using OpenGL, the initialisation of the renderer proceeds in the following way:

1. the presence of a virtual reality HMD is checked, and window dimensions set accordingly.
2. The `RenderConfig` is parsed from a render config YAML file.
3. The renderer checks whether the user has requested the activation of validation layers[^layernote], and activates them if indicated.
4. the renderer checks whether the output will be embedded in a `SceneryPanel`. If this is not the case, the renderer will request surface rendering extensions, and create a _Vulkan instance_[^instancenote], if not, the instance will be created without the extensions. Further extensions might be required by the presence of an HMD, e.g. for memory sharing.
5. A `VulkanDevice`[^devicenote] is created, the renderer defaults to the first device found, but this can be overridden by the user.
6. A device queue[^queuenote] is created.
7. A `SwapchainRecreator` is created. This object is responsible for all resources that are resolution-dependent, such as framebuffers and rendering surfaces. It also takes care of initialising the render passes defined by the `RenderConfig`, with the necessary framebuffers and attachments. The swapchain is be one of:
	* `OpenGLSwapchain`: creates an OpenGL context and enables the Vulkan renderer to draw into that. Necessary for frame-locked rendering e.g. on CAVE systems.
	* `HeadlessSwapchain`: creates a swapchain without any rendering surfaces, e.g. for server use.
	* `FXSwapchain`: create a swapchain for rendering into a JavaFX panel. Employs permanently mapped buffers for bandwidth efficiency and inherits from `HeadlessSwapchain`.
	* `VulkanSwapchain`: creates a regular, window-based swapchain with GLFW. This is the standard case.
8. the default vertex descriptors[^vdnote] are created.
9. descriptor pools are created.
10. default descriptor set layouts and descriptor sets[^dslnote] are prepared.
11. a default set of textures is initialised to provide textures in case a `Node`'s textures cannot be found.
12. a heartbeat timer is initialised to record GPU usage (only on Nvidia cards running on Windows) and record performance data.
13. a dynamically-mananged memory pool for `Node` geometry is allocated.

Let's note here that the Vulkan renderer does not perform explicit scene initialisation on startup, but discovers the `Node`s of a scene during the rendering loop.

[^layernote]: In Vulkan, a _validation layer_ provides guidance to adherance to the standard. While in OpenGL, all state is continiously checked for sanity, thus incurring a performance hit, Vulkan skips these checks, and has outsourced them to validation layers, that may be activated during startup, and usually only used during development or debugging. Compared to OpenGL error messages, Vulkan validation layers provide highly detailed error messages, usually enabling the developer to quickly pinpoint the source of a problem.
[^instancenote]: A _Vulkan instance_ is the basic building block of a Vulkan application.
[^devicenote]: A _Vulkan device_ contains all the information about a device and its capabilities, and all allocations and executions are made with respect to a particular device, also enabling parallel runs on multiple devices.
[^queuenote]: Work, may it be rendering or compute work, is submitted to a _queue_ in Vulkan, and executed asyncronously by the GPU. A queue may be asked for work completion and can be waited on.
[^vdnote]: _Vertex descriptors_ describe the vertex layout for rendering and are somewhat comparable to OpenGL's Vertex Array Objects.

[^dslnote]: _Descriptor set layouts_ describe the memory layout of UBOs and textures in a shader, while _descriptor sets_ contain their actual realisation, and link to a physical buffer.

<div class="figure-on-margin">
~~~mermaid
sequenceDiagram
    Alice->>John: Hello John, how are you?
    John-->>Alice: Great!
~~~
</div>


### Generic Rendering workflow

### Shader Introspection




### Instancing

Instancing is done nicely ...



### Mapping between scenery Nodes and shaders

spirvcrossj enables...



### Configurable Rendering Pipelines

With YAML files, we can ...



### Push Mode

Push mode enables event-driven rendering


### Volume Rendering



## Settings store

Settings are stored...



## External hardware -- Head-mounted displays

HMD support is provided by SteamVR...



## External hardware -- Augmented Reality and the Hololens

_scenery_ also includes support for the Microsoft Hololens, a stand-alone, untethered augmented reality headset, based on the Universal Windows Platform. The Hololens includes its own CPU and GPU, due to size constraints they are however not very powerful, and especially if it comes to rendering of volumetric datasets, completely underpowered.

To get around this issue, we have developed a thin, Direct3D-based client application for the Hololens that makes use of Hololens Remoting, a kind of proprietary streaming protocol developed by Microsoft[^remotingnote]. This client receives pose data from the Hololens, as well as all other parameters required to generate correct images, such as the projection matrices for each eye. This data is then forwarded to a Hololens interface within scenery, based on the regular HMD interface. Initial communication to acquire rendering parameters is done via a ZeroMQ publish-subscribe socket, as is receiving of per-frame pose data.

The Hololens remoting applications are usually fed by data rendered with Direct3D, which lets us immediately recognise the problem that _scenery_ can only render via OpenGL and Vulkan at the present moment. Fortunately, a shared memory extension for Vulkan, `NV_external_memory`, exists in the standard that enables `zero-copy` sharing of buffer data between different graphics APIs, by using a keyed mutex. Programmatically, this is done as:

1. Allocate a Direct3D shared handle texture with flag `D3D11_RESOURCE_MISC_SHARED_KEYEDMUTEX` on the side of the client application. This application will serve as the final render target.[^sharedperfnote]
2. On the host (_scenery_) side, verify that the device supports this type of Direct3D texture for importing.
3. Create a Vulkan image, with memory bound to the shared handle.
4. Request access to the image via the keyed mutex, and store image data in it, e.g. via `vkCmdBlitImage`. Keyed mutex handling is done by the extension itself, via extra information attached to the appropriate `vkQueueSubmit` call.

The inclusion of the keyed mutex information into the `vkQueueSubmit` call in the last step has the benefit that no additional network communication via ZeroMQ is necessary to indicate by which part of the software the shared texture is used at the moment, leading to increased performance.

[^remotingnote]: The exact details of how this works are not published, but apparently work by streaming the image data for both eyes over the network, compressed with H264.
[^sharedperfnote]: In a production application, multiple image buffers should be allocated and used in a double/triple-buffering manner for read/write access to prevent the GPU stalling.

## External Hardware -- Eye Tracking

Eye tracking support is provided by ...





