//
//  NSReQLDocumentObjectModel.m
//  MastryAdmin
//
//  Created by Joe Moulton on 6/7/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSReQLDocumentObjectModel.h"
#import "NSReQL.h"

static NSString *const k = @"referer_app_link";

@implementation NSReQLDocumentObjectModel


+(NSString*)NSDocumentStoreURL
{
    return @"DEFAULT";
}
+(NSString*)NSDocumentStoreContainer
{
    return @"DEFAULT";
}
+(NSString*)NSDocumentStoreCollection
{
    return @"DEFAULT";
}

+(NSString*)NSDocumentStoreOrderKey
{
    return @"DEFAULT";
}
/*
-(NSDocumentStoreConnection*)NSDocumentStoreConnection
{
    
    
}
*/

/*
-(NSString *)DocumentUpdateNotification
{
    return nil;
}
*/

-(void)monitorDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSDictionary*)params updatePreferences:(NSDictionary*)preferences andOptions:(NSDictionary*)options
{
    /*
    NSReQLQueryClosure queryCallback = ^(ReqlError * err, NSReQLCursor * cursor){
        
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess )
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else{
            assert(cursor);
            results = [cursor toArray];
            NSLog(@"NSReQLQueryClosure results:\n\n%@\n", results);
        }
        //Return query result to client
        closure(error, results);
    };
    
    //Issue ReQL Query using NSReQL [NSReQLSession] API
    NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
    assert(conn);
    NSReQL.db(self.class.NSDocumentStoreContainer).table(self.class.NSDocumentStoreCollection).filter(params).changes(preferences).run(conn, options, queryCallback);
     */
    __weak typeof(self) weakSelf = self;
    NSReQLQueryClosure queryCallback = ^(ReqlError* err, NSReQLCursor* __nullable cursor){
        
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess )
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else{
            
            //Parse the json data in the cursor buffer
            results = [cursor toArray];
            //NSLog(@"NSReQLQueryClosure results:\n\n%@\n", results);
            
            //since we issued a changefeed query we don't need to check the response type
            //we know it will be REQL_SUCCESS_PARTIAL
            //if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            //[cursor next];
            //ReqlCursorContinue(&_cursor, "{\"max_batch_rows\":2,\"min_batch_rows\":2,\"max_batch_bytes\":512,\"first_batch_scaledown_factor\":1}");

            /*
            //build a continue query
            if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            {
                [cursor continue:options];
            }
            */
        }
        closure(self, error, results);
    };
    
    //Perform a query on the connection
    NSReQLConnection * conn = NSReQL.connection(self.NSDocumentStoreURL);
    NSLog(@"NSDocumentStoreOrderKey = %@", self.class.NSDocumentStoreOrderKey);
    NSReQL.db(self.NSDocumentStoreContainer).table(self.NSDocumentStoreCollection)/*.orderBy(@{ @"index":self.NSDocumentStoreOrderKey })*/.filter(params).changes(preferences).run(conn, options, queryCallback);
}

-(void)readDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSObject*)params andOptions:(NSDictionary* __nullable)options
{
    __weak typeof(self) weakSelf = self;
    NSReQLQueryClosure queryCallback = ^(ReqlError * err, NSReQLCursor * cursor){
        
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess )
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else{
            
            //Parse the json data in the cursor buffer
            results = [cursor toArray];
            if( cursor.responseType == REQL_CLIENT_ERROR )
            {
                NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %@\n", results];
                //NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
                error = [NSError errorWithDomain:NSReQLErrorDomain code:cursor.responseType userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
            }
            
            //NSLog(@"NSReQLQueryClosure results:\n\n%@\n", results);
            
            //since we issued a changefeed query we don't need to check the response type
            //we know it will be REQL_SUCCESS_PARTIAL
            //if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            //[cursor next];
            //ReqlCursorContinue(&_cursor, "{\"max_batch_rows\":2,\"min_batch_rows\":2,\"max_batch_bytes\":512,\"first_batch_scaledown_factor\":1}");
            
            //build a continue query
            
            /*
            if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            {
                //NSReQL.db(weakSelf.NSDocumentStoreContainer).table(weakSelf.NSDocumentStoreCollection).filter(params);//.continue(cursor, options, queryCallback);
                //NSLog(@"Cursor before continue");
                //[cursor continue:options];
                //NSLog(@"Cursor after continue");

            }
            */
        }
        closure(self, error, results);
    };
    
    //Issue ReQL Query using NSReQL [NSReQLSession] API
    NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
    NSReQL.db(self.NSDocumentStoreContainer).table(self.NSDocumentStoreCollection)/*.orderBy(@{ @"index":self.NSDocumentStoreOrderKey })*/.filter(params).run(conn, options, queryCallback);
}

-(void)deleteDocuments:(NSDocumentQueryClosure)closure withQueryParams:(NSObject* __nullable)params andOptions:(NSDictionary* __nullable)options
{
    NSReQLQueryClosure queryCallback = ^(ReqlError * err, NSReQLCursor * cursor){
        
        /*
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess )
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else{
            assert(cursor);
            results = [cursor toArray];
            NSLog(@"NSReQLQueryClosure results:\n\n%@\n", results);
        }
        //Return query result to client
        closure(self, error, results);
        */
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess )
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else{
            
            //Parse the json data in the cursor buffer
            results = [cursor toArray];
            NSLog(@"NSReQLQueryClosure results:\n\n%@\n", results);
            
            //since we issued a changefeed query we don't need to check the response type
            //we know it will be REQL_SUCCESS_PARTIAL
            //if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            //[cursor next];
            //ReqlCursorContinue(&_cursor, "{\"max_batch_rows\":2,\"min_batch_rows\":2,\"max_batch_bytes\":512,\"first_batch_scaledown_factor\":1}");
            
            //build a continue query
            
            if( cursor.responseType == REQL_SUCCESS_PARTIAL )
            {
                //NSReQL.db(weakSelf.NSDocumentStoreContainer).table(weakSelf.NSDocumentStoreCollection)/*.orderBy(@{ @"index":weakSelf.NSDocumentStoreOrderKey })*/.filter(params);//.continue(cursor, options, queryCallback);
                //NSLog(@"Cursor before continue");
                //[cursor continue:options];
                //NSLog(@"Cursor after continue");
                
            }
        }
        closure(self, error, results);
    };
    
    //Issue ReQL Query using NSReQL [NSReQLSession] API
    NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
    NSReQL.db(self.class.NSDocumentStoreContainer).table(self.class.NSDocumentStoreCollection).filter(params).delete(NULL).run(conn, options, queryCallback);
    
}

-(void)deleteDocuments:(NSArray*)documents withClosure:(NSDocumentQueryClosure)closure andOptions:(NSDictionary* __nullable)options
{
    
    /*
    NSReQLQueryClosure queryCallback = ^(ReqlError * err, NSReQLCursor * cursor){
        
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess ) //Create an NSError from ReQLError
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure Insert ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else //Parse the cursor to a results array
        {
            assert(cursor);
            results = [cursor toArray];
            NSLog(@"NSReQLQueryClosure Insert results:\n\n%@\n", results);

            if( results.firstObject && [results.firstObject isKindOfClass:[NSDictionary class]] )
            {
                NSDictionary * resultsDict = (NSDictionary*)results.firstObject;
                //Log the error
                if( [resultsDict[@"errors"] isKindOfClass:[NSNumber class]] )
                {
                    NSNumber * numErrorsNum = (NSNumber*)resultsDict[@"errors"];
                    if( numErrorsNum.integerValue != 0 )
                        NSLog(@"NSReQLQueryClosure Insert results:\n\n%@\n", results);
                }
            }
        }
        //Return query result to client
        closure(self, error, results);
    };
    
    //Issue ReQL Query using NSReQL [NSReQLSession] API
    NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
    NSReQL.db(self.class.NSDocumentStoreContainer).table(self.class.NSDocumentStoreCollection).insert(documents).run(conn, options, queryCallback);
    */
    
    NSMutableArray * deleteDocumentQueriesArray = [NSMutableArray new];
    
    NSArray * dbQuery = [NSArray arrayWithObjects:[NSNumber numberWithInt:REQL_DB],[NSArray arrayWithObjects:self.class.NSDocumentStoreContainer, nil], nil];
    NSArray * tableQuery = [NSArray arrayWithObjects:[NSNumber numberWithInt:REQL_TABLE], [NSArray arrayWithObjects:dbQuery, self.class.NSDocumentStoreCollection, nil], nil];
    //NSArray * getQuery = [NSArray arrayWithObjects:[NSNumber numberWithInt:REQL_GET], [NSArray arrayWithObjects:tableQuery, VRTUserShared.profile.Email, nil], nil];
    
    for( NSDictionary * document in documents )
    {
        NSArray * getQuery = [NSArray arrayWithObjects:[NSNumber numberWithInt:REQL_GET], [NSArray arrayWithObjects:tableQuery, document[self.class.primaryKey], nil], nil];
        NSArray * deleteQuery = [NSArray arrayWithObjects:[NSNumber numberWithInt:REQL_DELETE], [NSArray arrayWithObjects:getQuery, nil], nil];
        [deleteDocumentQueriesArray addObject:deleteQuery];
    }
    
    

        
        NSReQLQueryClosure deleteDocumentsQueryCallback = ^(ReqlError * err, NSReQLCursor * cursor)
        {
            NSArray * results = nil;
            NSError * error = nil;
            if( err && err->id != ReqlSuccess ) //Create an NSError from ReQLError
            {
                NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
                //NSLog(@"NSReQLQueryClosure Insert ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
                error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
            }
            else //Parse the cursor to a results array
            {
                assert(cursor);
                results = [cursor toArray];
                NSLog(@"NSReQLDocumentObjectModel::NSReQLQueryClosure Delete results:\n\n%@\n", results);

                if( results.firstObject && [results.firstObject isKindOfClass:[NSDictionary class]] )
                {
                    NSDictionary * resultsDict = (NSDictionary*)results.firstObject;
                    //Log the error
                    if( [resultsDict[@"errors"] isKindOfClass:[NSNumber class]] )
                    {
                        NSNumber * numErrorsNum = (NSNumber*)resultsDict[@"errors"];
                        if( numErrorsNum.integerValue != 0 )
                            NSLog(@"NSReQLDocumentObjectModel::NSReQLQueryClosure Delete results error:\n\n%@\n", results);
                    }
                }
            }
            //Return query result to client
            closure(self, error, results);
        };
        
    
        NSArray * queries = @[ [NSNumber numberWithInt:REQL_MAKE_ARRAY], deleteDocumentQueriesArray ];
        NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
        NSReQL.expr( queries ).run(conn, nil, deleteDocumentsQueryCallback);

}

-(void)insertDocuments:(NSArray*)documents withClosure:(NSDocumentQueryClosure)closure andOptions:(NSDictionary* __nullable)options
{

    
    //__weak typeof(self) weakSelf = self;
    NSReQLQueryClosure queryCallback = ^(ReqlError * err, NSReQLCursor * cursor){
        
        NSArray * results = nil;
        NSError * error = nil;
        if( err && err->id != ReqlSuccess ) //Create an NSError from ReQLError
        {
            NSString * errMsg = [NSString stringWithFormat:@"ReQLQuery failed with error: %d\n", err->id];
            //NSLog(@"NSReQLQueryClosure Insert ReqlError(class: %d, id: %d, msg: %@)", err->class, err->id, errMsg);
            error = [NSError errorWithDomain:NSReQLErrorDomain code:err->id userInfo:@{ NSLocalizedDescriptionKey : errMsg}];
        }
        else //Parse the cursor to a results array
        {
            assert(cursor);
            results = [cursor toArray];
            //NSLog(@"NSReQLQueryClosure Insert results:\n\n%@\n", results);

            if( results.firstObject && [results.firstObject isKindOfClass:[NSDictionary class]] )
            {
                NSDictionary * resultsDict = (NSDictionary*)results.firstObject;
                //Log the error
                if( [resultsDict[@"errors"] isKindOfClass:[NSNumber class]] )
                {
                    NSNumber * numErrorsNum = (NSNumber*)resultsDict[@"errors"];
                    if( numErrorsNum.integerValue != 0 )
                        NSLog(@"NSReQLQueryClosure Insert results error:\n\n%@\n", results);
                }
            }
        }
        //Return query result to client
        closure(self, error, results);
    };
    
    //Issue ReQL Query using NSReQL [NSReQLSession] API
    NSReQLConnection * conn = NSReQL.connection(self.class.NSDocumentStoreURL);
    NSReQL.db(self.class.NSDocumentStoreContainer).table(self.class.NSDocumentStoreCollection).insert(documents).run(conn, options, queryCallback);
}

@end
