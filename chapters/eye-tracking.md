# Eye Tracking and Gaze-based Interaction

Eye tracking is the process of following the direction of the user's eyes in order to determine what the user is looking at, and deriving information, context, and actions from that. 

## Eye Tracking Technologies

In this section, we're introducing common eye tracking technologies, and in the end compare them for user-friendliness and applicability for practical usage scenarios.

### Search Coil Contact Lenses

![Scleral search coil contact lens eye tracking schematic, reproduced from [@Robinson:1963wf].\label{fig:ScleralEyeTracking}](./figures/ScleralEyeTracking.png)

Search Coil Contact Lenses constitute the earliest[@Robinson:1963wf] and probably most invasive form of eye tracking. For this form of eye tracking, a contact lens fitted with a coil is put directly on the user's sclera, who has to sit in a uniform magnetic field. Movements of the coil then cause an electric current, which is measured and correlated with the user's eye angle. This kind of eye tracking yields high spatiotemporal precision (< 1ms temporal resolution, <1º spatial resolution). See Figure \ref{fig:ScleralEyeTracking} for a sketch of the principle.

### Electrooculography

![Electrooculography in use, still image reproduced from [Biopac Student Lab, youtube.com/watch?v=-QXGiZBDkUw](https://www.youtube.com/watch?v=-QXGiZBDkUw)\label{fig:eog}](./figures/Electrooculography.png)

In electrooculography (EOG), the user's eyes are tracked by measuring potential changes on its skin. The technology employed is very similar to electroencephalography (EEG) or electromyography (EMG) — electrodes are placed around the eyes, and from the registered signal, the horizontal and vertical orientations of the eye ball are inferred. Additionally, a scalp electrode can be placed to also measure radial movements, yielding highly precise timings for the onset of saccadic movements [@Keren:2010jd]. Albeit EOG is plagued by the same issues as EEG/EMG — namely drift over time, and not entirely reproducible signal amplitudes, leading to inaccuracies for the generation of absolute eye positioning data — it does not rely on the user's eyes being visible, which can be a plus depending on the usage scenario. EOG can yield a horizontal resolution of 1-2º, while the vertical accuracy is usually less due to artifacts from lid movements[@Heide:1999we]. Compared to contact lenses it is much less invasive, and compatible with wearers of both glasses and regular, correcting contact lenses. See Figure \ref{fig:eog} for an exemplary EOG setup.

### Videooculography and Purkinje Imaging

![Videooculography exemplified by the Pupil Pro headset, image reproduced from [@Kassner:2014kh].\label{fig:VideoOculography}](./figures/PupilEyeTracker.png)

![Videooculography using a HMD-based eye tracker from Pupil Labs, mounted on an HTC Vive. Image reproduced from [pupil-labs.com/vr-ar](https://pupil-labs.com/vr-ar/).\label{fig:HMDEyeTracking}](./figures/PupilEyeTrackerHMD.png)

In Videooculography (VOG), the user's eyes are imaged by one camera per eye, focused on the pupil. Contemporary devices use infrared light to either track the pupil directly, or to image reflections created by the anterior and posterior surfaces of the cornea — the Purkinje images, see Figure \ref{fig:PurkinjeImages} — which can then be used to calculate a vector between the pupil's center and the reflection to determine the point the user is looking at[@Gneo:2012kn]. This technique requires calibration in the beginning, and might also drift in longer tracking sessions. Yet, it is very unintrusive, and only requires a camera mounted to either an existing or new set of glasses (see Figure \ref{fig:VideoOculography}), or a set of two cameras mounted inside a HMD (see Figure \ref{fig:HMDEyeTracking}). VOG yields a high spatial accuracy (~1º), while temporal accuracy suffers a bit due to camera and processing latencies (~3-5ms).

![Purkinje images P1 to P4: _P1_, reflection on anterior corneal surface; _P2_, reflection on the posterior corneal surface; _P3_, reflection on the anterior surface of the lens; _P4_, reflection on posterior surface of the lens. Image (cc) by Z22, [commons.wikimedia.org/wiki/File:Diagram_of_four_Purkinje_images.svg](https://commons.wikimedia.org/wiki/File:Diagram_of_four_Purkinje_images.svg)\label{fig:PurkinjeImages}](./figures/PurkinjeImages.png)

In addition to the regular VOG modalities, a recent study from Wang, et al.[@Wang:2016fz] makes use of thermal video imaging of the cornea, which is about 0.5ºC cooler than the limbus. They segment the thermal image, and locate the position of the cornea in the segmentation. They achieved a fair accuracy of ~2.3º, mostly limited by the resolution of the thermal sensor.

With _Pupil_[@Kassner:2014kh] and _Oculomatic_[@Zimmermann:2016hv], now  open-source, open-hardware solutions exist for VOG.

### Comparison

| Modality | Setup Effort | Intrusiveness | Comfort | Spatial Accuracy | Temporal Accuracy |
|:--|:--|:--|:--|:--|:--|
| SCCL | Very High | Very high | Low | <1º | <1ms |
| EOG | High | Medium | High | 1-2º | >2º |
| VOG | Low | Low | High | 1º | 2-5ms |

Table: Comparison of eye tracking modalities. {#tbl:EyeTrackingComparison}

From the discussion of the various modalities, we conclude:

* _Search Coil Contact Lenses_ remain the gold standard for clinical eye tracking, where a high precision, both spatially and temporally is required, and balances their low user comfort and high setup effort.
* _Electrooculography_ is the most useful technique if relative eye coordinates are sufficient, or if the application might include the user's eyes not being visible, e.g. as it is the case in sleep analysis applications.
* _Videooculography_ is the most useful technique when it comes to day-to-day use, due to its easy setup and low to inexistent user discomfort. Also, both software and hardware for such a setup is readily available[@Kassner:2014kh; @Zimmermann:2016hv].

## Challenges

A few challenges remain to achieve widespread use of eye tracking technology. In this section, we're going to detail the Midas Touch Problem and the Double Role of Gaze, Accuracy and Reliability, Availability, and Privacy.

### Midas Touch Problem and the Double Role of Gaze

The notion of the _Midas Touch Problem_ was introduced by Jacob in 1990[@Jacob:1990hz], and describes the issue that by looking at an object, the user inadvertently triggers an action. It is named after the Greek fable of King Midas, who, after wishing that everything he touches would turn to gold, ultimately starved to death.

The Midas Touch Problem is intimately linked with the _Double Role of Gaze_: while visual attention can be actively directed, it is also often influenced by visual distractions that carry a high saliency, such as flashing lights, fast moving objects, or even input from other senses, such as loud bangs. A shift towards passive attention may cause a disruption of the workflow of the user, or can, in the sense of the Midas Touch Problem, lead to wrong inputs. The issues are especially pronounced in the case that one wants to emulate mouse-based input with gaze input.

Both issues can be addressed e.g. by providing the user with an additional means to confirm that the selection action is actually the one he intends to perform. This can be achieved with a variety of means:

* _dwell time-/blink-based selection_, where an action is only triggered after the user has rested his gaze on the object[@Jacob:1990hz], or blinked once or multiple times as confirmation[@jacob:1993; @Ashtiani:2010dw]. Anyway, these solutions lead to additional delays for the input, which, depending on the intent might or might not be a problem:  If fast interaction is intended, e.g. for selecting highly salient objects in fast succession, dwell/blink-based confirmation is problematic, while when interacting e.g. with locked-in patients, it may provide an excellent way for communicating[@Ashtiani:2010dw].
* _multimodal interaction_, where the user can utilise an additional device to confirm his intent, for example by pressing a button on a keyboard[@Castellina:vg], using an additional touchpad[@Meena:2017bn],   a foot pedal or foot mat[@Klamka:2015ka, @Hatscher:2017bi], or free-air pinch gestures[@Pfeuffer:2017jk].
* _computer vision techniques_, where visual attention and saliency[@Itti:2001cl] is modelled computationally, to determine which is the most probably object of attention at the moment [@Wu:2015kt; @Theis:2018tw].

### Accuracy and Reliability

Due to individual differences between users, and also between different spike trains in EOG, measurement of gaze cannot be 100% correct. For cursor-based applications, filtering approaches can be used to weed out erratic recognitions[@Zhang:2008ex], and adjusting the interface shown to the user, e.g. via magnifying it or exaggerating details (see [@Cockburn:2009kj] for a review).

HMD-based eye tracking here has the benefit that the lighting situation can be controlled, and it'll mostly be dark inside the eye piece of the HMD, leading to more predictable and reliable gaze detection. For screen-mounted or mobile eye trackers however, the situation is a bit more difficult, as they might be used in many different lighting scenarios.

In terms of recognition reliability, advances have been made in recent years towards model-free determination of gaze, e.g. via artificial neural networks[@Gneo:2012kn]. One can expect this trend to continue, leading to more reliable algorithms. _Pupil_[@Kassner:2014kh] for example uses a combination of model-based detection together with a convolutional neural network for gaze determination.

### Availability

Still back in 2014, eye tracking hardware was very expensive, with both screen-mounted and HMD-mounted trackers costing in excess of 10000 EUR.

Since then, a few projects have started that provide either low-cost or open-source eye trackers, or even both. Examples are e.g.: 

* _Pupil_[@Kassner:2014kh], where ready-to-use eye trackers for glasses, mobile or HMD use can be bought, but the bill of materials, construction manual, and software are open-sourced (see [github.com/pupil-labs/pupil](https://github.com/pupil-labs/pupil) and [docs.pupil-labs.com](https://docs.pupil-labs.com)).
* _Oculomatic_[@Zimmermann:2016hv], which provides an open-source toolkit, as well as schematics for high-speed eye tracking, primarily for use in oculomotor research.
* _aGlass_, which has recently announced the availability of a low-cost, full-FOV eye tracking development kit for the HTC Vive, mainly to facilitate foveated rendering[@Pohl:2016fy].

These developments lead us to believe that widespread and cost-effective use of eye-tracking hardware will soon become a reality.


### Privacy

With eye movements being an additional data point that can be used to fingerprint persons and track them through different media and situations, privacy is of course a concern when employing eye tracking.

This concern becomes even more important, as Hoppe, et al. have recently shown that tracking eye movements in daily activities is able to predict four of the Big Five personality traits[@Hoppe:2018ko] — namely neuroticism, extraversion, agreeableness, and conscientiousness —, and additionally, also perceptual curiousity[@Collins:2004ks]. The possibility of doing that makes it absolutely clear that acquired eye tracking data has to stay with the user, and must not leave the computer for outside processing, as the misuse potential is very high. 

With e.g. Facebook also evaluating eye tracking for foveated rendering for their next-generation Oculus headsets[^oculuseyetrackingnote], it remains to be seen whether eye tracking will turn into a privacy nightmare, or stay user-governed as a very promising and useful technology for future human-computer interaction.

[^oculuseyetrackingnote]: See e.g. [uploadvr.com/oculus-is-working-on-eye-tracking-technology-for-next-generation-of-vr/](https://uploadvr.com/oculus-is-working-on-eye-tracking-technology-for-next-generation-of-vr/) or [uploadvr.com/oculus-patented-new-eye-tracking-device-days-acquiring-eye-tribe/](https://uploadvr.com/oculus-patented-new-eye-tracking-device-days-acquiring-eye-tribe/).

## Review of Interaction Techniques

