//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FT_HIRAKAKU_W3(__size__)	[UIFont ft_hiraKakuFontWithSize:(__size__)]
#define FT_HIRAKAKU_W6(__size__)	[UIFont ft_boldHiraKakuFontWithSize:(__size__)]
#define FT_HIRAMIN_W3(__size__)		[UIFont ft_hiraMinFontWithSize:(__size__)]
#define FT_HIRAMIN_W6(__size__)		[UIFont ft_boldHiraMinFontWithSize:(__size__)]


@interface UIFont (FTUIFontHiragino)

+(UIFont*) ft_hiraKakuFontWithSize:(CGFloat)size;
+(UIFont*) ft_boldHiraKakuFontWithSize:(CGFloat)size;

+(UIFont*) ft_hiraMinFontWithSize:(CGFloat)size;
+(UIFont*) ft_boldHiraMinFontWithSize:(CGFloat)size;

@end
