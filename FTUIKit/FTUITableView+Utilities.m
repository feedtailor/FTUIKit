//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTUITableView+Utilities.h"

@implementation UITableView (FTUITableViewUtilities)

- (NSIndexPath *)ft_indexPathForSubview:(UIView *)subviewOfTableView
{
	CGPoint viewOrigin = [self convertPoint:CGPointZero fromView:subviewOfTableView];
	NSIndexPath *indexPath = [self indexPathForRowAtPoint:viewOrigin];
	return indexPath;
}

@end