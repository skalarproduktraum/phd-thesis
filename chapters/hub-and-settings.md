# Hub and Settings

In this chapter, we will briefly talk about the Hub and Settings systems of scenery: The Hub is the communications backbone of scenery, while the Settings store gathers user- and system-defined settings from various places and makes them available to the scenery in a type-safe manner.

## The Hub

All of scenery's subsystems — such as the renderers, input handlers, VR devices, etc. — register with a hub, which is unique to an application. 

A hub can be queried for the presence of a subsystem: Hubs can be queried by `Hub.get(e: SceneryElement)`. This routine will either return the `SceneryElement` is has been asked for, or `null` if that subsystem has not been registered. A `SceneryElement` can be a renderer, OpenCL compute context, statistics collector, node publishers or subscribers, settings storage, and regular or natural input devices. A new `SceneryElement` may be added to a hub via the generic function `<T: Hubable> Hub.add(e: SceneryElement, obj: T)`. `add` will return the object that has been added to the hub.

With this design, it is possible to realise full applications that handle the application logic, rendering, input, and clustering, but also completely headless applications that run only the application logic, but do not produce any visual output, and do not take any input. In this way, we can easily realise minimal unit tests or integration tests that only include the necessary subsystems for the test case at hand, while still enabling communication between the required subsystems.

## Settings store

scenery uses a simple key-value store for settings store. In the key-value store, values are fixed to their initial type once they have been set for the first time during an application run. The settings system allows a bit of leeway in typing: for example, up- and downcasts, e.g. from `float` to `double` and vice-versa are possible, but a warning will be emitted to make it easier for the developer to track down errors, should they occur. This constrained flexibility allows to interoperate with scripting languages that do not exhibit different floating point types, such as JavaScript.

During startup, settings are gathered in the following order:

* configuration files, where the settings are stored in YAML format (by default, `.scenery/[applicationName].conf.yml` in the user's home folder),
* system properties from the command line, e.g. defining `-Dscenery.Renderer=OpenGLRenderer` will override both scenery's default renderer setting, and the configuration file. System properties starting with `scenery.` are automatically translated to scenery settings, with the scenery setting name being the part after the dot,
* scenery's default settings, usually defined in the interfaces of the various subsystems, such as `Renderer`, which e.g. defines the supersampling factor[^SupersamplingNote] `Renderer.SupersamplingFactor` to be `1.0`.

New settings can be added via `Settings.set(name: String, contents: Any)`, or `Settings.setIfUnset(name: String, contents: Any)` if overwriting an existing setting — which might come from system properties or settings files — is not desired.

Settings can be queried during runtime via `<T> Settings.get(name: String, defaultValue: T? = null)`. The default value, which is optional, can provide a fallback if necessary. If a setting is not found or cannot be cast to the type requested, an exception is emitted.

[^SupersamplingNote]: Supersampling refers to a rendering technique where images are rendered larger than necessary and downscaled later on for displaying in order to remove aliasing artifacts.


