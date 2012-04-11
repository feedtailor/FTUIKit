//
//  Copyright 2009 feedtailor Inc. All rights reserved.
//

#import "FTTextFieldCell.h"

//#define __FT_TEXTFIELDCELL_DEBUG__

#if defined (__FT_TEXTFIELDCELL_DEBUG__)
#import <QuartzCore/QuartzCore.h>
#endif

static const CGFloat kDefaultTextFieldLeft = 115;
static const CGFloat kCellHorizontalEdgeMargin = 10;
static const CGFloat kLabelAndTextFieldSpacing = 5;

@implementation FTTextFieldCell
{
	UITextField *textField_;
	CGFloat textFieldMinX_;
}

@synthesize textField = textField_;
@synthesize textFieldMinX = textFieldMinX_;

- (void)commonInit
{
	textFieldMinX_ = kDefaultTextFieldLeft;
	
	textField_ = [[UITextField alloc] initWithFrame:CGRectZero];
	textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.contentView addSubview:textField_];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	NSException *exception = [NSException exceptionWithName:@"exception"
													 reason:@"not supported"
												   userInfo:nil];
	@throw exception;
	
	return nil;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if(self) {
		[self commonInit];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if(CGRectIsEmpty(self.textLabel.frame)) {
		CGRect textFieldFrame;
		textFieldFrame.origin.x = kCellHorizontalEdgeMargin;
		textFieldFrame.origin.y = 0;
		textFieldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - kCellHorizontalEdgeMargin * 2;
		textFieldFrame.size.height = CGRectGetHeight(self.contentView.bounds);
		textField_.frame = textFieldFrame;
	} else {
		CGRect textFieldFrame;
		textFieldFrame.origin.x = textFieldMinX_;
		textFieldFrame.origin.y = 0;
		textFieldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - textFieldMinX_ - kCellHorizontalEdgeMargin;
		textFieldFrame.size.height = CGRectGetHeight(self.contentView.bounds);
		textField_.frame = textFieldFrame;
		
		CGRect labelFrame = self.textLabel.frame;
		labelFrame.size.width = textFieldMinX_ - CGRectGetMinX(self.textLabel.frame) - kLabelAndTextFieldSpacing;
		self.textLabel.frame = labelFrame;
	}
	
#if defined (__FT_TEXTFIELDCELL_DEBUG__)
	self.layer.borderColor = [UIColor redColor].CGColor;
	self.layer.borderWidth = 1;
	
	self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
	self.contentView.layer.borderWidth = 1;
	
	self.textField.layer.borderColor = [UIColor blueColor].CGColor;
	self.textField.layer.borderWidth = 1;
	
	self.textLabel.layer.borderColor = [UIColor purpleColor].CGColor;
	self.textLabel.layer.borderWidth = 1;
#endif
}

- (void)setTextFieldMinX:(CGFloat)newTextFieldMinX
{
	textFieldMinX_ = newTextFieldMinX;
	[self setNeedsLayout];
}

@end
