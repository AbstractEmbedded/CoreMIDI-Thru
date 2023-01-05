//
//  NSData+Ext.m
//  Mineralism
//
//  Created by Joe Moulton on 11/18/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSData+Ext.h"

@implementation NSData (Ext)


//from: http://cocoadev.com/BaseSixtyFour
-(NSString*)base64 {

    const uint8_t* input = (const uint8_t*)[self bytes];
    NSInteger length = [self length];

  static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

  NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
  uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
  for (i=0; i < length; i += 3) {
    NSInteger value = 0;
        NSInteger j;
    for (j = i; j < (i + 3); j++) {
      value <<= 8;

      if (j < length) {
        value |= (0xFF & input[j]);
      }
    }

    NSInteger theIndex = (i / 3) * 4;
    output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
    output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
    output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
    output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
  }

    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


//Define a c-style function prototype for a function that takes a Obj-C NSString as input and outputs a NSString
/*
typedef NSString* _Nonnull (*NSStringFunc)  (NSString*      name);
NSString* _Nonnull base64PEM(NSString * header)
{
    
    
}

-(NSStringFunc)base64PEM
{
    return base64PEM;
}
*/

-(NSString*)base64PEM:(NSString*)header {

    NSString * base64 =  self.base64;
    
    int numLines = 1;
    int rmod = base64.length % 64;
    if( base64.length > 64 )
    {
        numLines = (int)base64.length/64 + (rmod > 0 ? 1 : 0);
    }
    
    //PEM header
    NSString * pemString = [NSString stringWithFormat:@"-----BEGIN %@-----\n", header];
    int lineIndex = 0;
    for(lineIndex = 0; lineIndex<numLines-1; lineIndex++)
    {
        NSRange substrRange = NSMakeRange(lineIndex * 64, 64);
        pemString = [pemString stringByAppendingString:[base64 substringWithRange:substrRange] ];
        pemString = [pemString stringByAppendingString:@"\n"];
    }
    
    //last line
    NSUInteger llLength = (rmod > 0 ? rmod : 64);
    NSRange substrRange = NSMakeRange(lineIndex * 64, llLength);
    pemString = [pemString stringByAppendingString:[base64 substringWithRange:substrRange] ];
    pemString = [pemString stringByAppendingString:@"\n"];

    //PEM footer
    pemString = [pemString stringByAppendingString: [NSString stringWithFormat:@"-----END %@-----", header] ];

    return pemString;//[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSData *)dataWithSecKeyRef:(SecKeyRef)givenKey
{
    static const uint8_t publicKeyIdentifier[] = "art.vrtventures.publickey";
    NSData *publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];

    OSStatus sanityCheck = noErr;
    NSData * publicKeyBits = nil;

    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Temporarily add key to the Keychain, return as data:
    NSMutableDictionary * attributes = [queryPublicKey mutableCopy];
    [attributes setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
    [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
    if (sanityCheck == errSecSuccess) {
        publicKeyBits = CFBridgingRelease(result);

        // Remove from Keychain again:
        (void)SecItemDelete((__bridge CFDictionaryRef) queryPublicKey);
    }

    return publicKeyBits;
}


@end
