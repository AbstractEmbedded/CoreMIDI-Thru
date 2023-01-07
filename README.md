<div>
<img align="left" src="https://github.com/3rdGen-Media/CoreMIDI-Thru/blob/master/Resources/Assets/AppIcon/Logo1024x1024.png" width="128">
<h1>CoreMIDI Thru</h1>
</div>
    
CoreMIDI Thru is a companion app to [MIDI Studio](https://support.apple.com/en-nz/guide/audio-midi-setup/ams875bae1e0/3.5/mac/13.0) for creating and managing CoreMIDI Server Persistent Thru Connections to ensure lowest MIDI packet jitter and transport latency from CoreMIDI device driver to DAW application. 

For demanding scenarios such as live mixing and monitoring of externally triggered audio with AU/VST plugin triggered audio in a high sample rate and low buffer size environment it addresses audibly perceivable sample alignment degradation exhibited when a client [DAW] application attempts to read MIDI from two or more MIDI devices by exposing the capability to have the system route incoming MIDI from multiple hardware devices to a single virtual device (e.g. the IAC Driver Bus).

<img align="center" src="https://github.com/3rdGen-Media/CoreMIDI-Thru/blob/master/Resources/Images/MainWindow.png">

## About Thru Connections

<h4>Client-Server IPC</h3>

When a manufacturer creates a hardware MIDI (USB) device they have the option to interface their firmware with the Apple provided CoreMIDI USB driver (Generic) or a driver they develop in-house (Vendor).  Either way these drivers are required to register themselves with and pass their incoming MIDI data to the CoreMIDI Server application running discreetly on your system.  The CoreMIDI server is responsible for then passing that MIDI data on to the CoreMIDI client apps such as a standalone audio app or an AU/VST plugin running within a DAW. 

The CoreMIDI server uses an Interprocess Communication (IPC) mechanism provided by the kernel known as [Mach Messaging](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/KernelProgramming/Mach/Mach.html#//apple_ref/doc/uid/TP30000905-CH209-CEGJEIAG) to communicate with client applications that register with the server to send/receive MIDI packets to/from specified device/port combinations exposed via the CoreMIDI API.  In short, while Mach messages achieve what they were designed to accomplish in kernel space they are a terrible choice for soft realtime client applications operating on a deadline wherein these messages have to cross the user-kernel divide.  Tens of thousands of these messages are sent between kernel processes and other userspace processes every second. The system can deprioritize those it deems less important at will compared to an API like CoreAudio which is always prioritized and guarantees throughput/latencies between software and hardware will always be met.  Beyond that the API dicates that client applications are forced to interlude such communication via the main thread's CFRunloop only.  Overstressing these clunky mach depedendent CoreMIDI client-server communication channels is the leading cause of unnecessary jitter, latency and relative scheduling error throughout the entire pipeline.    

<h4>Thru Connection API</h4>

Realizing this - instead of redesigning the CoreMIDI Server application and Client API - Apple introduced the [CoreMIDI Thru Connection API](https://developer.apple.com/documentation/coremidi/midi_thru_connection?language=objc) to allow client apps to instruct the server to create and maintain persistent pass-through for device/port combinations registered with the CoreMIDI server.  Cool, this allows combining two or more device inputs to a single virtual device that a client app can read from/write to.  Our options for such a virtual device are to create a driver that exposes one or create a client app that registers one via the CoreMIDI API - the latter with the disadvantage that the virtual device will not be persistent when the client app that created it is not running.  Luckily, Apple has provided such a driver for us and users can [create virtual "bus" devices owned by the Interapp Communication (IAC) Driver via MIDI Studio](https://support.apple.com/en-nz/guide/audio-midi-setup/ams1013/3.5/mac/13.1).

... but how do we create a Thru Connection to the IAC bus we exposed in MIDI Studio?  Apple seems to have inexplicably left this out.             

<h4>Best Practices</h4>

Since our client DAW application can't avoid using the mach message based IPC to obtain MIDI packets we can't avoid the latency and jitter incurred by this pipeline entirely but we can minimize the load associated with respect to the DAW's main runloop and the work the server is doing to fulfill such mach based requests by making it the only CoreMIDI client app registered with the server and aggregating our desired external hardware input device streams to a single IAC bus for the DAW to read from.

<h4>AudioUnit Devices</h4>

Recently Apple has allowed AudioUnit plugins to expose themselves as virtual MIDI-generating *input* devices to CoreMIDI but not as *output* devices.  You can use this app to create Thru Connections with them.  If Apple were to allow AU plugins to expose themselves as output devices then a Thru Connection could be made directly to the plugin bypassing the use of the virtual IAC Bus device and hopefully allaying the burden of processing all incoming MIDI on the DAW's main thread runloop.   

<h4>Thru Connection Mappings & Packet Translation</h4>

The CoreMIDI Thru Connection API allows for trivial 1-in, 1-out transformations of noteNumber, velocity, keyPressure, channelPressure, programChange, pitchBend and controlChange.  However, given that this simple API is not suitable for transforming note values based on observed CC messages it is of limited use to me so I have decided to forgo the extra work to expose a UI for Thru Connection mappings.  

Having an intermediate client app perform translation, of course, defeats the purpose of using a Thru Connection.  Best practice is to just send the correct MIDI from your external device and avoid translation altogether. Future efforts may involve writing a driver that exposes a virtual device whose traffic I can operate on despite that having the destination audio plugin directly translate messages on receipt would be a less invasive route in that it would not involve interjecting to hold up and process MIDI data. 

## Frequently Asked Questions

- [I already use client application X that allows traffic from multiple MIDI devices to be routed to a single virtual port and there are tons of them available.  Why would I need to use this?](#Question1)
- [Why am I experiencing greater latency and worse timing accuracy when using a Thru Connection than when receiving directly from a single device in my DAW?](#Question2)
- [This seems trivial.  Given that the CoreMIDI Thru Connection API has been around since OSX 10.2 how is it that this was missed by every other CoreMIDI client app?](#Question3)


<a name="Question1"/></a>
#### I already use client application X that allows traffic from multiple MIDI devices to be routed to a single virtual port and there are tons of them available.  Why would I need to use this?

I personally have been using the paid/pro version of [Bome Midi Translator](https://www.bome.com/products/miditranslator) for several years.  It is a very functional app.  It allows creation of non-persistent virtual devices, monitoring on all enabled devices and the ability to "create MIDI Thru Connections".  Specifically, its advanced filtering capabilities based on recorded variables and rulesets allow for creation of mini programs such as tracking hi-hat open/close CC such that when the hi-hat is struck it outputs the corresponding MIDI note value for open or closed.  This app can't possibly be creating true CoreMIDI Server Thru Connections, though, or it would not be able to interrupt those messages in favor of its custom rulesets.  

It is always possible that an app that does monitoring may have been built as a custom driver with a UI in front ([SnoizeMIDISpy](https://github.com/krevis/MIDIApps)). However, even when I am not filtering and connections are just passed through I experience the same perceivable degradation when receiving from multiple devices in Logic Pro X and so have stopped using Bome.  My advice is to be weary of this inexactness of language and try to verify if you can.  

This app promises doubt-free CoreMIDI Server Persistent Thru Connections.

<a name="Question2"/></a>
#### Why am I experiencing greater latency and worse timing accuracy when using a Thru Connection than when receiving directly from a single device in my DAW?

This is the expected behavior.  If you have only one device stream being fed directly from Device Driver->CoreMIDI Server->DAW your pipeline is already optimized.  Thru Connections are most useful when you wish to trigger from 2 or more devices to an audio plugin running in your DAW. Sending through an IAC Driver device WILL ALWAYS increase latency over not doing so as a trade-off for the benefit of improving relative timing accuracy by minimizing jitter + latency incurred when aggregating multi-device traffic via the DAW's main runloop.  You can adjust for the latency incurred by passing through the IAC bus by applying a negative latency delay on the device stream if your DAW exposes such a feature.   

<a name="Question3"/></a>
#### This seems trivial.  Given that the CoreMIDI Thru Connection API has been around since OSX 10.2 how is it that this was missed by every other CoreMIDI client app?

You are correct it is trivial!  This really should be exposed directly in MIDI Studio.  The [official documentation](https://support.apple.com/en-nz/guide/audio-midi-setup/ams875bae1e0/3.5/mac/13.0) reads:

*"You can’t specify a “MIDI thru” connection between two MIDI devices. To indicate a MIDI thru connection, connect the two MIDI devices to the same port of the MIDI interface device."*

Despite this being very poorly written it does appear to be possible to create Thru Connections between hardware devices by virtue of creating an intermediate "external device" albeit in an extremely unintuitive fashion.  However, this is the least useful case.  Thru Connections cannot be created between hardware devices and the IAC driver nor between AudioUnit and devices as needed.  

Here are some additional observations on why this feature may currently be overlooked by devs and pro audio users:

- It wasn't until I recently moved to M1 hardware from an older Intel Macbook Pro that I had enough processing headroom reported by Logic Pro X to realize that this was not about load but a symptom of the IPC mechanism.[^1]
- Of the popular third party wrapper libraries used by others to build CoreMIDI and even CoreAudio apps none of them use the Thru Connection API.[^2]
- I couldn't find any projects on github with a call to MIDIThruConnectionCreate that actively worked. Separately, many apps that claim to do virtual pass through do not use the Thru Connection API and miss the point by passing messages through the client.[^3] 
- A significant number of others have reported trouble getting the Thru Connection API to pass through packets.  Non-persistent Thru Connections are in fact broken.  While I did experience these initial pangs at first it could be that the issue manifests for those using Swift bindings, the API has been modified from its previous usage and/or they are just not reading the specification closely enough.[^4]

[^1]: TO DO:  How does one determine if a client application runloop is running on a P-Core vs an E-Core?
[^2]: [PortMidi](https://github.com/PortMidi/portmidi), [AudioKit](https://github.com/AudioKit/AudioKit), [MIDIKit](https://github.com/orchetect/MIDIKit) (*latter has ThruConnection but reports bug in Big Sur onward)
[^3]: [Swift2MIDI](https://github.com/genedelisa/Swift2MIDI), [Gong](https://github.com/dclelland/Gong)
[^4]: [StackOverflow 1](https://stackoverflow.com/questions/54871326/how-is-a-coremidi-thru-connection-made-in-swift-4-2), [Stack Overflow 2](https://stackoverflow.com/questions/15141810/midithruconnectioncreate-xcode), [Stack Overflow 3](https://stackoverflow.com/questions/14825371/how-to-monitor-outgoing-midi-messages-in-coremidi), [Stack Overflow 4](https://www.appsloveworld.com/swift/100/138/midithruconnectioncreate-always-creates-persistent-midi-thru-connection)
