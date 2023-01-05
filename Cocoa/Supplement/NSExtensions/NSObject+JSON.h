//
//  NSObject+JSON.h
//  APJSONMapping
//
//  Created by Alex Krzyżanowski on 17.12.15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum ObjCPropertyType
{
    NS_TYPE_UNKNOWN     = -1000,
    NS_TYPE_ID          = 1000,
    NS_TYPE_OBJECT      = '@',
    NS_TYPE_DATE        = NS_TYPE_ID+1,
    NS_TYPE_STRING      = NS_TYPE_ID+2,
    NS_TYPE_UINT        = 'I',
    NS_TYPE_INT         = 'i',
    NS_TYPE_DOUBLE      = 'd',
    NS_TYPE_INT64       = 'q',
    NS_TYPE_BOOL        = 'B'
    //NS_TYPE_DOUBLE      =
}ObjCPropertyType;

static ObjCPropertyType getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    printf("getPropertyType attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (ObjCPropertyType)*(attribute + 1);
            //return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return (ObjCPropertyType)*(attribute + 1);
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && attribute[2] == '"') {
            // it's another ObjC object type:
            //NSLog(@"%c%c%c%c", attribute[0], attribute[1], attribute[2], attribute[3]);
            NSString * propertyString = [NSString stringWithUTF8String:attribute+1];
            if( [propertyString localizedCompare:@"@\"NSDate\""] == NSOrderedSame)
            {
                NSLog(@"NSTypeDate");
                return NS_TYPE_DATE;
            }
            else if( [propertyString localizedCompare:@"@\"NSString\""] == NSOrderedSame)
             {
                 NSLog(@"NSTypeString");
                 return NS_TYPE_STRING;
             }
            else
            {
                //NSLog(@"strcmp failed (%@) = (%d)", propertyString, (int)propertyString.length);
                return (ObjCPropertyType)*(attribute + 1);
            }
        }
    }
    return NS_TYPE_UNKNOWN;
}

/**
 @brief Category that extends NSObject functionality with JSON mapping.
 
 @discussion Use this category to make NSObject able to initialize from JSON
 and vice versa.
 */
@interface NSObject (JSON)

/**
 @brief Tells to an object how to map to and to parse from JSON.
 
 @discussion You must to override this methods in your subclass add relations
 between object's properties and JSON fields.
 */
+ (NSMutableDictionary *)objectMapping;

/**
 @brief Initializes object with dictionary following the mapping rules.
 
 @discussion Object will be initialized with dictionary following the rules, that you
 declared in <code>objectMapping:</code> method.
 
 @param Dictionary that contains source values, that will be used to initialize object's
 properties.
 
 @return An instance of object, initialized with passed dictionary.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)populateWithDictionary:(NSDictionary *)dictionary;

/**
 @brief Initializes object with JSON string following the mapping rules.
 
 @discussion Object will be initialized with JSON string following the rules, that you
 declared in <code>objectMapping:</code> method.
 
 @param JSON that contains source values, that will be used to initialize object's
 properties.
 
 @return An instance of object, initialized with passed JSON string.
 */
- (instancetype)initWithJSONString:(NSString *)jsonString;

/**
 @brief Maps object into dictionary
 
 @return Dictionary, that contains all object's properties, that pointed in <code>objectMapping:</code>
 method, as key-value pairs.
 */
- (NSMutableDictionary *)mapToDictionary;

/**
 @brief Maps object to JSON string
 
 @return String, that contains all object's properties, that pointed in <code>objectMapping:</code>
 method, as a fields in JSON object.
 */
- (NSString *)mapToJSONString;

@end
