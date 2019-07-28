\mainmatter

\chapter*{Introduction}
\addcontentsline{toc}{chapter}{Introduction}

\section*{Current Trends and Challenges in Biology}

In the last three decades, biology has gone through a remarkable development from being a discipline that is mostly wetlab-based to one  utilising the tools and methods of mathematics, physics, and computer science, becoming more and more reliant and intertwined with them: 

To just highlight a few, developments on the experimental side like light-sheet fluorescence microscopy [@Huisken:2004ky], optogenetics [@Boyden:2005cd; @Li:2005ha], or Cryo-EM [@Adrian:1984vv] have opened new venues for investigation, while theoretical contributions, e.g. to active matter theory [@Mietke:2018b12] now shed more light on these results and provide analytical guidance.

Investigating biological systems in two dimensions has already led to fascinating and important results in the past (Drosophila embryonic genes, etc.). Building on these, and utilising the mathematical, physical, and computational techniques mentioned above, we are now able to investigate biological systems in three dimensions, and over time, and at high speed, enabling in-depth observation and reasoning about spatiotemporal processes.

Even more recent developments, like CRISPR/Cas9 [@Jinek:2012hm] or gene drives enable us to manipulate specimen in ways and on fast timescales thought impossible before. 

What these developments lack to a certain extent, are ways to again bring the experimenter into focus, both during the experiment, and during analysis, to enable new and flexible ways of interacting the large and complex amounts of data state-of-the-art experiments create, and also with the scientific instruments producing this data.

\section*{Virtual and Augmented Reality}

With the advent of the first small-enough computers, and small-enough cathode-ray tubes (CRTs), the development of devices that give the user the ability to inhabit a virtual environment or use more than just a keyboard for input of data started. Early examples of such systems — from the 1960s — are The Sword of Damocles[@Sutherland:1968im] or the Sketchpad system[@Sutherland:1963kq], made famous as _The Mother of All Demos_. In the meantime, and over the course of two Virtual Reality Revolutions — with important developments like the CAVE (CAVE Automatic Virtual Environment, [@CruzNeira:1992vt]) —  head-mounted displays (HMDs) have now become a commodity and can be bought for about 400$, bringing a once highly specialised and expensive device into the homes  or offices of potential users.

\section*{Natural User Interfaces}

Complimentary to these display devices, new input methods are also on the rise, such as free-air gesture input (e.g. the widely available Microsoft Kinect or the Leap Motion), touch input (multitouch screens in nearly every contemporary mobile phone) or even devices controlled by the gaze of the user (such as eye trackers from Tobii or Pupil Labs). Such devices and their interaction modalities are commonly called Natural User Interfaces (NUIs, cite).

\section*{Scope of this thesis and contributions}

In this thesis, we aim to demonstrate that the inclusion of natural user interfaces, combined with Virtual or Augmented Reality, and advanced realtime rendering techniques can enhance the biologist's workflow, and enable new kinds of experiments, _in vivo_ and _in silico_.

To achieve this, we develop an open-source realtime rendering and interaction framework named _scenery_ that enables rapid prototyping of visualisations of geometric and volumetric biological data, and interaction with such on the basis of Natural User Interfaces. The framework supports rendering on regular desktop screens, virtual reality headsets (like the Oculus Rift or HTC Vive), and augmented reality headsets (like the Microsoft HoloLens). 

We will detail the architecture of the framework and demonstrate its necessity, utility and comprehensiveness on a set of case studies, and show further contributions made possible by the use of the framework.

Specifically, we will detail the following contributions:

* _scenery_, a framework for creating visualisation and interaction interfaces with both volumetric and geometric data, supporting virtual and augmented reality, and clustered rendering.
* rendering the _Adaptive Particle Representation_[@Cheeseman:2018b12], which can be displayed as point-based graphics, as maximum intensity projection (MIP), or full volume rendering. The APR is a new computational particle-based representation of image and volume data that can significantly reduce both storage and processing cost. All rendering algorithms are implemented on top of _scenery_.
* _track2track_, an algorithm for utilising the user's gaze to solve tracking problems involving moving particles and objects or tracing of neurons, implemented on top of _scenery_.
* _interactive laser ablation_, where laser-based complex microsurgical procedures on microscopic specimens are enhanced and simplified by the use of virtual reality and natural user interfaces. A simulation of this workflow is also implemented on top of _scenery_.
* _SciView_, a plugin for the Fiji/ImageJ ecosystem, make scenery's flexible visualisation solutions available to the end user.


\section*{Publications}

Some of the results presented in this thesis have already been published :

\subsection*{Peer-reviewed Papers}

* __Günther, U.__, Pietzsch, T., Gupta, A., Harrington, K.I.S., Tomancak, P., Gumhold, S., and Sbalzarini, I.F.: scenery — scenery – Flexible Virtual Reality Visualisation on the Java VM. Submitted to _IEEE VIS_, 2019, [arXiv preprint 1906.06726](https://arxiv.org/abs/1906.06726)
* Daetwyler S., __Günther, U.__ , Modes, Carl D., Harrington, K.I.S., and Huisken, J.: Multi-sample SPIM image acquisition, processing and analysis of vascular growth in zebrafish. _Development_, 2019, [bioRxiv preprint 478149](https://www.biorxiv.org/content/10.1101/478149v1)
* Cheeseman, B.L., __Günther, U.__, Susik, M., Gonciarz, K., and Sbalzarini, I.F.: Adaptive Particle Representation of Fluorescence Microscopy Images. _Nature Communications_, 9(5160), 2019, [bioRxiv preprint 263061](https://www.biorxiv.org/content/early/2018/03/02/263061)
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume: open-source live 3D visualization for light-sheet microscopy. _Nature Methods_, 12(6), p.480, 2015



\subsection*{Conference Abstracts}


* __Günther, U.__, Pietzsch, T., Rueden, C., Daetwyler, S., Huisken, J., Elicieri, K., Tomancak, P., Sbalzarini, I.F., Harrington, K.I.S.: sciview - Next-generation 3D visualisation for ImageJ & Fiji, _From Images to Knowledge with ImageJ and Friends_, EMBL Heidelberg, 2018
* __Günther, U.__, Harrington, K.I.S., Sbalzarini, I.F.: Exploring the scenery of lightsheet microscopy with virtual reality, _LSFM2018_, Dresden, 2018
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume - from microscope to visualisation in seconds, _VizBi_, EMBL Heidelberg, 2016
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume - open-source 4D live visualisation for light-sheet microscopy. _Focus on Microscopy_, Göttingen, 2015
* __Günther, U.__, Cheeseman, B.L., Tomancak, P., Sbalzarini, I.F.: dive into data — immersive 3D particle visualisation, _BioImageInformatics_, Leuven, 2014

\subsection*{Papers in Preparation}

The following papers containing material from this work are currently under preparation:

* __Günther, U.__, Pietzsch, T., Rueden, C., Daetwyler, S., Huisken, J., Elicieri, K., Tomancak, P., Sbalzarini, I.F., Harrington, K.I.S.: sciview - Next-generation 3D visualisation for ImageJ & Fiji.
* __Günther, U.__, Simson, J., Sbalzarini, I.F., Harrington, K.I.S.: Linear Genetic Programming for robust pupil detection in interactive, virtual reality eye tracking applications.

\section*{Supervision}

The following students have been supervised by the author in the duration of the thesis:

* Sahil Loomba, intern, May - August 2014.
* Aryaman Gupta, intern and master student, June - December 2017.


\section*{What follows}

In the following, first part of the thesis we are going to introduce the basic concepts and technologies as the _Preliminaries_ that have ultimately led to the challenges addressed in this thesis. We start with _fluorescence microscopy_, describing the developments from first light microscopes to modern lightsheet volumetric microscopes, followed by a chapter about _visual processing_, detailing the detection and processing of visual information in the human nervous system. The visual processing chapter is followed by the _XR_ chapter, describing the historic and current developments in virtual and augmented reality, together termed as _cross reality_, or _XR_. The final chapter of the preliminaries part introduces _Eye Tracking and Gaze-based interaction_, going into detail how a mode of perception can also be used for control purposes. At the end of each of _preliminaries_ chapters, we state specific challenges that will be addressed in the _Case Studies_ in Part Three of this thesis. In Part Two, we describe our visualisation framework _scenery_ in detail, which is the enabling technology for the case studies in Part Three. Finally, in Part Four, we are going to conclude our findings and provide an outlook to future work.


