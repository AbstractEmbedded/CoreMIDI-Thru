//
//  NSView+Blur.h
//  MastryAdmin
//
//  Created by Joe Moulton on 4/18/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Blur)

-(instancetype)insertVibrancyViewBlendingMode:(NSVisualEffectBlendingMode)mode;

@end

NS_ASSUME_NONNULL_END
