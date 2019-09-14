# sciview — Integrating scenery into ImageJ2 & Fiji

\alreadypublished{The work presented in this chapter has been done in collaboration with Tobias Pietzsch (MPI-CBG), Curtis Rueden (University of Wisconsin, Madison), Stephan Daetwyler (MPI-CBG and UT Southwestern, Texas), and Kyle I.S. Harrington (University of Idaho, Moscow, and HHMI Janelia Farm), and is currently being prepared for publication as:}{\textbf{Günther, U.}, Pietzsch, T., Rueden, C., Daetwyler, S., Huisken, J., Elicieri, K., Tomancak, P., Sbalzarini, I.F., Harrington, K.I.S.: sciview — Next-generation 3D visualisation for ImageJ \& Fiji.}

![Screenshot of the sciview main window, showing the Game of Life 3D demo.\label{fig:SciViewMainWindow}](sciview-gameoflife.png)

Fiji [@schindelin2012fiji] is a widely-used — as of April 2019, it has been cited over 10000 times — open-source distribution of ImageJ for biological image analysis (Fiji stands for "Fiji is just ImageJ"). It is now the predominant ImageJ [@Schneider:2012nihi] distribution. It recently had its  its underlying infrastructure modernised tremendously, e.g. by replacing its basic image processing library with imglib2 [@Pietzsch:2012img], and replacing the original ImageJ 1.x with ImageJ2, which has brought better interoperability and better overall design [@Rueden:2017ij2]. 

The original 3D visualisation tool in Fiji is the 3D Viewer [@Schmid:2010gm], which has now become dated and is not actively developed anymore, necessitating a replacement. After the start of the development of scenery in early 2016, we started the development of a replacement for 3D Viewer, named _sciview_. sciview builds on the infrastructure provided by the Fiji, SciJava[^SciJavaNote], and ImageJ2 projects [@Rueden:2017ij2].

In this chapter, we introduce sciview and explain how intertwining scenery and the ImageJ2/Fiji ecosystem creates a powerful new tool for interactive visualisations in the life sciences. We start by introducing the ImageJ2/Fiji ecosystem  in more detail, focussing on the developer side and explaining how the various parts are used in our project. After that, we introduce examplary use cases that have not been possible before, and projects that are enabled by scenery and sciview.

[^SciJavaNote]: See [scijava.org](https://scijava.org) and [imagej.net/SciJava](https://imagej.net/SciJava) for more information about the projects.

## Integration into the ImageJ2 & Fiji ecosystem

With its basis, SciJava common, ImageJ2 focuses heavily on modularisation, extensibility, and interoperability. At the core of ImageJ2 is the support for N-dimensional image data, going beyond the "traditional" stack of 2D images from  microscopy, and extending towards multispectral and hyperspectral images, which might even include information about wavelengths, sample counts, polarisation states, etc. On the interoperability side, the SciJava infrastructure enables simple integration of plugins that only need to be written once into several different software suites, such as ImageJ2/Fiji, KNIME [@berthold2008], and Icy [@Chaumont:2012icy].

We make use of three main components from the ImageJ2 effort: 

* SciJava common, for providing core abstractions for extensible applications, such as for plugins and commands (more on that in a moment),
* SCIFIO, the _SCientific Image Format Input and Output_ library, facilitating image input and output in various formats, as well as interoperability between formats, and
* ImgLib2 [@Pietzsch:2012img], which decouples image representation from processing and storage.

SciJava common provides several services that enable integration into ImageJ2/Fiji installations:

* the `PluginService` for dynamic plugin discovery at runtime,
* the `EventService`, for publishing and subscribing to scenery-related events, such as Node additions, removals, and changes,
* the `IOService` for providing access to file input/output, e.g., via SCIFIO.

sciview itself is implemented as a SciJava `Service`, the `SciViewService`. A user can create a new sciview instance by running `SciViewService.createSciView()`, or get an already active instance by `SciViewService.getActiveSciView()`. sciview instances can also be named, and later accessed independently via `SciViewService.getSciView(name: String)`.

All commands the user can execute from the sciview main window are implemented as SciJava `Command` `Plugins`. As a simple and instructive example, the `Command` that adds the `Edit > Add Volume` menu item is shown in \cref{lst:SciJavaCommand}.

\begin{lstlisting}[float, language=Java, caption={Example SciJava Command for adding a volume to a sciview scene.}, label=lst:SciJavaCommand]
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
\end{lstlisting}

This example code illustrates one of the prime features of ImageJ2: the separation of data model and view (or GUI). All of the class members annotated as `@Parameter` are going to be either populated automatically or exposed in the UI by SciJava's plugin infrastructure: all the members referring to `Dataset`, or any kind of `Service` will be automatically populated with the currently open dataset or services at hand from the ImageJ instance. E.g, the parameter `sciView` will point to the currently active sciview instance. Members labelled `@Parameter` with no relation to a service will be user-editable parameters shown in the GUI dialog. How this `Command` is rendered in the default ImageJ2 Swing GUI is shown in Figure \ref{fig:SciViewAddVolume}. Such parameters can be named (`label`), given minimum and maximum boundaries, or styled as a particular widget.

\begin{marginfigure}
    \label{fig:SciViewAddVolume}
    \includegraphics{sciview-addvolume.png}
    \caption{A simple example for an automatically generated UI: sciview's \emph{Add Volume} dialog, shown in the default ImageJ2 Swing GUI.}
\end{marginfigure}

At the moment, all automatically-generated GUIs are using Swing. The generation system however is abstract enough such that Swing can be replaced by JavaFX or another UI toolkit in the future.

## Example Use Cases

The remainder of this chapter is intended to showcase applications of sciview. We introduce three examples and discuss how sciview has helped in creating them.

### Zebrafish development

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/ZebrafishVascularDevelopment.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video demo of zebrafish vasculature development visualised in sciview. For a list of supplementary videos see \href{https://ulrik.is/writing/a-thesis}{https://ulrik.is/writing/a-thesis}.
\end{marginfigure}

\alreadypublished{The visualisations shown in this section have been published as part of:}{Daetwyler S., \textbf{Günther, U.}, Modes, Carl D., Harrington, K.I.S., and Huisken, J.: Multi-sample SPIM image acquisition, processing and analysis of vascular growth in zebrafish. \emph{Development} 146 (6), 2019. \href{https://www.biorxiv.org/content/10.1101/478149v1}{bioRxiv preprint 478149}.}

![Screenshot of sciview, showing a multicolour segmentation of _Danio rerio_ vasculature. Dataset courtesy of Stephan Daetwyler, Huisken Lab, MPI-CBG Dresden and Morgridge Institute for Research, Madison, USA.\label{fig:SciViewScreenshot}](scenery-sciview.png)



For the publication [@Daetwyler:2018e8d] we developed a custom visualisation pipeline to cope with the terabytes of image data generated in experiments which simultaneously imaged multiple _Danio rerio_ embryos over the course of several days in order to investigate vascular development. This was developed before scenery gained support for out-of-core volume rendering, so alternative techniques had to be employed to create timelapse videos of vascular development. The resulting script for controlling sciview to create the animation shown in \cref{fig:developmental_timelapse_sciview} and the supplementary video is shown in \cref{lst:ZebrafishTimelapse} — it reads all TIFF files from a given location (line 19 onward), and iterate through them one-by-one (line 23), saving a screenshot on each iteration (line 35).

\begin{marginfigure}[-4cm]
    \includegraphics{developmental-timelapse.png}
    \caption{Frames from a developmental timelapse of \emph{D. rerio} rendered in sciview, from \citep{Daetwyler:2018e8d}.}
    \label{fig:developmental_timelapse_sciview}
\end{marginfigure}

\begin{lstlisting}[language=JavaScript, label=lst:ZebrafishTimelapse, caption={sciview example script in JavaScript to display a zebrafish vasculature developmental timelapse, with each frame loaded individually. See text for details.}]
// import necessary packages
importPackage(java.nio.file);
importPackage(java.io);
importPackage(java.lang);
importPackage(java.util);

// get sciview object
var sc = sciView.getActiveSciView();

// get scene object
var scene = sc.getAllSceneNodes()[0].parent;

// get imported volume, number 6 in the array
var fish = scene.children[6];
// scale to half the original size
fish.renderScale = 0.5;

// get all TIFF files and sort by name
var files = new File("C:/my/fish/data/tiff/combined/angle000/").listFiles();
Arrays.sort(files, 0, files.length-1);

// iterate over all files
for(i = 0; i < files.length-1; i++) {
    var f = Paths.get(files[i]);
    fish.readFrom(f, true);
    Thread.sleep(1500);
    
    // adjust transfer function range and LUT
    fish.trangemin = 0.0;
    fish.trangemax = 255.0;
    sc.setColormap(fish, lut.loadLUT(lut.findLUTs().get("VirtualFishAssignment.lut")));
    Thread.sleep(500);
    
    // take a screenshot (which is saved to disk)
    sc.takeScreenshot();
    Thread.sleep(1500);
}
\end{lstlisting}



### Constrained Segmentation of the Zebrafish heart

\begin{marginfigure}
    \begin{center}
    \qrcode[height=3cm]{https://ulrik.is/thesising/supplement/ConstrainedSegmentation.mp4}
    \end{center}
    \vspace{1.0em}
    Scan this QR code to go to a video demo of the constrained segmentation. For a list of supplementary videos see \href{https://ulrik.is/writing/a-thesis}{https://ulrik.is/writing/a-thesis}.
\end{marginfigure}

In this use case, sciview is leveraged to simplify the segmentation procedure for parts of the zebrafish heart by introducing interactive mesh-based cropping as a pre-segmentation step.

Segmentation of intricate structures in 3D microscopy images, such as the zebrafish heart, using simple, off-the-shelf algorithms and suites such as _Weka_ [@Hall:2009WEKA], is often hampered by oversegmentation or noise. If the user can interactively constrain the region to be segmented, the performance of such algorithms can be increased tremendously.

The approach is the following:

1. The user uses ImageJ's point selection tool to roughly select points that define a convex shape around the region of interest for segmentation,
2. the image is visualised as a 3D volume in sciview, and the points from the point selection are shown as spheres within the volume,
3. the user moves the points around, either using a mouse, or VR controllers, until they constrain the dataset in a satisfactory manner (see \cref{fig:ConstrainedSegmentation}a),
4. a convex hull is calculated from such points using sciview's `InteractiveConvexMesh` command,
5. the convex hull is used to determine the inside of the relevant region of the volumetric dataset, and outside parts are removed or set to zero (see \cref{fig:ConstrainedSegmentation}b).
6. the resulting dataset is used with a trainable _Weka_ segmenter in 3D.

For the last step, less than 10 annotations had to be manually performed, in order to reach a good segmentation quality, as shown in \cref{fig:ConstrainedSegmentationResult}. This approach involves a tractable effort, and is able to effectively reduce formerly impossible segmentation problem to feasible ones.

\begin{figure}
    \includegraphics{constrained-segmentation.png}
    \caption{Constraining a volumetric image for segmentation using the \emph{thingy} command in SciView. a: Constrain points drawn into dataset (step 1), b: Outside of convex hull removed (step 5). See text for details. Dataset courtesy of Anjalie Schleppi, Huisken Lab, MPI-CBG and Morgridge Institute for Research.\label{fig:ConstrainedSegmentation}}
\end{figure}

\begin{marginfigure}[-4.5cm]
    \includegraphics{segmented-pericardium.png}
    \caption{Constrained segmentation result using a trainable Weka segmenter on the volume cropped before (step 6), as shown in \cref{fig:ConstrainedSegmentation}. See text for details. Dataset courtesy of Anjalie Schleppi, Huisken Lab, MPI-CBG and Morgridge Institute for Research.\label{fig:ConstrainedSegmentationResult}}
\end{marginfigure}


### EmbryoGen — Generating test data for algorithmic analysis of lightsheet imaging data

\begin{figure*}
    \includegraphics{embryogen.png}
    \caption{Visualisation of a simulated \emph{Drosophila} embryo using \emph{EmbryoGen} in sciview. The cells are shown as green spheres, while the equilibrating forces acting on them are shown as arrows on the right side where the cells are hidden. Courtesy of Vladimir Ulman, Tomancak and Jug Labs, MPI-CBG and Center for Systems Biology Dresden.\label{fig:EmbryoGen}}
\end{figure*}

Vladimir Ulman (Tomancak Lab, MPI-CBG) has developed a software, _EmbryoGen_, to create artificial, but realistic-looking images of developing _Drosophila_ embryos. EmbryoGen was developed in order to be able to compare segmentation and tracking algorithms with actual ground truth data of cell positions, sizes, and velocities, which is normally not available for microscope-acquired fluorescence microscopy datasets.

![EmbryoGen architecture, with the actual simulation written in C++ talking to scenery and sciview via a ZeroMQ-based protocol. See text for details.\label{fig:EmbryoGenArchitecture}](embryogen-communication.pdf)

EmbryoGen's visualisation is based on scenery and sciview, in order to harness the simultaneous visualisation of mesh data, coming from simulated cell shapes and positions, and volumetric data, calculated from the simulated cells. Employing a client-server architecture, EmbryoGen has the actual simulation code written in C++, and communicates with scenery and sciview via a simple, ZeroMQ-based protocol. A sketch of the architecture is shown in \cref{fig:EmbryoGenArchitecture}. The support of instancing in scenery (see [Instancing]) is helpful in this particular use case, as the number of simulated cells can easily reach many tens of thousands.

The visualisation of the simulation is used for debugging and demonstration purposes: The cells can be visualised individually (see \cref{fig:EmbryoGen}, with cells shown in green, and the forces acting on them as white arrows. Furthermore, the optical flow induced by the cells moving can be visualised (see \cref{fig:EmbryoGenOpticalFlow}.

\begin{figure}
    \includegraphics{embryogen-opticalflow.png}
    \caption{Visualisation of the optical flow generated by a simulated \emph{Drosophila} embryo using \emph{EmbryoGen} in sciview. Courtesy of Vladimir Ulman, Tomancak and Jug Labs, MPI-CBG and Center for Systems Biology Dresden.\label{fig:EmbryoGenOpticalFlow}}
\end{figure}


### Agent-based Simulations

We have used sciview to visualise agent-based simulations with large numbers of agents. By adapting the existing agent- and physics-based simulation toolkit _brevis_ [@brevis2019], we were able to increase the number of agents that can be visualised at interactive frame rates by a factor of 10, from originally 1000, on a notebook equipped with a Nvidia Quadro P4000 GPU with 8 GB of graphics memory. 

![An agent-based simulation of 10.000 independent agents simulated using _brevis_ and visualised using _sciview_. See text for details.\label{fig:agentbased}](agentbased-simulation.png)

This performance improvement enables previous studies of swarms with evolving behaviours to be revisited under conditions that may enable new levels of emergent behaviour [@harrington2017; @gold2014]. In Figure \ref{fig:agentbased}, we show 10.000 agents that use flocking rules inspired by [@reynolds1987] to collectively form a sphere.

Subsequently, we were able to further increase the number of agents, pushing the limits of scenery. The highest number of agents we could visualise was 2.500.000, albeit at a framerate of only about 2-5 fps, as the GPU becomes overwhelmed with vertex and geometry processing.

## Conclusions and Future Work

In the future, we want to integrate sciview even more tightly with the existing ImageJ ecosystem, for example by making image processing commands available in a context-based menu that can also be used in VR/AR, such that image processing tasks can be executed without having to take off the headset.

In order to make sciview more interoperable with other ecosystems, we will provide wrapper libraries. Such a library has already been developed to use sciview from Python, enabling use of, e.g., SciPy, Numpy, TensorFlow, or PyTorch[^PythonFrameworkNote], is currently undergoing testing, and will be published as open-source software in the near future.

[^PythonFrameworkNote]: SciPy and Numpy (see [scipy.org](https://scipy.org)) are Python frameworks for scientific computing, while TensorFlow ([tensorflow.org](https://tensorflow.org)) and PyTorch ([pytorch.org](https://pytorch.org)) are widely-used frameworks for GPU-accelerated deep learning and neural network prototyping.

Furthermore, we would like to provide better interoperability with simulation frameworks such as Morpheus [@Starruss:2014Morpheus] or OpenFPM [@Incardona:2019OpenFPM], to better facilitate the visualisation and analysis of experimental data in conjunction with data from models and simulations. In this context, we have already done preliminary work for simulating and visualising the growth of artificial neurons in conjunction with Simple Neurite Tracer [@Longair:2011snt] and a custom-built growth simulation. 

While the current GUI of sciview is based on Swing, we would like to provide support for JavaFX in the future as well. If Fiji/ImageJ2 also move to JavaFX, this would provide a very powerful combination, as it opens up the possibility to also run on touch-based devices, such as smartphones and tablets.

