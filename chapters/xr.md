# XR

The acronym _XR_, or _cross reality_, encompasses the full spectrum of virtuality, reaching from full virtual reality, to mixed, and augmented reality. In this chapter we give a brief overview of existing technology and current developments, as well as outline the challenges associated and opportunities offered, especially in the context of biology.

## Virtual Reality, Augmented Reality, Mixed Reality

With the them _Virtual Reality_ we describe environments that simulate parts of the real-world experience of human beings, such as the visual surroundings, auditory perception, and sometimes even proprioception in an interactive, computer-generated three-dimensional environment. The world exterior to the simulated environment plays no role here, such that the user can become shut off from his real surroundings.

If the surroundings of the user are actually taken into consideration and displayed, e.g. via a set of glasses that do not shut out the outside environment, but overlay information on top of it that extend the capabilities or information content of the environment, we speak of _augmented reality_.

In the case of a mix of both, where there is a direct connection or overlap between the virtual, simulated world, and the real world, the setting is termed _mixed reality_. _Mixed reality_ might take place anywhere in the _virtuality continuum_, except the extremal points of fully real environments, or fully virtual environments[@Milgram:1995cl]. 

![\label{fig:virtuality}Virtuality continuum according to [@Milgram:1995cl], where mixed reality encompasses all settings that are not the extremal points.](figures/virtuality_continuum.pdf)

## Historic Perspective

The first virtual reality "glasses" have been introduced in the 1850's, as so-called _stereoscopes_, looking not unlike contemporary head-mounted displays. In the stereoscopes, the user would insert a postcard that is split in the middle in two parts, showing the subject of the postcard from two slightly different perspectives corresponding the capturing an image with two eyes, as in the human visual system. 

![\label{fig:stereoscope}The stereoscope.](figures/stereoscope.png){ width=50% }

In the early 1950, the _sensorama_ was introduced, an immersive movie theater\ref{fig:sensorama}, that not only included stereoscopic visuals, but also wind, sound, and even smell.

![\label{fig:sensorama}The sensorama.](figures/sensorama.png){ width=50% }

With computer graphics still in it's infancy, the first steps towards a head-mounted display mainly for military purposes, were made in 1968 by Ivan Sutherland[@Sutherland:1968im]. Sutherland developed a glasses-based virtual reality system (actually, augmented reality) that consisted of cathode-ray tubes mounted on the users head, with images being directed to the eyes by the means of mirrors. The tracking system for the contraption was suspended from the ceiling, looming over the user, hence the name of the system, _The Sword of Damocles_. _The Sword of Damocles_ could display wireframe models of geometric objects overlaid onto the user's surroundings, and adapted to the viewpoint that had been calculated by the tracking system.

![\label{fig:damocles}The _Sword of Damocles_. Note the cathode-ray tubes mounted to the sides of the user's head, and the mirrors directing the image to the eyes.](figures/sword-of-damocles.png){ width=50% }

Big steps towards the current state of virtual and augmented reality were taken in the 1980s and 1990s by the University of Southern California's _Mixed Reality Lab_, and the company VPL, a spin-off of the aforementioned lab. The lab developed not only head-mounted displays, but full-body virtual reality suits, providing the user with a force-feedback system, and gloves that would react to virtual objects and the user's grip. One more idea from the lab is the omnidirectional threadmill for exploring virtual worlds, which is nowadays getting new traction for gaming settings. __TODO: Add citations__ Many of these developments have led to the _First Virtual Reality Revolution_, aiming at ubiquity of virtual reality devices and their usage. It was however not successful, due to the high cost of the systems, and ergonomics issues arising both from the size and weight of the systems, and the low frame rates contemporary computers produced when created digital 3-dimensional imagery.

In addition to the personal systems based on head-mounted displays, room-scale systems such as the _CAVE_[@CruzNeira:1992vt] — a backronym for _CAVE Automatic Virtual Environment_ — were developed in the mid-1990s. In contrast to the HMDs, these systems use the tracking of the user not to display a perspective-corrected image on a screen attached to the user's head, but on a (front or back-)projected wall or display at a distance to the user. Compared to HMDs, such CAVEs have the benefit that multiple people can use it simultaneously, with the constraint that only a single person will see the fully correct three-dimensional, immersive image. CAVE systems have found a large user base in the automative industry, and in architecture and design[@DeFanti:2010cp].

## Current Developments

The currently ongoing _Second Virtual Reality Revolution_ (with the same goals as the first one) has been enabled mainly by the now cheaply available, high-resolution, small form-factor displays that are used in smart phones, as such displays are the ideal basis for head-mounted displays with compact form factors.

After showing several prototypes of head-mounted displays, Palmer Luckey, a former employee of the _Mixed Reality Lab_, produced the _Oculus Rift_, a translational and rotational tracking HMD complete with tracking system, based on full-HD smartphone displays. Soon after the _Rift_, other manufacturers presented similar devices, such as HTC's _Vive_, Sony's _Playstation VR_, Samsung's _GearVR_, or the set of Microsoft's _Windows Mixed Reality_ glasses (which are actually misnamed, as they are virtual reality glasses, not mixed reality).

On the side of augmented reality, Microsoft is at the moment selling the developer kit of the _HoloLens_, an untethered headset with its own CPU, GPU, and HPU (holographic processing unit, apparently used for tracking tasks, etc.). The _HoloLens_ features _inside-out tracking_, where no external tracking hardware is needed, apart from the HMD itself.

Current-generation HMDs are now able to display convincing virtual reality environments to the user, if a potent-enough computer and GPU are used to produce the images. Compared to the _First VR Revolution_, performance of the rendering computers has increased tremendously, the form factors and weights of the HMDs have gotten to usable and halfway ergonomic dimensions, and cost has reduced substantially, such that a virtual reality-capable computer system, including the HMD, can now be bought for about €1500.

## Challenges and Opportunities

## Fitness for Purpose

We are interested in how cross reality combined with natural user interfaces can enhance the daily workflows of life scientists (such as biologists, computer scientists working on simulations of biological systems, etc.), and by extension also enable experiments that were not possible before. In this section, we will briefly summarise three particular areas the different modalities of virtual reality, augmented reality, and mixed reality can be beneficial, and where or how they might actually hinder the user.

### Simulation visualisation and debugging

In this case, we envision the user to be using a regular desktop computer to write software and run simulations directly there, or submit them to a remote cluster, returning the simulation results. The simulation results themselves might be abstract data, or might be concerning spatiotemporal relations of objects such as cells. Such objects constitute abstract entities that usually do not have any correspondence with objects experience by the user in daily life. In such settings, a full virtual reality HMD is the best solution, as the setting itself does not usually require interacting with anything, but the simulation results themselves. It is therefore okay to shut out the user from the normal environment, and only show a simulated environment, from which the user can then return at will.

### Microscopy data visualisation

Visualisation might occur both at the time of acquisition (e.g. for checking correct imaging parameters), or later on, at the time of evaluation of the data. Both cases have in common that the user will most probably need to interact with the outside environment to adjust the microscope, or just to take notes. It would therefore be not beneficial to encumber the user inside a fully virtual environment, but rather augment the existing environment with the data that has been acquired. Intuitive interactions, in which the users e.g. sifts through a set of time points of a microscopy dataset much alike to sifting through a pile of papers, would enhance the acceptance of such modalities.

### Microscope development and control

This use case can make use of both augmented and virtual reality settings: While augmented reality would benefit the user at design time of the instrument, e.g. by overlaying rulers, angles, and component descriptions on the optical table, fully shutting out the user from reality at control time can be helpful to interact with data that does not have a daily-life correspondent, just analogue to the first use case we have been looking at.

