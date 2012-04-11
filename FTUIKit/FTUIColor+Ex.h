//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FT_HTML_COLOR(__str__)						[UIColor ft_colorWithHTMLString:(__str__) alpha:1.0f]
#define FT_HTML_COLOR_A(__str__, __alpha__)			[UIColor ft_colorWithHTMLString:(__str__) alpha:(__alpha__)]
#define FT_RGB_COLOR(__r__, __g__, __b__)			[UIColor ft_colorWith255Red:(__r__) green:(__g__) blue:(__b__) alpha:255]
#define FT_RGBA_COLOR(__r__, __g__, __b__, __a__)	[UIColor ft_colorWith255Red:(__r__) green:(__g__) blue:(__b__) alpha:(__a__)]

@interface UIColor (FTUIColorEx)

+(UIColor*) ft_colorWithHTMLString:(NSString*)string alpha:(CGFloat)alpha;
+(UIColor*) ft_colorWith255Red:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

+ (UIColor *)ft_tableCellBlueTextColor;
+ (UIColor *)ft_tableCellValue1BlueColor;
+ (UIColor *)ft_tableCellValue2BlueColor;
+ (UIColor *)ft_tableCellGrayTextColor;
+ (UIColor *)ft_infoTextOverPinStripeTextColor;

@end
