# track2track — Eye Tracking for Cell Tracking

We are going to detail the track2track strategy for augmenting biological tracking tasks with eye gaze data in order to make them easier and faster to do.

We will first discuss the tracking problems usually encountered in biology and then detail the design process that went into track2track, and finally show a proof-of-concept that the strategy works in the case of tracking cells during the early development of _Platynereis_ embryos.

## Tracking Problems in Biology and Challenges

In cell and developmental biology, the image data generated by fluorescence microscopy is often only a means to an end: Many tasks require exact information about the position of cells during development, or even their entire history, the so-called cell lineage tree. 

Images from fluorescence microscopy don't have any well-defined intensity scale — in contrast to CT images, for example, where a specific intensity indicates a particular tissue type — and intensity might even vary across a single cell. It can therefore be very hard to follow a moving, dividing, or dying cell around in a developing tissue or organism. Often, the task of tracking cells is done manually over a series of time points, which can be a very tedious process. In the past, tracking software was often developed for a specific model organism, e.g., for _C. elegans_, and relied on their stereotypical development to succeed in tracking their cells. Such approaches however either fail entirely, or produce unreliable results for larger organism. For that reason, (semi)automated approaches have been developed which are independent of the model organism and can track large amounts of cells:

* _TGMM_, Tracking by Gaussian Mixture Models [@amat2014; @ckendorf:2015ch], is an offline tracking solution that works by generating oversegmented supervoxels from the original image data, then fit all cell nuclei with a Gaussian Mixture Model and evolve that through time, and finally use the temporal context of the various lineages to create the final lineage.
* _TrackMate_ [@tinevez2017] is a plugin for Fiji [@schindelin2012fiji] that provides automatic, semi-automatic, or manual tracking of single particles in imaging datasets. TrackMate is highly customisable and allows the user to even extend it with self-developed spot detection or tracking algorithms.
* _MaMuT_, the Massive MultiView Tracker [@wolff2018], is in some sense the successor to TrackMate, allowing the user to track cells in large datasets, often originating from lightsheet microscopes, and containing multiple different views. MaMuT's viewer is based on BigDataViewer [@Pietzsch:2015hl], and is able to handle very large amounts of data.

All of these automated approaches however have in common that they need manual curation as a final step, as all of them do make assumptions about cell shapes, modelling them as Gaussian blobs, as in the case of TGMM. The main problem we are going to address in this chapter is the manual curation step, which might be needed either for verification, or to handle especially difficult developmental stages, where cell shapes may vary wildly.

The challenges of this step are twofold:

* Image data from fluorescence microscopy can be very inhomogeneous, with inhomogeneity stemming from both the distribution of fluorescent proteins, and from the diversity of cell shapes. Deriving general algorithms that can capture both regular and very deformed cells is a highly challenging task.
* Manually curation of cell lineages is very tedious at the moment, as the users have to go through each timepoint and connect cells between the timepoints. This is often done on a per-slice basis and by mouse, leading to a time-consuming process. Manually tracking a single cell through 100 timepoints with this process can take up to 30 minutes, and tracking a single dataset whole can take many months.

## Design Space

We intend to tackle this problem by using a combination of eye tracking and virtual reality. 

The user can be tasked to follow a cell with his/her eyes, the gaze direction recorded, and the targeted cell then determined, turning the 3-dimensional localisation problem into a 1-dimensional one — from the whole volume of image data, to a single ray through it. The human visual system, as described in the chapter [Introduction to Visual Processing], is excellent in following moving objects smoothly, and in datasets used for cell tracking, the cells can also be assumed to move smoothly. Interestingly, the particular kind of eye movement we are exploiting here, _smooth pursuits_ — see the section [Eye movements] in [Introduction to Visual Processing] for details — is rather underexplored in human-computer interaction. To the author's knowledge, only [@piumsomboon2017] use it in their _Radial Pursuit_ technique. In _Radial Pursuit_, the user can select an object by following it in a scene with his eyes, and it will become more "lensed-out" the longer he does that.

With the addition of virtual reality to the mix, we can first help the user with orientation in the dataset, and second, utilise the tracking data from the head-mounted display, consisting of head position and head orientation, for constraining the eye tracking data to remove outliers or spurious pupil detections, or even foveate the rendering of the volumetric dataset.

Taking one of the two away, would lead to issues:

* When _removing eye tracking_, the head orientation could still be used as a cursor. However, following small and smooth movements with your head is not something humans are used to, the eyes will always lead the way, and the head will follow via the vestibulo-ocular reflex (VOR, see [Eye movements] in the [Introduction to Visual Processing] chapter).
* When _removing virtual reality_, the effective "canvas" the user can use to follow cells around become restricted to the small part of the visual field a regular screen occupies. Alternatively, large screens, such as Powerwalls, could be used, but these also do not offer the freedom of movement that virtual reality headsets offer, especially when the user needs to move inside the dataset.

In terms of the design space for gaze interaction on head-mounted displays introduced by [@hirzle2019], we utilise (stereoscopic) VR with full world information, combined with binocular eye tracking.

## Tracking cells in early Platynereis development

_Platynereis dumerilii_ is an annelid, a segmented worm. Its embryonic development has a very characteristic feature, _spiral cleavage_ where dividing cells turn in spiral form during their division. Arising from this geometric peculiarity, a wide variety of cell shapes can be found in developing _Platynereis_, with some examples shown in \cref{fig:PlatynereisCellShapes}. \TODO{Add cell shape figure.}

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/Platynereis100Timepoints.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video showing the early development of a \emph{Platynereis} embryo. For a list of supplementary videos see \href{https://ulrik.is/thesising/supplement/}{ulrik.is/thesising/supplement/}.
\end{marginfigure}
 
## Design Process

### Initial Prototype

![2D Screenshot of the attentive tracking prototype. The sphere to be tracked can be seen in the upper left corner of the image. See the text for details.\label{fig:attentive_tracking_prototype}](attentive_tracking_prototype.png)

For the initial prototype, within _scenery_ we created a virtual reality-based crowded environment consisting of many differently-sized and differently-colored boxes. 

This prototype was tested with an HTC Vive on a set of 5 people familiar with tracking problems, either from the biological or algorithmic side. The participants were not told that they are going to perform a tracking problem in order to prevent priming them.

In the presented scene, a black sphere is performing random motions in the a crowded space, and the participant was instructed to follow this sphere, and not lose sight of it. A screenshot of the prototype can be see in \cref{fig:attentive_tracking_prototype}. While participants stated that manual tracking is usually perceived as a tedious, boring and annoying task, they described following the sphere in VR as interesting, easy and fun.

Encouraged by the positive reactions to the first simple prototype, a next, more serious prototype was planned. Just tracking head orientation and position would not be enough for the precision required, so an eye-tracking solution was integrated into the HTC Vive to gain access to more detailed information on where the user is looking at any given point in time.

### Selecting the eye tracking hardware

For the this project, we have chosen the _Pupil_ eye trackers produced by _Pupil Labs_[@Kassner:2014kh][^pupilnote], as they provide a solution that provides both open-source software and very competitively-priced hardware that is simple to integrate into HMDs. The software offered is available as LGPL-licensed open-source software on Github ([https://github.com/pupil-labs](https://github.com/pupil-labs)) and can be extended with custom plugins. 

In addition to being open, data gathered by the software is available to external applications via a ZeroMQ-based protocol — in contrast to closed-source proprietary libraries required by other products — which even enables the use of the eye tracking data over the network.

At the time of writing, HTC's extended version of their _Vive Pro_ HMD, the _Vive Pro Eye_, with integrated eye tracking hardware, is also becoming available. It will be interesting to compare the two solutions in the future, especially as the _Vive Pro Eye_ will be more competitively priced (around EUR1400) than a regular _Vive_ combined with the _Pupil_ eye trackers (EUR600 for the HMD, plus EUR1100 for the eye trackers).

![The Pupil eye tracking cameras integrated into a HTC Vive HMD. The cameras view the eyes of the user from below, while the eyes are illuminated by a set of IR LEDs position around the lenses of the HMD. Image reproduced from [www.pupil-labs.com](https://www.pupil-labs.com).\label{fig:PupilInVive}](PupilEyeTrackerHMD.png)

An image of how the eye tracking solution looks integrated into a HTC Vive HMD can be seen in \cref{fig:PupilInVive}.

[^pupilnote]: The _Pupil_ HMD-based eye tracker from Pupil Labs, see [https://www.pupil-labs.com](https://www.pupil-labs.com).

## Pupil detection and calibration

### Pupil 2D and 3D detection

\begin{figure}
    \includegraphics{pupil-pupil_detection.png}
    \caption{Pupil detection in the \emph{Pupil} software. See text for a description of the steps. Image reproduced from \citep{Kassner:2014kh}.}.
    \label{fig:Pupil2DDetection}
\end{figure}

Using three user-defined parameters, pupil intensity range, and pupil min/max diameter, _Pupil_ extracts the pupil from the camera images as follows (from [@Kassner:2014kh]):

1. A Canny edge detector is applied to the camera image (\cref{fig:Pupil2DDetection}-1),
2. Darker regions of the image are selected, based on the pupil intensity range parameter, the offset of the first histogram maximum, edges outside this area are discarded (\cref{fig:Pupil2DDetection}-2),
3. the remaining edges are filtered to exclude specular reflections, such as from the infrared LEDs, then the remaining edges are extracted into contours using connected components (\cref{fig:Pupil2DDetection}-3, spectral reflections in yellow),
4. the remaining contours are filtered and split into sub-contours based on the continuity of their curvature (\cref{fig:Pupil2DDetection}-4), 
5. candidate pupil ellipses are formed using least squares fitting, with the major axis within the bounds of the pupil min/max parameter, and a combinatorial search is done on the remaining contours to see which might be added to the ellipse for additional support. Resulting ellipses are evaluated based on the ratio of supporting edge length and ellipse circumference, called _confidence_ in _Pupil_, and finally
6. if the best result's confidence is above a defined threshold, the candidate ellipse is reported as result, otherwise the algorithm returns that no pupil has been found.

If 3D detection is selected in _Pupil_, the result ellipse is passed on to the algorithm described in [@Swirski:2013b12]. As we are only going to use 2D detection for _Attentive Tracking_, we are not going to detail this algorithm, but refer the interested reader to the paper instead.

We have found that the the combination of high-resolution camera images (resolution over 640x480 pixels) in combination with the Canny edge detector used in the first step of the algorithm leads to contour overdetection, and therefore useless pupil detections. We therefore used a camera resolution of 640x480 pixels, which provides the best tradeoff between speed, processing cost, and accuracy. The used cameras provide a framerate of 120fps at this resolution, which in turn leads to a high-enough temporal resolution for tracking eye movements, as the framerate of the HMD is 90 fps maximum. We are currently exploring alternatives to the algorithm described, based on genetic algorithms.

Although by using vergence as binocular depth cues, 3D detection could yield additional constraints on at what depth the user was looking, in the following, we use the 2D detection algorithm, which we found to be more reliable. 

### Calibration procedure

Eye positions, size, etc. are subject to large individual differences. It is therefore required to calibrate the eye trackers before each use, to be able to get reliable gaze data out. 

In case of regular, glasses-mounted eye trackers, _Pupil_ offers an integrated calibration procedure, while for HMD-based settings, we need to create our own calibration routine. Our custom calibration routine works as follows:

 1. we show the user a single highlighted point located on a circle in the center of the screen, the user is instructed to follow the highlighted point with his eyes,
 2. after acquiring enough samples for calibration, the screen space position of the calibration point is sent to Pupil,
 3. the next, randomly selected point out of a set of 10 equidistant points on the circle is shown to the user,
 4. after all 10 points have been gazed at by the user, Pupil's calibration routine will try to construct a correspondence between the gaze vectors of both eyes and the screen-space coordinates submitted,
 5. if the calibration routine is successful, the calibration interface will be hidden, and the regular application can continue. If the calibration routine is not successful, we restart from 1. until successful or until the user cancels.

\TODO{Add calibration image}



## Tracking Procedure

\begin{marginfigure}
    \includegraphics{vive-controllers-t2t.pdf}
    \caption{Controller bindings for using \emph{track2track}. See text for details. Vive controller drawing from VIVEPORT Developer Documentation, \href{https://developer.viveport.com}{developer.viveport.com}.\label{fig:T2TControls}}
\end{marginfigure}

After calibration and before starting the tracking procedure for a single cell, the user can position himself freely in space, and also move to the right position in time for the dataset. All of these functions can be performed using the HTC Vive handheld controllers. The controller bindings are shown in \cref{fig:T2TControls}, with them the user can perform the following:

* move the dataset by holding the left-hand trigger and moving the controller around,
* use the directional pad on the left-hand controller to move forward, back, left, right, with respect to the direction the user is looking into,
* start and stop tracking by pressing the right-hand trigger,
* play and pause the dataset by pressing the right-hand menu button,
* playing the dataset faster or slower by pressing the right-hand directional pad up or down, and 
* stepping through the timepoints of the dataset by pressing the right-hand directional pad left or right.

To adjust for handedness of the user, the controller mappings can be swapped. 

The user can start the tracking process as soon as he is ready and has found the cell he wants to track. Starting a tracking step will start playing the dataset if it is currently paused. When tracking is active, gaze directions and other metadata are collected, and can be analysed automatically in the next step. The limitation at the moment is that the user _has_ to look at a trackable object when the tracking step is started, in order to seed the analysis algorithm.

## Analysis of Eye Tracking Data

After all rays have been collected for a tracking step, all further track data is derived from the set of rays, which we call the _hedgehog_. An individual ray we dub _spine_, as it contains more information than just the ray's orientation and direction. In particular, it contains:

* the confidence of the gaze data point it was derived from,
* the entry and exit points through the volume in volume-local coordinates (meaning for each coordinate axis $\in [0.0, 1.0]$),
* the head orientation at recording time,
* the head position at recording time,
* the timepoint of the volume it belongs to, and
* a list of samples taken in uniform spacing along the ray, along with the spacing. 

How this collection looks visually in 3D is depicted in \cref{fig:hedgehog} (when visualising spines, we usually only show the spatial extent of them, and show their associated confidence as color code — all data associated with the spine is however used in the analysis). In the depicted image, the tracking user's position is the intersection of all spines, which are shown here in an elongated way for visualisation purposes. In this case, the spines are color-coded by the timepoint of the volumetric dataset.

![The hedgehog of a tracking step of a single cell through 100 timepoints in a _Platynereis_ dataset. In the dataset, a Histone marker is used for fluorescence. Each spine is color-coded by timepoint, with early timepoints shown in green, and later ones in yellow. Dataset courtesy of Mette Handberg-Thorsager, Tomancak Lab, MPI-CBG.\label{fig:hedgehog}](hedgehog.png)

Additionally, the hedgehog can be represented in two dimensions, with time on the Y axis, and depth along a given ray along the X axis. An example of that is shown in \cref{fig:rawHedgehog}. In this figure it is clearly visible that the rays do have different lengths, which is due to the angle they intersect the dataset. Also note that each line on the Y axis represents one gaze sample, of which we collect up to 60 per second, leading to 1614 samples in the plot (16 samples per timepoint on average).

\begin{marginfigure}[-4cm]
    \includegraphics{hedgehog-raw.png}
    \caption{The raw plot of the hedgehog rays. On the X axis, volume intensity along a single ray is shown, on the Y axis, time runs from top to bottom. See text for details.\label{fig:rawHedgehog}}
\end{marginfigure}

The data can also be smoothed with a moving window average over time. An example of that with the same dataset as before is shown in \cref{fig:labelledHedgehog}. In this plot we additionally show the local maxima along each ray in red. The track of the cell we were following is clearly visible. As there are movements of the user, and other cells or objects might appear in front of the cell the user is tracking, the challenge is now how to reliably use the temporal information contained in the hedgehog to find a track for the cell.


### Graph-based temporal tracking

\begin{figure*}
    \includegraphics{t2t-ray.pdf}
    \caption{An example profile of an entire ray through a volumetric dataset. X axis is step along the ray in voxels, Y axis volume sample value. In this case, there are two local maxima along the ray, one close to the observer, at index 70, and another one further away at 284.\label{fig:T2TExampleRay}}
\end{figure*}

\begin{marginfigure}[14cm]
    \includegraphics{hedgehog-with-maxima.png}
    \caption{The same hedgehog with local maxima marked. On the X axis, volume intensity along a single ray is shown, on the Y axis, time runs from top to bottom. Local maxima are shown in red. See text for details. \label{fig:labelledHedgehog}}
\end{marginfigure}

To reliably connect cells together over several timepoints, we use an incremental graph-based approach utilising all spines that have local maxima in their sample value. An example ray through a volume is shown in \cref{fig:T2TExampleRay}. In the figure, the position in voxels along the ray is shown on the X axis, while the Y axis shows the value of the volume at that point of the ray. We assume that when starting a tracking step, the user is looking at an unoccluded object that will be visible as a local maximum along the ray to seed the algorithm.

\begin{figure*}
    \includegraphics{t2t-algorithm.pdf}
    \caption{A graphical illustration of the incremental graph-search algorithm used to extract tracks from a hedgehog. Time runs along the X axis. $s_1$ is the initial seed point where to start tracking. The algorithm is currently at $s_3$, determining how to proceed to $s_4$. In this case, the middle track with $d=1$ wins, as it is the shortest world-space distance away from the current point.\label{fig:T2TAlgorithm}}
\end{figure*}

For each timepoint, we have collected a variable number of spines, whose count varies between 0 and 60 (with an average of 16) — zero spines might be obtained in case that the user blinks and no detection was possible. To connect the initial seed point with the other correct spines correctly, we step through the list of spines one-by-one, performing the following steps:

1. Advance to the next spine,
2. connect the currently active point from the previous spine with the local maximum on current next spine that has the lowest world-space distance — with this weighting we can exclude cases where another object was briefly moving between the user and the actually tracked object. The process of connecting one local maximum to the next closest one is a version of \emph{dynamic fringe-saving A*}-search [@sun2009] on a grid, where all rays get extended the the maximum length in the whole hedgehog along the X axis, and time flows along the Y axis. 

A graphical representation of the algorithm is given in \cref{fig:T2TAlgorithm} and the algorithm itself is summarised in \cref{alg:T2T}.

\begin{algorithm}
  \SetKwData{Image}{image}
  \SetKwData{hedgehog}{$\mathcal{H}$}
  \SetKwData{spines}{$\mathcal{S}$}
  \SetKwData{spine}{$s$}
  \SetKwData{current}{$v_\mathrm{current}$}
  \SetKwData{closest}{$i_\mathrm{closest}$}
  \SetKwFunction{FindIndexOfClosestMax}{FindIndexOfClosestMax}
​	\KwData{Hedgehog $\mathcal{H}$ with spines $\mathcal{S}$}
	\KwResult{Track $\mathcal{T}$, consisting of points $p_i$}
​	\BlankLine
​	
	  \current \leftarrow \spines first\;
		\ForAll{ Spine $s$ $\in$ \hedgehog $\backslash$ \current }{
    		\tcc{Find index of the closest local maximum}
    		\closest \leftarrow \FindIndexOfClosestMax(\current, $||\cdot||^2$)\;
    		\tcc{If no maximum found, skip to next spine}
    		\If{\closest == null}{
        		skip to next $s$\;
    		}
    		$v.$position \leftarrow $s$.origin + $s$.direction \cdot \closest\;
    		\current \leftarrow $v$\;
    		$\mathcal{T} + v$
    }

	\caption{Algorithm for evaluation of the hedgehog in \emph{track2track}.\label{alg:T2T} See text for a detailed explanation of the steps.} 
\end{algorithm}


## Preliminary Results

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/Track2TrackPlatynereis.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video showing tracking of a cell via \emph{track2track} in early \emph{Platynereis} development. For a list of supplementary videos see \href{https://ulrik.is/thesising/supplement/}{ulrik.is/thesising/supplement/}.
\end{marginfigure}

\begin{marginfigure}
    \includegraphics{t2t-track.png}
    \caption{A reconstructed cell track in a \emph{Platynereis} embryo. \TODO{Replace image}.\label{fig:T2TReconstructedTrack}}
\end{marginfigure}

Preliminary results show that cell tracks can be reliably reconstructed by "just looking at them", using eye, head and body movements that are used in everyday life. See \cref{fig:T2TReconstructedTrack} for an example track reconstruction. In addition to being able to reconstruct cell tracks, we find promising speedup of up to a factor of 10 compared to manually tracking cells in _Platynereis_ embryos.

## Discussion and Future Work

In this chapter we have introduced the _track2track_ strategy for tracking cells in 3D microscopy images in an effort to speed up manual tracking and proofreading and developed a proof of concept. Preliminary results show that we can achieve an order of magnitude speedup compared to manually tracking cells. 

Before we can bring this strategy into actual use for biologists, we need to do three more things: 

* First, perform a user test to figure out usability issues and improvements. 
* Second, implement interactions that allow to track or proofread lineage trees. Such an interaction could for example include the user pressing a certain button whenever a cell division occurs, and then track until the next cell division. 
* Third, track2track has to benchmarked against other automatic solutions, e.g. on cell tracking challenge datasets.

We foresee the limitation that for tracking large lineages entirely, track2track will not work, simply for combinatorial reasons. It can however be used to track early-stage embryos where cells may have less-defined shapes, or it may provide constraints to training data to machine learning algorithms. Furthermore, track2track could be used in a divide-and-conquer manner in conjunction with an automatic tracking algorithm that provides uncertainty scores, and only be applied in regions where the algorithm cannot cross a given uncertainty threshold. We could further increase the usefulness of track2track by not just searching for local maxima along rays, but actually extract the centroids of cells.

Ultimately, we would like to integrate track2track into existing tracking software, such that it can be helpful for a more general audience. Current developments in eye tracking hardware indicate falling prices in the near future, such that those devices might become way more common soon. Alternatively, one could imagine just having one or two eye  tracking-enabled HMDs, and make them available to users in a bookable item-facility-like manner.

