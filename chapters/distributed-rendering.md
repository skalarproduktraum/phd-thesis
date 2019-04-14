# Distributed Rendering

![A user interacting with a _Drosophila_ dataset rendered on a clustered 4-sided CAVE setup with 5 machines, image courtesy of the MPI-CBG Photolab, MPI-CBG, Dresden.](./figures/scenery-cave.jpg)

scenery includes support for parallel rendering on multiple machines. While all scenery-based applications are in principle ready to be run on multiple machines in concert, a bit of configuration is required. This chapter details the necessary steps, starting with the geometry definition for multi-projector/multi-screen environments, followed by an explanation what steps are necessary on the software side. We end the chapter with information about how scenery keeps the information on all machines synchronised.

## Screen Geometry Definition

For setting up a multi-projector, multi-machine environment with scenery, the physical geometry of the projection space has to be defined. This is done using a simple YAML file:

```yaml
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

```

First, the name and description of the configuration are set, along with the screen dimensions in pixels (at the moment, all screens have to have the same pixel width and height). Following that, a set of screens is defined. These screens can have arbitrary names, and should ideally reflect a physical property, e.g. relating to their positioning in the room. The `match` element defines how scenery determines which machine in the cluster is associated with which screen. Two ways are possible for this:

* `type: Property`, where the screen is determined by the system property `scenery.screenName` set to the string given in `value`, or
* `type: Hostname`, where the screen is determined by matching the hostname of the machine to the name given in `value`.

The following three vectors, `lowerLeft`, `lowerRight`, and `upperLeft` determine the corners of the screen surface in physical space, which are assumed to be rectangular. Note here that the tracking system also needs to be calibrated to the same coordinate space. In the example above, the coordinate origin is on the floor, 0.48m in front of the `front` screen, and each screen has a width of 3.84m, and a height of 2.40m.

## Software Setup for Clustering

## Synchronisation of Scene Data


