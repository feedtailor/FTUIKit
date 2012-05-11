//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTUIActionSheet+Block.h"
#import "FTUIVew+UserInfo.h"
#import <objc/runtime.h>

@interface FTUIActionSheetDelegate : NSObject <UIActionSheetDelegate>
@end

@implementation FTUIActionSheetDelegate

- (void)dealloc
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSMutableDictionary *map = [actionSheet ft_userInfo];
	
	void (^block)() = [map objectForKey:[NSNumber numberWithInteger:buttonIndex]];
	if(block) {
		block();
	}
}

//- (void)actionSheetCancel:(UIActionSheet *)actionSheet
//{
//}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	if(actionSheet.ft_willPresentBlock) {
		actionSheet.ft_willPresentBlock(actionSheet);
	}
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if(actionSheet.ft_didPresentBlock) {
		actionSheet.ft_didPresentBlock(actionSheet);
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(actionSheet.ft_willDismissBlock) {
		actionSheet.ft_willDismissBlock(actionSheet, buttonIndex);
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(actionSheet.ft_didDismissBlock) {
		actionSheet.ft_didDismissBlock(actionSheet, buttonIndex);
	}

	[actionSheet ft_clearUserInfo];
}

@end

#pragma mark - 

@implementation UIActionSheet (FTUIActionSheetBlock)

+ (id)ft_actionSheetWithTitle:(NSString *)title
{
	FTUIActionSheetDelegate *delegate = [[FTUIActionSheetDelegate alloc] init];

	UIActionSheet *shhet = [[UIActionSheet alloc] initWithTitle:title
													   delegate:delegate
											  cancelButtonTitle:nil
										 destructiveButtonTitle:nil
											  otherButtonTitles:nil];

	static char delegateKey;
	objc_setAssociatedObject(shhet, &delegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	return shhet;
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

- (NSInteger)ft_setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())block
{
	NSInteger index = [self ft_addButtonWithTitle:title handler:block];
	self.destructiveButtonIndex = index;

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

- (void)setFt_willPresentBlock:(void (^)(UIActionSheet *))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_willPresentBlockKey];
	} else {
		[map removeObjectForKey:ft_willPresentBlockKey];
	}
}

- (void (^)(UIActionSheet *))ft_willPresentBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_willPresentBlockKey];
}

#pragma mark - 

- (void)setFt_didPresentBlock:(void (^)(UIActionSheet *))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_didPresentBlockKey];
	} else {
		[map removeObjectForKey:ft_didPresentBlockKey];
	}
}

- (void (^)(UIActionSheet *))ft_didPresentBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_didPresentBlockKey];
}

#pragma mark - 

- (void)setFt_willDismissBlock:(void (^)(UIActionSheet *, NSInteger))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_willDismissBlockKey];
	} else {
		[map removeObjectForKey:ft_willDismissBlockKey];
	}
}

- (void (^)(UIActionSheet *, NSInteger))ft_willDismissBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_willDismissBlockKey];
}

#pragma mark - 

- (void)setFt_didDismissBlock:(void (^)(UIActionSheet *, NSInteger))block
{
	NSMutableDictionary *map = [self ft_userInfo];
	if(block) {
		[map setObject:[block copy] forKey:ft_didDismissBlockKey];
	} else {
		[map removeObjectForKey:ft_didDismissBlockKey];
	}
}

- (void (^)(UIActionSheet *, NSInteger))ft_didDismissBlock
{
	NSMutableDictionary *map = [self ft_userInfo];
	return [map objectForKey:ft_didDismissBlockKey];
}

@end
