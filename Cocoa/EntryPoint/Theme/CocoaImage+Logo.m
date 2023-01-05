//
//  NSImage+Logo.m
//  CoreMIDI Thru
//
//  Created by Joe Moulton on 1/4/23.
//

#import "CocoaImage+Logo.h"
#import "NSColor+3rdGen.h"

@implementation CocoaImage (Logo)

+(void)createAppIconImages
{
    for(int size = 1024; size>15; size/=2)
    {
        CGSize imgSize = CGSizeMake(size, size);
        NSString * imgPath = [NSString stringWithFormat:@"/Users/jmoulton/Pictures/Logo%dx%d.png", size, size];
        CocoaImage * image = [CocoaImage logoImage:imgSize];
        [CocoaImage saveImage:image atPath:imgPath];
    }
}

+ (void)saveImage:(NSImage *)image atPath:(NSString *)path {

   CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                            context:nil
                                              hints:nil];
   NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
   [newRep setSize:[image size]];   // if you want the same resolution
   NSData *pngData = [newRep representationUsingType:NSBitmapImageFileTypePNG properties:[NSDictionary new]];
   [pngData writeToFile:path atomically:YES];
   //[newRep autorelease];
}

+(CocoaImage *)logoImage:(CGSize)imgSize
{
    CGRect imgRect = CGRectMake(0,0,imgSize.width, imgSize.height);
    
#if TARGET_OS_OSX
    //CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] CGContext];
    
    NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc]
       initWithBitmapDataPlanes:NULL
       pixelsWide:imgSize.width
       pixelsHigh:imgSize.height
       bitsPerSample:8
       samplesPerPixel:4
       hasAlpha:YES
       isPlanar:NO
       colorSpaceName:NSDeviceRGBColorSpace
       bitmapFormat:NSBitmapFormatAlphaFirst
       bytesPerRow:0
       bitsPerPixel:0];// autorelease];

    // set offscreen context
    NSGraphicsContext *nsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsContext];

 
    // Drawing code here.
    [[NSColor clearColor] setFill];
    [NSBezierPath fillRect:imgRect];
    
    CGFloat strokeWidth = 3.0f/150.f * imgSize.width;
    
    NSBezierPath * fillPath = [NSBezierPath bezierPathWithOvalInRect:imgRect];
    [[NSColor logoPrimaryColor] setFill];
    [fillPath fill];
    
    CGRect insetRect = CGRectMake(imgRect.origin.x + strokeWidth/2., imgRect.origin.y+strokeWidth/2., imgRect.size.width - strokeWidth, imgRect.size.height-strokeWidth);
    NSBezierPath * strokePath = [NSBezierPath bezierPathWithOvalInRect:insetRect];
    [[NSColor logoAccentColor] setStroke];
    strokePath.lineWidth = strokeWidth;
    [strokePath stroke];
    
    
    CGFloat circleRadius = 15.f/150.f * imgSize.width;
    CGRect circleRect = CGRectMake( imgRect.size.width/2. - circleRadius/2., imgRect.size.height * 0.85f - circleRadius/2., circleRadius, circleRadius);
    NSBezierPath * fillCircle1 = [NSBezierPath bezierPathWithOvalInRect:circleRect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle1 fill];
    
    CGFloat hOffset = 30.f/150.f * imgSize.width;
    CGFloat hOffset2 = 50.f/150.f * imgSize.width;
    
    CGFloat vOffset = 8.f/150.f * imgSize.width;
    CGFloat vOffset2 = 30.5f/150.f * imgSize.width;
    

    CGRect circle2Rect = CGRectMake( circleRect.origin.x - hOffset, circleRect.origin.y - vOffset, circleRadius, circleRadius);
    NSBezierPath * fillCircle2 = [NSBezierPath bezierPathWithOvalInRect:circle2Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle2 fill];
    
    CGRect circle3Rect = CGRectMake( circleRect.origin.x + hOffset, circleRect.origin.y - vOffset, circleRadius, circleRadius);
    NSBezierPath * fillCircle3 = [NSBezierPath bezierPathWithOvalInRect:circle3Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle3 fill];
    
    CGRect circle4Rect = CGRectMake( circleRect.origin.x - hOffset2, circleRect.origin.y - vOffset2, circleRadius, circleRadius);
    NSBezierPath * fillCircle4 = [NSBezierPath bezierPathWithOvalInRect:circle4Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle4 fill];
    
    CGRect circle5Rect = CGRectMake( circleRect.origin.x + hOffset2, circleRect.origin.y - vOffset2, circleRadius, circleRadius);
    NSBezierPath * fillCircle5 = [NSBezierPath bezierPathWithOvalInRect:circle5Rect];
    [[NSColor logoAccentColor] setFill];
    [fillCircle5 fill];
    
    //draw label

    ///CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    //char* text= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    //CGContextSelectFont(context, "Arial",12, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(nsContext.CGContext, kCGTextFill);
    CGContextSetRGBFillColor(nsContext.CGContext, 0, 0, 0, 1);
    //CGContextShowTextAtPoint(context,img.size.width/2, img.size.height/2,text, strlen(text));
    
    /*
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting alignmentSetting;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    alignmentSetting.value = &alignment;
    CTParagraphStyleSetting settings[1] = {alignmentSetting};
     size_t settingsCount = 1;
     CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, settingsCount);

     (__bridge id)kCTParagraphStyleAttributeName : (__bridge id)paragraphRef,
     */
    
    
    CGFloat fontSize = imgSize.width > 512 ? 24.5f : 24.f;
    if( imgSize.width < 512 ) fontSize = 23.f;
    
    NSDictionary *attributes = @{NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:fontSize/150.f * imgSize.width], NSForegroundColorAttributeName : [NSColor whiteColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"MIDI\nThru" attributes:attributes];
    //[@"THRU" drawAtPoint:CGPointMake(imgSize.width/2, imgSize.height/2) withAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Helvetica" size:22.5f/150.f * imgSize.width]}];
    
    //get the size of the string
    NSSize labelSize = [attributedString size];
    
    [attributedString drawAtPoint:CGPointMake(imgSize.width/2. - labelSize.width/2., (0.5 * imgSize.height) - labelSize.height*(2./3.))];
     // done drawing, so set the current context back to what it was
     [NSGraphicsContext restoreGraphicsState];

     // create an NSImage and add the rep to it
     NSImage *image = [[NSImage alloc] initWithSize:imgSize];// autorelease];
     [image addRepresentation:offscreenRep];

     // then go on to save or view the NSImage
     
    
    
    return image;

#else
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //CGContextFillRect(context, rect);
    
    CGContextFillEllipseInRect(context, circleRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#endif

    return image;
}



@end
