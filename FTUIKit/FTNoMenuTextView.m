//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTNoMenuTextView.h"


@implementation FTNoMenuTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender 
{
	if (action == @selector(paste:) || action == @selector(cut:) || action == @selector(copy:) || action == @selector(select:) || action == @selector(selectAll:)) {
		[UIMenuController sharedMenuController].menuVisible = NO;
		return NO;
	}
    return [super canPerformAction:action withSender:sender];
}

-(BOOL) canBecomeFirstResponder
{
	return NO;
}

@end
