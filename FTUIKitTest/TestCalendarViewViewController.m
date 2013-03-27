//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "TestCalendarViewViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TestCalendarCell : FTCalendarViewCell
{
}

@property (nonatomic, readonly) UILabel *label;

@end

@implementation TestCalendarCell

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

@interface TestCalendarViewViewController ()

@end

@implementation TestCalendarViewViewController
{
	__weak FTCalendarView *calendarView_;
}

@synthesize calendarContainerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self) {
		self.title = @"Calendar";
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

	FTCalendarView *calendarView = [[FTCalendarView alloc] initWithFrame:CGRectZero];
	[self.calendarContainerView addSubview:calendarView];
	calendarView_ = calendarView;

	//calendarView_.startWeekday = 2; // 月曜始まり
	calendarView_.currentDate = [NSDate date];
	calendarView_.dataSource = self;
	calendarView_.delegate = self;
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	calendarView_.frame = self.calendarContainerView.bounds;
}

#pragma mark -

- (void)calendarView:(FTCalendarView *)calendarView didSelectCell:(FTCalendarViewCell *)cell
{
	NSLog(@"%@", cell.date);
	cell.selected = !cell.selected;
}

- (FTCalendarViewCell *)calendarView:(FTCalendarView *)calendarView cellForDate:(NSDate *)date
{
	static NSString *cellIdentifier = @"Cell";

	TestCalendarCell *cell = [calendarView_ dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[TestCalendarCell alloc] initWithIdentifier:cellIdentifier];
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
	if([calendarView_ currentMonthContainsDate:date]) {
		cell.label.textColor = [UIColor whiteColor];
		
		NSDateComponents *weekDayComponents = [calendarView_.calendar components:NSWeekdayCalendarUnit fromDate:date];
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
	[calendarView_ setCurrentDate:[NSDate date]];
	[calendarView_ reloadData];

	FTCalendarViewCell * cell = [calendarView_ cellForDate:[NSDate date]];
	cell.selected = YES;
}

- (IBAction)prevMonth:(id)sender
{
	[calendarView_ offsetMonth:-1];
	[calendarView_ reloadData];
}

- (IBAction)nextMonth:(id)sender
{
	[calendarView_ offsetMonth:1];
	[calendarView_ reloadData];
}

- (IBAction)prevYear:(id)sender
{
	[calendarView_ offsetMonth:-12];
	[calendarView_ reloadData];
}

- (IBAction)nextYear:(id)sender
{
	[calendarView_ offsetMonth:+12];
	[calendarView_ reloadData];
}

@end
