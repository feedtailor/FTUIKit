//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTActivityIndicatorDialogView.h"

@implementation FTActivityIndicatorDialogView

- (id)initWithTitle:(NSString *)aTitle
	   button0Title:(NSString *)aButton0Title
	   button1Title:(NSString *)aButton1Title
	 rotateDelegate:(id)rotateDelegate
{
	UIActivityIndicatorView *indicator =
	[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
    self = [super initWithTitle:aTitle contentView:indicator button0Title:aButton0Title button1Title:aButton1Title rotateDelegate:rotateDelegate];
    if(self) {
		[indicator startAnimating];
    }
	
    return self;
}

- (id)initWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rotateDelegate:(id)rotateDelegate
{
    return [self initWithTitle:title button0Title:buttonTitle button1Title:nil rotateDelegate:rotateDelegate];
}

@end
