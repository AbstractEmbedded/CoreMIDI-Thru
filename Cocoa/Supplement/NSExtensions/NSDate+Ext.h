//
//  NSDate+Ext.h
//  Mastry
//
//  Created by Joe Moulton on 6/11/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Ext) //: NSDate

+(NSString*)ISO8601;
-(NSString*)ISO8601;
-(NSString*)RFC3339;

+(NSString*)yyyymmdd;
-(NSString*)yyyymmdd;

-(NSString*)ddMMYYYY;
-(NSString*)militaryTOD;
-(NSString*)dateAndTime;



+(NSDate*)dateWithISO8601String:(NSString*)ISO8601String;
@end

NS_ASSUME_NONNULL_END
