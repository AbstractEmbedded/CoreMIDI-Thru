//
//  NSObject+JSON.m
//  JSONMapping
//
//  Created by Alex Krzyżanowski on 17.12.15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

#import "NSObject+JSON.h"
//#import <objc/objc-class.h>
#import <Foundation/NSObjCRuntime.h>

@implementation NSObject (JSON)

+ (NSMutableDictionary *)objectMapping {
    return [NSMutableDictionary new];
}

#pragma mark - Dictionary mapping

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        /*
        NSDictionary *mappingRules = [[self class] objectMapping];
        
        for (NSString *propertyName in mappingRules) {
            id jsonFieldName = mappingRules[propertyName];
            Class propertyClass = [self classForPropertyNamed:propertyName];
            
            if (propertyClass == [NSArray class]) {
                NSString *sss = [NSString stringWithFormat:@"%@Type", propertyName];
                SEL sel = NSSelectorFromString(sss);
                if ([[self class] respondsToSelector:sel]) {
                    Class typeOfPropertyObjects = ((Class (*)(id, SEL))[[self class] methodForSelector:sel])([self class], sel);
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in dictionary[jsonFieldName]) {
                        id obj = [[typeOfPropertyObjects alloc] initWithDictionary:dict];
                        [array addObject:obj];
                    }
                    
                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] capitalizedString], [propertyName substringFromIndex:1]]);
                    ((void (*)(id, SEL, id))[self methodForSelector:selector])(self, selector, array);
                    
                    continue;
                }
            }
            
            BOOL isRelationship = [self classHasMapping:propertyClass];
            if (isRelationship == YES) {
                NSDictionary *childDictionary = dictionary[propertyName];
                Class relationClass = [self classForPropertyNamed:propertyName];
                [self setValue:[[relationClass alloc] initWithDictionary:childDictionary]
                    forKeyPath:propertyName];
                continue;
            }
            
            id value = dictionary[jsonFieldName];
            if ((value != nil) && ([value class] != [NSNull class])) {
                [self setValue:value forKey:propertyName];
            }
        }
         */
        
        unsigned int propertyCount = 0;
        //NSMutableDictionary *dictionary = [NSMutableDictionary new];
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        //loop over each NSObject property
        for (int i = 0; i < propertyCount; i++) {
            ObjCPropertyType type = getPropertyType(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
            id value = dictionary[propertyName];
            if( type == NS_TYPE_OBJECT )
            {
                [self setValue:value forKey:propertyName];
            }
            /*
            else if( type == NS_TYPE_DOUBLE )//!= NS_TYPE_ID && type != NS_TYPE_OBJECT )
            {
                //NSLog(@"NS_TYPE_DOUBLE");
                //[self setValue:((NSNumber*)value).doubleValue forKey:propertyName];
            }
            */
            else if( value )
            {
                [self setValue:value forKey:propertyName];
            }
            
        }
        free(properties);
        
        if ([self respondsToSelector:NSSelectorFromString(@"id")])
        {
            [self setValue:dictionary[@"id"] forKey:@"id"];
            NSLog(@"id = %@", [self valueForKey:@"id"]);
        }
        
        //self[@"_id"] = dictionary[@"_id"];
    }
    return self;
}

-(void)populateWithDictionary:(NSDictionary*)dictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    //loop over each NSObject property
    for (int i = 0; i < count; i++) {
        
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = dictionary[propertyName];
        [self setValue:value forKey:propertyName];
        
        //id value = [self valueForKey:key];
        /*
         if (value == nil) {
         // nothing todo
         }
         else if ([value isKindOfClass:[NSNumber class]]
         || [value isKindOfClass:[NSString class]]
         || [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableArray class]]) {
         // TODO: extend to other types
         [dictionary setObject:value forKey:key];
         }
         else if ([value isKindOfClass:[NSObject class]]) {
         [dictionary setObject:[value dictionary] forKey:key];
         }
         else {
         NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
         }
         */
    }
    free(properties);
    
    
    if ([self respondsToSelector:NSSelectorFromString(@"id")])
    {
        [self setValue:dictionary[@"id"] forKey:@"id"];
        NSLog(@"id = %@", [self valueForKey:@"id"]);
    }
    
}

- (Class)classForPropertyNamed:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
    
    NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    NSArray *attributeComponentList = [propertyAttributes componentsSeparatedByString:@"\""];
    if (attributeComponentList.count < 2) {
        return [NSObject class];
    }
    
    NSString *propertyClassName = [attributeComponentList objectAtIndex:1];
    Class propertyClass = NSClassFromString(propertyClassName);
    
    return propertyClass;
}

- (BOOL)classHasMapping:(Class)class {
    BOOL hasObjectMapping = ![[class objectMapping] isEqualToDictionary:@{}];
    if (hasObjectMapping) {
        return YES;
    }
    
    return NO;
}


/***
 *  maptToDictionary
 *
 *  Serialize an NSObject that uses NSObject+JSON extensions
 *  To a NSDictionary that is appropriate for use with NSJSONSerialization
 ***/
- (NSMutableDictionary *)mapToDictionary {

    NSLog(@"mapToDictionary");
    unsigned int propertyCount = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++)
    {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSLog(@"Key = %@", key);
        id value = [self valueForKey:key];//[NSString stringWithFormat:@"%@",[self valueForKey:key]];
        if( value ) //here only the values that are Not NULL get serialized!!!
        {
            //Most properties deriving from NSObject need to be converted directly to a NSString
            //Before placing in the NSDictionary converted to JSON
            NSString * strValue = [NSString stringWithFormat:@"%@",value];
            
            ObjCPropertyType type = getPropertyType(properties[i]);
            if( type == NS_TYPE_DOUBLE )//!= NS_TYPE_ID && type != NS_TYPE_OBJECT )
            {
                NSLog(@"NS_TYPE_DOUBLE");
                NSNumber * num = [NSNumber numberWithDouble:strValue.doubleValue];
                [dictionary setObject:num forKey:key];
            }
            else if( type == NS_TYPE_INT )
            {
                NSLog(@"NS_TYPE_INT");
                NSNumber * num = [NSNumber numberWithInt:strValue.intValue];
                [dictionary setObject:num forKey:key];
            }
            else if( type == NS_TYPE_BOOL )
            {
                NSLog(@"NS_TYPE_BOOL");

                [dictionary setObject:[NSNumber numberWithBool:(BOOL)strValue.boolValue] forKey:key];
            }
            /*
            else if( type == NS_TYPE_DATE )
            {
                //If the date is in a dictionary it has already been downloaded from RethinkDB in ReQL format
                if( [value isKindOfClass:[NSDictionary class]] )
                {
                    [dictionary setObject:value forKey:key];
                }
                //If the date is in an NSDate class, it needs to be converted to the proper RethinkDB date format
                else if( [value isKindOfClass:[NSDate class]] )
                {
                    NSDate * dateVal = (NSDate*)value;
                    NSArray * reqlISO8601Date = @[ @(REQL_ISO8601), @[ dateVal.ISO8601 ]];
                    [dictionary setObject:reqlISO8601Date forKey:key];
                }
                
            }
            */
            else if( type == NS_TYPE_OBJECT )
            {
                //NSLog(@"NS_TYPE_OBJECT");

                if( [value isKindOfClass:[NSDictionary class]] )
                {
                    [dictionary setObject:value forKey:key];
                }
                /*
                else if( [value isKindOfClass:[NSDate class]] )
                {
                    
                    NSDate * dateVal = (NSDate*)value;
                    NSArray * reqlISO8601Date = @[ @(REQL_ISO8601), @[ dateVal.ISO8601 ]];
                    [dictionary setObject:reqlISO8601Date forKey:key];
                    

                }
                */
               
                else if( [value isKindOfClass:[NSArray class]] )
                {
                    NSLog(@"NS_TYPE_ARRAY");
                    
                }
                else if( [value isKindOfClass:[NSString class]] )
                {
                    if ([strValue localizedCompare:@"null"] == NSOrderedSame  || [strValue localizedCompare:@"<null>"] == NSOrderedSame )
                    {
                        [self setValue:[NSNull null] forKey:key];
                        [dictionary setObject:[NSNull null] forKey:key];
                    }
                    else
                        [dictionary setObject:strValue forKey:key];
                }
                else
                    [dictionary setObject:strValue forKey:key];
                          
            }
            else if( type == NS_TYPE_STRING )
            {
                NSLog(@"NS_TYPE_STRING");

                if ([strValue localizedCompare:@"null"] == NSOrderedSame  || [strValue localizedCompare:@"<null>"] == NSOrderedSame )
                {
                    [self setValue:[NSNull null] forKey:key];
                    [dictionary setObject:[NSNull null] forKey:key];
                }
                else
                    [dictionary setObject:value forKey:key];
                
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
            
            
        }
    }
    free(properties);
    return dictionary;
}




#pragma mark - JSON mapping

- (instancetype)initWithJSONString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [self initWithDictionary:dictionary];
}

- (NSString *)mapToJSONString {
    NSDictionary *dictionary = [self mapToDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end
