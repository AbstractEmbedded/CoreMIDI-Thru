/*
 *  NSData+MappedToFile - An NSData stream to a file on disk
 *
 *
 *  Created by MACMaster on 11/16/14.
 *  Copyright (c) 2014 Abstract Embedded, LLC. All rights reserved.
 *
 *
 */


#import <Foundation/Foundation.h>

@interface NSData (MappedToFile)

@property (nonatomic, readonly) unsigned long long lengthInBytes;

+ (instancetype)dataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)dataWithMappedContentsOfURL:(NSURL *)url;

+ (instancetype)modifiableDataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)modifiableDataWithMappedContentsOfURL:(NSURL *)url;

- (void)synchronizeMappedFile;

@end
