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

From our survey of related works and use cases, we can observe the following:

Complex, three-dimensional cuts are very hard to perform on a regular screen from an interaction perspective —  it is very hard to translate from an image projected on a 2D screen to a — potentially moving — 3D volumetric specimen, and even with sophisticated techniques as in [@Peng:2014bu], it can become overwhelming for the user. Nevertheless, complex geometries need to be investigated in order to better understand the biophysics of e.g. the cellular cortex. 

Furthermore, it is preferable to use lightsheet microscopes for their superior speed and gentle imaging as instruments for 3D ablation purposes: Their particular way of mounting samples is extremely beneficial for quickly moving the sample in three directional axis plus one rotational axis, something that is not possible with e.g. confocal microscopes.

## Prototyping, Stage 1

As a first prototype, we developed a browser-based (threejs, [https://threejs.org](https://threejs.org)) prototype that makes use of the _LeapMotion_ gesture controller. A screenshot of the prototype can be seen in Figure \ref{fig:LMAblationPrototype}. The workflow of the prototype is

1. orient the specimen in the desired way by using keyboard and mouse,
2. form a circular structure with thumb and index finger, and draw the desired tubular structure into the aligned worm, and finally
3. a cylindrical tube is calculated from the defined circular samples via Centripetal Catmull-Rom spline interpolation[@Catmull:1974cf]. Catmull-Rom splines have been chosen here as they always go through their control points, and do not form cusps, which both are desirable properties for surfaces later to be used in laser ablation.

Within a limited user study, we identified two main issues with this approach:

1. Orientation of the specimen using keyboard and mouse is error-prone and was noted to be not very comfortable and intuitive, especially when combined with subsequent gestural interaction,
2. the gestural interaction was found to be imprecise, as a feeling of 3-dimensionality or immersion did not come up when being restricted to a regular, flat screen.

Additionally, we abandoned browser-based prototyping after this first iteration, as loading times were already too long when using the geometry model of 26MiB, and would be even longer if volumetric data would be used. We want to note here that this initial experience also contributed to the decision to start the development of scenery.

![Screenshot of the _LeapMotion_-based interaction prototype, where the user has delineated a tubular structure along the _C. elegans_' gonad system. _C. elegans_ model courtesy of [openworm.org](https://www.openworm.org).\label{fig:LMAblationPrototype}](./figures/LeapMotionLaserAblationPrototype.png)

## Prototyping, Stage 2

## Proposed Hardware Realisation

![3D rendering of the UV ablation module, original design by Michael Weber, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, Wisconsin, USA.\label{fig:UVcutterRendering}](./figures/ablation-module.png)