# Future Development Directions

## Improved rendering

While scenery supports a set of different rendering methods (and exchangeable and customisable rendering pipelines), we would like to extend the default rendering pipeline further with more state-of-the-art algorithms:

* We would like to use more efficient ways of deferred shading, like forward+ shading [@Harada:2012fr] or clustered deferred shading [@Olsson:2012vr] — these variations of deferred shading support a large number of light sources, while being able to be integrated with regular forward shading effects and material pipelines more easily. Ideally, options for machines in several performance categories could be offered, as scenery will probably be used on notebooks as well as high-powered workstations.
* Volume rendering in scenery is still quite basic, supporting only alpha blending, and (local) maximum intensity projection. There, we would like to explore options like Monte Carlo light transport (e.g. as used in [@Kroes:2012bo]), or path tracing [@Novak:2018Monte]. In addition to the added visual fidelity, such methods make the precise simulation of light emitted by fluorescent proteins possible [@Abdellah:2017cq], opening the way to create better simulated data, e.g. for testing algorithms.
* Shadowing has not been implemented yet, but provides higher visual fidelity as well. We have started exploring various ideas in screen-space shadowing, with a preliminary rendering of the _Sponza_ demo scene shown in \cref{fig:SponzaSSS}.
* The advent of ray tracing cores in consumer hardware (as in Nvidia's RTX series GPUs) offers new possibilities for global illumination (and shadowing). We would like to explore how these new possibilities can improve the rendering of experimental and simulation data.

![The _Sponza_ demo scene rendered with screen-space shadowing rendered in scenery with an experimental rendering pipeline. Model from Morgan McGuire, Computer Graphics Archive, [casual-effects.com/data](https://casual-effects.com/data/)\label{fig:SponzaSSS}](sponza-screenspaceshadows.png)

## Improved networking

As described in [Distributed Rendering], scenery already provides facilities to synchronise scene content over the network. We would like to extend our implementation there such that scientists can work collaboratively _and_ remotely on datasets, without requiring large changes to the code of an application. Another possibility here is the collaboration of scientists via AR headsets in the same place, e.g. for discussing datasets and results while the dataset is hovering over the desk where the scientists are sitting.

## _In situ_ visualisation in Virtual Reality

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/insitu-molecular-dynamics.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video demo of \emph{in situ} visualisation in scenery. For a list of supplementary videos see \href{https://ulrik.is/thesising/supplement/}{ulrik.is/thesising/supplement/}.
\end{marginfigure}

We have already started exploring the possibility of coupling scenery with simulation frameworks such as OpenFPM [@Incardona:2019OpenFPM] and ISAAC [@Matthes:2016situ]. We would like to explore VR-augmented visualisation of simulation data, while the simulation is running (_in situ_ visualisation), and steering of the running simulation. With support for both virtual reality headsets and distributed rendering setups, as well as various devices for interaction, scenery is an ideal framework for prototyping in this project. We have already developed a prototype for a small molecular dynamics simulation, with the simulation code running in OpenFPM, and the visualisation on four rendering nodes, and one compositing node in scenery. This example is shown in the supplementary video.

_In situ_ visualisation provides further interesting research avenues: 

* How can we efficiently decouple updates of the simulation data from the visualisation, such that the low latency and high frame rate requirements of VR can be met? Here, we have already prototyped a client-server architecture, where renderings are composited on the head node of a cluster, and then forwarded to a visualisation client that does the final compositing an VR rendering.
* How can the framework be designed in a way to provide support for a wide range of simulation applications, yet require only minimal code changes? At the moment, we require only minimum code changes to include _in situ_ visualisation in OpenFPM, but does that scale to all use cases? Could the simulation code provide metadata such that scenery can automatically discover what visualisable or tuneable parameters of the simulation are?
* How can we represent volumetric data efficiently, such that compositing of even non-convex regions becomes possible, as domain decompositions from the simulation may be non-convex? In this case, an extension of _Volumetric Depth Images_ (VDI) [@Frey:2013Explorable] might provide a way out — VDIs are intermediate representation of volumetric data, where changes in the data below a certain threshold are compressed into a block representation, similar to run-length encoding. VDIs are then re-used for novel-view synthesis, where the rendering of a volumetric dataset is calculated from a new viewpoint, without traversing the entire dataset again. 

