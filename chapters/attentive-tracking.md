# Attentive Tracking

In this chapter, we are going to detail the attentive tracking strategy for augmenting biological tracking and tracing tasks with gaze data in order to make easier to do.

We will first discuss the tracking and tracing problems usually encountered in biology and then detail the design process that went into attentive tracking.

## Tracking and Tracing Problems in Biology

## Design Process

### Initial Prototype

For the initial prototype, within _scenery_ we created a virtual reality-based crowded environment consisting of many differently-sized and differently-colored boxes. A black sphere is performing random motions through them, and the user was instructed to follow this sphere, and not lose sight of them. A screenshot of the prototype can be see in \ref{fig:attentive_tracking_prototype}.

![\label{fig:attentive_tracking_prototype}2D Screenshot of the attentive tracking prototype. The sphere to be tracked can be seen in the upper left corner of the image. See the text for details.](./figures/attentive_tracking_prototype.png)

This prototype was tested with an HTC Vive on a set of 5 biologists and people from related areas that have to perform manual tracking, without telling them first that they should actually perform a tracking problem. And while manual tracking is usually perceived as a tedious, boring and annoying task, the test subjects have described following the sphere in VR as interesting and fun.

### Planning

Encouraged by the positive reactions to the first, admittedly very primitive, prototype, a next, more serious prototype was planned. Just tracking head orientation and position would not be enough for the precision required, so an eye-tracking solution[@Kassner:2014kh][^pupilnote] was integrated into the HTC Vive to procure more detailed information on where the user is looking at any point in time.

[^pupilnote]: The Pupil HMD-based eye tracker from Pupil Labs, see [https://www.pupil-labs.com](https://www.pupil-labs.com).

