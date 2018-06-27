# Visual Processing

Visual processing of photons received by the eye's lens, cornea, and ultimately, by the retina and visual cortex, is the basic process enabling cross reality and eye-based natural user interfaces. 

In this chapter, we introduce the movements performed by the human eyes, and then give a short tour of the human visual system, including the optical path of photons, and the processing that happens in the retina and downstream in the central nervous system.

## Eye movements

Following the classifications from [@Duchowski:2017ii] and [@Snowden:2012wu], we can categorise eye movements into these categories:

* _Saccades_ are quick, jumpy voluntary or involuntary movements of the eye to reposition the fovea to a new area of interest. In natural environments, saccades occur with high speeds, and several times per second. Their peak angular velocity can exceed $1000^\circ/\mathrm{s}$, and they last about $10-100\,\mathrm{ms}$. Saccades are _stereotyped_ movements in the sense that they always follow the same pattern of fast initial acceleration, movement with maximum velocity, followed by a rapid slowdown as the eye reaches the target area. The movements are also _ballistic_, meaning they are planned and, once initiated, cannot be stopped, rendering the subject effectively blind for their duration.
* _Smooth pursuits_ occur when a subject is tracking a moving stimulus, where the eye's angular velocity is matched to the movement of the image of the stimulus on the retina.
* _Fixations_, _tremors_, and _jitters_ occurs when a subject focuses on a particular object of interest. Counterintuitively, these movements do not completely fix the image on the retina, but jitter around it within about $5^\circ$ of visual angle. If they would not do that, the image would disappear within seconds. \TODO{Does this have to do with receptor bleaching?} This suggests that a different system is involved with fixations than with saccades or pursuits. Fixations last for about $150-600\,\mathrm{ms}$ and humans spend over 90% of viewing time with this kind of eye movement.
* _Vergence_ movements occur when a subject is moving its attention between near and far objects.
* (Physiological) _Nystagmus_ is a fast, compensatory movement of both eyes to either follow moving imagery (optokinetic nystagmus, such as when looking out of a train window), or when compensating for fast angular movements of the head (vestibular nystagmus). Both follow the same movement patterns.

In the context of 2-dimensional localisation of gaze directions, fixations, saccades, and smooth pursuits are the most important eye movements. Vergence movements would also be desirable to detect, but considering that even contemporary head-mounted VR displays are using regular, flat screen, with no possibility of actual scene depth, this is not a priority yet. Future displays are going to provide focus queues as well and will change that [@Jang:2017dr; @Sun:2017ia; @Huang:2015ce].

Let's continue this chapter by touring the human visual system, and connecting the aforementioned eye movements with their neurological basis:

## A Short Tour of the Human Visual System

![\label{fig:eye_diagram}Anatomy of the human eye -- 
**1**: posterior segment of eyeball **2**: ora serrata **3**: ciliary muscle **4**: ciliary zonules/zonules of Zinn **5**: canal of Schlemm **6**: pupil **7**: anterior chamber **8**: cornea **9**: iris **10**: lens cortex **11**: lens nucleus **12**: ciliary process **13**: conjunctiva **14**: inferior oblique muscle **15**: inferior rectus muscle **16**: medial rectus muscle **17**: retinal arteries and veins **18**: optic disc **19**: dura mater **20**: central retinal artery **21**: central retinal vein **22**: optic nerve **23**: vorticose vein **24**: bulbar sheath **25**: macula **26**: fovea **27**: sclera **28**: choroid **29**: superior rectus muscle **30**: retina, Image (cc) by [Ignacio Icke](https://commons.wikimedia.org/wiki/File:Eye-diagram_no_circles_border.svg)](./figures/eye-diagram.pdf){ width=50% }

On an abstract level, the processing of visual stimuli happens in multiple stages (with the human eye depicted in figure\ref{fig:eye_diagram}):

1. Accumulation of incoming photons by the optical system consisting of the _cornea_ (8), _iris_(9), and _lens_(11) onto the _retina_(30), and especially the most sensitive part of the retina, the _fovea_(26).
2. Pre-processing in the _Lateral Geniculate Nucleus_ (LGN) situated in the _thalamus_ part of the forebrain, serving as a relay for the information coming directly from the retina. Fascinatingly, the left LGN processes information from the right eye, and vice versa -- a pattern common in the human brain.
3. Final processing in the _visual cortex_ of the occipital lobe on the back of the brain.

## Optical Path

Light enters the anterior chamber (7) of the eye, and travels through the iris (9), traversing a gelatineous substance, the vitreous humour, to the lens (11). Evolution has optimised the refractive index of the human cornea to yield an optimal air/cornea boundary, rendering the final image sharp on the retina. The lens, held in place by the ciliary body (3), and the zonules of Zinn, focuses the incident light onto the retina, and especially on the most sensitive part of the retina, the fovea(26), containing the most photoreceptor-dense region ($150000/mm^2$ compared to $\approx 15000/mm^2$). 

Adaption to visible objects happens in two ways:

* the iris size can be modulated, changing the amount of light reaching the retina by a factor of 16[^irisnote].
* ciliary muscles can modulate the lens thickness; when they relax, leading to tense zonules, the vision is adapted for distance, when they contract, the zonules get more slack, and the vision is adapted for closer objects — these are the aforementioned vergence movements.

[^irisnote]: The iris not only contracts and expands due to light stimuli, but can also be affected by drugs or hormonal changes, e.g. due to excitement.

## Retinal architecture and processing

![\label{fig:retina_architecture}Inverted retinal architecture of mammals (light path in the image is bottom to top); **RPE**: retinal pigment epithelium; **OS**: outer segment of the photoreceptor cells; **IS**: inner segment of the photoreceptor cells; **ONL**: outer nuclear layer; **OPL**: outer plexiform layer; **INL**: inner nuclear layer **IPL**: inner plexiform layer; **GC**: ganglion cell layer; **P**: pigment epithelium cell; **BM**: Bruch-Membran; **R**: rods; **C**: cones; **H**: horizontal cell; **B**: bipolar cell; **M**: Müller cell; **A**: amacrine cell; **G**: ganglion cell; **AX**: Axon, Image (cc) by [Marc Gabriel Schmid](https://commons.wikimedia.org/wiki/File:Retina_layers.svg)](./figures/retina-architecture.pdf){ width=50% }

At the retina, the computational processing of incident photons starts in the true sense of the word, so far we've been only concerned with transmission, modulation, and focussing.

A mammal's retina has a somewhat odd architecture, seen in Figure\ref{fig:retina_architecture}, where the light is entering from the bottom of the image. This kind of architecture is called _inverted retina architecture_, as the light has to travel through a maze of neurons and ganglion cells, before reaching the true actors of photon reception, the _rods_ and _cones_. Why this kind of retina architecture has evolved in mammals, or has not been "corrected", is still a matter of scientific debate \TODO{Add citations for retina architecture}. There are good reasons for the inverted architecture, such as easier supply of blood to the back side of the retina, than the front, which is very much needed by the (in terms of chemical energy) power-hungry photoreceptor cells. A tradeoff however is the existence of the blind spot where the optic nerve exits, mostly mended by the presence of two eyes.

### Rods and cones

These are the workhorses of the retina, responding in different lighting intensity conditions: While rods are highly sensitive in dim conditions,  the _scotopic_ regime, even responding to single-photon stimuli (_rhodopsin_ is responsible for the actual reception in rods, and absorbs green light most strongly), cones respond more sensitively in high-intensity conditions, the _mesopic_ regime. Rods are also all the same, while cones exist in long-wavelength, middle-wavelength, and short-wavelength flavours, often called red, green, and blue. 

Coming back to the distribution of photoreceptors among the retina, both types also follow different patterns: While most — $150000/mm^2$ — of the rods exist around $12^\circ-15^\circ$ of visual angle, the density of cones peaks at the fovea at $0^\circ$ of visual angle, also with about $150000/mm^2$. The cone density falls off sharply outside the fovea, reaching a density as low as $\approx 15000/mm^2$ at $15^\circ$, while there are no rods at the fovea, and their falloff is not as sharp, slowly waning to about $50000/mm^2$ in the periphery at $80^\circ$.

### Retinal ganglion cells

Retinal ganglion cells are responsible for wiring the photoreceptors of the retina to the _lateral geniculate nucleus_ in the thalamus. What they are doing can already be described as image processing: They are wired to the photoreceptors in a layout that is essentially circular, with the area of responsibility called a _receptive field_. The layour of a receptive field consists of an inner and an outer ring that act in competition with each other: starting from their baseline activity, ON-center cells fire more when the center is stimulated, and the outside is not, while OFF-center cells fire more when the center remains unstimulated, but the outside is stimulated (center-surround decorrelation). This behaviour makes ganglion cells basically differentiators, or better, edge detectors, transmitting only the edge information downstream, also resulting in a large reduction in the amount of data that needs to be transmitted[^retina-data-rate-note]

[^retina-data-rate-note]: The ganglion cells receive input from about about $128000000$ cells — $120000000$ rods, $8000000$ cones — carrying (for simplicity) 256 shades of gray, or 8bit of data. Assuming a "refresh rate" of 30 Hz, this amounts to $\approx 4\,\mathrm{GiB/s}$(!). The ganglion cells however only have about $1000000$ outputs, reducing the data rate to the LGN to about $30\,\mathrm{MiB/s}$.

## From the retina to the LGN

\TODO{add citations for cell type stuff}

The axons from both eyes cross over at a point called the _optic chiasm_. There, the axons from the nasal side of each retina cross to the other side of the brain, while the axons from the temporal side do not cross. The part of the nerves between the optic chiasm and the LGN is called the _optic tract_.

The LGN itself has a 6-layer architecture, and consists of three types of cells, that in some cases refine the receptive field structure of the retinal ganglion cells:

* _magnocellular_ (M) cells, large, fast-responding cells connected to rods,  to be found in the first two layers,
* _parvocellular_ (P) cells, small, slow-responding cells, connected to the cones, and found in layers 3-6,
* _koniocellular_ (K) cells, consisting of very small cells, connected to only blue cones, to be found _between_ the M and P layers.

The inputs from each eye are staggered: Projections from the same side (_ipsilateral_) end up in layers 2, 3, and 5, while projections from the opposite side (_contralateral_) end up in 1, 4, and 6 — and projections from the same visual area connect to the same place in all the layers.

While the functions of the M and P cells are more or less clear, the function of the K cells remains a bit nebulous, it may link visual perception to proprioception (the sense of body part positioning), and play a role in color perception.

The most striking fact about the LGN is that it does not receive most of its input from the retinal ganglion cells, but actually from the visual cortex itself. Through this feedback loop, the LGN is able to play a vital role in the direction of visual attention, focussing and vergence of the eyes, and stereoscopic mapping of the visual field.

Just as the retinal ganglion cells provide a spatial coding of their inputs, the LGN provides a temporal coding, resulting in an even more efficient transmission of information.

## From the LGN to the Visual Cortex

![\label{fig:v1_architecture}V1 architecture, reproduced from [@Thomson:2010de]](./figures/v1-layers.jpg){ width=50% }

The axons leaving the LGN are called the _optic radiation_, and enter the _primary visual cortex_, or _V1_[^primarynote], or _area 17_, or _striate cortex_ in the occipital lobe of the brain.

In Figure \ref{fig:v1_architecture}, we can appreciate the — again — layered architecture of V1: A crucial difference this time is that the contralateral _and_ ipsolateral projections arrive in the same layer. Additionally does layer 6 provide a feedback connection to the LGN, while layers 2, 3, and 5 also connect to areas outside V1. Large parts of V1 are solely responsible for the fovea, and with increasing visual angle, there are less and less cells associated. 

But what does V1 then do with the input? The cells in V1 are tuned to orientation, and organised in _orientation columns_, meaning that cells responsible for a particular orientation are in the same column. A collection of orientation columns, called a _hypercolumn_ then encodes all the possible orientations occuring in one visual area.

### Simple cells

Not only does the layered architecture continue, but also the division in receptive fields. In contrast to the LGN's center-surround architecture, _simple cells_ in V1 form bar structures, with either two or three areas that can be excitory or inhibitory, and thereby form either bar or edge detectors.

### Complex cells

_Complex cells_ then adding (e.g. _OR_'ing) together the outputs of multiple simple cells, resulting in a receptive field that is not only sensitive to the orientation of the stimulus, but also to its relative position within the field.

### Hypercomplex cells

_Hypercomplex cells_ then, in turn, wire together multiple complex cells, to additionally provide inhibition if a stimulus exceeds the receptive field — complex cells would continue to fire there.

[^primarynote]: We're going to use this name in the rest of the thesis.

