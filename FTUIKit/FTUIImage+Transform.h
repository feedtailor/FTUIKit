//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FTUIImageTransform)

/**
 * @brief	画像変換
 * @param	autoRotate	EXIFに基づいた回転を行うかどうか
 * @param	resolution	変換後の最大解像度（回転した場合は透過部分も含む）: 0で指定なし
 */
+(UIImage*) ft_imageWithImage:(UIImage*)image autoRotate:(BOOL)autoRotate maxResolution:(CGFloat)resolution;

/**
 * @brief	画像変換
 * @param	orientation	画像の向きを直に指定
 * @param	resolution	変換後の最大解像度（回転した場合は透過部分も含む）: 0で指定なし
 */
+(UIImage*) ft_imageWithImage:(UIImage*)image orientation:(UIImageOrientation)orientation maxResolution:(CGFloat)resolution;
+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef orientation:(UIImageOrientation)orientation maxResolution:(CGFloat)resolution;

/**
 * @brief	画像変換
 * @param	imgRef		変換元の画像
 * @param	scale2D		XY両方向に対する拡大率 : CGSizeZeroで指定なし
 * @param	angle		回転角度（ラジアン）
 * @param	resolution	変換後の最大解像度（回転した場合は透過部分も含む）: 0で指定なし
 * @note	処理順のイメージとしては、scale2Dの拡大 => angleの回転 => resolutionにあわせて縮小
 */
+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef scale:(CGSize)scale2D rotate:(CGFloat)angle maxResolution:(CGFloat)resolution;

/**
 * @brief	画像切り抜き
 * @param	imgRef		変換元の画像
 * @param	cropRect	切り抜く範囲
 * @param	resolution	変換後の最大解像度（回転した場合は透過部分も含む）: 0で指定なし
 * @param	fillAll		余白を埋めるかどうか
 */
+(UIImage*) ft_imageWithCGImage:(CGImageRef)imgRef cropRect:(CGRect)cropRect maxResolution:(CGFloat)resolution fillAll:(BOOL)fillAll;

+(UIImage*) ft_imageWithCGImage:(CGImageRef)imageRef maxResolution:(CGFloat)resolution;
-(UIImage*) ft_resizedImageWithMaxResolution:(CGFloat)resolution;

+(UIImageOrientation) ft_imageOrientationWithExifOrientation:(int)exifOrientation;
+(CGFloat) ft_rotateAngleForImageOrientation:(UIImageOrientation)orientation;

@end
