//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (FTUIToolbarUtilities)

- (UIBarButtonItem *)ft_itemWithTag:(NSInteger)tag;

@end

@interface UIViewController (FTUIToolbarUtilities)

- (UIBarButtonItem *)ft_toolbarItemWithTag:(NSInteger)tag;

@end
