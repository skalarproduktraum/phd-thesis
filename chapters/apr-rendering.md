# Rendering the Adaptive Particle Representation



The work presented in this chapter has been done in collaboration with Bevan Cheeseman, Sbalzarini Lab, MPI-CBG, and is partially published in Cheeseman, B.L., __Günther, U.__, Susik, M., Gonciarz, K., and Sbalzarini, I.F., 2018. _Forget Pixels: Adaptive Particle Representation of Fluorescence Microscopy Images_. [biorxiv.org/content/early/2018/03/02/263061](https://www.biorxiv.org/content/early/2018/03/02/263061), accepted at _Nature Communications_)



## Introduction

The Adaptive Particle Representation[@Cheeseman:ia] (APR) is a representation of image data that does not rely on regular sampling as found in pixel images, but instead uses computational particles to represent point intensities and further properties in space-filling data structure similar to an octree. Especially in the context of fluorescence microscopy, where images are mostly sparse, this alternative representation allows for highly efficient data storage and processing, resulting in space savings of a factor of 10 to 100 compared to the original image size.

## Theory

## Rendering

### Particle-based rendering


### GPU-based volume rendering