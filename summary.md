# A Modular and Open-Source Framework for Virtual Reality Visualisation and Interaction in Bioimaging -- Summary

In the last three decades, biology has gone through a remarkable development from being a discipline that is mostly wetlab-based to one  utilising the tools and methods of mathematics, physics, and computer science, becoming more and more reliant and intertwined with them: 

To just highlight a few, developments on the experimental side like light-sheet fluorescence microscopy [@Huisken:2004ky], optogenetics [@Boyden:2005cd; @Li:2005ha], or Cryo-EM [@Adrian:1984vv] have opened new venues for investigation, while theoretical contributions, e.g. to active matter theory [@Mietke:2018b12] now shed more light on these results and provide analytical guidance.

Investigating biological systems in two dimensions has already led to fascinating and important results in the past (Drosophila embryonic genes, etc.). Building on these, and utilising the mathematical, physical, and computational techniques mentioned above, we are now able to investigate biological systems in three dimensions, and over time, and at high speed, enabling in-depth observation and reasoning about spatiotemporal processes.

Even more recent developments, like CRISPR/Cas9 [@Jinek:2012hm] or gene drives enable us to manipulate specimen in ways and on fast timescales thought impossible before. 

What these developments lack to a certain extent, are ways to again bring the experimenter into the loop, both during the experiment, and during analysis, to enable new and flexible ways of interacting the large and complex amounts of data state-of-the-art experiments create, and also with the scientific instruments producing this data.

## Virtual and Augmented Reality

With the advent of the first small-enough computers, and small-enough cathode-ray tubes (CRTs), the development of devices that give the user the ability to inhabit a virtual environment or use more than just a keyboard for input of data started. Early examples of such systems — from the 1960s — are The Sword of Damocles[@Sutherland:1968im] or the Sketchpad system[@Sutherland:1963kq], made famous as _The Mother of All Demos_. In the meantime, and over the course of two Virtual Reality Revolutions — with important developments like the CAVE (CAVE Automatic Virtual Environment, [@CruzNeira:1992fa]) —  head-mounted displays (HMDs) have now become a commodity and can be bought for about 400$, bringing a once highly specialised and expensive device into the homes  or offices of potential users.

Complimentary to these display devices, new input methods are also on the rise, such as free-air gesture input (e.g. the widely available Microsoft Kinect or the Leap Motion), free-air controller input (e.g., HTC Vive controllers), touch input (multitouch screens in nearly every contemporary mobile phone) or even devices controlled by the gaze of the user (such as eye trackers from Tobii or Pupil Labs). Such devices and their interaction modalities are commonly called Natural User Interfaces. 

Despite the common availability of VR display devices, or NUI input device, many of the analysis and visualisation tasks in bioimaging are still done on a 2D screen, using a keyboard and a mouse, while VR might actually provide tangible benefits, beyond just a quick "wow" effect.

## Scope and contributions

In this thesis, we aim to demonstrate that the inclusion or Virtual  Reality and associated input devices, and advanced realtime rendering techniques can enhance the biologist's workflow, and enable new kinds of experiments, _in vivo_ and _in silico_.

To achieve this, we develop an open-source realtime rendering and interaction framework named _scenery_ that enables rapid prototyping of visualisations of geometric and volumetric biological data, and interaction with such on the basis of Natural User Interfaces. The framework supports rendering on regular desktop screens, virtual reality headsets (like the Oculus Rift or HTC Vive), and augmented reality headsets (like the Microsoft HoloLens). 

We will detail the architecture of the framework and demonstrate its necessity, utility and comprehensiveness on a set of case studies, and show further contributions made possible by the use of the framework.

Specifically, we will detail the following contributions:

* _scenery_, a framework for creating visualisation and interaction interfaces with both volumetric and geometric data, supporting virtual and augmented reality, and clustered rendering.
* _track2track_, an algorithm for utilising the user's gaze to solve tracking problems involving moving particles and objects or tracing of neurons, implemented on top of _scenery_.
* _Towards interactive laser ablation_, where laser-based complex microsurgical procedures on microscopic specimens are enhanced and simplified by the use of virtual reality and natural user interfaces. A simulation of this workflow is also implemented on top of _scenery_ and a user study performed to show benefits and challenges, as well as identify issues.
* _Rendering the Adaptive Particle Representation_, where we introduce ideas how to render the highly-efficient, particle-based Adaptive Particle Representation (APR) [@Cheeseman:2018b12] of volumetric data. The APR  can be displayed as point-based graphics, as maximum intensity projection (MIP), or full volume rendering. All rendering algorithms are implemented on top of _scenery_.
* _SciView_, a plugin for the ImageJ2/Fiji ecosystem, make scenery's flexible visualisation solutions available to the end user.

## Framework

With _scenery_, we have introduced a framework using the state-of-the-art rendering API Vulkan in order to provide VR/AR rendering of geometric and volumetric datasets of large size. The initial development of scenery was motivated by the need to make 3D data actually 3D, and harness the perceptual improvements brought by VR/AR for biological problems, such as tracking or instrument control. scenery was developed with five goals in mind: 

1. VR/AR support, both for headsets and room-scale systems like CAVEs,
2. Out-of-core volume rendering of large datasets,
3. User- and developer-friendly API 
4. Cross platform, support for at least Windows, macOS, and Linux, and
5. Run natively on the Java VM, and be embeddable in existing applications.

No existing software packages fulfilled these goals when we started the development of scenery, and at the time of writing, this still holds true. scenery is also the first framework for scientific visualisation that uses the modern Vulkan API.

In addition to the already mentioned VR/AR support and the out-of-core volume rendering of large datasets, we succeeded in creating a cross-platform framework that can help produce prototypes and applications on the three major operating systems. The framework can be embedded in existing applications on the Java VM, like Fiji, and — according to user feedback — is both user and developer friendly. 

In the future, we would like to extend the capabilities of scenery: This includes improved rendering algorithms as outlined in [Future Development Directions], improved support for AR applications, and venturing into new areas, such as _in situ_ visualisation.

## Case studies and applications

With the case studies in this work we demonstrated two things:

1. VR/AR can provide a tangible benefit for various visualisation and interaction applications in systems biology, and
2. scenery is a powerful and practical tool to develop such.

__With _track2track: Eye Tracking for Cell Tracking_,__ we combined virtual reality exploration of 4D biological datasets with eye tracking technology to enable the user to track cells by just looking at them, and following them around in time and space. We chose to develop this in virtual reality, as the tracking enables the user to look and move around, and even perform evasive movements, without the necessity for additional input devices, mimicking the exploration of objects in the real world. The combination of the tracking information from the virtual reality headset with the eye tracking data provided a powerful way to discern real and spurious cell detections, and an easy way to reduce the problem of finding a cell from 3D to 1D — from the whole 3D dataset, to just along a ray through the dataset. We have demonstrated a graph search-based approach, similar to fringe-preserving A* search, to connect detections of cells between multiple timepoints. Initial feedback indicates that  track2track is able to speed-up manual cell tracking tasks by at least an order of magnitude, significantly lowering the workload on the person performing the tracking. 

In the future, we want to validate our approach, e.g. with pre-annotated datasets or simulated datasets, where ground truth data is available, and make the technique available in tracking software packages, such as TrackMate, MaMuT, or Mastodon.

__With _Towards Interactive Virtual Reality Laser Ablation_,__ we have developed a prototype for the virtual reality control of laser ablation devices on volumetric microscopes, in order to make spatiotemporally complex processes accessible for experimental interference. We tested our prototypes with pre-recorded data on a set of people familiar with laser ablation, and collected their feedback. The feedback of the users has been mostly positive, with most of the users stating the presented technique provides an improvement over the state-of-the-art and could enable them to perform experiments not doable before, or perform experiments more quickly or precisely. From the user feedback, we have also collected ideas for future developments, namely the inclusion of a _virtual toolbelt_ that can provide multiple cutting geometries, as well as a macro mode to easily produce highly reproducible laser cuts even in difficult geometries. We have  furthermore sketched ideas for an OpenSPIM-based lightsheet microscope with an ablation unit. 

In the future, we are going to implement the suggestions from the user tests, and build a microscope to actually perform the actual laser ablation, and conduct another user test with the actual microscope, with data acquired in realtime.

__With _Rendering the Adaptive Particle Representation_,__ we have given a short introduction to the Adaptive Particle Representation (APR) as a new and highly efficient way of representing fluorescences images. In this case study, we have shown that scenery can also adapt to new, unconventional representations of image data, and can be a useful tool both during development and use of such. We introduced the prototyping stages for visualising the APR, presented particle-based rendering, and CPU-based maximum intensity projections of the APR, and finally outlined a new algorithm to render the APR in a similar way to volume renderings on the GPU via raytracing. 

In the future, we would like to finish the implementation of the raycasting algorithm, and evaluate the performance of the raycasting algorithm, especially on very large datasets exceeding multiple terabytes when stored as traditional pixel images. Additionally, we want to integrate the APR rendering methods into sciview.

__With _sciview — Integrating scenery into ImageJ2 & Fiji_,__ we have introduced sciview, a visualisation plugin for ImageJ2 & Fiji, based on the scenery framework. With sciview, we combine the advanced rendering and customisation capabilities of scenery, with a user-friendly interface in a software package that is widely used within the biomedical imaging community. We have shown how sciview harnesses the SciJava infrastructure for efficient integration into the ecosystem, and demonstrated example use cases, including the visualisation large data originating from the imaging of zebrafish vascular development, manually-constrained image segmentation, embryo simulation for ground truth generation, and visualisation of agent-based simulations. 

In the future, we would like to integrate sciview even tighter into the ecosystem and associated applications, and provide an actual VR interface for performing image analysis tasks, as such tasks at the moment still have to be performed with the regular menu structure in Fiji.

With these four case studies, we believe that we have demonstrated both theses stated above: In interactive ablation, VR is invaluable for exploration and understanding of the dataset, and scenery helped to rapidly prototype interactions. For track2track, scenery has provided the crucial underpinning, providing visualisation of large volumetric data, VR, and eye tracking support. With the demonstration of APR rendering, we have shown that scenery is a powerful toolkit even for unusual kinds of volumetric data, and finally, with sciview, we demonstrated scenery can be used to build applications and make VR available to a wider audience in the biomedical imaging community.




