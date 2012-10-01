//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (FTUIDeviceEx)

+ (NSData *)ft_WiFiMACAddressData;
+ (NSString *)ft_WiFiMACAddressString;

+(NSString*) ft_platform;
+(NSString*) ft_platformString;

@end
