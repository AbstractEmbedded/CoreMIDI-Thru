//
//  NSView+Blur.m
//  MastryAdmin
//
//  Created by Joe Moulton on 4/18/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSView+Blur.h"

/*
@interface NSView ()

@end
*/

@implementation NSView (Blur)

-(instancetype)insertVibrancyViewBlendingMode:(NSVisualEffectBlendingMode)mode
{
    Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
    if (vibrantClass)
    {
        NSVisualEffectView *vibrant=[[vibrantClass alloc] initWithFrame:self.bounds];
        [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        // uncomment for dark mode instead of light mode
        // [vibrant setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
        [vibrant setBlendingMode:mode];
        [self addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
        
        return vibrant;
    }
    
    return nil;
    
}


@end
