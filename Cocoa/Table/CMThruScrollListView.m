//
//  CMThruTableView.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/28/22.
//

#import "CMThruScrollListView.h"
#include "CMidiAppInterface.h"
#import "CMThruConnection.h"
#import "NSTaggedTableColumn.h"
#import <Foundation/NSObjcRuntime.h>
#import <objc/runtime.h>

#import "NSObject+JSON.h"

#import "ButtonTableViewCell.h"
#import "CMTextFieldCell.h"
#import "NSCheckboxView.h"

@interface CMThruScrollListView()
{
    CGFloat _defaultColumnWidth;
    NSTableView * _tableView;
    NSColor *     _fillColor;
    
    CMThruConnection * _dataModel;
}

@property (nonatomic, retain) NSTableView * tableView;
@property (nonatomic, retain) NSMutableArray * keys;
@property (nonatomic, retain) NSMutableDictionary * columnDict;

@property (nonatomic, retain) CMDOM * dataModel;

@property (atomic) int numCells;

@end

@implementation CMThruScrollListView

@synthesize tableView = _tableView;
@synthesize fillColor = _fillColor;

@synthesize dataModel = _dataModel;

-(id)initWithFrame:(NSRect)frameRect andDOM:(CMThruConnection*)dataModel
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        self.dataModel = dataModel;
        //self.numCells = numCells;
        
        self.fillColor = [NSColor clearColor];

        [self setWantsLayer:YES];
        self.layer.borderWidth = 0.5f;
        self.layer.backgroundColor = [NSColor clearColor].CGColor;
        //self.layer.masksToBounds = YES;
        self.layer.borderColor = [NSColor darkGrayColor].CGColor;
        [self setFocusRingType:NSFocusRingTypeNone];
        [self noteFocusRingMaskChanged];
        //[self.layer setCornerRadius: 10];

        //This will override the draw fill
        self.backgroundColor = [NSColor clearColor];
        //This will allow the draw fill
        [self setDrawsBackground:NO];
        
        [self createTableView];
        [self createTableViewMenu];
        [self.tableView reloadData];
        
        
    }
    return self;
}


- (void)processAlertReturnCode:(NSInteger)returnCode
{
    if (returnCode == NSModalResponseOK )//|| returnCode == NSOKButton)
    {
        NSLog(@"(returnCode == NSOKButton)");
        //[self.window makeKeyWindow];
    }
    else if (returnCode == NSModalResponseCancel )// || returnCode == NSCancelButton)
    {
        NSLog(@"(returnCode == NSCancelButton)");
        
        //MastryAdminAppDelegate *appDelegate = (MastryAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
        //[[NSApp modalWindow] makeKeyWindow];
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
        
        //[self.indicatorView hideAndStopAnimating];
        
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
        //[self.window setStyleMask:NSWindowStyleMaskTitled];
        //[self.window display];
        //[self.window layoutIfNeeded];
        //[self.window setViewsNeedDisplay:YES];
        
    //});
    
}

-(void)deleteSelectedTableEntry:(int)row
{
    NSLog(@"deleteSelectedTableEntry row:  %d", row);
    if( row < _dataModel.documents.count)
    {
        //[self populateDataModelPropertiesFromInputFields];
        
        __block CMThruConnection * thruConnectionDOM = [_dataModel.documents objectAtIndex:row];
        __block CMThruConnection * thruConnectionKey = [_dataModel.keys objectAtIndex:row];

        assert(thruConnectionDOM);
        //__weak typeof(self) weakSelf = self;
        
        //[self.indicatorView showAndStartAnimating];


        __block NSString * domTitle = self.dataModel.domTitle;
        __block NSString * domid = thruConnectionDOM.primaryKey;
        //__block NSString * domid = _dataModel.primaryKey;

        __weak typeof(self) weakSelf = self;
        NSDocumentQueryClosure documentsDeleteClosure = ^(NSDocumentObjectModel*dom, NSError * __nullable error, NSArray* __nullable results)
        {
           //FYI, we are no longer on the main thread we are on the NSReQLSession query queue!
           NSLog(@"CMThruMScrollListView::documentsDeleteClosure results: \n\n%@", results);
           
           if( error )
           {
               NSString * title = [NSString stringWithFormat:@"Delete %@(s) Failed", domTitle];
               [weakSelf showAlertView:title message:error.localizedDescription async:YES];
               return;
           }
           else if( results && results.count > 0 )
           {
               if( [results.firstObject isKindOfClass:[NSArray class] ])
               {
                   for(int i = 0; i < ((NSArray*)results.firstObject).count; i++)
                   {
                       
                       NSDictionary * resultDict = [((NSArray*)results.firstObject) objectAtIndex:i];
                       NSNumber * numErrors = resultDict[@"errors"];
                       NSNumber * numInsertions = resultDict[@"deleted"];
                       if( numErrors.intValue > 0 || numInsertions.intValue != 1 )
                       {
                           NSString * errorMessage = @"Unknown Delete Error";
                           if( numErrors.intValue > 0 && resultDict[@"first_error"])
                               errorMessage = resultDict[@"first_error"];
                           NSString * title = [NSString stringWithFormat:@"Delete %@(s) Failed at Index %d", domTitle, i];
                           [weakSelf showAlertView:title message:errorMessage async:YES];
                           return;
                       }
                       
                   }
                   
                   
               }
               else
               {
                   assert(results.count == 1);
                   NSDictionary * resultDict = [results objectAtIndex:0];
                   NSNumber * numErrors = resultDict[@"errors"];
                   NSNumber * numInsertions = resultDict[@"deleted"];
                   if( numErrors.intValue > 0 || numInsertions.intValue != 1 )
                   {
                       NSString * errorMessage = @"Unknown Delete Error";
                       if( numErrors.intValue > 0 && resultDict[@"first_error"])
                           errorMessage = resultDict[@"first_error"];
                       NSString * title = [NSString stringWithFormat:@"Delete %@(s) Failed", domTitle];
                       [weakSelf showAlertView:title message:errorMessage async:YES];
                       return;
                   }
                   
               }
           }
            
            //success
            NSString * msg = [NSString stringWithFormat:@"%@ Document (%@) deleted Successfully!", domTitle, domid];

            
           //delete the entry from the data array and the cell form the table
            
            if( [weakSelf.dataModel.dictionary objectForKey:thruConnectionDOM.primaryKey ])
            {
                [weakSelf.dataModel.dictionary removeObjectForKey:thruConnectionDOM.primaryKey];
                [weakSelf.dataModel.documents removeObject:thruConnectionDOM];
                [weakSelf.dataModel.keys removeObject:thruConnectionKey];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{

                //NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:row];
                //[weakSelf.tableView beginUpdates];
                //[weakSelf.tableView removeRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectNone];
                //[weakSelf.tableView endUpdates];

                [weakSelf showAlertView:@"Success" message:msg async:NO];
                
            });
           return;
        };

        [self.dataModel deleteDocuments:@[ thruConnectionDOM ] withClosure:documentsDeleteClosure andOptions:nil];
          
        //self.dataModel.del
    }
    else{
        [self showAlertView:@"Delete Error" message:@"Intended row for deletion is out of Data Model internal array storage bounds!" async:YES];

        
    }
    
}

-(void)editMenuItemClicked:(id)sender
{
    if( self.tableView.clickedRow < CMClient.numThruConnections)
    {
        
        CMThruConnection * thruConnection = [_dataModel.documents objectAtIndex:self.tableView.clickedRow];
        thruConnection.row = self.tableView.clickedRow;
        [[CMThruApplicationDelegate sharedInstance] openThruConnectionModalWindow:thruConnection.ThruID];
        
    }
}

-(void)deleteMenuItemClicked:(id)sender
{
    //[self.indicatorView showAndStartAnimating];

    assert(CMClient.numThruConnections > 0);
    if( self.tableView.clickedRow < CMClient.numThruConnections)
    {
        //show the alert view
        
        __block NSArray * modalButtonTitles = @[@"No", @"Yes"];
        __block int clickedRow = (int)self.tableView.clickedRow;
        void (^modalCompetionBlock)(int returnCode) = ^void(int returnCode)
        {
            if( returnCode == NSAlertFirstButtonReturn)
            {
                NSLog(@"User cancelled delete");
                
            }
            else if( returnCode == NSAlertSecondButtonReturn )
            {
                NSLog(@"Proceed with delete");
                
                //submit the delete request
                [self deleteSelectedTableEntry:clickedRow];
                /*
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                 */
            }
            //Since our implementation is abstract, only the MastryDocumentObjectModel child class implementations know how to interpret the response data for their POST requests
            //We use a delegate
            //dispatch_async(dispatch_get_main_queue(), ^{
            //    [self.indicatorView hideAndStopAnimating];
            //});
            
            //NSLog(@"ScrollListView JSON Response: \n\n%@", arrayOfDicts);
            //self.entries = [NSMutableArray arrayWithArray:arrayOfDicts];
            

        };
        
        assert(_dataModel.documents.count > 0);
        if( self.tableView.clickedRow < _dataModel.documents.count)
        {
            NSString * deleteMessage = [NSString stringWithFormat:@"Are you sure you want to delete the selected MIDI Thru Connection?\n\n"];
            NSString * modelEntryDictStr = [[NSString alloc] initWithFormat:@"%@", ((CMDOM*)[_dataModel.documents objectAtIndex:self.tableView.clickedRow]).primaryKey];
            deleteMessage = [deleteMessage stringByAppendingString:modelEntryDictStr];
            NSLog(@"Delete Entries: \n%@", modelEntryDictStr);

            [self.dataModel showAlertView:@"Delete Thru Connection" message:deleteMessage buttonTitles:modalButtonTitles completionHandler:modalCompetionBlock];
            //[self.dataModel submitGetManyRequestWithQueryParams:nil andCompletionHandler:getManyDataModelCompetionBlock];
        }
        
        /*
        MastryAdminAppDelegate *appDelegate = (MastryAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
        
        MastryDocumentObjectModel * dataModel = nil;
        if( self.dataModel.type == MASTRY_ARTIST )
        {
            dataModel = [[MastryArtist alloc] initWithDictionary:[self.entries objectAtIndex:self.selectedRow] ];
        }
        else if(  self.dataModel.type == MASTRY_USER )
        {
            dataModel = [[MastryUser alloc] initWithDictionary:[self.entries objectAtIndex:self.selectedRow] ];
        }
        else if(  self.dataModel.type == MASTRY_DIGITAL_PAINTING )
        {
            dataModel = [[MastryDigitalPainting alloc] initWithDictionary:[self.entries objectAtIndex:self.selectedRow] ];
        }
        
        [appDelegate openModalWindowWithDataModel:dataModel];
        */
    }
}

-(void)createTableViewMenu
{
    NSMenu* menu = [NSMenu new];
    /*
    NSMenuItem* editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Modify"
                                                          action:@selector(editMenuItemClicked:)
                                                   keyEquivalent:@""];
    */

    NSMenuItem* editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Edit"
                                                          action:@selector(editMenuItemClicked:)
                                                   keyEquivalent:@""];

    NSMenuItem* deleteMenuItem = [[NSMenuItem alloc] initWithTitle:@"Delete"
                                                          action:@selector(deleteMenuItemClicked:)
                                                   keyEquivalent:@""];
    
    
    //[menu addItem:editMenuItem];
    [menu addItem:editMenuItem];
    [menu addItem:deleteMenuItem];
    _tableView.menu = menu;
        
}


-(void)createTableView
{
    self.tableView = [[NSTableView alloc]  initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    _tableView.allowsColumnReordering = NO;
    [_tableView setFocusRingType:NSFocusRingTypeNone];
    _tableView.wantsLayer = YES;
    _tableView.layer.backgroundColor = [NSColor clearColor].CGColor;
    _tableView.backgroundColor = [NSColor clearColor];

    _tableView.gridColor = [NSColor darkGrayColor];
    _tableView.gridStyleMask = NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask;
    _tableView.style = NSTableViewStyleFullWidth;
    //_tableView.usesAlternatingRowBackgroundColors = YES;
    //create columns for our table by looping over each property in the data model
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([CMThruConnection class], &count);
    
    self.columnDict = [NSMutableDictionary new];
    self.keys = [NSMutableArray new];
    
    for( int i = 0; i< count; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [self.keys addObject:key];
        
        NSTaggedTableColumn * column = [[NSTaggedTableColumn alloc] initWithIdentifier:key];
        column.title = key;
        column.tag = i;

        _defaultColumnWidth = column.width;
        
        [_tableView addTableColumn:column];
                
        [self.columnDict setObject:column forKey:key];
    }
    free(properties);
    
    //set table view delegates
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    //embed the table view in the scroll view, and add the scroll view to our window
    [self setDocumentView:_tableView];
    self.hasVerticalScroller = NO;
    self.hasHorizontalScroller = NO;

    
    /*
    _tableView.translatesAutoresizingMaskIntoConstraints = NO; //Window will not resize unless this is set to NO
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:_tableView
                                                                attribute: NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:_tableView.superview
                                                                attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:_tableView
                                                                attribute: NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:_tableView.superview
                                                                attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0f constant:0.0f];

    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_tableView
                                                                attribute: NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:_tableView.superview
                                                                attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f constant:0.0f];



    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:_tableView
                                                                attribute: NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                   toItem:_tableView.superview
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:0.0f];

    [_tableView.superview addConstraints:@[ top, height, left, width]];
    
    */
    [_tableView reloadData];

}

- (void)scrollWheel:(NSEvent *)theEvent
{
    // Do nothing: disable scrolling altogether
}


- (nullable __kindof NSView *)makeTextFieldWithIdentifier:(NSUserInterfaceItemIdentifier)identifier owner:(nullable id)owner
{
    
    NSTextField * titleLabel = [[NSTextField alloc] init];
    [titleLabel setCell: [[CMTextFieldCell alloc] init]];

    titleLabel.frame = CGRectMake(0,200,200,50);

    titleLabel.focusRingType = NSFocusRingTypeNone;
    titleLabel.stringValue  = identifier;
    //_titleLabel.font = [NSFont systemFontOfSize:36.0];
    titleLabel.wantsLayer = YES;
    //self.titleLabel.bordered = YES;
    titleLabel.delegate = self;
    //self.titleLabel.enabled = YES;
    titleLabel.editable = YES;
    titleLabel.drawsBackground = NO;
    titleLabel.layer.masksToBounds = NO;
    
    //self.titleLabel.usesSingleLineMode = NO;
    //self.titleLabel.maximumNumberOfLines = 1;
    titleLabel.textColor = NSColor.grayColor;
    titleLabel.backgroundColor = [NSColor clearColor];
    titleLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    titleLabel.bezeled         = NO;
    titleLabel.editable        = NO;
    titleLabel.drawsBackground = NO;
    
    return titleLabel;
}

//- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row NS_SWIFT_UI_ACTOR API_AVAILABLE(macos(10.7));
- (nullable __kindof NSView *)makeViewWithIdentifier:(NSUserInterfaceItemIdentifier)identifier owner:(nullable id)owner
{
    if( [identifier localizedCompare:CMThruConnection.primaryKey] == NSOrderedSame )
    {
        return [self makeTextFieldWithIdentifier:identifier owner:owner];
    }
    else
    {
        NSPopUpButton * popupButton = [[NSPopUpButton alloc] initWithFrame:CGRectZero pullsDown:NO];
        popupButton.enabled = YES;
        
        
        if( [identifier localizedCompare:@"Input"] == NSOrderedSame)
        {
            for( int i = 0; i < CMClient.numSources; i++)
            {
                [popupButton addItemWithTitle:[NSString stringWithUTF8String:CMClient.sources[i].name]];
            }
        }
        else if( [identifier localizedCompare:@"Output"] == NSOrderedSame)
        {
            for( int i = 0; i < CMClient.numDestinations; i++)
            {
                [popupButton addItemWithTitle:[NSString stringWithUTF8String:CMClient.destinations[i].name]];
            }
        }
        
        return popupButton;
    }
    
    return nil;
}


-(nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id value = nil;
    if( self.dataModel )
    {
      
        //Cast NSTableColumn to our Custotm TTagged Column Object Type
        assert( [tableColumn isKindOfClass:[NSTaggedTableColumn class]] );
        NSTaggedTableColumn * taggedColumn = (NSTaggedTableColumn*)tableColumn;
        
        //Get the DOM data model class property list (so we can check fo non-standard property types and handle them)
        //unsigned int count = 0;
        //objc_property_t *properties = class_copyPropertyList([self.dataModel class], &count);
        
        if( self.dataModel == CMThru )
        {
            CMThruConnection * thruConnectionDOM = [CMThru.documents objectAtIndex:row];

            if( taggedColumn.tag > 4 )
            {
                NSArray * filterIdentifiers = @[@"CC", @"SysEx", @"MTC", @"Beat Clock", @"Tune Request"];
                NSCheckboxView * checkboxView = [[NSCheckboxView alloc] initWithIdentifiers:filterIdentifiers Title:nil Justification:NSTextAlignmentLeft];
                
                for( NSButton * button in checkboxView.buttons ) button.enabled = NO;
                if( thruConnectionDOM.connection->params.filterOutAllControls ) ((NSButton*)[checkboxView.buttons objectAtIndex:0]).state = NSControlStateValueOn;
                if( thruConnectionDOM.connection->params.filterOutSysEx ) ((NSButton*)[checkboxView.buttons objectAtIndex:1]).state = NSControlStateValueOn;
                if( thruConnectionDOM.connection->params.filterOutMTC ) ((NSButton*)[checkboxView.buttons objectAtIndex:2]).state = NSControlStateValueOn;
                if( thruConnectionDOM.connection->params.filterOutBeatClock ) ((NSButton*)[checkboxView.buttons objectAtIndex:3]).state = NSControlStateValueOn;
                if( thruConnectionDOM.connection->params.filterOutTuneRequest ) ((NSButton*)[checkboxView.buttons objectAtIndex:4]).state = NSControlStateValueOn;

                return checkboxView;
            }
            else
            {
                NSTextField * textField = [self makeTextFieldWithIdentifier:tableColumn.identifier owner:self];
                
                if( [tableColumn.identifier localizedCompare:@"ThruID"]  == NSOrderedSame)
                {
                    textField.stringValue = thruConnectionDOM.ThruID;
                }
                else if( [tableColumn.identifier localizedCompare:@"Input"] == NSOrderedSame)
                {
                    textField.stringValue = thruConnectionDOM.Input;
                }
                else if( [tableColumn.identifier localizedCompare:@"InputDriver"] == NSOrderedSame)
                {
                    textField.stringValue = thruConnectionDOM.InputDriver;
                }
                else if( [tableColumn.identifier localizedCompare:@"Output"] == NSOrderedSame)
                {
                    textField.stringValue = thruConnectionDOM.Output;
                }
                else if( [tableColumn.identifier localizedCompare:@"OutputDriver"] == NSOrderedSame)
                {
                    textField.stringValue = thruConnectionDOM.OutputDriver;
                }
                
                return textField;
            }
        }
        else
        {
            if(row == 0 )
            {
                if( taggedColumn.tag > 2 ) return nil;

                NSView * view = [self makeViewWithIdentifier:tableColumn.identifier owner:self];
                
                if( [view isKindOfClass:[NSTextField class]] )
                {
                    NSTextField * textField = (NSTextField*)view;
                    textField.editable = YES;
                    textField.placeholderString = @"Enter ThruID";
                    textField.stringValue = @"";
                }
                //cell.textField.stringValue = tableColumn.identifier;
                //cell.textField.font = [NSFont systemFontOfSize:10];
                //return cell;
             
                return view;
            }
            if( row == 1 )
            {
                ButtonTableViewCell *footerCell = [[ButtonTableViewCell alloc] init];//[ tableView makeViewWithIdentifier:@"FooterCell" owner:nil ]; // use custom cell view class
                return footerCell;
            }
        }
    }
    return value;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if( self.dataModel )
    {
        if( self.dataModel == CMThru)
            return CMThru.documents.count;
        else
            return 2;
        
    }
    
    return 0;
}

-(void)redraw{
    
    [self.tableView setNeedsLayout:YES];
    [self.tableView setNeedsDisplay:YES];
    [self.tableView reloadData];
    [self.tableView display];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // erase the background by drawing white
    [_fillColor set];
    [NSBezierPath fillRect:dirtyRect];
    

    NSTaggedTableColumn * filterColumn = [self.columnDict objectForKey:@"Filter"];
    [filterColumn setWidth:self.frame.size.width - (5.f*_defaultColumnWidth)];
    
}

@end
