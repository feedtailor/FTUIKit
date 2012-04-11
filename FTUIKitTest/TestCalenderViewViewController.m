//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "TestCalenderViewViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TestCalenderCell : FTCalenderViewCell
{
}

@property (nonatomic, readonly) UILabel *label;

@end

@implementation TestCalenderCell

@synthesize label = label_;

- (id)initWithIdentifier:(NSString *)identifier
{
	self = [super initWithIdentifier:identifier];
	if(self) {
		label_ = [[UILabel alloc] initWithFrame:CGRectZero];
		label_.font = [UIFont boldSystemFontOfSize:14];
		label_.textAlignment = UITextAlignmentCenter;
		label_.textColor = [UIColor whiteColor];
		label_.highlightedTextColor = [UIColor redColor];
		label_.numberOfLines = 0;		
		[self.contentView addSubview:label_];
	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	label_.frame = self.contentView.bounds;
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];

	label_.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	
	if(selected) {
		label_.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
		label_.layer.borderWidth = 4;
	} else {
		label_.layer.borderWidth = 0;
	}
}

@end

#pragma mark -

@interface TestCalenderViewViewController ()

@end

@implementation TestCalenderViewViewController
{
	__weak FTCalenderView *calenderView_;
}

@synthesize calenderContainerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {
		self.title = @"Calender";
	}
	return self;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	FTCalenderView *calenderView = [[FTCalenderView alloc] initWithFrame:CGRectZero];
	[self.calenderContainerView addSubview:calenderView];
	calenderView_ = calenderView;

	//calenderView_.startWeekday = 2; // 月曜始まり
	calenderView_.currentDate = [NSDate date];
	calenderView_.dataSource = self;
	calenderView_.delegate = self;
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	calenderView_.frame = self.calenderContainerView.bounds;
}

#pragma mark -

- (void)calenderView:(FTCalenderView *)calenderView didSelectCell:(FTCalenderViewCell *)cell
{
	NSLog(@"%@", cell.date);
	cell.selected = !cell.selected;
}

- (FTCalenderViewCell *)calenderView:(FTCalenderView *)calenderView cellForDate:(NSDate *)date
{
	static NSString *cellIdentifier = @"Cell";

	TestCalenderCell *cell = [calenderView_ dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[TestCalenderCell alloc] initWithIdentifier:cellIdentifier];
	}
	
	static int color = 0;
	color++;
	
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yy/MM/dd.EEEEE"];

	});

	cell.label.text = [dateFormatter stringFromDate:date];
	if([calenderView_ currentMonthContainsDate:date]) {
		cell.label.textColor = [UIColor whiteColor];
		
		NSDateComponents *weekDayComponents = [calenderView_.calendar components:NSWeekdayCalendarUnit fromDate:date];
		if([weekDayComponents weekday] == 1) {
			cell.label.backgroundColor = [UIColor colorWithHue:0 saturation:0.8 brightness:0.8 alpha:1];
		} else if([weekDayComponents weekday] == 7) {
			cell.label.backgroundColor = [UIColor colorWithHue:0.66 saturation:0.8 brightness:0.8 alpha:1];
		} else {
			if(color % 2) {
				cell.label.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1];
			} else {
				cell.label.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.3 alpha:1];
			}
		}
	} else {
		cell.label.textColor = [UIColor lightGrayColor];
		cell.label.backgroundColor = [UIColor grayColor];
	}

	cell.selected = NO;
	
	return cell;
}

- (IBAction)today:(id)sender
{
	[calenderView_ setCurrentDate:[NSDate date]];
	[calenderView_ reloadData];

	FTCalenderViewCell * cell = [calenderView_ cellForDate:[NSDate date]];
	cell.selected = YES;
}

- (IBAction)prevMonth:(id)sender
{
	[calenderView_ offsetMonth:-1];
	[calenderView_ reloadData];
}

- (IBAction)nextMonth:(id)sender
{
	[calenderView_ offsetMonth:1];
	[calenderView_ reloadData];
}

- (IBAction)prevYear:(id)sender
{
	[calenderView_ offsetMonth:-12];
	[calenderView_ reloadData];
}

- (IBAction)nextYear:(id)sender
{
	[calenderView_ offsetMonth:+12];
	[calenderView_ reloadData];
}

@end
