//
//  CustomButtonView.m
//  NCrypt
//
//  Created by MACMaster on 4/18/15.
//  Copyright (c) 2015 Abstract Embedded, LLC. All rights reserved.
//

#import "CustomButtonView.h"

@interface CustomButtonView()
{
    volatile bool _touchDown;
    CocoaImageView * _backgroundImageView;
}


@property (nonatomic) BOOL highlighted;




@end

@implementation CustomButtonView


@synthesize backgroundImageView = _backgroundImageView;
@synthesize normalBackgroundColor = _normalBackgroundColor;
@synthesize highlightedBackgroundColor = _highlightedBackgroundColor;
@synthesize selectedBackgroundColor = _selectedBackgroundColor;


@synthesize backgroundImage = _backgroundImage;
@synthesize highlightedBackgroundImage = _highlightedBackgroundImage;
@synthesize selectedBackgroundImage = _selectedBackgroundImage;

@synthesize titleLabel = _titleLabel;
@synthesize highlightedTitleLabel = _highlightedTitleLabel;
@synthesize selectedTitleLabel = _selectedTitleLabel;

@synthesize title = _title;
@synthesize highlightedTitle = _highlightedTitle;
@synthesize selectedTitle = _selectedTitle;

@synthesize titleColor = _titleColor;
@synthesize highlightedTitleColor = _highlightedTitleColor;
@synthesize selectedTitleColor = _selectedTitleColor;

-(void)layoutSubviews
{
#if TARGET_OS_OSX

#else
    [super layoutSubviews];
#endif
    if( _makeBorderCircular )
        self.layer.cornerRadius = self.frame.size.width/2.0;
    
}

-(void)dealloc
{


}

-(void)createTrackingArea
{
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |  NSTrackingCursorUpdate | NSTrackingActiveWhenFirstResponder | NSTrackingActiveAlways) owner:self userInfo: nil];
    [self addTrackingArea:trackingArea];
}

-(id) init
{
    _touchDown = false;
    //self.acceptsFirstResponder = YES;
    //[self createTrackingArea];
    return [self initWithFrame:CGRectZero];
    
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.makeBorderCircular = NO;
        _highlighted = false;
        _selected = false;
        _touchDown = false;
        //self.acceptsFirstResponder = YES;

        //self.backgroundColor = [UIColor yellowColor];
        
#if TARGET_OS_OSX

#else
        self.userInteractionEnabled = true;
#endif
        
        [self createBackgroundImageView];
        [self createTitleLabelSet];

        [self createTrackingArea];
    }
    
    return self;
}



-(void)setHighlighted:(BOOL)high
{
    //NSLog(@"set highlighted");
    _highlighted = high;
    if ( high == true )
    {
        
        
        
        if (_highlightedBackgroundColor != nil)
        {
#if TARGET_OS_OSX
            self.layer.backgroundColor = _highlightedBackgroundColor.CGColor;
#else
            self.backgroundColor = _highlightedBackgroundColor;
#endif
        }
        
        if (_highlightedBackgroundImage != nil)
        {
            _backgroundImageView.image = _highlightedBackgroundImage;
        }
        else
        {
            
            if (_highlightedTitle != nil)
            {
                NSLog(@"show highlighted title label hide others");
                //self.highlightedTitleLabel.text = highlightedTitle?
#if TARGET_OS_OSX
                //[viewToBeMadeForemost removeFromSuperview];
                //[self addSubview:viewToBeMadeForemost positioned:NSWindowAbove relativeTo:nil];
#else
                [self bringSubviewToFront:_highlightedTitleLabel];
#endif
                _titleLabel.hidden = true;
                _selectedTitleLabel.hidden = true;
                _highlightedTitleLabel.hidden = false;
                
                
            }
            /*
            if (_highlightedTitleColor != nil)
            {
                //self.titleLabel.textColor = _highlightedTitleColor;
                //self.selectedTitleLabel.textColor = _highlightedTitleColor;
                //self.highlightedTitleLabel.textColor = _highlightedTitleColor;
                
            }
            */
        }
        
    }
    else
    {
        if  (_selected == true)
        {
            
            
            
            if (_selectedBackgroundColor != nil)
            {
#if TARGET_OS_OSX
            self.layer.backgroundColor = _selectedBackgroundColor.CGColor;
#else
            self.backgroundColor = _selectedBackgroundColor;
#endif
            }
            
            if (_selectedBackgroundImage != nil)
            {
                _backgroundImageView.image = _selectedBackgroundImage;
            }
            else
            {
                
                if (_selectedTitle != nil)
                {
                    //self.titleLabel.text = selectedTitle?
#if TARGET_OS_OSX

#else
                    [self bringSubviewToFront:_selectedTitleLabel];
#endif
                    _titleLabel.hidden = true;
                    _highlightedTitleLabel.hidden = true;
                    _selectedTitleLabel.hidden = false;
                    
#if TARGET_OS_OSX
                    self.layer.backgroundColor = [NSColor clearColor].CGColor;
#else
                    self.backgroundColor = [UIColor clearColor];
#endif
                }
                
                /*
                if (_selectedTitleColor != nil)
                {
                    self.titleLabel.textColor = _selectedTitleColor;
                    self.selectedTitleLabel.textColor = _selectedTitleColor;
                    self.highlightedTitleLabel.textColor = _selectedTitleColor;
                    
                }
                */
                
            }
            
        }
        else
        {
            
            
            if (_normalBackgroundColor != nil)
            {
#if TARGET_OS_OSX
            self.layer.backgroundColor = _normalBackgroundColor.CGColor;
#else
            self.backgroundColor = _normalBackgroundColor;
#endif
            }
            
            if (_backgroundImage != nil)
            {
                _backgroundImageView.image = _backgroundImage;
            }
            else
            {
                if (_title != nil)
                {
                    //self.titleLabel.text = title?
#if TARGET_OS_OSX

#else
                    [self bringSubviewToFront:_titleLabel];
#endif
                    _selectedTitleLabel.hidden = true;
                    _highlightedTitleLabel.hidden = true;
                    _titleLabel.hidden = false;
                }
                
                /*
                if (_titleColor != nil)
                {
                    self.titleLabel.textColor = _titleColor;
                    self.selectedTitleLabel.textColor = _titleColor;
                    self.highlightedTitleLabel.textColor = _titleColor;
                    
                }
                */
            }
            
        }
        
    }
    
    
    
}


-(void)setSelected:(BOOL)selected
{

        _selected = selected;

        if  (_selected == true)
        {
            
            
            
            if (_selectedBackgroundColor != nil)
            {
#if TARGET_OS_OSX
                self.layer.backgroundColor = _selectedBackgroundColor.CGColor;
#else
                self.backgroundColor = _selectedBackgroundColor;
#endif
            }
            
            if (_selectedBackgroundImage != nil)
            {
                _backgroundImageView.image = _selectedBackgroundImage;
            }
            else
            {
                
                if (_selectedTitle != nil)
                {
                    //self.titleLabel.text = selectedTitle?
                    
#if TARGET_OS_OSX
                    self.layer.backgroundColor = [NSColor clearColor].CGColor;
#else
                    [self bringSubviewToFront:_selectedTitleLabel];
                    self.backgroundColor = [UIColor clearColor];
#endif
                    _titleLabel.hidden = true;
                    _highlightedTitleLabel.hidden = true;
                    _selectedTitleLabel.hidden = false;
     
                }
                
                /*
                 if (_selectedTitleColor != nil)
                 {
                 self.titleLabel.textColor = _selectedTitleColor;
                 self.selectedTitleLabel.textColor = _selectedTitleColor;
                 self.highlightedTitleLabel.textColor = _selectedTitleColor;
                 
                 }
                 */
                
            }
            
        }
        else
        {
            if ( _highlighted == true )
            {
                
                
                if (_highlightedBackgroundColor != nil)
                {
#if TARGET_OS_OSX
                    self.layer.backgroundColor = _highlightedBackgroundColor.CGColor;
#else
                    self.backgroundColor = _highlightedBackgroundColor;
#endif
                }
                
                if (_highlightedBackgroundImage != nil)
                {
                    _backgroundImageView.image = _highlightedBackgroundImage;
                }
                else
                {
                    
                    if (_highlightedTitle != nil)
                    {
                        NSLog(@"show highlighted title label hide others");
                        //self.highlightedTitleLabel.text = highlightedTitle?
#if TARGET_OS_OSX

#else
                        [self bringSubviewToFront:_highlightedTitleLabel];
#endif
                        _titleLabel.hidden = true;
                        _selectedTitleLabel.hidden = true;
                        _highlightedTitleLabel.hidden = false;
                        
                        
                    }
                    /*
                     if (_highlightedTitleColor != nil)
                     {
                     //self.titleLabel.textColor = _highlightedTitleColor;
                     //self.selectedTitleLabel.textColor = _highlightedTitleColor;
                     //self.highlightedTitleLabel.textColor = _highlightedTitleColor;
                     
                     }
                     */
                }
                
            }
            else
            {
                if (_normalBackgroundColor != nil)
                {
#if TARGET_OS_OSX
                    self.layer.backgroundColor = _normalBackgroundColor.CGColor;
#else
                    self.backgroundColor = _normalBackgroundColor;
#endif
                }
                
                if (_backgroundImage != nil)
                {
                    _backgroundImageView.image = _backgroundImage;
                }
                else
                {
                    if (_title != nil)
                    {
                        //self.titleLabel.text = title?
#if TARGET_OS_OSX

#else
                        [self bringSubviewToFront:_titleLabel];
#endif
                        _selectedTitleLabel.hidden = true;
                        _highlightedTitleLabel.hidden = true;
                        _titleLabel.hidden = false;
                    }
                    
                    /*
                     if (_titleColor != nil)
                     {
                     self.titleLabel.textColor = _titleColor;
                     self.selectedTitleLabel.textColor = _titleColor;
                     self.highlightedTitleLabel.textColor = _titleColor;
                     
                     }
                     */
                }
            }
            
        }
        
    


}



-(void)setNormalBackgroundColor:(CocoaColor*)color
{
    _normalBackgroundColor = color;
    if (!_selected && !_highlighted)
    {
#if TARGET_OS_OSX
        self.layer.backgroundColor = _normalBackgroundColor.CGColor;
#else
        self.backgroundColor = _normalBackgroundColor;
#endif
        _titleLabel.backgroundColor = [CocoaColor clearColor];

    }
    else
        _titleLabel.backgroundColor = _normalBackgroundColor;

}

 -(void)setHighlightedBackgroundColor:(CocoaColor*)color
 {
     _highlightedBackgroundColor = color;

     if (_highlighted)
     {
#if TARGET_OS_OSX
         self.layer.backgroundColor = _highlightedBackgroundColor.CGColor;
#else
         self.backgroundColor = _highlightedBackgroundColor;
#endif
         _highlightedTitleLabel.backgroundColor = [CocoaColor clearColor];

     }
     else
         _highlightedTitleLabel.backgroundColor = _highlightedBackgroundColor;

 }

 -(void)setSelectedBackgroundColor:(CocoaColor*)color
 {
     _selectedBackgroundColor = color;
     if (_selected && !_highlighted)
     {
#if TARGET_OS_OSX
         self.layer.backgroundColor = _selectedBackgroundColor.CGColor;
#else
         self.backgroundColor = _selectedBackgroundColor;
#endif
         _selectedTitleLabel.backgroundColor = [CocoaColor clearColor];

     }
     else
         _selectedTitleLabel.backgroundColor = _selectedBackgroundColor;

 }






-(void)setBackgroundImage:(CocoaImage*)image
{
    _backgroundImage = image;
    if (!_selected && !_highlighted)
    {
        _backgroundImageView.image = _backgroundImage;
    }
    
}

-(void) highlightedBackgroundImage:(CocoaImage*)image
{

    _highlightedBackgroundImage = image;
    if (_highlighted)
    {
            _backgroundImageView.image = _highlightedBackgroundImage;
    }
}

-(void) selectedBackgroundImage:(CocoaImage*)image
{
    _selectedBackgroundImage = image;
    if (_selected && !_highlighted)
    {
        _backgroundImageView.image =  _selectedBackgroundImage;
    }
    
}




-(void) setTitle:(NSString*)title
{

        _title = title;
        
#if TARGET_OS_OSX
#else
        _titleLabel.text = title;
#endif
}

-(void) setHighlightedTitle:(NSString*)title
{
    
        _highlightedTitle = title;
    
#if TARGET_OS_OSX
#else

        _highlightedTitleLabel.text = _highlightedTitle;
#endif
    
}

-(void) setSelectedTitle:(NSString*)title
{

        _selectedTitle = title;
#if TARGET_OS_OSX
#else
    _selectedTitleLabel.text = _selectedTitle;
#endif
    
}



-(void) setTitleColor:(CocoaColor*)color
{
    _titleColor = color;
    _titleLabel.textColor = _titleColor;
        

    
}

-(void) setHighlightedTitleColor:(CocoaColor*)color
{
        _highlightedTitleColor = color;
        _highlightedTitleLabel.textColor = _highlightedTitleColor;
    
    
}

-(void) setSelectedTitleColor:(CocoaColor*)color
{
        _selectedTitleColor = color;
        _selectedTitleLabel.textColor = _selectedTitleColor;
    
}



-(void) createBackgroundImageView
{
    _backgroundImageView = [[CocoaImageView alloc ] init];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
#if TARGET_OS_OSX
    _backgroundImageView.layer.backgroundColor = [CocoaColor clearColor].CGColor;
#else
    _backgroundImageView.backgroundColor = [CocoaColor clearColor];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
#endif
    
    [self addSubview:_backgroundImageView];
    
    [self addBackgroundImageViewConstraintsToItem:self fromItem:_backgroundImageView];
}

-(void) createTitleLabelSet
{
    self.titleLabel = [[RSMaskedLabel alloc ] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
#if TARGET_OS_OSX

#else
    _titleLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //titleLabel.contentMode = .ScaleAspectFit;
    
    self.selectedTitleLabel = [[RSMaskedLabel alloc] init];
    self.selectedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
#if TARGET_OS_OSX

#else
    _selectedTitleLabel.textAlignment = NSTextAlignmentCenter;
#endif
    self.highlightedTitleLabel = [[RSMaskedLabel alloc] init];
    self.highlightedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
#if TARGET_OS_OSX

#else
    _highlightedTitleLabel.textAlignment = NSTextAlignmentCenter;
#endif
    
    
    self.selectedTitleLabel.hidden = true;
    self.highlightedTitleLabel.hidden = true;
    
    [self addSubview:_titleLabel];
    [self addSubview:_selectedTitleLabel];
    [self addSubview:_highlightedTitleLabel];
    
    
    [self addBackgroundImageViewConstraintsToItem:self fromItem:_titleLabel];
    [self addBackgroundImageViewConstraintsToItem:self fromItem:_selectedTitleLabel];
    [self addBackgroundImageViewConstraintsToItem:self fromItem:_highlightedTitleLabel];
    
    
    
}

-(void) addBackgroundImageViewConstraintsToItem:(CocoaView*)toItem fromItem: (CocoaView*)fromItem
{
    

    
    NSLayoutConstraint * leading = [NSLayoutConstraint constraintWithItem: fromItem
                                                                attribute: NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: toItem attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0f constant:0.0f];
    
    
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: fromItem
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: toItem attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * trailing = [NSLayoutConstraint constraintWithItem: fromItem
                                                              attribute: NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: toItem attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0 constant:0];
    
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem: fromItem
                                                               attribute: NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem: toItem attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0 constant:0.0];
    
    
    [toItem addConstraints:@[  leading, trailing, top, bottom ]];
    
}


#if TARGET_OS_OSX
-(void) mouseDown:(CocoaEvent *)event
{
    _touchDown = true;
    //NSLog(@"mouseDown:");

    if (_delegate && [_delegate respondsToSelector:@selector(cbvTouchDown:)] )
    {
        [self.delegate cbvTouchDown:self];
    }
    
    if (_highlighted == false)
    {
        [self setHighlighted:true];
    }
    
    [super mouseDown:event];
    
}

-(void) mouseUp:(CocoaEvent *)event
{
    //NSLog(@"mouseUp:");

    if (_delegate && [_delegate respondsToSelector:@selector(cbvTouchUpInside:)] && _touchDown )
    {
        [self.delegate cbvTouchUpInside:self];
    }
    
    _touchDown = false;

    if (_highlighted == false)
    {
        [self setHighlighted:true];
    }
    
    [super mouseUp:event];
}

-(void) mouseEntered:(CocoaEvent *)event
{
    //NSLog(@"mouseEntered:");

    /*
     let touchCount = touches.count
     let touch = touches.anyObject() as UITouch
     let tapCount = touch.tapCount
     
     let touchPoint = touch.locationInView(self)
     
     let touchView = touch.view
     */
    
    //delegate!.cbvTouchesBegan!(self) //assuming the delegate is assigned otherwise error
    
    if (_delegate && [_delegate respondsToSelector:@selector(cbvEntered:)] )
    {
        [self.delegate cbvEntered:self];
    }
    
    if (_highlighted == false)
    {
        [self setHighlighted:true];
    }
    
    [super mouseEntered:event];
    
    
}

-(void) mouseMoved:(CocoaEvent *)event
{
    //NSLog(@"mouseMoved:");

    //NSPoint event_location = [event locationInWindow];
    //NSPoint local_point = [self convertPoint:event_location fromView:nil];

    //CGPoint mousePoint = CGPointMake(local_point.x, local_point.y);//[touch locationInView:self];

    //delegate!.cbvTouchesMoved!(self) //assuming the delegate is assigned otherwise error
    //CGRect obstacleViewFrame = [self convertRect:self.frame fromView: self.superview];
    
    /*
    if (CGRectContainsPoint(obstacleViewFrame, mousePoint) )
    {
        //NSLog("highlight true")
        if (_highlighted == false)
        {
            [self setHighlighted:true];
        }
    }
    else
    {
        //NSLog("highlight cancelled on move")
        if( _highlighted == true )
        {
            [self setHighlighted:false];
        }
    }
    */
    
    [super mouseMoved:event];
    
    
}

-(void) mouseExited:(CocoaEvent *)event
{
    _touchDown = false;

    //NSPoint event_location = [event locationInWindow];
    //NSPoint local_point = [self convertPoint:event_location fromView:nil];

    //CGPoint mousePoint = CGPointMake(local_point.x, local_point.y);//[touch locationInView:self];
    
    //NSLog(@"mouseExited:");

    /*
     dispatch_async(dispatch_get_main_queue())
     {
     [weak self] a in
     
     self!.highlighted = false
     }
     */
    
    //CGRect obstacleViewFrame = [self convertRect:self.frame fromView: self.superview];
    
    //if (CGRectContainsPoint(obstacleViewFrame, mousePoint))
    //{
        //touchUpInsideBlock!()
        if (_delegate && [_delegate respondsToSelector:@selector(cbvExited:)] )
        {
            
            [self.delegate cbvExited:self];
        }
        
        
        
    //}
    
    //let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
    //dispatch_async(queue, { [unowned self] a in
    //println("gcd hello")
    //    dispatch_sync(dispatch_get_main_queue())
    //    {
    if( _highlighted == true )
    {
        [self setHighlighted:false];
    }
    //    }
    //})
    
    
    //delegate!.cbvTouchesEnded(self) //assuming the delegate is assigned otherwise error
    

    [super mouseExited:event];
    
    
    
    
}

#else

-(void) touchesBegan:(NSSet *)touches withEvent:(CocoaEvent *)event
{

    //NSLog(@"touches began");

    /*
     let touchCount = touches.count
     let touch = touches.anyObject() as UITouch
     let tapCount = touch.tapCount
     
     let touchPoint = touch.locationInView(self)
     
     let touchView = touch.view
     */
    
    //delegate!.cbvTouchesBegan!(self) //assuming the delegate is assigned otherwise error
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(cbvTouchDown:)] )
    {
        
        [self.delegate cbvTouchDown:self];
    }
    
    if (_highlighted == false)
    {
        [self setHighlighted:true];
    }
    
    [super touchesBegan:touches withEvent:event];
    
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(CocoaEvent *)event
{
    
    UITouch * touch = (UITouch*)[touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //delegate!.cbvTouchesMoved!(self) //assuming the delegate is assigned otherwise error
    CGRect obstacleViewFrame = [self convertRect:touch.view.frame fromView: touch.view.superview];
    
    
    if (CGRectContainsPoint(obstacleViewFrame, touchPoint) )
    {
        //NSLog("highlight true")
        if (_highlighted == false)
        {
            [self setHighlighted:true];
        }
    }
    else
    {
        //NSLog("highlight cancelled on move")
        if( _highlighted == true )
        {
            [self setHighlighted:false];
        }
    }
    
    [super touchesMoved:touches  withEvent:event];
    
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(CocoaEvent *)event
{
    
    UITouch * touch = (UITouch*)[touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    
    //NSLog("touches ended")
    
    /*
     dispatch_async(dispatch_get_main_queue())
     {
     [weak self] a in
     
     self!.highlighted = false
     }
     */
    
    CGRect obstacleViewFrame = [self convertRect:touch.view.frame fromView: touch.view.superview];
    
    
    if (CGRectContainsPoint(obstacleViewFrame, touchPoint))
    {
        //touchUpInsideBlock!()
        if (_delegate && [_delegate respondsToSelector:@selector(cbvTouchUpInside:)] )
        {
            
            [self.delegate cbvTouchUpInside:self];
        }
        
        
        
    }
    
    //let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
    //dispatch_async(queue, { [unowned self] a in
    //println("gcd hello")
    //    dispatch_sync(dispatch_get_main_queue())
    //    {
    if( _highlighted == true )
    {
        [self setHighlighted:false];
    }
    //    }
    //})
    
    
    //delegate!.cbvTouchesEnded(self) //assuming the delegate is assigned otherwise error
    
    
    [super touchesEnded:touches  withEvent:event];
    
    
    
    
}


#endif

@end
