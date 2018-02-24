# Introduction

## The State of Biology

In recent years, biology has made a remarkable jump from being a discipline that is entirely wetlab-based to a a discipline utilising the tools and methods of mathematics, physics and computer science. Developments on the experimental side like light-sheet fluorescence microscopy [@Huisken:2004ky], optogenetics [@Boyden:2005cd,@Li:2005ha] or Cryo-EM [@Adrian:1984vv] have opened new venues for investigation, while theoretical contributions like active matter theory (cite) or ... now shed more light on these results.

Investigating biological systems in two dimensions have already led to remarkable results in the past (Drosophila embryonic genes, etc.). Building on these, and utilising the techniques mentioned above, we are now able to investigate biological systems in three dimensions, and over time, making correct reasoning about spatiotemporal processes a reality. 

Even more recent developments, like CRISPR/Cas9 [@Jinek:2012hm] or gene drives enable us to manipulate specimen in ways and on timescales thought impossible before. 

All of these need new, flexible ways of interacting with the data produced, and with the instruments producing this data.

## Virtual and Augmented Reality

With the advent of the first small-enough computers, and small-enough cathode-ray tubes (CRTs), the development of devices that give the user the ability to inhabit a virtual environment or use more than just a keyboard for input of data started. Early examples of such systems are The Sword of Damocles (cite) or the Sketchpad system (cite) from the 1960s. In the meantime, and over the course of two Virtual Reality Revolutions -- with important developments like the CAVE (CAVE Automatic Virtual Environment, [@CruzNeira:1992vt]) --  head-mounted displays (HMDs) have now become a commodity and can be bought for about 400$, bringing a once highly expensive, specialised device into the homes of users.

## Natural User Interfaces

Complimentary to these display devices, new input methods are also on the rise, such as free-air gesture input (e.g. the widely available Microsoft Kinect), touch input (multitouch screens in nearly every contemporary mobile phone) or even devices controlled by the gaze of the user (Tobii, cite). Such devices and their interaction modalities are commonly called Natural User Interfaces (NUIs, cite).

## Scope of this thesis and contributions

In this thesis, we develop an open-source framework named _scenery_ that enables rapid prototyping of visualisations of biology data, and interaction with such data on the basis of Natural User Interfaces. This framework supports rendering on regular screens, virtual reality headsets (like the Oculus Rift or HTC Vive), and augmented reality headset (like the Microsoft HoloLens). We will demonstrate the necessity, utility and comprehensiveness of such a framework on a set of case studies and show further contributions made possible by the use of the framework.

We will detail the following contributions:

* _scenery_, a framework for creating visualisation and interaction interfaces with both volumetric and geometric data, supporting virtual and augmented reality, and clustered rendering.
* rendering models for the _Adaptive Particle Representation_ (APR) (cite), which can be displayed as point-based graphics, as maximum intensity projection (MIP), or full volume rendering. The APR is a new computational particle-based representation of image and volume data that can significantly reduce both storage and processing cost. All rendering algorithms are implemented on top of _scenery_.
* _attentive tracking_, an algorithm for utilising the user's gaze to solve tracking problems involving moving particles and objects or tracing of neurons, implemented on top of _scenery_.
* _interactive laser ablation_, where laser-based complex microsurgical procedures on microscopic specimens are enhanced and simplified by the use of virtual reality and natural user interfaces. A simulation of this workflow is also implemented on top of _scenery_.

### Publications

The following peer-reviewed papers have been published from parts of this work:

* Royer, L.A., Weigert, M., _Günther, U._, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W., 2015. __ClearVolume: open-source live 3D visualization for light-sheet microscopy__. _Nature Methods_, 12(6), p.480.
* Cheeseman, B.L.,  _Günther, U._, Susik, M., Gonciarz, K., and Sbalzarini, I.F., 2018. __The Adaptive Particle Representation (APR) for efficient storage and computation on LSFM images__. (Preprint)

### Supervision

The following students have been supervised by the author in the duration of the thesis:

* Sahil Loomba, intern
* Aryaman Gupta, intern and master student