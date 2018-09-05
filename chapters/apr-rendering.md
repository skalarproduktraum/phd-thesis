# Rendering the Adaptive Particle Representation



The work presented in this chapter has been done in collaboration with Bevan Cheeseman, Sbalzarini Lab, MPI-CBG, and is partially published in Cheeseman, B.L., __Günther, U.__, Susik, M., Gonciarz, K., and Sbalzarini, I.F., 2018. _Forget Pixels: Adaptive Particle Representation of Fluorescence Microscopy Images_. [biorxiv.org/content/early/2018/03/02/263061](https://www.biorxiv.org/content/early/2018/03/02/263061), accepted at _Nature Communications_)



## Introduction

The Adaptive Particle Representation[@Cheeseman:ia] (APR) is a representation of image data that does not rely on regular sampling as found in pixel images, but instead uses computational particles to represent point intensities and further properties in space-filling data structure similar to an octree. Especially in the context of fluorescence microscopy, where images are mostly sparse, this alternative representation allows for highly efficient data storage and processing, resulting in space savings of a factor of 10 to 100 compared to the original image size.

## Theory

As bottlenecks in fluorescence microscopy not only exist with storage, but also with processing of the generated imagery, underlying the APR are four representation criteria:

* _RC1_ — The APR must guarantee a user-definable representation of noise-free images and must not degrade the signal-to-noise-ratio of noisy images. 
* _RC2_ — Memory cost and computational cost of the APR must be proportional to the information content of the image, and not its pixel size.
* _RC3_ — It must be possible to rapidly convert from image to APR, and back.
* _RC4_ — The APR must reduce both memory cost and computational cost, and allow existing algorithms to consume it with minimal changes, and without resorting back to a pixel representation during processing.

Before continuing, let us introduce and explain a few terms that we are going to need:

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
R(y) \leq L(y^*), \forall y: |y-y^*|\leq R(y)\label{eq:resbound}
\end{align},
with $L(y)=E\sigma(y)/|\nabla I|$, with $\nabla I$ being the gradient of the image. This inequality is called the _Resolution Bound_ and $L$ the _Local Resolution Estimate_. If the underlying image is assumed to be differentiable everywhere, and $\sigma(y)$ assumed to be sufficiently smooth, the Resolution Bound is stricter than the Reconstruction Condition, and an $R(y)$ subject to it will yield an equal or better representation accuracy. 

Second, If now the Resolution Function $R(y)$ is further restricted to consist only of square blocks, the optimal Resolution Function can be found in $\mathcal{O}(N)$.

### Particle Cells

The blocks constituting the Resolution Function must be powers of $1/2$ the image edge length in pixels $|\Omega|$[^sizenote]. The piecewise constant Resolution Function which is then defined by the upper edges of these blocks is called the _Implied Resolution Function_ $R^*(y)$, and it's blocks are called the _Particle Cells_, which all have a side length of $|\Omega|/2^l$. $l$ is called the _Particle Cell Level_ and ranges from $l_{\mathrm{min}}=1$, where the corresponding block has half the size of the original image, to $l_{\mathrm{max}}$, corresponding to blocks of pixel size.

With the two restrictions introduced, the determination of the optimal Resolution Function can be reduced to finding the smallest set $\mathcal{V}$ of particle cells defining a Resolution Function $R^*(y)$ that satisfies the Resolution Bound \ref{eq:resbound}. This smallest set is called the _Optimal Valid Particle Cell set_ (OVPC).

For now finding this set, we reformulate the Resolution Bound \ref{eq:resbound} in terms of Particle Cells:

* particle cells become arranged in a tree structure, with an individual particle cell labeled $c_{i,l}$ by level $l$ and location $i$ in the tree. The tree itself is a binary tree in 1D, a quadtree in 2D, and an octree in 3D.
* within this tree structure, the descendents of a particle cell can be naturally defined as all the child particle cells in the tree up to $l_{\mathrm{max}}$.
* $L(y)$ can then be represented as a set of particle cells $\mathcal{L}$ generated by iterating over all pixels $y^*$, and adding the particle cell with $l=\ceil{\log_2 \frac{|\Omega|}{L(y^*)}}$ and $i=\floor{\frac{2^l y^*}{|\Omega|}}$, if it is not there already. $\mathcal{L}$ is called the _Local Particle Cell set_ (LPC).

Then, the Resolution Bound can be reformulated as:

_A set of Particle Cells $\mathcal{V}$ will define an Implied Resolution Function $R^*(y)$ satisfying the Resolution Bound \ref{ey:resbound} for $L(y)$, iff $\forall p\in \mathcal{V}$ none of its descendents, or neighbor's descendents are in the LPC set $\mathcal{L}$._



[^sizenote]: If an image edge length is not a power of two, $|\Omega|$ is rounded up, and the image not padded.

### Pulling Scheme

With this definition, we can go on the describe the Pulling Scheme for finding the OVPC set in $\mathcal{O}(N)$ time. The name arises from the behaviour of a cell in $\mathcal{L}$ that pulls the resolution function down, leading to smaller particle cells across the image.

\SetKwProg{Fn}{Function}{}{}
\begin{algorithm}
	\KwData{Local Particle Cell set $\mathcal{L}$}
	\KwResult{Optimal Valid Particle Cell set $\mathcal{V}(\mathcal{L})$}
	\BlankLine
	
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
	
	
	\caption{\textbf{The Pulling Scheme algorithm}. The Pulling Scheme efficiently computes the OVPC set $\mathcal{V}$ from the Local Particle Cell set $\mathcal{L}$ using a temporary pyramid mesh data structure. $\mathcal{C}(l)$ denotes all Particle Cells on level $l$.
	\label{alg:pulling_scheme}    
\end{algorithm}


### Forming the APR

## Related Work

## Rendering

### Particle-based rendering

### GPU-based volume rendering

## Discussion