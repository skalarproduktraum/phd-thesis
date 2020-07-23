\mainmatter

\chapter*{Overview and Contributions}
\addcontentsline{toc}{chapter}{Overview and Contributions}

\section*{Current Trends and Challenges in Biology}

In the last three decades, biology has gone through a remarkable development from being a discipline that is mostly wetlab-based to one  utilising the tools and methods of mathematics, physics, and computer science, becoming more and more reliant and intertwined with them: 

To just highlight a few, developments on the experimental side like light-sheet fluorescence microscopy [@Huisken:2004ky], optogenetics [@Boyden:2005cd; @Li:2005ha], or Cryo-EM [@Adrian:1984vv] have opened new venues for investigation, while theoretical contributions, e.g. to active matter theory [@Mietke:2018b12] now shed more light on these results and provide analytical guidance.

Investigating biological systems in two dimensions has already led to fascinating and important results in the past (Drosophila embryonic genes, etc.). Building on these, and utilising the mathematical, physical, and computational techniques mentioned above, we are now able to investigate biological systems in three dimensions, and over time, and at high speed, enabling in-depth observation and reasoning about spatiotemporal processes.

Even more recent developments, like CRISPR/Cas9 [@Jinek:2012hm] or gene drives enable us to manipulate specimen in ways and on fast timescales thought impossible before. 

What these developments lack to a certain extent, are ways to again bring the experimenter into the loop, both during the experiment, and during analysis, to enable new and flexible ways of interacting the large and complex amounts of data state-of-the-art experiments create, and also with the scientific instruments producing this data.

\section*{Virtual and Augmented Reality}

With the advent of the first small-enough computers, and small-enough cathode-ray tubes (CRTs), the development of devices that give the user the ability to inhabit a virtual environment or use more than just a keyboard for input of data started. Early examples of such systems — from the 1960s — are The Sword of Damocles[@Sutherland:1968im] or the Sketchpad system[@Sutherland:1963kq], made famous as _The Mother of All Demos_. In the meantime, and over the course of two Virtual Reality Revolutions — with important developments like the CAVE (CAVE Automatic Virtual Environment, [@CruzNeira:1992fa]) —  head-mounted displays (HMDs) have now become a commodity and can be bought for about 400$, bringing a once highly specialised and expensive device into the homes  or offices of potential users.

Complimentary to these display devices, new input methods are also on the rise, such as free-air gesture input (e.g. the widely available Microsoft Kinect or the Leap Motion), free-air controller input (e.g., HTC Vive controllers), touch input (multitouch screens in nearly every contemporary mobile phone) or even devices controlled by the gaze of the user (such as eye trackers from Tobii or Pupil Labs). Such devices and their interaction modalities are commonly called Natural User Interfaces. 

Despite the common availability of VR display devices, or NUI input device, many of the analysis and visualisation tasks in bioimaging are still done on a 2D screen, using a keyboard and a mouse, while VR might actually provide tangible benefits, beyond just a quick "wow" effect.

\section*{Scope of this thesis and contributions}

In this thesis, we aim to demonstrate that the inclusion or Virtual  Reality and associated input devices, and advanced realtime rendering techniques can enhance the biologist's workflow, and enable new kinds of experiments, _in vivo_ and _in silico_.

To achieve this, we develop an open-source realtime rendering and interaction framework named _scenery_ that enables rapid prototyping of visualisations of geometric and volumetric biological data, and interaction with such on the basis of Natural User Interfaces. The framework supports rendering on regular desktop screens, virtual reality headsets (like the Oculus Rift or HTC Vive), and augmented reality headsets (like the Microsoft HoloLens). 

We will detail the architecture of the framework and demonstrate its necessity, utility and comprehensiveness on a set of case studies, and show further contributions made possible by the use of the framework.

Specifically, we will detail the following contributions:

* _scenery_, a framework for creating visualisation and interaction interfaces with both volumetric and geometric data, supporting virtual and augmented reality, and clustered rendering.
* _Bionic Tracking_, an algorithm for utilising the user's gaze to solve tracking problems involving moving particles and objects or tracing of neurons, implemented on top of _scenery_.
* _Towards interactive laser ablation_, where laser-based complex microsurgical procedures on microscopic specimens are enhanced and simplified by the use of virtual reality and natural user interfaces. A simulation of this workflow is also implemented on top of _scenery_ and a user study performed to show benefits and challenges, as well as identify issues.
* _Rendering the Adaptive Particle Representation_, where we introduce ideas how to render the highly-efficient, particle-based Adaptive Particle Representation (APR) [@Cheeseman:2018b12] of volumetric data. The APR  can be displayed as point-based graphics, as maximum intensity projection (MIP), or full volume rendering. All rendering algorithms are implemented on top of _scenery_.
* _sciview_, a plugin for the ImageJ2/Fiji ecosystem, make scenery's flexible visualisation solutions available to the end user.


\section*{Publications}

Some of the results presented in this thesis have already been published :

\subsection*{Peer-reviewed Papers}

* __Günther, U.__, Harrington, K.I.S.: Tales from the Trenches -- Developing sciview, a new 3D viewer for the ImageJ community. _VisGap workshop at Eurovis 2020_, Norrköping, Sweden. [arXiv preprint 2004.11897](https://arxiv.org/abs/2004.11897), [DOI 10.2312/visgap20201112](https://doi.org/10.2312/visgap20201112).
* __Günther, U.__, Pietzsch, T., Gupta, A., Harrington, K.I.S., Tomancak, P., Gumhold, S., and Sbalzarini, I.F.: scenery: Flexible Virtual Reality Visualization on the Java VM. _IEEE VIS_ 2019, Vancouver, Canada. [arXiv preprint 1906.06726](https://arxiv.org/abs/1906.06726), [DOI 10.1109/VISUAL.2019.8933605](https://doi.org/10.1109/VISUAL.2019.8933605).
* Daetwyler S., __Günther, U.__ , Modes, Carl D., Harrington, K.I.S., and Huisken, J.: Multi-sample SPIM image acquisition, processing and analysis of vascular growth in zebrafish. _Development_, 2019. [bioRxiv preprint 478149](https://www.biorxiv.org/content/10.1101/478149v1), [DOI 10.1242/dev.173757](https://doi.org10.1242/dev.173757).
* Cheeseman, B.L., __Günther, U.__, Susik, M., Gonciarz, K., and Sbalzarini, I.F.: Adaptive Particle Representation of Fluorescence Microscopy Images. _Nature Communications_, 9(5160), 2019. [bioRxiv preprint 263061](https://www.biorxiv.org/content/early/2018/03/02/263061), [DOI 10.1038/s41467-018-07390-9](https://doi.org/10.1038/s41467-018-07390-9)
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume: open-source live 3D visualization for light-sheet microscopy. _Nature Methods_, 2015. [DOI 10.1038/nmeth.3372](https://doi.org/10.1038/nmeth.3372).

\subsection*{Submitted Papers}

* __Günther, U.__, Harrington, K.I.S., Dachselt, Raimund, Sbalzarini, I.F.: Bionic Tracking: Using Eye Tracking to Track Biological Cells in Virtual Reality. _Submitted to BioImageComputing at ECCV 2020_. [arXiv preprint 2005.00387](https://arxiv.org/abs/2005.00387).
* Arshadi, C., Eddison, M., __Günther, U.__, Harrington, K.I.S., Ferreira, T.A.: SNT: A Unifying Toolbox for Quantification of Neuronal Anatomy. _Submitted to Nature Methods_. [bioRxiv preprint 2020.07.13.179325](https://www.biorxiv.org/content/10.1101/2020.07.13.179325v1).

\subsection*{Conference Abstracts}


* Gupta, A., __Günther, U.__, Incardona, P., Aydin, A.D., Dachselt, R., Gumhold, S., Sbalzarini, I.F.: A Framework for Interactive Virtual Reality _In Situ_ Visualisation of Parallel Numerical Simulations. _The 9th IEEE Symposium on Large Data Analysis and Visualization at IEEE VIS_, 2019. [arXiv preprint 1909.02986](https://arxiv.org/abs/1909.02986), [DOI 10.1109/LDAV48142.2019.8944368](https://doi.org/10.1109/LDAV48142.2019.8944368).
* __Günther, U.__, Pietzsch, T., Rueden, C., Daetwyler, S., Huisken, J., Elicieri, K., Tomancak, P., Sbalzarini, I.F., Harrington, K.I.S.: sciview - Next-generation 3D visualisation for ImageJ & Fiji, _From Images to Knowledge with ImageJ and Friends_, EMBL Heidelberg, 2018
* __Günther, U.__, Harrington, K.I.S., Sbalzarini, I.F.: Exploring the scenery of lightsheet microscopy with virtual reality, _LSFM2018_, Dresden, 2018.
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume - from microscope to visualisation in seconds, _VizBi_, EMBL Heidelberg, 2016.
* Royer, L.A., Weigert, M., __Günther, U.__, Maghelli, N., Jug, F., Sbalzarini, I.F. and Myers, E.W.: ClearVolume - open-source 4D live visualisation for light-sheet microscopy. _Focus on Microscopy_, Göttingen, 2015.
* __Günther, U.__, Cheeseman, B.L., Tomancak, P., Sbalzarini, I.F.: dive into data — immersive 3D particle visualisation, _BioImageInformatics_, Leuven, 2014.

\subsection*{Papers in Preparation}

The following papers containing material from this work are currently under preparation:

* __Günther, U.__, Pietzsch, T., Rueden, C., Daetwyler, S., Huisken, J., Elicieri, K., Tomancak, P., Sbalzarini, I.F., Harrington, K.I.S.: sciview - Next-generation 3D visualisation for ImageJ & Fiji.
* __Günther, U.__, Simson, J., Sbalzarini, I.F., Harrington, K.I.S.: Linear Genetic Programming for robust pupil detection in interactive, virtual reality eye tracking applications.

\section*{Supervision}

The following students have been supervised by the author in the duration of the thesis:

* Sahil Loomba, intern, May - August 2014.
* Aryaman Gupta, intern and master student, June - December 2017.
* Luke J. Hyman, intern, August - September 2018.


\section*{What follows}

In the following, first part of the thesis we are going to introduce the basic concepts and technologies as the _Preliminaries_ that have ultimately led to the challenges addressed in this thesis. We start with _fluorescence microscopy_, describing the developments from first light microscopes to modern lightsheet volumetric microscopes, followed by a chapter about _visual processing_, detailing the detection and processing of visual information in the human nervous system. The visual processing chapter is followed by the _XR_ chapter, describing the historic and current developments in virtual and augmented reality, together termed as _cross reality_, or _XR_. The final chapter of the preliminaries part introduces _Eye Tracking and Gaze-based interaction_, going into detail how a mode of perception can also be used for control purposes. At the end of each of _preliminaries_ chapters, we state specific challenges that will be addressed in the _Case Studies_ in Part Three of this thesis. In Part Two, we describe our visualisation framework _scenery_ in detail, which is the enabling technology for the case studies described in Part Three. Finally, in Part Four, we are going to conclude our findings and provide an outlook to future work.


