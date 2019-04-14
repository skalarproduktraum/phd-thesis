\part[CASE STUDIES]{Case studies}

# SciView — integrating scenery into the Fiji ecosystem

![Screenshot of SciView, showing a multicolour segmentation of _Danio rerio_ vasculature. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, USA.\label{fig:SciViewScreenshot}](./figures/scenery-sciview.png)

## Introduction

### The ImageJ ecosystem

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

We have expanded the original code to make SNT work on top of SciView, with an example image shown in Figure \ref{fig:SNTnew}.

\begin{figure*}
    \includegraphics{./figures/sciviewSNT.png}
    \caption{Simple Neurite Tracer running on top of sciview.\label{fig:sciviewSNT}}
\end{figure*}



