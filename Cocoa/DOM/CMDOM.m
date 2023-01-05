//
//  CMDOM.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/29/22.
//

#import "CMDOM.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
//#import "OSTextField.h"

#define OSTextField NSTextField

@interface CMDOMError()
{
    
}


//@property (nonatomic) int state;
//@property (nonatomic, retain) NSString * description;

@end

@implementation CMDOMError

@end

@interface CMDOM()
{
    //NSString * _DocumentID;
    //NSString * __id;    //every database model will have _id, but we don't want/need to expose it in our https calls or user interface fields
    NSString * _id;

    NSArray * _csvFields;
    
    NSString * _GET_URL;
    NSString * _CREATE_URL;
    
    NSString * _DELETE_URL;
    NSString * _DELETE_MANY_URL;

    NSString * _CREATE_MANY_URL;
    NSString * _GET_MANY_URL;
    NSString * _POST_MANY_URL;

    //NSArray * _requiredProperties;
    int _type;
}


@end

@implementation CMDOM

/*
+(int)type
{
    return -1;
}
*/

//Usage:
//To expose the superclass readonly properties to their child class instantiations...
//declare the same @synthesize statements in the child class implementation (.m) files
//...by including the "NSObject+JSON" protcol in the child class, but no this parent class,
//we can prevent the parent class properties we don't want to expose over http(s)
//from being "JSON'ified" when we call [NSObject+JSON mapToDictionary];
//@synthesize id = _id
@synthesize id = _id;
//@synthesize DocumentID = _DocumentID;

//@synthesize documents = _documents;

@synthesize csvFields = _csvFields;

@synthesize CREATE_URL = _CREATE_URL;
@synthesize CREATE_MANY_URL = _CREATE_MANY_URL;

@synthesize GET_MANY_URL = _GET_MANY_URL;

@synthesize DELETE_URL = _DELETE_URL;
@synthesize DELETE_MANY_URL = _DELETE_MANY_URL;


//@synthesize type = _type;

//Notifications Stuff

-(void)addDocumentNotificationObserver:(id)observer notificationCallback:(SEL)notificationCallback
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:notificationCallback name:self.InsertedDocumentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:notificationCallback name:self.DeletedDocumentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:notificationCallback name:self.ModifiedDocumentsNotification object:nil];
}


-(void)removeDocumentNotificationObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:self.InsertedDocumentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:self.DeletedDocumentsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:self.ModifiedDocumentsNotification object:nil];
}

+(NSArray*)requiredProperties
{
    return @[];
}



//Constructor/Destructor


-(id)init{
    
    self = [super init];
    if( self )
    {
        //NSLog(@"CMDOM init");
        self.documents = [[NSMutableArray alloc] init];
        self.keys = [[NSMutableArray alloc] init];
        self.dictionary = [[NSMutableDictionary alloc] init];

    }
    return self;

}

-(instancetype)initWithPrimaryKey:(NSString*)primaryKey
{
    if( (self = [super init]) )
    {
        [self setValue:primaryKey forKey:[self class].primaryKey];
        
        //NSLog(@"CMDOM initWithPrimaryKey");
        self.documents = [[NSMutableArray alloc] init];
        self.keys = [[NSMutableArray alloc] init];
        self.dictionary = [[NSMutableDictionary alloc] init];
        _id = primaryKey;
        //self.primaryKey = _id;
    }
    return self;
}

-(instancetype)initWithDocumentID:(NSString*)documentID
{
    if( (self = [super init]) )
    {
        self.documents = [[NSMutableArray alloc] init];
        _id = documentID;
    }
    return self;
    
}


-(void)dealloc
{
    //NSLog(@"CMDOM dealloc");
    [self.documents removeAllObjects];
    //self.documents = nil;
}

//Notification Stuff
+(int)type
{
    return -1;
}

-(int)type
{
    return self.class.type;
}

-(NSString*)primaryKey
{
    return [super primaryKey];
    
}

-(NSString*)InsertedDocumentsNotification
{
    return nil;
}

-(NSString*)DeletedDocumentsNotification
{
    return nil;
}

-(NSString*)ModifiedDocumentsNotification
{
    return nil;
}

+(NSString*)getDocumentTitle:(NSDictionary*)document
{
    return document[self.class.primaryKey];
}


+(NSString*)getDocumentDetailString:(NSDictionary*)document
{
    return @"CMDOM Document Detail String";
}

/*
-(void)sendDocumentStoreNotification:(NSString*)notificationName documents:(NSDictionary* __nullable)documents
{
    //post notification on asynchronous background thread
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:nil
                                                      userInfo:documents];
}

-(BOOL)checkForInvalidChars:(NSString*)INVALID_CHAR_STR inString:(NSString*)string lineIndex:(int)lineIndex field:(NSString*)fieldKey
{
    NSLog(@"checking for invalid chars in: %@ -- end", string);
    NSCharacterSet *INVALID_CHAR_SET = [NSCharacterSet characterSetWithCharactersInString:INVALID_CHAR_STR];
    
    NSRange range = [string rangeOfCharacterFromSet:INVALID_CHAR_SET];
    if (range.location != NSNotFound)
    {
        NSString *errMsg;
        if( [string containsString:@","] )
            errMsg = [NSString stringWithFormat:@"Line %d -- Extra comma(s) present."];
        else
        {
            NSString *prettyStr = [INVALID_CHAR_STR stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            prettyStr = [prettyStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            prettyStr = [prettyStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];

            errMsg = [NSString stringWithFormat:@"Line %d -- Invalid Character found in %@ field:\n\n%@\n\nThe following characters are not allowed: \n\n%@", lineIndex+1, fieldKey, string, prettyStr ];
        }
        [self showAlertView:@"Failed to Parse CSV" message:errMsg buttonTitles:nil completionHandler:nil];
        //return nil;
        return YES;
    }
    
    return NO;
}
*/


-(CMDOMError*)populatePropertiesFromDictionary:(NSDictionary*)fields
{
    CMDOMError * domErr = nil;//[[CMDOMError alloc] init];
    NSLog(@"CMDOM::populatePropertiesFromDictionary");
    unsigned int count = 0;
    //NSMutableDictionary *dictionary = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    //loop over each NSObject property
    for (int i = 0; i < count; i++) {
        
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        id valueContainer = [fields objectForKey:propertyName];
        id value;
        if( [valueContainer isKindOfClass:[OSTextField class]])
        {
            OSTextField *tf = (OSTextField*)valueContainer;
            value = tf.stringValue;//[propertyName];
        }
        
        
        if( value && [value isKindOfClass:[NSString class]] && ((NSString*)value).length > 0 )
        {
            //[self setValue:value forKey:propertyName];

            //Most properties deriving from NSObject need to be converted directly to a NSString
            //Before placing in the NSDictionary converted to JSON
            NSString * strValue = [NSString stringWithFormat:@"%@",value];
            NSLog(@"strValue = %@", strValue);
            ObjCPropertyType type = getPropertyType(properties[i]);
            if( type == NS_TYPE_DOUBLE )//!= NS_TYPE_ID && type != NS_TYPE_OBJECT )
            {
                NSLog(@"NS_TYPE_DOUBLE");
                NSNumber * num = [NSNumber numberWithDouble:strValue.doubleValue];
                [self setValue:num forKey:propertyName];
            }
            else if( type == NS_TYPE_INT )
            {
                NSLog(@"NS_TYPE_INT");
                NSNumber * num = [NSNumber numberWithInt:strValue.intValue];
                [self setValue:num forKey:propertyName];
            }
            else if( type == NS_TYPE_BOOL )
            {
                NSLog(@"NS_TYPE_BOOL");
                [self setValue:[NSNumber numberWithBool:(BOOL)strValue.boolValue] forKey:propertyName];
            }
            else if( type ==  NS_TYPE_DATE )
            {
                NSLog(@"NS_TYPE_DATE");

                NSString *dateString = strValue;//(NSString*)value;//@"01-02-2010";
                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];

                   NSDate *dateVal = [dateFormatter dateFromString:dateString];
                   //NSArray * reqlISO8601Date = @[ @(REQL_ISO8601), @[ dateVal.ISO8601 ]];
                   [self setValue:dateVal forKey:propertyName];
                
            }
            else if( type ==  NS_TYPE_STRING )
            {
                NSLog(@"NS_TYPE_DATE");

                if( strValue.length < 1 )
                {
                    //NSLog(@"req props = %@", [[self class] requiredProperties]);
                    if( [[[self class] requiredProperties] containsObject:propertyName])
                    {
                        domErr = [[CMDOMError alloc] init];
                        domErr.state = CM_DOM_MISSING_REQUIRED_FIELD;
                        domErr.message = [NSString stringWithFormat:@"%s (%@)", CM_DOM_ERROR_STATES[domErr.state], propertyName];
                        break;
                    }
                }
                else if ([strValue localizedCompare:@"null"] == NSOrderedSame || [strValue localizedCompare:@"<null>"] == NSOrderedSame )
                {
                    [self setValue:[NSNull null] forKey:propertyName];
                    //[dictionary setObject:[NSNull null] forKey:key];
                }
                else
                {
                    [self setValue:value forKey:propertyName];
                }
                
            }
            else if( type == NS_TYPE_OBJECT )
            {
                //NSLog(@"NS_TYPE_OBJECT");

                if( [value isKindOfClass:[NSDictionary class]] )
                {
                    [self setValue:value forKey:propertyName];
                }
                else if( [value isKindOfClass:[NSDate class]] )
                {
                   
                    

                }
              
                else if( [value isKindOfClass:[NSArray class]] )
                {

                }
                else if( [value isKindOfClass:[NSString class]] )
                {
                    if( strValue.length < 1 )
                    {
                        //NSLog(@"req props = %@", [[self class] requiredProperties]);
                        if( [[[self class] requiredProperties] containsObject:propertyName])
                        {
                            domErr = [[CMDOMError alloc] init];
                            domErr.state = CM_DOM_MISSING_REQUIRED_FIELD;
                            domErr.message = [NSString stringWithFormat:@"%s (%@)", CM_DOM_ERROR_STATES[domErr.state], propertyName];
                            break;
                        }
                    }
                    else if ([strValue localizedCompare:@"null"] == NSOrderedSame )
                    {
                        [self setValue:[NSNull null] forKey:propertyName];
                        //[dictionary setObject:[NSNull null] forKey:key];
                    }
                    else
                    {
                        [self setValue:value forKey:propertyName];
                    }
                }
                else
                    [self setValue:strValue forKey:propertyName];
                          
            }
            else if( type == NS_TYPE_ID )
            {
                NSLog(@"NSObject+JSON::mapToDictionary NS_TYPE_ID");
            }
            else
                NSLog(@"NSObject+JSON::mapToDictionary NS_TYPE_UNKNOWN");
        }
        else //handle Null Properties here
        {
            //NSLog(@"req props = %@", [[self class] requiredProperties]);
            if( [[[self class] requiredProperties] containsObject:propertyName])
            {
                //check if the root class set a default value for this property
                if( ![self valueForKey:propertyName] )
                {
                    domErr = [[CMDOMError alloc] init];
                    domErr.state = CM_DOM_MISSING_REQUIRED_FIELD;
                    domErr.message = [NSString stringWithFormat:@"%s (%@)", CM_DOM_ERROR_STATES[domErr.state], propertyName];
                    break;
                }
            }
            
        }
            
        
    }
            
    
    for (int i = 0; i < count; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id valueContainer = [self valueForKey:propertyName];
        NSLog(@"%@ = %@", propertyName, valueContainer);
    }
    free(properties);
    
    return domErr;
}



#if (defined(TARGET_OS_IOS) && TARGET_OS_IOS) || (defined(TARGET_OS_TV) && TARGET_OS_TV)

-(void)showAlertView:(NSString *)title message:(NSString *)message completionHandler:(void (^ __nullable)(int returnCode))handler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //stop the activity indicator if visible/spinning
        //[self.indicatorView hideAndStopAnimating];
        
        UIAlertView * alertView  = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
    });
}

#else

- (void)processAlertReturnCode:(NSInteger)returnCode
{
    if (returnCode == NSModalResponseOK )//|| returnCode == NSOKButton)
    {
        NSLog(@"(returnCode == NSOKButton)");
        //[self.window makeKeyWindow];
    }
    else if (returnCode == NSModalResponseCancel )//|| returnCode == NSCancelButton)
    {
        NSLog(@"(returnCode == NSCancelButton)");
        
        //MineralismAdminAppDelegate *appDelegate = (MineralismAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
        [[NSApp modalWindow] makeKeyWindow];
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
        NSLog(@"All Other return code %d",(int)returnCode);
    }
    
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    
    [self processAlertReturnCode:returnCode];
    
}
-(void)showAlertView:(NSString*)title message:(NSString*)message buttonTitles:(NSArray * __nullable)buttonTitles completionHandler:(void (^ __nullable)(int returnCode))handler
{
    
    //MineralismAdminAppDelegate *appDelegate = (MineralismAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
    //[self.window setStyleMask:appDelegate.modalWindowStyleMask];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //[self.indicatorView hideAndStopAnimating];
        
        NSAlert *alert = [[NSAlert alloc] init];
        //alert.delegate = self;
        //[alert addButtonWithTitle:@"Continue"];
        //[alert addButtonWithTitle:@"OK"];
        
        if( buttonTitles && buttonTitles.count > 0 )
        {
            for(int buttonIndex=0;buttonIndex<buttonTitles.count; buttonIndex++)
            {
                [alert addButtonWithTitle:[buttonTitles objectAtIndex:buttonIndex] ];
            }
            
        }
        
        [alert setMessageText:title];
        [alert setInformativeText:message];
        [alert setAlertStyle:NSAlertStyleWarning];
        
        //[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        NSModalResponse response = [alert runModal];
        
        [self processAlertReturnCode:response];
        
        if( handler )
            handler((int)(NSInteger)response);
        
        //MineralismAdminAppDelegate *appDelegate = (MineralismAdminAppDelegate *)[[NSApplication sharedApplication] delegate];
        //[self.window setStyleMask:NSWindowStyleMaskTitled];
        //[self.window display];
        //[self.window layoutIfNeeded];
        //[self.window setViewsNeedDisplay:YES];
        
    });
    
}





#endif



@end
