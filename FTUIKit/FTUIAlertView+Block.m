//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTUIAlertView+Block.h"
#import "FTUIVew+UserInfo.h"
#import <objc/runtime.h>

@interface FTUIAlertViewDelegate : NSObject <UIAlertViewDelegate>
@end

@implementation FTUIAlertViewDelegate

- (void)dealloc
{
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSMutableDictionary *map = [alertView ft_userInfo];
	
	void (^block)() = [map objectForKey:[NSNumber numberWithInteger:buttonIndex]];
	if(block) {
		block();
	}
}

//- (void)alertViewCancel:(UIAlertView *)alertView
//{
//}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
	if(alertView.ft_willPresentBlock) {
		alertView.ft_willPresentBlock(alertView);
	}
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
	if(alertView.ft_didPresentBlock) {
		alertView.ft_didPresentBlock(alertView);
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.ft_willDismissBlock) {
		alertView.ft_willDismissBlock(alertView, buttonIndex);
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.ft_didDismissBlock) {
		alertView.ft_didDismissBlock(alertView, buttonIndex);
	}

	[alertView ft_clearUserInfo];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	if(alertView.ft_shouldEnableFirstOtherButtonBlock) {
		return alertView.ft_shouldEnableFirstOtherButtonBlock(alertView);
	}

	return YES;
}

@end

#pragma mark -

@implementation UIAlertView (FTUIAlertViewBlock)

+ (id)ft_alertViewWithTitle:(NSString *)title
{
	return [self ft_alertViewWithTitle:title message:nil];
}

+ (id)ft_alertViewWithTitle:(NSString *)title message:(NSString *)message
{
	FTUIAlertViewDelegate *delegate = [[FTUIAlertViewDelegate alloc] init];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:nil
										  otherButtonTitles:nil];

	static char delegateKey;
	objc_setAssociatedObject(alert, &delegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	return alert;
}

- (NSInteger)ft_addButtonWithTitle:(NSString *)title handler:(void (^)())block;
{
	NSInteger index = [self addButtonWithTitle:title];

	NSMutableDictionary *map = [self ft_userInfo];
	NSNumber *number = [NSNumber numberWithInteger:index];
	if(block) {
		[map setObject:[block copy] forKey:number];
	} else {
		[map setObject:[^{} copy] forKey:number];
	}

	return index;
}

- (NSInteger)ft_setCancelButtonWithTitle:(NSString *)title handler:(void (^)())block
{
	NSInteger index = [self ft_addButtonWithTitle:title handler:block];
	self.cancelButtonIndex = index;

	return index;
}

#pragma mark -

static NSString *const ft_willPresentBlockKey = @"willPresent";
static NSString *const ft_didPresentBlockKey = @"didPresent";
static NSString *const ft_willDismissBlockKey = @"willDismiss";
static NSString *const ft_didDismissBlockKey = @"didDismiss";
static NSString *const ft_shouldEnableFirstOtherButtonKey = @"shouldEnableFirstOtherButton";

- (void)setFt_willPresentBlock:(void (^)(UIAlertView *))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_willPresentBlockKey];
	} else {
		[map removeObjectForKey:ft_willPresentBlockKey];
	}
}

- (void (^)(UIAlertView *))ft_willPresentBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_willPresentBlockKey];
}

#pragma mark - 

- (void)setFt_didPresentBlock:(void (^)(UIAlertView *))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_didPresentBlockKey];
	} else {
		[map removeObjectForKey:ft_didPresentBlockKey];
	}
}

- (void (^)(UIAlertView *))ft_didPresentBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_didPresentBlockKey];
}

#pragma mark - 

- (void)setFt_willDismissBlock:(void (^)(UIAlertView *, NSInteger))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_willDismissBlockKey];
	} else {
		[map removeObjectForKey:ft_willDismissBlockKey];
	}
}

- (void (^)(UIAlertView *, NSInteger))ft_willDismissBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_willDismissBlockKey];
}

#pragma mark - 

- (void)setFt_didDismissBlock:(void (^)(UIAlertView *, NSInteger))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_didDismissBlockKey];
	} else {
		[map removeObjectForKey:ft_didDismissBlockKey];
	}
}

- (void (^)(UIAlertView *, NSInteger))ft_didDismissBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_didDismissBlockKey];
}

#pragma mark - 

- (void)setFt_shouldEnableFirstOtherButtonBlock:(BOOL (^)(UIAlertView *))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_shouldEnableFirstOtherButtonKey];
	} else {
		[map removeObjectForKey:ft_shouldEnableFirstOtherButtonKey];
	}
}

- (BOOL (^)(UIAlertView *))ft_shouldEnableFirstOtherButtonBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_shouldEnableFirstOtherButtonKey];
}

@end
