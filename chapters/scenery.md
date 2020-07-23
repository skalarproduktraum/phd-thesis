# scenery — VR/AR for Systems Biology

\alreadypublished{The work presented in this part has been partially published in:}{\textbf{Günther, U.}, Pietzsch, T., Gupta, A., Harrington, K.I.S., Tomancak, P., Gumhold, S., and Sbalzarini, I.F.: scenery: Flexible Virtual Reality Visualization on the Java VM. \emph{IEEE VIS}, 2019 (accepted). \href{https://arxiv.org/abs/1906.06726}{arXiv preprint 1906.06726}.}
    
In the chapters before, we have highlighted the needs of systems biology for flexible ways of harnessing human-computer interaction, high-fidelity, customisable visualisations, and reproducibility. 

In order to address these needs, we have chosen to develop our own visualisation framework: _scenery_, enabling prototyping and the delivery of multimodal, customisable, and interactive scientific visualisations, running on top of the Java Virtual Machine (JavaVM/JVM). scenery can be used on both desktop machines, and on distributed setups, such as the ones commonly used for CAVE systems or Powerwalls.

In this chapter, we are going to introduce the framework, starting with the development of ClearVolume [@Royer:2015tg], which later ignited the development of scenery. Subsequently, we outline the exact design goals and decisions made along the way, and compare scenery to existing frameworks and related works, followed by a high-level description of its components. 

After this chapter, we will introduce scenery's subsystems in more detail.

## ClearVolume

![ClearVolume running inside Fiji, showing a multicolour _Drosophila melanogaster_ brain dataset (courtesy of Tsumin Lee, Howard Hughes Medical Institute, Janelia Farm Research Campus), with a by-slice viewer inset. Reused from [@Royer:2015tg].\label{fig:cvfiji}](ClearVolumeFiji.png)

\alreadypublished{The work presented in this section has been developed in collaboration with Loïc Royer, Martin Weigert, Nicola Maghelli, and Florian Jug, Myers Lab, MPI-CBG, and has been published in:}{Royer, L.A., Weigert, M., \textbf{Günther, U.}, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume: open-source live 3D visualization for light-sheet microscopy. \emph{Nature Methods}, 2015.}

ClearVolume is a visualisation library enabling live, realtime visualisation of lightsheet microscopy data, with the capability of being integrated directly into an existing microscopy setup — ClearVolume can be used in conjunction with commonly-used microscopy control software, like MicroManager[@Edelstein:2010gf] or National Instruments LabVIEW.

The discerning features of ClearVolume are:

* _Local and remote visualisation_ — the data acquired on the microscope can be visualised right on the instrument's control computer, or on a remote machine, with the data transferred over the network, albeit uncompressed. Especially when working with genetically modified organism, where the instrument has to be located in an access-controlled S1 or S2 area, remote viewing proved to be a practical tool  to check on an experiment's progress, or on specimen health.
* _Source/sink architecture_ — the data acquired in ClearVolume can be sent through a processing pipeline on the GPU, with the visualisation part at the end of the pipeline, and a number of processing steps before. These processing steps can include, e.g., image sharpness measurement, sample drift measurement, or Lucy-Richardson deconvolution.
* _Multipass maximum projection_ (developed by Martin Weigert) — rendering large datasets in full resolution can be quite taxing on GPUs. To alleviate this problem, we have developed a new way of sampling along a traced ray, based on low-discrepancy sequences (such as the Fibonacci sequence). When multipass maximum projection rendering is active, the first samples along the ray are taken very coarsely, while subsequent samples are placed in a way to fill "holes" along the ray most efficiently, yielding a significant speedup (see Figure \ref{fig:LowDiscrepancySampling} for a sketch of the principle).
* _Sample tracking_ (developed by the author) — utilising the source/sink architecture for data, we developed a simple center-of-mass tracking algorithm that stabilises the sample in the center of the user's field of view. The tracking can be enabled or disabled at any point in time (see Figure \ref{fig:ClearVolume}c).
* _Image quality measurement_ (developed by Martin Weigert and Loïc Royer) — again utilising the source/sink architecture for data, we added a flexible evaluator of image sharpness to the system, where in the default settings the Tenengrad image sharpness measure is used (see Figure \ref{fig:ClearVolume}c), and
* _Fiji & KNIME integration_ (developed by Florian Jug) — as ClearVolume supports visualising volumetric data from a microscope or any other source, we have developed plugins for Fiji[@schindelin2012fiji] and KNIME, in addition to the integration with MicroManager[@Edelstein:2010gf] and National Instruments LabVIEW (see Figure \ref{fig:cvfiji}).

![Multipass maximum projection — In the naive approach, consecutive samples along a ray are taken in single-step increments. With low-discrepancy sampling based on the Fibonacci sequence, not-yet sampled intervals along the ray are filled in most efficiently. In the figure, consecutive samples are shown top-to-bottom, with the current sample being highlighted in red.\label{fig:LowDiscrepancySampling} Reused from [@Royer:2015tg].](ClearVolumeMultipassVsNaive.pdf)

\begin{figure*}
    \includegraphics{ClearVolumeMainFigure.pdf}
    \caption{\textbf{a} Data flow in a ClearVolume-augmented microscopy application, \textbf{b} Local or remote visualisation using ClearVolume, \textbf{c} Evaluation of data fitness/sharpness and drift correction applied, \textbf{d} Multi-colour compositing.\label{fig:ClearVolume} Reused from \citep{Royer:2015tg}.}
\end{figure*}

In the time since its publication, ClearVolume has proven to be a useful tool for a multitude of use cases, such as microscope development and usage [@Royer:2016fh; @Kumar:2018rvi], method development for live imaging [@Boothe:20178ad], and the visualisation of correlative light microscopy/electron microscopy data [@Russell:2016711].

However, ClearVolume only supports the visualisation of a single — although multicolour — registered volumetric dataset, which moreover needs to fit into GPU memory. With the ongoing foray of more complex computational methods into systems biology and imaging, however, volumetric data is not the only kind of data that needs to be visualised: segmentations, graph data, textual information, etc. need to be supported as well. In addition, infrastructure to support volumetric data that does not fit into the GPU memory fully needs to be supported. This in turn requires different rendering architecture, supporting complex scenes, filled with volumetric, geometric, and custom kinds of data. Furthermore, we also recognised the need for integration of various interaction hardware, such as head-mounted displays (HMDs) for Virtual Reality or gesture interfaces. The integration of such is possible with ClearVolume, but needs to happen on a lower level, with a framework designed around such input and output modalities.

The development of scenery started out of these particular needs.


## Design Goals

From ClearVolume, we have kept the following goals for the development of scenery:

* __Free and open source software__ —  the resulting framework should be open-source such that the users, such as scientists, can dive into the code and see both what a particular algorithm does and/or modify it to their needs. Free and open-source software also assures the reproducibility of results over a longer period of time than closed-source software does.
* __Volume rendering__ — fluorescence microscopy produces volumetric data, so the software package has to support both single-timepoint 3D volumetric images (as are also created in CT and MRI scans), and time series of 3D images, such as developmental time lapse images. 
* __Extensible__ — the software has to be easily extensible, such that it can be adapted to current and future needs easily, both from hardware and software side.
* __JavaVM/Fiji integration__ — Fiji[@schindelin2012fiji] is a free and open-source image analysis software package running on the JavaVM, which is used by thousands of biologists world-wide. To enable easy adoption and present the user with a familiar ecosystem, the software has to integrate with this particular ecosystem easily. For that, the software has either to be written to target the Java Runtime Environment, or be able to be called from that.

In light of the needs we have identified in the previous section, we have added the following design goals for scenery that go beyond the capabilities of ClearVolume:

* __Mesh rendering__ — segmentation results or simulation results are also often produced in a mesh format, so the software also has to support these. Furthermore, localisation microscopy produces collocation points, which can also be interpreted as vertices and rendered as such.
* __Out of core volume rendering__ — the size of volumetric data produced in imaging experiments or simulations is constantly growing, while e.g. bandwidth — be it network or memory bandwidth — and graphics memory do not grow at the same rate. As a result, the software has to support datasets that do not fit into the GPU memory anymore.
* __Distributed Rendering__ — the software needs to be able to run on multiple machines in order to distribute the rendering workload, and synchronise scene content, e.g. for running on Powerwall systems[@woodward2001powerwall; @Papadopoulos:2015bw] or CAVE systems[@CruzNeira:1992fa].
* __Cross Reality__ — the software has to support both virtual and augmented reality rendering modalities, such as head-mounted displays (HMDs).
* __Vulkan/OpenGL support__ — To harness the power of current GPUs, the software should support the state-of-the-art rendering APIs Vulkan, and also provide a fallback to OpenGL 4.0+ in case Vulkan is not supported on the platform[^openglnote].


[^openglnote]: A higher OpenGL version than 4.1 would also be desirable, but macOS only supports up to 4.1, unfortunately. OpenGL, together with OpenCL, is actually deprecated since macOS 10.14 _Mojave_. As Apple does not natively support the Vulkan API, we are going to use a wrapper, _MoltenVK_, that translates Vulkan calls to Apple's proprietary Metal API to support future development on the macOS platform.

## State of the Art

The following table shows a comparison of scenery with other state-of-the-art software packages in terms of our design goals.

| Software | Type | \rotatebox[origin=c]{90}{Free/open-source} | \rotatebox[origin=c]{90}{Volumes} | \rotatebox[origin=c]{90}{Out-of-core rendering}  | \rotatebox[origin=c]{90}{Meshes} | \rotatebox[origin=c]{90}{Distr. Rendering} | \rotatebox[origin=c]{90}{VR} | \rotatebox[origin=c]{90}{Extensible} | \rotatebox[origin=c]{90}{Cross-platform} | \rotatebox[origin=c]{90}{OGL 4.1/D3D12/Vulkan} | \rotatebox[origin=c]{90}{Fiji integration} |
|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| Amira | Big data, Microscopy | - | \textbullet | \textbullet | \textbullet | - | \textbullet | - | - | - | - |
| Arivis | Big data, Microscopy | - | \textbullet | \textbullet | \textbullet | - | \textbullet | \textbullet | - | - | - |
| BigDataViewer [@Pietzsch:2015hl] | Big data, Microscopy | \textbullet | \textbullet | \textbullet | - | - | - | \textbullet | \textbullet | - | \textbullet |
| Imaris | Big data, Microscopy | - | \textbullet | \textbullet |  \textbullet | - | \textbullet | \textbullet | - | \textbullet | \textbullet |
| Vaa3D [@Bria:2016fl] | Big data, Microscopy | \textbullet | \textbullet |  \textbullet | \textbullet | - | - | \textbullet | \textbullet | \textbullet | - |
| ClearVolume [@Royer:2015tg] | Microscopy | \textbullet | \textbullet | - | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet |
| Zeiss ZEN | Microscopy | - | \textbullet | - | - | - | - | \textbullet | - | - | - |
| Unity | Game engine | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| Unreal Engine | Game engine | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| Vizard | CAVE software | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet | - | \textbullet | - |
| Mechdyne CAVELib | CAVE software | - | - | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - |
| VTK [@Hanwell:2015iv] | Scivis engine | \textbullet | \textbullet | - | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | - | - |
| _scenery_ | Scivis engine | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet | \textbullet |

Table: scenery compared to other software packages. {#tbl:SceneryComparison}

We find that none of the existing software packages satisfy our design goals fully, though _VTK_ comes closest. _VTK_ is widely used and stable, and actually provides wrapper code for use from the Java VM. The wrappers are, however, difficult to build and maintain. VTK also does not offer straightforward modifications of the rendering code. VTK's rendering routines have been updated recently to use OpenGL 2.1 [@Hanwell:2015iv], but that OpenGL version does still enable the use of modern technologies like compute shaders to fully exploit of current GPUs.

The CAVE development libraries _Vizard_ and _CAVElib_ offer out-of-the-box virtual reality support, but are not able to render volumetric data, nor are they extensible enough to add such functionality as a plugin. They also do not integrate with the Fiji ecosystem and the Java VM and are closed-source software, with significant license costs for all users. 

The game engines _Unity_ and _Unreal_ in turn offer a wide variety of plugin-based extensions, albeit most of them are neither free nor open-source software. Both can be extended enough to facilitate volume rendering, but out-of-core volume rendering has not been shown yet. Both also support virtual reality and distributed rendering, although distributed rendering is an experimental feature at the time of writing. They also do not offer integration into the Fiji ecosystem or the Java VM.

_Vaa3D_ and it's extension, _TeraFly_, does offer plugin-based extensibility, rendering of volumetric data — even out of core — but falls short on the virtual reality and distributed rendering support. Vaa3D also does not offer Fiji/Java VM integration, although there exists a Fiji plugin that can import Vaa3D data.

The commercial big data microscopy packages, _Amira_, _Arivis_, and _Imaris_ all offer similar feature sets, with support for out-of-core volume rendering, mesh data support, even virtual reality. With the exception of Imaris, they use older graphics APIs than DirectX12/Vulkan or OpenGL 4.x and do not support distributed rendering setups. Imaris also offers Fiji integration, which the other two do not. However, non of them are open-source software and they do not support changes to their rendering routines.

_Zeiss ZEN_ and is Zeiss' default microscopy acquisition software. It supports volumetric data and rendering of it, although not out-of-core. Since recently, ZEN also offers plugin-based extensibility, but is not open-source software and does not integrate with Fiji or the Java VM.

Finally, _BigDataViewer_ has introduced an open-source architecture for access to large image datasets that do not fit into the main memory of a given machine, and are loaded on-the-fly from hard drives or even over the network. BigDataViewer supports by-slice rendering of volumetric data (thereby excluding VR rendering), but no meshes, and is tightly integrated with Fiji. We are going to use BigDataViewer's technology to implement out-of-core volume rendering in scenery.

Of the mentioned software packages, Amira, Arivis, Imaris, ZEN, Vizard, and CAVELib only run on a subset of our list of target platforms (Windows, macOS, Linux).

## Implementation Challenges

### Language

The first implementation challenge is finding the right programmings language. The obvious choice for graphics applications would be C/C++, or newer/safer alternatives, such as Rust[^rustnote]. 

One of our goals, however, is tight integration with the ImageJ ecosystem, which is targeting the JavaVM. While the JavaVM itself does not have the reputation of being a harbour for high-performance applications, which usually resort to C/C++, it offers a less steep learning curve for new users, and extremely well-designed abstractions, e.g. for multithreading between the different platforms we are targeting, making platform-specific code unnecessary in most cases. 

We additionally view our framework as an interesting experiment on how to bring high-performance graphics to the JavaVM — a task that should now not be as difficult as before anymore, owing to pipelined graphics/compute APIs such as OpenCL, CUDA, and Vulkan. 

We aim for excellent interoperability with the ImageJ ecosystem, yet want to use a functional language to make it easy to reason about the code, and avoid the large amounts of boilerplate code usually necessary in pure-Java projects. Within the realm of JavaVM-based languages, the contenders[^contendernote] therefore are

* _Clojure_, a Lisp dialect,
* _Scala_, a functional and object-oriented language developed at _EPFL_,
* _Kotlin_, a language using both functional and object-oriented paradigms by the company JetBrains.

_Clojure_ unfortunately has a very steep learning curve, resulting in a small pool of experts, and _Scala_ makes usage from existing Java code difficult. _Kotlin_ on the other hand provides a useful functional feature set, as well as low entry barriers, and a well developed, open-source and commercially maintained IDE [^kotlinlink]. Kotlin is additionally useable as a scripting language (see [https://github.com/hbrandl/kscript](https://github.com/hbrandl/kscript)). Since 2017, Kotlin is also a first-class citizen on the Android platform, which has since significantly boosted its popularity, making it one of the most popular newcomer languages, as determined by the PyPL index (\emph{P}opularit\emph{Y} of \emph{P}rogramming \emph{L}anguages, [pypl.github.io](https://pypl.github.io)). 

Finally, returning to our previous remark about native languages vs. the JavaVM: In addition to targeting the JavaVM, _Kotlin_ also offers to transpilation to JavaScript and to actual native code (via LLVM [@Lattner:2004vw]), making our design choice more future-proof, in the case that the JavaVM should at some day present unsurmountable issues, or should we decide to include the web browser in our list of deployment targets.

[^rustnote]: Rust is a new multi-paradigm programming language focused on memory safety, see [rustlang.org](https://rust-lang.org).
[^kotlinlink]: see [kotlinlang.org](https://kotlinlang.org).
[^contendernote]: As of early 2016, when the project was started. Since then, other languages, such as Ceylon, have matured a lot — and would probably now be considered as well.

### Graphics APIs

The graphics API is the API that makes talks to the GPU. Historically — and before graphics cards were actually called GPUs — the developer would manipulate the geometry to be shown on screen on the CPU, and the graphics card executes hard-wired in-silicon graphics functions that could not be changed. OpenGL is an example for an API that originated in this era, back when graphics cards did not offer _actual_ programmability, but would just execute a fixed set of instructions quicker than a regular processor could.

OpenGL has originally been developed by Silicon Graphics (SGI) in the early 1990's for their graphics workstations. Originally intended for CAD/CAM applications, OpenGL soon became the go-to API for developing cross-platform graphics applications and games.

Since the early days of OpenGL, and also after further development had been handed over to the Khronos Group, OpenGL's development model has been based around the definition of a standard, augmented by extensions approved by the Khronos Group's Architecture Review Board (ARB). New versions of the standard were then essentially made out of sets of mandatory ARB extensions a GPU would have to support to be declared compatible with OpenGL x.y.

Shader-based rendering, and with that, more programmability of the graphics pipeline, has been introduced into OpenGL fully with OpenGL 2.1, with further extensions made with 3.3 and 4.1. What has not changed since the beginning though, is the basic programming model, where the programmer modifies a global state, and render objects either directly (in the ancient days of OpenGL 1.x), or with the help of vertex buffer objects (VBOs). This programming model mapped very well to the early, fixed-function graphics cards.

Unfortunately, this programming model does not map well to current-generation GPUs, which have become massively parallel computing machines, with some sporting 4000 individual cores and more. These cores do not have the flexibility of regular CPUs, but eclipse them easily in specialty disciplines, such as the floating-point computations needed for matrix and vector math operations heavily used in both graphics and machine learning. 

In 2016, the Khronos Group has published a new graphics API named _Vulkan_ solving the issues with OpenGL, and essentially starting with a clean slate. Vulkan provides a much deeper, _close-to-metal_ access to the GPU than OpenGL does, with the main differences being:

* More verbose code with less checks done by the driver, leading to more clarity about what is done, when, and how. Now, however, the developer needs to take greater care in adhering to the specification, as it clearly states that the driver is allowed to crash an application in case it is behaving out-of-specification.
* Better options for validation on the developer side. While the driver does not do many checks anymore, they can be activated on the application side by the _Validation Layers_, which can impact performance quite badly, but provide highly detailed information about where and when a problem occured, giving the developer quicker insight how to fix that problem.
* Possible higher performance by caching command buffers containing rendering commands, instead of scene iteration and draw call issuing with every frame. Command buffers can also be created by multiple threads in parallel, but need to be submitted serially.
* Resources, such as textures and buffers, and their descriptors, have to be allocated and managed on a much more fine-grained level than with OpenGL, but can be accessed directly, and do not need to be bound to texture units like in OpenGL.
* Vendor-independent (Homogeneous) Multi-GPU support (since Vulkan 1.1).
* A Conformance Test Suite (CTS) for the graphics drivers, ensuring that a Vulkan-based application behaves identically on all drivers.
* Shaders are not loaded from OpenGL Shading Language (GLSL) text files, but compiled SPIR-V byte code, with interesting new possibilities for introspection and reflection, e.g. via the tool/library _spirv-cross_.

From this list, it is clear that with great power comes great responsibility — with more effort required by the developer when writing Vulkan code, although that typically is more than compensated by better performance and much better debugging options. 

During early development, we recognised that the OpenGL and Vulkan APIs do not map very well onto each other, as Vulkan operates on a much lower level. For this reason, scenery has been written with flexibility regarding the rendering backend in mind: It should be easy for the developer to replace one of the existing rendering backends with an entirely new one. 

scenery now includes both an OpenGL 4.1 backend for use on the macOS operating system, and a Vulkan backend for use on Windows and Linux. The contract between the core library and the rendering backend is thin, making it very easy to create new rendering backends, with offline rendering via an external raytracing software, such as _Embree_[@Wald:2014db], _OSPray_[@Wald:2017ee] or _OptiX_[@Parker:2013hxa] being a future possibility.

### Interfacing with Graphics API on the Java VM

Current versions (8.0+) of the Java Virtual Machine do not provide Java-native bindings to graphics APIs like Direct3D, OpenGL or Vulkan, but 3rd-party libraries exist to bridge this gap.  We have chosen two projects for developing the OpenGL and Vulkan backends of scenery:

* _JOGL_ ([www.jogamp.org](https://jogamp.org)) provides an object-oriented Java interface to the OpenGL API in all of its current versions. In that, JOGL's interfaces are written in a very idiomatic way, which partially diverge quite far from the original OpenGL C API. They do, however, simplify the use for the developed software, especially in situations where it has to be embedded into an existing GUI application. JOGL is used for the OpenGL backend in scenery.
* _LWJGL3_ ([www.lwjgl.org](https://lwjgl.org)) provides a Java interface to the OpenGL and Vulkan APIs in all of their current versions. In contrast to JOGL, LWJGL3 keeps its API very close to the original, and does not wrap a normal C API in an object-oriented manner, but leaves that aspect to the developer, in case desired. This approach results in more flexibility, at the cost of higher effort for embedding into existing applications. LWJGL3 is used to develop the Vulkan backend in scenery. Memory management for Vulkan-related structures is mostly manual, but off-heap: Off-heap memory is memory that is not managed by the JavaVM. In the case of LWJGL3, on Windows `malloc()` is used for allocations, while on Linux and macOS, the high-performance memory allocator _jemalloc_ (jemalloc.net](http://jemalloc.net)) is used. Both allocators provide a better alternative to using Java's Direct Byte Buffers that incur a large performance penalty over raw `malloc()` calls, and are also a sparse resource, available only in a size determined at program startup. In LWJGL3, a thread-local memory stack is provided in addition, enabling high-speed temporary allocations. For details about memory allocation strategies in LWJGL3, see [blog.lwjgl.org/memory-management-in-lwjgl-3/](https://blog.lwjgl.org/memory-management-in-lwjgl-3/). In short, management of that memory is up to the developer.

Unfortunately, JOGL is not actively maintained anymore, and we aim to fully switch to the LWJGL3-powered Vulkan backend in the future.

## Component overview

\begin{figure*}
    \includegraphics{scenery-architecture.pdf}
    \caption{A high-level overview of scenery's components.\label{fig:SceneryArchitecture}}
\end{figure*}

At the outermost architectural layer, the scenery framework consists of seven main software components:

* the _Scene_, represents the content that needs to be visualised as directed acyclic graph (scenegraph),
* the _Renderer_, taking care of the visual representation of the scene's contents,
* the _Input Handler_ for responding to input events triggered by the user,
* the _External Hardware Handlers_, for handling, e.g., head-mounted displays or tracking systems,
* the _Publishers_ and _Subscribers_, which track changes, e.g. to a Scene, and disseminate them to connected clients over the network in a distributed rendering setup,
* the _Hub_, tying all these systems together and allowing the system to query information about each components state, and
* the _Settings_, an instance-local database of default and user-defined settings that may also change during runtime.

The construction and interplay of all the components is handled by the class `SceneryBase`, which a user can directly subclass to create own applications.

In the next chapters, we are going to introduce the most important subsystems of scenery, namely those for rendering, input handling and integration of external hardware, and for distributed rendering. These chapters are followed by a brief description of the remaining subsystems in scenery. We conclude the description of scenery with [Future Development Directions]. 

## Software Availability

scenery is available as free and open-source software under the LGPL 3.0 license at [github.com/scenerygraphics/scenery](https://github.com/scenerygraphics/scenery).


