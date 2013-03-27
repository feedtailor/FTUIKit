//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCalendarView.h"

@interface TestCalendarViewViewController : UIViewController <FTCalendarViewDataSource, FTCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *calendarContainerView;

- (IBAction)today:(id)sender;
- (IBAction)prevMonth:(id)sender;
- (IBAction)nextMonth:(id)sender;
- (IBAction)prevYear:(id)sender;
- (IBAction)nextYear:(id)sender;

@end
