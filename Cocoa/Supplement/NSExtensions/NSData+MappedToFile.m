/*
 *  NSData+MappedToFile - An NSData stream to a file on disk
 *
 *
 *  Created by MACMaster on 11/16/14.
 *  Copyright (c) 2014 Abstract Embedded, LLC. All rights reserved.
 *
 *
 */

#import "NSData+MappedToFile.h"
#include <sys/types.h>
#include <sys/mman.h>

static NSMutableDictionary *get_size_map()
{
  static NSMutableDictionary *map = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    map = [[NSMutableDictionary alloc] init];
  });

  return map;
}

static void mmap_deallocate(void *ptr, void *info)
{
    printf("\nmmap_dealloc\n");

  NSNumber *key = [NSNumber numberWithUnsignedLongLong:(uintptr_t)ptr];
  NSNumber *fileSize = nil;

  NSMutableDictionary *sizeMap = get_size_map();
  @synchronized(sizeMap) {
    fileSize = [sizeMap objectForKey:key];
    [sizeMap removeObjectForKey:key];
  }

  size_t size = (size_t)[fileSize unsignedLongLongValue];
  munmap(ptr, size);
}

static CFAllocatorRef get_mmap_deallocator()
{
  static CFAllocatorRef deallocator = NULL;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CFAllocatorContext context;
    bzero(&context, sizeof(context));
    context.deallocate = mmap_deallocate;

    deallocator = CFAllocatorCreate(kCFAllocatorDefault, &context);
  });

  return deallocator;
}

@implementation NSData (MappedToFile)

-(void)dealloc
{
    //[super dealloc];
    NSLog(@"NSData+MappedToFile Dealloc");
    
}

+ (instancetype)dataWithMappedContentsOfFile:(NSString *)path
{
  return [[self class] _dataWithMappedContentsOfFile:path modifiable:NO];
}

+ (instancetype)dataWithMappedContentsOfURL:(NSURL *)url
{
  return [[self class] dataWithMappedContentsOfFile:[url path]];
}

+ (instancetype)modifiableDataWithMappedContentsOfFile:(NSString *)path
{
  return [[self class] _dataWithMappedContentsOfFile:path modifiable:YES];
}

+ (instancetype)modifiableDataWithMappedContentsOfURL:(NSURL *)url
{
  return [[self class] modifiableDataWithMappedContentsOfFile:[url path]];
}

+ (instancetype)_dataWithMappedContentsOfFile:(NSString *)path modifiable:(BOOL)modifiable
{
  NSFileHandle *fileHandle = nil;
  if (modifiable) {
    fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
  }
  else {
    fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
  }
  if (fileHandle == nil) {
      NSLog(@"fileHandle == nil");

    return nil;
  }

  int fd = [fileHandle fileDescriptor];
  if (fd < 0) {
      NSLog(@"fileDescriptor < 0");

    return nil;
  }

  off_t size = lseek(fd, 0, SEEK_END);
  if (size < 0) {
      NSLog(@"size < 0");

    return nil;
  }

  int protection = PROT_READ;
  if (modifiable) {
    protection |= PROT_WRITE;
  }

  void *address = mmap(NULL, (size_t)size, protection, MAP_FILE | MAP_SHARED, fd, 0);
  if (address == MAP_FAILED) {
      NSLog(@"address == MAP_FAILED");

    return nil;
  }

    NSLog(@"Mmap success");
  NSMutableDictionary *sizeMap = get_size_map();
  @synchronized(sizeMap) {
    [sizeMap setObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)size]
                forKey:[NSNumber numberWithUnsignedLongLong:(uintptr_t)address]];
  }

  return CFBridgingRelease(CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, (const UInt8 *)address, (CFIndex)size, kCFAllocatorDefault));
}

-(unsigned long long)lengthInBytes
{
    
    NSNumber *key = [NSNumber numberWithUnsignedLongLong:(uintptr_t)[self bytes]];
    NSNumber *fileSize = nil;
    
    NSMutableDictionary *sizeMap = get_size_map();
    @synchronized(sizeMap) {
        fileSize = [sizeMap objectForKey:key];
    }
    
    
    if (fileSize == nil) {
        return 0;
    }
    
    return [fileSize unsignedLongLongValue];
}

- (void)synchronizeMappedFile
{
  NSNumber *key = [NSNumber numberWithUnsignedLongLong:(uintptr_t)[self bytes]];
  NSNumber *fileSize = nil;

  NSMutableDictionary *sizeMap = get_size_map();
  @synchronized(sizeMap) {
    fileSize = [sizeMap objectForKey:key];
  }

  if (fileSize == nil) {
    return;
  }

  size_t size = (size_t)[fileSize unsignedLongLongValue];
  msync((void *)[self bytes], size, MS_SYNC | MS_INVALIDATE);
}

@end
