//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "FTDialogView.h"

@interface FTActivityIndicatorDialogView : FTDialogView

- (id)initWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle rotateDelegate:(id)rotateDelegate;

- (id)initWithTitle:(NSString *)aTitle
	   button0Title:(NSString *)aButton0Title
	   button1Title:(NSString *)aButton1Title
	 rotateDelegate:(id)rotateDelegate;

@end
