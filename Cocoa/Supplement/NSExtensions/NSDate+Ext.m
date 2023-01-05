//
//  NSDate+Ext.m
//  Mastry
//
//  Created by Joe Moulton on 6/11/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSDate+Ext.h"

@implementation NSDate (Ext)

-(NSString*)dateAndTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    [dateFormat setDateFormat:@"yyyy-MMM-dd HH:mm"];
    return [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:self]];
}

-(NSString *)militaryTOD
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    [dateFormat setDateFormat:@"HH:mm"];
    return [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:self]];
}

-(NSString*)ddMMYYYY
{
    //NSString *str = [self objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    return [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:self]];
}

+(NSDate*)dateWithISO8601String:(NSString*)ISO8601String
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd'T'HHmmssZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:ISO8601String];
    NSLog(@"dateWithISO8601String = %@", date);
    return date;
}

+(NSString*)ISO8601
{
    //format the NSDate to the ISO 8601 string format that we will populate in JSON
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmssZZZZ"];
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    return [dateFormatter stringFromDate:[NSDate date]];
}


-(NSString*)ISO8601
{
    //format the NSDate to the ISO 8601 string format that we will populate in JSON
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmssZZZZZ"];
    
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [dateFormatter stringFromDate:self];
}


-(NSString*)RFC3339
{
    //format the NSDate to the ISO 8601 string format that we will populate in JSON
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"];
    
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [dateFormatter stringFromDate:self];
}


+(NSString*)yyyymmdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    return [dateFormatter stringFromDate:[NSDate date]];
}


-(NSString*)yyyymmdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

    return [dateFormatter stringFromDate:self];
}


@end
