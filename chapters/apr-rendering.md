# Rendering the Adaptive Particle Representation

\begin{publishedin}
The work presented in this chapter has been done in collaboration with Bevan Cheeseman, Sbalzarini Lab, MPI-CBG, and is partially published in\\
\vspace{0.5em} 
Cheeseman, B.L., \textbf{Günther, U.}, Susik, M., Gonciarz, K., and Sbalzarini, I.F.: Adaptive Particle Representation of Fluorescence Microscopy Images. \emph{Nature Communications}, 2018. \href{https://www.biorxiv.org/content/early/2018/03/02/263061}{bioRxiv preprint 263061}.
\end{publishedin}


## Introduction

The Adaptive Particle Representation (APR) [@Cheeseman:2018b12] is a representation of image data that does not rely on regular sampling as found in pixel images, but instead uses computational particles to represent point intensities and further properties in space-filling data structure similar to an octree. Especially in the context of fluorescence microscopy, where images are mostly sparse, this alternative representation allows for highly efficient data storage and processing, resulting in space savings of a factor of 10 to 100 compared to the original image size.

## Theory

![High-level overview of the APR construction pipeline: _1._ Input image _2._ Determination of the gradient magnitude and local intensity scale, allowing to adjust for local intensity variations across the image _3._ Estimation of the Local Resolution _4._ Construction of the Resolution Function from the Optimal Valid Particle Cell set _5._ The final APR as combination of the Optimal Valid Particle Cell set $\mathcal{V}$ and the Particle Set $\mathcal{P}$. Image reproduced from \citep{Cheeseman:2018b12}.\label{fig:APRPipeline}](apr-pipeline.pdf)

As bottlenecks in fluorescence microscopy not only exist with storage, but also with processing of the generated imagery, underlying the APR are four representation criteria:

* _RC1_ — The APR must guarantee a user-definable representation of noise-free images and must not degrade the signal-to-noise-ratio of noisy images. 
* _RC2_ — Memory cost and computational cost of the APR must be proportional to the information content of the image, and not its pixel size.
* _RC3_ — It must be possible to rapidly convert from image to APR, and back.
* _RC4_ — The APR must reduce both memory cost and computational cost, and allow existing algorithms to consume it with minimal changes, and without resorting back to a pixel representation during processing.

An overview of the APR construction pipeline is given in Figure \ref{fig:APRPipeline}. Before continuing, let us introduce and explain a few terms that we are going to need:

* _Particles_ — particles in the APR are a generalisation of pixels that can carry properties, such as, but not limited to, intensity or size. Particles, in contrast to pixels, to not need to reside on a Cartesian grid.
* _Implied Resolution Function_ — as the APR resamples an image using particles the implied resolution function governs the required or desired resolution everywhere in the image.
* _Local Intensity Scale_ — or $\sigma(y)$ for a point $y$ in the image is a estimation of the dynamic range locally present around $y$, introduced to not over-value bright parts of an image, and under-value dim parts.
* _Pulling Scheme_ — the pulling scheme is an algorithm that efficiently solves the particle positioning with regard to the implied resolution function, turning a problem that would otherwise scale as $\mathcal{O}(N^2)$ ($N$ being the number of particles) to $\mathcal{O}(N)$.

### Reconstruction condition

At each point $y$ of an image $I(y)$, and an image $\hat{I}(y)$ reconstructed from an APR, _RC1_ can be reformulated as finding the resolution function $R(y)$ that maximises
\begin{align}
|I(y) - \hat{I}(y)| \leq E\sigma(y)
\end{align}
where $E$ is the user-specified maximum error, and $\sigma(y)$ is the local intensity scale. As $\hat{I}(y)$ is reconstructed by interpolating over all particles in the APR, finding an optimal $R(y)$ is an $\mathcal{O}(N^2)$ operation in the number of particles. 

By introducing two restrictions on the formulation of $R(y)$, we can solve this problem though: 

First, we restrict $R(y)$ to satisfy
\begin{align}
R(y) \leq L(y^*), \forall y: |y-y^*|\leq R(y)\label{eq:resbound},
\end{align}
with $L(y)=E\sigma(y)/|\nabla I|$, with $\nabla I$ being the gradient of the image. This inequality is called the _Resolution Bound_ and $L$ the _Local Resolution Estimate_. If the underlying image is assumed to be differentiable everywhere, and $\sigma(y)$ assumed to be sufficiently smooth, the Resolution Bound is stricter than the Reconstruction Condition, and an $R(y)$ subject to it will yield an equal or better representation accuracy. 

Second, If now the Resolution Function $R(y)$ is further restricted to consist only of square blocks, the optimal Resolution Function can be found in $\mathcal{O}(N)$.

### Particle Cells

![Formation of the Optimal Valid Particle Set in the case that the local particle cell set $\mathcal{L}$ only has one cell. Image reproduced from  \citep{Cheeseman:2018b12}. \label{fig:OVPCFormation}](apr-ovpc.pdf)

The blocks constituting the Resolution Function must be powers of $1/2$ the image edge length in pixels $|\Omega|$[^sizenote]. The piecewise constant Resolution Function which is then defined by the upper edges of these blocks is called the _Implied Resolution Function_ $R^*(y)$, and it's blocks are called the _Particle Cells_, which all have a side length of $|\Omega|/2^l$. $l$ is called the _Particle Cell Level_ and ranges from $l_{\mathrm{min}}=1$, where the corresponding block has half the size of the original image, to $l_{\mathrm{max}}$, corresponding to blocks of pixel size.

With the two restrictions introduced, the determination of the optimal Resolution Function can be reduced to finding the smallest set $\mathcal{V}$ of particle cells defining a Resolution Function $R^*(y)$ that satisfies the Resolution Bound \ref{eq:resbound}. This smallest set is called the _Optimal Valid Particle Cell set_ (OVPC). 

For now finding this set, we reformulate the Resolution Bound \ref{eq:resbound} in terms of Particle Cells:

* particle cells become arranged in a tree structure, with an individual particle cell labeled $c_{i,l}$ by level $l$ and location $i$ in the tree. The tree itself is a binary tree in 1D, a quadtree in 2D, and an octree in 3D.
* within this tree structure, the descendents of a particle cell can be naturally defined as all the child particle cells in the tree up to $l_{\mathrm{max}}$.
* $L(y)$ can then be represented as a set of particle cells $\mathcal{L}$ generated by iterating over all pixels $y^*$, and adding the particle cell with $l=\ceil{\log_2 \frac{|\Omega|}{L(y^*)}}$ and $i=\floor{\frac{2^l y^*}{|\Omega|}}$, if it is not there already. $\mathcal{L}$ is called the _Local Particle Cell set_ (LPC).

For the formation of the OVPC, particles are given an additional _type_ property, which is `seed` if the cell is in both $\mathcal{V}$ and $\mathcal{L}$; `neighbor` in case their neighbor is of type `seed`; and `filler` in all other cases. See Figure \ref{fig:OVPCFormation} for a schematic how this set if formed in the case of $\mathcal{L}$ only containing one cell.

Then, the Resolution Bound can be reformulated as:

_A set of Particle Cells $\mathcal{V}$ will define an Implied Resolution Function $R^*(y)$ satisfying the Resolution Bound \ref{eq:resbound} for $L(y)$, iff $\forall p\in \mathcal{V}$ none of its descendents, or neighbor's descendents are in the LPC set $\mathcal{L}$._


[^sizenote]: If an image edge length is not a power of two, $|\Omega|$ is rounded up, and the image not padded.

### Pulling Scheme

With this definition, we can go on the describe the Pulling Scheme for finding the OVPC set in $\mathcal{O}(N)$ time. The name arises from the behaviour of a cell in $\mathcal{L}$ that pulls the resolution function down, leading to smaller particle cells across the image.

The algorithm for the pulling scheme is summarised in Algorithm \ref{alg:PullingScheme}.


\SetKwProg{Fn}{Function}{}{}
\begin{algorithm}
​	\KwData{Local Particle Cell set $\mathcal{L}$}
​	\KwResult{Optimal Valid Particle Cell set $\mathcal{V}(\mathcal{L})$}
​	\BlankLine
​	
	\Fn{pulling\_scheme($\mathcal{L}$)}
	{
		
		Represent all possible Particle Cells $\mathcal{C}$ from $l_{max}$ to $l_{min}$ in a multi-resolution pyramid and set all Particle Cells type to EMPTY\;
		\ForAll{Particle Cells $c \in \mathcal{C}$ where $c \in \mathcal{L}$}{
			$c$.type = SEED
		}
		
		\For{$l_c = l_{max}:l_{min}$ }{
			\tcc{Fill neighbors (Step 1)}
			\ForAll{neighbors $n$ of $c \in \mathcal{C}(l_c)$ where $c.type$ is (SEED or PROPAGATE)}{
				\uIf{$n$.type is EMPTY}{
					$n.\mathrm{type} = \mathrm{BOUNDARY}$
				}
			}
			\tcc{Set Parents (Step 2)}
			\ForAll{parents $p$ of $c \in \mathcal{C}(l_c)$ where $c.type$ is (SEED, PROPAGATE, or ASCENDANT)} {       
				$p.\mathrm{type} = \mathrm{ASCENDANT}$        
			}
			
			\uIf{$l_c > l_{min}$}{
				\tcc{Set Ascendant Neighbors (Step 3)}
				\ForAll{neighbors $n$ of $c \in \mathcal{C}(l_c-1)$ where $c.type$ is ASCENDANT }{
					\uIf{$n$.type is EMPTY}{
						$n.\mathrm{type} = \mathrm{ASCENDANT\_NEIGHBOR}$
					}
					\uIf{$n$.type is SEED}{
						$n.\mathrm{type} = \mathrm{PROPAGATE}$
					}
				}
				\tcc{Set Fillers (Step 4)}
				\ForAll{children $d$ of $c \in \mathcal{C}(l_c-1)$ where $c.type$ is (ASCENDANT\_NEIGH or PROPAGATE)}{               	    
					\uIf{($d$.type is EMPTY}{
						$d.\mathrm{type} = \mathrm{FILLER}$
					}
				}
			}
		}
		
		return all type SEED, BOUNDARY and FILLER Particle Cells in $\mathcal{C}$ as $\mathcal{V}$\;
	}
	\BlankLine


​	
	\caption{\textbf{The Pulling Scheme algorithm}. The Pulling Scheme efficiently computes the OVPC set $\mathcal{V}$ from the Local Particle Cell set $\mathcal{L}$ using a temporary pyramid mesh data structure. $\mathcal{C}(l)$ denotes all Particle Cells on level $l$.\label{alg:PullingScheme}} 
\end{algorithm}

The Pulling Scheme has the following properties:

* _Predictability and self-similar structure_ — neighbouring particle cells never differ by more than one level from each other, and are arranged in a fixed pattern around the smallest particle cells in the set. This structure is independent of the level itself and results in self-similarity between the levels. From this property, the OVPC set $\mathcal{V}$ can easily be constructed from any LPC set $\mathcal{L}$ with a single particle cell $c_{i,l}$.
* _Separability_ — The OVPC set can be found by considering each particle cell in $\mathcal{L}$ on its own, and afterwards combining them into one set, covering the whole image. See Figure \ref{fig:APRsep} for a visualisation.
* _Redundancy_ — When constructing $\mathcal{V}$, all particle cells in $\mathcal{L}$ that have descendants can be ignored, as descendants imply either the same or a tighter constraint on the Resolution Function.

![Separability property of the Pulling Scheme: In the first two parts, the construction of $R^*(y)$ is shown for two separate particle cells, $c_{19,6}$ and $c_{38,6}$. In the third part of the figure, their combination into the Local Particle set $\mathcal{L}$ is shown. Image reproduced from \citep{Cheeseman:2018b12}.\label{fig:APRsep}](apr-separability.pdf)

### Creating the APR from the Optimal Valid Particle Cell set

After determining $\mathcal{V}$ via the pulling scheme, the particles $\mathcal{P}$ have to be placed. The Resolution Bound implies that within radius $R^*(y)$ of a pixel at $y$, at least one particle has to be placed. This means that for each $c_{i,l} \in \mathcal{V}$, a particle $p$ is added to $\mathcal{P}$ with location 
\begin{align}
y_p = \frac{|\Omega|}{2^l}(i+0.5)\label{eq:ParticlePosition}. 
\end{align}
As particle positions are already governed by the particle cell, they do not need to be stored explicitly. The only data then stored explicitly are particle properties, such as interpolated intensities $I_p$.

Finally, the APR is formed from both the Optimal Valid Particle Cell set $\mathcal{V}$, and the Particle Set $\mathcal{P}$.

## Related Work

Adaptive sampling and multiresolution approaches have quite a history in  image processing: Ranging from pyramid image representations [@adelson1984pyramid], over super-pixels [@achanta2012slic; @amat2012fast], wavelet decompositions, level-set methods [@monasse2000fast], dictionary-based sparse representations [@davis1997adaptive], to adaptive mesh representations [@demaret2002scattered; @wang1996use; @yang2003fast], and dimensionality reduction [@schmid2013high; @heemskerk2015tissue]. None of these methods however are able to guarantee all the Reconstruction Criteria we have outlined earlier.

If we venture outside of just image processing and turn to (realtime) rendering, there are two additional techniques that bear a similarity:

* _Sparse Voxel Octrees_ (SVOs) [@Laine:EffectiveSVO; @Crassin:2011uo] work by voxelising a given geometry, with the actual voxels being stored in an octree data structure as final leaf nodes. SVOs are great for storing very large mesh data, but cannot efficiently represent volumetric data as we try to achieve. 
* _VDB_ [@Museth:2013gw] uses B+trees [@Bayer:2002ds] to hierarchically represent volumetric data. From the spatial organisation, VDB is closest to our approach, although the leaf nodes of their tree do still contain voxels instead of particles. Figure \ref{fig:vdb2d} shows a 2D representation of a VDB dataset.

![Representation of a narrow-band level set stored in the VDB data structure. The lower left part shows the tree structure of a 1D VDB representation of the circle above, with the sparse representation displayed at the bottom left. On the right, the 2D structure of the circle represented as VDB is shown. (Image reproduced from [@Museth:2013gw], branching factors here are chosen for visualisation purposes, and are chosen larger in practise).\label{fig:vdb2d}](vdb2d.png)

## Integration into _scenery_

Our APR software library, _libapr_ is written in C++ and available at [github.com/cheesema/libapr](https://github.com/cheesema/libapr). For interfacing with _scenery_, and the JavaVM ecosystem in general, we have developed a SWIG [@Workshop:uc] ([swig.org](https://swig.org)) wrapper that exposes nearly all of the _libapr_ functionality to Java. The wrapper functionality is part of the main repository.

SWIG works by creating an _interface definition file_ that specifies all header files that need to be wrapped, in our library this file can be found in the root directory as `libapr.i`, and is quite short. The interface definition also includes additional code that is needed to make the wrapping work, e.g. for renaming functions in the case that naming rules clash between wrapper and wrappee, or for specialising templated code. It also includes custom allocator/deallocator code for the `APR` and `ExtraParticleData`[^epdclassnote] class, as memory management between garbage-collected languages and non-garbage-collected ones is not straightforward: In our case, both those classes will retain references to a loaded APR, such that it does not get garbage collected by the VM.

[^epdclassnote]: The `ExtraParticleData` class contains functionality for attaching additional properties to particles, such as intensities.

### Limitations

SWIG does not have very good support for templated code, and the APR library is heavily templated. Therefore, the wrapped library contains only support for 16bit APRs, although this is not too limiting, as that is the most common case, at least in our main use case of fluorescence microscopy.

### Future Directions

We are exploring alternatives to SWIG, such as JavaCPP ([github.com/bytedeco/javacpp](https://github.com/bytedeco/javacpp), which has better support for state-of-the-art C++ features, and also includes an automatic wrapper generator, as well as the possibility for manual adjustments, which SWIG provides with the interface definition file.

A prototype of that effort has been developed by Krzysztof Gonciarz and can be found at [github.com/krzysg/LibAPR-java-wrapper](https://github.com/krzysg/LibAPR-java-wrapper).

## Goals

For visualising the Adaptive Particle Representation, we set the following goals:

* the software has to handle the APR datasets in realtime
* the software needs to be integrated at some point with the existing Fiji/ImageJ ecosystem, i.e. it needs to be usable from Java
* the software needs to support virtual reality visualisation
* the software needs to make use of the attributes provided by the APR particles, such as position, normals, etc.

## Initial prototype

The first prototype developed for APR visualisation, named _dive_, came to be before scenery development even had started.

dive was able to primitively visualise APR datasets as point clouds, with no postprocessing applied (see Figure \ref{fig:dive}), but included limited support for the Oculus Rift DK2 HMD. It was also written from scratch using OpenGL 3.3 and SDL, where the need for a much quicker prototyping solution became apparent, as this cost much more time than it should have.

![Visualisation of a _Drosophila_ dataset using _dive_ as a point cloud.  The original dataset size is 960 MiB, while the APR only consumes 70 MiB. Dataset courtesy of Tomancak Lab, MPI-CBG Dresden.\label{fig:dive}](dive.png)

### User feedback

A demo of _dive_ was shown at the 2014 BioImageInformatics conference in Leuven, Belgium. In addition, it was tested on 2 more lab members internally. The main points collected were:

* flat colouring leads to a false impression of the dataset
* dataset loading times were considered good, especially as the original dataset is about 960MiB, and the APR dataset only 70MiB.
* filtering based on particle properties should be possible

## Second prototype

The second prototype built was based on _scenery_ already, and included a port of the code used in _dive_ for importing the APR files. This port resulted in the creation of the Java wrappers discussed in [Integration into _scenery_].

This new iteration now had support for particle properties, as well as HDR and Ambient Occlusion as postprocessing options, as provided by default by scenery. A visualisation with AO on/off is shown in Figure \ref{fig:aprAO}. The second prototype did not include support for VR headsets, as this was still work in progress in scenery back then.

\begin{figure*}
    \includegraphics{apr-ao.png}
    \caption{Visualisation of a \emph{Danio rerio} vasculature dataset using scenery. Top: Ambient occlusion on, revealing the details of the vasculature. Bottom: Ambient occlusion off. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden \& Morgridge Institute for Research, Madison, USA.\label{fig:aprAO}}
\end{figure*}

### User feedback

 Compared to the first prototype, user feedback now was better:

 * Ambient Occlusion was well liked, as it gives the dataset a more plastic, more detailed appearance and highlights small details.
 * Custom colormaps introduce more customisation options.
 * Filtering can help to create segmentation-like visualisations easily.

However, there were also negative comments:

* 3D model-like appearance is unusual for microscopy datasets, biologists are more used to maximum intensity projections or alpha blending-based renderings.
* Re-addition of Virtual Reality support would be nice.
* It would be good if filtering on the particles could be interactively controlled.

## Particle-based rendering in scenery

For interactive rendering of the APR, we have integrated the Java wrapper with _scenery_[^demonote]. In scenery, we render the APR as point-based graphics, and subject it to the same postprocessing steps as all other renderings (such as screen-space ambient occlusion, and HDR exposure correction).

For point-based rendering, positions and intensities for particles for all levels of the APR are reconstructed according to Eq. \ref{eq:ParticlePosition}, and stored in a `Mesh`, with the following mapping:

| scenery Node property | APR contents |
|:--|:--|
| `Mesh.vertices` | Particle position (x, y, z) |
| `Mesh.normals` | Particle intensity, particle cell level, Particle normal x (optional) |
| `Mesh.texcoords` | Particle normal y, Particle normal z |

Table: APR-to-scenery mapping for particle properties. {#tbl:APRtoScenery}

Particle normals can be stored with the regular APR data as additional property, but they might also be computed on-the-fly. The vertex data is then rendered with a custom shader that provides multiple options for colouring the particles, such as colouring by level, by distance to observer, or intensity. The shader also enables thresholding of the particles, resulting in a very simple way to render isosurfaces and segmentations. An example segmentation of _D. rerio_ head vasculature is shown in Figure \ref{fig:APRvasculature} and an example direct particle rendering of a _Drosophila melanogaster_ embryo is shown in Figure \ref{fig:APRdrosophila}

[^demonote]: See [github.com/skalarproduktraum/aprrenderer](https://github.com/skalarproduktraum/aprrenderer) for demo code.

![Image of a APR-based segmentation of _Danio rerio_ head vasculature visualised as point-based graphics. Particles are coloured by distance to the camera. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden & Morgridge Institute for Research, Madison, USA\label{fig:APRvasculature}](apr-vasculature.png)

![Image of a APR-based direct particle rendering of a _Drosophila melanogaster_ embryo after cellularisation. Particles are here colored by level, with blue signifying the highest-resolution level, and red the lowest-resolution level. Dataset courtesy of Loïc Royer, MPI-CBG Dresden & Chen-Zuckerberg Biohub, San Francisco, USA\label{fig:APRdrosophila}](apr-drosophila.png)

## Particle-based maximum intensity projection

![Comparison of maximum intensity projections of a _Danio rerio_ (zebrafish) vasculature dataset with __a__ the maximum intensity projection based on the original pixel data and __b__ the maximum intensity projection based on the APR. Visually, there is no perceivable difference, only when the contrast is exaggerated, blocking artifacts from the lower particle cells become visible. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden & Morgridge Institute for Research, Madison, USA\label{fig:PixelVsAPR}](apr-raycasting.png)

![Comparison of maximum intensity projections of a _Triboleum castaneum_ (red flour beetle) dataset with __a__ the maximum intensity projection based on the original pixel data and __b__ the maximum intensity projection based on the APR. Visually, there is no perceivable difference, only when the contrast is exaggerated, blocking artifacts from the lower particle cells become visible. Dataset courtesy of Akanksha Jain, Tomancak Lab, MPI-CBG Dresden\label{fig:TriboliumPixelVsAPR}](apr-tribolium.png)

Maximum intensity projects of datasets are one of the most common visualisations used in fluorescence microscopy, therefore it needs to be supported on the APR.

The algorithm for achieving this is relatively simple: First, we create a Mipmap of the original image dimensions down to the lowest level, iterating over all particles, and adding the interpolated pixel intensity to the corresponding pixel. Second, the resulting per-level images are blended together to yield the final maximum intensity projection. More formally, this algorithm is stated in Algorithm \ref{alg:MaxProjectionAPR}.

Two example rendering resulting from this algorithm are shown in Figures \ref{fig:PixelVsAPR} and \ref{fig:TriboliumPixelVsAPR}, where it is also compared with a maximum intensity projection from the same pixel-based dataset. Visually, there is no difference, although blocking artifacts on the lowest particle cell levels will appear when the contrast is exaggerated.

\begin{algorithm}
  \SetKwData{Image}{image}
  \SetKwData{Presult}{$\hat{P}$}
  \SetKwFunction{InterpolateIntensity}{InterpolateIntensity}
  \SetKwFunction{Blend}{blend}
​	\KwData{APR consisting of OVPC $\mathcal{V}$ and particle set $\mathcal{P}$}
​	\KwResult{Maximum projection of the APR, $\hat{P}$}
​	\BlankLine
​	
	\Fn{max\_project\_apr($\mathcal{V}$, $\mathcal{P}$)}
	{
		\For{$l_c = l_{max}:l_{min}$ }{
	    	\Image$\leftarrow$ initialize as empty with dimensions $\Omega_{l_c}$
	    	\For{$c_{i,l_c} \in \mathcal{V}$ }{
	        	$y_p$ $\leftarrow$ $\frac{|\Omega|}{2^{l_c}}(i+0.5)$
	        	\tcc{\InterpolateIntensity can either directly use the particle's intensity, or interpolate it}
	        	\Image$(y_p)$ $\leftarrow$ \InterpolateIntensity{$c_{i,l_c}$,$\mathcal{P}$}
	    	}
	    	
	    	\tcc{Blend levels together, e.g. by max operation}
	    	\Presult \leftarrow \Blend{\Presult, \Image}
		}
	}
	\caption{Maximum Projection on the APR.\label{alg:MaxProjectionAPR}} 
\end{algorithm}




## Particle-based volume rendering of the APR on the GPU

Unfortunately, the algorithm presented in the previous section only works well on the CPU, as it requires a lot of random accesses to change pixel values, and therefore does not map well to the massively parallel architecture of GPUs. By just gathering particles on a per-level basis, it does also not make use of the space decomposition inherent to the APR. In this section, we present an alternative algorithm that solves these problems and makes the APR accessible as a basis for interactive volume rendering of large datasets.

In addition, the methodology we proposed in [Particle-based rendering in scenery], while certainly easy, does not deal well with the high number of particles an APR might contain, especially not when these particles occupy very little screen space, need to be depth-sorted, and blended together. In such cases, the performance can degrade very quickly. Furthermore, the typical user of the APR might not be used to particle-based renderings, but rather to volume renderings of microscopy data.

\begin{figure}
    \includegraphics{apr-decomposition.pdf}
    \caption{A slice of an APR rendered as particle intensities, particle cell level (larger circle equals lower level), cell type, and cell decomposition. Image reproduced from \citep{Cheeseman:2018b12}.\label{fig:aprDecomposition}}
\end{figure}

\begin{algorithm}
  \SetKwData{Image}{image}
  \SetKwData{Iresult}{$\hat{I}$}
​	\KwData{APR consisting of OVPC $\mathcal{V}$ and particle set $\mathcal{P}$}
​	\KwData{Ray with origin $\vec{o}$ and normalised direction $\vec{d}$}
  \SetKwFunction{GetNextCell}{NextCell}
  \SetKwFunction{SampledIntensity}{SampledIntensity}
  \SetKwFunction{ParticleIntensity}{ParticleIntensity}
  \SetKwFunction{GetExitPointForCell}{ExitPointForCell}
  \SetKwFunction{HitPoint}{$\vec{h}$}
  \SetKwFunction{Intensity}{$I_i$}
  \SetKwFunction{SIntensity}{$I(I_i, \vec{h})$}
  \SetKwFunction{RayOrigin}{$\vec{o}$}
  \SetKwFunction{RayOriginNew}{$\vec{o}'$}
​	\KwResult{Intensity per-ray, $\hat{I}$}
​	\BlankLine
​	
	\Fn{volumerender\_apr\_for\_ray($\mathcal{V}$, $\mathcal{P}$, $\vec{o}$, $\vec{d}$)}
	{
		\While{ $c \neq \mathrm{null}$ }{
    		\tcc{Query next cell from APR structure}
	    	$c$ $\leftarrow$ \GetNextCell{$\mathcal{V}$, $\mathcal{P}$, $\vec{o}$, $\vec{d}$}\;
	    	\RayOriginNew $\leftarrow$ \GetExitPointForCell{$c$, \RayOrigin, $\vec{d}$}\;
	    	\ForAll{Hit particles $i \in c$}{
    	    	\HitPoint \leftarrow $\vec{o} + \left|\vec{p}_i - \vec{o}\right| \cdot \vec{d}$\;
    	    	\Intensity \leftarrow \ParticleIntensity{\HitPoint}\;
    	    	\tcc{sample intensity according to \ref{eq:SampledIntensity} }
    	    	\SIntensity \leftarrow \SampledIntensity{\Intensity, \HitPoint}\;
    	    	\tcc{Blend particles together, e.g. by front-to-back blending}
    	    	\Iresult \leftarrow \Blend{\Iresult, \SIntensity}\;
	    	}
	    	\RayOrigin \leftarrow \RayOriginNew\;
		}
	}
	\caption{Volume rendering of the APR.\label{alg:VolumeRenderingAPR} See text for a detailed explanation of the steps.} 
\end{algorithm}

Our approach bears similarity to the algorithm proposed in [@knoll2019], where radial basis functions are used as a basic primitive to emulate rasterisation-based billboard splatting via raytracing. Compared to [@knoll2019], we however do not need to build an acceleration data structure, as the APR already provides a decomposition of space from which the particles can efficiently be accessed. See Figure \ref{fig:aprDecomposition} for an example how the APR decomposes space into cells in an example dataset. Using this decomposition the dataset can be traversed efficiently for raycasting. The particles in the APR then also have a naturally-defined bounding box, and can be interpolated using Gaussians/Radial Basis Functions, or a piecewice constant function. For calculating the intersection of a particle $i$ at position $\vec{p}_i$ with radius $r_i$ with a ray of normalised direction $\vec{d}$ and origin $\vec{o}$, the hit point $\vec{h}$ is given as 

\begin{align}
    \vec{h} & = \vec{o} + \left|\vec{p}_i - \vec{o}\right| \cdot \vec{d}.
\end{align}

Depending on whether to reconstruct using a Gaussian or a piecewise constant function, the sampled intensity $I(I_i,\vec{h})$ then is one of

\begin{align}
    I(I_i,\vec{h})_\mathrm{Gaussian} &= I_i \cdot \exp\left( -\frac{\left(\vec{h} - \vec{p_i}\right)^2}{r_i^2} \right) \nonumber \\
    I(I_i,\vec{h})_\mathrm{Piecewise} &= I_i,
    \label{eq:SampledIntensity}
\end{align}

where $I_i$ is the intensity of the particle $i$. The algorithm for APR traversal for a single ray of origin $\vec{o}$, direction $\vec{d}$, and maximum length $d_\mathrm{max}$ is then given as algorithm in algorithm \ref{alg:VolumeRenderingAPR}.

The proposed algorithm is currently being implemented in scenery.

## Discussion and Future Work

In this chapter, we have introduced the Adaptive Particle Representation (APR) and provided a brief summary of how it is constructed from a given image. We have shown the evolution of rendering the APR, going from an initial, unshaded prototype, over particle-based rendering with interpolated surface normals and ambient occlusion, to maximum projection and a proposal for actual volume rendering on the APR data structures.

At the moment, we are finalising the interfacing of the `libapr` C++ code with Java code, such that scenery can also benefit in full from the APR data structures and transfer these directly to the GPU without any conversions necessary such that the algorithm described in [Particle-based volume rendering of the APR on the GPU] can be implemented efficiently and without resorting to additional data structures. When the integration is done and verified, we want to perform benchmarking, comparing regular volume rendering to volume rendering on the APR, which will likely provide a large speedup, especially when going to extremely large datasets, but sparse volumetric datasets of >100 TB, where the APR can play out its full potential.

Additionally, the spatial sampling of the APR is currently being extended to the time domain by Bevan Cheeseman (APR+t). For multi-timepoint datasets, this is going to provide an additional boost in data reduction, such that volume rendering multi-timepoint datasets with high individual timepoint sizes could also become much faster.

On the applications side, remote 3D collaboration on volumetric datasets is currently hampered by the need to either possess or transfer the dataset to all participants — for gigabyte-sized datasets a nuisance, for terabyte-sized datasets nearly impossible without time-intensive preparation, and sharing of data via sneakernet. Alternatively, browser-based approaches like CATMAID [@Anonymous:2009fx] can be used, but suffer from latency — especially in the case of VR/AR rendering — and the need of centralised, fast hardware. 

The APR, and especially  the APR+t provides a way out here, by reaching data reduction rates of 20-100, moving gigabytes to megabytes, and terabytes to gigabytes. As scenery already includes capabilities for synchronisation over the network, remote 3D collaboration on large volumetric datasets is an interesting research avenue for the future.


