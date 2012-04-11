//
//  Copyright 2009 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTTextFieldCell : UITableViewCell 

@property (nonatomic, readonly) UITextField *textField;

// textFieldの左端のX座標 (self.contentViewの左端が基準)
// self.textLabel.textが空の場合この値は無視され、TextFieldがcell一杯にレイアウトされる
@property (nonatomic, assign) CGFloat textFieldMinX;

// UITableViewCellStyleDefault で初期化する
// initWithStyle:reuseIdentifier: は使用不可
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
