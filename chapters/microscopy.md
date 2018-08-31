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

![\label{fig:spim_data_rate}Comparison of the data produced by a confocal microscope equipped with an EM-CCD camera, a lightsheet microscope with an EM-CCD camera, and a lightsheet microscope with an sCMOS camera in the course of 24 hours. Adapted from [@Reynaud:2015dx].](./figures/spim_data_rate.pdf){ width=50% }

Confocal microscopes equipped with EM-CCD cameras produce an image data rate of about $1\,\mathrm{MB/s}$. Surely, lightsheet microscopes are going to be at least in the same area? 

No, they are not. Lightsheet microscopes are usually equipped with state-of-the-art sCMOS[^scmosnote] cameras. These cameras, running at full speed, can easily produce data rates of $1 GB/s$ [@Reynaud:2015dx][^datarateimg], filling up a 500GiB SSD drive in less than 10 minutes, and amounting to nearly 90TiB of data _per day_, if running at full speed.

This deluge of data now poses a large problem both for the scientists using the lightsheet microscopes and producing that data, and also for the support staff that has to take care of data storage, compute clusters, and so on. This has led to approaches where microscopy data is acquired and processed in an interleaved way, with e.g. 10 minutes of data acquisition followed by 10 minutes of processing, such as in the case of imaging the zebrafish heart. [@Mickoleit:2014bl].

Furthermore, effective processing of long developmental timelapses, the parade discipline of lightsheet microscopes, is not possible without a cluster. 

The high data rate combined with the high spatiotemporal quality of the data leads to interesting challenges regarding data storage and processing, and instrument interaction for current and future lightsheet microscopes:

[^scmosnote]: sCMOS is a trademark of Fairchild Semiconductor and describes their take on high-resolution complimentary metal-oxide semiconductor (CMOS) active pixel sensors, featuring about 60% quantum efficiency, a low readout noise, and high readout speeds of about 100fps at full frame size, which is usually 4 to 6 megapixels.

## Challenges and Opportunities

### Taming the data

Data compression alone is not going to solve the data deluge issue posed by lightsheet microscopy: While the compression step requires time, but can nowadays, utilising efficient algorithms and multi-core processors or graphics cards, be made very quick, it also requires a decompression step, again taking time and restoring the data to it's original, unwieldy size. While successful efforts have already been made to democratise the use of lightsheet microscopes [@2016PLoSOneEduSPIM; @Pitrone:2013ki; @Gualda:2013gr], the expensive data processing requiring the use of clusters hinders users from effectively deploying one or multiple lightsheet microscopes. 

To really tame the data, one has to think of an alternative data representation, that could have a compression step, but without necessary decompression — instead, processing should happen on the alternative data representation. 

Such a representation has been developed [@Cheeseman:ia], named the _Adaptive Particle Representation_ (APR). The APR non-uniformly resamples images and stores information only where it actually is, saving a lot of storage space, especially for sparsely populated images, such as from fluorescence microscopes. 

In the chapter _Rendering the APR_ we are going to talk about how to use this representation for fast and efficient rendering of lightsheet microscopy data.

### Smart microscopy requires smart interactions

Scherf and Huisken [@Scherf:2015ba] have made the case in 2015 for smart and gentle microscopes, that not only know how to image a specimen, but also take great care in not disturbing the normal development of it, treating it as gently as possible, by means of adaptive laser power, imaging times and windows, and dynamic determination of regions of interest. 

Royer has developed a microscope for long-term _Drosophila_ imaging [@Royer:2016fh] that constantly measures image sharpness and embryo drift, and optimises the microscope's optical components in-between each stack of a timelapse for optimal image quality, fit for high-quality tracking and lineage tree creation for the whole time of embryo development.

Hufnagel \TODO{cite} has developed a microscope that combines adaptive lightsheet imaging with single-cell transcriptomics, yielding simulteneous insight into both gene expression and the spatiotemporal consequences of it.

All these microscopes, envisioned, and already existing, have in common that they require a very low to no level of human intervention during the imaging session, therefore allowing developmental imaging with unprecented precision, but no options to interfere with the specimen interactively, may it be via optogenetic manipulation, or laser microsurgery. Such tools are however invaluable for the biophysical investigation of tissue mechanics, and the combination of smart microscopy with smart, natural, and intuitive interaction techniques in 3D can open the door for new experiments leading to even deeper insight into both developmental and biophysical processes, such as _Drosophila_ wingdisc formation, or retinal development \TODO{cite Marija's paper}:

* In the case of _Drosophila_ wingdisc formations, investigations of tissue tensions and mechanics have so far been focused only on flat pieces of tissue, which do not constitute the main part of development, and are actually hard to find in the developing embryo. 3D interaction in that scenario can provide the user with easy access to more complex geometries to perform ablation experiments in.
* In the case of retinal development, which takes place on highly curved surfaces and in complex volumes, additional 3D interactions for ablation and optogenetics can lead to more insight into defects in retinal development, of which human medicine might ultimately benefit.

For these use cases, we are going into deeper detail in the chapter [Interactive Laser Ablation], developing an interactive demo of how such interactions might take place in the future, on a microscope, equipped with 3D virtual reality glasses, or from a room-scale virtual reality system.