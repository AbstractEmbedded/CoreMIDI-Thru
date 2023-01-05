//
//  ButtonTableViewCell.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/29/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonTableViewCell : NSTableCellView

@property (nonatomic, readonly) NSButton* cancelButton;
@property (nonatomic, readonly) NSButton* submitButton;


@end

NS_ASSUME_NONNULL_END
