//
//  RSMaskedLabelView.h
//  RSMaskedLabel
//
//  Created by Robin Senior on 2013-02-07.
//  Copyright (c) 2013 Nulayer. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define CocoaColor NSColor
#define CocoaLabel NSTextField
#else
#import <UIKit/UIKit.h>
#define CocoaColor UIColor
#define CocoaLabel UILabel
#endif


@interface RSMaskedLabel : CocoaLabel

@end
