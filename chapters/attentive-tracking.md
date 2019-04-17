# Attentive Tracking — or — Tracking for Tracking

In this chapter, we are going to detail the attentive tracking strategy for augmenting biological tracking and tracing tasks with gaze data in order to make easier to do.

We will first discuss the tracking and tracing problems usually encountered in biology and then detail the design process that went into attentive tracking.

## Tracking and Tracing Problems in Biology

## Design Process

### Initial Prototype

For the initial prototype, within _scenery_ we created a virtual reality-based crowded environment consisting of many differently-sized and differently-colored boxes. A black sphere is performing random motions through them, and the user was instructed to follow this sphere, and not lose sight of them. A screenshot of the prototype can be see in \ref{fig:attentive_tracking_prototype}.

![\label{fig:attentive_tracking_prototype}2D Screenshot of the attentive tracking prototype. The sphere to be tracked can be seen in the upper left corner of the image. See the text for details.](./figures/attentive_tracking_prototype.png)

This prototype was tested with an HTC Vive on a set of 5 biologists and people from related areas that have to perform manual tracking, without telling them first that they should actually perform a tracking problem. And while manual tracking is usually perceived as a tedious, boring and annoying task, the test subjects have described following the sphere in VR as interesting and fun.

### Planning

Encouraged by the positive reactions to the first, admittedly very primitive, prototype, a next, more serious prototype was planned. Just tracking head orientation and position would not be enough for the precision required, so an eye-tracking solution was integrated into the HTC Vive to procure more detailed information on where the user is looking at any point in time.

### Selecting the eye tracking hardware

For the this project, we have chosen the _Pupil_ eye trackers produced by _Pupil Labs_[@Kassner:2014kh][^pupilnote], as they provide a solution that provides both open-source software and very competitively hardware that is in addition very easy to integrate into HMDs. The software offered is available as LGPL-licensed open-source software on Github ([https://github.com/pupil-labs](https://github.com/pupil-labs)) and can be easily extended with custom plugins. 

In addition to being open, data gathered by the software is available to external applications via a ZeroMQ-based protocol — in contrast to closed-source proprietary libraries required by other products — which even enables the use of the eye tracking data over the network.

[^pupilnote]: The _Pupil_ HMD-based eye tracker from Pupil Labs, see [https://www.pupil-labs.com](https://www.pupil-labs.com).

## Pupil detection and calibration

### Pupil 2D and 3D detection

\begin{marginfigure}
    \includegraphics{./figures/pupil-pupil_detection.png}
    \caption{Pupil detection in the \emph{Pupil} software. Image reproduced from \citep{Kassner:2014kh}.\label{fig:Pupil2DDetection}}.
\end{marginfigure}

Using three user-defined parameters, pupil intensity range, and pupil min/max diameter, _Pupil_ extracts the pupil from the camera images as follows (from [@Kassner:2014kh]):

1. A Canny edge detector is applied to the camera image (Figure \ref{fig:Pupil2DDetection}-1),
2. Darker regions of the image are selected, based on the pupil intensity range parameter, the offset of the first histogram maximum, edges outside this area are discarded (Figure \ref{fig:Pupil2DDetection}-2),
3. the remaining edges are filtered to exclude specular reflections, e.g. from the IR LEDs, then the remaining edges are extracted into contours using connected components (Figure \ref{fig:Pupil2DDetection}-3, spectral reflections in yellow),
4. the remaining contours are filtered and split into sub-contours based on the continuity of their curvature (Figure \ref{fig:Pupil2DDetection}-4), 
5. candidate pupil ellipses are formed using least squares fitting, with the major axis within the bounds of the pupil min/max parameter, and a combinatorial search is done on the remaining contours to see which might be added to the ellipse for additional support. Resulting ellipses are evaluated based on the ratio of supporting edge length and ellipse circumference, called _confidence_ in _Pupil_, and finally
6. if the best result's confidence is above a defined threshold, the candidate ellipse is reported as result, otherwise the algorithm returns that no pupil has been found.

If 3D detection is selected in _Pupil_, the result ellipse is passed on to the algorithm described in [@Swirski:2013b12]. As we are only going to use 2D detection for _Attentive Tracking_, we are not going to detail this algorithm, but refer the interested reader to the paper instead.

### Calibration procedure

Eye positions, size, etc. are subject to large individual differences. It is therefore required to calibrate the eye trackers before each use, to be able to get reliable gaze data out. 

In case of regular, glasses-mounted eye trackers, _Pupil_ offers an integrated calibration procedure, while for HMD-based settings, we need to create our own calibration routine. The calibration has to be redone over time, this is not actually a negative aspect, but can help with a good integration of the calibration procedure into the virtual world presented to the user.

Our custom calibration routine works as follows:

 1. we show the user a single highlighted point located on a circle in the center of the screen, the user is instructed to follow the highlighted point with his eyes,
 2. after acquiring enough samples for calibration, the screen space position of the calibration point is sent to Pupil,
 3. the next, randomly selected point out of a set of 10 equidistant points on the circle is shown to the user,
 4. after all points have been gazed at by the user, Pupil's calibration routine will try to construct a correspondence between the gaze vectors of both eyes and the screen-space coordinates submitted,
 5. if the calibration routine is successful, the calibration interface will be hidden, and the regular application can continue. If the calibration routine is not successful, we restart from 1. until successful or until the user cancels.

\TODO{Add calibration image}
