//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUIToolbar+Utilities.h"

@implementation UIToolbar (FTUIToolbarUtilities)

- (UIBarButtonItem *)ft_itemWithTag:(NSInteger)tag
{
	UIBarButtonItem *item;
	for(UIBarButtonItem *tempItem in self.items) {
		if(tempItem.tag == tag) {
			item = tempItem;
			break;
		}
	}
	
	return item;
}

@end

@implementation UIViewController (FTUIToolbarUtilities)

- (UIBarButtonItem *)ft_toolbarItemWithTag:(NSInteger)tag
{
	UIBarButtonItem *item;
	for(UIBarButtonItem *tempItem in self.toolbarItems) {
		if(tempItem.tag == tag) {
			item = tempItem;
			break;
		}
	}

	return item;
}

@end
