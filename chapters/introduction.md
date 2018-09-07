\mainmatter
\part{Introduction}

# Introduction

## The State of Biology

In recent years, biology has made a remarkable jump from being a discipline that is mostly wetlab-based to a a discipline utilising the tools and methods of mathematics, physics and computer science. 

Developments on the experimental side like light-sheet fluorescence microscopy [@Huisken:2004ky], optogenetics [@Boyden:2005cd; @Li:2005ha] or Cryo-EM [@Adrian:1984vv] have opened new venues for investigation, while theoretical contributions like active matter theory (cite) or ... now shed more light on these results.

Investigating biological systems in two dimensions have already led to remarkable results in the past (Drosophila embryonic genes, etc.). Building on these, and utilising the techniques mentioned above, we are now able to investigate biological systems in three dimensions, and over time, making correct reasoning about spatiotemporal processes a reality. 

Even more recent developments, like CRISPR/Cas9 [@Jinek:2012hm] or gene drives enable us to manipulate specimen in ways and on timescales thought impossible before. 

All of these need new, flexible ways of interacting with the large amounts of data produced, and with the instruments producing this data.

## Virtual and Augmented Reality

With the advent of the first small-enough computers, and small-enough cathode-ray tubes (CRTs), the development of devices that give the user the ability to inhabit a virtual environment or use more than just a keyboard for input of data started. Early examples of such systems are The Sword of Damocles[@Sutherland:1968im] or the Sketchpad system[@Sutherland:1963kq] from the 1960s. In the meantime, and over the course of two Virtual Reality Revolutions -- with important developments like the CAVE (CAVE Automatic Virtual Environment, [@CruzNeira:1992vt]) --  head-mounted displays (HMDs) have now become a commodity and can be bought for about 400$, bringing a once highly expensive, specialised device into the homes of users.

## Natural User Interfaces

Complimentary to these display devices, new input methods are also on the rise, such as free-air gesture input (e.g. the widely available Microsoft Kinect), touch input (multitouch screens in nearly every contemporary mobile phone) or even devices controlled by the gaze of the user (Tobii, cite). Such devices and their interaction modalities are commonly called Natural User Interfaces (NUIs, cite).

## Scope of this thesis and contributions

In this thesis, we aim to demonstrate that the inclusion of natural user interfaces, combined with Virtual or Augmented Reality, and advanced realtime rendering techniques can enhance the biologist's workflow, and enable new kinds of experiments, _in vivo_ and _in silico_.

To achieve this, we develop an open-source realtime rendering and interaction framework named _scenery_ that enables rapid prototyping of visualisations of biology data, and interaction with such data on the basis of Natural User Interfaces. This framework supports rendering on regular desktop screens, virtual reality headsets (like the Oculus Rift or HTC Vive), and augmented reality headsets (like the Microsoft HoloLens). 

We will detail the architecture of the framework and demonstrate its necessity, utility and comprehensiveness on a set of case studies, and show further contributions made possible by the use of the framework.

Specifically, we will detail the following contributions:

* _scenery_, a framework for creating visualisation and interaction interfaces with both volumetric and geometric data, supporting virtual and augmented reality, and clustered rendering.
* _SciView_, a plugin for the Fiji/ImageJ ecosystem, make scenery's flexible visualisation solutions available to the end user.
* rendering the _Adaptive Particle Representation_[@Cheeseman:ia], which can be displayed as point-based graphics, as maximum intensity projection (MIP), or full volume rendering. The APR is a new computational particle-based representation of image and volume data that can significantly reduce both storage and processing cost. All rendering algorithms are implemented on top of _scenery_.
* _attentive tracking_, an algorithm for utilising the user's gaze to solve tracking problems involving moving particles and objects or tracing of neurons, implemented on top of _scenery_.
* _interactive laser ablation_, where laser-based complex microsurgical procedures on microscopic specimens are enhanced and simplified by the use of virtual reality and natural user interfaces. A simulation of this workflow is also implemented on top of _scenery_.

## Publications

Some of the results presented in this thesis have already been published :

### Peer-reviewed Papers

* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W., 2015. _ClearVolume: open-source live 3D visualization for light-sheet microscopy_. _Nature Methods_, 12(6), p.480.
* Cheeseman, B.L., __Günther, U.__, Susik, M., Gonciarz, K., and Sbalzarini, I.F., 2018. _Forget Pixels: Adaptive Particle Representation of Fluorescence Microscopy Images_. ([bioRxiv preprint](https://www.biorxiv.org/content/early/2018/03/02/263061), under revision at _Nature Communications_)

### Conference Abstracts

* __Günther, U.__, Cheeseman, B.L., Tomancak, P., Sbalzarini, I.F.: _dive into data — immersive 3D particle visualisation_, _BioImageInformatics_, Leuven, 2014
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: _ClearVolume - open-source 4D live visualisation for light-sheet microscopy_. _Focus on Microscopy_, Göttingen, 2015
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: _ClearVolume - from microscope to visualisation in seconds_, _VizBi_, EMBL Heidelberg, 2016
* __Günther, U.__, Harrington, K.I.S., Sbalzarini, I.F.: _Exploring the scenery of lightsheet microscopy with virtual reality_, _LSFM2018_, Dresden

### Supervision

The following students have been supervised by the author in the duration of the thesis:

* Sahil Loomba, intern
* Aryaman Gupta, intern and master student


