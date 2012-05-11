//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (FTUIAlertViewBlock)

// 以下のメソッドで生成したインスタンスのみブロック対応になる。
// 生成したインスタンスのdelageteプロパティを再設定してはならない。
+ (id)ft_alertViewWithTitle:(NSString *)title;
+ (id)ft_alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (NSInteger)ft_addButtonWithTitle:(NSString *)title handler:(void (^)())block;
- (NSInteger)ft_setCancelButtonWithTitle:(NSString *)title handler:(void (^)())block;

@property (nonatomic, copy) void (^ft_willPresentBlock)(UIAlertView *);
@property (nonatomic, copy) void (^ft_didPresentBlock)(UIAlertView *);
@property (nonatomic, copy) void (^ft_willDismissBlock)(UIAlertView *, NSInteger);
@property (nonatomic, copy) void (^ft_didDismissBlock)(UIAlertView *, NSInteger);
@property (nonatomic, copy) BOOL (^ft_shouldEnableFirstOtherButtonBlock)(UIAlertView *);

@end
