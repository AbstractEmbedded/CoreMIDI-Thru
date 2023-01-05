//
//  NSTextFieldButton.h
//  MastryAdmin
//
//  Created by Joe Moulton on 4/30/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTextFieldButton : NSButton


@property BOOL chooseFiles;
@property BOOL chooseDir;

@property (nonatomic, retain) NSTextField * textfield;
@property (nonatomic, retain) NSArray * filetypes;


@end

NS_ASSUME_NONNULL_END
