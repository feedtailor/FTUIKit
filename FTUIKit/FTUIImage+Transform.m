//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTUIImage+Transform.h"

@implementation UIImage (FTUIImageTransform)


/* http://blog.logichigh.com/2008/06/05/uiimage-fix/ */

+(UIImage*) ft_imageWithImage:(UIImage*)image autoRotate:(BOOL)autoRotate maxResolution:(CGFloat)resolution
{
	UIImageOrientation orientation = (autoRotate) ? image.imageOrientation : UIImageOrientationUp;
	
	return [UIImage ft_imageWithImage:image orientation:orientation maxResolution:resolution];
}

+(UIImage*) ft_imageWithImage:(UIImage*)image orientation:(UIImageOrientation)orientation maxResolution:(CGFloat)resolution
{
	return [UIImage ft_imageWithCGImage:image.CGImage orientation:orientation maxResolution:resolution];
}

+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef orientation:(UIImageOrientation)orientation maxResolution:(CGFloat)resolution
{
	CGFloat angle = 0.0;
	CGSize scale2D = CGSizeZero;
	
	switch (orientation) {
		case UIImageOrientationUp: //EXIF = 1
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			scale2D.width = -1.0;
			//				transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			//				transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			angle = M_PI;
			//				transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			//				transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			scale2D.height = -1.0;
			//				transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			//				transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			scale2D.width = -1.0;
			angle = M_PI / 2.0;
			//				boundHeight = bounds.size.height;
			//				bounds.size.height = bounds.size.width;
			//				bounds.size.width = boundHeight;
			//				transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			//				transform = CGAffineTransformScale(transform, -1.0, 1.0);
			//				transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			angle = 3.0 * M_PI / 2.0;
			//				boundHeight = bounds.size.height;
			//				bounds.size.height = bounds.size.width;
			//				bounds.size.width = boundHeight;
			//				transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			//				transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			scale2D.width = -1.0;
			angle = 3.0 * M_PI / 2.0;
			//				boundHeight = bounds.size.height;
			//				bounds.size.height = bounds.size.width;
			//				bounds.size.width = boundHeight;
			//				transform = CGAffineTransformMakeScale(-1.0, 1.0);
			//				transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			angle = M_PI / 2.0;
			//				boundHeight = bounds.size.height;
			//				bounds.size.height = bounds.size.width;
			//				bounds.size.width = boundHeight;
			//				transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			//				transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}		
	
	return [UIImage ft_imageWithCGImage:imgRef scale:scale2D rotate:angle maxResolution:resolution];
}

+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef scale:(CGSize)scale2D rotate:(CGFloat)angle maxResolution:(CGFloat)resolution
{
	CGFloat scaleRatio;
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);	
	
	if (scale2D.width == 0) {
		scale2D.width = 1.0;
	}
	if (scale2D.height == 0) {
		scale2D.height = 1.0;
	}
	
	CGRect bounds = CGRectMake(0, 0, width * fabsf(scale2D.width), height * fabsf(scale2D.height));
	
	CGPoint p1 = CGPointMake(bounds.size.width * cosf(angle) - bounds.size.height * sinf(angle), bounds.size.width * sinf(angle) + bounds.size.height * cosf(angle));
	CGPoint p2 = CGPointMake(bounds.size.width * cosf(angle), bounds.size.width * sinf(angle));
	CGPoint p3 = CGPointMake(- bounds.size.height * sinf(angle), bounds.size.height * cosf(angle));
	
	// 左上原点で回転した後に元に戻すための差分
	// および、できあがる画像の外接矩形サイズ
	CGFloat dx = 0;
	CGFloat dy = 0;
	if (angle < M_PI / 2.0) {
		dx = height * sinf(angle);
		
		bounds.size.width = (p2.x - p3.x);
		bounds.size.height = p1.y;
	} else if (angle < M_PI) {
		dx = (-1) * (width * cosf(angle) - height * sinf(angle));
		dy = height * cosf(angle);
		
		bounds.size.width = -p1.x;
		bounds.size.height = p2.y - p3.y;
	} else if (angle < M_PI / 2.0 * 3.0) {
		dx = (-1) * width * cosf(angle);
		dy = width * sinf(angle) + height * cosf(angle);
		
		bounds.size.width = (p3.x - p2.x);
		bounds.size.height = -p1.y;
	} else {
		dy = width * sinf(angle);
		
		bounds.size.width = p1.x;
		bounds.size.height = p3.y - p2.y;
	}
	
	if (resolution == 0) {
		// リサイズしない
		scaleRatio = 1.0;
	} else {
		CGFloat baseWidth = bounds.size.width;
		if (bounds.size.width > resolution || bounds.size.height > resolution) {
			CGFloat ratio = bounds.size.width / bounds.size.height;
			if (ratio > 1) {
				bounds.size.width = resolution;
				bounds.size.height = bounds.size.width / ratio;
			} else {
				bounds.size.height = resolution;
				bounds.size.width = bounds.size.height * ratio;
			}
		}
		scaleRatio = bounds.size.width / baseWidth;
	}
	// 小数点以下の数値を丸める
	bounds.size.width = round(bounds.size.width);
	bounds.size.height = round(bounds.size.height);
	
	//	NSLog(@"(%f,%f) %f, %f => %@, %f", width, height, resolution, angle, NSStringFromCGSize(bounds.size), scaleRatio);
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// 負のスケールは鏡像なので先に平行移動
	if (scale2D.width < 0) {
		transform = CGAffineTransformTranslate(transform, bounds.size.width, 0);
	}
	if (scale2D.height < 0) {
		transform = CGAffineTransformTranslate(transform, 0, bounds.size.height);
	}
	transform = CGAffineTransformScale(transform, scale2D.width, scale2D.height);
	transform = CGAffineTransformRotate(transform, angle);
	transform = CGAffineTransformScale(transform, scaleRatio, -scaleRatio);
	transform = CGAffineTransformTranslate(transform, dx * cosf(angle) - dy * sinf(angle), - height + (dx * sinf(angle) + dy * cosf(angle)));
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
	
	// 変換後の画像
	UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImg;	
}

+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef cropRect:(CGRect)cropRect maxResolution:(CGFloat)resolution fillAll:(BOOL)fillAll
{
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	UIImage* img = nil;
	
	// 切り取り範囲を超えていても自動的に必要な部分だけを切り取ってくれるみたい
	CGImageRef cropped = CGImageCreateWithImageInRect(imgRef, cropRect);
	if (!fillAll || 
		(cropRect.origin.x >= 0 && cropRect.origin.y >= 0 && cropRect.origin.x + cropRect.size.width <= width && cropRect.origin.y + cropRect.size.height <= height)) {
		// 画像の方が切り取り範囲より大きい場合は普通に切り取るだけ
		img = [UIImage ft_imageWithCGImage:cropped scale:CGSizeZero rotate:0.0 maxResolution:resolution];
		CGImageRelease(cropped);	
	} else {
		// 切り取り範囲が画像を超えている場合は透過で埋める
		// リサイズも同時に行う
		CGFloat croppedWidth = CGImageGetWidth(cropped);
		CGFloat croppedHeight = CGImageGetHeight(cropped);
		CGRect bounds = CGRectMake(0, 0, cropRect.size.width, cropRect.size.height);
		CGFloat scaleRatio;
		
		if (resolution == 0) {
			// リサイズしない
			scaleRatio = 1.0;
		} else {
			CGFloat baseWidth = bounds.size.width;
			if (bounds.size.width > resolution || bounds.size.height > resolution) {
				CGFloat ratio = bounds.size.width / bounds.size.height;
				if (ratio > 1) {
					bounds.size.width = resolution;
					bounds.size.height = bounds.size.width / ratio;
				} else {
					bounds.size.height = resolution;
					bounds.size.width = bounds.size.height * ratio;
				}
			}
			scaleRatio = bounds.size.width / baseWidth;
		}
		
		// 小数点以下の数値を丸める
		bounds.size.width = round(bounds.size.width);
		bounds.size.height = round(bounds.size.height);
		
		UIGraphicsBeginImageContext(bounds.size);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGRect rect = cropRect;
		if (rect.origin.x >= 0) {
			rect.origin.x = 0;
		} else {
			rect.origin.x *= (-1);
		}
		if (cropRect.origin.y >= 0 && cropRect.origin.y + cropRect.size.height <= height) {
			rect.origin.y = 0;
		} else {
			rect.origin.y = rect.size.height - (height - rect.origin.y);
			if (rect.origin.y < 0) {
				// 負にしてはいけない
				rect.origin.y = 0;
			}
		}
		
		if (rect.size.width > croppedWidth) {
			rect.size.width = croppedWidth;
		}
		if (rect.size.height > croppedHeight) {
			rect.size.height = croppedHeight;
		}
		
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -cropRect.size.height);
		CGContextDrawImage(context, rect, cropped);
		
		img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		CGImageRelease(cropped);
	}
	return img;
}

+(UIImage*) ft_imageWithCGImage:(CGImageRef)imageRef maxResolution:(CGFloat)resolution
{
	if (resolution == 0) {
		return [UIImage imageWithCGImage:imageRef];
	}
	
	CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
	if (newSize.width > resolution || newSize.height > resolution) {
		CGFloat ratio = newSize.width / newSize.height;
		if (ratio > 1) {
			newSize.width = resolution;
			newSize.height = newSize.width / ratio;
		} else {
			newSize.height = resolution;
			newSize.width = newSize.height * ratio;
		}
	}
	
	// 小数点以下の数値を丸める
	newSize.width = round(newSize.width);
	newSize.height = round(newSize.height);
	
	UIGraphicsBeginImageContext(newSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -newSize.height);
	CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height), imageRef);
	
	UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

-(UIImage*) ft_resizedImageWithMaxResolution:(CGFloat)resolution
{
	return [UIImage ft_imageWithCGImage:self.CGImage maxResolution:resolution];
}

+(UIImageOrientation) ft_imageOrientationWithExifOrientation:(int)exifOrientation
{
	UIImageOrientation orientation = UIImageOrientationUp;
	switch (exifOrientation) {
		case 1 :
			orientation = UIImageOrientationUp;
			break;
		case 2 :
			orientation = UIImageOrientationUpMirrored;
			break;
		case 3 :
			orientation = UIImageOrientationDown;
			break;
		case 4 :
			orientation = UIImageOrientationDownMirrored;
			break;
		case 5 :
			orientation = UIImageOrientationLeftMirrored;
			break;
		case 6 :
			orientation = UIImageOrientationLeft;
			break;
		case 7 :
			orientation = UIImageOrientationRightMirrored;
			break;
		case 8 :
			orientation = UIImageOrientationRight;
			break;
	}
	return orientation;
}

+(CGFloat) ft_rotateAngleForImageOrientation:(UIImageOrientation)orientation
{
	CGFloat angle = 0.0;
	
	switch (orientation) {
		case UIImageOrientationUp: //EXIF = 1
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			angle = M_PI;
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			angle = M_PI / 2.0;
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			angle = 3.0 * M_PI / 2.0;
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			angle = 3.0 * M_PI / 2.0;
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			angle = M_PI / 2.0;
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	return angle;
}

@end
