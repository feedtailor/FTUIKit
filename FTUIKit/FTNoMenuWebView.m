//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTNoMenuWebView.h"

@implementation FTNoMenuWebView

@synthesize noMenu;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender 
{
	if(!noMenu) {
		return [super canPerformAction:action withSender:sender];
	}
	
	if (action == @selector(paste:) || action == @selector(cut:) || action == @selector(copy:) || action == @selector(select:) || action == @selector(selectAll:)) {
		[UIMenuController sharedMenuController].menuVisible = NO;
		return NO;
	}
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder
{
	if(!noMenu) {
		return [super canBecomeFirstResponder];
	}
	
	return NO;
}

@end
