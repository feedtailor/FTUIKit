//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUIImage+BlockDraw.h"

@implementation UIImage(FTUIImageBlockDraw)

+ (UIImage *)ft_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale drawBlock:(FTUIImageDrawBlock)block
{
	UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
	block(size, UIGraphicsGetCurrentContext());
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
