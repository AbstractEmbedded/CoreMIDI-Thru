//
//  CMAppInterface.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/27/22.
//

#ifndef CMAppInterface_h
#define CMAppInterface_h

#if defined(__APPLE__)
#include <TargetConditionals.h>

#include <CoreFoundation/CoreFoundation.h>           //Core Foundation
#include <objc/runtime.h>                            //objective-c runtime
#include <objc/message.h>                            //objective-c runtime message

#include <CoreServices/CoreServices.h>               //Core Services
#include <CoreMIDI/MIDIServices.h>                   //Core Midi
#include <CoreAudio/HostTime.h>                      //Core Audio
#include <libkern/OSAtomic.h>                        //libkern

#if TARGET_OS_OSX
#include <ApplicationServices/ApplicationServices.h> //Cocoa
#endif
#endif


#pragma mark -- Platform Obj-C Headers

#if defined(__APPLE__) && defined(__OBJC__)  //APPLE w/ Objective-C Main
#if TARGET_OS_OSX           //MAC OSX
#import  <AppKit/AppKit.h>
#else                       //IOS + TVOS
#import  <UIKit/UIKit.h>
#endif
#endif

#pragma mark -- Standard C Headers

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "float.h"
#include "limits.h"

#include <unistd.h>


#pragma mark -- Application Obj-C Headers

#if defined(__APPLE__) && defined(__OBJC__)  //APPLE w/ Objective-C Main
#import "CMThruApplication.h"
#import "CMThruApplicationDelegate.h"
#endif


#pragma mark -- Application 3rd Party Headers

/*
#ifdef __cplusplus //|| defined(__OBJC__)
//CoreTransport CXURL and CXReQL C++ APIs use CTransport (CTConnection) API internally
#include <CoreTransport/CXURL.h>
#include <CoreTransport/CXReQL.h>
#elif defined(__OBJC__)
#include <CoreTransport/NSTURL.h>
#include <CoreTransport/NSTReQL.h>
#else
#include "CoreTransport/CTransport.h"
#endif
*/
#include "CMidi.h"


//------------------------------------------------------Linker Defines--------------------------------------------------------------------//

#pragma mark -- Obj-C Runtime Externs

#if defined(__APPLE__) && !defined(__OBJC__)
//define the NSApplicationMain objective-c runtime call to suppress warnings before linking
#if TARGET_OS_OSX
//extern int NSApplicationMain(int argc, const char *__nonnull argv[__nonnull]);
extern int NSApplicationMain(int argc, const char *_Nonnull argv[_Nonnull]);
//extern int NSApplicationMain(int argc, const char *__nonnull argv[__nonnull], id principalClassName, id delegateClassName);
#else// defined(CR_TARGET_IOS) || defined(CR_TARGET_TVOS)
//define the UIApplicationMain objective-c runtime call or linking will fail
extern int UIApplicationMain(int argc, char * _Nullable argv[_Nonnull], id _Nullable principalClassName, id delegateClassName);
//extern int UIApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);
#endif
#endif

//------------------------------------------------------App Definitions--------------------------------------------------------------------//

#pragma mark -- Application Globals

//ClientIDs used by CoreMIDI
static const char * _Nonnull CM_CLIENT_OWNER_ID         = "com.3rdGen.MidiThru";
static const char * _Nonnull CM_PERSISTENT_THRU_BASE_ID = "com.3rdGen.MidiThru.PersistentConnections";

//Class Names of the Custom NSApplication/UIApplication and NSAppDelegate/UIAppDelegate Cocoa App Singleton Objective-C Objects
static const char * _Nonnull CocoaAppClassName         = "CMThruApplication";
static const char * _Nonnull CocoaAppDelegateClassName = "CMThruApplicationDelegate";


#endif /* CMAppInterface_h */
