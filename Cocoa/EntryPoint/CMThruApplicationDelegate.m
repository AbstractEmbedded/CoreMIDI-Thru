//
//  AppDelegate.m
//  HappyEyeballs
//
//  Created by Joe Moulton on 7/24/22.
//

#import "CMThruApplicationDelegate.h"

//Midi
#import "CMidiAppInterface.h"

//View
#import "CMThruView.h"
#import "CMThruViewController.h"

//Modal
#import "CMThruModalView.h"
#import "CMThruModalViewController.h"

//Button
#import "CustomButtonView.h"

//AppIcon Generation
#import "CocoaImage+Logo.h"

static NSString * const NSToolbarAddItemIdentifier = @"AddToolbarItem";

const char * CM_THRU_MENU_TITLES[] =
{
    "CoreMIDI Thru",
    "SubMenu 2",
    "SubMenu 3"
};

@interface CMThruApplicationDelegate ()
{
    
    //CMThruView * _thruView;
    //CMThruScrollListView * _scrollListView;
}

@property (nonatomic, retain) NSToolbar * toolbar;
@property (nonatomic, retain) CustomButtonView* createThruButton;


@property (nonatomic, retain) NSTitlebarAccessoryViewController * accessoryViewController;

@property (nonatomic, retain) CocoaView           * rootView;
@property (nonatomic, retain) CocoaViewController * rootViewController;

@property (nonatomic, retain) CMThruModalView           * modalView;
@property (nonatomic, retain) CMThruModalViewController * modalViewController;

@end

@implementation CMThruApplicationDelegate

#pragma mark -- Create Menu

-(void)setMenuTitle:(NSString*)title
{
#if TARGET_OS_OSX
    NSMenuItem* menuItem = [[NSApp mainMenu] itemAtIndex:0];
    NSMenu *menu = [[[NSApp mainMenu] itemAtIndex:0] submenu];
    //NSString *title = @"Core Render";
    // Append some invisible character to title :)
    
    //NSFont* font = menu.font;

    title = [title stringByAppendingString:@"\x1b"];
    [menu setTitle:title];
    
    
    NSFont * newFont = menu.font;//[NSFont menuBarFontOfSize:0];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: newFont,
                                 NSForegroundColorAttributeName: [NSColor greenColor]
                                 };
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"View" attributes:attributes];
    //[attrTitle addAttribute:NSFontAttributeName value:menu.font range:NSMakeRange(0, title.length)];
    //[menu setTitle:attrTitle];
    //[menu setTitle:title];
    [menuItem setAttributedTitle:attrTitle];
    //[menuItem.submenu changeMenuFont:newFont];
    //[[menu setTitleColor:[NSColor redColor]];
    
    //[[NSApp mainMenu] setTitle:title];
    //NSFont* newFont = [NSFont boldSystemFontOfSize:font.pointSize];
    //[submenu setFont:newFont];
#else
    
#endif

}

-(void)createMenuBar
{
#if TARGET_OS_OSX
    [NSApp setMainMenu:[CMThruMenu sharedInstance]];
#else
    
#endif
}



+ (id)sharedInstance
{
    static CMThruApplicationDelegate *appDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDelegate = [[self alloc] init];
    });
    return appDelegate;
}


-(void)closeCurrentWindow
{
    
    
}

#pragma mark -- Init Delegate

-(id)init
{
    if(self = [super init]) {
        
        NSLog(@"CMThruApplicationDelegate::init");

       // [self createWindow];
        
        // Setup Preference Menu Action/Target on MainMenu
        [self createMenuBar];
        
        //CRView * view = [[CRView alloc] initWithFrame:self.window.frame];
        //[self.window.contentView addSubview:view];
        // Create a view
        //view = [[NSTabView alloc] initWithFrame:CGRectMake(0, 0, 700, 700)];
    }
    return self;
}

-(void)openThruConnectionModalWindow
{
    NSLog(@"openThruConnectionModalWindow");
    
    //Create a view and view controller for the data model as an overlay window, popover or sheet
    CGSize popoverSize = CGSizeMake(550, 550);
    CGRect viewFrame = CGRectMake(0,0,popoverSize.width, popoverSize.height);
    
    //Create the view/view controller pair that will manage the UI for a single abstract data model database entry as a modal window, popover or sheet
    self.modalView = [[CMThruModalView alloc] initWithFrame:viewFrame andThruConnection:nil];
    self.modalViewController = [[CMThruModalViewController alloc] initWithView:self.modalView];
    self.modalView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modalView.autoresizingMask = NSViewHeightSizable;
    
    //Present the ModalView/ViewCOntroller pair as a modal window, popover, or sheet on top of the parent window/view controller pair
    [self.rootViewController presentViewControllerAsModalWindow:self.modalViewController];

    [self.modalView.window setStyleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable];// | NSWindowStyleMaskFullSizeContentView ];
    self.modalView.window.title = [NSString stringWithFormat:@"New Midi Thru"];
    //self.modalView.titleLabel.stringValue = [NSString stringWithFormat:@"New Midi Route"];
}


-(void)openThruConnectionModalWindow:(NSString*)thruID
{
    NSLog(@"openThruConnectionModalWindow:%@", thruID);
    
    //Create a view and view controller for the data model as an overlay window, popover or sheet
    CGSize popoverSize = CGSizeMake(550, 550);
    CGRect viewFrame = CGRectMake(0,0,popoverSize.width, popoverSize.height);
    
    //Create the view/view controller pair that will manage the UI for a single abstract data model database entry as a modal window, popover or sheet
    self.modalView = [[CMThruModalView alloc] initWithFrame:viewFrame andThruConnection:thruID];
    self.modalViewController = [[CMThruModalViewController alloc] initWithView:self.modalView];
    self.modalView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modalView.autoresizingMask = NSViewHeightSizable;
    
    //Present the ModalView/ViewCOntroller pair as a modal window, popover, or sheet on top of the parent window/view controller pair
    [self.rootViewController presentViewControllerAsModalWindow:self.modalViewController];

    [self.modalView.window setStyleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable];// | NSWindowStyleMaskFullSizeContentView ];
    self.modalView.window.title = [NSString stringWithFormat:@"Edit Midi Thru"];
    //self.modalView.titleLabel.stringValue = [NSString stringWithFormat:@"New Midi Route"];
}


-(void)dismissModalWindow
{
    //dismiss the current view controller modal window/view controller, if present, before recreating the current view controller
    if( [self.rootViewController.presentedViewControllers containsObject:self.modalViewController] )
    {
        NSLog(@"dismissModalWindow");
        [self.modalViewController dismissViewController:self.modalViewController];
    }

    //Bastard Modal Window left our menu items disabled
    //Call custom fix:
    //[[CMMenu sharedInstance] enableAllMenuItems];
    
    //dealloc modaView/VC
    self.modalView = nil;
    self.modalViewController = nil;
    
}


-(void)addRouteButtonClicked:(id)sender
{
    
    NSLog(@"addRouteButtonClicked");
}


- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarAddItemIdentifier];//@"Today", @"Calendar"];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarAddItemIdentifier];//@"Today", @"Calendar"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    if( [itemIdentifier localizedCompare:NSToolbarAddItemIdentifier] == NSOrderedSame)
    {
        NSButton * button = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameAddTemplate] target:self action: @selector(openThruConnectionModalWindow)];
        button.bezelStyle = NSBezelStyleTexturedRounded;
        button.frame = CGRectMake(0,0,button.frame.size.height,button.frame.size.height);
        
        //self.createThruButton = [self createButtonViewWithImage:[NSImage imageNamed:NSImageNameAddTemplate]];
        return [self customToolbarItem:NSToolbarAddItemIdentifier label:@"New" paletteLabel:@"New Midi Thru" toolTip:@"Create a CoreMIDI Server Persistent Thru Connection" itemContent:button];
    }

    return nil;
    
}


-(void) cbvTouchUpInside:(id)sender
{
    
    if( sender == self.createThruButton )
    {
        NSLog(@"cbvTouchUpInside");
        [self openThruConnectionModalWindow];
    }
}
     
   /**
    Mostly base on Apple sample code: https://developer.apple.com/documentation/appkit/touch_bar/integrating_a_toolbar_and_touch_bar_into_your_app
    */

-(CustomButtonView*)createButtonViewWithImage:(NSImage*)image
{
    CustomButtonView * button = [[CustomButtonView alloc] initWithFrame:CGRectMake(0,20,image.size.width * 2., image.size.height * 1.5)];
    
    NSString * title = @"";
    button.title = title;
    button.selectedTitle = title;
    //[button sizeToFit];
    
    button.wantsLayer = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [NSColor grayColor].CGColor;
    button.layer.cornerRadius = 4;
    //button.layer.masksToBounds = YES;
    //button.layer.maskedCorners = YES;
    
    button.layer.borderColor = [CocoaColor clearColor].CGColor;
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.backgroundColor = [CocoaColor clearColor].CGColor;
    button.normalBackgroundColor = [CocoaColor clearColor];
    button.highlightedBackgroundColor = [CocoaColor lightGrayColor];
    button.selectedBackgroundColor = [CocoaColor redColor];
    //button.backgroundImageView.contentMode
    
    button.delegate = self;
    
    button.titleColor = [CocoaColor whiteColor];
    button.highlightedTitleColor = [CocoaColor grayColor];
    button.selectedTitleColor = button.titleColor;
    
    button.titleLabel.backgroundColor = [CocoaColor clearColor];
    
    button.layer.backgroundColor = [CocoaColor clearColor].CGColor;
    if(image)
        button.backgroundImage = image;
    
    return button;
}

-(NSToolbarItem*) customToolbarItem:(NSToolbarItemIdentifier)itemIdentifier
       label:(NSString*)label
       paletteLabel:(NSString*)paletteLabel
       toolTip:(NSString*)toolTip
       itemContent: (NSButton*)itemContent
{
       
    NSToolbarItem* toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.label = label;
    toolbarItem.paletteLabel = paletteLabel;
    toolbarItem.toolTip = toolTip;
    toolbarItem.target = self;
    toolbarItem.action = @selector(addRouteButtonClicked:);

    //[toolbarItem.label sizeToFit];
    //CGSize size = [label sizeWithAttributes:[NSAttributedStringKey.font: font])

    //minSize is deprecated but it is the only mechanism I can get to size the toolbar item properly
    toolbarItem.minSize = CGSizeMake(itemContent.frame.size.height,itemContent.frame.size.height);    // maybe + x
    
    //set toolbar view
    toolbarItem.view = itemContent;
    //toolbarItem.image = itemContent.image;
    
    // We actually need an NSMenuItem here, so we construct one.
    NSMenuItem * menuItem = [[NSMenuItem alloc] init];
    menuItem.submenu = nil;
    menuItem.title = paletteLabel;
    toolbarItem.menuFormRepresentation = menuItem;

    //toolbarItem.rou
    return toolbarItem;
}

-(void)createToolbar
{
    self.toolbar = [[NSToolbar alloc] init];
    // Toolbar **needs** a delegate
    self.toolbar.delegate = self;
    
    // Assign the toolbar to the window object
    self.window.toolbar = self.toolbar;
    //self.window.titleVisibility = NSWindowTitleHidden;
    //window.setFrameAutosaveName("Main Window")
    //window.contentView = NSHostingView(rootView: contentView)
    //window.makeKeyAndOrderFront(nil)
}

-(void) createAccessoryViewController
{
    self.accessoryViewController = [[NSTitlebarAccessoryViewController alloc] init];
    //self.accessoryViewController.view = accessoryView;
    self.accessoryViewController.layoutAttribute = NSLayoutAttributeRight;
    [self.window addTitlebarAccessoryViewController:self.accessoryViewController];
}


-(void)createWindow
{
    if( !self.window )
    {
#if TARGET_OS_OSX
    
    CGFloat width = 1024.;
    CGFloat height = 768.;
    NSLog(@"Creating Window");
    NSRect contentSize = NSMakeRect(0,0, width, height);
        NSUInteger windowStyleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskResizable | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView ;
    self.window = [[NSWindow alloc] initWithContentRect:contentSize styleMask:windowStyleMask backing:NSBackingStoreBuffered defer:YES];
    //self.window.frame = CGRectMake(NSScreen.mainScreen.frame.size.width/2. - width/2., NSScreen.mainScreen.frame.size.height/2. -  height/2., width, height);
    [self.window center];
    self.window.backgroundColor = [NSColor whiteColor];
    self.window.title = @"CoreMIDI Thru";

    self.window.appearance = [NSAppearance appearanceNamed: NSAppearanceNameVibrantDark];
    self.window.titlebarAppearsTransparent = YES;
    self.window.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone;
        
    [self createToolbar];
        /*
        NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton]; // Get the existing close button of the window. Check documentation for the other window buttons.
        NSView *titleBarView = closeButton.superview; // Get the view that encloses that standard window buttons.
        NSButton *myButton = …; // Create custom button to be added to the title bar.
        myButton.frame = …; // Set the appropriate frame for your button. Use titleBarView.bounds to determine the bounding rect of the view that encloses the standard window buttons.
        [titleBarView addSubview:myButton]; // Add the custom button to the title bar.
         */
#else

    //on ios >= 13.0 we'll defer window creation to the scene view delegate methods
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor purpleColor];
#endif
    }
}



-(void)createRootViewController
{
#if TARGET_OS_OSX
    self.rootView = [[CMThruView alloc] initWithFrame:CGRectMake(0,0, self.window.frame.size.width, self.window.frame.size.height)];
    self.rootViewController = [[CMThruViewController alloc] initWithView:self.rootView];
    
    //NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton]; // Get the existing close button of the window. Check documentation for the other window buttons.
    //NSView *titleBarView = closeButton.superview; // Get the view that encloses that standard window buttons.
    
    //Note to self:
    //
    //  If [[NSWindow setContentViewController:] is used then the Window will resize itself based on the view rather than visa versa
    //  However, this seems to prevent autolayout from resizing a scroll view within the root view appropriately so to avoid
    //  I am avoiding this routine, setting the window content view to be the root view manually, and having the view resize based on the window
    //
    //  [self.window setContentViewController:self.rootViewController];
    [self.window.contentView addSubview:self.rootViewController.view];
    
    self.rootView.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO
    NSLayoutConstraint * leading = [NSLayoutConstraint constraintWithItem:self.rootView
                                                                attribute: NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.window.contentView
                                                                attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0f constant:0.0f];

    NSLayoutConstraint * trailing = [NSLayoutConstraint constraintWithItem:self.rootView
                                                                attribute: NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.window.contentView
                                                                attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f constant:0.0f];

    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.rootView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.window.contentView
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0];

    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.rootView
                                                                attribute: NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.window.contentView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f];

    [self.window.contentView addConstraints:@[ leading, trailing, top, bottom]];
     
#else
    self.rootViewController = nil;
    
    //create the camera video view controller
    self.rootViewController = [[CMThruViewController alloc] init];

    self.rootViewController.view.backgroundColor = [UIColor purpleColor];
    self.window.rootViewController = self.rootViewController;
#endif
    
    
}
#pragma mark -- OSX Delegate Methods

#if TARGET_OS_OSX
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    //Hold up NSApplication::terminate: from being called so we can notify CoreTransport to clean up and it can notify NSApplication when finished so that shutdown can proceed

    /*
    struct kevent kev;
    EV_SET(&kev, CTProcessEvent_Exit, EVFILT_USER, EV_ADD | EV_ENABLE | EV_ONESHOT, NOTE_FFCOPY|NOTE_TRIGGER|0x1, 0, NULL);
    kevent(CTProcessEventQueue.kq, &kev, 1, NULL, 0, NULL);
    */
    
    return NSTerminateNow;//NSTerminateLater;
    
}

MIDINotifyBlock CMidiNotifyBlock = ^void(const MIDINotification *msg)
{
    //for debugging, trace change notifications:
    const char *descr[] = {
        "undefined (0)",
        "kMIDIMsgSetupChanged",
        "kMIDIMsgObjectAdded",
        "kMIDIMsgObjectRemoved",
        "kMIDIMsgPropertyChanged",
        "kMIDIMsgThruConnectionsChanged",
        "kMIDIMsgSerialPortOwnerChanged",
        "kMIDIMsgIOError"};

    NSLog(@"MIDI Notify, messageID %d (%s)\n", (int) msg->messageID, descr[(int) msg->messageID]);
    
    if( msg->messageID == kMIDIMsgThruConnectionsChanged )
    {
        //CMidi should have already udpated its internal data structures causing this change
        //but that doesn't necessarily have to be the case if other apps are also making thru connections

        //Distribute updates to the UI
        [[CMThruApplicationDelegate sharedInstance] updateThruConnectionWidgets];
    }
    
    return;
    
    
};

-(void)updateThruConnectionWidgets
{
    [((CMThruView*)(self.rootView)) updateThruConnectionWidgets];
}

//this is the Mac OS entrypoint
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSLog(@"applicationapplicationDidFinishLaunching");

    //Customize Menu Title
    //[self setMenuTitle:@"Core Transport"];

    //[[NSApplication sharedApplication] stop];
    //[NSRunLoop mainRunLoop]
    
    //A CoreMidi client is used to get notification that thru connections have been updated
    //as a result of this client app modifying thru connections
    CMidi.init(CM_CLIENT_OWNER_ID, CMidiNotifyBlock);
    
    //[CMThruConnection deleteThruConnectionKeysFromCache];
    [CMThruConnection loadThruConnections];
    
    //[self createWindow];
    //[self createRootViewController];
    

    if(!self.window) [self createWindow];
        
    //self.window = [[CRWindow alloc] init];
    //self.window.backgroundColor = [NSColor redColor];
    
    //self.windowController = [[CRWindowController alloc] initWithWindow:_window];
    [self createRootViewController];

    [self.window makeKeyAndOrderFront:self];     // Show the window

    
    [self updateThruConnectionWidgets];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"ApplicationWillTerminate");
    
    
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

#else


//This is the iOS entrypoint
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSLog(@"application:didFinishLaunchingWithOptions:");

    /*
     #if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
     // iOS-specific code
     //begin generating device orientation updates immediately at startup
     [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
     #elif TARGET_OS_TV
     // tvOS-specific code
     #endif
     */
    
    /*
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    if( [[UIDevice currentDevice].systemVersion floatValue] >= 13.0 )
    {
        NSLog(@"Here I am 0!");

    }
    else
    {
        NSLog(@"Here I am!");

        [self createWindow];
        [self createRootViewController];
    }
     */
    

    [self createWindow];
    [self createRootViewController];

    if(!self.window)
        NSLog(@"No Window Loaded!");
    /*
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.apple.GraphicsServices"];
    const char *frameworkPath = [[frameworkBundle executablePath] UTF8String];
    if (frameworkPath) {
        void *graphicsServices = dlopen(frameworkPath, RTLD_NOLOAD | RTLD_LAZY);
        if (graphicsServices) {
            BOOL (*GSFontAddFromFile)(const char *) = dlsym(graphicsServices, "GSFontAddFromFile");
            if (GSFontAddFromFile) {
                
                NSMutableDictionary *themeFonts = [[NSMutableDictionary alloc] init];
                NSString *fontFileName = nil; NSString *fontFilePath = nil;
                
                //add primary font
                //[self findNameOfFontFileWithType:PrimaryFont fontFileName:&fontFileName fontFilePath:&fontFilePath];
                //if (fontFilePath && fontFileName) {
                    //NSString *path = [NSString stringWithFormat:@"%@/%@", fontFilePath, fontFileName];
                    //newFontCount += GSFontAddFromFile([path UTF8String]);
                    //[themeFonts setObject:[fontFileName removeExtension] forKey:IFEPrimaryFontKey];
                    //[fontFilePath release];
                    //[fontFileName release];
               // }
            }
        }
    }
    */
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];

    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Documents DIR: %@", [paths objectAtIndex:0]);
    
    /*
    //notify our Core Render Application Event Loop that the Cocoa Touch application has finished launching
    struct kevent kev;
    EV_SET(&kev, crevent_init, EVFILT_USER, 0, NOTE_TRIGGER, 0, NULL);
    kevent(cr_appEventQueue, &kev, 1, NULL, 0, NULL);
    */
    
    
    return YES;
}



#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - UISceneDelegate methods

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

    UIWindowScene * windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    if( !windowScene ) return;
    
    //self.window = [[UIWindow alloc] initWithFrame:windowScene.coordinateSpace.bounds];
    self.window.windowScene = windowScene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    self.window.rootViewController = [[UIViewController alloc] init];
    self.window.rootViewController.view.backgroundColor = [UIColor purpleColor];
    [self.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


#endif


@end
