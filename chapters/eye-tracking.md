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

![Purkinje images P1 to P4: _P1_, reflection on anterior corneal surface; _P2_, reflection on the posterior corneal surface; _P3_, reflection on the anterior surface of the lens; _P4_, reflection on posterior surface of the lens. Image (cc) by Z22, [commons.wikimedia.org/wiki/File:Diagram_of_four_Purkinje_images.svg](https://commons.wikimedia.org/wiki/File:Diagram_of_four_Purkinje_images.svg)](./figures/PurkinjeImages.png)

In addition to the regular VOG modalities, a recent study from Wang, et al.[@Wang:2016fz] makes use of thermal video imaging of the cornea, which is about 0.5ºC cooler than the limbus. They segment the thermal image, and locate the position of the cornea in the segmentation. They achieved a fair accuracy of ~2.3º, mostly limited by the resolution of the thermal sensor.

With _Pupil_[@Kassner:2014kh] and _Oculomatic_[@Zimmermann:2016hv], now  open-source, open-hardware solutions exist for VOG.

### Comparison

| Modality | Setup Effort | Intrusiveness | Comfort | Spatial Accuracy | Temporal Accuracy |
|:--|:--|:--|:--|:--|:--|
| SCCL | Very High | Very high | Low | <1º | <1ms |
| EOG | High | Medium | High | 1-2º | >2º |
| VOG | Low | Low | High | 1º | 2-5ms |

From the discussion of the various modalities, we conclude:

* _Search Coil Contact Lenses_ remain the gold standard for clinical eye tracking, where a high precision, both spatially and temporally is required, and balances their low user comfort and high setup effort.
* _Electrooculography_ is the most useful technique if relative eye coordinates are sufficient, or if the application might include the user's eyes not being visible, e.g. as it is the case in sleep analysis applications.
* _Videooculography_ is the most useful technique when it comes to day-to-day use, due to its easy setup and low to inexistent user discomfort. Also, both software and hardware for such a setup is readily available[@Kassner:2014kh; @Zimmermann:2016hv].

## Challenges

### Midas Touch Problem

### Accuracy

### Availability

## Review of Interaction Techniques

