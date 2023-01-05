//
//  CMDOM.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/29/22.
//

#import <Foundation/Foundation.h>
#import "NSDocumentObjectModel.h"
//#import "VRTDOMAdminInterface.h"
#import "NSDate+Ext.h"
#import "NSData+Ext.h"
#import "NSString+Ext.h"
#import "NSObject+JSON.h"

#if (defined(TARGET_OS_IOS) && TARGET_OS_IOS) || (defined(TARGET_OS_TV) && TARGET_OS_TV)
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "CMidiAppInterface.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum CMDocumentState
{
    CM_DOCUMENT_STATE_IDLE = 0//,
    //VRT_ASSET_STATE_OWNED = 1,
    //VRT_ASSET_STATE_OFFER = 2,
    //VRT_ASSET_STATE_UNAVAILABLE
}CMDocumentState;


typedef enum CM_DOM_ERROR_STATE
{
    CM_DOM_STATE_OK = 0,
    CM_DOM_MISSING_REQUIRED_FIELD,
    CM_DOM_MALFORMATED_FIELD
}VRT_DOM_ERROR_STATE;

static const int NUM_CM_DOM_ERROR_STATES = CM_DOM_MALFORMATED_FIELD+1;
static const char * _Nonnull CM_DOM_ERROR_STATES[NUM_CM_DOM_ERROR_STATES] =
{
    "State OK",
    "Missing Required Field",
    "Malformatted Field"
};



@interface CMDOMError : NSObject

@property (nonatomic) int state;
@property (nonatomic, retain) NSString * message;

@end

typedef enum CM_DOM_TYPE
{
    //Mineralism Concrete
    //VRT_SPECIES,
    //VRT_VARIETY,
    //Mastry Concrete
    CM_THRU = 10,
    //MC_PAINTING = VRT_CLIENT_DOM_TYPE + 1,
    //MC_UNPUBLISHED_PAINTING = VRT_CLIENT_DOM_TYPE + 2

    //VRT_LOGIN_USER,          //this must go at the end (special case)
    //VRT_CLIENT_DOM_TYPE
}MASTRY_DOM_TYPE;

/*
static const int CM_NUM_EXT_DOM_MODELS = MC_UNPUBLISHED_PAINTING + 1 - VRT_CLIENT_DOM_TYPE;
static const char * _Nonnull VRT_EXT_DOM_TITLES[VRT_NUM_EXT_DOM_MODELS] =
{
    //Mineralism Concrete
    //"Species",
    //"Variety",
    //Mastry Concrete
    "Artist",
    "Painting",
    "Unpublished"
};

static const int NUM_EXT_DOM_COLLECTIONS = VRT_NUM_EXT_DOM_MODELS;
static const char * _Nonnull VRT_EXT_DOM_COLLECTION_TITLES[NUM_EXT_DOM_COLLECTIONS] =
{
    //Mineralism Concrete
    //"Species",
    //"Varieties",
    //Mastry Concrete
    "Artists",
    "Paintings",
    "Unpublished"
};
*/

@interface CMDOM : NSDocumentObjectModel <NSDocumentStoreQuery>

//@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) NSString* id;
//@property (nonatomic, readonly) NSString* primaryKey;

//@property (nonatomic, readonly) NSString* DocumentID;

//@property (nonatomic, readonly) NSString* DocumentID;
@property (nonatomic, readonly) NSArray* csvFields;

//Constructors
-(instancetype)initWithDocumentID:(NSString*)documentID;
-(instancetype)initWithPrimaryKey:(NSString*)primaryKey;

//Child Class Notification String Method Definitions
-(NSString*)InsertedDocumentsNotification;
-(NSString*)DeletedDocumentsNotification;
-(NSString*)ModifiedDocumentsNotification;


+(NSString*)getDocumentTitle:(NSDictionary*)document;
+(NSString*)getDocumentDetailString:(NSDictionary*)document;


//[Optional] Virtual Methods to be overridden by Child Class Implementations
//...

//Mandatory Parent Class Properties to be overridden by  Child Class Implementations
@property (nonatomic, readonly) NSString * CREATE_URL;
@property (nonatomic, readonly) NSString * CREATE_MANY_URL;

@property (nonatomic, readonly) NSString * GET_URL;
@property (nonatomic, readonly) NSString * GET_MANY_URL;

@property (nonatomic, readonly) NSString * DELETE_URL;
@property (nonatomic, readonly) NSString * DELETE_MANY_URL;

+(NSArray*)requiredProperties;



-(void)showAlertView:(NSString* __nullable)title message:(NSString*)message buttonTitles:(NSArray * __nullable)buttonTitles completionHandler:(void (^ __nullable)(int returnCode))handler;

-(NSString*)primaryKey;
//-(id)class;

-(CMDOMError*)populatePropertiesFromDictionary:(NSDictionary*)fields;



@end

NS_ASSUME_NONNULL_END
