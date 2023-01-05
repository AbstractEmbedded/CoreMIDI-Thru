//
//  RSMaskedLabelView.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 2013-02-07.
//  Copyright (c) 2013 Nulayer. All rights reserved.
//

#import "RSMaskedLabel.h"

@interface RSMaskedLabel()
{
    bool applyMasking;

}
- (void) RS_commonInit;
- (void) RS_drawBackgroundInRect:(CGRect)rect;
@end

@implementation RSMaskedLabel
{
	CocoaColor* maskedBackgroundColor;
}

@synthesize textColor = _textColor;


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
        [self RS_commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        [self RS_commonInit];
    return self;
}

- (CocoaColor*) backgroundColor
{
	return maskedBackgroundColor;
}

- (void) setBackgroundColor:(CocoaColor *)backgroundColor
{
	maskedBackgroundColor = backgroundColor;
    self.needsDisplay = YES;
}

- (void)RS_commonInit
{
    maskedBackgroundColor = [super backgroundColor];
    [super setTextColor:[CocoaColor whiteColor]];
    [super setBackgroundColor:[CocoaColor clearColor]];
    
#if TARGET_OS_OSX
    self.editable = NO;
    
    self.focusRingType = NSFocusRingTypeNone;
#else
    [self setOpaque:NO];
#endif
    applyMasking = true;
}

- (void)setTextColor:(CocoaColor *)textColor
{


    if( [textColor isEqual: [CocoaColor clearColor] ] )
    {
        NSLog(@"RSMasked Label set text color clear");

        // text color needs to be white for masking to work
        [super setTextColor:[CocoaColor whiteColor]];
        //[super setBackgroundColor:[UIColor clearColor]];
        
#if TARGET_OS_OSX
#else
        [self setOpaque:NO];
#endif
        applyMasking = true;
    
    }
    else
    {
        
        [super setBackgroundColor:maskedBackgroundColor];
        _textColor = textColor;
        [super setTextColor:_textColor];
        applyMasking = false;
    }
    
    self.needsDisplay = YES;

}

- (void)drawRect:(CGRect)rect
{

    if( applyMasking )
    {
#if TARGET_OS_OSX
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
#else
        CGContextRef context = UIGraphicsGetCurrentContext();
#endif
    // let the superclass draw the label normally
    [super drawRect:rect];

    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect)));
    
    // create a mask from the normally rendered text
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetBitsPerPixel(image), CGImageGetBytesPerRow(image), CGImageGetDataProvider(image), CGImageGetDecode(image), CGImageGetShouldInterpolate(image));
    
    CFRelease(image); image = NULL;
    
    // wipe the slate clean
    CGContextClearRect(context, rect);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, mask);

	if (self.layer.cornerRadius != 0.0f) {
		CGContextAddPath(context, CGPathCreateWithRoundedRect(rect, self.layer.cornerRadius, self.layer.cornerRadius, nil));
		CGContextClip(context);
	}

    CFRelease(mask);  mask = NULL;
    
    [self RS_drawBackgroundInRect:rect];
    
    CGContextRestoreGState(context);
    }
    else
    {
        // let the superclass draw the label normally
        [super drawRect:rect];
    }
    
}

- (void) RS_drawBackgroundInRect:(CGRect)rect
{
    // this is where you do whatever fancy drawing you want to do!
#if TARGET_OS_OSX
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
#else
    CGContextRef context = UIGraphicsGetCurrentContext();
#endif
    
	[maskedBackgroundColor set];
    CGContextFillRect(context, rect);
}

@end
