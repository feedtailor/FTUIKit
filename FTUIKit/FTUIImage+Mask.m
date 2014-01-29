//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUIImage+Mask.h"

@implementation UIImage (FTUIImageMask)

-(UIImage*) ft_imageWithMask:(UIImage*)maskImage
{
	CGContextRef mainViewContentContext;
	CGColorSpaceRef colorSpace;
	
	CGFloat width = CGImageGetWidth(self.CGImage);
	CGFloat height = CGImageGetHeight(self.CGImage);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create a bitmap graphics context the size of the image
	mainViewContentContext = CGBitmapContextCreate (NULL, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	
	// free the rgb colorspace
	CGColorSpaceRelease(colorSpace);
	
	if (mainViewContentContext==NULL) {
		return NULL;
	}
	
	CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, width, height), maskImage.CGImage);
	CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, width, height), self.CGImage);
	
	// Create CGImageRef of the main view bitmap content, and then
	// release that bitmap context
	CGImageRef maskedImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	UIImage* result = [UIImage imageWithCGImage:maskedImage];
	CGImageRelease(maskedImage);
	
	return result;
}

@end
