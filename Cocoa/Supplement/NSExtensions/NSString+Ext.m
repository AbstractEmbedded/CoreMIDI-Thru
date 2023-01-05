//
//  NSString+Ext.m
//  Mastry
//
//  Created by Joe Moulton on 6/9/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)

typedef NSString* _Nullable (*NSStringConstructor)(const char * str);

NSString* _Nullable NSStringConstructorImpl(const char * str)
{
    return [[NSString alloc] initWithUTF8String:str];
}

+(NSStringConstructor)NSString
{
    return NSStringConstructorImpl;
}


-(NSString*)toBase64
{
    //Convert Base64 to Base64URL By replacing '+' and '/' characters with '-' and '_' respectively
    NSString * base64 = [self stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64 = [base64  stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    return base64;
}

-(NSString*)toBase64URL
{
    //Convert Base64 to Base64URL By replacing '+' and '/' characters with '-' and '_' respectively
    NSString * base64URL = [self stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64URL = [base64URL  stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64URL;
}

-(NSString*)uriEncode:(BOOL)encodeSlash
{
    NSMutableString * result = [NSMutableString new];
    for (int i = 0; i < self.length; i++)
    {
        unichar ch = [self characterAtIndex:i];

        if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '_' || ch == '-' || ch == '~' || ch == '.' || ch == '\n')//|| ch == ':' || ch == '+')
            [result appendFormat:@"%c", ch];
        else if (ch == '%')
            [result appendFormat:@"%c", ch];
        else if (ch == '/')
        {
            if( encodeSlash)
                [result appendFormat:@"%%2F"];
            else
                [result appendFormat:@"%c", ch];
        }
        else //hex
            [result appendFormat:@"%x", ch];
    }
    return result;
}


-(NSString*)urlEncode:(BOOL)encodeSlash
{
    NSMutableString * result = [NSMutableString new];
    for (int i = 0; i < self.length; i++)
    {
        unichar ch = [self characterAtIndex:i];

        if( ch > 127 )
        {
            /*
            union fourCC{
                
                int  charcode;
                char bytes[4];
            }fourCC;
            
            fourCC.bytes[0] = ch;
            fourCC.bytes[1] = [self characterAtIndex:++i];
            fourCC.bytes[2] = [self characterAtIndex:++i];
            fourCC.bytes[3] = [self characterAtIndex:++i];

            uint32_t data = OSSwapHostToLittleInt32(fourCC.charcode); // Convert to little-endian
            NSString *fourCCString = [[NSString alloc] initWithBytes:&data length:4 encoding:NSUTF32LittleEndianStringEncoding];
            NSLog(@"fourCC = %@", fourCCString); // 😊
            [result appendString:fourCCString];
            continue;
            */
            //[result appendFormat:@"%C", ch];

            unichar digits3 = 0x0800;
            
            if( ch < digits3)
            {
                
                
                    union twoCC{
                        unichar       unibytes;
                        unsigned char bytes[2];
                    }twoCC;
                    
                    twoCC.unibytes = ch;
                    //unichar ch2 = [self characterAtIndex:++i];

                    //[result appendString:@"%"];
                    //[result appendFormat:@"%.2x", twoCC.bytes[1]];
                    //[result appendString:@"%"];
                    //[result appendFormat:@"%.2x", twoCC.bytes[0]];
                    //[result appendFormat:@"%x", twoCC.bytes[0]];

                
                    //unsigned char bitMask2 = 0x3;
                    unsigned char bitMask3 = 0x7;
                    //unsigned char bitMask5 = 0x1F;
                    unsigned char bitMask6 = 0x3F;
                
                    unsigned char comp1lowest5Bytes = twoCC.bytes[1] & bitMask3;
                    unsigned char comp2lowest6Bytes = twoCC.bytes[0] & bitMask6;
                    unsigned char next2Bytes =   twoCC.bytes[0] >> 6;

                    comp1lowest5Bytes = comp1lowest5Bytes << 2;
                    comp1lowest5Bytes |= next2Bytes;

                    unsigned char byteHeader1 = 0x6;
                    unsigned char byteHeader2 = 0x2;
                
                    unsigned char encodedByte1 = byteHeader1 << 5;
                    unsigned char encodedByte2 = byteHeader2 << 6;
                
                    encodedByte1 |= comp1lowest5Bytes;
                    encodedByte2 |= comp2lowest6Bytes;

                    NSString * byte1Str = [NSString stringWithFormat:@"%.2x", encodedByte1];
                    NSString * byte2Str = [NSString stringWithFormat:@"%.2x", encodedByte2];

                    [result appendString:@"%"];
                    [result appendString:byte1Str.uppercaseString];
                    [result appendString:@"%"];
                    [result appendString:byte2Str.uppercaseString];
                    
                    //i++;
                    //  [result appendFormat:@"%u", [self characterAtIndex:++i]];
                    //[result appendFormat:@"%u", [self characterAtIndex:++i]];
                
            }


        }
        else if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '_' || ch == '-' || ch == '~' || ch == '.' || ch == '\n')//|| ch == ':' || ch == '+')
            [result appendFormat:@"%c", ch];
        else if( ch == ':')
            [result appendFormat:@"%%3A"];
        else if( ch == ';')
            [result appendFormat:@"%%3B"];
        else if( ch == '=')
            [result appendFormat:@"%%3D"];
        else if( ch == ' ')
            [result appendFormat:@"%%20"];
        else if( ch == '+')
            [result appendFormat:@"%%2B"];
        else if( ch == ',')
            [result appendFormat:@"%%2C"];
        else if( ch == '\'')
            [result appendFormat:@"%%27"];
        else if (ch == '/')
        {
            if( encodeSlash)
                [result appendFormat:@"%%2F"];
            else
                [result appendFormat:@"%c", ch];
        }
        else//hex
        {
            [result appendString:@"%"];
            [result appendFormat:@"%x", ch];
            
        }
    }
    return result;
}



+(NSString*)formatCurrencyString:(unsigned long)currencyLong withSpace:(BOOL)space
{
    
    NSString *walletValueString;
    NSString *modifier;
    double walletValue = (double)currencyLong;
    bool fiveFigures = false;
    
    if( walletValue > 999999999.)
    {
        walletValue = walletValue / 1000000000.;
        modifier = @"B";
    }
    else if( walletValue > 999999.)
    {
        walletValue = walletValue / 1000000.;
        modifier = @"M";

    }
    else if( walletValue > 9999.)
    {
        walletValue = walletValue / 1000.;
        modifier = @"K";
        fiveFigures=true;
    }
    else
    {
        //walletValueString = [NSString stringWithFormat:@" %.3f ", walletValue];
        modifier = @"";
    }
    
    if(space)
        modifier = [NSString stringWithFormat:@" %@", modifier];
    
    unsigned long walletValueLong = walletValue;
    
    if( walletValueLong > 99 || fiveFigures ) //3 significant digits
    {
        walletValueString = [NSString stringWithFormat:@"%lu%@", walletValueLong, modifier];
    }
    else if ( walletValueLong > 9 )
    {
        walletValueString = [NSString stringWithFormat:@"%lu%@", (unsigned long)walletValue, modifier];
    }
    else// if( walletValueLong > 10 )
    {
        walletValueString = [NSString stringWithFormat:@"%lu%@", (unsigned long)walletValue, modifier];
    }
    
    return walletValueString;
}

@end
