//
//  CMThruView.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/27/22.
//

#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define CocoaView NSView
#else
#import <UIKit/UIKit.h>
#define CocoaView UIView
#endif


NS_ASSUME_NONNULL_BEGIN

@interface CMThruView : NSVisualEffectView

-(void)updateThruConnectionWidgets;

@end

NS_ASSUME_NONNULL_END
