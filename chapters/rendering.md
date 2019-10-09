# Rendering

After having introduced a high-level overview of scenery in the previous chapter, in this chapter, we are diving deeper into the framework, describing each of its components. We start with scenegraph-based rendering and traversal:

## Scenegraph-based rendering

A scenegraph is a data structure that organises objects in a hierarchical manner, in a tree or graph structure, where each node in the graph has its own transformation properties. In that way, it is very easy to describe spatial and organisational relations between objects, such as a car tyre belonging to a car, and the tyre moving with the parent object _car_ (inheriting its transformations), when it moves.

In general, a scenegraph can contain connections between multiple nodes. In scenery, we use a scenegraph approach that is closer to a tree representation, because that structure more easily enables parallel scene element discovery [@boudier2015].

If bounding boxes are stored along with the nodes, the scenegraph can easily be extended to also include _bounding volume hierarchies_ that can enable more efficient collision detection[^collisionnote] or frustum culling[^cullingnote].



[^collisionnote]: For general collision detection without additional acceleration data structures like bounding volume hierarchies, the whole scenegraph has to be traversed for each object that is checked for collisions, leading to a $\mathcal{O}(n^2)$ complexity. In BVHs, objects are guaranteed not to overlap, if their parent bounding volumes to not overlap, which can greatly lower the candidate pool, speeding collision detection up tremendously.
[^cullingnote]: Frustum culling is the process of determining the objects that are currently in the camera's view frustum, and rendering only those. Acceleration data structures can help with determining the inside set in the same manner as in collusion detection.


### Traversal

Scenegraphs can be traversed in a variety of ways, such as depth-first traversal. Depth-first traversal is also used by default in scenery. The renderer can make further optimisations, such as drawing it in front-to-back order, where spatial sorting is applied after gathering nodes, e.g. to draw transparent objects in the correct way.

The exception to normal scenegraph traversal is _instancing_ (described in detail in [Instancing]), where copies of a node are not added as children, but to the special `instances` property as performance optimisation. See the section on instancing for details.

### The Nodes

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

[^quatnote]: Quaternions are a 4-dimensional extension of complex numbers, that can describe rotations in space. While rotations may as well be represented as matrices, such representations suffer from two problems: a) matrices cannot be smoothly interpolated and b) they may lead to _gimbal locking_, where the sine or cosine of an angle in a rotation matrix lead to a zero entry, making the transformation loose a degree of freedom — further multiplications will not be able to achieve a non-zero rotation around this axis. Quaternions do not suffer from both problems, they are however not as intuitive as other rotation representations such as Euler angles. In scenery, helper routines are provided to convert Euler angles or matrices to quaternions for user convenience.


## The Rendering Procedure in scenery

In scenery, the contract with the renderer is thin. A renderer needs to:

* be able to render something (`render()` function),
* initialize a scene (`initializeScene()` function),
* take screenshots (`screenshot()` function),
* resize a (eventually existing) viewport (`reshape()` function),
* become embedded inside an existing window, e.g. from JavaFX or Swing (`embedIn` property),
* change the rendering quality (`setRenderingQuality()` function),
* toggle push mode (`pushMode` property, also see [Push Mode]),
* hold settings (`settings` property),
* hold a window (`window` property), and
* close itself.

This design decision was made such that scenery can support a variety of different rendering backends, after discovering that OpenGL — which scenery started with as only renderer — and Vulkan do not map well to each other. With this architecture we are more easily able to extend rendering support in the future to e.g. software renderers, or external ray tracing frameworks.

The Renderer interface in scenery is defined as:

\begin{lstlisting}[language=Kotlin, caption=Renderer interface definition.\label{lst:RendererInterface}]
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

    // more functions follow here
    ...
}
\end{lstlisting}


A renderer may also run in its own thread, but must indicate that properly by setting `managesRenderLoop`, as e.g. done by the OpenGL renderer. Otherwise, the renderer will run synchronous with scenery's main loop.

A renderer may store its own metadata related to a `Node` in its `metadata` field. This field is cleared upon the removal of a `Node` from the scene. The `metadata` must be uniquely named, such that renderers — which could be running in parallel — do not interfere with each other's `metadata`.

At the time of writing, scenery includes a high-performance Vulkan renderer, used by default on Windows and Linux, and an OpenGL renderer, used by default on macOS.

### Windowing Systems

On the Java VM, the main options for drawing (to) windows and related elements are AWT, Swing, and JavaFX. In scenery, the currently supported mode for embedding into existing windows is Swing, which is supported by both the OpenGLRenderer and the VulkanRenderer. 

In development, we had originally started out with using JavaFX, the most modern UI toolkit for the Java VM. JavaFX however has the problem that it works entirely GPU-based, but unfortunately does not allow the developer to directly access GPU resources, keeping them hidden and inaccessible. The consequence: Images already generated on the GPU have to be transferred to main memory, and are then again uploaded to the GPU as a texture by JavaFX's internal mechanisms. As bandwidth is usually a limited resource, this leads to severe performance issues, especially when rendering at higher resolutions beyond full HD (1920x1080). Recently, a new project named _DriftFX_ [^DriftFXNote] appeared, which aims to solve this issue by introducing operating system-native OpenGL rendering surfaces into JavaFX, circumventing the double-transfer issue just described. Our hope is we can harness this project in the future, and eventually extend it to support Vulkan as well.

[^DriftFXNote]: The DriftFX project ([github.com/eclipse-efx/efxclipse-drift/](https://github.com/eclipse-efx/efxclipse-drift/)) provides an extension for JavaFX to allow direct use of OpenGL. As this project appeared only very recently, we have not yet evaluated it.

### Uniform Buffer Serialisation and Updates

Uniforms are properties that are communicated to the shader program, and are very similar to C-style structs. Before the advent of OpenGL 4.x and Vulkan, single uniform variables had to be stored and updated individually, leading to a large API overhead. Since OpenGL 4.x and Vulkan, Uniform Buffer Objects (UBOs) are available — instead of storing and updating single uniforms, UBOs are buffers of uniforms, which are updated together, and sent to the GPU. In contrast to single uniforms, this provides two main benefits:

* less API overhead by being able to serialise many uniforms into a single buffer, and uploading them to the GPU in one API call, and
* multiple-rate updates of different UBOs — before, uniforms had to be set every time they were used in a shader, now they can be updated only when needed, and for different UBOs, this can mean different update rates, further reducing the original overhead.

In scenery, UBOs belonging to a Node are tentatively updated with each frame before the main rendering loop, guaranteeing that a `Node` that has been added to the scene graph will have its transformations and properties ready at render time. 

Serialisation of a `Node`'s transformations and properties are handled by the class `UBO`. In that class, member variables of the UBO are stored as a `LinkedHashMap` of a string (for the property name), and a lambda of type `() -> Any` for the value of the property. This mechanism enables determining values of properties that change during runtime, without rewriting the contents of the map. Order in the struct does matter, which is why a linked map is being used. The actual order of the properties is determined via shader introspection. For common data types (floats, doubles, integers, shorts, booleans, vectors, and matrices), `UBO` will determine the necessary size and offset of a certain property, and write the contents of the property to a `ByteBuffer`, according to OpenGL's and Vulkan's `std140` buffer rules, storing data in the same memory layout as C-style structs.

After an UBO has been serialised for the first time, a hash is calculated from its current members. Upon revisiting this `UBO`, the previous member hash is compared with the current one, to determine whether re-serialisation is necessary or not. In case re-serialisation is not necessary, the buffer backing the UBO will remain untouched and continued to be used in that state. If it needs to be re-serialised, it will also be re-uploaded to the GPU.

### Push Mode

Push Mode is a rendering optimisation especially for viewer-type applications, where continuous scene changes are not expected. In push mode, the renderer will keep track of updated UBOs (as described in [Uniform Buffer Serialisation and Updates]) and modified scene contents, and only render a frame in the following cases:

* an UBO has been updated,
* an object has been added or removed from the currently visible objects, or
* an object that is visible has changed it's properties (e.g. uses a different material or texture now)

Buffer swaps may however still take place, so that special care is taken to update all swapchain images before stopping to actively render. This mechanism is implemented using a JDK-provided `CountDownLatch` that starts with the number of swapchain images, and is counted down by one for each render loop pass. When the latch reaches zero, rendering is discontinued until the next update happens.

The push mode mechanism also guarantees that all updates to the scene's content are obeyed, as it is not tied to e.g. input events, which might be caused by a myriad of devices, but the actual updates of scene contents or UBOs.

### Configurable Rendering Pipelines

scenery provides configurable rendering pipelines which can contain multiple passes over the scene's geometry, or postprocessing (fullscreen) passes. 

The renderpasses are read from a YAML file. A simple example for a forward shading pipeline with HDR postprocessing can be seen in Listing \ref{lst:SimpleForwardShading}: In this simple pipeline, the scene contents are rendered in a single pass into the 16bit RGBA floating point rendertarget HDR (line 5) by the `Scene` rendering pass (line 11). The HDR postprocessing is done in the `PostprocessHDR` pass (line 18), which outputs to the viewport.

\begin{lstlisting}[language=YAML, caption={Simple forward shading rendering pipeline definition.}, label=lst:SimpleForwardShading]
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
\end{lstlisting}

In the render config file, both _rendertargets_ and _renderpasses_ are defined. A _rendertarget_ consists of a framebuffer name, a framebuffer size, and a set of attachments of the framebuffer that can have different data types. A _renderpass_ consists of a pass name, a type -- geometry or quad (for postprocessing) --, a set of default shaders, and defined _inputs_ and _outputs_. The renderpass may also define a set of _shader parameters_, which are handed over to the shader via the `UBO` mechanism, and supports all the data types supported by `UBO`.

The definition must contain one renderpass that outputs to Viewport, otherwise nothing will be rendered.

From the definition in the YAML file, `RenderConfigReader` will try to form a directed acyclic graph (DAG). The resulting graph for the forward shading example in Listing \ref{lst:SimpleForwardShading} is shown in Figure \ref{fig:SimpleRenderpipelineGraph}.

\begin{figure}
    \includegraphics{RenderpipelineExampleSimple.pdf}
    \caption{The graph representation of the ForwardShading rendering pipeline. Scene passes are shown with red background, postprocessing passes with orange background. Light blue parallelograms are framebuffers. Solid black arrows signify transition from one pass to the next, grey arrows show data dependencies, with squares standing for writes, and circles for reads. Dotted arrows show scenegraph accesses.\label{fig:SimpleRenderpipelineGraph}}
\end{figure}

If a DAG cannot be formed from the given definition, `RenderConfigReader` will emit an exception.

Render configs are switchable during runtime and switching will cause the renderer to destroy and recreate its rendering framebuffers — while all other loaded textures and resources are preserved. This mechanism is e.g. used to toggle stereo rendering during runtime, and can facilitate rapid prototyping. In addition, the renderer can watch used shader files actively for changes, try to compile them, and, if compilation and linking is successful, replace them on-the-fly. To toggle this behaviour, `Renderer.watchShaders()` can be called.

\begin{fullwidth}
\begin{lstlisting}[language=YAML, caption={Deferred Shading rendering pipeline definition, with forward shading for transparent geometry as separate step, HDR, and FXAA antialiasing as postprocessing steps.}, label=lst:DeferredShadingPipeline, multicols=2]
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
\end{lstlisting}
\end{fullwidth}

A more complex rendering pipeline definition is shown in Listing \ref{lst:DeferredShadingPipeline}. In this rendering pipeline configuration, we apply the following techniques:

* Deferred Shading [@Deering:1988jd], for being able to render a large number of lights by splitting geometry processing and lighting into two separate passes: for every pixel, first, surface normals (with an efficient normal storage, where 3D unit vectors are compressed into a 2D octogon [@Zigolle:2014ase]), surface material properties, and depth are stored into separate buffers in the `Scene` pass (line 35), second, the final shading of the pixel is determined from these buffers in the `DeferredLighting` pass (line 90).
* Ambient Occlusion via the HBAO algorithm [@Bavoil:2008a61] in the `AO` pass, with horizontal and vertical blurring in the `AOBlurV` and `AOBlurH` passes (lines 43, 60, and 75),
* tone-mapping of the 16bit HDR color output of the `DeferredLighting` pass in the `HDR` pass, using the ACES tone mapping operator[^ACESnote] (line 120), and
* Anti-aliasing of the final image via the Fast approximate anti-aliasing algorithm [@Lottes:200983a] in the `FXAA` pass (line 130).

This rendering pipeline configuration also showcases shader properties (see e.g. `Direction` or `Pass.displayWidth` in the `parameters` section of the `AOBlurH` pass). These are explained in more detail in the section [Shader Introspection and Shader Properties].

This more complex rendering pipeline can also be represented as a graph, as shown in Figure \ref{fig:DeferredShadingRenderpipelineGraph}. 

\begin{figure*}
    \includegraphics{RenderpipelineExampleDeferredShading.pdf}
    \caption{The graph representation of the DeferredShading rendering pipeline. Scene passes are shown with red background, postprocessing passes with orange background. Light blue parallelograms are framebuffers. Solid black arrows signify transition from one pass to the next, grey arrows show data dependencies, with squares standing for writes, and circles for reads. Dotted arrows show scenegraph accesses.\label{fig:DeferredShadingRenderpipelineGraph}}
\end{figure*}

[^ACESnote]: ACES, the Academy Color Encoding System, defines a particular curve for mapping from HDR to LDR color, see [github.com/ampas/aces-dev/tree/v1.0.3](https://github.com/ampas/aces-dev/tree/v1.0.3) for details.

### General Rendering workflow

In scenery, scene object discovery (determining which objects are to be rendered), and updating the UBO's contents are done in parallel using Kotlin's coroutines.

The main rendering loop will proceed after the visible objects have been determined:

The main loop then proceeds as follows:

1. Loop through the flow of renderpasses, except Viewport pass:
	a. determine the kind of pass 	
	b. bind framebuffers for output
	c. blit contents of inputs into output framebuffer (if configured)
	d. set pass configuration and blending options
	e. iterate through scene objects (if scene pass or light pass) or draw fullscreen quad (if quad/postprocessing pass), and bind UBOs and buffers for each object as necessary
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

Instancing can be done by defining a `Node`'s `instanceMaster` property as `true` and adding other `Nodes` to its `instances` property. Instances are not part of the regular scene graph for improved discovery performance, but their transformation matrices are updated in the same manner. Instanced properties can be added to the master node's `instancedProperties` hash map, and are serialised in the same manner as UBOs. As instances are not allowed to depend on each other, the serialisation is done in parallel in a number of worker threads using coroutines, such that hundreds of thousands of instances can be updated at interactive frame rates.

To use instancing, the user needs to provide a custom shader that declares the properties set in `instancedProperties`, e.g. as in

```glsl
layout(location = 0) in vec3 vertexPosition;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 vertexTexCoord;
layout(location = 3) in mat4 iModelMatrix;
```
where the location 3 defines the instanced model matrix. For both Vulkan and OpenGL, scenery will automatically derive a fitting vertex description.

It is important to note here that a matrix occupies more than a single vertex input, such that the next available location after the 4x4 matrix `iModelMatrix` would be location 7.

## Rendering of Volumetric Data

![Volume raycasting schematic, 1. casting a ray through the volume, 2. defining sampling points, 3. calculation of lighting at the sampling points, 4. accumulation of the lit samples into a single pixel and alpha value](raycasting.png)

Volume rendering in scenery is done via volume raycasting, where a ray for each screen pixel, originating at the camera's near plane is shot perspectively correct through the piece of volumetric data, accumulating color and alpha information along the way. The accumulation function is customisable and can be used to realise e.g. the following compositing options:

* _maximum intensity projection_ (MIP), where each voxel data point along the way is compared to the previous, and the maximum kept,
* _local maximum intensity projection_ (LMIP), where each voxel data point along the way is compared to the previous, and the maximum kept, but only after reaching a user-defined threshold, and
* _alpha blending_, where the attenuation of light entering the volume is simulated in a physically plausible manner.

The first two of those, MIP and LMIP, are commutative in the sense that volumes superimposed on top of each other will lead to the same result, no matter in which order they are being rendered. 

For alpha blending, the ordering of the volumes does matter, and accurate visualisation is only possible if all the volumes occupying the same space are rendering in the same moment. Alpha blending is based on a physical model, and in the next subsection we are going to derive the front-to-back compositing equations used in scenery, and then discuss options going beyond alpha compositing for added realism:

### Alpha compositing

In general, the total spectral radiance $L_0(\vec{p}, \vec{v})$ — the quantity rendering determines for a pixel — at a point $\vec{p}$ in direction $\vec{v}$ is given by the rendering equation [@Kajiya:1986tre], where $\vec{l}$ is the light direction, and $\vec{n}$ the surface normal:

\begin{align}
L_0(\vec{p}, \vec{v}) & = \textcolor{ForestGreen}{L_e(\vec{p}, \vec{v})} \\ 
& + \textcolor{Cerulean}{\int_{l \in \Omega} \mathrm{d}\vec{l} L_0(r(\vec{p}, \vec{l}, -\vec{l}) (\vec{n}\cdot\vec{l})^{+}},
\end{align}
or, 

\begin{align*}
\text{Spectral radiance at}\,\vec{p} \text{ in direction } \vec{v} & = \textcolor{ForestGreen}{\text{Emission at}\, \vec{p} \text{ in direction } \vec{v}}\\
& + \textcolor{Cerulean}{\text{Reflected radiance from hemisphere}\,\Omega}.
\end{align*}

As this integral is recursive — the reflected radiance at a given point $\vec{l}$ depends on previous surface bounces subject to the same integral — it is in general very hard to solve accurately. For this reason, [@Sabella:1984ara] introduces an extension and simplification of the rendering equation for volumetric data: In this volumetric rendering equation, we compute $L(x)$, which is the spectral radiance at a point $x$ along a ray, ignoring previous surface bounces:

\begin{align}
L(x) = \int_{x}^{y} \mathrm{d}x' \epsilon(x')\exp\left( -\int_{x}^{x'}\mathrm{d}x'' \tau(x'') \right).
\label{eq:VolumeRenderingEquation}
\end{align}

The spectral radiance here depends on $\epsilon(x')$, the emission, and $\tau(x')$, the absorption function, describing the probability of absorbing a photon along unit distance on the ray. Note here that this emission-absorption model completely ignores scattering.

Eq. \ref{eq:VolumeRenderingEquation} can be discretised as Riemann sum,

\begin{align}
L(x) & = \sum_{i} \epsilon_{i} \Delta x\cdot \exp \left( -\sum_{j}^{i-1}\tau_{j} \Delta x \right)\\
 & =  \sum_{i} \epsilon_{i} \Delta x\cdot \prod_{j=0}^{i-1}\exp \left( -\tau_{j} \Delta x \right).
\end{align}.

This discretisation gives natural rise to interpretations of  color (pre-multiplied by the alpha value), and opacity:

\begin{align}
\alpha_i C_i &= \epsilon_i \Delta x \,\,\text{(color)}\\
\alpha_i &= 1 - \exp\left( \tau_i \Delta x \right)\,\,\text{(alpha)}.
\end{align}

With these equations, we can then derive the front-to-back compositing formula for alpha blending: Let $T_{s}^{s'}$ be the composite transparency of front-to-back samples $s, s+1,…,s'$,

\begin{align}
T_{s}^{s'} &= \prod_{i=s}^{s'}T_i,\,\,\text{then},\\
C_s &= \alpha_s C_s\\
T_s &= 1-\alpha_s,\,\,\text{and}\\
C_{s}^{s'+1} & = C_s^{s'} + \alpha_{s'+1}C_{s'+1}T_s^{s'}\\
T_{s}^{s'+1} & = \left( 1 - \alpha_{s'+1} \right) T_s^{s'}.
\end{align}

\begin{marginfigure}
    \includegraphics{sciview-alphacompositing.png}
    \caption{A volume rendered in scenery using alpha compositing, showing the Game of Life in 3D with volumetric ambient occlusion.\label{fig:alphacompositing}}
\end{marginfigure}

Front-to-back compositing has the benefit that cast rays can be terminated early once $T_{s}^{s'}$ falls below a given threshold (or 0).

An example of an alpha-composited volume rendering is shown in Figure \ref{fig:alphacompositing}.

### Out-of-core rendering

Out-of-core (OOC) rendering describes techniques for rendering volumetric data that does not fit into the GPU memory or main memory of a computer, and is therefore out-of-core. 

BigDataViewer[@Pietzsch:2015hl] has introduced a HDF5[@hdf52017]-based pyramid image file format that is now widely used. The program itself displays single slices that can be arbitrarily oriented to the user, and loads them on-the-fly from local or remote data sources (see Figure \ref{fig:bdvDrosophila} for an example).

\begin{marginfigure}
    \label{fig:bdvDrosophila}
    \includegraphics{bdv.png}
    \caption{A \emph{Drosophila} dataset rendered by-slice in BigDataViewer. Image courtesy of Tobias Pietzsch.}
\end{marginfigure}

scenery also includes support for loading these data sets, and for that makes use of a BigDataViewer-provided library. An example of multiple volumes rendered using this technique is shown in Figure \ref{fig:sceneryBDV}.

![scenery rendering an out-of-core, multiview _Drosophila_ dataset consisting of three different views (color-coded) using the BigDataViewer integration. volume rendering using maximum intensity projection. On the left-hand side, the transfer function has been adjusted to make boundaries between the different subvolumes visible more clearly. \label{fig:sceneryBDV}](ooc-drosophila.png)

Volumetric data for out-of-core rendering is stored in tiles of up to $2^{31}$ voxels. Tiles are addressed with 64bit, leading to a theoretical maximum data size of $2^{94}$ voxels, or about 20000 Yottabyte. Tiles are stored in a GPU cache. The cache is organised into small, uniformly-sized blocks storing a particular tile of the volume in the resolution pyramid. All tiles are padded by one voxel to avoid bleeding artifacts. To render a particular view of a volume, we determine the base resolution, such that the screen resolution is matched for the voxel closest to the observer. We then prepare a 3D lookup texture (LUT) where each voxel corresponds to a volume block at base resolution. Each voxel in the LUT stores the coordinates of a tile in the in cache, as well as the resolution level relative to the base level, encoded as RGBA quadruple. For each visible volume tile, we determine the ideal resolution by the distance to the observer. 

If a tile requested is already present in the cache, we encode its coordinates in the corresponding LUT voxel. Should a tile not yet be present in the cache, we enqueue the missing block for asynchronous loading through the cache layer of BigDataViewer. Recently-loaded blocks are inserted into the cache texture. The cache has least-recently used (LRU) behaviour, such that the oldest tiles are the first ones to be replaced. Missing blocks are substituted by lower-resolution data while not yet available.

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/OutOfCoreRendering.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video demo of out-of-core volume rendering in scenery. For a list of supplementary videos see \href{https://ulrik.is/writing/a-thesis}{https://ulrik.is/writing/a-thesis}.
\end{marginfigure}

When the LUT is prepared, volume rendering proceeds by raycasting, while adapting the step size along the ray depending on distance to the observer. The correct coordinates for each voxel are determined by scaling its coordinate down to coincide with the voxel in the LUT. Nearest-neighbour sampling from the LUT then yields a block offset and scale in the cache texture. The final voxel value is then sampled from the cache texture, after reversing the scaling and translation operations. 

This approach enables to render multiple volumes simultaneously, by adding additional LUTs for each volume. Non-out-of-core volumes can be rendered as well, such then do not require additional LUTs.

To produce the correct shader for multiple volumes, which can also change in number, we make use of a custom `ShaderFactory` that can ingest the shader code generated by BigVolumeViewer, and transform it to scenery's conventions. ShaderFactories are created for a particular number of volumes, e.g., 3 out-of-core (OOC) volumes, mixed with 2 regular ones, and cached up to a count of 8 factories. A sketch of the workflow is shown in Figure \ref{fig:sceneryBVV}.

\begin{figure*}
    \includegraphics{outofcore-workflow.pdf}
    \caption{Workflow for translating between BigVolumeViewer and scenery. \label{fig:sceneryBVV}}
\end{figure*}

## Rendering with OpenGL

In this section, we will introduce how a scene is rendered with OpenGL, to compare it with Vulkan lateron. 

### Initialisation

When using OpenGL, the initialisation of the renderer proceeds in the following way:

1. the presence of a virtual reality HMD is checked.
2. the `RenderConfig` is parsed from a file.
2. it is checked whether the renderer will be embedded in a `SceneryPanel` for rendering with JavaFX, or if a drawable surface already exists. If both are not the case, a window owned by the renderer is created. After this, a separate animator thread takes over the initialisation.
3. an OpenGL 4.1 context is initialised. 
4. a default set of buffers is initialised for:
	* Uniform Buffer Objects (UBOs)
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
6. the renderer checks whether the `Node`'s definition includes any `@ShaderProperty` annotations, for which an additional UBO would be created (see [Uniform Buffer Serialisation and Updates] for details). 
7. The `Node` is marked as initialised and unlocked.

[^vbonote]: Vertex Buffer Objects are the buffers on the GPU that actually contain the vertices of a Node's geometry. In scenery, they are stored in a strided format, meaning that vertices and normals are not stored as `V1V2V3N1N2N3...`, but rather as `V1N1V2N2V3N3`, for improved cache locality.
[^vaonote]: Vertex Array Objects describe which buffers a rendered object in OpenGL uses, and what the data layouts of these buffers are.

### Rendering

## Rendering with Vulkan

After having introduced the rendering steps in OpenGL, in this section we do the same for the newer, high-performance Vulkan API.

### Initialisation

Compared to OpenGL, Vulkan provides much leaner, close-to-metal access to the GPU's resources. It is therefore more verbose, but does not do as much validation as OpenGL during runtime.

Instead in Vulkan, a _validation layer_ provides guidance to adherence to the standard. While in OpenGL, all state and state changes are continuously checked for sanity, incurring a performance hit, Vulkan skips these checks, and outsources them to validation layers, that may be activated during startup, and usually only used during development or debugging. Compared to OpenGL error messages, Vulkan validation layers provide highly detailed error messages, thus enabling the developer to quickly pinpoint the source of a problem.

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
13. a dynamically-managed memory pool for `Node` geometry is allocated.

Note here that the Vulkan renderer does not perform explicit scene initialisation on startup, but discovers the `Node`s of a scene during the rendering loop.

[^instancenote]: A _Vulkan instance_ is the basic building block of a Vulkan application.
[^devicenote]: A _Vulkan device_ contains all the information about a device and its capabilities, and all allocations and executions are made with respect to a particular device, also enabling parallel runs on multiple devices.
[^queuenote]: Work, may it be rendering or compute work, is submitted to a _queue_ in Vulkan, and executed asynchronously by the GPU. A queue may be asked for work completion and can be waited on.
[^vdnote]: _Vertex descriptors_ describe the vertex layout for rendering and are somewhat comparable to OpenGL's Vertex Array Objects.

[^dslnote]: _Descriptor set layouts_ describe the memory layout of UBOs and textures in a shader, while _descriptor sets_ contain their actual realisation, and link to a physical buffer.

### Rendering

## Performance

The Java Virtual Machine is quite an unorthodox choice for realtime rendering. One reason might be that the JVM is still perceived as slow, especially when compared to close-to-metal languages like C or C++.

In this section, we compare performance of matrix multiplications on the Java VM with native code. Matrix multiplications in our context are particularly representative, as they occur in large amounts when doing scene graph traversals, in order to compute node positioning, scaling, and rotation in space.

At the end of this section, we additionally compare the performance of the OpenGL and Vulkan renderers with each other.

### Performance of Matrix multiplications on the Java Virtual Machine

_The code for the performance comparison can be found at [github.com/skalarproduktraum/java-autovectorisation-test](https://github.com/skalarproduktraum/java-autovectorisation-test)_


Recent studies in the _Computer Languages Benchmark Game_[^BenchmarkGameNote], which benchmarks different languages in scenarios such as computing Mandelbrot sets or n-body simulations, have shown that the performance of JVM-based software is on par with other VM-based languages (such as C# or Julia), or even Intel Fortran, and does not lag behind C/C++ much — usually a factor of two (see also Figure \ref{fig:PerfComparison}, benchmarking with "toy example" should however always be taken with a grain of salt, as real-world performance may be influenced by a variety of other factors).

![Comparison of different languages with the _Computer Languages Benchmark Game_, as of August 2019. Figure from [benchmarksgame-team.pages.debian.net/benchmarksgame/which-programs-are-fastest.html](https://benchmarksgame-team.pages.debian.net/benchmarksgame/which-programs-are-fastest.html).\label{fig:PerfComparison}](fastest-08-2019.pdf)

[^BenchmarkGameNote]: See [benchmarksgame-team.pages.debian.net/benchmarksgame/](https://benchmarksgame-team.pages.debian.net/benchmarksgame/).

High-performing code on the JVM is usually written by understanding what optimisations the JVM does in which case, and not trying to outsmart the JVM. For parts of the code the JVM determines as performance hotspots, the bytecode is taken and compiled to native code _just-in-time_, usually leading to near-native performance. In this subsection, we will investigate a specific performance case, namely matrix multiplications. For any transformations in 3D, matrix multiplications play a crucial role, and are often executed thousands of times per second for a moderately complex scene.

For our comparison, we consider three different ways to do matrix multiplications, defined as $C_{ij} = \sum_{k} A_{ik} B_{kj}$:

* _loop-based_, where the two sums are implemented as loops over the floating-point numbers stored in float arrays,
* _loop-based with FMA_, where the two sums are implemented as loops over the floating-point numbers stored in float arrays, and the summation is done by the FMA (fused multiply-add) instruction, which executes a $a \cdot b + c$ operation in one CPU cycle (supported since Java 9), and
* _unrolled loop-based_, where the loops in the first two cases has been unrolled by hand.

\begin{figure*}
    \includegraphics{MM_fma.pdf}
    \caption{Generated assembly for the loop-based matrix multiplication with FMA, ran on JDK 9.0.4, macOS 10.12.6, Intel Core i7-4980HQ CPU @ 2.80GHz.\label{fig:MMfma}}
\end{figure*}

By using the _hsdis_ utility of the Java Development Kit, it is possible to glimpse into the assembly code that gets generated by the JVM, after passing the flags `-XX:+UnlockDiagnosticVMOptions -XX:+PrintAssembly` to the JVM on startup.

In the loop case, we arrive at very inefficient assembly containing a lot of jumps, but also AVX512 SIMD (single instruction, multiple data) instructions mixed with SSE SIMD instructions — although they are only scalar operations, while ideally they'd be vectorised. In addition, the mixing of AVX and SSE registers incurs a performance penalty (the assembly is not shown here due to its length). In contrast, the FMA-based and unrolled loop version (see Figures \ref{fig:MMfma} and \ref{fig:MMunrolled}) yield better assembly code with less jumps, and more AVX512 commands, leading to less CPU cycles needed for the matrix multiplication. The AVX512 commands however operate only on the 128bit SSE registers (`xmm0-15`), while for optimal performance they should use the 512bit AVX512 registers `zmm0-31`, or at least the 256bit AVX registers `ymm0-15`.

\begin{figure*}
    \includegraphics{MM_unrolled_loop.pdf}
    \caption{Generated assembly for the loop-unrolling matrix multiplication, ran on JDK 9.0.4, macOS 10.12.6, Intel Core i7-4980HQ CPU @ 2.80GHz.\label{fig:MMunrolled}}
\end{figure*}

The following table shows the results for the different routines for matrix multiplications, with the benchmarks run on JDK 9.0.4, macOS 10.12.6, Intel Core i7-4980HQ CPU @ 2.80GHz using the Java Microbenchmarking Harness (timings given are averaged over 10 iterations, with 5 iterations of warm-up before):

| Routine | Timing ± Std.Dev. |
|:--|:--|
| Loop-based | 27.664±0.782ns |
| Loop-based, FMA | 24.553±0.774ns |
| Unrolled loop | 21,906±0.389ns |
| Unrolled loop | 21,906±0.389ns |
| _C++ loop-based_ (`gcc -O1`) | 25.6ns |
| _C++ AVX512_ (`gcc -O3`) | 3.2ns |

Table: 4x4 matrix multiplications routines on the JVM compared with native C++ routines. {#tbl:MatrixMultiplicationComparison}

Ideally, 4x4 matrix multiplication would utilise both AVX512 commands and registers. This can be achieved with hand-written C code, see Listing \ref{lst:AVX512MatMult} for an example. 

\begin{lstlisting}[language=C++, caption={Example code for 4x4 matrix multiplication using AVX512 intrinsics. Source: \href{gist.github.com/rygorous/4172889}{https://gist.github.com/rygorous/4172889}.}, label=lst:AVX512MatMult, float]
#include <immintrin.h>
#include <intrin.h>

union Mat44 {
    float m[4][4];
    __m128 row[4];
};

void matmult_AVX_8(Mat44 &out, const Mat44 &A, const Mat44 &B)
{
    _mm256_zeroupper();
    __m256 A01 = _mm256_loadu_ps(&A.m[0][0]);
    __m256 A23 = _mm256_loadu_ps(&A.m[2][0]);
    
    __m256 out01x = twolincomb_AVX_8(A01, B);
    __m256 out23x = twolincomb_AVX_8(A23, B);

    _mm256_storeu_ps(&out.m[0][0], out01x);
    _mm256_storeu_ps(&out.m[2][0], out23x);
}
\end{lstlisting}

As can be seen from the table, the unoptimised C++ version of loop-based 4x4 matrix multiplication is in the same timing region as the loop-based Java version. The AVX512 is way faster, though. In the future, the JVM will gain native support for using SSE and AVX intrinsics manually in the language, almost certainly closing that gap. This initiative runs under the name _Project Panama_, and preview releases can be found at [openjdk.java.net/projects/panama](https://openjdk.java.net/projects/panama). scenery has already been tested successfully with the preview releases of Project Panama, benchmarks will be conducted in the future once the Project Panama API for intrinsics stabilises more.


## Summary

In this chapter, we have introduced the rendering architecture of scenery, discussed the renderer interface, and special scenery features like semi-automatic instancing and custom rendering pipelines. We discussed the differences between the OpenGL and Vulkan renderers, and compared a performance-critical operation in the context of the JVM and native code.

For future work, we refer the reader to [Future Development Directions], which summarises the future targets for all components of scenery.




