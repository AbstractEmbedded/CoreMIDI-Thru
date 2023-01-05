//
//  CMThruView.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/27/22.
//

#import "CMThruView.h"
#import "CMThruScrollListView.h"
#import "CMThruApplicationDelegate.h"
#import "CMThruConnection.h"

@interface CMThruView()
{
    CMThruScrollListView * _scrollListView;
}

@end

@implementation CMThruView



-(void)createScrollListView
{
    _scrollListView = [[CMThruScrollListView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height) andDOM:CMThru];
    [self addSubview:_scrollListView];
    
    
    _scrollListView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:CMThruApplicationDelegate.sharedInstance.window.contentView.safeAreaInsets.top];

    NSLayoutConstraint * Bottom = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f constant:-14.0f];

    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:14.0f];

    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-14.0f];

    [self addConstraints:@[ Top, Bottom, Left, Right]];
    
}


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // setup the initial properties of the
        // draggable item
        
        [self setWantsLayer:NO];
        self.layer.borderWidth = 0.0f;
        self.layer.masksToBounds = YES;
        [self.layer setBorderWidth:0];
        self.appearance = [NSAppearance appearanceNamed: NSAppearanceNameDarkAqua];

        [self createScrollListView];
        
        
        
    }
    return self;
}

-(void)updateThruConnectionWidgets
{
    [_scrollListView redraw];

}


- (void)drawRect:(NSRect)rect
{
    //[NSGraphicsContext saveGraphicsState];
    [super drawRect:rect];
    // erase the background by drawing white
    [[NSColor clearColor] set];
    [NSBezierPath fillRect:rect];
    //[NSGraphicsContext restoreGraphicsState];

}
@end
