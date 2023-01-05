//
//  NSData+Ext.h
//  Mineralism
//
//  Created by Joe Moulton on 11/18/19.
//  Copyright © 2019 VRTVentures LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Ext)

-(NSString*)base64;
//-(NSString*)base64PEM;
-(NSString*)base64PEM:(NSString*)header;

+ (NSData *)dataWithSecKeyRef:(SecKeyRef)givenKey;

@end

NS_ASSUME_NONNULL_END
