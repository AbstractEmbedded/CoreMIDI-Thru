//
//  CMThruConnection.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 12/28/22.
//

#import "CMDOM.h"
NS_ASSUME_NONNULL_BEGIN

//Create a short MACRO reference to the global instance constructor
#define CMThru [CMThruConnection sharedInstance]

@interface CMThruConnection : CMDOM

+(CMThruConnection*)sharedInstance;

@property (nonatomic, retain) NSString * ThruID;
@property (nonatomic, retain) NSString * Input;
@property (nonatomic, retain) NSString * InputDriver;
@property (nonatomic, retain) NSString * Output;
@property (nonatomic, retain) NSString * OutputDriver;
@property (nonatomic, retain) NSString * Filter;
//@property (nonatomic, retain) NSString * Map;

+(void)loadThruConnections;

//Create & Delete are called as class methods
+(CMThruConnection*)createThruConnection:(NSString*)thruID Params:(MIDIThruConnectionParams*)params;
+(void)deleteThruConnection:(CMThruConnection*)thruConnectionDocument;

//but a data model instance can save its internal params to core midi when changed
-(void)saveThruConnection;
-(void)replaceThruConnection:(NSString*)ThruID atIndex:(NSUInteger)domIndex;


-(id)initWithCMConnection:(struct CMConnection*)connection;

-(CMConnection*)connection;

@end

NS_ASSUME_NONNULL_END
