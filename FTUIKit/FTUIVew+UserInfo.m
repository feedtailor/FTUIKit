//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTUIVew+UserInfo.h"
#import <objc/runtime.h>

@implementation UIView (FTUIVewUserInfo)

static char sUserInfoKey;

- (NSMutableDictionary *)ft_userInfo
{
	NSMutableDictionary *userInfo = (NSMutableDictionary *)objc_getAssociatedObject(self, &sUserInfoKey);
	if(!userInfo) {
		userInfo = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, &sUserInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return userInfo;
}

- (void)ft_clearUserInfo
{
	objc_setAssociatedObject(self, &sUserInfoKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
