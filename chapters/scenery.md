\part{scenery}

# scenery

In the chapters before, we have described the needs of systems biology for flexible ways of harnessing human-computer interaction, high-fidelity, customizable visualisations, and reproducibility. 

To realise these needs, we have chosen to develop our own visualisation framework, as currently existing libraries were not flexible.

The result of this effort is _scenery_, a toolkit for prototyping and delivering multimodal, customisable, and interactive scientific visualisations, targeting the Java Virtual Machine (JavaVM). scenery can be used on both desktop machines, as well as clustered setups, such as the ones commonly used for CAVE systems or Powerwalls.

In this chapter, we are going to introduce the framework, outlining the exact design goals and decisions made along the way, compare it to existing frameworks and related works, followed by a high-level description of its components. This chapter is followed by the architecture chapter, going into deeper details for each of scenery's building blocks.


## Design Goals

In designing _scenery_, we set these design goals

* __Free and open source software__ —  the resulting framework should be open-source such that the users, such as scientists, can dive into the code and see both what a particular algorithm is doing and/or modify it to their needs.
* __Volume rendering__ — fluorescence microscopy produces volumetric data, so the software package has to support both single-timepoint 3D volumetric images (as are also created in CT or MRI scans), and time series of 3D images, such as developmental time lapse images.
* __Mesh rendering__ — segmentation results or simulation results are also often produced in a mesh format, so the software also has to support these. Furthermore, localisation microscopy produces collocation points, which can also be interpreted as vertices and rendered as such.
* __Clustering__ — the software should be able to run on multiple machines which share the rendering workload, and syncronise scene content, e.g. for running on Powerwall systems \TODO{cite Powerwall paper} or CAVE systems[@CruzNeira:1992vt].
* __Cross Reality__ — the software has to support both virtual and augmented reality rendering modalities, such as HMDs.
* __Extensible__ — the software has to be easily extensible, such that it can be adapted to current and future needs easily, both from hardware and software side.
* __Cross-platform__ — Windows, macOS and Linux are the most commonly encountered operating systems today. When surveying the fields of biology, computer science, physics and math, they are encountered in different distributions, to the software has to support all of them, preferably with minimal adjustments required.
* __Vulkan/OpenGL support__ — To harness the power of current GPUs, the software should support state-of-the-art rendering APIs Vulkan, and also provide a fallback to  OpenGL 4.0+ in case Vulkan is not supported on the platform. [^openglnote].
* __JavaVM/Fiji integration__ — Fiji[@Schindelin:2012ir] is a free and open-source image analysis software package running on the JavaVM, and used by thousands of biologists world-wide. To enable easy adoption and present the user with a familiar ecosystem, the software has to integrate with this particular ecosystem easily. For that, the software has either to be written to target the Java Runtime Environment, or be able to be called from that.

[^openglnote]: A higher OpenGL version than 4.1 would also be desirable, but macOS only supports up to 4.1, unfortunately.

## State of the Art

The following table shows a comparison of _scenery_ with other state-of-the-art software packages in terms of our design goals.

| Software | Type | \rotatebox[origin=c]{90}{Free/open-source} | \rotatebox[origin=c]{90}{Volumes} | \rotatebox[origin=c]{90}{Meshes} | \rotatebox[origin=c]{90}{Clustering} | \rotatebox[origin=c]{90}{VR} | \rotatebox[origin=c]{90}{Extensible} | \rotatebox[origin=c]{90}{Cross-platform} | \rotatebox[origin=c]{90}{OGL 4.1/D3D12/Vulkan} | \rotatebox[origin=c]{90}{Fiji integration} |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| Amira | Big data, Microscopy | - | \textbullet | \textbullet | - | \textbullet | - | - | - | - |
| Arivis | Big data, Microscopy | - | \textbullet | \textbullet | - | \textbullet | \textbullet | - | - | - |
| BigDataViewer | Big data, Microscopy | \textbullet | \textbullet | - | - | - | \textbullet | \textbullet | - | \textbullet |
| Imaris | Big data, Microscopy | - | \textbullet | \textbullet | - | \textbullet | \textbullet | - | \textbullet | \textbullet |
| Vaa3D | Big data, Microscopy | \textbullet | \textbullet | \textbullet | - | - | \textbullet | \textbullet | \textbullet | - |
| ClearVolume | Microscopy | \textbullet | \textbullet | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet |
| Zeiss ZEN | Microscopy | - | \textbullet | - | - | - | \textbullet | - | - | - |
| Unity | Game engine | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| Unreal Engine | Game engine | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| Vizard | CAVE software | - | - | \textbullet | \textbullet | \textbullet | \textbullet | - | \textbullet | - |
| Mechdyne CAVELib | CAVE software | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| VTK | Scivis engine | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - | - |
| _scenery_ | Scivis engine | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet |

We find that none of the existing software packages satisfy our design goals fully, though _VTK_ comes very close. While _VTK_ is widely used and stable, and actually provides wrapper code for use in Java, it is difficult to build and maintain the code interfacing VTK's native parts with Java, and does not offer easy modifications of the rendering code, which is also still using OpenGL 2.0\cite{IEEE OpenGL2.0 VTK paper}, and therefore not able to make full use of current GPUs.

## Implementation Challenges

### Language

The first implementation challenge is finding the right language. The obvious choice for graphics applications would be C/C++, or newer/safer alternatives, such as Rust. As we have just mentioned, one of our goals is tight integration with the ImageJ ecosystem, targeting the JavaVM. While the JavaVM itself does not have the reputation of being a harbour for high-performance applications, usually resorting to C/C++, it offers a less steep learning curve for new users, and extremely well-designed abstractions between the different platforms we are targeting, making platform-specific code (mostly) unnecessary. We additionally view our framework as an interesting experiment on how to bring high-performance graphics to the JavaVM -- a task that should now not be as difficult as before anymore, owed to pipelined graphics/compute APIs such as OpenCL, CUDA or Vulkan. 

As said before, we aim for excellent interoperability with the ImageJ ecosystem, yet wanted to use a functional language to make it easy to reason about the code, and prevent the amounts of boilerplate code usually necessary in pure-Java projects. Within the realm of JavaVM-based languages, the contenders[^contendernote] therefore were

* _Clojure_, a Lisp dialect,
* _Scala_, a functional and object-oriented language developed at _EPFL_,
* _Kotlin_, a language using both functional and object-oriented paradigms by the company JetBrains.

_Clojure_ unfortunately has a very steep learning curve, resulting in a small pool of experts, and _Scala_ makes use from existing Java code difficult. _Kotlin_ on the other hand provides a useful functional feature set, as well as low entry barriers, and a well developed, open-source and commercially maintained IDE [^kotlinlink] Further, Kotlin is also useable as a scripting language (see [https://github.com/hbrandl/kscript](https://github.com/hbrandl/kscript)). Since 2017, Kotlin is also a first-class citizen on the Android platform, which has since significantly boosted its popularity.

Coming back to our previous remark about native languages vs. the JavaVM: In addition to targeting the JavaVM, _Kotlin_ also offers support for JavaScript and actual native code as target (via LLVM \TODO{cite}), making the design choice more future-proof, just in the case that the JVM should at some day present unsurmountable issues, or should we decide to include the web browser as our deployment target of choice.

[^kotlinlink]: see [kotlinlang.org](https://kotlinlang.org).
[^contendernote]: As of early 2016, when the project was started. Since then, other languages, such as Ceylon, have matured a lot, and would probably now be considered as well.

### Graphics APIs

OpenGL is a graphics API originally developed by Silicon Graphics (SGI) in the early 1990's for their graphics workstations. Originally intended for CAD/CAM applications, OpenGL soon became the go-to API for developing cross-platform graphics applications and games.

Since the early days of OpenGL, and also after further development had been handed over to the Khronos Group, OpenGL's development model has been based around the definition of a standard, augmented by extensions approved by the Khronos Group's Architecture Review Board (ARB). New versions of the standard were then essentially made out of sets of mandatory ARB extensions a GPU would have to support to be declared compatible with OpenGL x.y.

Shader-based rendering has been introduced into OpenGL fully with OpenGL 2.1, with further extensions made with 3.3 and 4.1. What has not changed since the beginning though, is the basic programming model, where the programmer would modify a global state, and render objects either directly (in the ancient days of OpenGL 1.x), or with the help of vertex buffer objects (VBOs).

Unfortunately, this programming model does not map well to current-generation GPUs, which have become massively parallel computing machines, with some sporting 4000 individual cores and more. They do not have the flexibility of regular CPUs, but eclipse them easily in floating-point compute power.

In 2016, the Khronos Group has published a new graphics API named _Vulkan_, aiming at alleviating the issues with OpenGL, essentially starting with a clean slate. Vulkan provides a much deeper, _close-to-metal_ access to the GPU than OpenGL does, further differences are:

* More verbose code, with less checks done by the driver, leading to more clarity about what is done, when, and how. Now however the developer needs to take greater care in adhering to the specification, as it clearly states that the driver is allowed to crash an application in case it is behaving out-of-spec.
* Higher possible performance by caching command buffers containing rendering commands, instead of scene iteration with every frame. Command buffers can also be created by multiple threads in parallel, but need to be submitted serially.
* Resources, such as textures and buffers, and their descriptors, have to be allocated and managed on a much more fine-grained level than with OpenGL.
* (Homogeneous) Multi-GPU support (since Vulkan 1.1).
* A Conformance Test Suite (CTS) for the graphics drivers, ensuring that a Vulkan-based application behaves the same on all drivers.
* Shaders are not loaded from GLSL text files, but compiled SPIR-V byte code, with large possibilities for introspection and reflection, e.g. via the tool/library _spirv-cross_.

From this list it is clear that with great power comes great responsibility — and that the OpenGL and Vulkan APIs do not map very well to each other. 

For this reason, _scenery_ has been written with flexibility regarding the rendering backend in mind: It should be easy for the developer to replace one of the existing rendering backends with an entirely new one. 

_scenery_ now includes both an OpenGL 4.1 backend for use on the macOS operating system, and a Vulkan backend for use on Windows and Linux. The contract between the core library and the rendering part is quite thin, making it very easy to create new rendering backends, with offline rendering via an external raytracing software, such as _Embree_[@Wald:2014db], _OSPray_[@Wald:2017ee] or _OptiX_[@Parker:2013hxa] being a future possibility.

### Interfacing with Graphics API on the Java VM

Current versions (8.0+) of the Java Virtual Machine do not provide Java-native bindings to graphics APIs like Direct3D, OpenGL or Vulkan, but 3rd party libraries exist to bridge that gap.  We have chosen two projects for developing the OpenGL and Vulkan backends:

* _JOGL_ ([www.jogamp.org](https://jogamp.org)) provides an object-oriented Java interface to the OpenGL API in all of its current versions. In that, JOGLs interfaces are written in a very idiomatic way, which partially diverge quite far from the original OpenGL C API. They however simplify the use for the developed software, especially in situations where it has to be embedded into an existing GUI application. JOGL is used for the OpenGL backend in scenery.
* _LWJGL3_ ([www.lwjgl.org](https://lwjgl.org)) provides a Java interface to the OpenGL and Vulkan APIs in all of their current versions. In contrast to JOGL, LWJGL3 keeps its API very close to the original, and does not try to wrap a normal C API in an object-oriented manner, but leaves that aspect to the developer, in case desired. This approach results in more flexibility, though at the cost of higher effort for embedding into existing applications. LWJGL3 is used to develop the Vulkan backend in scenery. Memory management for Vulkan-related structures is mostly manual, but off-heap[^offheapnote], such that management of that memory is up to the developer.

[^offheapnote]: Off-heap memory is memory that is not being managed by the JavaVM. In the case of LWJGL3, on Windows `malloc()` is used for allocations, while on Linux and macOS, the high-performance memory allocator _jemalloc_ (jemalloc.net](http://jemalloc.net)) is used. Both allocators provide a better alternative to using Java's Direct Byte Buffers that incur a large performance penalty over raw `malloc()` calls, and are also a sparse resource, available only in a size determined at program startup. In LWJGL3, a thread-local memory stack is provided in addition, enabling high-speed temporary allocations. For details about memory allocation strategies in LWJGL3, see [blog.lwjgl.org/memory-management-in-lwjgl-3/](https://blog.lwjgl.org/memory-management-in-lwjgl-3/).

## Component overview

From a birds-eye perspective, the scenery framework consists of six main components:

* the _Scene_, representing all the content that needs to be shown on screen as directed, acyclic graph (scenegraph),
* the _Renderer_, taking care of the visual representation of the scene's contents,
* the _Input Handler_, for responding to input events triggered by the user,
* the _External Hardware Handlers_, for handling e.g. head-mounted displays or tracking systems,
* the _Hub_, tying all these systems together, and allowing each system to query information about each other's state, and
* the _Settings_, an instance-local database of default and user-defined settings that might also change during runtime.

The construction and interplay of all these subsystems is handled by the class `SceneryBase`, which a user can directly subclass to create own applications.


In the next chapter, _design & architecture_, we are going into sharp detail about each of the subsystems.

