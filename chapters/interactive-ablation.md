# Towards Interactive Virtual Reality Laser Ablation

The investigation of biological phenomena not only rests on observation of such, but also on the ability to interfere with them. Especially where biomechanical and biophysical questions need to be answered, _laser ablation_ or _microsurgery_ plays an important role and conveys the possibility to destroy cells or parts of tissues, while not interfering with their neighbours, in a manner much more precise than purely mechanical manipulation could achieve.

## Introduction to Microsurgery

### Biophysical Principles

For the interaction of light with biological tissue, five different regimes exist, depending on the applied power density. These are shown in table {@tbl:LaserInteractions}[@Niemz:2007laa].

\begin{marginfigure}
    \includegraphics{./figures/thermal_interaction.png}
    \caption{Coagulated tissue samples, a: Uterine tissue of a Wistar Rat, using a 10W continious wave laser, b: Human cornea coagulated with 120 pulses of $5\,\mathrm{mJ}$ from an Er:YAG laser. Reproduced from  \citep{Niemz:2007laa}.}
    \label{fig:thermal_interaction}
\end{marginfigure}

| Regime | Power density ($\mathrm{W}/\mathrm{m}^2$) | Exposure time (s) |
|:--|:--|:--|
| Photochemical interaction | $10^{-3}\,-\,10$ | $10+$ |
| Thermal interaction | $10\,-\,10^6$ | $10^{-5}\,-\,10$ |
| Photoablation | $10^6\,-\,10^{10}$ | $10^{-9}\,-\,10^{-6}$ |
| _Plasma-induced ablation_ | $10^{10}\,-\,10^{14}$ | $10^{-13}\,-\,10^{-10}$ |
| Photodisruption | $10^{11}\,-\,10^{16}$ | $10^{-12}\,-\,10^{-8}$ |

Table: Regimes for light interacting with biological tissue. {#tbl:LaserInteractions}

In case of photochemical interaction, chemical reactions are triggered by the application of laser light, with most of the effects origination from decay products of these chemicals, and not the laser itself[@Niemz:2007laa].

Thermal interaction in turn is characterized by non-local tissue damage due to vaporisation, coagulation, carbonisation or melting. This is not desirable for precise manipulation on the cellular or tissue level, as clearly visible in Figure \ref{fig:thermal_interaction}.

In case of very high plasma energies, _photodisruption_ occurs and is marked by both shock-wave generation and/or cavitation, which also leaves surrounding tissue damaged and is therefore not desirable for microsurgery.

Tuning down the energy density a bit, we come to the most useful regime for microsurgery on the cellular level: _plasma-induced ablation_ regime, highlighted in the table. This regime provides ablation of the target area by _optical breakdown_, confined to the focal point of the laser, with no damage around that area. Two examples are shown in \ref{fig:plasma_ablation}.


\begin{marginfigure}
    \includegraphics{./figures/plasma_ablation.png}
    \caption{a: Cut in a human cornea sample achieved with an picosecond Nd:YAG laser, b: $1x1mm^2$ cut in a human tooth sample with 16000 $1\,\mathrm{mJ}$ pulses, with cracking only due to EM sample preparation. Reproduced from  \citep{Niemz:2007laa}.}
    \label{fig:plasma_ablation}
\end{marginfigure}

Optical breakdown of tissue occurs when the applied electric field $\symbfit{E}$ exceeds the ionisation energy $\symbfit{E_I}$ of the molecules and atoms present. Ionisation then occurs within a few hundred picoseconds, and the radiation is absorbed by the created plasma. The plasma is created by an effect called _inverse Bremsstrahlung_[^bremsnote], where a free electron is accelerated by an inbound photon, which in turn collides with an atom, ionising it, and resulting in two new free electrons, with less kinetic energy, leading to an avalanche effect. Even if the original material was transparent, the plasma will be opaque to the incident radiation. This effect makes it possible to ablate areas that are otherwise transparent.

[^bremsnote]: _Inverse Bremsstrahlung_ is the opposite of the regular _Bremsstrahlung_ effect, where a high-velocity electron gets rapidly decelerated in an atom's electric field, emitting high-energy photons during the process.

## Example Use Cases

Laser ablation has found wide application in cellular biology, here we show a few examples from this wide variety:

* In [@Brugues:2012fx] the authors use femtosecond infrared laser ablation repeatedly to induce synchronous depolymerisation in _Xenopus_ metaphase spindles and by that are able to infer information about the length distribution of microtubule segments in the spindle.
* In [@Saha:2016ca8], the authors describe the use of a picosecond Nd:YAG laser for disruption of the cellular cortex of _C. elegans_ embryos and gastrulating _D. rerio_ embryos in order to determine its properties, which are modeled as a 2D film of a viscoelastic active gel.
* In [@Li:2014f0b], the authors use laser ablation and optogenetics to disrupt the _C. elegans_ AIY interneuron and by that are able to show it is important for locomotion and direction reversal of motion.
* In [@Li:20193c4], the authors use laser ablation to investigate the migration of Trunk Neural Crest cells in chick embryos. In the paper they partially eliminate the lamellipodium to investigate its role in cell-cell contact attraction in conjunction with cell-cell adhesion and find both play counteracting roles.

## Related work

While the use of virtual reality and associated interaction techniques for arbitrary laser ablation has not been demonstrated yet, various authors have made contributions in that direction: 

For starters, [@Engelbrecht:2007tt] demonstrate a SPIM-based microsurgery/laser ablation setup, powered by a $355\,\mathrm{nm}$ UV laser, which is able to perform multiple cuts with difficult geometries, and high precision in all three spatial dimensions, ranging from sub-micron precision for the ablation of microtubules to the cutoff of entire _D. rerio_ fins.

On the interaction side, [@Peng:2014bu] demonstrates the _Virtual Finger_ system to boost the precision of selection and tracing tasks in 3D environments, such as for neuron tracing, or in microsurgery settings. The authors employ a combination of raycasting together with region growing and shortest path determination for the precision enhancement of their methods.

[@Oswald:2010pr] demonstrates a versatile laser ablation setup on top of a confocal microscope that is able to perform cuts with rates in the $1\,\mathrm{kHz}$ range over an area of $100^2\,\mathrm{µm}$. In our proposed setup, we are going to use a lightsheet microscope of the SPIM variety to overcome the speed and phototoxicity issues of confocal microscopes in order to provide the user with instant feedback, and to treat the sample more gently, potentially for repeated application of cuts.

In terms of volumetric cuts, the authors of [@Brugues:2012fx] use a their femtosecond infrared laser to perform plane-like cuts composed of many, micrometer-spaced lines inside the spindle apparatus of a _Xenopus_ nucleus.

## Observations

\TODO{Ask Romina for wing disc example stack to show complex geometry, and Brugues lab for spindle}

From our survey of related works and use cases, we can observe the following:

Current interfaces for laser ablation usually utilise a 2D window with different controls for moving around, and often do not feature a 3D view of the specimen, as shown in Figure \ref{fig:LaserAblation2D}. Such systems provide support for planar cuts, in the form of lines, circles, or rectangles.

\begin{figure*}
    \includegraphics{./figures/LaserAblation2DInterface.png}
    \caption{A window-based 2D interface for laser ablation. Laser and stage controls for movement are shown in the tabs on the upper left, power controls for the ablation unit on the lower left. The view of the specimen is shown at the center, with the current cut overlaid as a circle. Reproduced from [@Oswald:2010pr].\label{ref:LaserAblation2D}}
\end{figure*}

Complex, three-dimensional cuts are very hard to perform on a regular screen from an interaction perspective —  it is very hard to translate from an image projected on a 2D screen to a — potentially moving — 3D volumetric specimen, and even with sophisticated techniques as in [@Peng:2014bu], it can become overwhelming for the user. Nevertheless, complex geometries need to be investigated in order to better understand the biophysics of e.g. the cellular cortex. 

Furthermore, it is preferable to use lightsheet microscopes for their superior speed and gentle imaging as instruments for 3D ablation purposes: Their particular way of mounting samples is extremely beneficial for quickly moving the sample in three directional axis plus one rotational axis, something that is not possible with e.g. confocal microscopes.

## First Prototype

As a first prototype, we developed a browser-based (threejs, [https://threejs.org](https://threejs.org)) prototype that makes use of the _LeapMotion_ gesture controller. A screenshot of the prototype can be seen in Figure \ref{fig:LMAblationPrototype}. The workflow of the prototype is

1. orient the specimen in the desired way by using keyboard and mouse,
2. form a circular structure with thumb and index finger, and draw the desired tubular structure into the aligned worm, and finally
3. a cylindrical tube is calculated from the defined circular samples via Centripetal Catmull-Rom spline interpolation[@Catmull:1974cf]. Catmull-Rom splines have been chosen here as they always go through their control points, and do not form cusps, which both are desirable properties for surfaces later to be used in laser ablation.

Within a limited user study, we identified two main issues with this approach:

1. Orientation of the specimen using keyboard and mouse is error-prone and was noted to be not very comfortable and intuitive, especially when combined with subsequent gestural interaction,
2. the gestural interaction was found to be imprecise, as a feeling of 3-dimensionality or immersion did not come up when being restricted to a regular, flat screen without any VR functionality.

We abandoned browser-based prototyping after this first iteration, as loading times were already too long when using the geometry model of 26MiB, and would be even longer if any volumetric data would be used — such data can easily reach many GiB. We want to note here that this initial experience also contributed to the decision to start the development of scenery, such that we can efficiently prototype software that enables interaction with geometry data, and large volumetric data.

![Screenshot of the _LeapMotion_-based interaction prototype, where the user has delineated a tubular structure along the _C. elegans_' gonad system. _C. elegans_ model courtesy of [openworm.org](https://www.openworm.org).\label{fig:LMAblationPrototype}](./figures/LeapMotionLaserAblationPrototype.png)

## Proposed Hardware Realisation

![3D rendering of the UV ablation module, original design by Michael Weber, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, Wisconsin, USA.\label{fig:UVcutterRendering}](./figures/ablation-module.png)

## Second Prototype

For the second prototype, we choose a VR setup using an HTC Vive HMD, with two controllers. The HTC Vive VR package is state-of-the-art at the time of writing, provides high-resolution displays for both eyes, and low-latency, hand-held controllers. In addition, the controllers can be augmented with additional devices, tracked by a small puck that can be attached to arbitrary objects, or even body parts for full-body tracking. We did however only use the hand-held controllers for this prototype.

### Description of study

In the prototype, the user is shown a pre-recorded, multi-timepoint dataset of a _C. elegans_ embryo in three-cell-stage. The embryo had been genetically engineered to express a fluorescent protein in it's DNA's histones, such that the chromosomes (and also the associated spindle apparatus orchestrating DNA condensation, duplication, and division) are visible. The time series dataset was played faster than realtime to evaluate quick decision making and the ability to perform cuts under time constraints. A screenshot of the prototype is shown in Figure \ref{fig:VRLaserAblationDemo}.

The users can control movement with the touchpad of the left-hand controller, and also move around physically, as they are being tracked by the VR system. The right-hand controller can then be used to activate a wand-like tool to designate areas for ablation. The prototype was designed such that there is no undo function, but a cut drawn, once finished, would be performed instantly.

For the study, we contacted 8 expert users of laser ablation and asked for their participation in the study. All of them agreed to take part after being informed about contents and goal of the study, and eventual risks and adverse health effects arising from the use of VR glasses. The tests subjects were not compensated for taking part in the study.

Before the start of the study, users were asked for their familiarity with smartphone-based VR, computer-based VR, and standalone VR, as well as for their current wellbeing.

After an introduction to the software and familiarisation with the dataset, the users were asked to perform the following tasks:

* perform several cuts in the chromosomes of the uppermost cell
* perform one triangular cut in centrosomes of the uppermost cell, and one in the centrosome of the lower cell
* perform several cuts in the metaphase plates that form in the lower cell after playing half the dataset.

Performing all of these tasks took 5 to 10 minutes per user.

After the study, the users were asked again for their wellbeing, for different aspects of the prototype, the likelihood of adoption of VR-steered laser ablation, as well as for simulator sickness using the SSQ scoring system \cite{kennedy1993}, a scoring system taking 16 different symptoms of discomfort — ranging over nausea, oculomotor, and disorientation symptoms —  into consideration to calculate a final, weighted score.  After filling out our questionaire, the users were asked to participate in an additional, voluntary interview, to ask detailed questions about their experience with the prototype. All of the users agreed to participate in the interview. 

\begin{figure}
    \includegraphics{./figures/vr_ablation_demo.png}
    \caption{Demonstration of a possible ablation modality utilising virtual reality on the mitotic spindle apparatus in a pre-recorded dataset showing a \emph{C. elegans} embryo undergoing mitosis. Dataset courtesy of Loïc Royer.\label{fig:VRLaserAblationDemo}}
\end{figure}

### Results — Acceptance and Potential Adoption

\begin{figure*}
    \includegraphics{./figures/VRAAdoption.pdf}
    \caption{Results of the adoption questions section of the study.\label{ref:VRAAdoption}}
\end{figure*}

### Results — Wellbeing and Simulator Sickness

All users tolerated the usage of the prototype very well. The changes in wellbeing before and after the study were minimal, with the most-reported problem being \TODO{add more information here}.

The average total SSQ score was $6.2\pm6.7$. Compared to the calibration sample in [@kennedy1993], this is a very low score, as only the 60th percentile was in that realm, and the mean of the calibration sample was $9.8\pm15.0$, nearly $1.5$-times the score in our study.

The users in the test had various degrees of previous exposure to VR systems before. We did not find a correlation between previous VR exposure and experience of discomfort or motion sickness. \TODO{Check this and add correlation values}.

### Results — Correlations

\begin{figure*}
    \includegraphics[height=14cm]{./figures/VRACorrelationShort.pdf}
    \caption{Correlations between questions in the questionnaire, only including SSQ summary score. For full correlation plot, please see \ref{fig:VRACorrelationFull}.\label{ref:VRACorrelation}}
\end{figure*}

### Requested Changes and Additions

In the interviews conducted after the study, users were asked to comment further on the presented prototype and suggest improvements and additions. For the next iteration, we decided to implement the following features and changes:

* __Confirm and Undo__: In addition to the regular freeform mode with immediate ablation after completing the drawing, another mode, where the target shape is drawn first, and confirmed after additional inspection was requested. In this mode, undo or erase will be possible  as well.
* __Brush size__: The ablation laser by default has a specific cut size. By combination of multiple shots, larger cuts can be created. In the interface, this can then be handled in a similar way as brush size adjustments in applications like _Photoshop_.
* __Template mode__: Many cuts the user has to perform are to be reproducible over a set of different specimen. For that reason, a template mode will be added, where a shape defined at one point can be reused later, optionally after translating, scaling or rotating it.
* __Semi-automatic Guides__: In 2D/3D or presentation applications, such as _Autodesk Maya_, _Adobe Photoshop_ or _Apple Keynote_, interactive guides exist to help the user with element alignment. Users often perform ablations relative to one or more specific landmarks, such as centrosomes in the mitotic spindle, or these dots in the Drosophila wingdisc \TODO{Ask Romina what these dots are called}. Semi-automatic guides will be added such that they can indicate to the user which are the best points or contours for ablation.
* __Toolbelt__: The already existing freeform mode will be combined into a toolbelt — e.g. attached to a VR controller, with the user being able to seamlessly switch between different tools. The toolbelt will also offer the possibility to create custom tools, e.g. by scripting.

These changes will be implemented in a future version of the software.