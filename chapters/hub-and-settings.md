# Miscellaneous Subsystems

In this chapter, we will briefly talk about the remaining subsystems of scenery: Hub, Settings, Statistics, and OpenCL contexts: The Hub is the communications backbone of scenery, while the Settings store gathers user- and system-defined settings from various places and makes them available to scenery in a type-safe manner. The Statistics subsystem enables to collect running averages of timings or frame rates, and an OpenCL context can be used to perform general-purpose computation on the CPU or GPU.

## The Hub

All of scenery's subsystems — such as the renderers, input handlers, VR devices, etc. — register with a hub, which is unique to an application. 

A hub can be queried for the presence of a subsystem: Hubs can be queried by `Hub.get(e: SceneryElement)`. This routine will either return the `SceneryElement` is has been asked for, or `null` if that subsystem has not been registered. A `SceneryElement` can be a renderer, OpenCL compute context, statistics collector, node publishers or subscribers, settings storage, and regular or natural input devices. A new `SceneryElement` may be added to a hub via the generic function `<T: Hubable> Hub.add(e: SceneryElement, obj: T)`. `add` will return the object that has been added to the hub.

With this design, it is possible to realise full applications that handle the application logic, rendering, input, and clustering, but also completely headless applications that run only the application logic, but do not produce any visual output, and do not take any input. In this way, we can easily realise minimal unit tests or integration tests that only include the necessary subsystems for the test case at hand, while still enabling communication between the required subsystems.

Furthermore, by implementing the `Hubable` interface, the developer is able to add own subsystems.

## Settings store

scenery uses a simple key-value store for settings. In the key-value store, values are fixed to their initial type once they have been set for the first time during an application run. The settings system allows a bit of leeway in typing: for example, up- and downcasts, e.g. from `float` to `double` and vice-versa are possible, but a warning will be emitted to make it easier for the developer to track down errors, should they occur. This constrained flexibility allows to interoperate with scripting languages that do not exhibit different floating point types, such as JavaScript.

During startup, settings are gathered in the following order:

* configuration files, where the settings are stored in YAML format (by default, `.scenery/[applicationName].conf.yml` in the user's home folder),
* system properties from the command line, e.g. handing the optional flag `-Dscenery.Renderer=OpenGLRenderer` to the JVM on startup will override both scenery's default renderer setting, and the configuration file. System properties starting with `scenery.` are automatically translated to scenery settings, with the scenery setting name being the part after the dot,
* scenery's default settings, usually defined in the interfaces of the various subsystems, such as `Renderer`, which e.g. defines the supersampling factor[^SupersamplingNote] `Renderer.SupersamplingFactor` to be `1.0`.

New settings can be added via `Settings.set(name: String, contents: Any)`, or `Settings.setIfUnset(name: String, contents: Any)` if overwriting an existing setting — which might come from system properties or settings files — is not desired.

Settings can be queried during runtime via `<T> Settings.get(name: String, defaultValue: T? = null)`. The default value, which is optional, can provide a fallback if necessary. If a setting is not found or cannot be cast to the type requested, an exception is emitted.

For inspection, they can be queried as a string via `Settings.list()`, or their names returned as a `List<String>`, via `Settings.getAllSettings()`.

[^SupersamplingNote]: Supersampling refers to a rendering technique where images are rendered larger than necessary and downscaled later on for displaying in order to remove aliasing artifacts.

## Statistics

The Statistics subsystem can be used to collect information on timings or framerates. By default, the renderers use this subsystem to collect the timings of each rendering pass, and of the framerate. For all statistics collected, a running average of the last 100 values is kept.

A new statistic can be added by calling `Statistics.add(name: String, value: Float, isTime: Boolean)`, where `value` is expected to be in nanoseconds, if it is a time value. When `isTime` is false, the values are not converted to milliseconds for displaying. In addition to adding already calculated values, `Statistics.addTimed(name: String, lambda: () -> Any)` can be used to measure the runtime of the `lambda` function invocation, and add that as statistic.

All statistics can be output on the standard output or REPL, by calling `Statistics.log()`:

```
Statistics - avg/min/max/stddev/last
OpenGLRenderer.updateInstanceBuffers   - 0.18/0.11/0.41/0.05/0.19
OpenGLRenderer.updateUBOs              - 0.38/0.24/0.68/0.09/0.33
Renderer.AO.renderTiming               - 0.14/0.08/0.30/0.04/0.15
Renderer.AOBlurH.renderTiming          - 0.11/0.06/1.63/0.16/0.11
Renderer.AOBlurV.renderTiming          - 0.14/0.06/1.83/0.24/0.12
Renderer.DeferredLighting.renderTiming - 0.28/0.15/1.43/0.15/0.40
Renderer.FXAA.renderTiming             - 0.07/0.04/0.17/0.02/0.07
Renderer.ForwardShading.renderTiming   - 0.53/0.30/2.68/0.32/0.55
Renderer.HDR.renderTiming              - 0.10/0.06/0.25/0.03/0.11
Renderer.Scene.renderTiming            - 0.28/0.18/1.81/0.16/0.29
Renderer.fps                           - 25.50/0.00/57.00/25.84/56.00
loop                                   - 0.00/0.00/0.00/0.00/0.00
ticks                                  - 515.50/466.00/565.00/28.87/565.00
```

In this example, all default statistics are shown: the timings of the individual renderpasses (e.g. `Renderer.HDR.renderTiming`), the frame rate `Renderer.fps`, and the timings for UBO and instance buffer updates (all in milliseconds). 

## OpenCL contexts

For general-purpose computations on the GPU, scenery offers access to OpenCL, if supported by either GPU or CPU. OpenCL can be use to do any kinds of computations that are not related to the regular graphics pipeline. In scenery, we use an OpenCL context (in the class `OpenCLContext`) for example to generate signed distance fields[^DistanceFieldNote] for high-quality font rendering [@Green:2007Improved; @Chlumsky:2015Shape]. This technique requires high-resolution distance fields for each glyph of the font, which is subsequently downsampled and stored in an atlas for later access. This distance field can then be very efficiently sampled in a shader to find the (anti-aliased) outline of the font without storing the font as texture at different resolutions. For an example rendering, see \cref{fig:sdf}.

\begin{figure*}
    \includegraphics{sdf_fixed.png}
    \caption{Font in scenery rendered from a signed distance field font atlas generated via an OpenCL kernel. Note that the per-glyph distance field only has a size 64x64 pixels maximum, and the rendered resolution in this case is already 160 pixels in glyph height. For details, see text.\label{fig:sdf}}
\end{figure*}

The creation of the distance fields of a glyph is quite simple and serves here as an example how to use an OpenCLContext. The abridged code showing the most important parts for this process is shown in \cref{lst:OpenCLContextExample}. For full code, see the `SDFFontAtlas` class in scenery (in directory `src/main/kotlin/graphics/scenery/fonts`), and the `DistanceTransform.cl` (in directory `src/main/resources/graphics/scenery/fonts`) for the OpenCL kernel code.

\begin{lstlisting}[language=Kotlin, caption={OpenCL context usage example.}, label=lst:OpenCLContextExample]
// resolution of high-res distance field in pixels
val distanceFieldSize = 512
// create OpenCL context
val context = OpenCLContext()
// generate image of P character in given font, returns pair of
// character width and generated image byte buffer
val character = genCharImage("P", font, distanceFieldSize)

// wrap the byte buffer returned from genCharImage
// such that OpenCL can read it
val input = context.wrapInput(character.second)
// create an output buffer to store the distance field
val outputBuffer = ByteBuffer.allocate(distanceFieldSize * distanceFieldSize)
// wrap the output byte buffer such that OpenCL can
// write to it
val output = context.wrapOutput(outputBuffer)

// load the signed distance field kernel
// and run it
context.loadKernel(kernelResource, "SignedDistanceTransformUnsignedByte")
    .runKernel("SignedDistanceTransformUnsignedByte",
    distanceFieldSize * distanceFieldSize,
    input,
    output,
    distanceFieldSize,
    distanceFieldSize,
    maxDistance)
    
// read the result back into outputBuffer
context.readBuffer(output, outputBuffer)
\end{lstlisting}

[^DistanceFieldNote]: A distance field of a binary image stores the distance to the next border between foreground (white) and background (black). A signed distance field stores the signed distance, where (depending on convention) positive means inside, and negative means outside.


