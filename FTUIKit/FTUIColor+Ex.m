//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTUIColor+Ex.h"

#define RGBA(__r__, __g__, __b__, __a__)	[UIColor colorWithRed:(__r__) green:(__g__) blue:(__b__) alpha:(__a__)]

@implementation UIColor (FTUIColorEx)

+(UIColor*) ft_colorWithHTMLString:(NSString*)string alpha:(CGFloat)alpha
{
	NSString* code = ([string hasPrefix:@"#"]) ? [string substringFromIndex:1] : string;
	unsigned int red = 0, green = 0, blue = 0;
	if ([code length] == 6) {
		if (sscanf([code UTF8String], "%02x%02x%02x", &red, &green, &blue) != 3) {
			return nil;
		}
	} else if ([code length] == 3) {
		if (sscanf([code UTF8String], "%1x%1x%1x", &red, &green, &blue) != 3) {
			return nil;
		}
		red = (red | red << 4);
		green = (green | green << 4);
		blue = (blue | blue << 4);
	} else {
		return nil;
	}
	return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

+(UIColor*) ft_colorWith255Red:(int)red green:(int)green blue:(int)blue alpha:(int)alpha
{
	return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
}

#pragma mark - Predefined Colors

+ (UIColor *)ft_tableCellBlueTextColor
{
	return RGBA(0.22, 0.33, 0.53, 1);
}

+ (UIColor *)ft_tableCellValue1BlueColor
{
	return RGBA(0.22, 0.33, 0.53, 1);
}

+ (UIColor *)ft_tableCellValue2BlueColor
{
	return RGBA(0.32, 0.4, 0.57, 1);
}

+ (UIColor *)ft_tableCellGrayTextColor
{
	return RGBA(0.5, 0.5, 0.5, 1);
}

+ (UIColor *)ft_infoTextOverPinStripeTextColor
{
	return RGBA(0.3, 0.34, 0.42, 1);
}

@end

/*
 UIColor Class Methods:
 1: ft_colorWithHTMLString:alpha: : (null)
 2: ft_colorWith255Red:green:blue:alpha: : (null)
 3: noContentLightGradientBackgroundColor : kCGColorSpaceModelPattern 1 
 4: noContentDarkGradientBackgroundColor : kCGColorSpaceModelPattern 1 
 5: translucentPaperTextureColor : kCGColorSpaceModelPattern 1 
 6: whitePaperTextureColor : kCGColorSpaceModelPattern 1 
 7: groupTableViewBackgroundColor : kCGColorSpaceModelPattern 1 
 8: insertionPointColor : UIDeviceRGBColorSpace 0.26 0.42 0.95 1
 9: selectionHighlightColor : UIDeviceRGBColorSpace 0 0.33 0.65 0.2
 10: pinStripeColor : kCGColorSpaceModelPattern 1 
 11: lightTextColor : UIDeviceWhiteColorSpace 1 0.6
 12: darkTextColor : UIDeviceWhiteColorSpace 0 1
 13: viewFlipsideBackgroundColor : kCGColorSpaceModelPattern 1 
 14: underPageBackgroundColor : kCGColorSpaceModelPattern 1 
 15: scrollViewTexturedBackgroundColor : kCGColorSpaceModelPattern 1 
 16: padFaceTimeLightBabyBlueColor : UIDeviceRGBColorSpace 0.388235 0.666667 0.917647 1
 17: padFaceTimeBabyBlueColor : UIDeviceRGBColorSpace 0.345098 0.541176 0.741176 1
 18: padFaceTimeLightSeparatorColor : UIDeviceWhiteColorSpace 1 0.1
 19: padFaceTimeDarkSeparatorColor : UIDeviceWhiteColorSpace 0 0.5
 20: padFaceTimeSectionOutlineColor : UIDeviceWhiteColorSpace 0 0.7
 21: padFaceTimeShadowedGroupBackgroundColor : UIDeviceWhiteColorSpace 0 0.2
 22: padFaceTimeLightBabyBlueColor : UIDeviceRGBColorSpace 0.388235 0.666667 0.917647 1
 23: padFaceTimeBabyBlueColor : UIDeviceRGBColorSpace 0.345098 0.541176 0.741176 1
 24: padFaceTimeLightSeparatorColor : UIDeviceWhiteColorSpace 1 0.1
 25: padFaceTimeDarkSeparatorColor : UIDeviceWhiteColorSpace 0 0.5
 26: padFaceTimeSectionOutlineColor : UIDeviceWhiteColorSpace 0 0.7
 27: padFaceTimeShadowedGroupBackgroundColor : UIDeviceWhiteColorSpace 0 0.2
 28: padFaceTimeLightBabyBlueColor : UIDeviceRGBColorSpace 0.388235 0.666667 0.917647 1
 29: padFaceTimeBabyBlueColor : UIDeviceRGBColorSpace 0.345098 0.541176 0.741176 1
 30: padFaceTimeLightSeparatorColor : UIDeviceWhiteColorSpace 1 0.1
 31: padFaceTimeDarkSeparatorColor : UIDeviceWhiteColorSpace 0 0.5
 32: padFaceTimeSectionOutlineColor : UIDeviceWhiteColorSpace 0 0.7
 33: padFaceTimeShadowedGroupBackgroundColor : UIDeviceWhiteColorSpace 0 0.2
 34: allocWithZone: : (null)
 35: blueColor : UIDeviceRGBColorSpace 0 0 1 1
 36: cyanColor : UIDeviceRGBColorSpace 0 1 1 1
 37: magentaColor : UIDeviceRGBColorSpace 1 0 1 1
 38: yellowColor : UIDeviceRGBColorSpace 1 1 0 1
 39: orangeColor : UIDeviceRGBColorSpace 1 0.5 0 1
 40: purpleColor : UIDeviceRGBColorSpace 0.5 0 0.5 1
 41: brownColor : UIDeviceRGBColorSpace 0.6 0.4 0.2 1
 42: _systemColorWithName: : (null)
 43: tableBackgroundColor : UIDeviceRGBColorSpace 1 1 1 1
 44: tableSeparatorLightColor : UIDeviceRGBColorSpace 0.88 0.88 0.88 1
 45: tableGroupedSeparatorLightColor : UIDeviceRGBColorSpace 0 0 0 0.18
 46: textFieldAtomBlueColor : UIDeviceRGBColorSpace 0.16 0.34 1 1
 47: textFieldAtomPurpleColor : UIDeviceRGBColorSpace 0.41 0 0.74 1
 48: tableCellBlueTextColor : UIDeviceRGBColorSpace 0.22 0.33 0.53 1
 49: infoTextOverPinStripeTextColor : UIDeviceRGBColorSpace 0.3 0.34 0.42 1
 50: tableCellGroupedBackgroundColorLegacyWhite : (null)
 51: colorWithHue:saturation:brightness:alpha: : (null)
 52: colorWithCIColor: : (null)
 53: _systemColorForColor:withName: : (null)
 54: tableCellPlainBackgroundColor : UIDeviceRGBColorSpace 1 1 1 1
 55: tableSelectionColor : UIDeviceRGBColorSpace 0.16 0.43 0.83 1
 56: tableSelectionGradientStartColor : UIDeviceRGBColorSpace 0.02 0.55 0.96 1
 57: tableSelectionGradientEndColor : UIDeviceRGBColorSpace 0.04 0.37 0.91 1
 58: tableGroupedTopShadowColor : UIDeviceRGBColorSpace 0 0 0 0.08
 59: sectionListBorderColor : UIDeviceRGBColorSpace 0.52 0.56 0.58 0.8
 60: sectionHeaderBackgroundColor : UIDeviceRGBColorSpace 0.9 0.93 0.99 0.8
 61: sectionHeaderOpaqueBackgroundColor : UIDeviceRGBColorSpace 0.92 0.94 0.99 1
 62: sectionHeaderBorderColor : UIDeviceRGBColorSpace 0.85 0.87 0.91 1
 63: tableCellValue1BlueColor : UIDeviceRGBColorSpace 0.22 0.33 0.53 1
 64: tableCellValue2BlueColor : UIDeviceRGBColorSpace 0.32 0.4 0.57 1
 65: tableCellGrayTextColor : UIDeviceRGBColorSpace 0.5 0.5 0.5 1
 66: greenColor : UIDeviceRGBColorSpace 0 1 0 1
 67: redColor : UIDeviceRGBColorSpace 1 0 0 1
 68: colorWithPatternImage: : (null)
 69: colorWithCGColor: : (null)
 70: initialize : (null)
 71: tableCellGroupedBackgroundColor : UIDeviceRGBColorSpace 0.97 0.97 0.97 1
 72: tableSeparatorDarkColor : UIDeviceRGBColorSpace 0.67 0.67 0.67 1
 73: tableShadowColor : UIDeviceRGBColorSpace 1 1 1 0.91
 74: blackColor : UIDeviceWhiteColorSpace 0 1
 75: whiteColor : UIDeviceWhiteColorSpace 1 1
 76: clearColor : UIDeviceWhiteColorSpace 0 0
 77: darkGrayColor : UIDeviceWhiteColorSpace 0.333333 1
 78: lightGrayColor : UIDeviceWhiteColorSpace 0.666667 1
 79: grayColor : UIDeviceWhiteColorSpace 0.5 1
 80: colorWithRed:green:blue:alpha: : (null)
 81: colorWithWhite:alpha: : (null)
*/
