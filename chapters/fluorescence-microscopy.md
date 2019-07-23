\part[Introduction]{Introduction}

# Fluorescence Microscopy

Fluorescence microscopy is one of the major techniques used in cell, developmental and systems biology. In the most basic version, a fluorescent molecule is introduced into the biological specimen, staining it. The early fluorescent markers used (e.g. FITC, Hoechst), are however highly cytotoxic and incompatible with life, and can therefore only be used for fixed specimen. Newer developments led the the introduction of fluorescent proteins into to organism of interest  via genetic engineering. These fluorescent proteins are biocompatible and can therefore be used to study processes in a living organism.

A fluorescent protein emits photons of wavelength $\lambda_\mathrm{illumination}$ after being illuminated with a shorter excitation wavelength $\lambda_\mathrm{detection}$. One of the most popular fluorescent proteins is GFP, or green fluorescent protein, was originally isolated from the jellyfish _Aequorea victoria_ [@heim1995]. GFP has a _quantum yield_ of 0.79 photons per excitation photon. The emission of photons in the fluorescent protein itself originates from an active _chromophore_, usually located in the center of the protein (see Figure \ref{fig:gfp} for a cartoon of the structure). The chromophore can emit a certain number of photons after excitation before stopping (photobleaching). This leads to the problem that in each microscopy application, one has to take into account the available photon budget, resulting from the interplay of excitation intensity and quantum yield.

\begin{marginfigure}
    \includegraphics{gfp.png}
    \caption{The green fluorescent protein GFP, with the beta barrel cut away on the right sight, revealing the chromophore. Image courtesy of Raymond Keller, Public Domain.\label{fig:gfp}}
\end{marginfigure} 

In _widefield fluorescence microscopy_, the full specimen is illuminated at once with the excitation wavelength, leading to a single 2D image of the specimen. The resolution of a microscope is defined via its _point spread function_ (PSF), which is not directly observable, but measurable as its square $|h(x,y,z)|^2$. The intensity $I(x,y,z)$ of an object $O(x,y,z)$ in the image plane is then its convolution with the PSF,

\begin{align}
I(x,y,z) & = O(x,y,z) \otimes |h(x,y,z)|^2.
\end{align}

In the widefield microscope, illumination and detection are done through the same optical path. Were this not the case, the total PSF would be a product of both the illumination and detection PSFs,

\begin{align}
|h_{\mathrm{full}}|^2 & = |h_{\mathrm{i}}|^2 \cdot |h_{\mathrm{d}}|^2.
\end{align}

For more complex specimen, and to study three-dimensional structures, more advanced techniques are used, which we will introduce in the following.

## Confocal Microscopy

The confocal microscope was developed in the 1960s by Marvin Minsky, one of the pioneers of Artificial Intelligence (AI), in order to investigate neural connections in the central nervous system of mammals, and draw conclusions for AI from that. The confocal microscope enables optical sectioning by illuminating the sample sample with a coherent light source, nowadays lasers, and rejecting the emitted fluorescence with a pinhole. With this principle, it is possible to scan the specimen point-wise in X and Y directions, and provide optical sectioning by also moving it in the Z direction. Occurring fluorescence that was not rejected as background by the pinhole gets collected point-wise by a photomultiplier, and an image or volume reconstructed from that. The principle of operation is also pictured in \ref{fig:confocal_principle}. An example of an image taken with a confocal microscope is shown in Figure \ref{fig:ConfocalActinFilaments}

\begin{marginfigure}
    \label{fig:ConfocalActinFilaments}
    \includegraphics{./figures/confocal-actin-filaments.png}
    \caption{Z projection of a phalloidin-labeled osteosarcoma cancer cell, making actin filaments visible. Image taken on a Zeiss LSM780 confocal microscope. Image (cc) by Howard Vidin, Wikimedia Commons}  
\end{marginfigure}

![\label{fig:confocal_principle}Confocal microscope operating principle,  10: Arc lamp (laser, nowadays), 12: Illumination pinhole, 16: Dichroic mirror, 22: specimen, 26: Pinhole, 28: Photomultiplier diode (Public Domain, from Marvin Minksky's original patent application).](./figures/confocal_principle.png)

### Image formation

The confocal microscope uses a single lens for illumination and detection, achieves focused illumination through beam scanning, and detects photons from fluorescence via its pinhole. As the illumination and detection wavelengths differ, the confocal's PSF is given as the product of the illumination and the detection PSF. However, when illumination and detection wavelengths nearly coincide, e.g. for GFP $\lambda_{\mathrm{illumination}}=488\mathrm{nm}$ and $\lambda_{\mathrm{detection}}=520\mathrm{nm}$, the total PSF is approximately equal to the square of the PSF of the widefield microscope, resulting in a $\approx 1/\sqrt{2}$ better resolution.

### Shortcomings

Though a very useful instrument with a higher resolution than a widefield microscope, the confocal microscope has a few issues, namely:

* A lot of the photon yield is discarded, due to the pinhole. For fast acquisitions, this can lead to images with a very low signal-to-noise ratio.
* Due to scanning the laser over each point to be imaged, the specimen is exposed to high levels of light. In addition, the scanning process can be quite slow, up to 1 or 2 seconds per image. Spinning Disk Confocal Microscopes alleviate this issue to some extent, leading to much higher acquisition speeds by multiplexing the illumination process.

In the next section, we will explain lightsheet microscopy, which aims to alleviate these shortcomings.

## Lightsheet Microscopy

In lightsheet, or similarly, selective plane illumination microscopy[@Huisken:2004ky][^spimnote], the specimen is illuminated by a coherent light source in a 90º angle to the detection plane. The illumination light is focused into a thin sheet of light by means of a cylindrical lens (selective plane illumination microscopy, SPIM), or by scanning a Gaussian laser beam (digitally scanned lightsheet microscope, DSLM). This means that a full-frame 2D image of the specimen can be acquired at once, without point scanning, lowering the required light intensity by a substantial amount. Further, many 2D acquisitions can happen sequentially, enabling the capture of fast biological processes in 3D and 4D, such as the beating of the zebrafish _Danio rerio_'s heart[@Mickoleit:2014bl].

[^spimnote]: Throughout the remainder of this work, for the sake of brevity, we are going to refer to both lightsheet microscopy and SPIM microscopy simply as "lightsheet microscopy".

### Image formation

In the lightsheet microscope, illumination and detection are again separate, leading to separate PSFs for illumination and detection. 
The microscope's lightsheet thickness should be optimised for the detection optics, choosing the numerical aperture of the illumination such that the lightsheet has a uniform thickness across the entire field of view[@Huisken:5iIUZiJj]. However the lightsheet can usually not be made completely uniform, and will be thinnest at the focus. One possible compromise is to choose the NA so that the lightsheet is twice as thick at the edges of the field-of-view as it is in the middle. The PSF of the SPIM can finally be approximated with Gaussians, yielding[@Huisken:5iIUZiJj]:

\begin{align}
|h_{\mathrm{SPIM}}(x,y,z)|^2 \propto \exp\left( -\frac{2x}{w_{\mathrm{lat}}^2} -\frac{2y}{w_{\mathrm{lat}}^2} -\frac{2z}{w_{\mathrm{axial}}^2} \right)
\end{align}, where $w_\mathrm{lat}$ is the lightsheet thickness.

The lightsheet microscope also has the benefit that samples can be mounted in a movable way, and imaged from multiple directions, finally fusing the best parts of the image together for optimal image quality[@preibisch2014efficient]. Furthermore, the sample can also be illuminated from multiple directions[@Weber:2012kw]. Many realisations of lightsheet microscopes enable the user to move the sample in X, Y, and Z directions, and additionally rotate it at high speeds.

### Data rates

\begin{marginfigure}
    \includegraphics{./figures/spim_data_rate.pdf}
    \caption{Comparison of the data produced by different microscope types within 24 hours. Adapted from \citep{Reynaud:2015dx}.}
    \label{fig:spim_data_rate}
\end{marginfigure}

Confocal microscopes equipped with EM-CCD cameras produce an image data rate of about $1\,\mathrm{MB/s}$. Lightsheet microscopes however, play in a different league, as they are usually equipped with state-of-the-art sCMOS cameras (which offer about 60% quantum efficiency, a low readout noise, and high readout speeds of about 100fps at full frame size, which is usually 4 to 6 megapixels). These cameras, running at full speed, can easily produce data rates of $1 GB/s$ [@Reynaud:2015dx], filling up a 500GiB SSD drive in less than 10 minutes, and amounting to nearly 90TiB of data _per day_, if running at full speed. For a visual comparison, have a look at Figure \ref{fig:spim_data_rate}.

This deluge of data now poses a large problem both for the scientists using the lightsheet microscopes and producing that data, and also for the support staff that has to take care of data storage, compute clusters, and so on. This has led to approaches where microscopy data is acquired and processed in an interleaved way, with e.g. 10 minutes of data acquisition followed by 10 minutes of processing, such as in the case of imaging the zebrafish heart. [@Mickoleit:2014bl].

Furthermore, effective processing of long developmental timelapses, the parade discipline of lightsheet microscopes, is not possible without a cluster. 

The high data rate combined with the high spatiotemporal quality of the data leads to interesting challenges regarding data storage and processing, and instrument interaction for current and future lightsheet microscopes:

## Challenges and Opportunities

### Taming the data

Data compression alone is not going to solve the data deluge issue posed by lightsheet microscopy: While the compression step requires time, but can nowadays, utilising efficient algorithms and multi-core processors or graphics cards, be made very quick, it also requires a decompression step, again taking time and restoring the data to it's original, unwieldy size. While successful efforts have already been made to democratise the use of lightsheet microscopes [@2016PLoSOneEduSPIM; @Pitrone:2013ki; @Gualda:2013gr], the expensive data processing requiring the use of clusters hinders users from effectively deploying one or multiple lightsheet microscopes. 

To really tame the data, one has to think of an alternative data representation, that could have a compression step, but without necessary decompression — instead, processing should happen on the alternative data representation. 

Such a representation has been developed [@Cheeseman:2018b12], named the _Adaptive Particle Representation_ (APR). The APR non-uniformly resamples images and stores information only where it actually is, saving a lot of storage space, especially for sparsely populated images, such as from fluorescence microscopes. 

In the chapter [Rendering the Adaptive Particle Representation] we are going to talk about how to use this representation for fast and efficient rendering of lightsheet microscopy data.

### Smart microscopy requires smart interactions

Scherf and Huisken [@Scherf:2015ba] have made the case in 2015 for smart and gentle microscopes, that not only know how to image a specimen, but also take great care in not disturbing the normal development of it, treating it as gently as possible, by means of adaptive laser power, imaging times and windows, and dynamic determination of regions of interest. 

Royer has developed a microscope for long-term _Drosophila_ imaging [@Royer:2016fh] that constantly measures image sharpness and embryo drift, and optimises the microscope's optical components in-between each stack of a timelapse for optimal image quality, fit for high-quality tracking and lineage tree creation for the whole time of embryo development.

Hufnagel[@Guignard:bi] has developed a microscope that combines adaptive lightsheet imaging with single-cell transcriptomics, yielding simulteneous insight into both gene expression and the spatiotemporal consequences of it.

All these microscopes, envisioned, and already existing, have in common that they require a very low to no level of human intervention during the imaging session, therefore allowing developmental imaging with unprecented precision, but no options to interfere with the specimen interactively, may it be via optogenetic manipulation, or laser microsurgery. Such tools are however invaluable for the biophysical investigation of tissue mechanics, and the combination of smart microscopy with smart, natural, and intuitive interaction techniques in 3D can open the door for new experiments leading to even deeper insight into both developmental and biophysical processes, such as _Drosophila_ wingdisc formation, or retinal development[@Matejcic:2018hj]:

* In the case of _Drosophila_ wingdisc formations, investigations of tissue tensions and mechanics have so far been focused only on flat pieces of tissue, which do not constitute the main part of development, and are actually hard to find in the developing embryo. 3D interaction in that scenario can provide the user with easy access to more complex geometries to perform ablation experiments in.
* In the case of retinal development, which takes place on highly curved surfaces and in complex volumes, additional 3D interactions for ablation and optogenetics can lead to more insight into defects in retinal development, of which human medicine might ultimately benefit.

For these use cases, we are going into deeper detail in the chapter [Interactive Laser Ablation], developing an interactive demo of how such interactions might take place in the future, on a microscope, equipped with 3D virtual reality glasses, or from a room-scale virtual reality system. Additionally, in the chapter [Attentive Tracking], we discuss a new way to approach tracking and tracing problems on images resulting from fluorescence microscopy by utilising eye tracking.

