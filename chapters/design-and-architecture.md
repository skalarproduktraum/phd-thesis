# Design and Architecture



## The Nodes

Nodes are the central part of scenery and represent all the entities that can be rendered on-screen. These nodes are organised into an ordered, acyclic graph of parent-child relationships. Operations, such as mathematical transformations -- such as translations, rotations, or scalings -- are automatically propagated to a `Node`s `children`. This way of organising scene contents is called a _scene graph_ and is a standard way in computer graphics to organise scenes hierarchically by their relationship with each other. 

For actually organising nodes into a scene, a special node type exists, the `Scene`. `Node`s attached to a top-level `Scene` element as `children` become the top-level elements of the scene, and can in turn have their own `children`.

As a short example, a `Scene` might contain a `Node` _Cell_, which has children _Nucleus_ and _ER_. The transformations of _Nucleus_ and _ER_ are then relative to _Cell_, and when the _Cell_ moves, so will _Nucleus_ and _ER_.

### Transforms

A `Node` can have the following transforms:

* `position` -- the position of the `Node` in 3D space
* `scale` -- scaling along the X, Y, and Z axis
* `rotation` -- a quaternion[^quatnote] describing the `Node`s orientation in space.
* `model` -- local transforms how this `Node` is positioned with respect so its parent
* `world` -- global transforms that include the `model` transform, as well as the `parent`s `world` transform

The transforms are calculated by a `Node`s `updateWorld(recursive: Boolean, force: Boolean)` routine, and stored to the `model` and `world` properties. If `recursive` is specified, the routine will descend to all children, calculate their transforms, and mark them as updated. If any of the transforms of a `Node` change during runtime, it will get its `needsUpdate` and `needsUpdateWorld` flag set, to be picked up on the next update run.

[^quatnote]: Quaternions are a 4-dimensional extension of complex numbers, that can also describe rotations in space. While rotations may as well be represented as matrices, such representations suffer from two problems: a) they cannot be smoothly interpolated and b) they may lead to _gimbal locking_, where the sine or cosine of an angle in a rotation matrix lead to a zero entry, making the transformation loose a degree of freedom. Quaternions are free of both problems, they are however not as intuitive as e.g. Euler angles. In scenery, helper routines are provided to convert Euler angles and matrices to quaternions for user convenience.

## The Renderers

The renderers...



### Mapping between the Virtual Machine and shaders

spirvcrossj enables...

### Configurable Rendering Pipelines

With YAML files, we can ...



## Input Handling

Input handling is done using...



## The Hub

The hub is the main central of...



## Settings store

Settings are stored...



## External hardware -- Head-mounted displays

HMD support is provided by SteamVR...



## External hardware -- Augmented Reality and the Hololens

_scenery_ also includes support for the Microsoft Hololens, a stand-alone, untethered augmented reality headset, based on the Universal Windows Platform. The Hololens includes its own CPU and GPU, due to size constraints they are however not very powerful, and especially if it comes to rendering of volumetric datasets, completely underpowered.

To get around this issue, we have developed a thin, Direct3D-based client application for the Hololens that makes use of Hololens Remoting, a kind of proprietary streaming protocol developed by Microsoft[^remotingnote]. This client receives pose data from the Hololens, as well as all other parameters required to generate correct images, such as the projection matrices for each eye. This data is then forwarded to a Hololens interface within scenery, based on the regular HMD interface. Initial communication to acquire rendering parameters is done via a ZeroMQ publish-subscribe socket, as is receiving of per-frame pose data.

The Hololens remoting applications are usually fed by data rendered with Direct3D, which lets us immediately recognise the problem that _scenery_ can only render via OpenGL and Vulkan at the present moment. Fortunately, a shared memory extension for Vulkan, `NV_external_memory`, exists in the standard that enables `zero-copy` sharing of buffer data between different graphics APIs, by using a keyed mutex. Programmatically, this is done as:

1. Allocate a Direct3D shared handle texture with flag `D3D11_RESOURCE_MISC_SHARED_KEYEDMUTEX` on the side of the client application. This application will serve as the final render target.[^sharedperfnote]
2. On the host (_scenery_) side, verify that the device supports this type of Direct3D texture for importing.
3. Create a Vulkan image, with memory bound to the shared handle.
4. Request access to the image via the keyed mutex, and store image data in it, e.g. via `vkCmdBlitImage`. Keyed mutex handling is done by the extension itself, via extra information attached to the appropriate `vkQueueSubmit` call.

The inclusion of the keyed mutex information into the `vkQueueSubmit` call in the last step has the benefit that no additional network communication via ZeroMQ is necessary to indicate by which part of the software the shared texture is used at the moment, leading to increased performance.

[^remotingnote]: The exact details of how this works are not published, but apparently work by streaming the image data for both eyes over the network, compressed with H264.
[^sharedperfnote]: In a production application, multiple image buffers should be allocated and used in a double/triple-buffering manner for read/write access to prevent the GPU stalling.

## External Hardware -- Eye Tracking

Eye tracking support is provided by ...