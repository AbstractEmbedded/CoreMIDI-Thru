//
//  main.c
//  QUIC MIDI
//
//  Created by Joe Moulton on 12/26/22.
//

#include "CMidiAppInterface.h"
//#include "CMDeviceInput.h"

void CTPlatformInit(void)
{
    //CTProcessEventQueue = {0, 0};
#ifdef _WIN32
    //cr_mainThread = GetCurrentThread();
    CTMainThreadID = GetCurrentThreadId();
#elif defined(__APPLE__)
#if TARGET_OS_OSX
     //Initialize kernel timing mechanisms for debugging
    //monotonicTimeNanos();

    //We can do some Cocoa initializations early, but don't need to
    //Note that NSApplicationLoad will load default NSApplication class
    //Not your custom NSApplication Subclass w/ custom run loop!!!
    //NSApplicationLoad();

    /***
     *  0 Explicitly
     *
     *  OSX CoreGraphics API requires that we make the process foreground application if we want to
     *  create windows on threads other than main, or we will get an error that RegisterApplication() hasn't been called
     *  Since this is usual startup behavior for User Interactive NSApplication anyway that's fine
     ***/
    //pid_t pid;
    //CGSInitialize();

    ProcessSerialNumber psn = { 0, kCurrentProcess };
    //GetCurrentProcess(&psn);  //this is deprecated, all non-deprecated calls to make other process foreground must route through Cocoa
    /*OSStatus transformStatus = */TransformProcessType(&psn, kProcessTransformToForegroundApplication);
#endif
    //RegisterNotificationObservers();
#endif
    //StartApplicationEventLoop();
}

void ExitHandler(void)
{
    fprintf(stderr, "Exiting via Exit Handler...\n");

    //CMidiThruCleanup();
    
    //pause for leak tracking
    //fscanf(stdin, "c");
}

int StartPlatformEventLoop(int argc, const char * argv[])
{
    //CoreTransport Gratuitous Client App Event Queue Initialization (not strictly needed for CoreTransport usage)
    CTPlatformInit();

#if defined(__APPLE__) //&& TARGET_IOS
    
#if TARGET_OS_OSX
    atexit(&ExitHandler);
    NSApplicationMain(argc, argv);       //Cocoa Application Event Loop
#else //defined(CR_TARGET_IOS) || defined(CR_TARGET_TVOS)
    
    // Create an @autoreleasepool, using the old-stye API.
    // Note that while NSAutoreleasePool IS deprecated, it still exists
    // in the APIs for a reason, and we leverage that here. In a perfect
    // world we wouldn't have to worry about this, but, remember, this is C.
    
    id (*objc_ClassSelector)(Class class, SEL _cmd) = (void*)objc_msgSend;//objc_msgSend(objc_getClass("NSAutoreleasePool"), sel_registerName("alloc")), sel_registerName("init"))
    id (*objc_InstanceSelector)(id self, SEL _cmd) = (void*)objc_msgSend;//objc_msgSend(objc_getClass("NSAutoreleasePool"), sel_registerName("alloc")), sel_registerName("init"))

    //pre OSX 10.15
    //id autoreleasePool = objc_msgSend(objc_msgSend(objc_getClass("NSAutoreleasePool"), sel_registerName("alloc")), sel_registerName("init"));
    //post OSX 10.15
    id autoreleasePool = objc_InstanceSelector(objc_ClassSelector(objc_getClass("NSAutoreleasePool"), sel_registerName("alloc")), sel_registerName("init"));
    
    // Get a reference to the file's URL
    CFStringRef cfAppClassName = CFStringCreateWithCString(kCFAllocatorDefault, CocoaAppClassName, CFStringGetSystemEncoding());
    CFStringRef cfAppDelegateClassName = CFStringCreateWithCString(kCFAllocatorDefault, CocoaAppDelegateClassName, CFStringGetSystemEncoding());
    UIApplicationMain(argc, (char* _Nullable *)argv, (id)cfAppClassName, (id)cfAppDelegateClassName);
    CFRelease( cfAppClassName );
    CFRelease( cfAppDelegateClassName );
    
    //release all references in the autorelease pool
    objc_InstanceSelector(autoreleasePool, sel_registerName("drain"));
#endif

#else
    SystemKeyboardEventLoop(argc, argv);
#endif
    return 0;
}


#pragma mark -- Main

int main(int argc, const char * argv[])
{

    StartPlatformEventLoop(argc, argv);
    //SystemKeyboardEventLoop(argc, argv);

    //sleep(1);
    //fprintf(stderr, "Exiting via Main...\n");
    
    //pause for leaks
    //fscanf(stdin, "c");
    
    return 0;
}
