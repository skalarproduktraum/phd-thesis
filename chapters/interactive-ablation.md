# Interactive Laser Ablation

The investigation of biological phenomena not only rests on observation of such, but also on the ability to interfere with them. Especially where biomechanical and biophysical questions want to be answered, _laser ablation_ or microsurgery plays an important role and conveys the possibility to destroy cells or parts of tissues, while not interfering with their neighbours, in a manner much more precise than purely mechanical manipulation could achieve.

## Introduction to Microsurgery

### Biophysical Principles

For the interaction of light with biological tissue, five different regimes, based on the applied power density are known:

| Regime | Power density ($\mathrm{W}/\mathrm{m}^2$) | Exposure time (s) |
|:--|:--|:--|
| Photochemical interaction | $10^{-3}\,-\,10$ | $10+$ |
| Thermal interaction | $10\,-\,10^6$ | $10^{-5}\,-\,10$ |
| Photoablation | $10^6\,-\,10^{10}$ | $10^{-9}\,-\,10^{-6}$ |
| _Plasma-induced ablation_ | $10^{10}\,-\,10^{14}$ | $10^{-13}\,-\,10^{-10}$ |
| Photodisruption | $10^{11}\,-\,10^{16}$ | $10^{-12}\,-\,10^{-8}$ |

For microsurgery on the cellular level, we are interested in the _plasma-induced ablation_ regime, highlighted in the table. This regime provides ablation of the target area by _optical breakdown_, confined to the focal point of the laser, with no damage around that area, and no shock-wave generation or cavitation, as observed in the _photodisruption_ regime marked by even higher power densities.

Optical breakdown of tissue occurs when the applied electric field $\symbfit{E}$ exceeds the ionisation energy of the molecules and atoms present, with ionisation occurring within a few hundred picoseconds, and the radiation being absorbed by the created plasma. The plasma is created by _inverse Bremsstrahlung_, where a free electron is accelerated by an inbound photon, which in turn collides with an atom, ionising it, and resulting in two new free electrons, with less kinetic energy, leading to an avalanche effect. Even if the original material was transparent, the plasma will be opaque to the incident radiation. This effect makes it possible to also ablate areas that are otherwise transparent.

## Common Use Cases

## Limitations of the current approach

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