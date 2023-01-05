//
//  AppDelegate.h
//  HappyEyeballs
//
//  Created by Joe Moulton on 7/24/22.
//


#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define CocoaDelegateSuperclass NSObject
#define CocoaAppDelegate        NSApplicationDelegate
#define CocoaWindow             NSWindow
#import "CMThruMenu.h"
#else
#define CocoaDelegateSuperclass UIResponder
#define CocoaAppDelegate        UIApplicationDelegate, UIWindowSceneDelegate
#define CocoaWindow             UIWindow
#endif


#import "CMThruApplication.h"
//#import "CMThruConnection.h"
#import "CustomButtonView.h"

@interface CMThruApplicationDelegate : CocoaDelegateSuperclass <CocoaAppDelegate, NSToolbarDelegate, CustomButtonViewDelegate>

+ (CMThruApplicationDelegate*)sharedInstance;

@property (strong, nonatomic) CocoaWindow *window;

-(void)openThruConnectionModalWindow:(NSString*)thruID;
-(void)dismissModalWindow;
-(void)updateThruConnectionWidgets;

//@property (nonatomic) NSWindowStyleMask modalWindowStyleMask;
//@property (nonatomic, retain) MastryAdminWindow * window;
//@property (nonatomic, retain) MastryAdminWindow * editWindow;

@end

