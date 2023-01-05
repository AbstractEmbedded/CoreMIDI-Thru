//
//  CustomIndicatorView.h
//  Mastry
//
//  Created by Joe Moulton on 4/12/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Cocoa/Cocoa.h>
#import "NSView+Blur.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomIndicatorView : NSView

@property (nonatomic, retain) NSProgressIndicator * indicator;
@property (nonatomic, retain) NSTextField * label;

-(void)showAndStartAnimating;
-(void)hideAndStopAnimating;

@end

NS_ASSUME_NONNULL_END
