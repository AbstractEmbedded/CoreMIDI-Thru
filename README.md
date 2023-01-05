<div>
<img align="left" src="https://github.com/3rdGen-Media/CoreMIDI-Thru/blob/master/Resources/Assets/AppIcon/Logo1024x1024.png" width="100">
<h2>CoreMIDI Thru</h2>
</div>
    
CoreMIDI Thru is a companion app to [MIDI Studio] for creating and managing CoreMIDI Server Persistent Thru Connections to ensure lowest latency and jitter transport of MIDI packets fom CoreMIDI device driver to DAW application. 

For demanding scenarios such as live mixing and monitoring of externally triggered audio with AU/VST plugin triggered audio in a high sample rates and low buffer size environment it addresses the perceivable degradation exhibited when a client [DAW] application attempts to read MIDI from two or more MIDI devices by exposing the capability to have the system route incoming MIDI from multiple hardware devices to a single virtual device (e.g. the IAC Driver Bus).

<img align="center" src="https://github.com/3rdGen-Media/CoreMIDI-Thru/blob/master/Resources/Images/MainWindow.png">

<h3>About CoreMIDI Thru Connections</h3>

<h4>Client-Server IPC</h3>

When a manufacturer creates a hardware MIDI (USB) device they have the option to interface their firmware with the Apple provided CoreMIDI USB driver (Generic) or a driver they develop in-house (Vendor).  Either way these drivers are required to register themselves with and pass their incoming MIDI data to the CoreMIDI Server application running discreetly on your system.  The CoreMIDI server is responsible for then passing that MIDI data on to the CoreMIDI client apps such as a standalone music app or an AU/VST plugin running within a DAW. 

The CoreMIDI server uses an Interprocess Communication (IPC) mechanism provided by the kernel known as "Mach Messaging" to communicate with client applications that register with the server to send/receive MIDI packets to/from specified device/port combinations exposed via the CoreMIDI API.  In short, while Mach messages may perform better in kernel space they are a terrible choice for soft realtime client applications operating on a deadline wherein these messages have to cross the user-kernel divide.  Beyond that the API dicates that client applications are forced to interlude such communication via the main thread's CFRunloop only.  Overstressing these mach based CoreMIDI client-server connections is the #1 cause of unnecessary latency and jitter in the entire pipeline.    

<h4>Thru Connection API</h4>

Realizing this -- instead of redesigning the CoreMIDI server application and API -- Apple introduced the [CoreMIDI Thru Connection API] to allow client apps to instruct the server to create and maintain persistent pass-through for device/port combinations registered with the CoreMIDI server.  Cool, this will allow combining two or more device inputs to a single virtual device that a client app can read from/write to.  Our options for such a virtual device are to create a driver that exposes one or create a client app that registers one via the CoreMIDI API -- the latter with the disadvantage that virtual device will not be persistent when the client app that created it is not running.  Luckily, Apple has provided such a driver for us and users can create virtual "busses" on the Interapp Communication (IAC) device via MIDI Studio.  

Wait... but how do we create a Thru Connection to the IAC bus we exposed in MIDI Studio?  Apple seems to have inexplicably left this out.             

<h4>Best Practices</h4>

Since our client DAW application can't avoid using the mach message based IPC to obtain MIDI packets we can't avoid the latency and jitter incurred by this pipeline entirely but we can minimize the load associated with respect to the DAW's main runloop and the work the server is doing to fulfill such mach based requests by making it the only CoreMIDI client app registered with the server and aggregating our desired external hardware input devices to a single IAC bus for the DAW to read from.

<h4>AU Plugin Devices</h4>

Recently, Apple has allowed AU plugins to expose themselves as virtual MIDI generating output devices to Core MIDI, but not as input devices.  If Apple were to allow AU plugins to expose themselves as input then the Thru Connection could be made directly bypassing the use of the virtual IAC Bus device and the burden hopefully removed from the DAW's main run loop.   

<h4>About Thru Mapping</h4>


## Frequently Asked Questions

- [I already use client application X that allows traffic from multiple MIDI devices to be routed to a single virtual port and there are tons of them available.  Why would I need to use this?](#why-would-i-need-to-use-this)
- [This seems trivial.  Given that the CoreMIDI Thru Connection API has been around since OSX 10.2 how is it that this was missed by every other CoreMIDI client app?](#Isnt-this-trivial)

#### I already use client application X that allows traffic from multiple MIDI devices to be routed to a single virtual port and there are tons of them available.  Why would I need to use this?

I personally have been using the paid/pro version of [Bome Midi Translator](https://www.bome.com/products/miditranslator) for several years.  It is a very functional app.  It allows creation of non-persistent virtual devices, monitoring on all enabled devices and the ability to "create MIDI Thru Connections".  Specifically, it's advanced filtering capabilities allow creation of mini programs (e.g. tracking hi-hat open/close CC such that when the hi-hat is struck it outputs the corresponding MIDI not value for open or closed).  This app can't possibly be creating true CoreMIDI Server Thru Connections, though, or it would not be able to interrupt those messages in favor of its custom rulesets.  

It is always possible that an app that does monitoring may have been built as a custom driver with a UI in front (e.g. [MIDIMonitor/SnoizeMIDISpy](https://github.com/krevis/MIDIApps)). However, even when I am not filtering and connections are just passed through I experience the same perceivable degradation when receiving from multiple devices in Logic Pro X and so have stopped using Bome.  My advice is to be weary of this inexactness of language and try to verify if you can.  This app promises doubt-free CoreMIDI Server Persistent Thru Connections.


#### This seems trivial.  Given that the CoreMIDI Thru Connection API has been around since OSX 10.2 how is it that this was missed by every other CoreMIDI client app?

You are correct it is trivial! My thoughts on why this might be the case: 

- This really should be exposed directly in MIDI Studio.  Shame on Apple.  
- It wasn't until I recently moved to M1 hardware from an older intel based MBP that I had enough processing headroom reported by Logic Pro X to realize that this was not about load but a symptom of the IPC mechanism.    
- Of the popular 3rd party wrapper libraries that devs seem to use to build CoreMIDI and even CoreAudio apps none of them use the Thru Connection API.[^1]
- I couldn't find any projects on github with a call to MIDIThruConnectionCreate that worked and apps that claim to do virtual pass through always miss the point by passing messages through the client.[^2] 
-  A significant number of others have reported trouble getting the Thru Connection API to pass through packets.  Non-persistent Thru Connections are in fact broken.  While I did experience these initial pangs at first it may be they just weren't trying hard enough.[^3]

[^1]: [PortMidi](https://github.com/PortMidi/portmidi), [AudioKit](https://github.com/AudioKit/AudioKit), [MIDIKit](https://github.com/orchetect/MIDIKit) (latter has ThruConnection but claims bug in Big Sur onward)
[^2]: [Swift2MIDI](https://github.com/genedelisa/Swift2MIDI), [Gong](https://github.com/dclelland/Gong)
[^3]: [StackOverflow 1](https://stackoverflow.com/questions/54871326/how-is-a-coremidi-thru-connection-made-in-swift-4-2), [Stack Overflow 2](https://stackoverflow.com/questions/15141810/midithruconnectioncreate-xcode), [Stack Overflow 3](https://stackoverflow.com/questions/14825371/how-to-monitor-outgoing-midi-messages-in-coremidi), [Stack Overflow 4](https://www.appsloveworld.com/swift/100/138/midithruconnectioncreate-always-creates-persistent-midi-thru-connection)
