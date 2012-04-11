//
//  Copyright 2011 feedtailor Inc. All rights reserved.
//

#import "FTDialogView.h"
#import "CAAnimationFactory.h"

static const CGFloat kAlertWidth = 284;
static const CGFloat kAlertMinimumHeight = 62;

static const CGFloat kAlertTopMargin = 15;
static const CGFloat kAlertBottomMargin = 16;
static const CGFloat kContentViewTopMargin = 10;
static const CGFloat kButtonTopMargin = 13;

static const CGFloat kButtonWidth = 262;  // and other views
static const CGFloat kButtonHeigth = 43;
static const CGFloat kButtonHorizontalMargin = 11;

static const CGFloat kLabelWidth = 260;
//static const CGFloat kLabelHeight = 23;
static const CGFloat kLabelMargin = 12;

static const CGFloat kContentViewWidth = 260;

static const int kAlertViewTag = 32123;
static const NSTimeInterval kAnimationShowFadeDuration = 0.4;
static const NSTimeInterval kAnimationHideFadeDuration = 0.2;
static const NSTimeInterval kAnimationPopDuration = 0.425;

#pragma mark FTAlertController

@interface FTDialogRootView : UIView
@end

@implementation FTDialogRootView

- (void)dealloc
{
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	FTDialogView *dialogView = (FTDialogView *)[self viewWithTag:kAlertViewTag];
	dialogView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	CGRect frame = dialogView.frame;
	frame.origin.x = floorf(frame.origin.x);
	frame.origin.y = floorf(frame.origin.y);
	dialogView.frame = frame;

#if 0
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor greenColor].CGColor;
#endif
}

@end

@interface FTDialogController : NSObject
{
	BOOL (^shouldAutorotateToInterfaceOrientationBlock)(UIInterfaceOrientation);
	UIView *view;
}

@property (nonatomic, copy) BOOL (^shouldAutorotateToInterfaceOrientationBlock)(UIInterfaceOrientation);
@property (nonatomic, retain) UIView *view;

- (void)loadView;
- (void)layoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)layoutInitialPosition;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation FTDialogController

@synthesize shouldAutorotateToInterfaceOrientationBlock;
@synthesize view;

- (id)init
{
	self = [super init];
	if(self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillChangeStatusBarOrientationNotification:)
													 name:UIApplicationWillChangeStatusBarOrientationNotification
												   object:nil];
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.shouldAutorotateToInterfaceOrientationBlock = nil;
	self.view = nil;
}

- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification
{
	NSNumber *newInterfaceOrientationNumber = [[notification userInfo] objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
	UIInterfaceOrientation newInterfaceOrientation = [newInterfaceOrientationNumber intValue];

	if([self shouldAutorotateToInterfaceOrientation:newInterfaceOrientation]) {
		[self layoutToInterfaceOrientation:newInterfaceOrientation];
	}
}

- (void)loadView
{
	[self.view removeFromSuperview];
	self.view = nil;
	self.view = [[FTDialogRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];

	self.view.backgroundColor = nil;
	self.view.opaque = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(shouldAutorotateToInterfaceOrientationBlock) {
		return shouldAutorotateToInterfaceOrientationBlock(interfaceOrientation);
	}

	if(interfaceOrientation == UIInterfaceOrientationPortrait) {
		return YES;
	}

	return NO;
}

- (void)layoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	CGRect screenFrame = self.view.window.bounds;
	self.view.transform = CGAffineTransformIdentity;
	self.view.frame = screenFrame;

	float angle = 0;
	CGRect bounds = CGRectZero;
	switch(interfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			bounds.size.width = screenFrame.size.width;
			bounds.size.height = screenFrame.size.height;
			angle = 0;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			bounds.size.width = screenFrame.size.width;
			bounds.size.height = screenFrame.size.height;
			angle = M_PI;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			bounds.size.width = screenFrame.size.height;
			bounds.size.height = screenFrame.size.width;
			angle = M_PI_2 * 3;
			break;
		case UIInterfaceOrientationLandscapeRight:
			bounds.size.width = screenFrame.size.height;
			bounds.size.height = screenFrame.size.width;
			angle = M_PI_2;
			break;
		default:
			break;
	}

	self.view.bounds = bounds;
	self.view.transform = CGAffineTransformMakeRotation(angle);	

	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (void)layoutInitialPosition
{
	UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	UIInterfaceOrientation interfaceOrientation;
	if([self shouldAutorotateToInterfaceOrientation:currentInterfaceOrientation] == NO) {
		interfaceOrientation = UIInterfaceOrientationPortrait;
	} else {
		interfaceOrientation = currentInterfaceOrientation;
	}

	[self layoutToInterfaceOrientation:interfaceOrientation];
}

@end

#pragma mark - FTAlert

@interface FTDialogView ()
+ (void)didReceiveMemoryWarningNotification:(NSNotification *)notification;
+ (UIFont *)largeFont;
+ (UIFont *)normalFont;
+ (UIImage *)buttonImage;
+ (UIImage *)backgroundImage;
+ (UIWindow *)alertWindow;
@end

@implementation FTDialogView

@synthesize delegate;
@synthesize didClickButtonBlock;
@synthesize didClickWithIndexButtonBlock;
@synthesize userInfo;
@synthesize contentView;

static UIWindow *sAlertWindow = nil;
static UIImage *sButtonImage = nil;
static UIImage *sBackgrountImage = nil;
static UIWindowLevel sWindowLevel;

#pragma mark - class method

+ (void)initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveMemoryWarningNotification:)
												 name:UIApplicationDidReceiveMemoryWarningNotification
											   object:nil];

	sWindowLevel = UIWindowLevelStatusBar + 1;
}

+ (void)didReceiveMemoryWarningNotification:(NSNotification *)notification
{
	sButtonImage = nil;
	sBackgrountImage = nil;
}

+ (UIFont *)largeFont
{
	return [UIFont boldSystemFontOfSize:18];
}

+ (UIFont *)normalFont
{
	return [UIFont systemFontOfSize:16];
}

+ (UIWindowLevel)dialogWindowLevel
{
	return sWindowLevel;
}

+ (void)setDialogWindowLevel:(UIWindowLevel)windowLevel
{
	sWindowLevel = windowLevel;
}

+ (CGFloat)maximumContentViewWidth
{
	return kContentViewWidth;
}

+ (UIImage *)buttonImage
{
	if(sButtonImage) {
		return sButtonImage;
	}

	CGSize size = CGSizeMake(15, 43);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	CGContextSaveGState(context);
	
	UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, 42) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
	[roundPath addClip];
	
	[[UIColor colorWithWhite:1 alpha:0.25] set];
	CGContextFillRect(context, CGRectMake(0, 1, size.width, 1));
	
	CGFloat colors[] = {1.0, 169.0/255.0, 1.0, 99.0/255.0};
	CGGradientRef upperGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGPoint gradientStartPoint = CGPointMake(0, 0);
	CGPoint gradientEndPoint = CGPointMake(0, 21);
	CGContextDrawLinearGradient(context, upperGradient, gradientStartPoint, gradientEndPoint, 0);
	CGGradientRelease(upperGradient);
	
	CGFloat colors2[] = {1.0, 59.0/255.0, 1.0, 83.0/255.0};
	CGGradientRef lowerGradient = CGGradientCreateWithColorComponents(colorSpace, colors2, NULL, 2);
	gradientStartPoint = CGPointMake(0, 21);
	gradientEndPoint = CGPointMake(0, 42);
	CGContextDrawLinearGradient(context, lowerGradient, gradientStartPoint, gradientEndPoint, 0);
	CGGradientRelease(lowerGradient);
	
	CGColorSpaceRelease(colorSpace);
	
	CGContextRestoreGState(context);
	
	UIBezierPath *roundPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0+0.5, 0+0.5, size.width-1, 42) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
	[[UIColor colorWithWhite:0 alpha:0.4] set];
	[roundPath2 stroke];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2)+1 topCapHeight:0];
	sButtonImage = image;
	return sButtonImage;
}

+ (UIImage *)backgroundImage
{
	if(sBackgrountImage) {
		return sBackgrountImage;
	}
	
	CGSize size = CGSizeMake(284, 62);
	CGFloat w = 276;
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect panelRect = CGRectMake(4, 1, w, 52);
	CGContextSaveGState(context);
	{
		panelRect = CGRectInset(panelRect, 1, 1);
		UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:panelRect
														byRoundingCorners:UIRectCornerAllCorners
															  cornerRadii:CGSizeMake(10, 10)];
		[[UIColor colorWithRed:0 green:19.0/255.0 blue:69.0/255.0 alpha:204.0/255.0] set];
		CGContextSetShadowWithColor(context, CGSizeMake(0, 5), 6, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
		CGContextAddPath(context, roundPath.CGPath);
		CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:191.0/255.0 green:196.0/255.0 blue:208.0/255.0 alpha:0.9].CGColor);
		CGContextSetLineWidth(context, 2.5);
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFillStroke);
	}
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	{
		CGContextBeginPath(context);
		UIBezierPath *roundPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(panelRect, -1.5, -1.5) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
		CGContextAddPath(context, roundPath2.CGPath);
		CGContextClosePath(context);
		
		CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.2].CGColor);
		CGContextSetLineWidth(context, 1);
		CGContextDrawPath(context, kCGPathStroke);
	}	
	CGContextRestoreGState(context);
	
	UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(panelRect, 1, 0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(11, 11)];
	[clipPath addClip];
	
	CGRect ovalRect = panelRect;
	ovalRect.size.height = 30-3;
	ovalRect.origin.y -= ovalRect.size.height;
	ovalRect.size.height *= 2;
	ovalRect = CGRectInset(ovalRect, -64, 0);
	UIBezierPath *roundClipPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
	[roundClipPath addClip];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGFloat colors[] = {1.0, 103.0/255.0, 1.0, 30.0/255.0};
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGPoint gradientStartPoint = CGPointMake(0, 3);
	CGPoint gradientEndPoint = CGPointMake(0, 30);
	CGContextDrawLinearGradient(context, grayScaleGradient, gradientStartPoint, gradientEndPoint, 0);
	CGGradientRelease(grayScaleGradient);
	
	CGColorSpaceRelease(colorSpace);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:32];
	sBackgrountImage = image;
	return sBackgrountImage;
}

+ (UIWindow *)alertWindow
{
	if(!sAlertWindow) {
		sAlertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		sAlertWindow.opaque = NO;
		sAlertWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
	}

	return sAlertWindow;
}

#pragma mark - private

- (void)dealloc
{
}

- (void)buttonClicked:(id)sender
{
	NSInteger buttonIndex;
	if(sender == button0) {
		buttonIndex = 0;
	} else {
		buttonIndex = 1;
	}

	if(didClickWithIndexButtonBlock) {
		didClickWithIndexButtonBlock(buttonIndex);
	}
	
	if(didClickButtonBlock) {
		didClickButtonBlock();
	}
	
	if(delegate) {
		if([delegate respondsToSelector:@selector(dialogViewDidClickButton:)]) {
			[delegate dialogViewDidClickButton:self];
		}
	}

	[self dismissAnimated:YES];
}

- (void)showAnimated
{
	UIWindow *window = [[self class] alertWindow];
	window.hidden = NO;
	window.alpha = 0;
	
	[UIView animateWithDuration:kAnimationShowFadeDuration delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 window.alpha = 1;
					 }
					 completion:nil];
	
	CAAnimation *popAnimation = [CAAnimationFactory popAnimation];
	popAnimation.duration = kAnimationPopDuration;
	[self.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark - public

- (id)initWithTitle:(NSString *)aTitle contentView:(UIView *)aContentView
	   button0Title:(NSString *)aButton0Title
	   button1Title:(NSString *)aButton1Title
shouldAutorotateToInterfaceOrientationBlock:(BOOL (^)(UIInterfaceOrientation))aShouldAutorotateToInterfaceOrientationBlock
{
	if(!aContentView) {
		NSAssert(NO, @"contentView required.");
		return nil;
	}
	
	self = [super init];
	if(self) {
		self.tag = kAlertViewTag;
		
		shouldAutorotateToInterfaceOrientationBlock = [aShouldAutorotateToInterfaceOrientationBlock copy];
		title = [aTitle copy];
		contentView = aContentView;
		button0Title = [aButton0Title copy];
		
		if(aButton1Title) {
			button1Title = [aButton1Title copy];
		}
	}
	return self;
}

- (id)initWithTitle:(NSString *)aTitle
		contentView:(UIView *)aContentView
		buttonTitle:(NSString *)aButtonTitle
shouldAutorotateToInterfaceOrientationBlock:(BOOL (^)(UIInterfaceOrientation))aShouldAutorotateToInterfaceOrientationBlock
{
	return [self initWithTitle:aTitle
				   contentView:aContentView
				  button0Title:aButtonTitle
				  button1Title:nil
shouldAutorotateToInterfaceOrientationBlock:aShouldAutorotateToInterfaceOrientationBlock];
}

- (id)initWithTitle:(NSString *)aTitle contentView:(UIView *)aContentView button0Title:(NSString *)aButton0Title button1Title:(NSString *)aButton1Title rotateDelegate:(id)aRotateDelegate
{
	__weak id weakDelegate = aRotateDelegate;
	
	BOOL (^block)(UIInterfaceOrientation) = ^(UIInterfaceOrientation interfaceOrientation) {
		id rotateDelegate = weakDelegate;
		if(!rotateDelegate || ![rotateDelegate respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
			if(interfaceOrientation == UIInterfaceOrientationPortrait) {
				return YES;
			} else {
				return NO;
			}
		}
		
		return [rotateDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	};
	
	return [self initWithTitle:aTitle contentView:aContentView button0Title:aButton0Title button1Title:aButton1Title shouldAutorotateToInterfaceOrientationBlock:block];
}

- (id)initWithTitle:(NSString *)aTitle contentView:(UIView *)aContentView buttonTitle:(NSString *)aButtonTitle rotateDelegate:(id)rotateDelegate
{
	return [self initWithTitle:aTitle contentView:aContentView button0Title:aButtonTitle button1Title:nil rotateDelegate:rotateDelegate];
}

- (UIButton *)dialogButtonWithTitle:(NSString *)buttonTitle
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundImage:[[self class] buttonImage] forState:UIControlStateNormal];
	button.frame = CGRectMake(0, 0, kButtonWidth, kButtonHeigth);
	
	[button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	button.titleLabel.font = [[self class] largeFont];
	button.titleLabel.textAlignment = UITextAlignmentCenter;
	button.titleLabel.shadowOffset = CGSizeMake(0, -1);

	return button;
}

- (BOOL)show
{
	UIWindow *window = [[self class] alertWindow];
	if(window && window.hidden == NO) {
		NSAssert(YES, @"FTAlert can't show 2 or more.");
		return NO;
	}

	window.hidden = YES;

	NSAssert(!dialogController, @"!");
	dialogController = [[FTDialogController alloc] init];
	[dialogController loadView];
	[window addSubview:dialogController.view];

	dialogController.view.frame = window.bounds;
	dialogController.shouldAutorotateToInterfaceOrientationBlock = shouldAutorotateToInterfaceOrientationBlock;
	[dialogController layoutInitialPosition];

	window.windowLevel = [[self class] dialogWindowLevel];

	self.opaque = NO;


	if(title) {
		UILineBreakMode lineBreakMode = UILineBreakModeWordWrap;
		CGSize maxSize = CGSizeMake(kLabelWidth, FLT_MAX);
		UIFont *font = [[self class] largeFont];
		CGSize textSize = [title sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, kAlertTopMargin, kLabelWidth, textSize.height)];
		titleLabel.opaque = NO;
		titleLabel.backgroundColor = nil;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = font;
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.shadowColor = [UIColor blackColor];
		titleLabel.shadowOffset = CGSizeMake(0, -1);
		titleLabel.lineBreakMode = lineBreakMode;
		titleLabel.numberOfLines = 0;
		titleLabel.text = title;
	}

	if(button0Title) {
		button0 = [self dialogButtonWithTitle:button0Title];
	}

	if(button1Title) {
		button1 = [self dialogButtonWithTitle:button1Title];
	}

	CGRect frame = CGRectMake(0, 0, kAlertWidth, kAlertTopMargin);
	if(titleLabel) {
		frame.size.height += titleLabel.frame.size.height;
	}
	CGFloat contentViewTop = frame.size.height;
	if(contentView) {
		if(titleLabel) {
			frame.size.height += kContentViewTopMargin;
			contentViewTop += kContentViewTopMargin;
		}
		frame.size.height += contentView.frame.size.height;
	}

	if(button0) {
		frame.size.height += kButtonTopMargin + button0.frame.size.height;
		frame.size.height += kAlertBottomMargin;
	} else {
		frame.size.height += kAlertTopMargin + 10;
	}

	self.frame = frame;

	backgroundImageView = [[UIImageView alloc] initWithImage:[[self class] backgroundImage]];
	backgroundImageView.opaque = NO;
	backgroundImageView.frame = frame;
	[self addSubview:backgroundImageView];

	if(button0) {
		CGRect button0Frame = CGRectZero;
		CGRect button1Frame = CGRectZero;
		CGFloat buttonOriginY = CGRectGetMaxY(self.bounds) - CGRectGetHeight(button0.frame) - kAlertBottomMargin;
		CGFloat buttonAreaWidth = kAlertWidth - kButtonHorizontalMargin * 2;
	
		if(button0 && !button1) {
			button0Frame = button0.frame;
			button0Frame.origin.x = kButtonHorizontalMargin;
			button0Frame.origin.y = buttonOriginY;
			button0Frame.size.width = buttonAreaWidth;
		} else if(button0 && button1) {
			CGFloat buttonSpacing = 8;
			CGFloat buttonWidth = floorf((buttonAreaWidth - buttonSpacing) / 2);

			button0Frame = button0.frame;
			button0Frame.origin.x = kButtonHorizontalMargin;
			button0Frame.origin.y = buttonOriginY;
			button0Frame.size.width = buttonWidth;

			button1Frame = button1.frame;
			button1Frame.origin.x = kButtonHorizontalMargin + buttonWidth + buttonSpacing;
			button1Frame.origin.y = buttonOriginY;
			button1Frame.size.width = buttonWidth;
		}

		[self addSubview:button0];
		button0.frame = button0Frame;

		if(button1) {
			[self addSubview:button1];
			button1.frame = button1Frame;
		}
	}

	if(contentView) {
		CGRect contentViewFrame = contentView.frame;
		contentViewFrame.origin.x = floorf((self.bounds.size.width - contentViewFrame.size.width) / 2.0f);
		contentViewFrame.origin.y = contentViewTop;
		contentView.frame = contentViewFrame;
		[self addSubview:contentView];
	}

	if(titleLabel) {
		[self addSubview:titleLabel];
	}
	
	[dialogController.view addSubview:self];

	[self showAnimated];

	return YES;
}

- (void)dismissAnimated:(BOOL)animated
{
	self.didClickWithIndexButtonBlock = nil;
	self.didClickButtonBlock = nil;

	UIWindow *window = [[self class] alertWindow];

	void (^animationBlock)(void) = ^ {
		window.alpha = 0;
	};

	void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
		if(finished) {
			[self removeFromSuperview];
			[dialogController.view removeFromSuperview];
			dialogController = nil;
			window.hidden = YES;
		}
	};

	if(animated) {
		[UIView animateWithDuration:kAnimationHideFadeDuration delay:0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:animationBlock
						 completion:completionBlock];
	} else {
		animationBlock();
		completionBlock(YES);
	}
}

@end
