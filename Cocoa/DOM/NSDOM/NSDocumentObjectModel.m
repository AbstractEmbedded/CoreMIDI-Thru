//
//  NSDocumentModel.m
//  MastryAdmin
//
//  Created by Joe Moulton on 6/7/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSDocumentObjectModel.h"

/***
 *  NSDocumentStoreConnection
 ***/
@interface NSDocumentStoreConnection()
{
    
    
}

//Documents can have an inherent type enumeration association
//Independent of the "Collection" that they belong to
//@property (nonatomic, readonly) NSString * URL;
//@property (nonatomic, readonly) NSString* id;

@end

@implementation NSDocumentStoreConnection

@end


/***
 *  NSDocumentObjectModel
 ***/
@interface NSDocumentObjectModel()
{
    NSMutableArray * _documents;
    
    NSMutableArray * _sectionKeys;
    NSMutableDictionary * _sectionHash;
}

@end

@implementation NSDocumentObjectModel

@synthesize documents = _documents;

-(NSMutableDictionary*)SectionHash
{
    if( !_sectionHash ) _sectionHash = [NSMutableDictionary new];
    return _sectionHash;
}

-(NSMutableArray*)SectionKeys
{
    if( !_sectionKeys ) _sectionKeys = [NSMutableArray new];
    return _sectionKeys;
}


+(int)type
{
    return -1;
}

/*
+(NSString*)domTitle
{
    NSLog(@"NSDOM::domTitle = %d", self.class.type);
    if(self.class.type > -1 && self.type < NUM_DOM_COLLECTIONS + NUM_EXT_DOM_COLLECTIONS)
    {
        if( self.type >= NUM_DOM_COLLECTIONS )
        {
            NSLog(@"NSDOM::domTitle = %@",  [NSString stringWithUTF8String:VRT_EXT_DOM_TITLES[self.class.type - NUM_DOM_COLLECTIONS]]);
            return [NSString stringWithUTF8String:VRT_EXT_DOM_TITLES[self.class.type - NUM_DOM_COLLECTIONS]];
        }
        else
            return [NSString stringWithUTF8String:VRT_DOM_TITLES[self.class.type]];
    }
    return @"(Unknown DOM Type)";
}

+(NSString*)collectionTitle
{
    NSLog(@"NSDOM::collectionTitle");

    if(self.class.type > -1 && self.type < NUM_DOM_COLLECTIONS + NUM_EXT_DOM_COLLECTIONS)
    {
        if( self.type >= NUM_DOM_COLLECTIONS )
        {
            NSLog(@"NSDOM::collectionTitle = %@",  [NSString stringWithUTF8String:VRT_EXT_DOM_COLLECTION_TITLES[self.class.type - NUM_DOM_COLLECTIONS]]);
            return [NSString stringWithUTF8String:VRT_EXT_DOM_COLLECTION_TITLES[self.class.type - NUM_DOM_COLLECTIONS]];
        }
        else
            return [NSString stringWithUTF8String:VRT_DOM_COLLECTION_TITLES[self.class.type]];
    }
    return @"(Unknown DOM Type)";
}
*/

-(int)type
{
    return self.class.type;
}

-(NSString*)domTitle
{
    NSLog(@"NSDocumentObjectModel::domTitle = %@", self.class.domTitle);
    return self.class.domTitle;
}

-(NSString*)collectionTitle
{
    NSLog(@"NSDocumentObjectModel::collectionTitle = %@", self.class.collectionTitle);
    return self.class.collectionTitle;
}


+(NSString*)primaryKey
{
    return @"id";
    //return [NSString stringWithUTF8String:property_getName(NSDocumentObjectModel.id)];
}

-(NSString*)primaryKeyID
{
    return self.class.primaryKey;
}

-(void)dealloc
{
    [_documents removeAllObjects];
}

-(id)init{
    
    if( (self = [super init]) )
    {
        _documents = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString*)primaryKey
{
    return [self valueForKey:self.class.primaryKey];
}

-(void)setPrimaryKey:(NSString*)keyValue
{
    [self setValue:keyValue forKey:self.class.primaryKey];
}

-(NSString*)DocumentUpdateNotification
{
    return nil;
}

-(void)sendDocumentNotification:(NSDictionary* __nullable)NotificationDict
{
    //post notification on asynchronous background thread
    assert (self.DocumentUpdateNotification );
    [[NSNotificationCenter defaultCenter] postNotificationName:self.DocumentUpdateNotification object:nil userInfo:NotificationDict];
}

@end
