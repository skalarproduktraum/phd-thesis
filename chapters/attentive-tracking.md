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

For the this project, we have chosen the _Pupil_ eye trackers produced by _Pupil Labs_[@Kassner:2014kh][^pupilnote], as they provide an open-source and very competitively priced solution that is easy to integrate into HMD headsets. The software offered is available as LGPL-licensed open-source software on Github ([https://github.com/pupil-labs](https://github.com/pupil-labs)) and can be easily extended. In addition to being open, data gathered by the software is also available to external applications via an easy-to-implement, ZeroMQ-based protocol (opposed to closed-source proprietary libraries required by other products), which even enables the use of the eye tracking data over the network.

[^pupilnote]: The Pupil HMD-based eye tracker from Pupil Labs, see [https://www.pupil-labs.com](https://www.pupil-labs.com).

### Calibration procedure

Eye positions, size, etc. are subject to large individual differences. It is therefore required to calibrate the eye trackers before each use, to be able to get reliable gaze data out. In case of regular, glasses-mounted eye trackers, _Pupil_ offers an integrated calibration procedure, while for HMD-based settings, we need to create our own calibration routine. The calibration has to be redone over time, this is not actually a negative aspect, but can help with a good integration of the calibration procedure into the virtual world presented to the user.

In our custom calibration routine, we show the user 8 different points, lying on a circle, at which he has to look. These 8 points cover most of the field of view and enable the Pupil software to establish a one-to-one relation between measured pupil position and the screen space point the user's gaze is directed to.

\TODO{Add calibration image}
