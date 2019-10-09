# A Short Introduction to Cross Reality

_Cross reality_, or _XR_, encompasses everything on the spectrum between fully virtual environments, and fully real environments. This includes especially virtual reality (VR), augmented reality (AR), and augmented virtuality.

In this chapter we give a brief overview of existing technology and current developments in the areas of virtual and augmented reality. We will explain the benefits of VR and AR, and outline associated challenges and opportunities offered, with an emphasis on biology and imaging. In the end we will sketch issues addressed in this thesis.

## Virtual Reality, Augmented Reality, Mixed Reality

> "_Virtual Reality_ is the computer-generated simulation of a three-dimensional image or environment that can be interacted with in a seemingly real or physical way by a person using special electronic equipment, such as a helmet with a screen inside or gloves fitted with sensors." —  _Oxford Dictionary of English_

With the term _Virtual Reality_ we describe environments that simulate parts of the real-world experience of human beings, such as the visual surroundings, auditory perception, and sometimes even proprioception[^ProprioNote] in an interactive, computer-generated three-dimensional environment. The world exterior to the simulated environment plays no role here, such that the user can become shut off from her real surroundings and fully immersed in the simulation, if it is convincing enough.

[^ProprioNote]: Proprioception is the sense of relative motion and positioning of one's own body and/or its parts.

If the surroundings of the user are actually visible, e.g. via a set of glasses that are transparent and show the outside environment (or show them via cameras) and overlay information on top of it that extend or augment the capabilities or information content of the environment, we speak of _augmented reality_.

In the case of a mix of both, where there is a direct connection or overlap between the virtual, simulated world, and the real world, the setting is termed _mixed reality_. _Mixed reality_ might take place anywhere in the _virtuality continuum_, except the extremal points of fully real environments, or fully virtual environments, while _cross reality_ encompasses the full spectrum [@Milgram:1995cl]. 

![\label{fig:virtuality}Virtuality continuum according to [@Milgram:1995cl], where mixed reality encompasses all settings that are not the extremal points, and cross reality encloses the extremal points as well.](virtuality_continuum.pdf)

## Historic Perspective — 1800s to 1990s

The first virtual reality "glasses" have been introduced in the 1850's, as so-called _stereoscopes_, looking not unlike contemporary head-mounted displays. In the stereoscopes, the user would insert a postcard that is split in the middle in two parts, showing the subject of the postcard from two slightly different perspectives corresponding the capturing an image with two eyes, as in the human visual system. 

\begin{marginfigure}
    \includegraphics{stereoscope.jpg}
    \caption{\label{fig:stereoscope}A Holmes-type stereoscopes to view left/right-eye images as single image. Public Domain.}
\end{marginfigure}

In the early 1950, the _Sensorama_ was introduced, an immersive movie theater, that not only included stereoscopic visuals, but also wind, sound, and even smell. The machine is shown in Figure \ref{fig:sensorama}.

\begin{marginfigure}
    \includegraphics{sensorama.jpg}
    \caption{\label{fig:sensorama}The sensorama. Image reproduced from Sensorama, Inc. Advertisement, 1962.}
\end{marginfigure}

With computer graphics still in it's infancy, the first steps towards a head-mounted display mainly for military purposes, were made in 1968 by Ivan Sutherland [@Sutherland:1968im]. Sutherland developed a glasses-based virtual reality system (actually, augmented reality) that consisted of cathode-ray tubes mounted on the users head, with images being directed to the eyes by the means of mirrors. The tracking system for the contraption was suspended from the ceiling, looming over the user, hence the name of the system, _The Sword of Damocles_. _The Sword of Damocles_ could display wireframe models of geometric objects overlaid onto the user's surroundings, and adapted to the viewpoint that had been calculated by the tracking system.

\begin{marginfigure}
    \includegraphics{sword-of-damocles.png}
    \caption{\label{fig:damocles}The \emph{Sword of Damocles}. Note the cathode-ray tubes mounted to the sides of the user's head, and the mirrors directing the image to the eyes. Reproduced from \citep{Sutherland:1968im}.}
\end{marginfigure}

Big steps towards the current state of virtual and augmented reality were taken in the 1980s and 1990s by the University of Southern California's _Mixed Reality Lab_, and the company VPL, a spin-off of the lab. The lab developed not only head-mounted displays, but full-body virtual reality suits, providing the user with a force-feedback system, and gloves developed for NASA that would react to virtual objects and the user's grip [@Zimmerman:19875d6]. 
In addition to the personal systems based on head-mounted displays, room-scale systems such as the _CAVE_ [@CruzNeira:1992fa] — a backronym for _CAVE Automatic Virtual Environment_ — were developed in the mid-1990s. In contrast to the HMDs, these systems use the tracking of the user not to display a perspective-corrected image on a screen attached to the user's head, but on a (front or back-)projected wall or display at a distance to the user. Compared to HMDs, such CAVEs have the benefit that multiple people can use it simultaneously, with the constraint that only a single person will see the fully correct three-dimensional, immersive image. 
CAVE systems have found a large user base in the automative industry, and in architecture and design [@DeFanti:2010cp].

In the 1990s, interesting applications for various VR settings were explored in the research field. Especially UNC Chapel Hill's Virtual Reality Lab created a lot of solutions for diverse areas such as pharmaceuticals [@Brooks:1990be2], electron microscope control [@Taylor:19932a5], or architecture [@Airey:1990151], with the example of VR protein docking supported by haptics shown in \ref{fig:GROPE}.

\begin{marginfigure}
    \label{fig:GROPE}
    \includegraphics{ProteinDocking.png}
    \caption{Protein docking example using the haptic \emph{GROPE-III} system. Users reported a radically improved situational awareness from using the system. From \citep{Brooks:1990be2}.}
\end{marginfigure}

Another fascinating idea from the 90s is the omnidirectional treadmill for exploring virtual worlds [@Darken:1997odt], where a moving 2D conveyor belt would compensate the user's movement in the virtual environment. These developments have led to the _First Virtual Reality Revolution_, aiming at ubiquity of virtual reality devices and their usage, sprouting movies and conferences focused on VR, and companies channeling R&D money into VR technology. Nicholas Negroponte conjectured in 1993 a widespread use of VR devices, and a company that "will soon introduce a VR display system with a parts cost of less than US$25"[^WiredLinkNegroponte], while Fred Brooks estimated in 1994 "we will see high-resolution, low-lag systems doing serious applications within 3 years", although acknowledging that display technology back then was so bad it made the user "legally blind" [@Bryson:19942f4].

Unfortunately, the First Virtual Reality Revolution was not successful, at least from a commercial point of view — and most of the companies betting on its success went out of business until 1998 [@Jerald:2015vk]. Some reasons for the failure were: 

* Due to the high cost of the systems, few people and labs were able to afford them, and often the systems remained only in research use,
* ergonomics issues arising both from the size and weight of the systems prevented usage for more than a short period of time, with Randy Pausch stating, "approximately 10% of the visitors adamantly decline the opportunity to wear a head-mounted display" [@Bryson:19942f4], and
* the visual fidelity then-contemporary computers could produce when rendering digital 3-dimensional imagery were simply neither good enough nor fast enough to provide a fully convincing, not sickness-inducing, experience.

[^WiredLinkNegroponte]: See [wired.com/1993/06/negroponte-11/](https://www.wired.com/1993/06/negroponte-11/).


## Current Developments

\begin{marginfigure}
    \label{fig:OculusRiftPrototype}
    \includegraphics{OculusRiftPrototype.jpg}
    \caption{An early Oculus Rift prototype. Image reproduced from  Engadget, \url{https://www.engadget.com/2012/08/16/oculus-rift-hands-on/}.}
\end{marginfigure}

The currently ongoing _Second Virtual Reality Revolution_ has been enabled — at least in part — by the development of low-cost, high-resolution displays that are used in smart phones, and the gyroscopic sensors used alongside them. 

The displays used in mobile phones form the ideal basis for ergonomic and lightweight head-mounted displays, as they feature both a low physical footprint, low energy use, and the right size and resolution to be put right in front of the eyes.

\begin{marginfigure}[1cm]
    \label{fig:OculusRiftHMD}
    \includegraphics{OculusRiftHMD.jpg}
    \caption{The Oculus Rift Virtual Reality HMD. Public domain.}
\end{marginfigure}

After showing several prototypes of head-mounted displays, Palmer Luckey, a former employee of the _Mixed Reality Lab_, produced the _Oculus Rift_ in 2016 (see Figure \ref{fig:OculusRiftPrototype} for the prototype, and Figure \ref{fig:OculusRiftHMD} for the final product), a translational and rotational tracking HMD complete with tracking system, based on full-HD smartphone displays. Soon after the _Rift_, other manufacturers presented similar devices, such as HTC's _Vive_, Sony's _Playstation VR_, Samsung's _GearVR_, or the set of Microsoft's _Windows Mixed Reality_ glasses (a slight misnomer, being actually virtual reality glasses).

On the side of augmented reality, Microsoft has been selling the developer kit of the _HoloLens_ since 2016. The HoloLens is an untethered headset with its own CPU, GPU, and HPU (holographic processing unit, apparently used for tracking tasks, etc.). The HoloLens features _inside-out tracking_, where no external tracking hardware is needed, apart from the cameras inside the HMD itself. On the software side, the HoloLens supports rendering directly on the device via Direct3D11, or via low-latency remote rendering (named Holographic Remoting) on a separate computer, and streamed image transfer, with the images encoded as H264 video stream, and corrected by the HoloLens on-the-fly with affine transformations for rotations and translations, to compensate for network latency. In early 2019, Microsoft announced the _HoloLens 2_, with improved field of view, latency, and physical footprint (see Figure \ref{fig:HoloLens2}).

\begin{marginfigure}
    \includegraphics{HoloLens2.jpg}
    \caption{The HoloLens 2. Promotional picture, from \href{http://microsoft.com/en-us/hololens}{microsoft.com/en-us/hololens}.\label{fig:HoloLens2}}
\end{marginfigure}

Another available AR headset (as of 2019) is the _Magic Leap One_, featuring advanced optics, with three planes of focus, and a dedicated processing unit (dubbed _light pack_) featuring 8 GiB RAM and an ARM-architecture Nvidia Tegra X2 with an integrated Pascal-generation GPU with 256 CUDA cores, tentatively providing more compute power than the HoloLens. Also on contrast to the HoloLens that runs Windows 10, the Magic Leap One runs a custom Linux distribution named Lumin OS. 

\begin{marginfigure}
    \includegraphics{MagicLeap.png}
    \caption{The Magic Leap AR Headset. Promotional picture, from \href{http://magicleap.com}{magicleap.com}.\label{fig:MagicLeap}}
\end{marginfigure}

Both the HoloLens and the Magic Leap One provide a glimpse of what will be possible, comfortable, and easy with mixed reality devices at some point in the near future. Both still suffer from a lack of resolution, field of view, and computational power, such that the impression these headsets leave in actual reality are still a bit of a stretch from their promotional materials.

In contrast, current-generation Virtual Reality HMDs are able to display convincing virtual reality environments to the user, with a high frame rate, and a large field of view, given a potent-enough CPU and GPU are used to produce the images. Compared to the _First VR Revolution_, performance of the rendering computers, and even more importantly, the tracking systems, has increased tremendously, the form factors and weights of the HMDs have gotten to usable and ergonomic dimensions, and their price has been reduced substantially, such that a VR-capable computer system, including the HMD, can be bought for as little as about €1500 in early 2019.

Current research topics in the usage of virtual reality include how people explore virtual environments [@Sitzmann:to], the combination of multiuser virtual reality with physical systems on top of 5G low-latency networks [@bastug2016], or foveated rendering to gain significant speed-ups [@Patney:2016b4e][^FoveatedNote]. Clinicians have renewed interest in the usage of VR technologies in psychology and psychiatry, such as for treatment of anxiety disorders [@Maples-Keller:2017790] or for the rehabilitation of stroke victims [@Laver:2017vrsr]. In the context of biology, VR has recently been used to sample molecular conformations in a multiuser environment [@OConnor:2018339], combining rendering on VR HMDs with cloud-based simulations of molecular structures, or for the visualisation of endocytosis datasets from electron microscopy [@Johnston:20189ce].

For augmented reality, the visualisation of complex data, such as large graphs is an active area of research [@Buschel:2019a5d], and it is also being explored as a new modality for neuronavigational systems in neurosurgery [@Meola:20170ce]. Utilising AR in combination with cyber-physical systems, such as human-robot collaborative assembly systems [@Makris:20161c0] or for debugging distributed systems [@Reipschläger:2018945] is also investigated.

[^FoveatedNote]: In foveated rendering, only the part of the image seen by the user's fovea, the part of the retina with the highest spatial resolution, is rendered at full resolution.


## Issues

### Motion Sickness or Simulator Sickness

Motion or Simulator sickness can occur when there is a disparity between the motion seen by the eyes, and the motion perceived by the vestibular system. There are several hypothesis why it arises [@Jerald:2015vk]:

* _sensory conflict theory_ — motion sickness arises due to a conflict of the visual, vestibular, or proprioceptive systems that cannot be reconciled,
* _evolutionary theory_ — the disparity of sensations from the different system is assumed by the body to originate in being poisoned, which is counteracted by the need to lie down, vomiting (to get rid of ingested poison), and nausea, to prevent the consumption of more poison, 
* _postural instability theory_ postulates that one of the main goals of animals is maintaining a stable posture, and sickness is a reaction to incomplete or inexistent learning — which also means people using VR systems for a while may experience a lessening in the intensity of their motion sickness, or
* _eye movement theory_/_nystagmus theory_ — motion sickness arises from unnatural eye movements that would be required to stabilise the image on the retina. Both the vestibulo-ocular reflex (VOR) and the optokinetic reflex (OKR) are involved in stabilising images and the lack of saccadic suppression might also play a role (see the chapter [Visual Processing] for details on eye movements and processing).

Whatever the actual reason for motion sickness might be, it has to be kept in check for a user to be able to comfortably use a VR system. For that, several defences can be used:

* the system should run with a frame rate of 60fps, or better 90fps to maintain a fluid appearance, as everything below will be perceived as stuttering and can increase motion sickness — it is advisable to rather sacrifice realistic rendering instead of frame rate (see [Visual Processing] on more information about what movements are perceived as fluid),
* certain kinds of movement, such as lateral movements should be avoided, as they do not occur in the real world, and teleportation should be the preferred way of moving, with fading transitions at start and end[^OculusBPLink], alternatively, dynamically reduce the field of view during fast movements [@Fernandes:2016cvrs],
* the system should be set up to use the correct inter-pupillary distance (IPD) of the user, to provide the same image convergence as in the real world [@Ukai:20085b2],
* the tracking system used should be well-calibrated and work with low latency to avoid stuttering and jerky movements [@Mania:2004ps;@Jerald:2015vk].

[^OculusBPLink]: See [developer.oculus.com/design/latest/concepts/book-bp/](https://developer.oculus.com/design/latest/concepts/book-bp/).

Furthermore, there has also been research into other ways to prevent motion sickness, which has produced fascinating results: In [@Whittinghill:2015581], the authors report on the addition of a "virtual nose" to the rendered scene, which reduces the occurrence of motion sickness and enabled their users to use their system for longer amounts of time without getting sick. 

This list is of course far from exhaustive: In addition to the countermeasures just described, [@Jerald:2015vk, Chapter 19] offers a very comprehensive list of guidelines to counter adverse health effects when designing and using VR systems. In addition, [@Clift:2018ncs] provides a review of both software and hardware solutions against motion sickness in VR.

### Lack of Vergence

Current, commercially-available HMDs do not provide focus cues for the eye. This not only completely precludes the use of vergence for user evaluation or control, but also makes the issue of simulator sickness, described in the section before, worse. 

Research-grade HMDs try to solve this now using light-field rendering [@Wetzstein:2013jo], to provide focus cues for the eye. In [@Huang:2015ce] for example, a three-layered HMDs is described, providing focus cues for foreground, background, and the area in-between. 

Actually giving focus cues to the user would bring detection of the depth the user is looking at, and therefore 3D eye tracking, one step closer.

### Hygienic Issues

In settings where a head-mounted display is used by many different people, such as for demo purposes, or at conferences, hygienic problems arise. To be comfortable, a HMD needs some cushioning, usually provided by a foamy insert on the HMD, which over time accumulate dirt and can also harbour germs. One solution to this is to provide washable inserts, as companies like VRCover[^VRCoverNote] now offer. Museums using VR systems have also started to use disposable face masks to combat this problem[^FaceMaskNote].

[^VRCoverNote]: See [vrcover.com](https://vrcover.com/)
[^FaceMaskNote]: See [museumnext.com/2019/01/how-museums-are-using-virtual-reality/](https://www.museumnext.com/2019/01/how-museums-are-using-virtual-reality/)

## Challenges

* _Can we use VR/AR for visualising microscopy data after acquisition, and provide a measurable benefit for the user from that?_ — Visualisation might occur both at the time of acquisition (e.g. for checking correct imaging parameters), or later on, at the time of evaluation of the data. Both cases have in common that the user will most probably need to interact with the outside environment to adjust the microscope, or just to take notes. It would therefore be not beneficial to encumber the user inside a fully virtual environment, but rather augment the existing environment with the data that has been acquired. Intuitive interactions, in which the users e.g. sifts through a set of time points of a microscopy dataset much alike to sifting through a pile of papers, would enhance the acceptance of such modalities.
* _Can we use VR/AR to control microscopes and do e.g. laser ablation experiments more efficiently?_ — This use case can make use of both augmented and virtual reality settings: While augmented reality would benefit the user at design time of the instrument, e.g. by overlaying rulers, angles, and component descriptions on the optical table. Virtual reality on the other hand could be beneficial while performing e.g. laser ablation or optogenetic experiments undisturbed, in a fully immersive environment, fully concentrated on the specimen.
