# Distributed Rendering

\begin{figure*}
    \includegraphics{scenery-cave.jpg}
    \caption{A user interacting with a \emph{Drosophila} dataset rendered on a clustered 4-sided CAVE setup with 5 machines. Photo courtesy of Aryaman Gupta, MPI-CBG, Dresden.}
\end{figure*}

Apart from rendering to VR/AR headsets, scenery includes support for parallel and distributed rendering on multiple machines. While all scenery-based applications are in principle ready to be run on multiple machines in concert, a bit of configuration is required. This chapter details the necessary steps, starting with the geometry definition for multi-projector/multi-screen environments, followed by an explanation what steps are necessary on the software side. We end the chapter with information about how scenery keeps the information on all machines synchronised.

## Screen Geometry Definition

For setting up a multi-projector, multi-machine environment with scenery, the physical geometry of the projection space has to be defined. This is done using a simple YAML file, an example of which can be seen in Listing \ref{lst:CAVEConfig}.

\begin{lstlisting}[language=YAML, caption={Simple configuration file for a four-sided CAVE environment with each wall having a resolution of 2560x1600 pixels.}, label=lst:CAVEConfig]
name: CAVE example configuration
description: Multi-screen configuration, demoing a 4-sided CAVE environment
screenWidth: 2560
screenHeight: 1600

screens:
  front:
    match:
      type: Property
      value: front
    lowerLeft: -1.92, 0.00, 1.92
    lowerRight: 1.92, 0.00, 1.92
    upperLeft: -1.92, 2.40, 1.92
  left:
      match:
        type: Property
        value: left
      lowerLeft: -1.92, 0.00, -1.92
      lowerRight: -1.92, 0.00, 1.92
      upperLeft: -1.92, 2.40, -1.92
  right:
      match:
        type: Property
        value: right
      lowerLeft: 1.92, 0.00, 1.92
      lowerRight: 1.92, 0.00, -1.92
      upperLeft: 1.92, 2.40, 1.92
  floor:
      match:
        type: Property
        value: floor
      lowerLeft: -1.92, 0.00, -0.48
      lowerRight: 1.92, 0.00, -0.48
      upperLeft: -1.92, 0.00, 1.92
\end{lstlisting}

First, the name and description of the configuration are set (lines 1 and 2), along with the screen dimensions in pixels (lines 3 and 4, at the moment, all screens have to have the same pixel width and height). Following that, a set of screens is defined (line 6 and following). These screens can have arbitrary names, and should ideally reflect a physical property, e.g. relating to their positioning in the room. The `match` element (e.g. line 8) defines how scenery determines which machine in the cluster is associated with which screen. Two ways are possible for this:

* `type: Property`, where the screen is determined by the system property `scenery.screenName` set to the string given in `value`, or
* `type: Hostname`, where the screen is determined by matching the hostname of the machine to the name given in `value`.

The following three vectors, `lowerLeft`, `lowerRight`, and `upperLeft` determine the corners of the screen surface in physical space, which are assumed to be rectangular (e.g. lines 11, 12, and 13). Note here that the tracking system also needs to be calibrated to the same coordinate space. In the example above, the coordinate origin is on the floor, 0.48m in front of the `front` screen, and each screen has a width of 3.84m, and a height of 2.40m.

## Software Setup for Clustering

## Synchronisation of Scene Data


