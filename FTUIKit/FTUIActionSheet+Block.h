//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (FTUIActionSheetBlock)

// 以下のメソッドで生成したインスタンスのみブロック対応になる。
// 生成したインスタンスのdelageteプロパティを再設定してはならない。
+ (id)ft_actionSheetWithTitle:(NSString *)title;

- (NSInteger)ft_addButtonWithTitle:(NSString *)title handler:(void (^)())block;
- (NSInteger)ft_setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())block;
- (NSInteger)ft_setCancelButtonWithTitle:(NSString *)title handler:(void (^)())block;

@property (nonatomic, copy) void (^ft_willPresentBlock)(UIActionSheet *);
@property (nonatomic, copy) void (^ft_didPresentBlock)(UIActionSheet *);
@property (nonatomic, copy) void (^ft_willDismissBlock)(UIActionSheet *, NSInteger);
@property (nonatomic, copy) void (^ft_didDismissBlock)(UIActionSheet *, NSInteger);

@end
