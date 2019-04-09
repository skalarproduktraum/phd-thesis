# Input Handling and Integration of External Hardware

## Input Handling

Input handling is done using using Tobias Pietzsch's _ui-behaviour_ library \TODO{Cite!}. This library provides a distinction of input events into `InputTriggers` and `Behaviours`. An `InputTrigger` is the related to the physical event, such as a key press, or a mouse movement/scroll/click. A `Behaviour` is the triggered action. Vanilla ui-behaviour is able to handle AWT input events. For scenery, we have extended the library to also be able to handle events originating from JOGL, GLFW, JavaFX, or headless windows. Further, custom mappings are available for buttons of hand-held controller devices, or VRPN devices.

Spatial input, such as HMD positioning and rotations, are handled by the specific implementation of a `TrackerInput`, such as an `OpenVRHMD`[^openvrnote], or a `VRPNTracker`[^vrpnnote]. Multiple of these inputs can coexist peacefully, and will not interfere with each other, but rather augment.

[^openvrnote]: OpenVR or SteamVR is a VR abstraction layer that provides rendering to various VR headsets, and access to the associated input devices. OpenVR has been developed by Valve Software, more information can be found at [github.com/ValveSoftware/OpenVR](https://github.com/ValveSoftware/OpenVR).

[^vrpnnote]: VRPN (Virtual Reality Periphery Network) is an abstraction layer that enables access to a variety of Virtual Reality-associated input devices, such as tracked stereo glasses, Wiimotes or Flysticks. See [@TaylorII:2001bq].

## Head-mounted displays and natural/gestural user interface devices

Support for head-mounted displays and control devices is provided by two means:

1. utilising the lwjgl bindings for SteamVR/OpenVR to interface with off-the-shelf HMDs like the Oculus Rift or HTC Vive (see class `OpenVRHMD`).
2. utilising the custom-built wrappers for the VRPN[@TaylorII:2001bq], the Virtual Reality Periphery Network, library, called jVRPN ([github.com/scenerygraphics/jvrpn](https://github.com/scenerygraphics/jvrpn)). jVRPN is used in scenery to e.g. provide support for DTrack devices used in CAVE systems (see class `TrackedStereoGlasses`).

HMDs usually implement the `Display` interface:
```
interface Display {
    fun getEyeProjection(eye: Int, nearPlane: Float = 1.0f, farPlane: Float = 1000.0f): GLMatrix
    fun getIPD(): Float
    fun hasCompositor(): Boolean
    fun submitToCompositor(textureId: Int)
    fun submitToCompositorVulkan(width: Int, height: Int, format: Int,
                                 instance: VkInstance, device: VulkanDevice,
                                 queue: VkQueue,
                                 image: Long)
    fun getRenderTargetSize(): GLVector
    fun initializedAndWorking(): Boolean
    fun update()
    fun getVulkanInstanceExtensions(): List<String>
    fun getVulkanDeviceExtensions(physicalDevice: VkPhysicalDevice): List<String>
    fun getWorkingDisplay(): Display?
    fun getHeadToEyeTransform(eye: Int): GLMatrix
}
```

This interface provides submission to both OpenGL and Vulkan renderers, which is necessary as they work quite differently. The `update` function is used to update HMD state once per frame, while transformations are cached as much as possible. The renderer will only render to the device if `initializedAndWorking()` returns `true`, and `getWorkingDisplay()` returns a `Display` instance. HMDs can choose to have a compositor to which the resulting renderered image is submitted. If this is not the case, e.g. as it is with tracked stereo glasses for CAVEs, the image is rendered regularly.

An HMD might also provide tracking information, in which case it will also implement the `TrackerInput` interface:

```
interface TrackerInput {
   
    fun getOrientation(): Quaternion
    fun getOrientation(id: String): Quaternion
    fun getPosition(): GLVector
    fun getPose(): GLMatrix
    fun getPoseForEye(eye: Int): GLMatrix
    fun initializedAndWorking(): Boolean
    fun update()
    fun getWorkingTracker(): TrackerInput?
    fun loadModelForMesh(device: TrackedDevice, mesh: Mesh): Mesh
    fun loadModelForMesh(type: TrackedDeviceType = TrackedDeviceType.Controller, mesh: Mesh): Mesh
    fun attachToNode(device: TrackedDevice, node: Node, camera: Camera? = null)
    fun getTrackedDevices(ofType: TrackedDeviceType): Map<String, TrackedDevice>
}
```

In this interface, the noteworthy functions are `getPoseForEye()`, which returns a transformation matrix relative to the origin containing translational and rotational information per-eye. Furthermore, an HMD may provide multiple tracked devices, such as nunchucks, which can be queried via `getTrackedDevices()`. `attachToNode()` then facilitates their attachment to any `Node` in the scene graph, which subsequently inherits the transformations of the tracked device. A model for such a device may be provided by the HMD via `loadModelForMesh()`. Our implementation of SteamVR HMDs provides the correct mesh for a given HMD via this function.


## Augmented Reality and the Hololens

_scenery_ also includes support for the Microsoft Hololens, a stand-alone, untethered augmented reality headset, based on the Universal Windows Platform (see class `Hololens`). The Hololens includes its own CPU and GPU, due to size constraints they are however not very powerful, and especially if it comes to rendering of volumetric datasets, completely underpowered.

To get around this issue, we have developed a thin, Direct3D-based client application for the Hololens that makes use of Hololens Remoting, a kind of proprietary streaming protocol developed by Microsoft[^remotingnote]. This client receives pose data from the Hololens, as well as all other parameters required to generate correct images, such as the projection matrices for each eye. This data is then forwarded to a Hololens interface within scenery, based on the regular HMD interface. Initial communication to acquire rendering parameters is done via a ZeroMQ request-reply socket, while receiving of per-frame pose data is handled with an additional, publish-subscribe socket due to better latency.

The Hololens remoting applications are usually fed by data rendered with Direct3D, which lets us immediately recognise the problem that _scenery_ can only render via OpenGL and Vulkan at the present moment. 

Fortunately, a shared memory extension for Vulkan, `NV_external_memory`, exists in the standard that enables _zero-copy_ sharing of buffer data between different graphics APIs, by using a keyed mutex. Programmatically, this is done as:

1. On the host (_scenery_) side, verify that the device supports this type of Direct3D texture for importing.
2. For each swapchain image, allocate a Direct3D shared handle texture with flag `D3D11_RESOURCE_MISC_SHARED_KEYEDMUTEX` on the side of the client application. This image will serve as the final render target to be sent to the Hololens[^sharedperfnote].
3. For each shared handle, create a Vulkan image, with memory bound to the shared handle.
4. Request access to the image via the keyed mutex, and store image data in it, e.g. via `vkCmdBlitImage`. Keyed mutex handling is done by the extension itself, via extra information attached to the appropriate `vkQueueSubmit` call. The command buffer for the blit operation needs to be recorded only once and can be reused as long the resolution does not change.

The inclusion of the keyed mutex information into the `vkQueueSubmit` call in the last step has the benefit that no additional network communication via ZeroMQ is necessary to indicate by which part of the software the shared texture is used at the moment, leading to increased performance.

[^remotingnote]: The exact details of how this works are not published, but apparently work by streaming the image data for both eyes over the network, compressed with H264.
[^sharedperfnote]: We allocate multiple image buffers and use them in a double/triple-buffering manner for read/write access to prevent the GPU stalling.

## Eye Tracking

scenery includes support for the Pupil Labs eye tracking solution[@Kassner:2014kh]([www.pupil-labs.com](https://www.pupil-labs.com)), implemented in the class `PupilEyeTracker`. This class communicates with the Pupil Labs software _Pupil Capture_ or _Pupil Service_ via ZeroMQ, with msgpack data serialisation. Our implementation provides HMD-based screen-space and world-space calibration, reporting of the gaze positions, normals, timestamps, and confidences.

For calibration, the user is presented with a series of points to look at, which serve to establish a connection between the eye tracker's captured direction of gaze with a screen-space or world-space position in the scene. For each calibration point, 80 different samples are taken to account for microsaccades, and the first 20 are discarded to exclude those samples that might still include eye movement, while the user is moving from one point to the next. After finishing the calibration, the user is informed of successful or unsuccessful calibration, and can repeat the calibration, if necessary.

After successful calibration, scenery enables the developer to connect the outputs of the eye tracker (in the form of gaze normals, gaze positions, and a confidence rating) to the properties of any object. By default, gaze points are only output in case the confidence reaches more than 90%, leaving the decision which of the higher-confidence samples to use to the developer.

More details about eye tracking can be found in the chapter [Eye Tracking and Gaze-based Interaction], with a use case implemented in the chapter [Attentive Tracking].



