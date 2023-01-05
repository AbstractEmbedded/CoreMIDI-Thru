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


-(NSString*)InsertedDocumentsNotification
{
    return nil;
}

-(NSString*)DeletedDocumentsNotification
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
*/


/*

-(void)submitCreateRequestWithCompletionHandler:(HTTPRequestCompletionBlock)completionHandler
{
    NSString * API_URL = self.CREATE_URL;
    
    
    
    //Must use NSMutableURLRequest for HTTP(S) POST requests
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    urlRequest.HTTPMethod=@"POST";  //use post so we can send parameters in body
    
    NSString * loginString = nil;//[VRTUser clientInstance].token;//[NSString stringWithFormat:@"%@:%@", fbid, accessToken ];
    NSData * loginData = [loginString dataUsingEncoding: NSUTF8StringEncoding];
    NSString * base64LoginString = [loginData base64EncodedStringWithOptions:0];
    NSString * authValue = [NSString stringWithFormat:@"Basic %@", base64LoginString];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //populate URL request body parameters
    NSError *writeError = nil;
    NSDictionary *jsonBodyDict = [self mapToDictionary]; // { "some_number": 112, "some_string": "testString" }
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:0 error:&writeError];
    //NSString *jsonString = [[NSString alloc] initWithData:jsonBodyData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    urlRequest.HTTPBody = jsonBodyData;//[jsonBodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //IMPORTANT: Make sure to specify json body when POSTing with NSMutableURLRequest
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonBodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * submitRequestTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        long statusCode = -1;
        NSArray * documents = nil;
        NSError *e = error;

        if (e == nil)
        {
            //cast request to http response to get status code
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            statusCode = (long)[HTTPResponse statusCode];
            
            NSString * responseData = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            // Parse data here
            //NSLog(@"URL Request Success");
            //NSLog(@"Status Code = %ld", (long)statusCode);
            //NSLog(@"HTTP Response = %@", HTTPResponse);
            //NSLog(@"Response Data = %@", responseData);
            
            //Process Post Response
            if( statusCode > 299 || statusCode < 200 ) //HTTP Failure Codes
            {
                [weakSelf showAlertView:@"HTTP(S) CREATE Failure" message:responseData buttonTitles:nil completionHandler:nil];
            }
            else
            {
                NSData *JSONData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error: &e];
                
                if( e )  //Failure to Parse JSON Response
                {
                    [weakSelf showAlertView:@"HTTP(S) Response Parsing Error" message:e.localizedDescription buttonTitles:nil completionHandler:nil];
                }
                else
                {
                    e = error;
                    documents = [JSONDict objectForKey:@"documents"];
                    
                    //add the json documents representing our data model to our internal store
                    [weakSelf.documents addObjectsFromArray:documents];
                    
                    //Process child class implementation custom post response if implemented
                    if([weakSelf respondsToSelector:@selector(processPOSTResponse:JSON:)])
                        [weakSelf processPOSTResponse:statusCode JSON:JSONDict];
                    else
                    {
                        //send the notification associated with this
                        //if( [self respondsToSelector:@selector(InsertedDocumentsNotification)] && self.InsertedDocumentsNotification != nil )
                        //    [self sendDocumentStoreNotification:self.InsertedDocumentsNotification documents:nil];
                        
                        //if there is a message, display it to the user
                        if( [JSONDict objectForKey:@"msg"] )//|| [jsonResponseDict objectForKey:@"message"] )
                        {
                            
                            [self showAlertView:@"Success" message:[JSONDict objectForKey:@"msg"]  buttonTitles:nil completionHandler:nil];
                        }
                    }
                    

                }
            }
            
        }
        else
        {
            [self showAlertView:@"URL Request Error" message:error.localizedDescription buttonTitles:nil completionHandler:nil];
            return;
        }
        
        //Call the completion handler for the calling UI so it can clean up it's UI
        //(Such as to stop network load indicators from animating)
        if( completionHandler )
            completionHandler(statusCode, e, documents);
        
    }];
    
    //start the async task
    [submitRequestTask resume];
    
}



-(void)submitDeleteRequestForDict:(NSDictionary*)dict withCompletionHandler:(HTTPRequestCompletionBlock)completionHandler
{
    NSString * API_URL = self.DELETE_URL;
    
    //Must use NSMutableURLRequest for HTTP(S) POST requests
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    urlRequest.HTTPMethod=@"DELETE";  //use post so we can send parameters in body
    
    NSString * loginString = nil;//[VRTUser clientInstance].token;//[NSString stringWithFormat:@"%@:%@", fbid, accessToken ];
    NSData * loginData = [loginString dataUsingEncoding: NSUTF8StringEncoding];
    NSString * base64LoginString = [loginData base64EncodedStringWithOptions:0];
    NSString * authValue = [NSString stringWithFormat:@"Basic %@", base64LoginString];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //populate URL request body parameters
    NSError *writeError = nil;
    NSDictionary *jsonBodyDict = dict;//[self mapToDictionary]; // { "some_number": 112, "some_string": "testString" }
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:0 error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonBodyData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    urlRequest.HTTPBody = jsonBodyData;//[jsonBodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //IMPORTANT: Make sure to specify json body when POSTing with NSMutableURLRequest
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonBodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * submitRequestTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
        long statusCode = -1;
        NSError *e = error;
        if (e == nil)
        {
            //cast request to http response to get status code
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            statusCode = (long)[HTTPResponse statusCode];
            
            NSString * responseData = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            // Parse data here
            //NSLog(@"URL Request Success");
            //NSLog(@"Status Code = %ld", (long)statusCode);
            //NSLog(@"HTTP Response = %@", HTTPResponse);
            //NSLog(@"Response Data = %@", responseData);
            
            //Process Delete Response
            if( statusCode > 299 || statusCode < 200 ) //HTTP Failure Codes
            {
                [weakSelf showAlertView:@"HTTP(S) DELETE Failure" message:responseData buttonTitles:nil completionHandler:nil];
            }
            else
            {
                NSData *JSONData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error: &e];
                
                if( e )  //Failure to Parse JSON Response
                {
                    [weakSelf showAlertView:@"HTTP(S) Response Parsing Error" message:e.localizedDescription buttonTitles:nil completionHandler:nil];
                }
                else
                {
                    e = error;
                    //remove the document entry from the VRTUserProfile json document store
                    [weakSelf.documents removeObject:dict];
                    
                    //send the document store notification associated with this request
                    //if( [self respondsToSelector:@selector(DeletedDocumentsNotification)] && self.DeletedDocumentsNotification != nil )
                    //    [self sendDocumentStoreNotification:self.DeletedDocumentsNotification documents:nil];
                    
                    //Do any custom processing of the response required by child class implementations
                    if([weakSelf respondsToSelector:@selector(processPOSTResponse:JSON:)])
                        [weakSelf processPOSTResponse:statusCode JSON:JSONDict];
                    else
                    {
                        //show a success message
                        if( [JSONDict objectForKey:@"msg"] )//|| [jsonResponseDict objectForKey:@"message"] )
                        {
                            [self showAlertView:@"Success" message:[JSONDict objectForKey:@"msg"]  buttonTitles:nil completionHandler:nil];
                        }
                    }
                    
                }
            }
        }
        else{
            [self showAlertView:@"URL Request Error" message:error.localizedDescription buttonTitles:nil completionHandler:nil];
        }
        
        //Call the completion handler for the calling UI so it can clean up it's UI
        //(Such as to stop network load indicators from animating or reload a table view)
        if( completionHandler )
            completionHandler(statusCode,e, nil);
        
    }];
    
    //start the async task
    [submitRequestTask resume];
    
    
}


-(NSArray*)csvFields
{
    NSLog(@"VRTUserProfile::csvFields Empty base implementation");
    return _csvFields;
}



-(void)submitGetManyRequestWithQueryParams:(NSDictionary*)queryParams andCompletionHandler:(HTTPRequestCompletionBlock)completionHandler
{
    NSString * API_URL = self.GET_MANY_URL;
    

    
    //assert( [VRTUser clientInstance].token != nil && [VRTUser clientInstance].token.length > 1 );
    NSLog(@"Request URL: %@", API_URL);
    //NSString * paramString = @"?token=";
    //paramString = [paramString stringByAppendingString:[VRTUserManager sharedInstance].user.token];
    if( queryParams && queryParams.count > 0)
    {
        NSString * paramString = nil;//@"?";

        for (NSString * key in queryParams)
        {
            NSString * value = [NSString stringWithFormat:@"%@", [queryParams objectForKey:key]];
            
            if( !paramString )
                paramString = [[NSString alloc] initWithFormat:@"?%@=%@", key, value];
            else
                paramString = [ paramString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value] ];
        }
        API_URL = [API_URL stringByAppendingString:paramString];
    }
    
    
    //Must use NSMutableURLRequest for HTTP(S) POST requests
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    urlRequest.HTTPMethod=@"GET";  //use post so we can send parameters in body
    
    NSString * loginString = nil;//[VRTUser clientInstance].token;//[NSString stringWithFormat:@"%@:%@", fbid, accessToken ];
    NSData * loginData = [loginString dataUsingEncoding: NSUTF8StringEncoding];
    NSString * base64LoginString = [loginData base64EncodedStringWithOptions:0];
    NSString * authValue = [NSString stringWithFormat:@"Basic %@", base64LoginString];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * getManyRequestTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //Call the completion handler for the calling UI so it can clean up it's UI
        //(Such as to stop network load indicators from animating)
        //if( completionHandler )
        //    completionHandler();
        
        long statusCode = -1;
        NSError *e = error;
        NSArray * documents = nil;//[JSONDict objectForKey:@"documents"];
        if (e == nil)
        {
            //cast request to http response to get status code
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            statusCode = (long)[HTTPResponse statusCode];
            
            NSString * responseData = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            
            // Parse data here
            //NSLog(@"URL Request Success");
            //NSLog(@"Status Code = %ld", (long)statusCode);
            //NSLog(@"HTTP Response = %@", HTTPResponse);
            //NSLog(@"Response Data = %@", responseData);

            //Process GET Response
            if( statusCode > 299 || statusCode < 200 ) //HTTP Failure Codes
                [weakSelf showAlertView:@"HTTP(S) POST Failure" message:responseData buttonTitles:nil completionHandler:nil];
            else
            {
                NSData *JSONData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSObject *JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error: &e];

                if( e )  //Failure to Parse JSON Response
                    [weakSelf showAlertView:@"HTTP(S) Response Parsing Error" message:e.localizedDescription buttonTitles:nil completionHandler:nil];
                else
                {
                    e = error;
                    if( [JSONObject isKindOfClass:[NSArray class]] )
                    {
                        documents = (NSArray*)JSONObject;
                        if( documents )
                            weakSelf.documents = [NSMutableArray arrayWithArray:documents];
                    }
                    else if( [JSONObject isKindOfClass:[NSDictionary class]] )
                    {
                        NSDictionary * JSONDict = (NSDictionary *)JSONObject;
                        documents =  [JSONDict objectForKey:@"documents"];
                        //put/replace the json array of documents in an internal store of NSArray of NSDictionaries
                        if( documents )
                            weakSelf.documents = [NSMutableArray arrayWithArray:documents];

                        //send the notification associated with this request
                        //if( [self respondsToSelector:@selector(InsertedDocumentsNotification)] && self.InsertedDocumentsNotification != nil )
                        //    [self sendDocumentStoreNotification:self.InsertedDocumentsNotification documents:nil];
                        
                        //Do any custom processing of the response required by child class implementations
                        if([weakSelf respondsToSelector:@selector(processPOSTResponse:JSON:)])
                            [weakSelf processPOSTResponse:statusCode JSON:JSONDict];
                        

                        

                    }
                    


                }
             }

            
        }
        else{
            [self showAlertView:@"URL Request Error" message:error.localizedDescription buttonTitles:nil completionHandler:nil];
        }
        
        //Return the result of the HTTP Request to the calling code by calling the completion block it provided
        if( completionHandler )
            completionHandler(statusCode, e, documents);
        
    }];
    
    //start the async task
    [getManyRequestTask resume];
}

-(void)submitCreateManyRequestWithDicts:(NSArray*)arrayOfDicts andCompletionHandler:(HTTPRequestCompletionBlock)completionHandler
{
    NSString * API_URL = self.CREATE_MANY_URL;
    
    //assert([VRTUser clientInstance]);
    //assert([VRTUser clientInstance].token);

    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    urlRequest.HTTPMethod=@"POST";  //use post so we can send parameters in body
    
    NSString * loginString = nil;//[VRTUser clientInstance].token;//[NSString stringWithFormat:@"%@:%@", fbid, accessToken ];
    NSData * loginData = [loginString dataUsingEncoding: NSUTF8StringEncoding];
    NSString * base64LoginString = [loginData base64EncodedStringWithOptions:0];
    NSString * authValue = [NSString stringWithFormat:@"Basic %@", base64LoginString];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSError *writeError = nil;
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:arrayOfDicts options:0 error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonBodyData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    
    urlRequest.HTTPBody = jsonBodyData;//[jsonBodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //IMPORTANT: Make sure to specify json body when POSTing with NSMutableURLRequest
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonBodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *createManyTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        long statusCode = -1;
        NSMutableArray * documents =  nil;//[JSONDict objectForKey:@"documents"];
        NSError *e = error;
        if (e == nil)
        {
            //cast request to http response to get status code
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            long statusCode = (long)[HTTPResponse statusCode];
            
            NSString * responseData = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
            
            // Parse data here
            NSLog(@"URL Request Success");
            NSLog(@"Status Code = %ld", (long)statusCode);
            NSLog(@"HTTP Response = %@", HTTPResponse);
            NSLog(@"Response Data = %@", responseData);

            //Process POST Response
            if( statusCode > 299 || statusCode < 200 ) //HTTP Failure Codes
            {
                [weakSelf showAlertView:@"HTTP(S) POST Failure" message:responseData buttonTitles:nil completionHandler:nil];
            }
            else
            {
                NSData *JSONData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options: NSJSONReadingMutableContainers error: &e];
                
                if( e )  //Failure to Parse JSON Response
                {
                    [weakSelf showAlertView:@"HTTP(S) Response Parsing Error" message:e.localizedDescription buttonTitles:nil completionHandler:nil];
                }
                else
                {
                     documents = [JSONDict objectForKey:@"documents"];
                    //add the json array of documents in an internal store of NSArray of NSDictionaries
                    if( documents )
                       [weakSelf.documents addObjectsFromArray:documents];
                    
                    //send the notification associated with this request
                    //if( [self respondsToSelector:@selector(InsertedDocumentsNotification)] && self.InsertedDocumentsNotification != nil )
                    //    [self sendDocumentStoreNotification:self.InsertedDocumentsNotification documents:nil];
                    
                    //Do any custom processing of the response required by child class implementations
                    if([weakSelf respondsToSelector:@selector(processPOSTResponse:JSON:)])
                        [weakSelf processPOSTResponse:statusCode JSON:JSONDict];
                    else
                    {
                        //show a success message
                        if( [JSONDict objectForKey:@"msg"] )//|| [JSONDict objectForKey:@"message"] )
                        {
                            NSString * alertTitle = [NSString stringWithFormat:@"Create %s Result:", CM_DOM_COLLECTION_TITLES[self.type]];
                            [self showAlertView:alertTitle message:[JSONDict objectForKey:@"msg"]  buttonTitles:nil completionHandler:nil];
                        }
                    }
                }
            }
            
        }
        else{
            [self showAlertView:@"URL Request Error" message:error.localizedDescription buttonTitles:nil completionHandler:nil];
        }
        
        //Call the completion handler for the calling UI so it can clean up it's UI
        //(Such as to stop network load indicators from animating or remove the object from a table view)
        if( completionHandler )
            completionHandler(statusCode, e, documents);
    }];
    
    //start the async task
    [createManyTask resume];
    
    
}

static __inline__ __attribute__((always_inline)) void cr_str_advance(char ** line, char character)
{
    while( *((*line)++) != character );
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

-(NSArray*)parseCSV:(NSString*)filepath assetDir:(NSString*)assetDir
{
    
    /*
    uint64_t filesize;
    char * filebuffer;
    //1 OPEN THE OBJECT FILE FOR READING AND GET FILESIZE USING LSEEK
    int fileDescriptor = cr_file_open(filepath.UTF8String);
    filesize = cr_file_size(fileDescriptor);
    
    //2 MAP THE FILE TO BUFFER FOR READING
    filebuffer = (char*)cr_file_map_to_buffer(&(filebuffer), filesize, PROT_READ,  MAP_SHARED | MAP_NORESERVE, fileDescriptor, 0);
    
    if (madvise(filebuffer, (size_t)filesize, MADV_SEQUENTIAL | MADV_WILLNEED ) == -1) {
        printf("\nread madvise failed\n");
    }
    cr_file_close(fileDescriptor);  //close file after mapping, we don't need the fd anymore
    printf("\nFile Size =  %llu bytes\n", filesize);
    
    //2 ASYNCHRONOUSLY TOUCH THE FILE DATA AT EACH PAGE
    
    int NUM_CSV_FIELDS;
    
    __block volatile uint8_t touchData1 = 0;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        
        size_t page_size = sysconf( _SC_PAGE_SIZE );
        
        for( size_t bufferIndex=0; bufferIndex < filesize; bufferIndex+=page_size)
        {
            touchData1 += *(filebuffer + bufferIndex);
        }
        
    });
    
    __block uint32_t numLines = 0;
    
    
    //calculate the SIMD loop size ( to calculate the number of newline characters quickly)
    size_t buffSize = (size_t)filesize;
    //__block size_t buffSize2;// = (size_t)filesize - (size_t)((firstMTL-sizeof(uint64x2_t)) - readBuffer);
    
    __block size_t bytesPerLoop;
    __block uint64_t simdLoopCount;
    //__block uint64_t simdLoopCount2;
    //#ifdef CR_TARGET_OSX
    bytesPerLoop = CR_SIMD_SIZE;//sizeof(  );
    //#else
    //        bytesPerLoop  = sizeof( uint16x8_t );
    //        bytesPerLoop2 = sizeof( uint16x8_t );
    //        uint64_t neonLoopCount2 = buffSize2/bytesPerLoop2 + 1;//(uint64_t)(buffSize/bytesPerLoop);
    //#endif
    simdLoopCount = buffSize/bytesPerLoop;//(uint64_t)(buffSize/bytesPerLoop);
    __block uint64_t simdRemainder = buffSize % bytesPerLoop;
    
    NSLog(@"CR_SIMD_SIZE = %d",(int)CR_SIMD_SIZE);
    if( filesize < bytesPerLoop )
    {
        NSLog(@"Parsing SIMD");

        //dispatch_group_async(task_group, simdQueue, ^{
        cr_simd_count_uint8(filebuffer, simdLoopCount, '\n', &numLines);
        //dispatch_semaphore_signal(task_semaphore);
        //wait--;
        //});
        
        if( simdRemainder > 1 )
        {
            int cStart = (int)(filesize - 1 - simdRemainder);
            for( int c = cStart; c < cStart + simdRemainder-1; c++ ) //doesnt matter if the last char is a newline there is no newline to read!
            {
                if( filebuffer[c] == '\n') numLines++;
            }
        }
    }
    else{
        NSLog(@"Parsing filebuffer");
        char * chr = filebuffer;
        uint64_t byteCount =0;
        while (byteCount < filesize-1)
        {
            //Count whenever new line is encountered
            if (*chr == '\n')
                numLines++;
            byteCount++;
            chr++;
        }
    }
    
    numLines++;
    
    NSString * INVALID_CHAR_STR = @",\n\r\t\"";
    //NSCharacterSet *INVALID_CHAR_SET = [NSCharacterSet characterSetWithCharactersInString:INVALID_CHAR_STR];

    //printf("Num Lines Before Remainder = %u\n", numLines);
    //printf( "simdRemainder = %llu\n", simdRemainder );
    
    //if there are 5 '\n' characters, then there are 6 lines
    //numLines++;
    printf("Num Lines = %u\n", numLines);
    
    char * line = filebuffer;
    
    
    uint32_t lineIndex = 0;
    
    NSMutableArray * errorStrings = [[NSMutableArray alloc] init];
    NSMutableOrderedSet * propertySet = [[NSMutableOrderedSet alloc] init];
    //NSMutableArray * columnHeaders = [[NSMutableArray alloc] init];
    //NSMutableDictionary * propertyMap = [[NSMutableDictionary alloc] init];

    NSMutableArray * documentArray = [[NSMutableArray alloc] init];//WithCapacity:numLines];
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    char * item = line;
    char * headerLineEnd = line;
    //read the entire first line
    cr_str_advance(&headerLineEnd, '\n');  //advance ptr to the end of the line
    
    //find the number of fields by reading the column header values in the first line
    item = line;
    cr_str_advance(&line, ',');  //advance to next comma
    while( line < headerLineEnd )
    {
        NSString * csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(line-1-item), item];
        printf("Reading CSV Header Field: %s, \n", csvFieldValue.UTF8String);
        
        //add the header field value to the array
        [propertySet addObject:csvFieldValue];
        
        //advance line
        item = line;
        cr_str_advance(&line, ',');  //advance to next comma
    }
    
    //read the final csv value in the header line
    int offset = 1;
    if( *(headerLineEnd-2) == '\r')
        offset++;
    NSString * csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(headerLineEnd-offset-item), item];
    printf("Reading CSV Header Field: %s, \n", csvFieldValue.UTF8String);
    
    //add the header field value to the array
    [propertySet addObject:csvFieldValue];
    
    lineIndex = 1;
    NUM_CSV_FIELDS = (int)propertySet.count;
    if( NUM_CSV_FIELDS != propertyCount )
    {
        NSString * errString = [NSString stringWithFormat:@"\n• Num CSV Fields (%d) != Num %s Property Fields (%d)\n", NUM_CSV_FIELDS, EARTHFORMS_DOM_TITLES[self.type], propertyCount];
        [errorStrings addObject:errString];
    }
    
    //match each data model property to a csv file field
    NSMutableArray * missingFields = [[NSMutableArray alloc] init];
    NSMutableOrderedSet * unmappedFields = [propertySet mutableCopy];
    for (int propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[propertyIndex])];
        if( ![propertySet containsObject:propertyName] )
        {
            [missingFields addObject:propertyName];
            continue;
        }
        [unmappedFields removeObject:propertyName];
    }
    
    if( missingFields.count > 0 )
    {
        NSString * missingFieldsString = [missingFields objectAtIndex:0];
        for(int i=1;i<missingFields.count;i++)
            missingFieldsString = [missingFieldsString stringByAppendingString:[NSString stringWithFormat:@",\\n\\r\"%@", [missingFields objectAtIndex:i]]];
        NSString * errString = [NSString stringWithFormat:@"\n• Missing the following expected fields:\n\n%@\n", missingFieldsString];
        [errorStrings addObject:errString];
    }
    if( unmappedFields.count > 0)
    {
        NSString * unmappedFieldsString = [unmappedFields objectAtIndex:0];
        for(int i=1;i<unmappedFields.count;i++)
            unmappedFieldsString = [unmappedFieldsString stringByAppendingString:[NSString stringWithFormat:@",\n%@", [unmappedFields objectAtIndex:i]]];
        NSString * errString = [NSString stringWithFormat:@"\n• Encountered the following unexpected fields:\n\n%@\n", unmappedFieldsString];
        [errorStrings addObject:errString];
    }
    
    [missingFields removeAllObjects];
    [unmappedFields removeAllObjects];
    missingFields = nil;
    unmappedFields = nil;
    
    if( errorStrings.count > 0 )
    {
        //return errors to user
        
        NSString * compositeErrorString = [errorStrings objectAtIndex:0];
        
        for(int i=1;i<errorStrings.count;i++)
            compositeErrorString = [compositeErrorString stringByAppendingString:[errorStrings objectAtIndex:i]];

        [self showAlertView:@"Failed to Parse CSV" message:[NSString stringWithFormat:@"%@", compositeErrorString] buttonTitles:nil completionHandler:nil];
        return nil;
    }

    //free unused memory no longer needed
    errorStrings = nil;
    
    //prepare to parse rows in csv file
    line = headerLineEnd;
    item = line;

    //parse row entries line by line in the CSV the file
    for(;lineIndex<numLines-1; lineIndex++)
    {
        NSMutableDictionary * documentDict = [[NSMutableDictionary alloc] init];
        
        //TO DO: check each line for the expected number of commas
        for (int propertyIndex = 0; propertyIndex < propertySet.count-1; propertyIndex++) {
            
            item = line;
            cr_str_advance(&line, ',');  //advance to next comma
            NSString * csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(line-1-item), item];
            printf("%.*s, ", (int)(line-1-item), item);
            
            //NSString * csvFieldName = [self.csvFields objectAtIndex:csvFieldIndex];
            NSString *key = [propertySet objectAtIndex:propertyIndex];//[NSString stringWithUTF8String:property_getName(properties[propertyIndex])];
            if( [self checkForInvalidChars:INVALID_CHAR_STR inString:csvFieldValue lineIndex:lineIndex field:key] )
                return nil;
            [documentDict setObject:csvFieldValue forKey:key];
        }
        
        
        item = line;
        cr_str_advance(&line, '\n');  //advance to newline character
        int offset = 1;
        if( *(line-2) == '\r')
            offset++;
        NSString * csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(line-offset-item), item];
        printf("%.*s, ", (int)(line-offset-item), item);
        printf("\n");

        //get the field key string
        NSString *key = [propertySet objectAtIndex:propertySet.count-1];//[NSString stringWithUTF8String:property_getName(properties[propertyCount-1])];
        if( [self checkForInvalidChars:INVALID_CHAR_STR inString:csvFieldValue lineIndex:lineIndex field:key] )
            return nil;
        //NSString * csvFieldName = [self.csvFields objectAtIndex:self.csvFields.count - 1];
        [documentDict setObject:csvFieldValue forKey:key];

        if( assetDir && assetDir.length > 1 )
        {
            //NSString * pathSuffix = [documentDict objectForKey:@"URL"];
            NSString * path = [assetDir stringByAppendingPathComponent:[documentDict objectForKey:@"URL"]];
            [documentDict setObject:path forKey:@"URL"];
        }
        
        [documentArray addObject:documentDict];
    }

    //read the last line.  it will not have a \n
    

    NSMutableDictionary * documentDict = [[NSMutableDictionary alloc] init];
    
    //TO DO: check each line for the expected number of commas
    for (int propertyIndex = 0; propertyIndex < propertySet.count-1; propertyIndex++) {
        
        item = line;
        cr_str_advance(&line, ',');  //advance to next comma
        NSString * csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(line-1-item), item];
        printf("%.*s, ", (int)(line-1-item), item);

        //NSString * csvFieldName = [self.csvFields objectAtIndex:csvFieldIndex];
        NSString *key = [propertySet objectAtIndex:propertyIndex];//[NSString stringWithUTF8String:property_getName(properties[propertyIndex])];
        if( [self checkForInvalidChars:INVALID_CHAR_STR inString:csvFieldValue lineIndex:lineIndex field:key] )
            return nil;
        [documentDict setObject:csvFieldValue forKey:key];
    }
    
    //read the last item of the last line
    item = line;
    //cr_str_advance(&line, '\n');  //advance to newline character
    
    offset = 0;
    if( *(filebuffer + filesize - 1) == '\n' )
       offset = 1;
    if( *(filebuffer + filesize - 2) == '\r')
        offset++;
       
    csvFieldValue =  [[NSString alloc] initWithFormat:@"%.*s", (int)(filebuffer + filesize - offset - item), item];
    printf("%.*s, ", (int)(line-offset-item), item);
    printf("\n");
    
    //NSString * csvFieldName = [self.csvFields objectAtIndex:self.csvFields.count - 1];
    NSString *key = [propertySet objectAtIndex:propertySet.count-1];//[NSString stringWithUTF8String:property_getName(properties[propertyCount-1])];
    if( [self checkForInvalidChars:INVALID_CHAR_STR inString:csvFieldValue lineIndex:lineIndex field:key] )
        return nil;
    [documentDict setObject:csvFieldValue forKey:key];
    
    if( assetDir && assetDir.length > 1 )
    {
        //NSString * pathSuffix = [documentDict objectForKey:@"URL"];
        NSString * path = [assetDir stringByAppendingPathComponent:[documentDict objectForKey:@"URL"]];
        [documentDict setObject:path forKey:@"URL"];
    }
    
    [documentArray addObject:documentDict];
    
    
    free(properties);

    return [NSArray arrayWithArray:documentArray];
     */
    
    return nil;
}


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
    if (returnCode == NSModalResponseOK || returnCode == NSOKButton)
    {
        NSLog(@"(returnCode == NSOKButton)");
        //[self.window makeKeyWindow];
    }
    else if (returnCode == NSModalResponseCancel || returnCode == NSCancelButton)
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
