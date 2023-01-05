//
//  CMThruModalView.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/28/22.
//

#import "CMThruModalView.h"
#import "CMidiAppInterface.h"

#import <Foundation/NSObjcRuntime.h>
#import <objc/runtime.h>

#import "CMThruApplicationDelegate.h"
#import "CMThruScrollListView.h"

#import "CustomIndicatorView.h"
#import "NSTextFieldButton.h"

#import "CMLogoView.h"
#import "NSCheckboxView.h"

@interface CMThruModalView()
{
    
    CMThruScrollListView * _scrollListView;

    NSTextField *_thruIDLabel;
    NSTextField *_inputDeviceLabel;
    NSTextField *_outputDeviceLabel;

    
    NSMutableDictionary * _inputFields;
    NSMutableDictionary * _fieldButtons;
    
    CocoaTextField *_csvField;
    CocoaTextField *_dirField;
    
    NSButton * _submitButton;
    NSButton * _deleteButton;
    NSButton * _cancelButton;
    
    volatile bool _userInteractionEnabled;
}

//@property (nonatomic, retain) NSImageView * imageView;
@property (nonatomic, retain) CMLogoView * imageView;

//Labels
@property (nonatomic, retain) NSTextField * thruIDLabel;
@property (nonatomic, retain) NSTextField * inputDeviceLabel;
@property (nonatomic, retain) NSTextField * outputDeviceLabel;
@property (nonatomic, retain) NSTextField * filterLabel;

//TextFields
@property (nonatomic, retain) NSTextField   * thruIDField;
@property (nonatomic, retain) NSPopUpButton * inputPopupButton;
@property (nonatomic, retain) NSPopUpButton * outputPopupButton;
@property (nonatomic, retain) NSCheckboxView * filterView;

//Toolbar
@property (nonatomic, retain) NSView * bottomToolbar;


@property (nonatomic, retain) NSScrollView * scrollView;
@property (nonatomic, retain) NSView * scrollDocumentView;

@property (nonatomic) int modalViewMode;
@property (nonatomic) int type;

@property (nonatomic, retain) CMThruConnection * dataModel;

@property (atomic) bool userInteractionEnabled;


@property (nonatomic, retain) NSMutableArray * inputFieldKeys;
@property (nonatomic, retain) NSMutableDictionary *inputFields;
@property (nonatomic, retain) NSMutableDictionary *fieldButtons;

@property (nonatomic, retain) NSMutableArray * modalButtons;

@property (nonatomic, retain) NSButton * submitButton;
@property (nonatomic, retain) NSButton * helpButton;

@property (nonatomic, retain) NSButton * cancelButton;

@property (nonatomic, retain) CustomIndicatorView * indicatorView;

@end

@implementation CMThruModalView

@synthesize thruIDLabel = _thruIDLabel;
@synthesize inputDeviceLabel = _inputDeviceLabel;
@synthesize outputDeviceLabel = _outputDeviceLabel;


@synthesize inputFields = _inputFields;

@synthesize cancelButton = _cancelButton;



-(void)createScrollListView
{
    _scrollListView = [[CMThruScrollListView alloc] initWithFrame:CGRectMake(14,0,self.frame.size.width - 28, 100) andDOM:self.dataModel];
    _scrollListView.wantsLayer = YES;
    _scrollListView.layer.backgroundColor = [NSColor clearColor].CGColor;
    [self addSubview:_scrollListView];
    
    
    //_scrollListView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:14];

   
    NSLayoutConstraint * CenterX = [NSLayoutConstraint constraintWithItem:_scrollListView
                                                                attribute: NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f constant:0];

   
    [self addConstraints:@[ Top, CenterX]];
    
}

-(void)createImageView
{
    
    //self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0,0,150, 150)];
    //self.imageView.image = [NSImage imageNamed:NSImageNameNetwork];
    self.imageView = [[CMLogoView alloc] initWithFrame:CGRectMake(0,0,150, 150)];
    
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2.0;
    [self addSubview:self.imageView];
    
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:14];

    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute: NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f constant:20.0f];

    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute: NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                 multiplier:0.25f constant:0.0f];
    
    NSLayoutConstraint * Height = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute: NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                 multiplier:0.25f constant:0];
    [self addConstraints:@[ Top, Left, Width, Height]];
}


//FYI, the width of the title label is currently controlling the width of the popover view!!!
//And the width of the title label is determined by font size + sizetofit
-(void) createThruIDLabel
{
    self.thruIDLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
    
    self.thruIDLabel.focusRingType = NSFocusRingTypeDefault;
    self.thruIDLabel.stringValue  = @"ThruID:";
    //_thruIDLabel.font = [NSFont systemFontOfSize:36.0];
    self.thruIDLabel.wantsLayer = YES;
    //self.thruIDLabel.bordered = YES;
    
    //self.thruIDLabel.enabled = YES;
    self.thruIDLabel.editable = YES;
    self.thruIDLabel.drawsBackground = YES;
    self.thruIDLabel.layer.masksToBounds = NO;
    
    //self.thruIDLabel.usesSingleLineMode = NO;
    //self.thruIDLabel.maximumNumberOfLines = 1;
    self.thruIDLabel.textColor = NSColor.blackColor;
    self.thruIDLabel.backgroundColor = [NSColor clearColor];
    self.thruIDLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.thruIDLabel.delegate = self;
    self.thruIDLabel.alignment = NSTextAlignmentRight;
    
    _thruIDLabel.bezeled         = NO;
    _thruIDLabel.editable        = NO;
    _thruIDLabel.drawsBackground = NO;
    
    [self addSubview:self.thruIDLabel];
    

    self.thruIDLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.thruIDLabel
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.imageView attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:8.f];
    
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.thruIDLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.imageView attribute:NSLayoutAttributeTop
                                                               multiplier:1.0 constant:14.f];
    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem: self.thruIDLabel
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.imageView attribute:NSLayoutAttributeWidth
                                                             multiplier:0.7f constant:0];

    
    [self addConstraints:@[ Left, Top, Width ]];
}


//FYI, the width of the title label is currently controlling the width of the popover view!!!
//And the width of the title label is determined by font size + sizetofit
-(void) createInputDeviceLabel
{
    self.inputDeviceLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
    
    self.inputDeviceLabel.focusRingType = NSFocusRingTypeDefault;
    self.inputDeviceLabel.stringValue  = @"Input Device:";
    self.inputDeviceLabel.wantsLayer = YES;
    
    self.inputDeviceLabel.editable = YES;
    self.inputDeviceLabel.drawsBackground = YES;
    self.inputDeviceLabel.layer.masksToBounds = NO;

    self.inputDeviceLabel.textColor = NSColor.blackColor;
    self.inputDeviceLabel.backgroundColor = [NSColor clearColor];
    self.inputDeviceLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.thruIDLabel.delegate = self;
    self.inputDeviceLabel.alignment = NSTextAlignmentRight;
    
    _inputDeviceLabel.bezeled         = NO;
    _inputDeviceLabel.editable        = NO;
    _inputDeviceLabel.drawsBackground = NO;
    
    [self addSubview:self.inputDeviceLabel];
    

    self.inputDeviceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.inputDeviceLabel
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.thruIDLabel attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];
    
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.inputDeviceLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.thruIDLabel attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:21.f];
    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem: self.inputDeviceLabel
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.thruIDLabel attribute:NSLayoutAttributeWidth
                                                             multiplier:1 constant:0];

    
    [self addConstraints:@[ Left, Top, Width ]];
}


//FYI, the width of the title label is currently controlling the width of the popover view!!!
//And the width of the title label is determined by font size + sizetofit
-(void) createOutputDeviceLabel
{
    self.outputDeviceLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
    
    self.outputDeviceLabel.focusRingType = NSFocusRingTypeDefault;
    self.outputDeviceLabel.stringValue  = @"Output Device:";
    self.outputDeviceLabel.wantsLayer = YES;
    
    self.outputDeviceLabel.lineBreakMode = NSLineBreakByClipping;
    self.outputDeviceLabel.usesSingleLineMode = YES;
    self.outputDeviceLabel.maximumNumberOfLines = YES;
    
    self.outputDeviceLabel.editable = YES;
    self.outputDeviceLabel.drawsBackground = YES;
    self.outputDeviceLabel.layer.masksToBounds = NO;
    
    self.outputDeviceLabel.textColor = NSColor.blackColor;
    self.outputDeviceLabel.backgroundColor = [NSColor clearColor];
    self.outputDeviceLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.thruIDLabel.delegate = self;
    self.outputDeviceLabel.alignment = NSTextAlignmentRight;

    _outputDeviceLabel.bezeled         = NO;
    _outputDeviceLabel.editable        = NO;
    _outputDeviceLabel.drawsBackground = NO;
    
    [self addSubview:self.outputDeviceLabel];
    

    self.outputDeviceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.outputDeviceLabel
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.inputDeviceLabel attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];
    
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.outputDeviceLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.inputDeviceLabel attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:21.f];
    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem: self.outputDeviceLabel
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.inputDeviceLabel attribute:NSLayoutAttributeWidth
                                                             multiplier:1 constant:0];

    
    [self addConstraints:@[ Left, Top, Width ]];
}


-(void)createThruIDTextField
{
    self.thruIDField = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
    
    self.thruIDField.focusRingType = NSFocusRingTypeDefault;
    self.thruIDField.stringValue  = self.dataModel.ThruID ? self.dataModel.ThruID : @"";
    self.thruIDField.placeholderString = @"Enter ThruID";
    //_thruIDLabel.font = [NSFont systemFontOfSize:36.0];
    self.thruIDField.wantsLayer = YES;
    //self.thruIDLabel.bordered = YES;
    
    //self.thruIDLabel.enabled = YES;
    self.thruIDField.editable = YES;
    self.thruIDField.drawsBackground = YES;
    self.thruIDField.layer.masksToBounds = NO;
    
    self.thruIDField.textColor = NSColor.blackColor;
    //self.thruIDField.backgroundColor = [NSColor clearColor];
    //self.thruIDField.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.thruIDField.delegate = self;
    self.thruIDField.alignment = NSTextAlignmentLeft;
    
    _thruIDField.bezeled         = YES;
    _thruIDField.editable        = YES;
    _thruIDField.drawsBackground = YES;
    
    [self addSubview:self.thruIDField];
    

    self.thruIDField.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.thruIDField
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.thruIDLabel attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:14.f];
    
    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.thruIDField
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:-14.f];
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.thruIDField
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.thruIDLabel attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0 constant:0.f];
    

    
    [self addConstraints:@[ CenterY, Left, Right ]];
}

-(void)devicePopupButtonClicked:(id)sender
{
    //NSLog(@"inputPopupButton select: %@", sender.)
    
    //if the string associated with the selected index does not equal our existing string
    
    if( self.modalViewMode == ModalView_Modify )
    {
        if( sender == self.inputPopupButton )
        {
            int selectedIndex = (int)self.inputPopupButton.indexOfSelectedItem;
            NSString * inputDeviceName = [NSString stringWithUTF8String:CMClient.sources[selectedIndex].name];
            if( [_dataModel.Input localizedCompare:inputDeviceName] != NSOrderedSame )
            {
                self.submitButton.enabled = YES;
            }
        }
        else if( sender == self.outputPopupButton )
        {
            int selectedIndex = (int)self.outputPopupButton.indexOfSelectedItem;
            NSString * deviceName = [NSString stringWithUTF8String:CMClient.destinations[selectedIndex].name];
            if( [_dataModel.Output localizedCompare:deviceName] != NSOrderedSame )
            {
                self.submitButton.enabled = YES;
            }
        }
        
    }
}

-(void)createInputPopupButton
{
    self.inputPopupButton = [[NSPopUpButton alloc] initWithFrame:CGRectZero pullsDown:NO];
    self.inputPopupButton.enabled = YES;
    
    [self.inputPopupButton setAction:@selector(devicePopupButtonClicked:)];
    
    int srcIndex = 0;
    for( int i = 0; i < CMClient.numSources; i++)
    {
        [self.inputPopupButton addItemWithTitle:[NSString stringWithUTF8String:CMClient.sources[i].name]];
        if( strcmp(_dataModel.connection->source.name, CMClient.sources[i].name) == 0 ) srcIndex = i;
    }
    
    if( self.modalViewMode == ModalView_Modify) [self.inputPopupButton selectItemAtIndex:srcIndex];
    [self addSubview:self.inputPopupButton];
    

    self.inputPopupButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.inputPopupButton
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.inputDeviceLabel attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:14.f];
    
    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.inputPopupButton
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:-14.f];
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.inputPopupButton
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.inputDeviceLabel attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0 constant:0.f];
    

    
    [self addConstraints:@[ CenterY, Left, Right ]];
}



-(void)createOutputPopupButton
{
    self.outputPopupButton = [[NSPopUpButton alloc] initWithFrame:CGRectZero pullsDown:NO];
    self.outputPopupButton.enabled = YES;
    [self.outputPopupButton setAction:@selector(devicePopupButtonClicked:)];

    
    int dstIndex=0;
    for( int i = 0; i < CMClient.numDestinations; i++)
    {
        [self.outputPopupButton addItemWithTitle:[NSString stringWithUTF8String:CMClient.destinations[i].name]];
        if(strcmp(_dataModel.connection->destination.name, CMClient.destinations[i].name) == 0 )dstIndex = i;
    }
    
    if( self.modalViewMode == ModalView_Modify) [self.outputPopupButton selectItemAtIndex:dstIndex];
    else if( self.outputPopupButton.numberOfItems > 1 ) [self.outputPopupButton selectItemAtIndex:1];

    [self addSubview:self.outputPopupButton];
    

    self.outputPopupButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.outputPopupButton
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputDeviceLabel attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:14.f];
    
    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.outputPopupButton
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:-14.f];
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.outputPopupButton
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputDeviceLabel attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0 constant:0.f];
    

    
    [self addConstraints:@[ CenterY, Left, Right ]];
}


-(void) createFilterLabel
{
    self.filterLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0,200,200,100)];
    
    self.filterLabel.focusRingType = NSFocusRingTypeDefault;
    self.filterLabel.stringValue  = @"Filter:";
    self.filterLabel.wantsLayer = YES;
    
    self.filterLabel.lineBreakMode = NSLineBreakByClipping;
    self.filterLabel.usesSingleLineMode = YES;
    self.filterLabel.maximumNumberOfLines = YES;
    
    self.filterLabel.editable = YES;
    self.filterLabel.drawsBackground = YES;
    self.filterLabel.layer.masksToBounds = NO;
    
    self.filterLabel.textColor = NSColor.blackColor;
    self.filterLabel.backgroundColor = [NSColor clearColor];
    self.filterLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    //self.thruIDLabel.delegate = self;
    self.filterLabel.alignment = NSTextAlignmentRight;

    self.filterLabel.bezeled         = NO;
    self.filterLabel.editable        = NO;
    self.filterLabel.drawsBackground = NO;
    
    [self addSubview:self.filterLabel];
    

    self.filterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.filterLabel
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputDeviceLabel attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];
    
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.filterLabel
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputDeviceLabel attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:14.];
    
    NSLayoutConstraint * Width = [NSLayoutConstraint constraintWithItem: self.filterLabel
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.outputDeviceLabel attribute:NSLayoutAttributeWidth
                                                             multiplier:1 constant:0];

    
    [self addConstraints:@[ Left, Top, Width ]];
}

-(void)buttonToggledAtIndex:(int)index;
{
    NSLog(@"CMThruModalView::buttonToggledAtIndex(%d)", index);
    if( self.modalViewMode == ModalView_Modify ) self.submitButton.enabled = YES;
}

-(void) createFilterView
{
    NSArray * filterIdentifiers = @[@"CC", @"SysEx", @"MTC", @"Beat Clock", @"Tune Request"];
    self.filterView = [[NSCheckboxView alloc] initWithIdentifiers:filterIdentifiers Title:@"Filter:  " Justification:NSTextAlignmentRight];
    self.filterView.delegate = self;
    
    if( self.modalViewMode == ModalView_Modify )
    {
        //for( NSButton * button in self.filterView.buttons ) button.enabled = NO;
        if( _dataModel.connection->params.filterOutAllControls ) ((NSButton*)[self.filterView.buttons objectAtIndex:0]).state = NSControlStateValueOn;
        if( _dataModel.connection->params.filterOutSysEx ) ((NSButton*)[self.filterView.buttons objectAtIndex:1]).state = NSControlStateValueOn;
        if( _dataModel.connection->params.filterOutMTC ) ((NSButton*)[self.filterView.buttons objectAtIndex:2]).state = NSControlStateValueOn;
        if( _dataModel.connection->params.filterOutBeatClock ) ((NSButton*)[self.filterView.buttons objectAtIndex:3]).state = NSControlStateValueOn;
        if( _dataModel.connection->params.filterOutTuneRequest ) ((NSButton*)[self.filterView.buttons objectAtIndex:4]).state = NSControlStateValueOn;
    }
    
    [self addSubview:self.filterView];
    self.filterView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.filterView
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];
    
    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.filterView
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:-14.f];
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.filterView
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputDeviceLabel attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:21.f];
    
    NSLayoutConstraint * Height = [NSLayoutConstraint constraintWithItem: self.filterView
                                                                attribute: NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.outputPopupButton attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0 constant:0.f];

    
    [self addConstraints:@[ Top, Left, Right, Height ]];
    
}


-(void)createBottomToolbar
{
    
    self.bottomToolbar = [[NSView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 50)];
    
    self.bottomToolbar.wantsLayer = YES;
    self.bottomToolbar.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.2].CGColor;
    
    //self.bottomToolbar.superview.wantsLayer = true
    self.bottomToolbar.shadow = [[NSShadow alloc] init];
    //self.bottomToolbar.layer.backgroundColor = [NSColor redColor].CGColor;
    //self.bottomToolbar.layer.cornerRadius = 5.0;
    self.bottomToolbar.layer.shadowOpacity = 1.0;
    self.bottomToolbar.layer.shadowColor = [NSColor colorWithWhite:0.3 alpha:1.0].CGColor;
    self.bottomToolbar.layer.shadowOffset = NSMakeSize(0, 0);
    self.bottomToolbar.layer.shadowRadius = 10;

    self.bottomToolbar.layer.borderWidth = 0.25;
    self.bottomToolbar.layer.borderColor = [NSColor colorWithWhite:0.7 alpha:1.0].CGColor;
    
    [self addSubview:self.bottomToolbar];
    
    //self.bottomToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint * Top = [NSLayoutConstraint constraintWithItem: self.bottomToolbar
                                                                attribute: NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.imageView attribute:NSLayoutAttributeBottom
                                                               multiplier:1 constant:14];
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.bottomToolbar
                                                                attribute: NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];

    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.bottomToolbar
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:0];

  

    
    [self addConstraints:@[ Top, Left, Right ]];
}

-(void)createSubmitButton
{
    self.submitButton = [[NSButton alloc] initWithFrame:CGRectMake(0,0,80,30)];//CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight)];
    // button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    self.submitButton.enabled = NO;
    
    [self.submitButton setTitle:@"Apply"];
    [self.submitButton setTarget:self];
    [self.submitButton setAction:@selector(submitButtonClicked:)];
    
    self.submitButton.wantsLayer = YES;
    self.submitButton.layer.backgroundColor = NSColor.clearColor.CGColor;
    self.submitButton.layer.borderColor = NSColor.clearColor.CGColor;
    self.submitButton.layer.borderWidth = 0;
    //self.submitButton.layer.cornerRadius = 4.0f;

    self.submitButton.shadow = [[NSShadow alloc] init];
    //self.bottomToolbar.layer.backgroundColor = [NSColor redColor].CGColor;
    //self.bottomToolbar.layer.cornerRadius = 5.0;
    self.submitButton.layer.shadowOpacity = 1.0;
    self.submitButton.layer.shadowColor = [NSColor colorWithWhite:0.3 alpha:1.0].CGColor;
    self.submitButton.layer.shadowOffset = NSMakeSize(0, 0.5);
    self.submitButton.layer.shadowRadius = 0.5;

    
    self.submitButton.contentTintColor = [NSColor colorWithWhite:0.9 alpha:1.0];
    self.submitButton.bezelStyle = NSBezelStyleRounded;
    
    //self.layer.backgroundColor =
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomToolbar addSubview:self.submitButton];
    
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * Right = [NSLayoutConstraint constraintWithItem: self.submitButton
                                                           attribute: NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem: self.bottomToolbar attribute:NSLayoutAttributeRight
                                                          multiplier:1.0f constant:-16.0f];
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.submitButton
                                                            attribute: NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: self.bottomToolbar attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0 constant:0];
    
    
    [self addConstraints:@[ Right, CenterY]];
    
}



-(void)createHelpButton
{
    self.helpButton = [[NSButton alloc] initWithFrame:CGRectMake(0,0,30,30)];//CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight)];
    // button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [self.helpButton setTitle:@""];
    [self.helpButton setTarget:self];
    [self.helpButton setAction:@selector(helpButtonClicked:)];
    
    self.helpButton.wantsLayer = YES;
    self.helpButton.layer.backgroundColor = NSColor.clearColor.CGColor;
    self.helpButton.layer.borderColor = NSColor.clearColor.CGColor;
    self.helpButton.layer.borderWidth = 0;
    //self.submitButton.layer.cornerRadius = 4.0f;

    self.helpButton.shadow = [[NSShadow alloc] init];
    //self.bottomToolbar.layer.backgroundColor = [NSColor redColor].CGColor;
    //self.bottomToolbar.layer.cornerRadius = 5.0;
    self.helpButton.layer.shadowOpacity = 1.0;
    self.helpButton.layer.shadowColor = [NSColor colorWithWhite:0.3 alpha:1.0].CGColor;
    self.helpButton.layer.shadowOffset = NSMakeSize(0, 0.5);
    self.helpButton.layer.shadowRadius = 0.5;

    
    self.helpButton.contentTintColor = [NSColor colorWithWhite:0.9 alpha:1.0];
    self.helpButton.bezelStyle = NSBezelStyleHelpButton;
    
    //self.layer.backgroundColor =
    self.helpButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomToolbar addSubview:self.helpButton];
    
    self.helpButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * Left = [NSLayoutConstraint constraintWithItem: self.helpButton
                                                           attribute: NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem: self.bottomToolbar attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0f constant:16.0f];
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: self.helpButton
                                                            attribute: NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: self.bottomToolbar attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0 constant:0];
    
    [self addConstraints:@[ Left, CenterY]];
    
}

-(id)initWithFrame:(NSRect)frame andThruConnection:(NSString* _Nullable)thruID
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.wantsLayer = YES;
    
        //[self setWantsLayer:NO];
        //self.layer.borderWidth = 0.0f;
        //self.layer.masksToBounds = YES;
        //[self.layer setBorderWidth:0];
        //self.appearance = [NSAppearance appearanceNamed: NSAppearanceNameDarkAqua];

        //create a temporary data model object that the modal table view can use to populate itself and visa versa
        //so the user can create a thru coonnection
        
        if( thruID && thruID.length > 0 )
        {
            self.dataModel = [CMThru.dictionary objectForKey:thruID];
            self.modalViewMode = ModalView_Modify;
            assert(self.dataModel);
        }
        else
        {
            self.modalViewMode = ModalView_Create;
            self.dataModel = [[CMThruConnection alloc] init];
        }
        
        
        //[self createScrollListView];
        //[self createScrollView];
        
        //create UI
        
        [self createImageView];
        
        [self createThruIDLabel];
        [self createInputDeviceLabel];
        [self createOutputDeviceLabel];
        //[self createFilterLabel];
        
        [self  createThruIDTextField];
        [self createInputPopupButton];
        [self createOutputPopupButton];
        [self createFilterView];

        [self createBottomToolbar];
        [self createSubmitButton];
        [self createHelpButton];
        
        //Updates to determine whether to activate submit button
        [self devicePopupButtonClicked:self.inputPopupButton];
        [self devicePopupButtonClicked:self.outputPopupButton];

        self.userInteractionEnabled = true;

       /*
        NSLayoutConstraint * documentTop = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                        attribute: NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:0];
        
        NSLayoutConstraint * documentBottom = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                           attribute: NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.scrollView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f constant:0];
        
        NSLayoutConstraint * documentLeft = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                         attribute: NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.scrollView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:0.f];
        
        NSLayoutConstraint * documentRight = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                          attribute: NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.scrollView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:0.0f];
        
        
        [self.scrollView addConstraints:@[documentTop, documentLeft, documentBottom, documentRight]];
        
    
        [self updateDocumentView];
        [_thruIDLabel setNeedsLayout:YES];
        [_thruIDLabel setNeedsDisplay:YES];
        */
    }
    
    return self;
}


-(void)scrollToBottom
{
    
    
}


-(void)createScrollView
{
    
    self.scrollView = [[NSScrollView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    self.scrollView.backgroundColor = [NSColor colorWithWhite:233./255. alpha:1.];
    [self addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * CenterX = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                attribute: NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1 constant:0];

    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                attribute: NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f constant:0];

    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f];

    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                attribute: NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f];
    
    
    [self addConstraints:@[CenterX, right, top, bottom]];
    
    
    
    self.scrollDocumentView = [[NSView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.scrollDocumentView.wantsLayer = true;
    self.scrollDocumentView.layer.backgroundColor = [NSColor redColor].CGColor;
    [self.scrollView setDocumentView:self.scrollDocumentView];
    self.scrollDocumentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * sCenterX = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                attribute: NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.f constant:0];

    NSLayoutConstraint * sright = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                attribute: NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f constant:0];

    NSLayoutConstraint * stop = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f];

    NSLayoutConstraint * sbottom = [NSLayoutConstraint constraintWithItem:self.scrollDocumentView
                                                                attribute: NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f];
    
    
    [self.scrollView addConstraints:@[stop, sCenterX, sbottom, sright]];
}



-(void)updateDocumentView
{
    [self layoutSubtreeIfNeeded];
    
    /*
    CGRect frame = self.scrollDocumentView.frame;
    self.scrollDocumentView.frame = CGRectMake(0,0,frame.size.width, 1000);

    CGFloat documentViewOffset = (self.cancelButton.frame.origin.y - self.frame.origin.y + self.cancelButton.frame.size.height - (self.frame.size.height) );
    if( documentViewOffset < 0 )
    documentViewOffset = 0;
    
    NSLayoutConstraint * documentTop = [NSLayoutConstraint constraintWithItem: self.scrollDocumentView
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: self.scrollView attribute:NSLayoutAttributeTop
                                                           multiplier:0.5 constant:0.0f];
     
     NSLayoutConstraint * documentLeft = [NSLayoutConstraint constraintWithItem: self.scrollDocumentView
                                                              attribute: NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.scrollView attribute:NSLayoutAttributeLeft
                                                             multiplier:1 constant:0.0f];



    NSLayoutConstraint * documentBottom = [NSLayoutConstraint constraintWithItem: self.scrollDocumentView
                                                            attribute: NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                              toItem: self.cancelButton attribute:NSLayoutAttributeBottom
                                                                multiplier:1 constant:20];

    NSLayoutConstraint * documentRight = [NSLayoutConstraint constraintWithItem: self.scrollDocumentView
                                                                                        attribute: NSLayoutAttributeRight
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem: self.scrollView attribute:NSLayoutAttributeRight
                                                                                       multiplier:1 constant:0.0f];
                               
    [self.scrollView addConstraints:@[ documentTop, documentLeft, documentBottom, documentRight ]];
     */
}


-(NSTextFieldButton*)createUserInputButtonForField:(NSTextField*)textField withTitle:(NSString*)title
{
    //CGFloat buttonWidth = 200;
    //CGFloat buttonHeight = 100;
    //CGFloat buttonX = self.view.frame.size.width/2 - buttonWidth/2;
    //CGFloat buttonY = self.view.frame.size.height/2 - buttonHeight/2;
    NSTextFieldButton * button = [[NSTextFieldButton alloc] initWithFrame:CGRectMake(0,0,200,100)];//CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight)];
    // button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    
    textField.enabled = NO;
    
    button.textfield = textField;
    button.chooseDir = NO;
    button.chooseFiles = YES;
    [button setAction:@selector(textFieldButtonClicked:)];

    [button setTitle:title];
    [button setTarget:self];
    //[button setAction:@selector(csvButtonClicked:)];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollDocumentView addSubview:button];
    
    //[self addLoginButtonConstraintsToItem:self fromItem:_loginButton];
    
    NSLayoutConstraint * cy = [NSLayoutConstraint constraintWithItem: button
                                                           attribute: NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem: textField attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem: button
                                                             attribute: NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem: textField attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:10.0f];
    
    /*
     NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: _csvButton
     attribute: NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem: _pwField attribute:NSLayoutAttributeBottom
     multiplier:1.0 constant:20];
     */
    /*
     NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _csvButton
     attribute: NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem: self attribute:NSLayoutAttributeWidth
     multiplier:.015 constant:0];
     
     NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _csvButton
     attribute: NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem: _nameField attribute:NSLayoutAttributeHeight
     multiplier:1 constant:0 ];
     */
    [self.scrollDocumentView addConstraints:@[ cy, left ]];
    
    return button;
    
}

/*
- (id)initWithFrame:(NSRect)frame andDataModel:(VRTDOM*)dataModel{
    self = [super initWithFrame:frame];
    if (self) {

        self.modalViewMode = ModalView_Modify;
        self.dataModel = dataModel;
        
        [self createTitleLabel];
        
        [self createUserInputFields];
        [self createModalButtons];
        //[self createLoginButton];
        
        //self.layer.backgroundColor = [[NSColor blueColor] CGColor];
        [self createActivityIndicator];
        
    }
    return self;
}

*/

/*
-(void)createActivityIndicator
{
    
    if( !self.indicatorView )
    {
        self.indicatorView = [[CustomIndicatorView alloc] init];
        _indicatorView.layer.cornerRadius = 6.0;
        
        [self addSubview:_indicatorView];
        
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        //[self addIndicatorViewConstraintsToItem:_loginButtonContainer fromItem:_indicatorView ];
        
        NSLayoutConstraint * centerX = [NSLayoutConstraint constraintWithItem: _indicatorView
                                                                    attribute: NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem: self attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:0.0f];
        
        
        NSLayoutConstraint * centerY = [NSLayoutConstraint constraintWithItem: _indicatorView
                                                                    attribute: NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem: self attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0.0f];
        
        
        NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: _indicatorView
                                                                  attribute: NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem: self attribute:NSLayoutAttributeWidth
                                                                 multiplier:0 constant:150];
        
        NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem: _indicatorView
                                                                   attribute: NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem: self attribute:NSLayoutAttributeHeight
                                                                  multiplier:0 constant:100];//22.0f * [[UIScreen mainScreen] scale]];
        
        [self addConstraints:@[ centerX, centerY, width, height ]];
        
        
        _indicatorView.label.stringValue = @"Logging In";
        //_indicatorView.label.font = [[[MastryFontManager sharedInstance] buttonThemeBoldFont] fontWithSize:36.0];
        //_indicatorView.label.minimumScaleFactor = 0.1;
        
        //_indicatorView.label.numberOfLines=0;
        //_indicatorView.label.lineBreakMode=NSLineBreakByWordWrapping;
        //_indicatorView.label.adjustsFontSizeToFitWidth=YES;
        _indicatorView.hidden = YES;
        
        //[_indicatorView showAndStartAnimating];
        
    }
    
    
}
 */

-(void)dealloc
{
    NSLog(@"MastryDOMView dealloc");

}



-(void) addTitleLabelConstraintsToItem:(NSView*)toItem fromItem:(NSView*)fromItem
{
    
    NSLayoutConstraint * CenterX = [NSLayoutConstraint constraintWithItem: fromItem
                                                                attribute: NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: toItem attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:0.0f];
    
    
    NSLayoutConstraint * CenterY = [NSLayoutConstraint constraintWithItem: fromItem
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: toItem attribute:NSLayoutAttributeBottom
                                                               multiplier:0.10 constant:0];
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: fromItem
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: toItem attribute:NSLayoutAttributeWidth
                                                             multiplier:1 constant:0];

    
    [toItem addConstraints:@[ CenterY, width, CenterX ]];
    
}

-(NSTextField*)createTextFieldWithText:(NSString *)text placeholderText:(NSString*)placeholderText prevTextField:(NSView*)prevTextField
{
    
    NSTextField * textField = [[NSTextField alloc] initWithFrame:CGRectMake(0,0,60,100)];
    [textField setWantsLayer:YES];
    textField.layer.cornerRadius = 3.0;
    textField.layer.backgroundColor = [NSColor blueColor].CGColor;

    [textField setBezeled:YES];
    [textField setDrawsBackground:YES];
    [textField setEditable:YES];
    [textField setSelectable:YES];
    
    //textField = UITextBorderStyleNone;
    //textField = [UIFont systemFont];
    //textField = @"user@spur.com";
    
    //textField.stringValue = @"Hello";
    if( placeholderText )
        textField.placeholderString = placeholderText;
    
    if( text )
        textField.stringValue = text;
    textField.textColor = [NSColor darkGrayColor];
    textField.delegate = self;
    
    [self.scrollDocumentView addSubview:textField];
    
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint * CenterX = [NSLayoutConstraint constraintWithItem: textField
                                                                attribute: NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem: self.scrollDocumentView attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.f constant:0.0f];
    
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: textField
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: prevTextField attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0 constant:0];
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: textField
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.scrollDocumentView attribute:NSLayoutAttributeWidth
                                                             multiplier:0.4 constant:0];
    

    [self.scrollDocumentView addConstraints:@[ CenterX, width, top ]];
    
    
    textField.hidden = NO;
    [textField setNeedsDisplay:YES];
    [textField setNeedsLayout:YES];
    
    return textField;
    
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    if( self.userInteractionEnabled )
        return [super hitTest:aPoint];
    else
        return nil;
}

-(void)textFieldButtonClicked:(id)sender
{
    NSTextFieldButton * button = (NSTextFieldButton *)sender;
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setLevel:NSPopUpMenuWindowLevel];
    [openDlg setAllowsMultipleSelection:NO];
    
    [openDlg setCanChooseDirectories:button.chooseDir];
    [openDlg setCanChooseFiles:button.chooseFiles];
    //[openDlg setCanCreateDirectories:NO];
    
    [openDlg setPrompt:@"Select"];
    
    //NSArray* imageTypes = [NSImage imageTypes];
    
    if( button.filetypes && button.filetypes.count > 0 )
        [openDlg setAllowedContentTypes:button.filetypes];
    
    
    self.userInteractionEnabled = false;
    
    __weak typeof(self) weakSelf = self;
    
    [openDlg beginWithCompletionHandler:^(NSInteger result){
        
        //if( result == NSModalResponseOK )
        //{
        //get the URL of the selected file
        NSArray* pathURLs = [openDlg URLs];
        if( pathURLs && pathURLs.count > 0 )
        {
            NSURL * pathURL = [pathURLs objectAtIndex:0];
            
            //NSArray* filepaths = [openDlg filenames];
            //get the filepath of the selected file and convert back to url
            NSString * filepath = pathURL.path;//[filepaths objectAtIndex:0];
            //NSURL * url = [[NSURL alloc] initFileURLWithPath:filepath];
        
            if( filepath )
            {
                //NSTextField * textField = (NSTextField*) [self.inputFields objectForKey:@"URL"];
                button.textfield.stringValue = filepath;
            }
            else
            {
                [self showAlertView:@"Error" message:@"Failed to get local URL to selected file." completionHandler:nil];
            }
        }
        
        //return user interaction to this view
        //dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = true;
        //});
        
    }];

}

-(void)createUserInputFields
{
    //loop over each property and create and input field
    unsigned int count = 0;
    //NSMutableDictionary *dictionary = [NSMutableDictionary new];
    self.inputFields = [NSMutableDictionary new];
    self.inputFieldKeys = [NSMutableArray new];
    self.fieldButtons = [NSMutableDictionary new];
    
    if( self.modalViewMode == ModalView_Create  || self.modalViewMode == ModalView_Modify)
    {
        objc_property_t *properties = class_copyPropertyList([CMThruConnection class], &count);
        
        NSView * prevTextField = self.scrollDocumentView;
        for (int i = 0; i < count; i++) {
            
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            //NSObject * value = [self valueForKey:key];
            
            NSLog(@"Input Field Key = %@", key);
            //if( value && [value isKindOfClass:[NSString class]] )
            // {
                //create a text field
                id text = nil;
                if( self.modalViewMode == ModalView_Modify )
                    text = [self.dataModel valueForKey:key];
            
                NSTextField * textField = [self createTextFieldWithText:text placeholderText:key prevTextField:prevTextField];
                //textField.delegate = self;
                prevTextField = textField;
                [self.inputFields setObject:textField forKey:key];
                [self.inputFieldKeys addObject:key];
            
                if( [key localizedCompare:@"URL"] == NSOrderedSame)
                {
                    NSTextFieldButton * button = [self createUserInputButtonForField:textField withTitle:@"Choose..."];
                    button.filetypes = @[@"png", @"PNG"];
                }
            //}
            //NSString *value = [NSString stringWithFormat:@"%@",[self valueForKey:key]];
            //[dictionary setObject:value forKey:key];
            //id value = [self valueForKey:key];
            /*
             if (value == nil) {
             // nothing todo
             }
             else if ([value isKindOfClass:[NSNumber class]]
             || [value isKindOfClass:[NSString class]]
             || [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableArray class]]) {
             // TODO: extend to other types
             [dictionary setObject:value forKey:key];
             }
             else if ([value isKindOfClass:[NSObject class]]) {
             [dictionary setObject:[value dictionary] forKey:key];
             }
             else {
             NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
             }
             */
        }
        free(properties);
        
    }
    /*
    else if( self.modalViewMode == ModalView_Create_MANY)
    {
        
        //NSArray * fieldTitleStrings = [[NSArray alloc] initWithObjects:@"Path ]
        //NSArray * fieldKeys = [[NSArray alloc] initWithObjects:@"CSV", "DIR", nil];
        NSArray * fieldKeys = [[NSArray alloc] initWithObjects:@"Path to CSV", @"Path to Image Directory", nil];

        //NSArray *
        
        NSView * prevTextField = _thruIDLabel;
        for (int i = 0; i < fieldKeys.count; i++) {
            
            NSString * key = [fieldKeys objectAtIndex:i];
            NSTextField * textField = [self createTextFieldWithText:nil placeholderText:key prevTextField:prevTextField];
            NSTextFieldButton * button = [self createUserInputButtonForField:textField withTitle:@"Choose..."];
            
            if( i == 0 )
                
            {
                _csvField = textField;
                button.chooseDir = NO;
                button.chooseFiles = YES;
                button.filetypes = @[@"csv", @"CSV"];
            }
            else
            {
                _dirField = textField;
                button.chooseDir = YES;
                button.chooseFiles = NO;
            }
            
            //textField.delegate = self;
            prevTextField = textField;
            [self.inputFields setObject:textField forKey:key];
            [self.inputFieldKeys addObject:key];
            
        }


    }
     */
    //return dictionary;
    
}

-(NSButton *)createModalButton:(NSString *)title topView:(NSView*)topView selector:(SEL)selector
{
    //CGFloat buttonWidth = 200;
    //CGFloat buttonHeight = 100;
    //CGFloat buttonX = self.view.frame.size.width/2 - buttonWidth/2;
    //CGFloat buttonY = self.view.frame.size.height/2 - buttonHeight/2;
    NSButton * button = [[NSButton alloc] initWithFrame:CGRectMake(0,0,0,100)];//CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight)];
    // button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [button setTitle:title];
    [button setTarget:self];
    [button setAction:selector];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    
    //[self addLoginButtonConstraintsToItem:self fromItem:_loginButton];
    
    NSLayoutConstraint * cx = [NSLayoutConstraint constraintWithItem: button
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem: self attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: button
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: topView attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0 constant:20];
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: button
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeWidth
                                                             multiplier:0.25 constant:0];
    
    
    [self addConstraints:@[ cx, width, top ]];
    
    return button;
    
}

/*
-(const char *)getCollectionTitle
{
    const char * collectionTitle = nil;
    if( self.dataModel.type > NUM_DOM_COLLECTIONS)
        collectionTitle = VRT_EXT_DOM_COLLECTION_TITLES[self.dataModel.type - NUM_DOM_COLLECTIONS];
    else
        collectionTitle = VRT_DOM_COLLECTION_TITLES[self.dataModel.type];
    return collectionTitle;
}

-(const char *)getDOMTitle
{
    const char * collectionTitle = nil;
    if( self.dataModel.type > NUM_DOM_COLLECTIONS)
        collectionTitle = VRT_EXT_DOM_TITLES[self.dataModel.type - NUM_DOM_COLLECTIONS];
    else
        collectionTitle = VRT_DOM_TITLES[self.dataModel.type];
    return collectionTitle;
}
*/

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if( textField.stringValue.length > 0 )
        _submitButton.enabled = YES;
    else
        _submitButton.enabled = NO;
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    //NSTextField *textField = [notification object];
    //if ([textField resignFirstResponder]) {
    //    textField.textColor = [NSColor blackColor];
    //}
}

-(void)helpButtonClicked:(id)sender
{
    
}

-(void)submitButtonClicked:(id)sender
{
    //[self.indicatorView showAndStartAnimating];
    
    if( self.modalViewMode == ModalView_Create )
    {
        //The submit button should not have been activated unless fields have been populated
        //TO DO: check ThruID for name collisions
        
        //TO DO:  make these asserts user alerts
        assert(self.thruIDField.stringValue.length > 0);
        assert(self.inputPopupButton.indexOfSelectedItem != self.outputPopupButton.indexOfSelectedItem);
        
        //TO DO:  check the field value for sanity
        int inputIDs[1] =  {(int)self.inputPopupButton.indexOfSelectedItem};
        int outputIDs[1] = {(int)self.outputPopupButton.indexOfSelectedItem};
        
        //Populate thruParam Inputs/Outputs
        MIDIThruConnectionParams* thruParams = &(CMClient.thruConnections[CMClient.numThruConnections].params);
        CMInitThruParams(thruParams, inputIDs, 1, outputIDs, 1);
        
        //NSArray * filterIdentifiers = @[@"CC", @"SysEx", @"MTC", @"Beat Clock", @"Tune Request"];

        //Populate thruParam Filter Section
        for( int i = 0; i<self.filterView.buttons.count; i++)
        {
            NSButton * button = [self.filterView.buttons objectAtIndex:i];
        
            if( button.state == NSControlStateValueOn)
            {
                if( [button.title localizedCompare:@"CC"] == NSOrderedSame )
                    thruParams->filterOutAllControls = 1;
                else if( [button.title localizedCompare:@"SysEx"] == NSOrderedSame )
                    thruParams->filterOutSysEx = 1;
                else if( [button.title localizedCompare:@"MTC"] == NSOrderedSame )
                    thruParams->filterOutMTC = 1;
                else if( [button.title localizedCompare:@"Beat Clock"] == NSOrderedSame )
                    thruParams->filterOutBeatClock = 1;
                else if( [button.title localizedCompare:@"Tune Request"] == NSOrderedSame )
                    thruParams->filterOutTuneRequest = 1;
            }
            else if( button.state == NSControlStateValueOff)
            {
                if( [button.title localizedCompare:@"CC"] == NSOrderedSame )
                    thruParams->filterOutAllControls = 0;
                else if( [button.title localizedCompare:@"SysEx"] == NSOrderedSame )
                    thruParams->filterOutSysEx = 0;
                else if( [button.title localizedCompare:@"MTC"] == NSOrderedSame )
                    thruParams->filterOutMTC = 0;
                else if( [button.title localizedCompare:@"Beat Clock"] == NSOrderedSame )
                    thruParams->filterOutBeatClock = 0;
                else if( [button.title localizedCompare:@"Tune Request"] == NSOrderedSame )
                    thruParams->filterOutTuneRequest = 0;
            }
        }
        
        
        //TO DO:  introduce some error checking to this function pipeline
        [CMThruConnection createThruConnection:self.thruIDField.stringValue Params:thruParams];
        [[CMThruApplicationDelegate sharedInstance] dismissModalWindow];
    }
    else if( self.modalViewMode == ModalView_Modify )
    {
        //TO DO:  make these asserts user alerts
        assert(self.thruIDField.stringValue.length > 0);
        assert(self.inputPopupButton.indexOfSelectedItem != self.outputPopupButton.indexOfSelectedItem);
        
        //TO DO:  check the field value for sanity
        int inputIDs[1] =  {(int)self.inputPopupButton.indexOfSelectedItem};
        int outputIDs[1] = {(int)self.outputPopupButton.indexOfSelectedItem};
        
        //Populate thruParam Inputs/Outputs
        MIDIThruConnectionParams* thruParams = &(_dataModel.connection->params);
        CMInitThruParamEndpoints(thruParams, inputIDs, 1, outputIDs, 1);

        //NSArray * filterIdentifiers = @[@"CC", @"SysEx", @"MTC", @"Beat Clock", @"Tune Request"];

        //Populate thruParam Filter Section
        for( int i = 0; i<self.filterView.buttons.count; i++)
        {
            NSButton * button = [self.filterView.buttons objectAtIndex:i];
        
            if( button.state == NSControlStateValueOn)
            {
                if( [button.title localizedCompare:@"CC"] == NSOrderedSame )
                    thruParams->filterOutAllControls = 1;
                else if( [button.title localizedCompare:@"SysEx"] == NSOrderedSame )
                    thruParams->filterOutSysEx = 1;
                else if( [button.title localizedCompare:@"MTC"] == NSOrderedSame )
                    thruParams->filterOutMTC = 1;
                else if( [button.title localizedCompare:@"Beat Clock"] == NSOrderedSame )
                    thruParams->filterOutBeatClock = 1;
                else if( [button.title localizedCompare:@"Tune Request"] == NSOrderedSame )
                    thruParams->filterOutTuneRequest = 1;
            }
            else if( button.state == NSControlStateValueOff)
            {
                if( [button.title localizedCompare:@"CC"] == NSOrderedSame )
                    thruParams->filterOutAllControls = 0;
                else if( [button.title localizedCompare:@"SysEx"] == NSOrderedSame )
                    thruParams->filterOutSysEx = 0;
                else if( [button.title localizedCompare:@"MTC"] == NSOrderedSame )
                    thruParams->filterOutMTC = 0;
                else if( [button.title localizedCompare:@"Beat Clock"] == NSOrderedSame )
                    thruParams->filterOutBeatClock = 0;
                else if( [button.title localizedCompare:@"Tune Request"] == NSOrderedSame )
                    thruParams->filterOutTuneRequest = 0;
            }
        }
        
        //if the ThruID changed we need to delete the old connection then create a new one
        if( [_dataModel.ThruID localizedCompare:self.thruIDField.stringValue] != NSOrderedSame )
        {
            //TO DO: present an alert to the user
            if([CMThru.dictionary objectForKey:self.thruIDField.stringValue]) assert(1==0);

            [_dataModel replaceThruConnection:self.thruIDField.stringValue atIndex:_dataModel.row];
        }
        else //but otherwise we just need to update the params on the CoreMIDI thru connection
        {
            [_dataModel saveThruConnection];
        }
        
        [[CMThruApplicationDelegate sharedInstance] dismissModalWindow];

    }
        

    /*
    else if( self.modalViewMode == ModalView_Create_MANY )
    {
        //TO DO:  verify csv and dir field
        self.indicatorView.label.stringValue = @"Parsing CSV";
        
        //parse csv to create array of nsdictionaries synchronously
        //it will display an error message to the user for us if needed
        NSArray * newEntries = [self.dataModel parseCSV:_csvField.stringValue assetDir:_dirField.stringValue];
        
        //there were errors parsing the csv
        if( !newEntries || newEntries.count < 1)
        {
            [self.indicatorView hideAndStopAnimating];
            return;
        }
        
        self.indicatorView.label.stringValue = @"Uploading Documents";
        HTTPRequestCompletionBlock createManyCompletionBlock = ^void(long statusCode, NSError * error, NSArray * documents)
        {
            //Since our implementation is abstract, only the VRTDOM child class implementations know how to interpret the response data for their POST requests
            //We use a delegate
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView hideAndStopAnimating];
            });
        };
        
        //[self.dataModel submitCreateManyRequestWithCSV:_csvField.stringValue andAssetDir:_dirField.stringValue];
        //[self.dataModel submitCreateManyRequestWithDicts:newEntries andCompletionHandler:createManyCompletionBlock];
    }
     */
}

-(void)cancelButtonClicked:(id)sender
{
    NSLog(@"cancelButtonClicked");
    CMThruApplicationDelegate *appDelegate = (CMThruApplicationDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate dismissModalWindow];
}

-(void)createModalButtons
{
    //everybody gets a submit button
    
    NSView * topView = _scrollListView;//[_inputFields objectForKey:[_inputFieldKeys objectAtIndex:_inputFieldKeys.count -1]];
    self.submitButton = [self createModalButton:@"Submit" topView:topView selector:@selector(submitButtonClicked:)];
    self.cancelButton = [self createModalButton:@"Cancel" topView:self.submitButton selector:@selector(cancelButtonClicked:)];

    self.modalButtons = [NSMutableArray new];
    [self.modalButtons addObject:self.submitButton];
    [self.modalButtons addObject:self.cancelButton];

    /*)
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem: self.scrollView
                                                              attribute: NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.cancelButton attribute:NSLayoutAttributeBottom
                                                             multiplier:1 constant:0];
    
    */
    //[self addConstraints:@[ bottom ]];

}

- (void)processAlertReturnCode:(NSInteger)returnCode
{
    if (returnCode == NSModalResponseOK || returnCode == NSOKButton)
    {
        NSLog(@"(returnCode == NSOKButton)");
        //[self.window makeKeyWindow];
    }
    else if (returnCode == NSModalResponseCancel || returnCode == NSCancelButton)
    {
        NSLog(@"(returnCode == NSCancelButton)");
        
        //MastryAdminAppDelegate *appDelegate = (MastryAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
    [[NSApp modalWindow] makeKeyWindow];
        //[appDelegate.window makeKeyWindow];

    }
    else if(returnCode == NSAlertFirstButtonReturn)
    {
        NSLog(@"if (returnCode == NSAlertFirstButtonReturn)");
    }
    else if (returnCode == NSAlertSecondButtonReturn)
    {
        NSLog(@"else if (returnCode == NSAlertSecondButtonReturn)");
    }
    else if (returnCode == NSAlertThirdButtonReturn)
    {
        NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
    }
    else
    {
        NSLog(@"All Other return code %ld",(long)returnCode);
    }
    
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    /*
     The following options are deprecated in 10.9. Use NSAlertFirstButtonReturn instead
     NSAlertDefaultReturn = 1,
     NSAlertAlternateReturn = 0,
     NSAlertOtherReturn = -1,
     NSAlertErrorReturn = -2
     NSOKButton = 1, // NSModalResponseOK should be used
     NSCancelButton = 0 // NSModalResponseCancel should be used
     */
    
    [self processAlertReturnCode:returnCode];
    
}

-(void)showAlertView:(NSString*)title message:(NSString*)message async:(BOOL)async
{
    if( async )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertView:title message:message completionHandler:nil];
        });
    }
    else
        [self showAlertView:title message:message completionHandler:nil];
}
-(void)showAlertView:(NSString*)title message:(NSString*)message completionHandler:(void (^ __nullable)(NSModalResponse returnCode))handler
{
    
    //MastryAdminAppDelegate *appDelegate = (MastryAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
    //[self.window setStyleMask:appDelegate.modalWindowStyleMask];

    //dispatch_sync(dispatch_get_main_queue(), ^{
        
        [self.indicatorView hideAndStopAnimating];
        
        NSAlert *alert = [[NSAlert alloc] init];
        //alert.delegate = self;
        //[alert addButtonWithTitle:@"Continue"];
        //[alert addButtonWithTitle:@"OK"];
        [alert setMessageText:title];
        [alert setInformativeText:message];
        [alert setAlertStyle:NSAlertStyleWarning];

        //[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        NSModalResponse response = [alert runModal];

        [self processAlertReturnCode:response];
        
        //CMThruApplicationDelegate *appDelegate = (CMThruApplicationDelegate *)[[NSApplication sharedApplication] delegate];
        [self.window setStyleMask:NSWindowStyleMaskTitled];
        //[self.window display];
        [self.window layoutIfNeeded];
        [self.window setViewsNeedDisplay:YES];
        
    //});
    
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //[self.thruIDLabel drawRect:dirtyRect];
    //[self.thruIDLabel drawCellInside:self.thruIDLabel.cell];
    // Drawing code here.
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2.0;
    
}

@end
