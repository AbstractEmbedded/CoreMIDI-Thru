//
//  CMThruTableView.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/28/22.
//

#import <Cocoa/Cocoa.h>
#import "CMThruConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMThruScrollListView : NSScrollView <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>

-(id)initWithFrame:(NSRect)frameRect andDOM:(CMThruConnection*)dataModel;

@property (nonatomic, retain) NSColor * fillColor;
-(void)redraw;

@end

NS_ASSUME_NONNULL_END
