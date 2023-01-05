//
//  CMLogoView.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/30/22.
//

#import "CMLogoView.h"
#import "NSColor+3rdGen.h"

@interface CMLogoView()
{
    
}

@property (nonatomic, retain) NSTextField * logoLabel;

@end


@implementation CMLogoView


//FYI, the width of the title label is currently controlling the width of the popover view!!!
//And the width of the title label is determined by font size + sizetofit
-(void) createLogoLabel
{
    self.logoLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,0,200,100)];
    
    NSFont * font =  [NSFont fontWithName:@"Helvetica" size:23.f/150.f * self.frame.size.width];
    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [NSColor whiteColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"MIDI\nThru" attributes:attributes];
    
    self.logoLabel.focusRingType = NSFocusRingTypeNone;
    //self.logoLabel.stringValue  = @"MIDI\nThru";
    self.logoLabel.stringValue = @"MIDI\nThru";
    self.logoLabel.font = font;//[NSFont systemFontOfSize:24.5];
    self.logoLabel.wantsLayer = YES;
    //self.thruIDLabel.bordered = YES;
    
    //self.thruIDLabel.enabled = YES;
    self.logoLabel.editable = YES;
    self.logoLabel.drawsBackground = YES;
    self.logoLabel.layer.masksToBounds = NO;
    
    self.logoLabel.usesSingleLineMode = NO;
    self.logoLabel.maximumNumberOfLines = 2;
    self.logoLabel.textColor = [NSColor colorWithWhite:255./255. alpha:1.f];
    self.logoLabel.backgroundColor = [NSColor clearColor];
    self.logoLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.thruIDLabel.delegate = self;
    self.logoLabel.alignment = NSTextAlignmentCenter;
    
    self.logoLabel.bezeled         = NO;
    self.logoLabel.editable        = NO;
    self.logoLabel.drawsBackground = NO;
    [self addSubview:self.logoLabel];
    
    self.logoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * CenterX = [NSLayoutConstraint constraintWithItem: self.logoLabel
                                                                attribute: NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterX
                                                               multiplier:1 constant:0];
    
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.logoLabel
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeCenterY
                                                               multiplier:1 constant:+1.0 * attributedString.size.height*(1./6.)];
    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem: self.logoLabel
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeWidth
                                                             multiplier:0.8 constant:0];

    
    [self addConstraints:@[ CenterX, CenterY, Width ]];
    
    [self.logoLabel sizeToFit];

}

-(id)initWithFrame:(CGRect)frameRect{
    
    self = [super initWithFrame:frameRect];
    if(self)
    {
        /*
        //This will override the draw fill
        self.backgroundColor = [NSColor clearColor];
        //This will allow the draw fill
        [self setDrawsBackground:NO];
         */
        
        [self createLogoLabel];
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor clearColor] setFill];
    [NSBezierPath fillRect:dirtyRect];
    // Drawing code here.
    
    CGFloat strokeWidth = 3.0f;
    
    NSBezierPath * fillPath = [NSBezierPath bezierPathWithOvalInRect:dirtyRect];
    [[NSColor logoPrimaryColor] setFill];
    [fillPath fill];
    
    CGRect insetRect = CGRectMake(dirtyRect.origin.x + strokeWidth/2., dirtyRect.origin.y+strokeWidth/2., dirtyRect.size.width - strokeWidth, dirtyRect.size.height-strokeWidth);
    NSBezierPath * strokePath = [NSBezierPath bezierPathWithOvalInRect:insetRect];
    [[NSColor logoAccentColor] setStroke];
    strokePath.lineWidth = strokeWidth;
    [strokePath stroke];
    
    
    CGFloat circleRadius = 15.f;
    CGRect circleRect = CGRectMake( dirtyRect.size.width/2. - circleRadius/2., dirtyRect.size.height * 0.85f - circleRadius/2., circleRadius, circleRadius);
    NSBezierPath * fillCircle1 = [NSBezierPath bezierPathWithOvalInRect:circleRect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle1 fill];
    
    CGRect circle2Rect = CGRectMake( circleRect.origin.x - 30., circleRect.origin.y - 8, circleRadius, circleRadius);
    NSBezierPath * fillCircle2 = [NSBezierPath bezierPathWithOvalInRect:circle2Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle2 fill];
    
    CGRect circle3Rect = CGRectMake( circleRect.origin.x + 30., circleRect.origin.y - 8, circleRadius, circleRadius);
    NSBezierPath * fillCircle3 = [NSBezierPath bezierPathWithOvalInRect:circle3Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle3 fill];
    
    CGRect circle4Rect = CGRectMake( circleRect.origin.x - 50., circleRect.origin.y - 30, circleRadius, circleRadius);
    NSBezierPath * fillCircle4 = [NSBezierPath bezierPathWithOvalInRect:circle4Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle4 fill];
    
    CGRect circle5Rect = CGRectMake( circleRect.origin.x + 50., circleRect.origin.y - 30, circleRadius, circleRadius);
    NSBezierPath * fillCircle5 = [NSBezierPath bezierPathWithOvalInRect:circle5Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle5 fill];
    
}

@end
