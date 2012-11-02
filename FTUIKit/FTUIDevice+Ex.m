//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUIDevice+Ex.h"

#include <ifaddrs.h>
#include <net/if_dl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (FTUIDeviceEx)

#pragma mark - MAC Address

// iPhone MAC-Address (WiFi-Address) ??? (programatically !!)
// https://devforums.apple.com/message/1366

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

#define SEARCH_INTERFACE_NAME	"en0"

+ (NSData *)ft_WiFiMACAddressData
{
	BOOL success;
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	const struct sockaddr_dl *dlAddr;
	const uint8_t *base;
	
	NSData *macAddressData = nil;
	
	success = getifaddrs(&addrs) == 0;
	
	if(success) {
		cursor = addrs;
		while(cursor != NULL) {
			if(!strncmp(cursor->ifa_name, SEARCH_INTERFACE_NAME, strlen(SEARCH_INTERFACE_NAME))) {
				if((cursor->ifa_addr->sa_family == AF_LINK) &&
				   (((const struct sockaddr_dl *)cursor->ifa_addr)->sdl_type == IFT_ETHER)) {
					
					dlAddr = (const struct sockaddr_dl *)cursor->ifa_addr;
					
					base = (const uint8_t *)&dlAddr->sdl_data[dlAddr->sdl_nlen];
					macAddressData = [NSData dataWithBytes:base length:dlAddr->sdl_alen];
					break;
				}
			}
			cursor = cursor->ifa_next;
		}
		
		freeifaddrs(addrs);
	}
	
	return macAddressData;
}

+ (NSString *)ft_WiFiMACAddressString
{
	NSData *data = [self ft_WiFiMACAddressData];
	if(!data || ![data length]) {
		return nil;
	}
	
	NSMutableString *textBuffer = [NSMutableString stringWithCapacity:[data length] * 3 - 1];
	const unsigned char *bytes = [data bytes];
	for(int i = 0; i < [data length]; i++) {
		[textBuffer appendFormat:@"%02x", bytes[i]];
		if(i != [data length] - 1) {
			[textBuffer appendString:@":"];
		}
	}
	return textBuffer;
}

// http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
+(NSString*) ft_platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+(NSString*) ft_platformString
{
    NSString *platform = [self ft_platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}	
	

@end
