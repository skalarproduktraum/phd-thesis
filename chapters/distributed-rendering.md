# Distributed Rendering

\begin{figure*}
    \includegraphics{scenery-cave.jpg}
    \caption{A user interacting with a \emph{Drosophila} dataset rendered on a clustered 4-sided CAVE setup with 5 machines. Photo courtesy of Aryaman Gupta, MPI-CBG, Dresden.}
\end{figure*}

Apart from rendering to VR/AR headsets, scenery includes support for parallel and distributed rendering on multiple machines. While all scenery-based applications are in principle ready to run on multiple machines in concert, a bit of configuration is required. This chapter details the necessary steps, starting with the geometry definition for multi-projector/multi-screen environments, followed by an explanation what steps are necessary on the software side. We end the chapter with information about how scenery keeps the information on all machines synchronised.

## Screen Geometry Definition

For setting up a multi-projector, multi-machine environment with scenery, the physical geometry of the projection space has to be defined. This is done using a simple YAML file, an example of which can be seen in Listing \ref{lst:CAVEConfig}.

\begin{lstlisting}[language=YAML, caption={Simple configuration file for a four-sided CAVE environment with each wall having a resolution of 2560x1600 pixels.}, label=lst:CAVEConfig]
name: CAVE example configuration
description: Multi-screen configuration, demoing a 4-sided CAVE environment
screenWidth: 2560
screenHeight: 1600

screens:
  front:
    match:
      type: Property
      value: front
    lowerLeft: -1.92, 0.00, 1.92
    lowerRight: 1.92, 0.00, 1.92
    upperLeft: -1.92, 2.40, 1.92
  left:
      match:
        type: Property
        value: left
      lowerLeft: -1.92, 0.00, -1.92
      lowerRight: -1.92, 0.00, 1.92
      upperLeft: -1.92, 2.40, -1.92
  right:
      match:
        type: Property
        value: right
      lowerLeft: 1.92, 0.00, 1.92
      lowerRight: 1.92, 0.00, -1.92
      upperLeft: 1.92, 2.40, 1.92
  floor:
      match:
        type: Property
        value: floor
      lowerLeft: -1.92, 0.00, -0.48
      lowerRight: 1.92, 0.00, -0.48
      upperLeft: -1.92, 0.00, 1.92
\end{lstlisting}

First, the name and description of the configuration are set (lines 1 and 2), along with the screen dimensions in pixels (lines 3 and 4, all screens have to have the same pixel width and height). Following that, a set of screens is defined (line 6 and following). These screens can have arbitrary names, and should ideally reflect a physical property, e.g. relating to their positioning in the room. The `match` element (e.g. line 8) defines how scenery determines which machine in the cluster is associated with which screen. Two ways are possible for this:

* `type: Property`, where the screen is determined by the system property `scenery.screenName` set to the string given in `value`, or
* `type: Hostname`, where the screen is determined by matching the hostname of the machine to the name given in `value`.

The following three vectors, `lowerLeft`, `lowerRight`, and `upperLeft` determine the corners of the screen surface in physical space, which is assumed to be rectangular (e.g. lines 11, 12, and 13). Note here that the tracking system also needs to be calibrated to the same coordinate space. In the example above, the coordinate origin is on the floor, 0.48m in front of the `front` screen, and each screen has a width of 3.84m, and a height of 2.40m.


## Synchronisation of Scene Data

Scene data is synchronised using a custom ZeroMQ-based protocol. ZeroMQ is a low-latency message-passing library with bindings for a variety of languages, and support of all major operating systems. It is very resilient to network issues, e.g., lost connections are reestablished automatically. Furthermore, ZeroMQ supports multiple connection topologies, such as publish-subscribe (non-blocking), request-reply (blocking), or push-pull. We use the publish-subscribe topology, which is non-blocking, to synchronise scene contents. The actual synchronisation is deliberately kept extremely simple, in order to be able to execute the synchronisation step as fast as possible.

Two classes in scenery are responsible for scene synchronisation, _NodePublisher_ and _NodeSubscriber_. The NodePublisher creates a ZeroMQ Publisher socket, to which an arbitrary number of _NodeSubscribers_ can connect. Node changes are detected using the mechanism described in [Push Mode], it is the same the renderer uses to decide whether a node needs re-rendering. If a node changes, it is serialised into a stream of bytes using the open-source library Kryo[^KryoNote] library. Kryo was chosen on the basis of performance and usability: It outperforms most other Java serialisation libraries, while not requiring code changes or large additions, and can be augmented with custom (de)serialisation routines.

A NodePublisher instance is created by default when scenery's base class `SceneryBase` initialises. It then listens on the local network interface on port 6666 for connections. NodeSubscribers are not created by default. They are only created if the system property `scenery.MasterNode` is set to the address of a master node.

A schematic of the scene synchronisation is shown in \cref{fig:SceneSync}.

\begin{figure*}
    \includegraphics{scenery-pubsub.pdf}
    \caption{Schematic of the scene synchronisation in scenery, where one or more clients connect to a master in order to synchronise scene contents over the network via ZeroMQ. See text for details.\label{fig:SceneSync}}
\end{figure*}

[^KryoNote]: See [github.com/EsotericSoftware/Kryo](https://github.com/EsotericSoftware/Kryo) for code and details.

## Software Setup for Clustering

At the time of writing, scenery requires a script to launch the remote clients that connect to the NodePublishers on the master node. On Windows, the utility `psexec` can be used, while on Linux `ssh` is the utility of choice. In \cref{lst:runcluster}, a script is shown to launch scenery instances on a number of nodes with `psexec`:  Lines 3 to 6 launch scenery instances on the machines wall1 to wall4, with user credentials given by `username` and `password`.

\begin{lstlisting}[language=command.com, caption={\texttt{run-cluster.bat} for launching multiple scenery instances on different Windows machines via \texttt{psexec}.}, label=lst:runcluster]
@echo off
echo "Running test %1"
call psexec -f -d -i -u username -p password \\wall1 -c run.bat %1 left
call psexec -f -d -i -u username -p password \\wall2 -c run.bat %1 front
call psexec -f -d -i -u username -p password \\wall4 -c run.bat %1 floor
call psexec -f -d -i -u username -p password \\wall3 -c run.bat %1 right

exit /b 0
\end{lstlisting}

\cref{lst:run} shows the script that launches the individual instance on a machine with the required parameters: Line 2 creates a network share from a path on the master node containing the scenery application, and Line 2 runs scenery, activating fullscreen mode (line 3), activating framelock (line 4), declaring the master node address (line 6), screen name (line 7), and activating VR rendering from the start (lines 8 and 9). In this example, the screen configuration for each wall is determine by the system property `scenery.ScreenName`, as defined in \cref{lst:CAVEConfig} on line 8.

\begin{lstlisting}[language=command.com, caption={\texttt{run.bat} for running a scenery instance on a node.}, label=lst:run]
net use S: \\master\scenery-base
java -cp "S:/scenery/target/*;S:/scenery/target/dependency/*" -Xmx16g^
 -Dscenery.RunFullscreen=true^ 
 -Dscenery.VulkanRenderer.UseOpenGLSwapchain=true^
 -Dscenery.Renderer.Framelock=true^ 
 -Dscenery.MasterNode=tcp://10.1.2.201:6666^ 
 -Dscenery.ScreenName=%2^ 
 -Dscenery.Renderer.Config=DeferredShadingStereo.yml^ 
 -Dscenery.vr.Active=true^
 org.junit.runner.JUnitCore %1 > S:\%2.log 2>&1
net use S: /delete /yes
\end{lstlisting}

The remote clients can be launched directly from within the IDE, or individually, independently of the master process (e.g., manually from the command line). Initial or resumed connections are possible at any point in time. The program can be designed in two ways: 

1. The local instance on master and clients handle scene construction themselves, or
2. scene construction is handled by the master node, and all changes and additions are communicated over the network to the clients.

Which of the strategies to choose depends on the problem at hand: Fully local initialisation can be beneficial if the data can be loaded from a local source for improved performance, while non-local construction is useful in the case that data can be loaded quickly from a common data source, such as a NAS (network-attached storage), SAN (storage-area network), or cluster file system.

In the future, we would like the extend the network capabilities of scenery in such a way that the remote-launch scripts are not necessary anymore, but a general-purpose client is run on the slave machines which will automatically connect to an active master node. Additionally, the synchronisation modes presented here can be used for networking in general, meaning that remote multi-user environments are also possible with scenery, but have not been explored yet.



