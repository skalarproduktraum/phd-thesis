# SciView — integrating scenery into ImageJ2 & Fiji

![Screenshot of the sciview main window, showing the Game of Life 3D demo.\label{fig:SciViewMainWindow}](sciview-gameoflife.png)

Fiji [@schindelin2012fiji] is a widely-used — as of April 2019, it has been cited over 10000 times — open-source distribution of ImageJ for biological image analysis (Fiji stands for "Fiji is just ImageJ"). It is now the predominant ImageJ [@Schneider:2012nihi] distribution and recently had its  its underlying infrastructure modernised tremendously, e.g. by replacing its basic image processing library with imglib2 [@Pietzsch:2012img] in an effort to replace the original ImageJ 1.x with a newer replacement, dubbed ImageJ2, which has brought better interoperability and better overall design [@Rueden:2017ij2]. 

The original way of doing 3D visualisation in Fiji is the 3D Viewer [@Schmid:2010gm], which has now become dated a bit and is not being actively developed anymore, necessitating a replacement. After the start of the development of scenery in early 2016, we started the development of a replacement for 3D Viewer, named _sciview_. sciview builds heavily on the infrastructure provided by the Fiji, SciJava[^SciJavaNote], and ImageJ2 projects[@Rueden:2017ij2].

In this chapter, we are going to introduce sciview and explain how intertwining scenery and the ImageJ2/Fiji ecosystem creates a new powerful tool for interactive visualisations in the life sciences. We start by introducing the ImageJ2/Fiji ecosystem  in more detail, focussing on the developer side and explaining how the various parts are used in our project. After that, we introduce examplary use cases that have not been possible before, and projects that are enabled by scenery and sciview.

[^SciJavaNote]: See [scijava.org](https://scijava.org) and [imagej.net/SciJava](https://imagej.net/SciJava) for more information about the projects.

## Integration into the ImageJ2 & Fiji ecosystem

With its basis, SciJava common, ImageJ2 focuses very heavily on modularisation, extensibility, and interoperability. At the core of ImageJ2 is the support for N-dimensional image data, going beyond the "traditional" stack of 2D images from  microscopy, and extending towards multispectral and hyperspectral images, which might even include information about wavelengths, sample counts, polarisation states, etc. On the interoperability side, the SciJava infrastructure enables simple integration of write-once plugins into several different software suites, such as ImageJ2/Fiji, KNIME [@Berthold:2008kni], or Icy [@Chaumont:2012icy].

We make use of three main components from the ImageJ2 effort: 
* SciJava common, for providing core abstractions for extensible applications, such as for plugins and commands (more on that in a moment),
* SCIFIO, the _SCientific Image Format Input and Output_ library, facilitating image input and output in various formats, as well as interoperability between them, and
* ImgLib2 [@Pietzsch:2012img], which decouples image representation from processing and storage.

SciJava common provides us with several services that enable integration into ImageJ2/Fiji installations:

* the `PluginService` for dynamic plugin discovery at runtime,
* the `EventService`, for publishing and subscribing to scenery-related events, such as Node additions, removals and changes,
* the `IOService` for providing access to file input/output, e.g. via SCIFIO.

sciview itself is implemented as a SciJava `Service`, the `SciViewService`. A user can create a new sciview instance by running `SciViewService.createSciView()`, or get an already active instance by `SciViewService.getActiveSciView()`. sciview instances can also be named, and later accessed independently via `SciViewService.getSciView(name: String)`.

All commands the user can execute from the sciview main window are implemented as SciJava `Command` `Plugins`. As a simple and instructive example, the `Command` that adds the `Edit > Add Volume` command looks as follows:

```java
@Plugin(type = Command.class, menuRoot = "SciView", //
        menu = { @Menu(label = "Edit", weight = EDIT), //
                 @Menu(label = "Add Volume", weight = EDIT_ADD_VOLUME) })
public class AddVolume implements Command {

    @Parameter
    private SciView sciView;

    @Parameter
    private Dataset image;

    @Parameter(label = "Voxel Size X")
    private float voxelWidth = 1.0f;

    @Parameter(label = "Voxel Size Y")
    private float voxelHeight = 1.0f;

    @Parameter(label = "Voxel Size Z")
    private float voxelDepth = 1.0f;

    @Parameter(label = "Global rendering scale")
    private float renderScale = 1.0f;

    @Override
    public void run() {
        Node n = sciView.addVolume( image, new float[] { voxelWidth, voxelHeight, voxelDepth } );
        n.setRenderScale(renderScale);
    }

}
```

This example code shows one of the prime features of ImageJ2: the separation between data model and view (or GUI). All of the class members annotated as `@Parameter` are going to be either populated or used by SciJava's plugin infrastructure — the members referring to `Dataset`, or any kind of `Service` will be auto-populated with open files or services at hand from the current instance, so e.g. the parameter `sciView` will point to the current sciview instance. Members labelled `@Parameter` with no relation to a service will be user-editable parameters shown in the GUI dialog. How this `Command` is rendered in the default ImageJ2 Swing GUI is shown in Figure \ref{fig:SciViewAddVolume}. Such parameters can be named (`label`), given minimum and maximum boundaries, or styled as a particular widget.

\begin{marginfigure}
    \label{fig:SciViewAddVolume}
    \includegraphics{sciview-addvolume.png}
    \caption{sciview's \emph{Add Volume} dialog, shown in the default ImageJ2 Swing GUI.}
\end{marginfigure}

At the moment, all automatically-generated GUIs are generated for Swing.  The generation system however is abstract enough such that Swing can be replaced by e.g. JavaFX in the future.

## Example Use Cases

### Zebrafish development

![Screenshot of SciView, showing a multicolour segmentation of _Danio rerio_ vasculature. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, USA.\label{fig:SciViewScreenshot}](scenery-sciview.png)

\begin{marginfigure}
    \includegraphics{developmental-timelapse.png}
    \caption{Frames from a developmental timelapse of \emph{D. rerio} rendered in SciView, from \citep{Daetwyler:2018e8d}.}
    \label{fig:developmental_timelapse_sciview}
\end{marginfigure}

### Simple Neurite Tracer

In [@Longair:2011snt], the authors present an ImageJ/Fiji plugin for quick and semiautomatic tracing of neurons, even in noisy datasets. An image of the Simple Neurite Tracer (SNT) plugin running is shown in Fig \ref{fig:SNTOriginal}

\begin{figure*}
    \includegraphics{SimpleNeuriteTracer.png}
    \caption{Simple Neurite Tracer showing tracing neurons in the adult \emph{Drosophila} brain, and neuropils shown in addition to the traced neurites in the old Fiji 3D Viewer\label{fig:SNTOriginal}.}
\end{figure*}

We have expanded the original code to make SNT work on top of SciView, with an example image shown in Figure \ref{fig:sciviewSNT}.

\begin{figure*}
    \includegraphics{sciviewSNT.png}
    \caption{Simple Neurite Tracer running on top of sciview.\label{fig:sciviewSNT}}
\end{figure*}

### Constrained Segmentation of the Zebrafish heart

### Agent-based Simulations

We have utilized sciview to visualise agent-based simulations with large numbers of agents. By adapting the existing agent- and physics-based simulation toolkit _brevis_ [@brevis2019], we were able to increase the number of agents that can be visualised at interactive frame rates by a factor of 10, from originally 1000, on a notebook equipped with a Nvidia Quadro P4000 GPU with 8 GB of graphics memory. 

![An agent-based simulation of 10000 independent agents simulated using _brevis_ and visualised using _sciview_. See text for details.\label{fig:agentbased}](agentbased-simulation.pdf)

This performance improvement enables previous studies of swarms with evolving behaviours to be revisited under conditions that may enable new levels of emergent behaviour [@harrington2017; @gold2014]. In Figure~\ref{fig:agentbased}, we show 10,000 agents using flocking rules inspired by [@reynolds1987] to collectively form a sphere.

Subsequently, we were able to increase the number of agents, pushing the limits of scenery. The highest number of agents we could achieve was 2.500.000, although the framerate drops significantly to about 2-5 fps, as the GPU becomes overwhelmed with vertex and geometry processing.

## Conclusions and Future Work


