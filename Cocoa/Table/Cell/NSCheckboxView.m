//
//  NSCheckboxView.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/31/22.
//

#import "NSCheckboxView.h"

@interface NSCheckboxView()
{
    
    
}

@property (nonatomic, retain) NSArray * identifiers;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) NSTextAlignment alignment;

@property (nonatomic, retain) NSTextField * titleLabel;
@property (nonatomic, retain) NSMutableArray * buttons;

@end

@implementation NSCheckboxView

@synthesize buttons = _buttons;

-(void)createTitleLabel
{
    if(self.title )
    {
        self.titleLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
        self.titleLabel.focusRingType = NSFocusRingTypeNone;
        self.titleLabel.stringValue = self.title;
        self.titleLabel.wantsLayer = YES;

        self.titleLabel.editable = YES;
        self.titleLabel.drawsBackground = YES;
        self.titleLabel.layer.masksToBounds = NO;
        
        //self.thruIDLabel.usesSingleLineMode = NO;
        //self.thruIDLabel.maximumNumberOfLines = 1;
        self.titleLabel.textColor = NSColor.blackColor;
        self.titleLabel.backgroundColor = [NSColor clearColor];
        self.titleLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
        self.titleLabel.alignment = self.alignment;
        
        self.titleLabel.bezeled         = NO;
        self.titleLabel.editable        = NO;
        self.titleLabel.drawsBackground = NO;
        
        [self addSubview:self.titleLabel];
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO
        
        if( self.alignment == NSTextAlignmentRight )
        {
            NSLayoutConstraint * justify = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                        attribute: NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self.buttons objectAtIndex:0]
                                                                        attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:-14.0f];

            NSLayoutConstraint * centery = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                        attribute: NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f];
            
            [self addConstraints:@[ justify, centery]];

        }

        
    }
}

- (void)checkboxToggled:(nullable id)sender
{
    NSLog(@"NSCheckboxView::checkboxToggled:");
    assert( [sender isKindOfClass:NSButton.class]);
    if(self.delegate && [self.delegate respondsToSelector:@selector(buttonToggledAtIndex:)])
       [self.delegate buttonToggledAtIndex:(int)((NSButton*)sender).tag];
}

-(void)createCheckboxArray
{
    self.buttons = [NSMutableArray arrayWithCapacity:self.identifiers.count];
    
    if( self.alignment == NSTextAlignmentRight )
    {
        NSButton * prevButton = [[NSButton alloc] initWithFrame:CGRectZero];
        [prevButton.cell setButtonType:NSButtonTypeSwitch];
        prevButton.title = [self.identifiers objectAtIndex:self.identifiers.count-1];
        prevButton.tag = self.identifiers.count-1;
        [prevButton setAction:@selector(checkboxToggled:)];
        [prevButton setTarget:self];
        
        //[prevButton performClick:YES];
        
        [self addSubview:prevButton];
        
        prevButton.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO
        NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:prevButton
                                                                    attribute: NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f];

        NSLayoutConstraint * centery = [NSLayoutConstraint constraintWithItem:prevButton
                                                                    attribute: NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f constant:0.0f];
        [self addConstraints:@[ right, centery]];
        [self.buttons addObject:prevButton];

        
        for( int i = (int)self.identifiers.count-2; i>-1; i--)
        {
            NSButton * button = [[NSButton alloc] initWithFrame:CGRectZero];
            [button.cell setButtonType:NSButtonTypeSwitch];
            button.title = [self.identifiers objectAtIndex:i];
            button.tag = i;
            [button setAction:@selector(checkboxToggled:)];
            [button setTarget:self];
            
            [self addSubview:button];
            button.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO

            right = [NSLayoutConstraint constraintWithItem:button
                                                                        attribute: NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:prevButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:0.0f];
            centery = [NSLayoutConstraint constraintWithItem:button
                                                                        attribute: NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f];
            [self addConstraints:@[ right, centery]];

            [self.buttons addObject:button];
            prevButton = button;
        }
        
        //reverse the array of buttons
        self.buttons = [NSMutableArray arrayWithArray:[[self.buttons reverseObjectEnumerator] allObjects]];
        
        [self createTitleLabel];
    }
    else
    {
        
        NSButton * prevButton = [[NSButton alloc] initWithFrame:CGRectZero];
        [prevButton.cell setButtonType:NSButtonTypeSwitch];
        prevButton.title = [self.identifiers objectAtIndex:0];
        prevButton.tag = 0;
        //[prevButton setAction:@selector(buttonToggled:)];

        [self addSubview:prevButton];
        
        prevButton.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO
        NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:prevButton
                                                                    attribute: NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f];

        NSLayoutConstraint * centery = [NSLayoutConstraint constraintWithItem:prevButton
                                                                    attribute: NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f constant:0.0f];
        [self addConstraints:@[ left, centery]];
        [self.buttons addObject:prevButton];

        
        for( int i = 1; i<self.identifiers.count; i++)
        {
            NSButton * button = [[NSButton alloc] initWithFrame:CGRectZero];
            [button.cell setButtonType:NSButtonTypeSwitch];
            button.title = [self.identifiers objectAtIndex:i];
            button.tag = i;
            //[button setAction:@selector(buttonToggled:)];
            [self addSubview:button];
            button.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO

            left = [NSLayoutConstraint constraintWithItem:button
                                                                        attribute: NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:prevButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:0.0f];
            centery = [NSLayoutConstraint constraintWithItem:button
                                                                        attribute: NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f];
            [self addConstraints:@[ left, centery]];

            [self.buttons addObject:button];
            prevButton = button;
        }
        
        
    }

}

-(id)initWithIdentifiers:(NSArray*)identifiers Title:(NSString* _Nullable)title Justification:(NSTextAlignment)alignment
{
    self = [super initWithFrame:CGRectZero];
    if( self )
    {
        self.identifiers = identifiers;
        self.title = title;
        self.alignment = alignment;

        [self createCheckboxArray];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
