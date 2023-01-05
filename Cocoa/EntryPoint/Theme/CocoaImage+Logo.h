//
//  NSImage+Logo.h
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 1/4/23.
//


#import <TargetConditionals.h>

#import <Cocoa/Cocoa.h>

#if TARGET_OS_OSX
#define CocoaImage NSImage
#else
#define CocoaImage UIImage
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CocoaImage (Logo)

+(void)createAppIconImages;
+(CocoaImage *)logoImage:(CGSize)size;

+ (void)saveImage:(NSImage *)image atPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
