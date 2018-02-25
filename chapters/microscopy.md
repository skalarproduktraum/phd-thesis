# Fluorescence Microscopy

Fluorescence microscopy is one of the major workhorses of cell, developmental and systems biology. In the most basic version, a fluorescent molecule -- which after receiving photons of a certain, molecule-specific excitation wavelength, emits secondary photons, of longer wavelength -- is introduced into a biological specimen, e.g. as a staining, antibody, or protein intrinsically produced by the specimen after genetic modification.

## Confocal Microscopy

The confocal microscope was developed in the 1960s by Marvin Minsky, one of the pioneers of Artificial Intelligence (AI), in order to investigate neural connections in the central nervous system of mammals, and draw conclusions for AI from that. The confocal microscope enables optical sectioning by illuminating the sample sample with a coherent light source, nowadays lasers, and rejecting the emitted fluorescence with a pinhole. With this principle, it is possible to scan the specimen point-wise in X and Y directions, and provide optical sectioning by also moving it in the Z direction. Occurring fluorescence that was not rejected as background by the pinhole gets collected point-wise by a photomultiplier, and an image or volume reconstructed from that. The principle of operation is also pictured in \ref{fig:confocal_principle}.

![\label{fig:confocal_principle}Confocal microscope operating principle,  10: Arc lamp (laser, nowadays), 12: Illumination pinhole, 16: Dichroic mirror, 22: specimen, 26: Pinhole, 28: Photomultiplier diode (Public Domain, from Marvin Minksky's original patent application).](./figures/confocal_principle.png)

### Image formation

### Shortcomings

Though a very useful instrument, confocal microscopy has a few issues, namely:

* due to the pinhole rejecting light, a lot of the photon yield is discarded. For fast acquisitions, this can lead to images with a very low signal-to-noise ratio.
* due to scanning the laser over each point to be imaged, the specimen is exposed to high levels of light, often above the biologically tolerated or inconsequential threshold.

In the next section, we will explain lightsheet microscopy, which aims to alleviate these shortcomings.

## Lightsheet Microscopy

In lightsheet, or similarly, selective plane illumination microscopy[@Huisken:2004ky][^spimnote], the specimen is illuminated by a coherent light source in a 90º angle to the detection plane. The illumination light is focused into a thin sheet of light by means of a cylindrical lens (selective plane illumination microscopy, SPIM), or by scanning a Gaussian laser beam (digitally scanned lightsheet microscope, DSLM). This means that a full-frame 2D image of the specimen can be acquired at once, without point scanning, lowering the required light intensity by a substantial amount. Further, many 2D acquisitions can happen sequentially, enabling the capture of fast biological processes in 3D and 4D, such as the beating of the zebrafish _Danio rerio_'s heart[@Mickoleit:2014bl].

[^spimnote]: Throughout the remainder of this work, for the sake of brevity, we are going to refer to both lightsheet microscopy and SPIM microscopy simply as "lightsheet microscopy".

### Image formation

### Data rates

![\label{fig:spim_data_rate}Comparison of the data produced by a confocal microscope equipped with an EM-CCD camera, a lightsheet microscope with an EM-CCD camera, and a lightsheet microscope with an sCMOS camera in the course of 24 hours. Adapted from [@Reynaud:2015dx].](./figures/spim_data_rate.pdf)

## Challenges and Opportunities

