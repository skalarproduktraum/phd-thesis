# Design and Architecture

After having introduced a high-level overview of scenery in the previous chapter, in this chapter, we are diving deeper into the framework, describing each of its components. We start with scenegraph-based rendering and traversal:

## Scenegraph-based rendering

A scenegraph is a data structure that organises objects in a hierarchical manner, in a tree or graph structure, where each node in the graph has its own transformation properties. In that way, it is very easy to describe spatial and organisational relations between objects, such as a car tyre belonging to a car, and the tyre moving with the parent object _car_ (inheriting its transformations), when it moves.

In general, a scenegraph can contain connections between multiple nodes. In scenery, we use a scenegraph approach that is closer to a tree representation, because that structure more easily enables parallel scene element discovery \TODO{add reference to Boudier/Kubisch GTC presentation}.

If bounding boxes are stored along with the nodes, the scenegraph can easily be extended to also include _bounding volume hierarchies_ that can enable more efficient collision detection[^collisionnote] or frustum culling[^cullingnote].



[^collisionnote]: For general collision detection without additional acceleration data structures like bounding volume hierarchies, the whole scenegraph has to be traversed for each object that is checked for collisions, leading to a $\mathcal{O}(n^2)$ complexity. In BVHs, objects are guaranteed not to overlap, if their parent bounding volumes to not overlap, which can greatly lower the candidate pool, speeding collision detection up tremendously.
[^cullingnote]: Frustum culling is the process of determining the objects that are currently in the camera's view frustum, and rendering only those. Acceleration data structures can help with determining the inside set in the same manner as in collusion detection.



### Traversal

Scenegraphs can be traversed in a variety of ways, such as depth-first traversal. In scenery, the scenegraph is traversed by default in the same way it is stored. The renderer can make further optimisations, such as drawing it in front-to-back order, where spatial sorting is applied after gathering nodes, e.g. to draw transparent objects in the correct way.

## The Nodes

Nodes are the elements of the scenegraph, and most of them are entities that can be rendered on-screen. These nodes are organised into an ordered, acyclic graph of parent-child relationships. Operations, such as mathematical transformations — such as translations, rotations, or scalings — are automatically propagated to a `Node`s `children`.  

For actually organising nodes into a scene, a special node type exists, the `Scene`. `Node`s attached to a top-level `Scene` element as `children` become the top-level elements of the scene, and can in turn have their own `children`.

As a short example, a `Scene` might contain a `Node` _Cell_, which has children _Nucleus_ and _ER_. The transformations of _Nucleus_ and _ER_ are then relative to _Cell_, and when the _Cell_ moves or rotates, so will _Nucleus_ and _ER_.

### Transforms

A `Node` can have the following transforms:

* `position` -- the position of the `Node` in 3D space
* `scale` -- scaling along the X, Y, and Z axis
* `rotation` -- a quaternion[^quatnote] describing the `Node`s orientation in space.
* `model` -- local transforms how this `Node` is positioned with respect so its parent
* `world` -- global transforms that include the `model` transform, as well as the `parent`s `world` transform

The transforms are calculated by a `Node`s `updateWorld(recursive: Boolean, force: Boolean)` routine, and stored to the `model` and `world` properties. If `recursive` is specified, the routine will descend to all children, calculate their transforms, and mark them as updated. If any of the transforms of a `Node` change during runtime, it will get its `needsUpdate` and `needsUpdateWorld` flag set, to be picked up on the next update run.

Some nodes might want to construct their own model and world matrices, overriding the behaviour of `updateWorld`: this can be achieved by setting the `wantsComposeModel` flag to `false`.

\TODO{Add scene graph figure}

[^quatnote]: Quaternions are a 4-dimensional extension of complex numbers, that can describe rotations in space. While rotations may as well be represented as matrices, such representations suffer from two problems: a) matrices cannot be smoothly interpolated and b) they may lead to _gimbal locking_, where the sine or cosine of an angle in a rotation matrix lead to a zero entry, making the transformation loose a degree of freedom — further multiplications will not be able to achieve a non-zero rotation around this axis. Quaternions do not suffer from both problems, they are however not as intuitive as other rotation representations such as Euler angles. In scenery, helper routines are provided to convert Euler angles or matrices to quaternions for user convenience.

## The Hub

The hub is the communications backbone of scenery. All of the subsystems register with a hub, and a hub can be queried for the presence of a subsystem. In this way, it is possible to also realise completely headless applications, that run logic, but do not produce any visual output, and do not take any input. It also helps to create minimal unit tests that only include the necessary subsystems for the particular test case.

Hubs can be queried by `Hub.get(e: SceneryElement)`. This routine will either return the `SceneryElement` is has been asked for, or `null` if that subsystem has not been registered.

A `SceneryElement` can be a renderer, OpenCL compute context, statistics collector, node publishers or subscribers, settings storage, and regular or natural input devices. A new `SceneryElement` may be added to a hub via the generic function `<T: Hubable> Hub.add(e: SceneryElement, obj: T)`. `add` will return the object that has been added to the hub.

## Input Handling

Input handling is done using using Tobias Pietzsch's _ui-behaviour_ library \TODO{Cite!}. This library provides a distinction of input events into `InputTriggers` and `Behaviours`. An `InputTrigger` is the related to the physical event, such as a key press, or a mouse movement/scroll/click. A `Behaviour` is the triggered action. Vanilla ui-behaviour is able to handle AWT input events. For scenery, we have extended the library to also be able to handle events originating from JOGL, GLFW, JavaFX, or headless windows. Further, custom mappings are available for buttons of hand-held controller devices, or VRPN devices.

Spatial input, such as HMD positioning and rotations, are handled by the specific implementation of a `TrackerInput`, such as an `OpenVRHMD`[^openvrnote], or a `VRPNTracker`[^vrpnnote]. Multiple of these inputs can coexist peacefully, and will not interfere with each other, but rather augment.

[^openvrnote]: OpenVR or SteamVR is a VR abstraction layer that provides rendering to various VR headsets, and access to the associated input devices. OpenVR has been developed by Valve Software, more information can be found at [github.com/ValveSoftware/OpenVR](https://github.com/ValveSoftware/OpenVR).

[^vrpnnote]: VRPN (Virtual Reality Periphery Network) is an abstraction layer that enables access to a variety of Virtual Reality-associated input devices, such as tracked stereo glasses, Wiimotes or Flysticks. See [@TaylorII:2001bq].

## The Renderers

In scenery, the contract with the renderer is a thin one: a renderer needs to:

* be able to render something (`render()` function),
* initialize a scene (`initializeScene()` function),
* take screenshots (`screenshot()` function),
* resize a (eventually existing) viewport (`reshape()` function),
* become embedded inside an existing window, e.g. from JavaFX or Swing (`embedIn` property),
* change the rendering quality (`setRenderingQuality()` function),
* toggle push mode (`pushMode` property, see [Push Mode] section),
* hold settings (`settings` property),
* hold a window (`window` property), and
* close.

This design decision was made such that scenery can support a variety of different rendering backends, after discovering that OpenGL — which scenery started with as only renderer — and Vulkan do not map well to each other. With this architecture we are more easily able to extend rendering support in the future to e.g. software renderers, or external ray tracing frameworks.

The Renderer interface in scenery is defined as:

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


A renderer may also run in its own thread, but must indicate that properly by setting `managesRenderLoop`, as e.g. done by the OpenGL renderer. In the opposite case, the renderer will run synchronous with scenery's main loop.

A renderer may store its own metadata related to a `Node` in its `metadata` field. This field is cleared upon the removal of a `Node` from the scene. The `metadata` must be uniquely named, such that renderers — which could be running in parallel — do not interfere with each other's `metadata`.

At the time of writing, scenery includes a high-performance Vulkan renderer, used by default on Windows and Linux, and an OpenGL renderer, used by default on macOS.

### Windowing Systems

On the JavaVM, the main options for drawing (to) windows and related elements are AWT, Swing, and JavaFX. Rendering to AWT and Swing is only supported by the OpenGL renderer, while both renderers support JavaFX. The Vulkan renderer by default uses GLFW to create and interact with windows, GLFW however is not compatible with AWT or Swing, because both have very similar ideas about how event handling should be done in which thread, therefore clashing about it, and leading to software instability.

JavaFX is now the predominant mode for building scenery-based applications. However, in OpenGL, buffer copies from the current framebuffer to a JavaFX texture are necessary and incur a performance penalty. With Vulkan, this problem does not exist, as Vulkan exhibits a feature called _permanently mapped buffers_\TODO{link}, which are accessible by both the host and device via DMA, and do not require copying, alleviating the pressure on the PCI express bus incurred by a copy. These PMBs then are ping-ponged for double buffering and provide a very good user and developer experience.

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

Here it should be emphasised again that Vulkan provides much leaner, close-to-metal access to the GPU's resources. It is therefore more verbose, but does not do as much validation as OpenGL during runtime.

Instead in Vulkan, a _validation layer_ provides guidance to adherance to the standard. While in OpenGL, all state and state changes are continiously checked for sanity, incurring a performance hit, Vulkan skips these checks, and outsources them to validation layers, that may be activated during startup, and usually only used during development or debugging. Compared to OpenGL error messages, Vulkan validation layers provide highly detailed error messages, thus enabling the developer to quickly pinpoint the source of a problem.

When using Vulkan, the initialisation of the renderer proceeds in the following way:

1. the presence of a virtual reality HMD is checked, and window dimensions set accordingly.
2. The `RenderConfig` is parsed from a render config YAML file.
3. The renderer checks whether the user has requested the activation of validation layers, and activates them if indicated.
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

[^instancenote]: A _Vulkan instance_ is the basic building block of a Vulkan application.
[^devicenote]: A _Vulkan device_ contains all the information about a device and its capabilities, and all allocations and executions are made with respect to a particular device, also enabling parallel runs on multiple devices.
[^queuenote]: Work, may it be rendering or compute work, is submitted to a _queue_ in Vulkan, and executed asyncronously by the GPU. A queue may be asked for work completion and can be waited on.
[^vdnote]: _Vertex descriptors_ describe the vertex layout for rendering and are somewhat comparable to OpenGL's Vertex Array Objects.

[^dslnote]: _Descriptor set layouts_ describe the memory layout of UBOs and textures in a shader, while _descriptor sets_ contain their actual realisation, and link to a physical buffer.

### Uniform Buffer Serialisation and Updates

UBOs are tentatively updated with each frame before the main rendering loop, guaranteeing that a `Node` that has been added to the scene graph will have it's transformations and properties ready at render time. 

Serialisation of a `Node`'s transformations and properties are handled by the class `UBO`. In that class, member variables of the UBO are stored as a `LinkedHashMap` of a string (for the property name), and a lambda of type `() -> Any` for the value of the property. This mechanism enables determining values of properties that change during runtime, without rewriting the contents of the map. Order in the struct does matter, which is why a linked map is being used. The actual order of the properties is determined via shader introspection. For common data types (floats, doubles, integers, shorts, booleans, vectors, and matrices), `UBO` will determine the necessary size and offset of a certain property, and write the contents of the property to a `ByteBuffer`, according to OpenGL's `std140` buffer rules.

After an `UBO` has been serialised for the first time, a hash is calculated from it's current members. Upon revisiting this `UBO`, the previous member hash is compared with the current one, to determine whether re-serialisation is necessary or not.

### Push Mode

Push Mode is a rendering optimisation especially for viewer-type applications, where continuous scene changes are not expected. In push mode, the renderer will keep track of updated UBOs and modified scene contents, and only render a frame in the following cases:

* an UBO has been updated
* an object has been added or removed from the currently visible objects
* an object that is visible has changed it's properties (e.g. uses a different material or texture now)

Buffer swaps may however still take place, so that special care is taken to update all swapchain images before stopping to actively render. This mechanism is implemented using a JDK-provided `CountDownLatch` that starts with the number of swapchain images, and is counted down by one for each render loop pass. When the latch reaches zero, rendering is discontinued until the next update happens.

The push mode mechanism also guarantees that all updates to the scene's content are obeyed, as it is not tied to e.g. input events, which might be caused by a myriad of devices, but the actual updates of scene contents or UBOs.

### Configurable Rendering Pipelines

scenery provides configurable rendering pipelines which can contain multiple passes over the scene's geometry, or postprocessing (fullscreen) passes. The renderpasses are read from a YAML file, that looks e.g. like the following one for forward shading with HDR postprocessing:

```yaml
name: Forward Shading
description: Forward Shading Pipeline, with HDR postprocessing

rendertargets:
  HDR:
    size: 1.0, 1.0
    attachments:
      HDRBuffer: RGBA_Float16
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

\TODO{add example graph}

If a DAG cannot be formed from the given definition, `RenderConfigReader` will emit an exception.

Render configs are switchable during runtime and will cause the renderer to destroy and recreate its rendering framebuffers. This mechanism is e.g. used to toggle stereo rendering during runtime.

Let's also show a more complex rendering pipeline configuration:

```yaml
name: Deferred Shading
description: Deferred Shading, with HDR postprocessing and FXAA
sRGB: true

rendertargets:
  GeometryBuffer:
    attachments:
      NormalsMaterial: RGBA_Float16
      DiffuseAlbedo: RGBA_UInt8
      ZBuffer: Depth32
  ForwardBuffer:
    attachments:
      Color: RGBA_Float16
  AOBuffer:
    size: 0.5, 0.5
    attachments:
      Occlusion: R_UInt8
  AOTemp1:
    size: 1.0, 1.0
    attachments:
      Occlusion: R_UInt8
  AOTemp2:
    size: 1.0, 1.0
    attachments:
      Occlusion: R_UInt8
  HDRBuffer:
    attachments:
      Color: RGBA_Float16
      Depth: Depth32
  FXAABuffer:
    attachments:
      Color: RGBA_UInt8

renderpasses:
  Scene:
    type: geometry
    renderTransparent: false
    renderOpaque: true
    shaders:
      - "DefaultDeferred.vert.spv"
      - "DefaultDeferred.frag.spv"
    output: GeometryBuffer
  AO:
    type: quad
    parameters:
      Pass.displayWidth: 0
      Pass.displayHeight: 0
      occlusionRadius: 1.0
      occlusionSamples: 4
      occlusionExponent: 2.0
      maxDistance: 1.0
      bias: 0.1
      algorithm: 0
    shaders:
      - "FullscreenQuadFrustum.vert.spv"
      - "HBAO.frag.spv"
    inputs:
      - GeometryBuffer
    output: AOTemp1
  AOBlurV:
    type: quad
    parameters:
      Pass.displayWidth: 0
      Pass.displayHeight: 0
      Direction: 1.0, 0.0
      Sharpness: 40.0
      KernelRadius: 8
    shaders:
      - "FullscreenQuad.vert.spv"
      - "HBAOBlur.frag.spv"
    inputs:
      - GeometryBuffer.ZBuffer
      - AOTemp1
    output: AOTemp2
  AOBlurH:
    type: quad
    parameters:
      Pass.displayWidth: 0
      Pass.displayHeight: 0
      Direction: 0.0, 1.0
      Sharpness: 40.0
      KernelRadius: 8
    shaders:
      - "FullscreenQuad.vert.spv"
      - "HBAOBlur.frag.spv"
    inputs:
      - GeometryBuffer.ZBuffer
      - AOTemp2
    output: AOBuffer
  DeferredLighting:
    type: lights
    renderTransparent: true
    renderOpaque: false
    depthWriteEnabled: false
    depthTestEnabled: false
    shaders:
      - "DeferredLighting.vert.spv"
      - "DeferredLighting.frag.spv"
    inputs:
      - GeometryBuffer
      - AOBuffer
    output: ForwardBuffer
    parameters:
      debugLights: 0
      reflectanceModel: 0
      Global.displayWidth: 0
      Global.displayHeight: 0
  ForwardShading:
    type: geometry
    renderTransparent: true
    renderOpaque: false
    blitInputs: true
    shaders:
      - "DefaultForward.vert.spv"
      - "DefaultForward.frag.spv"
    inputs:
      - ForwardBuffer.Color
      - GeometryBuffer.ZBuffer
    output: HDRBuffer
  HDR:
    type: quad
    shaders:
      - "FullscreenQuad.vert.spv"
      - "HDR.frag.spv"
    inputs:
      - HDRBuffer.Color
    output: FXAABuffer
    parameters:
      TonemappingOperator: 0
      Gamma: 1.8
      Exposure: 1.0
      WhitePoint: 11.2
  FXAA:
    type: quad
    shaders:
      - "FullscreenQuad.vert.spv"
      - "FXAA.frag.spv"
    parameters:
      activateFXAA: 1
      showEdges: 0
      lumaThreshold: 0.125
      minLumaThreshold: 0.02
      mulReduce: 0.125
      minReduce: 0.0078125
      maxSpan: 8.0
      Global.displayWidth: 0
      Global.displayHeight: 0
    inputs:
      - FXAABuffer
    output: Viewport

qualitySettings:
  Low:
    AO.occlusionSamples: 0
    FXAA.activateFXAA: 0
    AO.shaders:
      - "FullscreenQuadFrustum.vert.spv"
      - "SSAO.frag.spv"
  Medium:
    AO.occlusionSamples: 8
    FXAA.activateFXAA: 1
    AO.shaders:
      - "FullscreenQuadFrustum.vert.spv"
      - "SSAO.frag.spv"
  High:
    AO.occlusionSamples: 4
    FXAA.activateFXAA: 1
    AO.shaders:
      - "FullscreenQuadFrustum.vert.spv"
      - "HBAO.frag.spv"
  Ultra:
    AO.occlusionSamples: 8
    FXAA.activateFXAA: 1
    AO.shaders:
      - "FullscreenQuadFrustum.vert.spv"
      - "HBAO.frag.spv"
```

In this rendering pipeline configuration, we apply the following techniques \TODO{add graph}:

* Deferred Shading [@Deering:1988jd], for being able to render a large number of lights by splitting geometry processing and lighting into two separate passes: for every pixel, first, surface normals (with an efficient normal storage, where 3D unit vectors are compressed into a 2D octogon [@Zigolle:2014ase]), surface material properties, and depth are stored into separate buffers in the `Scene` pass, second, the final shading of the pixel is determined from these buffers in the `DeferredLighting` pass.
* Ambient Occlusion via the HBAO algorithm [@Bavoil:2008a61] in the `AO` pass, with horizontal and vertical blurring in the `AOBlurV` and `AOBlurH` passes,
* tone-mapping of the 16bit HDR color output of the `DeferredLighting` pass in the `HDR` pass, using the ACES tone mapping operator[^ACESnote], and
* Anti-aliasing of the final image via the Fast approximate anti-aliasing algorithm [@Lottes:200983a] in the `FXAA` pass.

This rendering pipeline configuration also showcases shader properties (see e.g. `Direction` or `Pass.displayWidth` in the `parameters` section of the `AOBlurH` pass). These are explained in more detail in the section [Shader Introspection and Shader Properties].

[^ACESnote]: ACES, the Academy Color Encoding System, defines a particular curve for mapping from HDR to LDR color, see [github.com/ampas/aces-dev/tree/v1.0.3](https://github.com/ampas/aces-dev/tree/v1.0.3) for details.

### Generic Rendering workflow

In scenery, scene object discovery (determining which objects are to be rendered), and updating the UBO's contents are done in parallel using Kotlin's coroutines.

The main rendering loop will proceed after the visible objects have been determined:

\TODO{add rendering flow diagram}
The main loop then proceeds as follows:

1. Loop through the flow of renderpasses, except Viewport pass:
	1. determine the kind of pass 	
	2. bind framebuffers for output
	3. blit contents of inputs into output framebuffer (if configured)
	4. set pass configuration and blending options
	5. iterate through scene objects (if scene pass or light pass) or draw fullscreen quad (if quad/postprocessing pass), and bind UBOs and buffers for each object as necessary
2. Run the viewport pass in the same way as (5), but siphon out data for third-party consumers (video recording, screenshots,...) if necessary
3. Swap buffers.

### Shader Introspection, Shader Properties, and Shader Parameters

scenery's renderers by default perform introspection on the shader files they ingest, by using the _spirvcrossj_[^spirvcrossjnote] library ([github.com/scenerygraphics/spirvcrossj](https://github.com/scenerygraphics/spirvcrossj)). Shader files are loaded via the `Shaders` class, which can provide both source code and SPIRV[^spirvnote] bytecode, either from file sources, or from procedurally generated shaders, and potentially other sources. `Shaders` will try to provide both versions of a shader, but can be instructed to prioritise either the source code version or the SPIRV version of the shader.

By adding the `@ShaderProperty` annotation to a member variable of a `Node`-derived class, this variable can be made accessible from the shader via the same name. Supported data types are Java's default elementary types, as well as the `GLVector` vector type and the `GLMatrix` matrix type. Additionally, the `@ShaderProperty` annotation can be added to a hash map of type `HashMap<String, Any>` to provide even more flexibility (e.g. for procedurally-generated shaders). scenery discovers shader properties in the following way:

When loading the shader, construct a list of all the properties that are part of the `ShaderProperties` UBO in the shader file, e.g. 
```glsl
layout(set = 0, binding = 0) uniform struct ShaderProperties {
  float scale;
  mat4 model;
  vec3 color;
}
```

Metadata for each member in the form of an offset and a length are stored along the with the property, and follow GLSL's std140 rules for alignment.

When updating UBOs for a `Node`, scenery performs reflection (and caches that information) on all properties that carry the `@ShaderProperty` annotation: first, properties with the given name are checked, and if not found, the `shaderProperties` hash map is consulted as fallback. Not providing a shader property in the class that is required by the shader will result in an exception. The other way around, a shader property defined in the class, but not used in the shader will only trigger a warning. Shader properties defined in the UBO, but not used in the shader will not be skipped upon serialisation.

_Shader parameters_ provide another way to hand parameters over to shader programs: These are defined in the rendering pipeline configuration, e.g. as (see [Configurable Rendering Pipelines] for full examples of such configurations):

```yaml
AO:
  type: quad
  parameters:
    Pass.displayWidth: 0
    Pass.displayHeight: 0
    occlusionRadius: 1.0
    occlusionSamples: 4
    occlusionExponent: 2.0
    maxDistance: 1.0
    bias: 0.1
    algorithm: 0
```

The shader parameters here are all the key-value pairs below `parameters`: The ones starting with `Pass` or `Global` are filled in automatically by the renderer, and are used e.g. for framebuffer sizes. All others are derived from scenery settings, and can be modified on-the-fly, enabling e.g. an easy way to switch between different algorithms in a shader, or turn  functionality in the shader on and off. The corresponding declaration in the shader file looks the following (ordering does not matter and is resolved automatically):

```glsl
layout(set = 2, binding = 0, std140) uniform ShaderParameters {
	int displayWidth;
	int displayHeight;
	float occlusionRadius;
	int occlusionSamples;
	float occlusionExponent;
  float maxDistance;
  float bias;
  int algorithm;
};
```

[^spirvcrossjnote]: _spirvcrossj_ is a wrapper of the Khronos Group's _spirv-cross_ reflection library and the _glslang_ reference compiler we have developed.
[^spirvnote]: SPIRV or SPIR-V is a binary bytecode format for shader files, specified by the Khronos Group. It serves as the primary provider of shader programs for Vulkan, but can also be used from OpenGL via vendor-specific extensions, and can be decompiled to plain GLSL or even HLSL.

### Instancing

Instancing can be done by defining a `Node`'s `instanceMaster` property as `true` and adding other `Nodes` to its `instances` property. Instances are not part of the regular scene graph for improved discovery performance, but their transformation matrices are updated in the same manner. Instanced properties can be added to the master node's `instancedProperties` hash map, and are serialised in the same manner as UBOs. As instances are not allowed to depend on each other, the serialisation is done in parallel in a number of worker threads using coroutines, such that tens of thousands of instances can be updated at interactive frame rates.

To use instancing, the user needs to provide a custom shader that declares the properties set in `instancedProperties`, e.g. as in

```glsl
layout(location = 0) in vec3 vertexPosition;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexTexCoord;
layout(location = 3) in mat4 iModelMatrix;
```
where the location 3 defines the instanced model matrix. For Vulkan, scenery will automatically derive a fitting vertex description consisting of both `VkVertexInputAttributeDescription`s and `VkVertexInputBindingDescription`s (see `VulkanRenderer::vertexDescriptionFromInstancedNode`).

## Settings store

Settings are stored...\{TODO: Actually necessary?} 

## Rendering of Volumetric Data

![Volume raycasting schematic, 1. casting a ray through the volume, 2. defining sampling points, 3. calculation of lighting at the sampling points, 4. accumulation of the lit samples into a single pixel and alpha value](./figures/raycasting.png)

Volume rendering in scenery is done via volume raycasting, where a ray for each screen pixel, originating at the camera's near plane is shot perspectively correct through the piece of volumetric data, accumulating color and alpha information along the way. The accumulation function is customisable and can be used to realise e.g. the following blending options:

* _maximum projection_ (MIP), where each voxel data point along the way is compared to the previous, and the maximum kept,
* _local maximum projection_ (LMIP), where each voxel data point along the way is compared to the previous, and the maximum kept, but only after reaching a user-defined threshold, and
* _alpha blending_, where the attenuation of light entering the volume is simulated in a physically plausible manner.

The first two of those, MIP and LMIP, are commutative in the sense that volumes superimposed on top of each other will lead to the same result, no matter in which order they are being rendered. For alpha blending, the ordering of the volumes does matter, and accurate visualisation is only possible if all the volumes occupying the same space are rendering in the same moment.

### Out-of-core rendering

Out-of-core rendering describes techniques for rendering volumetric data that does not fit into the GPU memory or main memory of a computer, and is therefore out-of-core. 

BigDataViewer[@Pietzsch:2015hl] has introduced a pyramid image file format that is now widely used. The program itself displays single slices that can be arbitrarily oriented to the user, and loads them on-the-fly from local or remote data sources.

scenery also includes support for loading these data sets, and for that makes use of a BigDataViewer-provided library. For correct blending of multiple, unregistered volumes, we make use of a custom `ShaderFactory` that creates a custom shader program for any number of volumes used (subject to hardware limitations, of course). An example of multiple volumes rendered using this technique is shown in Figure \ref{fig:sceneryBDV}.

![scenery rendering an out-of-core dataset using the BigDataViewer library.\TODO{add the actual image}\label{fig:sceneryBDV}](./figures/scenery-bdv.png)

\TODO{Add workflow diagram}

## Clustering

![A user interacting with a _Drosophila_ dataset rendered on a clustered CAVE setup with 5 machines.](./figures/scenery-cave.jpg)

scenery includes support for parallel rendering on multiple machines.

## Integration of External Hardware

### Head-mounted displays and natural/gestural user interface devices

Support for head-mounted displays and control devices is provided by two means:

1. utilising the lwjgl bindings for SteamVR/OpenVR to interface with off-the-shelf HMDs like the Oculus Rift or HTC Vive (see class `OpenVRHMD`).
2. utilising the custom-built wrappers for the VRPN[@TaylorII:2001bq], the Virtual Reality Periphery Network, library, called jVRPN ([github.com/scenerygraphics/jvrpn](https://github.com/scenerygraphics/jvrpn)). jVRPN is used in scenery to e.g. provide support for DTrack devices used in CAVE systems (see class `TrackedStereoGlasses`).

HMDs usually implement the `Display` interface:
```
interface Display {
    fun getEyeProjection(eye: Int, nearPlane: Float = 1.0f, farPlane: Float = 1000.0f): GLMatrix
    fun getIPD(): Float
    fun hasCompositor(): Boolean
    fun submitToCompositor(textureId: Int)
    fun submitToCompositorVulkan(width: Int, height: Int, format: Int,
                                 instance: VkInstance, device: VulkanDevice,
                                 queue: VkQueue,
                                 image: Long)
    fun getRenderTargetSize(): GLVector
    fun initializedAndWorking(): Boolean
    fun update()
    fun getVulkanInstanceExtensions(): List<String>
    fun getVulkanDeviceExtensions(physicalDevice: VkPhysicalDevice): List<String>
    fun getWorkingDisplay(): Display?
    fun getHeadToEyeTransform(eye: Int): GLMatrix
}
```

This interface provides submission to both OpenGL and Vulkan renderers, which is necessary as they work quite differently. The `update` function is used to update HMD state once per frame, while transformations are cached as much as possible. The renderer will only render to the device if `initializedAndWorking()` returns `true`, and `getWorkingDisplay()` returns a `Display` instance. HMDs can choose to have a compositor to which the resulting renderered image is submitted. If this is not the case, e.g. as it is with tracked stereo glasses for CAVEs, the image is rendered regularly.

An HMD might also provide tracking information, in which case it will also implement the `TrackerInput` interface:

```
interface TrackerInput {
   
    fun getOrientation(): Quaternion
    fun getOrientation(id: String): Quaternion
    fun getPosition(): GLVector
    fun getPose(): GLMatrix
    fun getPoseForEye(eye: Int): GLMatrix
    fun initializedAndWorking(): Boolean
    fun update()
    fun getWorkingTracker(): TrackerInput?
    fun loadModelForMesh(device: TrackedDevice, mesh: Mesh): Mesh
    fun loadModelForMesh(type: TrackedDeviceType = TrackedDeviceType.Controller, mesh: Mesh): Mesh
    fun attachToNode(device: TrackedDevice, node: Node, camera: Camera? = null)
    fun getTrackedDevices(ofType: TrackedDeviceType): Map<String, TrackedDevice>
}
```

In this interface, the noteworthy functions are `getPoseForEye()`, which returns a transformation matrix relative to the origin containing translational and rotational information per-eye. Furthermore, an HMD may provide multiple tracked devices, such as nunchucks, which can be queried via `getTrackedDevices()`. `attachToNode()` then facilitates their attachment to any `Node` in the scene graph, which subsequently inherits the transformations of the tracked device. A model for such a device may be provided by the HMD via `loadModelForMesh()`. Our implementation of SteamVR HMDs provides the correct mesh for a given HMD via this function.


### Augmented Reality and the Hololens

_scenery_ also includes support for the Microsoft Hololens, a stand-alone, untethered augmented reality headset, based on the Universal Windows Platform (see class `Hololens`). The Hololens includes its own CPU and GPU, due to size constraints they are however not very powerful, and especially if it comes to rendering of volumetric datasets, completely underpowered.

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

### Eye Tracking

scenery includes support for the Pupil Labs eye tracking solution[@Kassner:2014kh]([www.pupil-labs.com](https://www.pupil-labs.com)), implemented in the class `PupilEyeTracker`. This class communicates with the Pupil Labs software _Pupil Capture_ or _Pupil Service_ via ZeroMQ, with msgpack data serialisation. Our implementation provides HMD-based screen-space and world-space calibration, reporting of the gaze positions, normals, timestamps, and confidences.

For calibration, the user is presented with a series of points to look at, which serve to establish a connection between the eye tracker's captured direction of gaze with a screen-space or world-space position in the scene. For each calibration point, 80 different samples are taken to account for microsaccades, and the first 20 are discarded to exclude those samples that might still include eye movement, while the user is moving from one point to the next. After finishing the calibration, the user is informed of successful or unsuccessful calibration, and can repeat the calibration, if necessary.

After successful calibration, scenery enables the developer to connect the outputs of the eye tracker (in the form of gaze normals, gaze positions, and a confidence rating) to the properties of any object. By default, gaze points are only output in case the confidence reaches more than 90%, leaving the decision which of the higher-confidence samples to use to the developer.

More details about eye tracking can be found in the chapter [Eye Tracking and Gaze-based Interaction], with a use case implemented in the chapter [Attentive Tracking].




