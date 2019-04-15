\part[CASE STUDIES]{Case studies}

# SciView — integrating scenery into the Fiji ecosystem

![Screenshot of SciView, showing a multicolour segmentation of _Danio rerio_ vasculature. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, USA.\label{fig:SciViewScreenshot}](./figures/scenery-sciview.png)

Fiji [@schindelin2012fiji] is a widely-used — as of April 2019, it has been cited over 10000 times — open-source platform for biological image analysis. It has evolved as a successor to the original ImageJ \TODO{Cite ImageJ} and has over the years modernised its underlying infrastructure tremendously, e.g. by replacing its basic image processing library with  imglib2 [@Pietzsch:2012img]. The original way of doing 3D visualisation in Fiji is the 3D Viewer [@Schmid:2010gm], which has now become dated a bit and is not being actively developed anymore, necessitating a replacement

After with the start of the development of scenery in early 2016, we started the development of a replacement for 3D Viewer, named _sciview_. sciview builds heavily on the infrastructure provided by the Fiji and SciJava projects[^SciJavaNote].

In this chapter, we are going to introduce sciview and explain how intertwining scenery and the Fiji ecosystem creates a new powerful tool for interactive visualisations in the life sciences. We start by introducing the Fiji ecosystem  in more detail, focussing on the developer side and explaining how the various parts are useful for our project.

[^SciJavaNote]: See [scijava.org](https://scijava.org) and [imagej.net/SciJava](https://imagej.net/SciJava) for more information about the projects.

## The Fiji ecosystem

## Example Use Cases

### Zebrafish development

\begin{marginfigure}
    \includegraphics{./figures/developmental-timelapse.png}
    \caption{Frames from a developmental timelapse of \emph{D. rerio} rendered in SciView, from \citep{Daetwyler:2018e8d}.}
    \label{fig:developmental_timelapse_sciview}
\end{marginfigure}

### Simple Neurite Tracer

In [@Longair:2011snt], the authors present an ImageJ/Fiji plugin for quick and semiautomatic tracing of neurons, even in noisy datasets. An image of the Simple Neurite Tracer (SNT) plugin running is shown in Fig \ref{fig:SNTOriginal}

\begin{figure*}
    \includegraphics{./figures/SimpleNeuriteTracer.png}
    \caption{Simple Neurite Tracer showing tracing neurons in the adult \emph{Drosophila} brain, and neuropils shown in addition to the traced neurites in the old Fiji 3D Viewer\label{fig:SNTOriginal}.}
\end{figure*}

We have expanded the original code to make SNT work on top of SciView, with an example image shown in Figure \ref{fig:sciviewSNT}.

\begin{figure*}
    \includegraphics{./figures/sciviewSNT.png}
    \caption{Simple Neurite Tracer running on top of sciview.\label{fig:sciviewSNT}}
\end{figure*}



