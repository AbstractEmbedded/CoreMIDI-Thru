//
//  CMThruModalViewController.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/28/22.
//

#import "CMThruModalViewController.h"
#import "CMThruModalView.h"


@interface CMThruModalViewController ()

@end

@implementation CMThruModalViewController



-(id)initWithView:(NSView*)view
{
    self = [super init];
    if( self)
    {
        self.view = view;
    }
    return self;
}

-(void)viewWillAppear
{
    self.view.layer.backgroundColor = [NSColor orangeColor].CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do view setup here.
    //[self.view.window makeKeyAndOrderFront:self];
    //[self.view.window makeFirstResponder:self.view];
    
    //CMThruModalView* modalView = (CMThruModalView*)self.view;
    //self.preferredContentSize = NSMakeSize(self.view.frame.size.width, modalView.cancelButton.frame.size.height + modalView.cancelButton.frame.origin.y + 20);
    
    [self.view setNeedsLayout:YES];
    [self.view display];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
}

@end
