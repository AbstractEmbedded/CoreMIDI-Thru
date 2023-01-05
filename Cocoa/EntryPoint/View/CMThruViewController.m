//
//  ViewController.m
//  HappyEyeballs
//
//  Created by Joe Moulton on 7/24/22.
//

#import "CMThruViewController.h"
#import "CMThruScrollListView.h"

@interface CMThruViewController()
{
    CMThruScrollListView * _scrollListView;
}

@end


@implementation CMThruViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    NSLog(@"CMThruViewController::viewdDidLoad()");
}


-(id)initWithView:(NSView*)view
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"CMThruViewController::initWithView()");
        self.view = view;
    }
    
    return self;
    
}


#if TARGET_OS_OSX
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
#else

#endif

@end
