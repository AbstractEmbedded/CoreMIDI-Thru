//
//  CustomIndicatorView.m
//  Mastry
//
//  Created by Joe Moulton on 4/12/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "CustomIndicatorView.h"

@interface CustomIndicatorView()
{
    NSProgressIndicator * _indicator;
    //UIActivityIndicatorView * _rightIndicator;

    NSTextField * _label;

}



@end

@implementation CustomIndicatorView

@synthesize indicator = _indicator;
@synthesize label = _label;

-(void)showAndStartAnimating
{
    //self.superview.enable = NO;
    //[MastryAdminApplication sharedInstance].networkActivityIndicatorVisible = TRUE;
    [_indicator startAnimation:_indicator];
    _indicator.hidden = NO;
    self.hidden = NO;
}

-(void)hideAndStopAnimating
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    //self.superview.userInteractionEnabled = YES;
    self.hidden = YES;
    _indicator.hidden = YES;
    [_indicator stopAnimation:_indicator];
}

-(id)init
{
 
    self = [super init];
    
    if( self )
    {
        //UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_indicatorView.frame.size.width , _indicatorView.frame.size.height/6.0)];
        //label.backgroundColor = [UIColor clearColor];
        //label.text = @"Logging In ...";
        //label.adjustsFontSizeToFitWidth = YES;
        //label.font = [UIFont systemFontOfSize:label.frame.size.height*.5];
        //label.numberOfLines = 0;ß
        //label.textColor = [UIColor whiteColor];
        //label.textAlignment = NSTextAlignmentCenter;
        //[_indicatorView addSubview:label];
        
        [self createBlurView];
        
        [self createActivityIndicator];
        //[self createActivityIndicator2];

        [self createLabel];
    }
    return self;
    
}

-(void)createBlurView
{
    [self insertVibrancyViewBlendingMode:NSVisualEffectBlendingModeWithinWindow];
    /*
    self.layer.backgroundColor = [[NSColor clearColor] CGColor];
    // 2
    NSBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];//(style: .light)
    // 3
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //blurView.alpha= 0.5;
    // 4
    blurView.translatesAutoresizingMaskIntoConstraints = false;
    blurView.layer.cornerRadius = 6;

    //blurView.frame = CGRectMake(0,0, 100,100);//self.bounds;
    //blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.clipsToBounds = YES;
    [self addSubview:blurView];
    [self sendSubviewToBack:blurView];
    
    
    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem: blurView
                                                                attribute: NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem: blurView
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: blurView
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeWidth
                                                             multiplier:1 constant:0];
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: blurView
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:1 constant:0];
    [self addConstraints:@[ centerY, centerX, width, height ]];
    */
}

-(void)createActivityIndicator
{
    self.indicator = [[NSProgressIndicator alloc] initWithFrame:CGRectZero];
    [self.indicator setStyle:NSProgressIndicatorStyleSpinning];
    
    [self addSubview:_indicator];
    //[self  bringSubviewToFront:_indicator];
    
    _indicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    /*

    NSLayoutConstraint * leading = [NSLayoutConstraint constraintWithItem: _indicator
                                                                attribute: NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem: _indicator
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _indicator
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0 constant:0];
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _indicator
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:1.0 constant:0];
    
    [self addConstraints:@[ leading, centerY, width, height ]];
     */
    
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: _indicator
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: self attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem: _indicator
                                                                attribute: NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _indicator
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeHeight
                                                             multiplier:2./3. constant:0];
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _indicator
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:2./3. constant:0];
    
    [self addConstraints:@[ top, centerX, width, height ]];
}

/*
-(void)createActivityIndicator2
{
    _rightIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self addSubview:_rightIndicator];
    [self  bringSubviewToFront:_rightIndicator];
    
    _rightIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    

    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: _rightIndicator
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem: _rightIndicator
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _rightIndicator
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeHeight
                                                             multiplier:0.75 constant:0];
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _rightIndicator
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:0.75 constant:0];
    
    [self addConstraints:@[ top, centerY, width, height ]];

}
*/

-(void)createLabel
{
    self.label = [[NSTextField alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_label];
    //[self bringSubviewToFront:_label];
    
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    /*
    NSLayoutConstraint * leading = [NSLayoutConstraint constraintWithItem: _label
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: _indicator attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem: _label
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f];
    

     NSLayoutConstraint * trailing = [NSLayoutConstraint constraintWithItem: _label
                                                                 attribute: NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                 toItem: _rightIndicator attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f constant:0.0f];
     
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _label
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:1.0 constant:0];
    
    [self addConstraints:@[ leading, centerY, trailing, height ]];
    */
    
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: _label
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: _indicator attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem: _label
                                                                attribute: NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem: _label
                                                               attribute: NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _label
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeWidth
                                                             multiplier:0.95 constant:0];
    
    /*
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _label
                                                               attribute: NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: self attribute:NSLayoutAttributeHeight
                                                              multiplier:0.25 constant:0];
    */
    
    [self addConstraints:@[ top, bottom, width, centerX ]];
    
    
    _label.bezeled         = NO;
    _label.editable        = NO;
    _label.drawsBackground = NO;
    
    _label.backgroundColor = [NSColor clearColor];
    _label.alignment = NSTextAlignmentCenter;
    _label.textColor = [NSColor whiteColor];
    _label.font = [NSFont boldSystemFontOfSize:20.0];
    //_label.adjustsFontSizeToFitWidth = TRUE;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
