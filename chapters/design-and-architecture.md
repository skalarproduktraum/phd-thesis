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

::: figure-on-margin
~~~ {.mermaid format=svg width=100% loc=tmp}
sequenceDiagram
    Alice->>John: Hello John, how are you?
    John-->>Alice: Great!
~~~
:::

### Uniform Buffer Serialisation and Updates

UBOs are tentatively updated with each frame before the main rendering loop, guaranteeing that a `Node` that has been added to the scene graph will have it's transformations and properties ready at render time. 

Serialisation of a `Node`'s transformations and properties are handled by the class `UBO`. In that class, member variables of the UBO are stored as a `LinkedHashMap` of a string (for the property name), and a lambda of type `() -> Any` for the value of the property. This mechanism enables determining values of properties that change during runtime, without rewriting the contents of the map. Order in the struct does matter, which is why a linked map is being used. The actual order of the properties is determined via shader introspection. For common data types (floats, doubles, integers, shorts, booleans, vectors, and matrices), `UBO` will determine the necessary size and offset of a certain property, and write the contents of the property to a `ByteBuffer`, according to OpenGL's `std140` buffer rules.

After an `UBO` has been serialised for the first time, a hash is calculated from it's current members. Upon revisiting this `UBO`, the previous member hash is compared with the current one, to determine whether re-serialisation is necessary or not.

### Push Mode

Push Mode is a rendering optimisation especially for viewer-type applications, where continuous scene changes are not expected. In push mode, the renderer will keep track of updated UBOs and modified scene contents, and only render a frame in the following cases:

* an UBO has been updated
* an object has been added or removed from the currently visible objects
* an object that is visible has changed it's properties (e.g. uses a different material or texture now)

Buffer swaps may however still take place, so that special care is taken to update all swapchain images before stopping to actively render. This mechanism is implemented using a `CountDownLatch` that starts with the number of swapchain images, and is counted down by one for each render loop pass. When the latch reaches zero, rendering is discontinued until the next update happens.

The push mode mechanism also guarantees that all updates to the scene's content are obeyed, as it is not tied to e.g. input events, but the actual updates of scene contents or UBOs.

### Configurable Rendering Pipelines

scenery provides configurable rendering pipelines which can contain multiple passes over the scene's geometry, or postprocessing (fullscreen) passes. The renderpasses are read from a YAML file, that looks e.g. like the following one for forward shading with HDR postprocessing:

```yaml
name: Forward Shading
description: Forward Shading Pipeline, with HDR postprocessing

rendertargets:
  HDR:
    size: 1.0, 1.0
    attachments:
      HDRBuffer: RGBA_Float32
      ZBuffer: Depth32

renderpasses:
  Scene:
    type: geometry
    shaders:
      - "Default.vert.spv"
      - "Default.frag.spv"
    output: HDR
  PostprocessHDR:
    type: quad
    shaders:
      - "FullscreenQuad.vert.spv"
      - "HDR.frag.spv"
    inputs:
      - HDR
    output: Viewport
    parameters:
      Gamma: 1.7
      Exposure: 1.5
```

In the render config file, both _rendertargets_ and _renderpasses_ are defined. A _rendertarget_ consists of a framebuffer name, a framebuffer size, and a set of attachments of the framebuffer that can have different data types. A _renderpass_ consists of a pass name, a type -- geometry or quad (for postprocessing) --, a set of default shaders, and defined _inputs_ and _outputs_. The renderpass may also define a set of _shader parameters_, which are handed over to the shader via the `UBO` mechanism, and supports all the data types supported by `UBO`.

The definition must contain one renderpass that outputs to Viewport, otherwise nothing will be rendered.

From the definition in the YAML file, `RenderConfigReader` will try to form a directed acyclic graph (DAG), which in the forward shading case will be relatively simple:

~~~ {.mermaid format=png width=100%}
graph LR
    A(Scene contents) -.-> B[Scene]
    B --> C[PostprocessHDR]
    C -.-> D(Viewport)
~~~

If a DAG cannot be formed from the given definition, `RenderConfigReader` will emit an exception.

Render configs are switchable during runtime and will cause the renderer to destroy and recreate its rendering framebuffers. This mechanims is e.g. used to switch between mono and stereo rendering during runtime.

### Generic Rendering workflow

In scenery, scene object discovery (determining which objects are to be rendered), and updating the UBO's contents are done in parallel using Kotlin's coroutines.

The main rendering loop will proceed after the visible objects have been determined:

~~~ {.mermaid format=png width=100% caption="Rendering timeline\label{fig:rendertimeline}"}
gantt
    title Rendering Timeline
    dateFormat  YYYY-MM-DD
    section Rendering
    Async object discovery           :a1, 2018-03-14, 2d
    
    Render loop						:after a1, 3d
    section UBO
    UBO updates      :2018-03-14, 36h
~~~

The main loop then proceeds as follows:

1. Loop through the flow of renderpasses, except Viewport pass:
	1. determine the kind of pass 	
	2. bind framebuffers for output
	3. blit contents of inputs into output framebuffer (if configured)
	4. set pass configuration and blending options
	5. iterate through scene objects (if scene pass or light pass) or draw fullscreen quad (if quad/postprocessing pass), and bind UBOs and buffers for each object as necessary
2. Run the viewport pass in the same way as (5), but siphon out data for third-party consumers (video recording, screenshots,...) if necessary
3. Swap buffers.

### Shader Introspection




### Instancing

Instancing is done nicely ...



### Mapping between scenery Nodes and shaders

spirvcrossj enables...







### Push Mode

Push mode enables event-driven rendering


### Volume Rendering



## Settings store

Settings are stored...



## External hardware -- Head-mounted displays

HMD support is provided by SteamVR...



## External hardware -- Augmented Reality and the Hololens

_scenery_ also includes support for the Microsoft Hololens, a stand-alone, untethered augmented reality headset, based on the Universal Windows Platform. The Hololens includes its own CPU and GPU, due to size constraints they are however not very powerful, and especially if it comes to rendering of volumetric datasets, completely underpowered.

To get around this issue, we have developed a thin, Direct3D-based client application for the Hololens that makes use of Hololens Remoting, a kind of proprietary streaming protocol developed by Microsoft[^remotingnote]. This client receives pose data from the Hololens, as well as all other parameters required to generate correct images, such as the projection matrices for each eye. This data is then forwarded to a Hololens interface within scenery, based on the regular HMD interface. Initial communication to acquire rendering parameters is done via a ZeroMQ request-reply socket, while receiving of per-frame pose data is handled with an additional, publish-subscribe socket due to better latency.

The Hololens remoting applications are usually fed by data rendered with Direct3D, which lets us immediately recognise the problem that _scenery_ can only render via OpenGL and Vulkan at the present moment. 

Fortunately, a shared memory extension for Vulkan, `NV_external_memory`, exists in the standard that enables _zero-copy_ sharing of buffer data between different graphics APIs, by using a keyed mutex. Programmatically, this is done as:

1. On the host (_scenery_) side, verify that the device supports this type of Direct3D texture for importing.
2. For each swapchain image, allocate a Direct3D shared handle texture with flag `D3D11_RESOURCE_MISC_SHARED_KEYEDMUTEX` on the side of the client application. This image will serve as the final render target to be sent to the Hololens[^sharedperfnote].
3. For each shared handle, create a Vulkan image, with memory bound to the shared handle.
4. Request access to the image via the keyed mutex, and store image data in it, e.g. via `vkCmdBlitImage`. Keyed mutex handling is done by the extension itself, via extra information attached to the appropriate `vkQueueSubmit` call. The command buffer for the blit operation needs to be recorded only once and can be reused as long the resolution does not change.

The inclusion of the keyed mutex information into the `vkQueueSubmit` call in the last step has the benefit that no additional network communication via ZeroMQ is necessary to indicate by which part of the software the shared texture is used at the moment, leading to increased performance.

[^remotingnote]: The exact details of how this works are not published, but apparently work by streaming the image data for both eyes over the network, compressed with H264.
[^sharedperfnote]: We allocate multiple image buffers and use them in a double/triple-buffering manner for read/write access to prevent the GPU stalling.

## External Hardware -- Eye Tracking

Eye tracking support is provided by ...





