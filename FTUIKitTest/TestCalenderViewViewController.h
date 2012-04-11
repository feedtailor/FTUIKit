//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCalenderView.h"

@interface TestCalenderViewViewController : UIViewController <FTCalenderViewDataSource, FTCalenderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *calenderContainerView;

- (IBAction)today:(id)sender;
- (IBAction)prevMonth:(id)sender;
- (IBAction)nextMonth:(id)sender;
- (IBAction)prevYear:(id)sender;
- (IBAction)nextYear:(id)sender;

@end
