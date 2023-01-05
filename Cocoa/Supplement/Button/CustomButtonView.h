//
//  CustomButtonView.h
//  NCrypt
//
//  Created by MACMaster on 4/18/15.
//  Copyright (c) 2015 Abstract Embedded, LLC. All rights reserved.
//


#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define CocoaEvent NSEvent
#define CocoaColor NSColor
#define CocoaView NSView
#define CocoaImage NSImage
#define CocoaImageView NSImageView
#else
#import <UIKit/UIKit.h>
#define CocoaEvent UIEvent
#define CocoaColor UIColor
#define CocoaView UIView
#define CocoaImage UIImage
#define CocoaImageView UIImageView
#endif

//Custom UILabel for drawing transparent text
#import "RSMaskedLabel.h"

@protocol CustomButtonViewDelegate <NSObject>
@optional

#if TARGET_OS_OSX
-(void)cbvEntered:(id)sender;
-(void)cbvExited:(id)sender;
#endif

-(void) cbvTouchUpInside:(id)sender;
-(void) cbvTouchDown:(id)sender;

@end


@interface CustomButtonView : CocoaView

@property (nonatomic, weak) id <CustomButtonViewDelegate> delegate;

@property (nonatomic) BOOL selected;

@property (nonatomic) BOOL makeBorderCircular;

@property (nonatomic, readonly) CocoaImageView * backgroundImageView;

@property (nonatomic, retain) CocoaColor * normalBackgroundColor;
@property (nonatomic, retain) CocoaColor * highlightedBackgroundColor;
@property (nonatomic, retain) CocoaColor * selectedBackgroundColor;


@property (nonatomic, retain) CocoaImage * backgroundImage;
@property (nonatomic, retain) CocoaImage * highlightedBackgroundImage;
@property (nonatomic, retain) CocoaImage * selectedBackgroundImage;

@property (nonatomic, retain) RSMaskedLabel * titleLabel;
@property (nonatomic, retain) RSMaskedLabel * highlightedTitleLabel;
@property (nonatomic, retain) RSMaskedLabel * selectedTitleLabel;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * highlightedTitle;
@property (nonatomic, retain) NSString * selectedTitle;

@property (nonatomic, retain) CocoaColor * titleColor;
@property (nonatomic, retain) CocoaColor * highlightedTitleColor;
@property (nonatomic, retain) CocoaColor * selectedTitleColor;

-(void)setHighlighted:(BOOL)high;


@end
