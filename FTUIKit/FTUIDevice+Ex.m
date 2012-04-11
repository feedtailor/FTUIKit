//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUIDevice+Ex.h"

#include <ifaddrs.h>
#include <net/if_dl.h>
#include <sys/socket.h>

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

@end
