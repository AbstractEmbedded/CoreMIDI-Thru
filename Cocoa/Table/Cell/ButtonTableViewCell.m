//
//  ButtonTableViewCell.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/29/22.
//

#import "ButtonTableViewCell.h"

@interface ButtonTableViewCell()
{
    
    
    NSButton * _submitButton;
    //NSButton * _deleteButton;
    NSButton * _cancelButton;
}


@property (nonatomic, retain) NSButton* cancelButton;
@property (nonatomic, retain) NSButton* submitButton;


@end

@implementation ButtonTableViewCell

@synthesize cancelButton = _cancelButton;
//InheritedTableCellview *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];

/*
-(id)makeViewWithIdentifier:(NSString*)identifier owner:(id)owner
{
    
    
    
    
}
*/



-(NSButton *)createModalButton:(NSString *)title topView:(NSView*)topView selector:(SEL)selector
{
    //CGFloat buttonWidth = 200;
    //CGFloat buttonHeight = 100;
    //CGFloat buttonX = self.view.frame.size.width/2 - buttonWidth/2;
    //CGFloat buttonY = self.view.frame.size.height/2 - buttonHeight/2;
    NSButton * button = [[NSButton alloc] initWithFrame:CGRectMake(0,0,0,100)];//CGRectMake(buttonX,buttonY, buttonWidth, buttonHeight)];
    // button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [button setTitle:title];
    [button setTarget:self];
    [button setAction:selector];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    
    //[self addLoginButtonConstraintsToItem:self fromItem:_loginButton];
    
    NSLayoutConstraint * cx = [NSLayoutConstraint constraintWithItem: button
                                                           attribute: NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem: self attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem: button
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem: topView attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0 constant:20];
    
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem: button
                                                              attribute: NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self attribute:NSLayoutAttributeWidth
                                                             multiplier:0.25 constant:0];
    
    
    [self addConstraints:@[ cx, width, top ]];
    
    return button;
    
}

/*
-(const char *)getCollectionTitle
{
    const char * collectionTitle = nil;
    if( self.dataModel.type > NUM_DOM_COLLECTIONS)
        collectionTitle = VRT_EXT_DOM_COLLECTION_TITLES[self.dataModel.type - NUM_DOM_COLLECTIONS];
    else
        collectionTitle = VRT_DOM_COLLECTION_TITLES[self.dataModel.type];
    return collectionTitle;
}

-(const char *)getDOMTitle
{
    const char * collectionTitle = nil;
    if( self.dataModel.type > NUM_DOM_COLLECTIONS)
        collectionTitle = VRT_EXT_DOM_TITLES[self.dataModel.type - NUM_DOM_COLLECTIONS];
    else
        collectionTitle = VRT_DOM_TITLES[self.dataModel.type];
    return collectionTitle;
}
*/

-(void)submitButtonClicked:(id)sender
{
    //[self.indicatorView showAndStartAnimating];
    /*
    if( self.modalViewMode == ModalView_Create )
    {
        
        
    }
     */
    /*
    else if( self.modalViewMode == ModalView_Create_MANY )
    {
        //TO DO:  verify csv and dir field
        self.indicatorView.label.stringValue = @"Parsing CSV";
        
        //parse csv to create array of nsdictionaries synchronously
        //it will display an error message to the user for us if needed
        NSArray * newEntries = [self.dataModel parseCSV:_csvField.stringValue assetDir:_dirField.stringValue];
        
        //there were errors parsing the csv
        if( !newEntries || newEntries.count < 1)
        {
            [self.indicatorView hideAndStopAnimating];
            return;
        }
        
        self.indicatorView.label.stringValue = @"Uploading Documents";
        HTTPRequestCompletionBlock createManyCompletionBlock = ^void(long statusCode, NSError * error, NSArray * documents)
        {
            //Since our implementation is abstract, only the VRTDOM child class implementations know how to interpret the response data for their POST requests
            //We use a delegate
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView hideAndStopAnimating];
            });
        };
        
        //[self.dataModel submitCreateManyRequestWithCSV:_csvField.stringValue andAssetDir:_dirField.stringValue];
        //[self.dataModel submitCreateManyRequestWithDicts:newEntries andCompletionHandler:createManyCompletionBlock];
    }
     */
}

-(void)cancelButtonClicked:(id)sender
{
    NSLog(@"cancelButtonClicked");
    //CMThruApplicationDelegate *appDelegate = (CMThruApplicationDelegate *)[[NSApplication sharedApplication] delegate];
    //[appDelegate dismissModalWindow];
}

-(void)createModalButtons
{
    //everybody gets a submit button
    
    NSView * topView = self;//[_inputFields objectForKey:[_inputFieldKeys objectAtIndex:_inputFieldKeys.count -1]];
    self.submitButton = [self createModalButton:@"Submit" topView:topView selector:@selector(submitButtonClicked:)];
    self.cancelButton = [self createModalButton:@"Cancel" topView:self.submitButton selector:@selector(cancelButtonClicked:)];

    //self.modalButtons = [NSMutableArray new];
    //[self.modalButtons addObject:self.submitButton];
    //[self.modalButtons addObject:self.cancelButton];

    /*)
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem: self.scrollView
                                                              attribute: NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem: self.cancelButton attribute:NSLayoutAttributeBottom
                                                             multiplier:1 constant:0];
    
    */
    //[self addConstraints:@[ bottom ]];

}


-(id)init
{
    self = [super init];
    if(self)
    {
        [self createModalButtons];
    }
    return self;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createModalButtons];
    }
    return self;

    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
