//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTUIFont+Hiragino.h"

@implementation UIFont (FTUIFontHiragino)

+(UIFont*) ft_hiraKakuFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HiraKakuProN-W3" size:size];
}

+(UIFont*) ft_boldHiraKakuFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HiraKakuProN-W6" size:size];	
}

+(UIFont*) ft_hiraMinFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HiraMinProN-W3" size:size];
}

+(UIFont*) ft_boldHiraMinFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"HiraMinProN-W6" size:size];	
}

@end
