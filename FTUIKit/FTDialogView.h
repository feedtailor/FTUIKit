//
//  Copyright 2011 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTDialogViewDelegate;

@class FTDialogController;

@interface FTDialogView : UIView
{
@private
	__weak id <FTDialogViewDelegate> delegate;
	void (^didClickButtonBlock)();
	void (^didClickWithIndexButtonBlock)(NSInteger index);
	id userInfo;
	BOOL (^shouldAutorotateToInterfaceOrientationBlock)(UIInterfaceOrientation);

	NSString *title;
	UIView *contentView;
	NSString *button0Title;
	NSString *button1Title;

	UIImageView *backgroundImageView;
	UILabel *titleLabel;
	UIButton *button0;
	UIButton *button1;

	FTDialogController *dialogController;
}

// ダイアログウィンドウのレベル
+ (UIWindowLevel)dialogWindowLevel;
+ (void)setDialogWindowLevel:(UIWindowLevel)windowLevel;

// コンテンツビューの最大幅
// この幅を超えるとダイアログからはみ出す
+ (CGFloat)maximumContentViewWidth;

// shouldAutorotateToInterfaceOrientationBlockがnilの場合、
// UIInterfaceOrientationPortraitのみYESを返す挙動
// (UIViewController#shouldAutorotateToInterfaceOrientation: のデフォルトと同じ挙動)
- (id)initWithTitle:(NSString *)aTitle
		contentView:(UIView *)aContentView
		buttonTitle:(NSString *)aButtonTitle
shouldAutorotateToInterfaceOrientationBlock:(BOOL (^)(UIInterfaceOrientation))shouldAutorotateToInterfaceOrientationBlock;

- (id)initWithTitle:(NSString *)aTitle
		contentView:(UIView *)aContentView
	   button0Title:(NSString *)aButton0Title
	   button1Title:(NSString *)aButton1Title
shouldAutorotateToInterfaceOrientationBlock:(BOOL (^)(UIInterfaceOrientation))shouldAutorotateToInterfaceOrientationBlock;

// rotateDelegate
//   - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//   を実装しているオブジェクト。回転決定時に[rotateDelegate shouldAutorotateToInterfaceOrientation:] が呼出される。
// rotateDelegateがnilの場合
// UIInterfaceOrientationPortraitのみYESを返す挙動
// (UIViewController#shouldAutorotateToInterfaceOrientation: のデフォルトと同じ挙動)

- (id)initWithTitle:(NSString *)aTitle
		contentView:(UIView *)aContentView
		buttonTitle:(NSString *)aButtonTitle
	 rotateDelegate:(id)rotateDelegate;

- (id)initWithTitle:(NSString *)aTitle
		contentView:(UIView *)aContentView
	   button0Title:(NSString *)aButton0Title
	   button1Title:(NSString *)aButton1Title
	 rotateDelegate:(id)rotateDelegate;

// 表示できない場合はNOを返す
// (現時点では、DTDialogViewは1度に1枚しか表示できないため、2枚同時に表示しようとした場合にNOが返される)
- (BOOL)show;

- (void)dismissAnimated:(BOOL)animated;

// delegate,didClickButtonBlockの双方が指定されている場合、didClickButtonBlockだけが呼ばれる
@property (nonatomic, weak) id <FTDialogViewDelegate> delegate;
@property (nonatomic, copy) void (^didClickButtonBlock)();
@property (nonatomic, copy) void (^didClickWithIndexButtonBlock)(NSInteger index);

// 任意のオブジェクトを設定可能
@property (nonatomic, retain) id userInfo;

@property (nonatomic, readonly) UIView *contentView;

@end

@protocol FTDialogViewDelegate <NSObject>
@required
- (void)dialogViewDidClickButton:(FTDialogView *)dialogView;
@end