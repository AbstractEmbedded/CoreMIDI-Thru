//
//  NSDocumentModel.h
//  MastryAdmin
//
//  Created by Joe Moulton on 6/7/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JSON.h"

NS_ASSUME_NONNULL_BEGIN

#define NSDOM NSDocumentObjectModel
#define NSDocumentRequest NSDocumentQuery

typedef enum DOM_UPDATE_OPERATION
{
    DOM_APPEND_OPERATION,
    DOM_INSERT_OPERATION,
    DOM_MODIFY_OPERATION,
    DOM_DELETE_OPERATION,
    DOM_REPLACE_OPERATION
}DOM_UPDATE_OPERATION;


/***
 *  NSDocumentObjectModel
 *
 *  A "Document Object Model" is an abstract object representing
 *  a document in an abstract "Document Store"
 *
 ***/
@interface NSDocumentStoreConnection : NSObject

//Documents can have an inherent type enumeration association
//Independent of the "Collection" that they belong to
@property (nonatomic, readonly) NSString * URL;
//@property (nonatomic, readonly) NSString* id;

@end


@protocol NSDocumentObjectModelData
//-(void)serialize:(NSDocumentResultClosure)closure;
//-(void)deserialize:(NSDocumentResultClosure)closure;
@end

/***
 *  NSDocumentObjectModel
 *
 *  A "Document Object Model" is an abstract object representing
 *  a document in an abstract "Document Store"
 *
 ***/
@interface NSDocumentObjectModel : NSObject

//@property (nonatomic, assign) Class class;

//Documents can have an inherent type enumeration association
//Independent of the "Collection" that they belong to
//@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) NSString* id;

@property (nonatomic, retain) NSMutableArray     * documents;
@property (nonatomic, retain) NSMutableArray     * keys;
@property (nonatomic, retain) NSMutableDictionary* dictionary;

@property (atomic) long row;

-(NSMutableDictionary*)SectionHash;
-(NSMutableArray*)SectionKeys;

+(int)type;
+(NSString*)domTitle;
+(NSString*)collectionTitle;

-(int)type;
-(NSString*)domTitle;
-(NSString*)collectionTitle;

+(NSString*)primaryKey;
-(NSString*)primaryKeyID;
-(NSString*)primaryKey;
-(void)setPrimaryKey:(NSString*)keyValue;


-(NSString *)DocumentUpdateNotification;

//Notification Observer Subscribe/Unsubcribe
//-(void)addDocumentNotificationObserver:(id)observer notificationCallback:(SEL)notificationCallback;
//-(void)removeDocumentNotificationObserver:(id)observer;
-(void)sendDocumentNotification:(NSDictionary* __nullable)NotificationDict;


//Documents in a document store will generally have unique id
//@property (nonatomic, readonly) NSString* DocumentID;

@end

/***
 *  NSDocumentQuery [NSDocumentRequest] Protocol
 *
 *  A "Document Store" is a reference to an abstract local or remote container
 *  for storing data as abstract entries termed "Documents"
 *
 *  An NSDocumentObjectModel class implementation can adhere to this protocol to [asynchronously]
 *  read/write data via queries/requests to a local or remote "Document Store"
 ***/
@protocol NSDocumentStoreQuery

typedef void (^__nullable NSDocumentQueryClosure)   (NSDocumentObjectModel* dom, NSError * __nullable error, NSArray* __nullable results);

//A filepath or remote url to the local or remote or remote proxy to the document store
//(E.g an HTTPS Server, a Reql Server, a Redis Server, an SQLITE database on disk, etc.)
+(NSString*)NSDocumentStoreURL;            //A path to the directory containing the document store or a remote server URL
+(NSString*)NSDocumentStoreContainer;      //A database name or a file name
+(NSString*)NSDocumentStoreCollection;     //A table name or subpath in the file

-(NSString*)NSDocumentStoreURL;            //A path to the directory containing the document store or a remote server URL
-(NSString*)NSDocumentStoreContainer;      //A database name or a file name
-(NSString*)NSDocumentStoreCollection;     //A table name or subpath in the file

+(NSString*)NSDocumentStoreOrderKey;
-(NSString*)NSDocumentStoreOrderKey;


//For some remote document store protocols such as HTTPS we may need to have unique endpoints
//for each document store operation
/*
@optional
-(NSString*)DOM_INSERT_URL;
@optional
-(NSString*)DOM_MODIFY_URL;
@optional
-(NSString*)DOM_DELETE_URL;
*/

-(void)monitorDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSDictionary* __nullable)params updatePreferences:(NSDictionary* __nullable)preferences andOptions:(NSDictionary* __nullable)options;
-(void)readDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSObject* __nullable)params andOptions:(NSDictionary* __nullable)options;
-(void)insertDocuments:(NSArray*)documents withClosure:(NSDocumentQueryClosure)closure andOptions:(NSDictionary* __nullable)options;
-(void)modifyDocuments:(NSArray*)documents withClosure:(NSDocumentQueryClosure)closure andOptions:(NSDictionary* __nullable)options;
-(void)deleteDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSObject* __nullable)params andOptions:(NSDictionary* __nullable)options;
-(void)deleteDocuments:(NSArray*)documents withClosure:(NSDocumentQueryClosure)closure andOptions:(NSDictionary* __nullable)options;


-(void)listenForChangesWithOptions:(NSDictionary*)options andQueryParams:(NSDictionary*)params;

@end




NS_ASSUME_NONNULL_END
