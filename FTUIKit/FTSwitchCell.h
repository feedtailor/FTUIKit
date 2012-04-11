//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTSwitchCell : UITableViewCell;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly) UISwitch *switchControl;

@end
