# Eye Tracking and Gaze-based Interaction

Eye tracking is the process of following the direction of the user's eyes in order to determine what the user is looking at, and deriving information, context, and actions from that. 

## Eye Tracking Technologies

In this section, we're introducing common eye tracking technologies, and in the end compare them for user-friendliness and applicability for practical usage scenarios.

### Search Coil Contact Lenses

\begin{marginfigure}
    \includegraphics{ScleralEyeTracking.png}
    \caption{Scleral search coil contact lens eye tracking schematic, reproduced from \citep{Robinson:1963wf}.\label{fig:ScleralEyeTracking}}
\end{marginfigure}

Search Coil Contact Lenses constitute the earliest[@Robinson:1963wf] and probably most invasive form of eye tracking. For this form of eye tracking, a contact lens fitted with a coil is put directly on the user's sclera, who has to sit in a uniform magnetic field. Movements of the coil then cause an electric current, which is measured and correlated with the user's eye angle. This kind of eye tracking yields high spatiotemporal precision (< 1ms temporal resolution, <1º spatial resolution). See Figure \ref{fig:ScleralEyeTracking} for a sketch of the principle.

### Electrooculography

\begin{marginfigure}
    \includegraphics{Electrooculography.png}
    \caption{Electrooculography in use, still image reproduced from \href{https://www.youtube.com/watch?v=-QXGiZBDkUw}{Biopac Student Lab, youtu.be/QXGiZBDkUw}\label{fig:eog}}
\end{marginfigure}

In electrooculography, the user's eyes are tracked by measuring potential changes on its skin. The technology employed is very similar to electroencephalography (EEG) or electromyography (EMG) — electrodes are placed around the eyes, and from the registered signal, the horizontal and vertical orientations of the eye ball are inferred. Additionally, a scalp electrode can be placed to also measure radial movements, yielding highly precise timings for the onset of saccadic movements [@Keren:2010jd]. Albeit EOG is plagued by the same issues as EEG/EMG — namely drift over time, and not entirely reproducible signal amplitudes, leading to inaccuracies for the generation of absolute eye positioning data — it does not rely on the user's eyes being visible, which can be a plus depending on the usage scenario. EOG can yield a horizontal resolution of 1-2º, while the vertical accuracy is usually less due to artifacts from lid movements [@Heide:1999we]. Compared to contact lenses it is much less invasive, and compatible with wearers of both glasses and regular, correcting contact lenses. See Figure \ref{fig:eog} for an exemplary electrooculography setup.

### Videooculography and Purkinje Imaging

\begin{marginfigure}
    \includegraphics{PupilEyeTracker.png}
    \caption{A videooculography setup, the Pupil Pro headset. Reproduced from \citep{Kassner:2014kh}.\label{fig:VideoOculography}}
\end{marginfigure}

In videooculography, the user's eyes are imaged by one camera per eye, focused on the pupil. Contemporary devices use infrared light to either track the pupil directly, or to image reflections created by the anterior and posterior surfaces of the cornea — the Purkinje images, see Figure \ref{fig:PurkinjeImages} — which can then be used to calculate a vector between the pupil's center and the reflection to determine the point the user is looking at [@Gneo:2012kn]. This technique requires calibration in the beginning, and might also drift in longer tracking sessions. Yet, it is very unintrusive, and only requires a camera mounted to either an existing or new set of glasses (see Figure \ref{fig:VideoOculography}), or a set of two cameras mounted inside a HMD (see Figure \ref{fig:HMDEyeTracking}). VOG yields a high spatial accuracy (~1º), while temporal accuracy suffers a bit due to camera and processing latencies (~3-5ms).

![Videooculography using a HMD-based eye tracker from Pupil Labs, mounted on an HTC Vive. Image reproduced from [pupil-labs.com/vr-ar](https://pupil-labs.com/vr-ar/).\label{fig:HMDEyeTracking}](PupilEyeTrackerHMD.png)

\begin{marginfigure}
    \includegraphics{PurkinjeImages.png}
    \caption{The physical origin of Purkinje images P1 to P4: \emph{P1}, reflection on anterior corneal surface; \emph{P2}, reflection on the posterior corneal surface; \emph{P3}, reflection on the anterior surface of the lens; \emph{P4}, reflection on posterior surface of the lens. Image (cc) by Z22, \href{https://commons.wikimedia.org/wiki/File:Diagram_of_four_Purkinje_images.svg}{Wikimedia Commons}.\label{fig:PurkinjeImages}}
\end{marginfigure}

In addition to the regular videooculography modalities, a recent study from Wang, et al. [@Wang:2016fz] makes use of thermal video imaging of the cornea, which is about 0.5ºC cooler than the limbus. They segment the thermal image, and locate the position of the cornea in the segmentation. They achieved a fair accuracy of ~2.3º, mostly limited by the resolution of the thermal sensor.

With _Pupil_[@Kassner:2014kh] and _Oculomatic_ [@Zimmermann:2016hv], now  open-source, open-hardware solutions exist for videooculagraphy-based eye tracking.

### Comparison

| Modality | Setup Effort | Intrusiveness | Comfort | Spatial Accuracy | Temporal Accuracy |
|:--|:--|:--|:--|:--|:--|
| Scleral Contact Lenses | Very High | Very high | Low | <1º | <1ms |
| Electrooculography | High | Medium | High | 1-2º | >2º |
| Videooculography | Low | Low | High | 1º | 2-5ms |

Table: Comparison of eye tracking modalities. {#tbl:EyeTrackingComparison}

From the discussion of the various modalities, we conclude:

* _Search Coil Contact Lenses_ remain the gold standard for eye tracking in clinical settings, where the highest spatiotemporal precision is required, and precision outweighs their low user comfort and high setup effort.
* _Electrooculography_ is the most useful technique if relative eye coordinates are sufficient, or if the application might include the user's eyes not being visible, e.g. as it is the case in sleep analysis applications.
* _Videooculography_ is the most useful technique when it comes to day-to-day use, due to its easy setup and low to inexistent user discomfort. Also, both software and hardware for such a setup is readily available [@Kassner:2014kh; @Zimmermann:2016hv].

## Common issues

There exist some issues common to eye tracking applications: In this section, we are going to detail the _Midas Touch Problem_ and the _Double Role of Gaze_, Accuracy and Reliability, Availability, and Privacy.

### Midas Touch Problem and the Double Role of Gaze

The notion of the _Midas Touch Problem_ was introduced by Jacob in 1990 [@Jacob:1990hz], and describes the issue that by looking at an object, the user inadvertently triggers an action. It is named after the Greek fable of King Midas, who, after wishing that everything he touches would turn to gold, ultimately starved to death.

The Midas Touch Problem is intimately linked with the _Double Role of Gaze_: while visual attention can be actively directed, it is also often influenced by visual distractions that carry a high saliency, such as flashing lights, fast moving objects, or even input from other senses, such as loud bangs. A shift towards passive attention may cause a disruption of the workflow of the user, or can, in the sense of the Midas Touch Problem, lead to wrong inputs. The issues are especially pronounced in the case that one wants to emulate mouse-based input with gaze input.

Both issues can be addressed e.g. by providing the user with an additional means to confirm that the selection action is actually the one he intends to perform. This can be achieved with a variety of means:

* _dwell time-/blink-based selection_, where an action is only triggered after the user has rested his gaze on the object [@Jacob:1990hz], or blinked once or multiple times as confirmation [@jacob:1993; @Ashtiani:2010dw]. These solutions lead to additional delays for the input, which, depending on the intent might or might not be a problem:  If fast interaction is intended, e.g. for selecting highly salient objects in fast succession, dwell/blink-based confirmation is problematic, while when interacting e.g. with locked-in patients, it may provide an excellent way for communicating [@Ashtiani:2010dw].
* _multimodal interaction_, where the user can utilise an additional device to confirm his intent, for example by pressing a button on a keyboard[@Castellina:vg], using an additional touchpad [@Meena:2017bn],   a foot pedal or foot mat [@Klamka:2015ka, @Hatscher:2017bi], or free-air pinch gestures [@Pfeuffer:2017jk].
* _computer vision techniques_, where visual attention and saliency [@Itti:2001cl] is modelled computationally, to determine which is the most probably object of attention at the moment [@Wu:2015kt; @Theis:2018tw].

### Accuracy and Reliability

Due to individual differences between users, and also between different spike trains in EOG, measurement of gaze cannot be 100% correct. For cursor-based applications, filtering approaches can be used to weed out erratic recognitions [@Zhang:2008ex], and adjusting the interface shown to the user, e.g. via magnifying it or exaggerating details (see [@Cockburn:2009kj] for a review).

HMD-based eye tracking here has the benefit that the lighting situation can be controlled, and it'll mostly be dark inside the eye piece of the HMD, leading to more predictable and reliable gaze detection. For screen-mounted or mobile eye trackers however, the situation is a bit more difficult, as they might be used in many different lighting scenarios.

In terms of recognition reliability, advances have been made in recent years towards model-free determination of gaze, e.g. via artificial neural networks [@Gneo:2012kn]. One can expect this trend to continue, leading to more reliable algorithms. _Pupil_ [@Kassner:2014kh] for example uses a combination of image segmentation combined with model-based gaze estimation.

### Availability

Still back in 2014, eye tracking hardware was very expensive, with both screen-mounted and HMD-mounted trackers costing in excess of 10000 EUR.

Since then, new projects have emerged that provide either low-cost or open-source eye trackers, or even both. Examples of such projects are: 

* _Pupil_ [@Kassner:2014kh], where ready-to-use eye trackers for glasses, mobile or HMD use can be bought, but the bill of materials, construction manual, and software are open-sourced (see [github.com/pupil-labs/pupil](https://github.com/pupil-labs/pupil) and [docs.pupil-labs.com](https://docs.pupil-labs.com)).
* _Oculomatic_ [@Zimmermann:2016hv], which provides an open-source toolkit, as well as schematics for high-speed eye tracking, primarily for use in oculomotor research.
* _aGlass_, which has recently announced the availability of a low-cost, full-FOV eye tracking development kit for the HTC Vive, mainly to facilitate foveated rendering [@Pohl:2016fy].

These developments lead us to believe that widespread and cost-effective use of eye-tracking hardware will soon become a reality.


### Privacy

With eye movements being an additional data point that can be used to fingerprint persons and track them through different media and situations, privacy is of course a concern when employing eye tracking.

This concern becomes even more important, as Hoppe, et al. have recently shown that tracking eye movements in daily activities is able to predict four of the Big Five personality traits [@Hoppe:2018ko] — namely neuroticism, extraversion, agreeableness, and conscientiousness —, and additionally, also perceptual curiousity [@Collins:2004ks]. The possibility of doing that makes it absolutely clear that acquired eye tracking data has to stay with the user, and must not leave the computer for outside processing, as the misuse potential is very high. 

With e.g. Facebook also evaluating eye tracking for foveated rendering for their next-generation Oculus headsets[^oculuseyetrackingnote], it remains to be seen whether eye tracking will turn into a privacy nightmare, or stay user-governed as a very promising and useful technology for future human-computer interaction.

[^oculuseyetrackingnote]: See e.g. [uploadvr.com/oculus-is-working-on-eye-tracking-technology-for-next-generation-of-vr/](https://uploadvr.com/oculus-is-working-on-eye-tracking-technology-for-next-generation-of-vr/) or [uploadvr.com/oculus-patented-new-eye-tracking-device-days-acquiring-eye-tribe/](https://uploadvr.com/oculus-patented-new-eye-tracking-device-days-acquiring-eye-tribe/).

## Classification of Gaze-based User Interfaces

\begin{figure*}
    \includegraphics{eye-tracking-classification.pdf}
    \caption{Classification of gaze-based interaction. Left: According to \citep{Duchowski:2017ii}, Right: according to \citep{stellmach2013}. Figure reproduced from \citep{stellmach2013}.\label{fig:EyeTrackingClassification}}
\end{figure*}

Several classifications of gaze-based user interfaces have been proposed:

* [@Duchowski:2017ii] proposes a distinction between _interactive_ and _diagnostic_ eye tracking systems, and further discerns the interactive systems into _selective_ and _gaze-contingent_ systems. Gaze-contingent systems, where the user's gaze is utilised to determine e.g. the current area of interest, are then divided into screen-based and model-based systems. See Figure \ref{fig:EyeTrackingClassification}L for a depiction.
* [@stellmach2013] extends on Duchowski's classification, keeping the distinction between interactive and diagnostic eye tracking, but discerning the interactive part into _gaze-directed pointing_, _eye-based clicking_, and _eye gestures_. Pointing is further distinguished into by precision (precise, coarse) or abstraction (point, target, or area-based). Gaze-contingent interaction is included in the gaze-directed pointing branch. The gaze-based input modalities are optionally combined with another input device (multimodal input). See Figure \ref{fig:EyeTrackingClassification}R for a depiction.
* [@hirzle2019] introduces another classification scheme, specialised for the use with head-mounted AR or VR displays. Their scheme aims at both at the classification of existing applications, and at an ideation tools to create new interactions. Hirzle's approach classifies based on the use of _device type_ (VR or AR), _display type_ (monoscopic or stereoscopic), _world knowledge_ (based on [@Milgram:1995cl], full or none). World knowledge deserves more explanation: It describes how much the computer knows about the surrounding world of the user — none means no knowledge, and full means complete knowledge of geometry and also semantics. In the case of VR, the computer can only have full information about the user's surroundings, while in AR, only an overlay image could be presented to the user, or the device could have almost complete knowledge of the surroundings by scanning it, such as state-of-the-art devices such as the HoloLens or the MagicLeap do.


\begin{figure}
    \includegraphics{hirzle-classification.pdf}
    \caption{Gaze-based interaction classification according to \citep{hirzle2019}. In this figure, the interaction-centric view on the classification is shown, with specific interaction tasks classified into the respective fields. Figure reproduced from \citep{hirzle2019}.}
\end{figure}

For a more in-depth discussion of gaze-based input and its categorisation, see [@stellmach2013]. For the remainder of this chapter, we want to discuss two types of gaze-based input specifically, namely _gaze-contingent user interfaces_ and _attentive user interfaces_.

### Gaze-contingent user interfaces

The paradigm of gaze-contingent user interfaces is based on adjusting the displayed information depending on where the user is gazing. It is not a selection modality, but one that rather uses the context of the gaze. As described above, Duchowski [@Duchowski:2017ii] categorises gaze-contingent interaction into the model-based approach and the image-based approach:

* _image-based_: an image or video is modified based on the user's gaze
* _model-based_: the information presented to the user is modified before it is actually rendered, e.g. by adjusting the level of detail of a 3D model, reducing the total polygon count.

An interesting example is foveated rendering, a development based on the non-uniform and fovea-focused resolution of the human visual system (discussed in the chapter [Visual Processing]). In foveated rendering, only the area where the user is gazing is rendered at full resolution, while the surrounding area is rendered with less resolution, or may even lack color information at all, because there are no cones in the periphery of the retina to detect such. An early example of foveated rendering is [@levoy1990], where the authors adapted a volume rendering software to only render the area that will be projected onto the fovea in full resolution, while the remainder is rendered at reduced resolution. A more recent example is [@bruder2019], where the authors propose expand on the original idea of foveated volume rendering by modelling visual acuity and optimise their sampling strategy according to that (although their approach comes at the cost of requiring heavy pre-processing). Images from both publications are shown in Figure \ref{fig:FoveatedVolume}.

\begin{figure*}
    \includegraphics{foveated-volume-rendering.pdf}
    \caption{Foveated volume rendering evolution: a, b: Foveated and unfoveated volume renderings from \citep{levoy1990}. c, d: Foveated and unfoveated volume renderings from \citep{bruder2019}.\label{fig:FoveatedVolume}}
\end{figure*}

Aside from volume rendering, Nvidia's recent Turing GPUs (RTX 20xx series) support _variable-rate shading_, which can be used to implement foveated rendering for regular rasterized or ray-traced graphics. 

Considering that more and more, and also more complex data needs to be visualised in science and industry, gaze-contingent interaction is sure to stay very relevant in the future, especially if combined with computational models of saliency like proposed in [@Itti:2001cl; @Gao:2014a3e]. 

### Attentive User Interfaces

Attentive User Interfaces aim to develop less intrusive and more sociable interface to computers: By detecting what the user is currently occupied with and how important that is, the algorithm will determine whether or not the user should be disturbed. For example in [@shell2003] the authors describe an attentive cell phone that can detect whether the user is currently engaged in a conversation (in the slightly intrusive manner of attaching a camera to the conversation partner). The cellphone will only proceed to interrupt the user when this is not the case. Another interesting example is the work presented in [@singh2018], where the authors describe a framework for estimating the users emotional state from eye tracking and physiological data, in order to present a user interface that is most suited in a given life-critical situation. In [@bulling2016], the author argues for the necessity of ubiquity of attentive user interface, in order to cope with the problem of continuous distraction in a multi-billion display world.


## Summary

In this chapter, we have introduced the various modalities that can be used for eye tracking, with their positive and negative aspects, and came to the conclusion that for most applications that should come in widespread use, videooculography is most probably the best, due to being unobtrusive and fast. We have further briefly surveyed the landscape of gaze-based interaction and associated issues, and introduced gaze-contingent and attentive user interfaces in more detail. We will conclude the chapter by stating challenges and opportunities ahead, with one opportunity being addressed later in this work.

## Challenges and Opportunities

### Gaze-based object tracking

At the end of the [Introduction to Visual Processing] chapter, in the section [Object tracking with support of the visual system] we have already introduced the idea to utilise the power of the human visual system to follow objects for the purpose of tracking them. Such a system would fall into the category of gaze-contingent interaction. Furthermore, it would go beyond what is proposed in e.g. [@bruder2019], in the sense that it would need to handle multi-timepoint images on-the-fly, and combine it with an extension of the Radial Pursuit technique presented in [@piumsomboon2017]. See the chapter [track2track — Eye Tracking for Object Tracking in Volumetric Data] for details.

### Robust Pupil Segmentation

If eye tracking were to become a widely-used and reliable input modality, the first step, the detection of the pupil from a video stream, would need to be highly reliable.

While beyond the scope of this work, we have started preliminary work on automatic realtime segmentation of pupil images using genetic algorithms. This work was motivated by the algorithm for pupil segmentation proposed in [@Kassner:2014kh] and used in the Pupil software failing in the case of pupil images larger than 640x480 pixels, as it relies on Canny edge detection, which produces way too many false positives at high resolution. 

