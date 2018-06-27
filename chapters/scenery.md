\part{scenery}

# scenery

_scenery_ is a toolkit for prototyping and delivering multimodal, customisable, and interactive scientific visualisations, geared towards desktop and small-cluster use. 

To realise the ideas described in the previous chapters, we have chosen to develop our own toolkit, as currently existing libraries were not flexible enough to achieve this. 

## Design Goals

In designing _scenery_, we tried to adhere to these design goals

* __Free and open source software__ —  the resulting package should be open-source such that the users, such as scientists, can dive into the code and see both what a particular algorithm is doing and/or modify it to their needs
* __Volume rendering__ — fluorescence microscopy produces volumetric data, so the software package has to support both single-timepoint 3D volumetric images (as are also created in CT or MRI scans), and time series of 3D images, such as developmental time lapse images.
* __Mesh rendering__ — segmentation results or simulation results are also often produced in a mesh format, so the software also has to support these.
* __Clustering__ — the software should be able to run on multiple machines in parallel, which share the rendering workload, e.g. for rendering to Powerwall systems or CAVE systems[@CruzNeira:1992vt].
* __VR__ — the software has to support virtual reality rendering modalities, such as HMDs.
* __Extensible__ — the software has to be easily extensible, such that it can be adapted to current and future needs easily.
* __Cross-platform__ — Windows, macOS and Linux are the most commonly encountered operating systems today. When surveying the fields of biology, computer science, physics and math, they are encountered in different distributions, to the software has to support all of them, preferably with minimal adjustments required.
* __OpenGL 4.0+/Vulkan support__ — To harness the power of current GPUs, the software should support state-of-the-art rendering APIs like Vulkan and/or OpenGL 4.0+ [^openglnote].
* __Fiji integration__ — Fiji[@Schindelin:2012ir] is a free and open-source image analysis software package used by thousands of biologists world-wide. To facilitate easy adoption and present the user with a familiar ecosystem, the software has to integrate with this particular ecosystem easily. For that, the software has either to be written to target the Java Runtime Environment, or be able to be called from that.

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

We find that none of the existing software packages satisfy our design goals fully, though _VTK_ comes very close. While _VTK_ is widely used and stable, and actually provides wrapper code for use in Java, it is difficult to build, maintain, and use, and does not offer easy modifications of the rendering code, which is also still using OpenGL 2.0, and therefore not able to make full use of current GPUs in an efficient manner.

## Implementation Challenges

### Language

The first implementation challenge is finding the right language. For the project, we aim for interoperability with the ImageJ ecosystem, and wanted to use a functional language to make it easy to reason about the code. In the Java ecosystem, the contenders therefore were

* _Clojure_, a Lisp dialect
* _Scala_, a functional and object-oriented language developed at _EPFL_
* _Kotlin_, a functional and object-oriented language developed by the company JetBrains and used in their IntelliJ product line, now also a first-class citizen on the Android operating system.

_Clojure_ unfortunately has a very steep learning curve, resulting in a small pool of experts, and _Scala_ makes use from existing Java code difficult. _Kotlin_ on the other hand provides a useful functional feature set, as well as low entry barriers, and a well developed, open-source and commercially maintained IDE [^kotlinlink] Further, Kotlin is also useable as a scripting language (see [https://github.com/hbrandl/kscript](https://github.com/hbrandl/kscript)).

In addition to targeting the JVM, _Kotlin_ also offers support for JavaScript and actual native code as target, making the design choice more future-proof, just in the case that the JVM should at some day present unsurmountable issues, or should we decide to include the web browser as our deployment target of choice.

[^kotlinlink]: see [https://kotlinlang.org](https://kotlinlang.org).

### Graphics APIs

While OpenGL has been developed and extended over the years, Vulkan was only introduced by the Khronos Group in 2016, and provides much deeper, _close-to-metal_ access to GPUs than OpenGL does. The main differences are:

* More verbose code, with less checks done by the driver, leading to more clarity about what is done, and how.
* Higher possible performance by caching command buffers containing rendering commands, instead of scene iteration with every frame.
* Resources, such as textures and buffers, have to be allocated and managed on a much more fine-grained level than with OpenGL.
* (Homogeneous) Multi-GPU support (since Vulkan 1.1).
* Conformance Test Suites (CTS) for the graphics drivers.
* Shaders are not loaded from GLSL text files, but compiled SPIR-V byte code, with large introspection possibilities.

From this list it is clear that with great power comes great responsibility — and that the OpenGL and Vulkan APIs do not map very well to each other. 

For this reason, _scenery_ has been written with flexibility regarding the rendering backend in mind: It should be easy for the developer to replace one of the existing rendering backends with an entirely new one. _scenery_ now includes both an OpenGL 4.1 backend for use on the macOS operating system, and a Vulkan backend for use on Windows and Linux. As the contract between the core library and the rendering part is quite thin, it is very easy to create new rendering backends, with offline rendering via an external raytracing software, such as _Cycles_ or _OptiX_ being a possibility.

### Interfacing with Graphics API on the Java VM

Current versions (8.0+) of the Java Virtual Machine do not provide Java-native bindings to graphics APIs like Direct3D, OpenGL or Vulkan, but 3rd party libraries exist to bridge that gap.  We have chosen two projects for developing the OpenGL and Vulkan backends:

* _JOGL_ ([www.jogamp.org](https://jogamp.org)) provides an object-oriented Java interface to the OpenGL API in all of its current versions. In that, JOGLs interfaces are written in a very idiomatic way, which partially diverge quite far from the original OpenGL C API. They however simplify the use for the developed software, especially in situations where it has to be embedded into an existing GUI application. JOGL is used for the OpenGL backend in scenery.
* _LWJGL_ ([www.lwjgl.org](https://lwjgl.org)) provides a Java interface to the OpenGL and Vulkan APIs in all of their current versions. In contrast to JOGL, LWJGL keeps its API very close to the original, and does not try to wrap a normal C API in an object-oriented manner, but leaves that aspect to the user, in case desired. This approach results in more flexibility, though at the cost of higher effort for embedding into existing applications. LWJGL is used to develop the Vulkan backend in scenery.

## Architecture Details

## Features

### Mapping between the Virtual Machine and shaders

### Configurable Rendering Pipelines

### Head-mounted Virtual Reality Displays

### Augmented Reality — HoloLens support

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

### Eye Tracking

### Real-Time Rendering

### Clustering

## Designing applications with scenery

### Define, Make, Learn — Principles of Iterative Design

