//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FTUIImageDrawBlock)(CGSize, CGContextRef);

@interface UIImage (FTUIImageBlockDraw)

+ (UIImage *)ft_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale drawBlock:(FTUIImageDrawBlock)block;

@end

