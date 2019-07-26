# Towards Interactive Virtual Reality Laser Ablation

The investigation of biological phenomena not only rests on observation of such, but also on the ability to interfere with them. Especially where biomechanical and biophysical questions need to be answered, _laser ablation_ or _microsurgery_ plays an important role and conveys the possibility to destroy cells or parts of tissues, while not interfering with their neighbours, in a manner much more precise than purely mechanical manipulation could achieve.

Nowadays, experiments in this realm are carried out with simple slice-based 2D user interfaces, while the specimen and processes investigated get spatiotemporally more and more complex. 

In this chapter, we introduce the use of virtual reality to microsurgery to overcome this problem. We present two prototypes that we developed to investigate user satisfaction and compatibility, and propose a microscope design that will incorporate an ablation system that can be steered in virtual reality. The prototypes presented require flexible visualisation of both geometric data and large, time-series volumetric data, as well as integration of additional hardware such as VR HMDs and controllers, we show how our visualisation framework, introduced in the chapter [scenery — Democratising VR/AR Visualisation for Systems Biology], enabled those developments. First, we start with an introduction to microsurgery and the underlying biophysical principles.

## Introduction to Microsurgery

For the interaction of light with biological tissue, five different regimes exist, depending on the applied power density. These are shown in table {@tbl:LaserInteractions}[@Niemz:2007laa].

\begin{marginfigure}
    \includegraphics{thermal_interaction.png}
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

In case of _photochemical interaction_, chemical reactions are triggered by the application of laser light, with most of the effects originate from decay products of these chemicals, and not the laser itself[@Niemz:2007laa].

_Thermal interaction_ in turn is characterized by extended tissue damage due to vaporisation, coagulation, carbonisation or melting. This is not desirable for precise manipulation on the cellular or tissue level, as clearly visible in Figure \ref{fig:thermal_interaction}.

In case of very high plasma energies, _photodisruption_ occurs and is marked by both shock-wave generation and/or cavitation, which also leaves surrounding tissue damaged and is therefore not desirable for microsurgery.

Tuning down the energy density by one to two orders of magnitude, we come to the most useful regime for microsurgery on the cellular level: the _plasma-induced ablation_ regime, highlighted in the table. This regime provides ablation of the target area by _optical breakdown_, confined to the focal point of the laser, with no damage around that area. Two examples are shown in \ref{fig:plasma_ablation}.


\begin{marginfigure}
    \includegraphics{plasma_ablation.png}
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

In [@Engelbrecht:2007tt], the authors demonstrate a SPIM-based microsurgery/laser ablation setup, powered by a $355\,\mathrm{nm}$ UV laser, which is able to perform multiple cuts with difficult geometries, and high precision. Most importantly, this is to our knowledge the first paper where cuts in all three spatial dimensions were demonstrated, ranging from sub-micron precision for the ablation of microtubules to the cutoff of entire _D. rerio_ fins.

On the interaction side, [@Peng:2014bu] demonstrated the _Virtual Finger_ system to boost the precision of selection and tracing tasks in 3D environments, such as for neuron tracing, or in microsurgery settings. The authors employ a combination of raycasting together with region growing and shortest path determination for the precision enhancement of their methods.

[@Oswald:2010pr] demonstrated a versatile laser ablation setup on top of a confocal microscope that is able to perform cuts with rates in the $1\,\mathrm{kHz}$ range over an area of $100 \times 100\,\mathrm{µm}^2$. 

In terms of volumetric cuts, the authors of [@Brugues:2012fx] used a femtosecond infrared laser to perform plane-like cuts composed of many, micrometer-spaced lines inside the spindle apparatus of a _Xenopus_ nucleus.

## Observations

\TODO{Ask Romina for wing disc example stack to show complex geometry, and Brugues lab for spindle}

From our survey of related works and use cases in the previous section, we observe the following:

Current interfaces for laser ablation often do not feature a 3D view of the specimen, but usually utilise a 2D window with different controls for moving around, as shown in Figure \ref{fig:LaserAblation2D}. Such systems provide support for planar cuts, in the form of lines, circles, and rectangles.

\begin{figure*}
    \includegraphics{LaserAblation2DInterface.png}
    \caption{A window-based 2D interface for laser ablation. Laser and stage controls for movement are shown in the tabs on the upper left, power controls for the ablation unit on the lower left. The view of the specimen is shown at the center, with the current cut overlaid as a circle. Reproduced from \citep{Oswald:2010pr}.\label{fig:LaserAblation2D}}
\end{figure*}

Complex, three-dimensional cuts are hard to perform on a regular screen from an interaction perspective —  it is hard to translate from an image projected on a 2D screen to a — potentially moving — 3D volumetric specimen, and even with sophisticated techniques as in [@Peng:2014bu], it can become overwhelming for the user. Nevertheless, complex geometries need to be investigated in order to better understand the biophysics of, e.g., the cellular cortex.

Most of the systems surveyed use a confocal microscope as a basis. In many use cases, lightsheet microscopes could be used for their superior speed and gentle imaging as instruments for 3D ablation purposes. Their particular way of mounting samples can beneficial for quickly moving the sample in three directional axis plus one rotational axis, something that is not possible with e.g. confocal microscopes. Even if the sample requires to be mounted on a microscopy slide, variations of the original lightsheet microscope design exist that have similar geometries as confocal microscopes.

## First Prototype

As a first prototype, we developed a browser-based (threejs, [https://threejs.org](https://threejs.org)) prototype that makes use of the _LeapMotion_ gesture controller. In the prototype, the user can perform tubular cuts in a simulated geometry of a _C. elegans_ adult worm using the gesture controller. The process is visualised on the user's computer screen and does not use any VR visualisation techniques. A screenshot of the prototype can be seen in Figure \ref{fig:LMAblationPrototype}. The workflow of the prototype is

1. orient the specimen of _C. elegans_ in the desired way by using keyboard and mouse,
2. form a circular structure with thumb and index finger, and draw the desired tubular structure into the aligned worm, and finally
3. a cylindrical tube is calculated from the defined circular samples via Centripetal Catmull-Rom spline interpolation[@Catmull:1974cf]. Catmull-Rom splines have been chosen here as they always go through their control points, and do not form cusps, which both are desirable properties for surfaces later to be used in laser ablation.

We identified two major issues with this approach:

1. Orientation of the specimen using keyboard and mouse is error-prone and was noted to be not very comfortable and intuitive, especially when combined with subsequent gestural interaction,
2. the gestural interaction was found to be imprecise, as a feeling of 3-dimensionality or immersion did not come up when being restricted to a regular, flat screen without any VR functionality.

We abandoned browser-based prototyping after this first iteration, as loading times were already too long when using the geometry model of 26MiB, and would be even longer if any volumetric data would be used — such data can easily reach many GiB. We want to note here that this initial experience also contributed to the decision to start the development of scenery, such that we can efficiently prototype software that enables interaction with geometry data, and large volumetric data.

![Screenshot of the _LeapMotion_-based interaction prototype, where the user has delineated a tubular structure along the _C. elegans_' gonad system. _C. elegans_ model courtesy of [openworm.org](https://www.openworm.org).\label{fig:LMAblationPrototype}](LeapMotionLaserAblationPrototype.png)

## Second Prototype

\begin{figure}
    \includegraphics{vr_ablation_demo.png}
    \caption{Screenshot of the second virtual reality-powered laser ablation prototype. In the prototype, we show the mitotic spindle apparatus in a pre-recorded dataset showing a \emph{C. elegans} embryo undergoing mitosis. The tube-like objects in the center of the image are the condensing chromosomes in the cell nucleus, in the process of being separated by the mitotic spindle. The task of the user is to draw in cuts using VR controllers. See text for a full description. Dataset courtesy of Loïc Royer (MPI-CBG/CZI).\label{fig:VRLaserAblationDemo}}
\end{figure}

The software for the second prototype was developed with our visualisation framework _scenery_, described in detail in the chapter [scenery — Democratising VR/AR Visualisation for Systems Biology]. We switched away from browser-based prototyping, as the amounts of volumetric data required to be handled in the demo are too large for browser-based software, and because _scenery_ is an ideal toolkit for such prototype, due to its support for large volumetric data and VR devices. We choose a VR setup using an HTC Vive HMD with two controllers. The HTC Vive VR package is state-of-the-art at the time of writing, provides high-resolution displays for both eyes and low-latency, hand-held controllers. In addition, the controllers can be augmented with additional devices, tracked by a small puck that can be attached to arbitrary objects, or even body parts for full-body tracking. We did however only use the hand-held controllers for this prototype.

### Description of study

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/VRAblationPrototype.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video demo of the VR ablation prototype. For a list of supplementary videos see \href{https://ulrik.is/thesising/supplement/}{ulrik.is/thesising/supplement/}.
\end{marginfigure}

In the prototype, the user is shown a pre-recorded, multi-timepoint dataset of a _C. elegans_ embryo in three-cell-stage. The embryo had been genetically engineered to express a fluorescent protein in the histones of its DNA, such that the chromosomes (and, to a lesser extent, the associated spindle apparatus orchestrating DNA condensation, duplication, and division) are visible. The time series dataset was played faster than realtime to evaluate quick decision making and the ability to perform cuts under time constraints. A screenshot of the prototype is shown in Figure \ref{fig:VRLaserAblationDemo}.

\begin{marginfigure}
    \includegraphics{vive-controllers-vra.pdf}
    \caption{Controls for second prototype\label{fig:VRAControllers}. Vive controller drawing from VIVEPORT Developer Documentation, \href{https://developer.viveport.com}{developer.viveport.com}.}
\end{marginfigure}

The users can control movement with the touchpad of the left-hand controller, and also move around physically, as they are being tracked by the VR system in an area of about 2m by 3m. The right-hand controller can then be used to activate a wand-like tool to designate areas for ablation. See \ref{fig:VRAControllers} for a visual representation of the controls.

For simplicity, the prototype was designed such that there is no undo function, but a cut drawn, once finished, would be performed instantly. In real use, this is most probably not a universal solution, but may have benefits in certain situations, where interaction speed has a higher priority than precision.

We conducted a study with 8 experts in laser ablation (average age of 31, 4 female, 4 male, all right-handed, and recruited from different labs of the Max Planck Institute of Molecular Cell Biology and Genetics). The study subjects were informed about contents and goal of the study, and eventual risks and adverse health effects arising from the use of VR glasses. The study subjects were not compensated for taking part in the study.

Before the start of the study, users were asked about their familiarity with smartphone-based VR, computer-based VR, and standalone VR, as well as for their current wellbeing.

After an introduction to the software and familiarisation with the dataset, the users were asked to perform the following tasks:

* perform several cuts in the chromosomes of the uppermost cell
* perform one triangular cut in centrosomes of the uppermost cell, and one in the centrosome of the lower cell
* perform several cuts in the metaphase plates that form in the lower cell after playing half the dataset.

Performing all of these tasks took 5 to 10 minutes per user.

After the study, the users were asked about the following aspects:

*  again, for their wellbeing, 
*  for different aspects of the prototype, the likelihood of adoption of VR-steered laser ablation, 
*  for physical and mental demands, assessed by the NASA-TLX (_Task Load Index_) [@Hart:1988tlx] scoring system, and
*  for symptoms of simulator sickness using the SSQ scoring system \citep{kennedy1993} (SSQ takes 16 different symptoms of discomfort — ranging over nausea, oculomotor, and disorientation symptoms —  into consideration to calculate a final, weighted score).

For standardised evaluation, we choose NASA-TLX and SSQ, as they perfectly match our application setting, do not interfere with the study process itself, and have been widely used and validated. Newer methods to assess motion sickness in real or virtual environments, such as [@keshavarz2011] have not been used, as they have been designed to assess motion sickness during the course of the study, which would have caused interference with the tasks the user were asked to perform.

After filling out our questionnaire, the users were asked to participate in an additional, voluntary interview, to ask detailed questions about their experience with the prototype. All of the users agreed to participate in the follow-up interview. 


### Results — General Questions

\begin{figure*}
    \includegraphics{VRAGeneral.pdf}
    \caption{Results of the general questions section of the user study.\label{fig:VRAGeneral}}
\end{figure*}

Results for the general questions section of the study questionnaire are shown in Figure \ref{fig:VRAGeneral}. Users were universally satisfied with the quality and usability of the prototype, and were not irritated by having to perform tasks in VR they were previously only used to with 2D interfaces. They generally reported that showing the dataset in human size scales and positions — in the study, the dataset is shown with a height of $1.5\,\mathrm{m}$, hovering $1.5\,\mathrm{m}$ above (virtual) ground — was well chosen. They did not have trouble learning the interface, and were in general ready to use the interface within a few minutes. While the users felt that the way of visualising the dataset supported the performed tasks well, a number of users criticised the fidelity of the visualisation and indicated in the follow-up interview they would like e.g. adjustable transfer functions, as the opacity of the dataset sometimes interfered with the tasks. In terms of input modality — the users were given state-of-the-art handheld VR controllers — users were mostly satisfied, only a few users would have liked different input modalities more. In the follow-up interviews these users indicated that a pencil-like interface would feel more precise than the HTC Vive controllers used. 

In general, the very positive user response shows that most of the design decisions in the prototype have proven correct, so it can be refined further, and then deployed to control an actual physical system.


### Results — Wellbeing, Workload, and Simulator Sickness

\begin{figure*}
    \includegraphics{VRAHistory.pdf}
    \caption{History of previous VR usage and satisfaction in our study group.\label{fig:VRAHistory}}
\end{figure*}

All users tolerated the usage of the prototype very well. In Figure \ref{fig:VRACorrelation} it can also be seen that wellbeing — indicate by the _Concentrated_, _Motivated_, _Headache_, _Tired_, _Dry/Aching Eyes_, and _Nausea_ data points taken before and after the study — was not affected by the test in a significant manner. This finding is confirmed by the low SSQ scores we obtained:

The average total SSQ score was $6.2\pm6.7$. Compared to the calibration sample in [@kennedy1993], this is a very low score, as only the 60th percentile was in that realm, and the mean of the calibration sample was $9.8\pm15.0$, nearly $1.5$-times the score in our study.

The users in the test had mostly a low degree of previous exposure to VR systems before (see Figure \ref{fig:VRAHistory}). Those who had previous exposure to VR games or applications were mostly happy with it. 

We found a correlation between a history of VR usage and low SSQ scores (see Figure \ref{fig:VRACorrelation}), indicating there might be a training effect. Furthermore, a history of VR usage correlated well with low TLX scores, and a general appreciation of the visualisation, size, and positioning of the dataset in the study. 

\begin{figure*}
    \includegraphics{VRATLX.pdf}
    \caption{Task Load Index (TLX) results in the user study.\label{fig:VRATLX}}
\end{figure*}

Workload evaluation results are shown in Figure \ref{fig:VRATLX}. Users generally reported very low mental and physical demands in the study, and mostly did not have to work hard to achieve the desired results. A single user felt that the task was a bit hurried or rushed, and two felt that the mental demand was average or above-average. Users in general did not feel insecure or annoyed performing the task using the proposed interface. 

Both wellbeing and workload results indicate that using the proposed VR interface is very comfortable for the users and allows them to perform 3-dimensional ablation/selection tasks with ease, and without experiencing motion sickness.

### Results — Acceptance and Potential Adoption

\begin{figure*}
    \includegraphics{VRAAdoption.pdf}
    \caption{Results of the adoption questions section of the study.\label{fig:VRAAdoption}}
\end{figure*}

The majority of the users stated they could imagine adopting the presented technique for their experiments (see Figure \ref{fig:VRAAdoption} for all results), and stated that the technique provides an improvement over the current way laser ablation experiments are performed. 

Users seemed unsure whether the technique presents an improvement in terms of speed or precision: While they tended towards improvement in both cases, in both cases, four users answered only _maybe_ or less. In the follow-up interview we found out the reasons for the uncertainty here lies in the different models systems users investigate: users which had to produce a large number of reproducible cuts in their day-to-day experiments tended to be more skeptical about free-form drawing. We are going to address this problem in the next prototype, see [Requested Changes and Additions] for more details.

### Results — Further correlations

\begin{figure*}
    \includegraphics[height=16cm]{VRACorrelationShort.pdf}
    \caption{Correlations between questions in the questionnaire, only including SSQ summary score. For full correlation plot, please see Appendix \ref{fig:VRACorrelationFull}.\label{fig:VRACorrelation}}
\end{figure*}

In the correlation matrix in Figure \ref{fig:VRACorrelation} a few more interesting correlations can be observed. Correlations were computed as Pearson correlation coefficients. The observed correlations are:

* Positive answers to the Adoption questions (see Figure \ref{fig:VRAAdoption}) correlate well with affirmative answers to in the General section about fidelity and naturalness of the prototype, indicating the the subjects answered these questions truthfully.
* Individual TLX and SSQ scores anticorrelate with wellbeing scores, indicating that the less well a user felt before or after the study, the more demanding the tasks were scored, and the more sick the subject felt afterwards.
* Questions in the General section (see Figure \ref{fig:VRAGeneral}) did not correlate well with each other, indicating that each of them provides a valuable and independent data point.

### Requested Changes and Additions

\begin{marginfigure}
    \includegraphics{DrosophilaPupalWingLandmarks.png}
    \caption{Sensory organs in the \emph{Drosophila melanogaster} pupal wing circled in green. These can be used as landmarks for laser ablation. Image courtesy of Romina Piscitello, Eaton Lab, MPI-CBG.\label{fig:DrosophilaPupalWing}}
\end{marginfigure}


In the interviews conducted after the study, users were asked to comment further on the presented prototype and suggest improvements and additions. From this feedback, we decided to implement the following features and changes:

* __Confirm and Undo__: In addition to the regular freeform mode with immediate ablation after completing the drawing, another mode, where the target shape is drawn first, and confirmed after additional inspection was requested. In this mode, undo or erase will be possible  as well.
* __Brush size__: The ablation laser by default has a specific cut size. By combination of multiple shots, larger cuts can be created. In the interface, this can then be handled in a similar way as brush size adjustments in applications like _Adobe Photoshop_.
* __Template mode__: Many cuts a user has to perform are to be reproducible over a set of different specimen. For that reason, a template mode will be added, where a shape defined at one point can be reused later, optionally after translating, scaling or rotating it.
* __Semi-automatic Guides__: In 2D/3D or presentation applications, such as _Autodesk Maya_, _Adobe Photoshop_ or _Apple Keynote_, interactive guides exist to help the user with element alignment. Users often perform ablations relative to one or more specific landmarks, such as centrosomes in the mitotic spindle, or these dots in the Drosophila pupal wing (see Figure \ref{fig:DrosophilaPupalWing} for an example what such a landmark might be). Semi-automatic guides will be added such that they can indicate to the user which are the optimal points or contours for ablation. The semi-automatic guides will also be scriptable so they can be adjusted for a specific experiment.
* __Toolbelt__: The already existing freeform mode will be combined into a toolbelt, e.g., attached to a VR controller, with the user being able to seamlessly switch between different tools. The toolbelt will also offer the possibility to create custom tools by scripting.

These changes will be implemented in a future version of the software. The proposed changes can be easily integrated in our scenery-based prototype.

## Proposed Hardware Realisation

In our proposed setup, we are going to use a lightsheet microscope of the SPIM variety as default to overcome the speed and inflexible mounting issues of confocal microscopes in order to provide the user with instant feedback, and to treat the sample more gently, potentially for repeated application of cuts.

![Beam paths of our proposed hardware solution, based on a X-SPIM version of the OpenSPIM, with two illumination and two detection arms, and the UV ablation unit coupled into one of the detection arms. See text for details. Figure extended from X-OpenSPIM design by Johannes Girstmair.\label{fig:OpenSPIMAblation}](openspim-ablation.pdf)

The ablation unit design we propose is based on the design of [@Oswald:2010pr]. In Oswald's original design, the ablation unit was coupled to a spinning disk confocal microscope, and the design is already quite modular. We want to keep the modularity of the unit, such that it can also be used with other microscopes, e.g. spinning disk confocals as in the original, because some samples might need mounting on a glass slide.  _C. elegans_ adults for example do not enjoy embedding into agarose as it is common in lightsheet microscopy, while _Danio rerio_ or _Drosophila_ specimen tolerate it excellently.

A sketch of the setup is shown in Figure \ref{fig:OpenSPIMAblation}. The ablation unit is connected to an extension of the OpenSPIM microscope [@Pitrone:2013ki] for double-sided illumination and double-sided detection developed by Johannes Girstmair at UCL London and MPI-CBG, Dresden dubbed X-SPIM [@girstmair2016]. The X-SPIM design has the benefit that the sample can be more evenly illuminated from two sides, limiting the need for multi-angle acquisitions where the sample needs to be rotated, as light can only penetrate biological tissue to a limited extent. While more complex than the original OpenSPIM design, even an X-SPIM is still way less complex than a spinning disk confocal microscope and can be built by an experience microscopist within a day.

The ablation unit itself consists of the following parts:

* A 355nm Nd:YAG picosecond-pulsed UV laser, providing the necessary power output to reach the plasma-induced ablation regime described in [Introduction to Microsurgery]. The laser provides high-energy pulses of $10\,\mu\mathrm{J}$ with a rate of up to $1\,\mathrm{kHz}$, with a pulse width of $500\,\mathrm{ps}$, yielding power densities of up to $10\,\mathrm{TW}\cdot\mathrm{cm}^{-3}$.
* An Acousto-optical modulator (AOM) is used to be able to quickly change the laser power to reach the optimal regime for ablation. The AOM works by diffracting the beam by phonon waves in a silicium dioxide crystal. The first diffraction order of the beam then is adjustable between $0-80\mathrm{\%}$ of the original input power.
* Two galvanometric mirrors for steering in the X and Y axis are used to  steer the UV laser beam in an f$\Theta$ lens. An f$\Theta$ lens translates a beam of incidence angle $\Theta$ by $f\cdot\Theta$, where $f$ is the focal length of the lens. It is used in our proposed setup instead of the scanning telescope in the original setup.

The total magnification of the system has to be designed to overfill the entrance aperture of the objective, in our case the upper detection objective. The exact specifications of the objective to use are still under consideration. The setup will then contain an adjustable beam expander such that the ablation unit can be adapted to multiple systems.

For computer control of the microscope, the ClearControl interactive/automatic microscope control software ([github.com/clearcontrol/clearcontrol](https://github.com/clearcontrol/clearcontrol)) has been ported by Robert Haase and Johannes Girstmair to support the OpenSPIM hardware components. We have further coupled ClearControl with scenery and sciview to facilitate live visualisation and control.

## Future Work

The next prototype of the software will incorporate the changes proposed in the previous section. 

While we have focussed on the task of laser ablation, we believe that the interactions we have proposed are also applicable to other tasks in microscopy that require an surface or volume selection, such as optogenetics and photoconversion [@Boyden:2005cd], where photoactivatable proteins are used to steer cellular functions.

In terms of high-fidelity visualisation, we want to to extend our software framework to support better rendering algorithms [@Kroes:2012bo; @igouchkine2017] to provide better visual assistance and guidance to the user.

Finally, we aim to provide an open-source/open-hardware solution to perform both laser ablation and optogenetics tasks with the assistance of VR interfaces, based on a customised OpenSPIM microscope.



