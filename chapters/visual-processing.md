# Introduction to Visual Processing

\begin{figure*}
    \includegraphics{gray_optic_system.pdf}
    \caption{Schematic overview of the paths from the eye to the visual cortex, with the parts discussed in this chapter highlighted in italics. Adapted from \emph{Anatomy of the Human Body}\citep{Gray:1878ahb}, Public Domain.\label{fig:processing_overview}}
\end{figure*}

In this chapter, we introduce the human visual system, the anatomy of the human eye and its physical capabilities and movements, as well as the processing happening to incoming photons in the retina and further downstream, in the central nervous system. 

The goal of this chapter is to give the reader an understanding of the physiological processes that ultimately enable both eye-based natural user interfaces and cross reality applications, and introduce implications from physiology for such. In the end of the chapter, we will introduce some challenges and questions in the context of visual processing which will be addressed in later chapters of this thesis.

## A Short Tour of the Human Visual System

The processing of visual stimuli happens in multiple stages: In Figure \ref{fig:processing_overview} we show an overview sketch of the nerve pathways involved in visual processing. In the following, we will discuss the following parts in deeper detail:

1. _The Optical Path_ — Collection and accumulation of incoming photons by the optical system consisting of the _cornea_, _iris_, and _lens_ onto the _retina_, and especially the most sensitive part of the retina, the _fovea_.
2. _The Retina_ — Collection and translation of incoming photons into nerve pulses, and compression of the nerve signals for further processing,
3. _The Lateral Geniculate Nucleus_ (LGN) — situated in the _thalamus_ part of the forebrain, which serves as a relay for the information coming directly from the retina (interestingly, the left LGN processes information from the right eye, and vice versa — a pattern common in the human brain), and
4. _The Primary Visual Cortex_ — Final processing of the signals in the _primary visual cortex_ of the occipital lobe on the back of the brain.

## Optical Path

\begin{marginfigure}
    \includegraphics{EyeSchematic.pdf}
    \label{fig:eye_diagram}
    \caption{Anatomy of the human eye — Image (cc) by \href{https://commons.wikimedia.org/wiki/File:Schematic_diagram_of_the_human_eye_en.svg}{Rhcastilhos and Jmarchn, Wikimedia Commons}.}
\end{marginfigure}

Light enters the anterior chamber of the eye, travelling through the iris, then traversing the the vitreous humour (a gelatineous substance filling the interior of the eye) to the retina. 

Evolution has optimised the refractive index of the human cornea to yield an optimal air/cornea boundary, rendering the final image sharp on the retina. The lens, held in place by the ciliary body, and the suspensory ligaments, focuses the incident light onto the retina, and especially on the most sensitive part of the retina, the fovea. The fovea is about $1.5\,\mathrm{mm}$ in diameter and contains the most photoreceptor-dense region — $300000/\mathrm{mm}^2$ compared to $\approx 100000/\mathrm{mm}^2$ in the periphery [@Duchowski:2017ii; @Snowden:2012wu]. 

Foveal, or central vision only makes up about 5º of the field of vision.  In the most central part of the fovea, the foveola, about 133 cones per degree of visual angle lead to a resolvable frequency of 66 cycles/º, while at the fovea, the frequency already drop by about half, to 35 cycles/º [@Duchowski:2017ii]. In Figure \ref{fig:peripheral_vision}, we show a scheme of the different ranges of vision in humans, with the region below 30º being the _field of useful vision_. The movements of the eye, described in the next section, [Eye movements], are able to make up for the small field of useful vision by constantly scanning a scene. 

\begin{marginfigure}
    \includegraphics{peripheral_vision.png}
    \label{fig:peripheral_vision}
    \caption{Ranges for peripheral and central vision in humans. Central or foveal vision offers the highest acuity. Image (cc) by \href{https://commons.wikimedia.org/wiki/File:Peripheral_vision.svg}{Zyxwv99, Wikimedia Commons}.}
\end{marginfigure}

Apart from movements, the eye is also able to adapt itself internally to different viewing conditions. This adaption to visible objects happens in two ways:

* the iris size can be modulated, changing the amount of light reaching the retina by a up to a factor of 16. This contraction and expansion is not only due to light stimuli, but can also be triggered by drugs or hormonal changes, e.g. due to excitement, and
* ciliary muscles can modulate the lens thickness: when they relax, leading to tense zonules, the vision is adapted for distance, when they contract, the zonules get more slack, and the vision is adapted for closer objects — these are called vergence movements.

Vergence however is only one kind of the movements the eye can perform, so let's get into more detail about the other forms of movement.

### Eye movements

\begin{marginfigure}
    \includegraphics{EyeMuscles.jpg}
    \label{fig:EyeMuscles}
    \caption{Muscles of the human eye. Image (cc) by \href{http://patricklynch.net}{Patrick Lynch, Wikimedia Commons}.}
\end{marginfigure}

Following the classifications from [@Snowden:2012wu] and [@Duchowski:2017ii], eye movements fall into one of five categories:

* _Saccades_ are quick and jumpy movements of the eye to reposition the fovea to a new area of interest. As such, they can be voluntary or involuntary. In natural environments saccades occur with high speeds, and several times per second. Their peak angular velocity can exceed $900^\circ/\mathrm{s}$, take approximately $200\,\mathrm{ms}$ to initiate, and then last for about $10-200\,\mathrm{ms}$. Saccades are _stereotypical_ and _ballistic_: Stereotypical movement means they always follow the same pattern of fast initial acceleration after an initial processing delay of about $200\,\mathrm{ms}$, followed by movement with maximum velocity, and concluded by a rapid slowdown as the eye reaches the target area (see Figure \ref{fig:SaccadicMovements} for example time series). Ballistic movement means they are planned and, once initiated, cannot be stopped. During execution of the movement there is no visual perception, rendering the subject temporarilly blind. This effect is called _saccadic suppression_[^suppressionnote] [@Snowden:2012wu].
* _Smooth pursuits_ occur when a subject is tracking a moving stimulus, where the eye's angular velocity is matched to the movement of the image of the stimulus on the retina. These are the only smooth movements the eyes perform.
* _Fixations_, _tremors_, and _jitters_ occurs when a subject focuses on a particular object of interest. Counterintuitively, these movements do not completely fix the image on the retina, but jitter around it within about $5^\circ$ of visual angle. If they would not do that, the image would disappear within seconds. \TODO{Does this have to do with receptor bleaching?} This suggests that a different system is involved with fixations than with saccades or pursuits. Fixations last for about $150-600\,\mathrm{ms}$ and humans spend over 90% of viewing time with this kind of eye movement. It has also been found that miniature movements enhance the perception of high-frequency detail in a stimulus [@Rucci:20070f2].
* _Vergence_ movements occur when a subject is moving its attention between near and far objects, with the eyes then moving in opposite directions.
* (Physiological) _Nystagmus_ is a fast, compensatory movement of both eyes to either follow moving imagery (optokinetic nystagmus, such as when looking out of a train window), or when compensating for fast angular movements of the head (vestibular nystagmus). Both follow the same movement patterns.

[^suppressionnote]: The most visible effect of saccadic suppression in humans is the lack of motion blur during saccadic eye movements, opposed to e.g. fast head movements.

\begin{marginfigure}
    \includegraphics{SaccadeTimeSeries.pdf}
    \label{fig:SaccadicMovements}
    \caption{Example time series of saccadic eye movements: The movement starts after an initial processing delay of about $150\,\mathrm{ms}$, followed by fast movement for about $50-100\,\mathrm{ms}$. Image reproduced from \citep{Snowden:2012wu}.}
\end{marginfigure}

In the context of 2-dimensional localisation of gaze directions, fixations, saccades, and smooth pursuits are the most important eye movements. Vergence movements in turn can be used for 3-dimensional gaze estimation, e.g. by detecting independent gaze directions for each eye, and finding the intersection [@Mlot2016]. Future developments in display technology, where focus points can be modulated [@Huang:2015ce; @Jang:2017dr; @Sun:2017ia] will probably make that even more interesting.

All of the described movements are optimisations to provide the best image possible, using "the world's worst camera" [@Duchowski:2017ii]. We continue our discussion with the retina, the translator of photons to neural impulses.

## The Retina — Retinal Architecture and Processing

\begin{marginfigure}
    \label{fig:retina_architecture}
    \includegraphics{retina-architecture.pdf}
    \caption{Inverted retinal architecture of mammals. Adapted, original illustration (cc) by \href{https://commons.wikimedia.org/wiki/File:Retina_layers.svg}{Marc Gabriel Schmid}}  
\end{marginfigure}

At the retina, the processing of incident photons starts in the true sense of the word, as so far we have only been concerned with transmission, modulation, and focussing.

The retina of mammals has a somewhat odd architecture, seen in Figure \ref{fig:retina_architecture}: The light is entering from the bottom of the image, so the light has to travel through a dense forest of neurons before reaching the photoactive rods and cones. This kind of architecture is called _inverted retina architecture_. What the true benefits of an inverted architecture are remains a matter of debate.  

There are good reasons for the inverted architecture, such as easier supply of blood to the back side of the retina, rather than the front, which is very much needed by the (in terms of chemical energy) power-hungry photoreceptor cells. The neural tissue of the eyes has also been shown to act as waveguide for incoming photons, probably a mechanism to counter photon scattering through it [@Franze:20077e7]. One tradeoff is the existence of the blind spot where the optic nerve exits the eye, mended in most cases by the presence of two eyes, the [Eye movements] described before, and the upstream neural processing. 

After traversing this neuronal maze, photons reach the true actors of photon reception, the _rods_ and _cones_.

### Rods and cones

\begin{marginfigure}
    \includegraphics{rods-and-cones.pdf}
    \caption{The distribution of rods and cones in dependence of the visual angle. While the distribution of cones sharply peaks around the fovea, the distribution of rods falls off way slower in the periphery, and rods do not exist entirely at the fovea. Adapted from \citep{Duchowski:2017ii}.\label{fig:RodsAndCones}}
\end{marginfigure}

These are the workhorses of the retina, responding in different lighting intensity conditions: While rods are highly sensitive in dim conditions,  the _scotopic_ regime, even responding to single-photon stimuli (_rhodopsin_ is responsible for the actual reception in rods, and absorbs green light most strongly), cones respond more sensitively in high-intensity conditions, the _mesopic_ regime. While cones exist in long-wavelength, middle-wavelength, and short-wavelength flavours, often called red, green, and blue, rods only exist in a single flavour. 

Coming back to the distribution of photoreceptors among the retina, both types also follow different patterns: While most — $150000/\mathrm{mm}^2$ — of the rods exist around $12^\circ-15^\circ$ of visual angle, the density of cones peaks at the fovea at $0^\circ$ of visual angle, also with about $150000/mm^2$. The cone density falls off sharply outside the fovea, reaching a density as low as $\approx 15000/mm^2$ at $15^\circ$. 

There are no rods at the fovea, and their falloff is not as sharp, slowly waning to about $50000/mm^2$ in the periphery at $80^\circ$[@Snowden:2012wu]. See Figure \ref{fig:RodsAndCones} for a graph of the distribution.

The perceptual consequences of this distribution are interesting: While the sensitivity to color changes in the periphery sinks quite drastically due to the reduced number of cones, contrast sensitivity due to rods is still quite high.

### Retinal ganglion cells

Retinal ganglion cells are responsible for wiring the photoreceptors of the retina to the _lateral geniculate nucleus_ (LGN) in the thalamus, and are actually dendrites of the optic nerve. What they are doing can already be described as image processing: They are wired to the photoreceptors in a layout that is essentially circular, with the area of responsibility called a _receptive field_. 

A receptive field contains about 100 photoreceptors and consists of an inner and an outer ring that act in competition with each other: starting from their baseline neuronal activity, ON-center cells fire more when the center is stimulated, and the outside is not, while OFF-center cells fire more when the center remains unstimulated, but the outside is stimulated (_center-surround decorrelation_).

Instead of acting like the pixels of a camera sensor, this behaviour makes ganglion cells basically edge detectors, transmitting mostly the edge information downstream, which results in a large reduction in the amount of data that needs to be transmitted. Let's do an example calculation of the effect this has:

Retinal ganglion cells receive input from about about $128000000$ cells — about $120000000$ rods and $8000000$ cones —  assumed to carry, for simplicity, or 8bit of data, equivalent to 256 shades of gray. Assuming a "refresh rate" of 30 Hz, this amounts to $\approx 4\,\mathrm{GiB/s}$(!). The ganglion cells however only have about $1000000$ outputs connecting to the next processing area, the LGN, reducing the necessary data rate to the LGN to about $30\,\mathrm{MiB/s}$ [@brenner2000adaptive; @koch2006much]. Would the optic nerve carry through all the neural connections from the rods and cones, it would not have an average $3.5\,\mathrm{mm}$ diameter, but about $20\,\mathrm{mm}$, severely restricting the possible movements of the eye.



## The Lateral Geniculate Nucleus

First, the axons from both eyes cross over at a point called the _optic chiasm_. There, the axons from the nasal side of each retina cross to the other side of the brain, while the axons from the temporal side do not cross. The part of the nerves between the optic chiasm and the LGN is called the _optic tract_.

The LGN itself has a 6-layer, staggered architecture: Projections from the same side (_ipsilateral_) end up in layers 2, 3, and 5, while projections from the opposite side (_contralateral_) end up in 1, 4, and 6 — and projections from the same visual area connect to the same place in all the layers. In the LGN, three types of cells are found, that in some cases refine the receptive field structure of the retinal ganglion cells:

* _magnocellular_ (M) cells, large, fast-responding cells connected to rods,  to be found in the first two layers,
* _parvocellular_ (P) cells, small, slow-responding cells, connected to the cones, and found in layers 3-6,
* _koniocellular_ (K) cells, consisting of very small, heterogeneous cells, connected to only blue cones, to be found _between_ the M and P layers.

The M and P cells have complimentary functional characteristics, with certain similarities to the photoreceptors they connect from (from [@Duchowski:2017ii):

| Characteristic | Magnocellular cells | Parvocellular cells |
|:--|:--|:--|
| Ganglion size | Large | Small |
| Transmission time | Fast | Slow |
| Receptive fields | Large | Small |
| Sensitivity to small objects | Poor | Good |
| Sensitivity to change in light levels | Large | Small |
| Sensitivity to contrast | Low | High |
| Sensitivity to motion | High | Low |
| Color discrimination | No | Yes |

The function of the K cells remains a bit nebulous: They might play a role in motion detection and where-and-when processing [@Eiber:20182bf] and regulate other visual pathways [@Martin:2019cd1], and most likely are heterogeneous and form subpopulations [@Casagrande:1994tp].

Another striking fact about the LGN is that it does not receive most of its input from the retinal ganglion cells, but actually from the visual cortex itself. Through this feedback loop, the LGN is able to play a vital role in the direction of visual attention, focussing, and vergence of the eyes, as well as in stereoscopic mapping of the visual field.

Just as the retinal ganglion cells provide a spatial coding of their inputs by forming receptive fields, the LGN provides a temporal coding, resulting in an even more efficient transmission of information.

In terms of functional relevance to eye movements, the LGN plays an important role in the execution of saccades [@Krebs:20105e6], as well as indirectly controlling the ciliary muscles for vergence and focus described in [Optical Path].

## The Superior Colliculus

The Superior Colliculus again has a layered structure, with 7 layers in total. The first three layers are called superficial layers and connect mainly to the retina and the LGN. The remaining intermediate and deep layers receive connections from a variety of sources, such as somatosensory inputs and the cerebral cortex in general. The superficial layers also have outputs to the LGN.

The Superior Colliculus is heavily involved in the control of the eye movements. Each of the colliculi, which are located on the left and right side of the brain, can be mapped to respective halves of the visual field. Experiments with electrical microstimulation in monkeys have shown that, depending on the site of the stimulus, either saccades or fixations can be evoked [@Klier:20019e6]. The coordinate system used by the Superior Colliculus is also not world coordinates, but retinal coordinates, where the area of the colliculus covered corresponds with the receptor counts in the visual field (see Figure \ref{fig:peripheral_vision}).

## The Visual Cortex

\begin{marginfigure}
    \includegraphics{v1-layers.jpg}
    \caption{\label{fig:v1_architecture}Correlation of the layered architecture in the LGN (lower half) with the cell layers in the Primary Visual Cortex (upper half): Neurons from the magnocellular, parvocellular and koniocellular LGN layers project into similar sublayers of the cortex. Observe that V1 layer L6 also projects back to the LGN. Reproduced from \citep{Thomson:2010de}.}
\end{marginfigure}

The axons leaving the LGN are called the _optic radiation_, and enter the _primary visual cortex_ (also called or _V1_ or _striate cortex_) in the occipital lobe of the brain.

In Figure \ref{fig:v1_architecture}, we can appreciate the — again — layered architecture of the primary visual cortex: A crucial difference this time is that the contralateral _and_ ipsolateral projections arrive in the same layer. Additionally does layer 6 provide a feedback connection to the LGN, while layers 2, 3, and 5 also connect to areas outside the primary visual cortex. Large parts of the primary visual cortex are solely responsible for the fovea, and with increasing visual angle (compare again Figure \ref{fig:peripheral_vision}), there are less and less cells associated.

But what does the primary visual cortex then do with the input? The cells in the primary visual cortex are tuned to orientation, and organised in _orientation columns_, meaning that cells responsible for a particular orientation are in the same column. A collection of orientation columns, called a _hypercolumn_ then encodes all the possible orientations occurring in one visual area.

The hypercolumns can contain three different types of cells:

* _Simple Cells_: Not only does the layered architecture continue, but also the division in receptive fields. In contrast to the LGN's center-surround architecture, _simple cells_ in V1 form bar structures, with either two or three areas that can be excitatory or inhibitory, and thereby form either bar or edge detectors.
* _Complex Cells:_ They add together (e.g. with a mathematical _or_ operation) the outputs of multiple simple cells, resulting in a receptive field that is not only sensitive to the orientation of the stimulus, but also to its relative position within the field.
* Finally, _Hypercomplex cells_ or _End-stopped cells_ wire together multiple complex cells, to additionally provide inhibition if a stimulus exceeds the receptive field — complex cells would continue to fire there, and are thereby able to detect curved stimuli [@Yazdanbakhsh:2006ec0; @Snowden:2012wu].

## Consequences for the Design of Eye-based Interfaces

From the architecture of the visual system, we can draw a series of conclusions on how eye-based user interfaces need to be designed (in extension of [@Duchowski:2017ii]):

* _Cones fall off sharply outside the foveal region, high number of rods still exists in the periphery_ $\Rightarrow$ Color information (chrominance) can fall off as sharply outside the foveal region, while brightness (luminance) should not degrade as fast.
* _Magnocellular ganglion cells respond most strongly to stimuli in the periphery_ $\Rightarrow$ contrast changes should only happen on purpose there, as the visual system can react strongly to objects appearing suddenly in the periphery, responding e.g. with a saccade to the new highly salient object. Interfaces where gaze is used as selection modality, or where gaze is used more passively, e.g. to indicate current attention (gaze-contingent interfaces, see [Review of Interaction Techniques]) or which actively manage the users attention (attentive user interfaces) need to take special care about this.
* _Saccades lead to temporary blindness (saccadic suppression)_ $\Rightarrow$ eye tracking information correlated with e.g. saliency during a saccade might not be useful.
* _Smooth movements are not possible without smooth pursuit movements_ $\Rightarrow$ the limited possibility of voluntary, smooth movement needs to be taken into consideration e.g. when designing eye gesture-based interfaces.
* _Eye movements have characteristic velocities and durations_ $\Rightarrow$ can be taken into consideration for systemic modelling of  eye movements. As consequence, gaze-contingent or attentive user interfaces must not react too fast or require too swift user interaction.
* _Eye tracking is not instant_ $\Rightarrow$ the processing delay of eye tracking hardware and software also needs to be taken into account.

## Challenges and Opportunities

### Efficient representation of volumetric data

Adaptive sampling and by that, data reduction is done very efficiently already by the retinal ganglion cells. In [Retinal ganglion cells], we discussed that by the formation of receptive fields, these cells already reduce the data that has to be transmitted through the optic nerve from 4 GiB/s to about 30 MiB/s. Is it possible to use a similar approach for data reduction in the processing of volumetric data? In the chapter [Rendering the Adaptive Particle Representation] we discuss a data reduction technique, the Adaptive Particle Representation [@Cheeseman:2018b12] inspired exactly by that.

### Object tracking with support of the visual system

A task often encountered in image-based developmental and systems biology is the tracking of objects in volumetric data. One example is to identify cells in consecutive volumetric images that correspond to each other. Another example is the tracing of neurons from large still images, to ultimate generate a connectome — a representation of which neuron connects to which — in an effort to identify functional connections and correlations (see e.g. [@Swanson:2016ht] for a review). In the chapter [Attentive Tracking — or — Tracking for Tracking] for a prototype of how to use smooth pursuit eye movements for cell tracking. Solving such tracking problems via eye tracking further requires robust eye tracking algorithms, a topic we also briefly touch in that chapter.


### Optimal Viewpoint Determination by Modelling Visual Attention

Models for modelling visual attention based on image content have already been proposed [@Itti:2001cl; @Gao:2014a3e]. In the context of image analysis and visualisation of large datasets it is becoming more important to find optimal viewpoints, e.g. for exploration, education or presentation purposes. A computational model of visual attention can help here to select the visually most interesting or salient images and viewer positions. One could imagine feeding the model with a random selection of viewpoints on the dataset, and evolving them in a manner they converge to the most salient points. Another option would be a combination of eye tracking and saliency modelling: The area the user is looking at could be analysed for the most salient neighbourhood, and the dataset translated or rotated accordingly. Both are however beyond the scope of this work, but might be pursued in the future.


