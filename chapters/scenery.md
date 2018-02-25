# scenery

## Design Goals

In designing _scenery_, we tried to adhere to these design goals

* __Free and open source software__ - the resulting package should be open-source such that the users, such as scientists, can dive into the code and see both what a particular algorithm is doing and/or modify it to their needs
* __Volume rendering__ - fluorescence microscopy produces volumetric data, so the software package has to support both single-timepoint 3D volumetric images (as are also created in CT or MRI scans), and time series of 3D images, such as developmental time lapse images.
* __Mesh rendering__ - segmentation results or simulation results are also often produced in a mesh format, so the software also has to support these.
* __Clustering__ - the software should be able to run on multiple machines in parallel, which share the rendering workload, e.g. for rendering to Powerwall systems or CAVE systems[@CruzNeira:1992vt].
* __VR__ - the software has to support virtual reality rendering modalities, such as HMDs.
* __Extensible__ - the software has to be easily extensible, such that it can be adapted to current and future needs easily.
* __Cross-platform__ - Windows, macOS and Linux are the most commonly encountered operating systems today. When surveying the fields of biology, computer science, physics and math, they are encountered in different distributions, to the software has to support all of them, preferably with minimal adjustments required.
* __OpenGL 4.0+/Vulkan support__ - To harness the power of current GPUs, the software should support state-of-the-art rendering APIs like Vulkan and/or OpenGL 4.0+ [^openglnote].
* __Fiji integration__ - Fiji[@Schindelin:2012ir] is a free and open-source image analysis software package used by thousands of biologists world-wide. To facilitate easy adoption and present the user with a familiar ecosystem, the software has to integrate with this particular ecosystem easily. For that, the software has either to be written to target the Java Runtime Environment, or be able to be called from that.

[^openglnote]: A higher OpenGL version than 4.1 would also be desirable, but macOS only supports up to 4.1, unfortunately.

## State of the Art

The following table shows a comparison of _scenery_ with other state-of-the-art software packages in terms of our design goals.

| Software | Type | \rotatebox[origin=c]{90}{Free and open-source} | \rotatebox[origin=c]{90}{Volumes} | \rotatebox[origin=c]{90}{Meshes} | \rotatebox[origin=c]{90}{Clustering} | \rotatebox[origin=c]{90}{VR} | \rotatebox[origin=c]{90}{Extendible} | \rotatebox[origin=c]{90}{Cross-platform} | \rotatebox[origin=c]{90}{OpenGL 4.0+/Vulkan} | \rotatebox[origin=c]{90}{Fiji integration} |
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

We find that none of the existing software packages satisfy our design goals fully, though _VTK_ comes very close. While _VTK_ is widely used and stable, and actually provides wrapper code for use in Java, it is difficult to build, maintain, and use, and does not offer easy modifications of the rendering code, which is also still using OpenGL 2.0, and therefore not able to make full use of current GPUs in an efficient manner.

## Implementation Challenges

The first implementation challenge is finding the right language. For the project, we aimed to use a functional language to make it easy to reason about the code. In the Java ecosystem, the contenders therefore were

* _Clojure_, a LISP dialect
* _Scala_, a functional and object-oriented language developed at _EPFL_
* _Kotlin_, a functional and object-oriented language developed by the company JetBrains and used in their IntelliJ product line, now also a first-class citizen on the Android operating system.

_Clojure_ unfortunately has a very steep learning curve, with a small pool of experts, and _Scala_ makes use from existing Java code difficult. _Kotlin_ on the other hand provides a useful functional feature set, as well as low entry barriers, and a well developed, open-source and commercially maintained IDE [^kotlinlink] Further, Kotlin is also useable as a scripting language (see [https://github.com/hbrandl/kscript](https://github.com/hbrandl/kscript)).

[^kotlinlink]: see [https://kotlinlang.org](https://kotlinlang.org).

## Architecture Details

## Capabilities

### Virtual and Augmented Reality

### Eye Tracking

### Real-Time Rendering

### Clustering

### Interaction Prototyping

