//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTCalenderView.h"

// note
// iPhoneの標準カレンダーは
// 全体幅320
// 46px * 6 + 44px
// 46pxのセルのうち右2pxは仕切り線になっている

#pragma mark -

@interface FTCalenderViewCell ()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) FTCalenderView *calenderView;
@end

@interface FTCalenderView ()
- (void)handleCellTap:(FTCalenderViewCell *)cell;
@end

@implementation FTCalenderViewCell
{
@private
	UIView *contentView_;
}

@synthesize identifier = identifier_;
@synthesize contentView = contentView_;
@synthesize calenderView = calenderView_;
@synthesize date = date_;

@synthesize selected = selected_;
@synthesize highlighted = highlighted_;

- (id)initWithIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:CGRectZero];
	if(self) {
		identifier_ = identifier;
		contentView_ = [[UIView alloc] initWithFrame:CGRectZero];
		contentView_.backgroundColor = [UIColor whiteColor];
		[self addSubview:contentView_];
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	contentView_.frame = self.bounds;
}

- (void)setHighlighted:(BOOL)highlighted
{
	highlighted_ = highlighted;
}

- (void)setSelected:(BOOL)selected
{
	selected_ = selected;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.highlighted = YES;
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch = [touches anyObject];
	CGPoint point = [theTouch locationInView:self.superview];
	if(CGRectContainsPoint(self.frame, point)) {
		[calenderView_ handleCellTap:self];
	}

	self.highlighted = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.highlighted = NO;
}

@end

#pragma mark -

@implementation FTCalenderView
{
@private
	NSCalendar *gregorianCalendar_;
	NSDate *firstDay_;	// cache

	NSMutableDictionary *cellQueue_;
}

@synthesize calendar = gregorianCalendar_;

@synthesize currentDate = currentDate_;
@synthesize startWeekday = startWeekday_;
@synthesize dataSource = dataSource_;
@synthesize delegate = delegate_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
		self.backgroundColor = [UIColor whiteColor];
		gregorianCalendar_=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

		self.startWeekday = 1;

		NSDate *now = [NSDate date];
		self.currentDate = now;

		cellQueue_ = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
	currentDate_ = currentDate;
	NSDateComponents *ymComponents = [gregorianCalendar_ components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:currentDate];

	NSDateComponents *firstDayComponents = [[NSDateComponents alloc] init];
	[firstDayComponents setYear:[ymComponents year]];
	[firstDayComponents setMonth:[ymComponents month]];
	[firstDayComponents setDay:1];

	firstDay_ = [gregorianCalendar_ dateFromComponents:firstDayComponents];
}

- (void)setStartWeekday:(NSInteger)startWeekday
{
	NSParameterAssert(1 <= startWeekday && startWeekday < 7);

	startWeekday_ = startWeekday;
}

- (BOOL)currentMonthContainsDate:(NSDate *)date
{
	NSDateComponents *ymComponentsCurrentDate = [gregorianCalendar_ components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:currentDate_];
	NSDateComponents *ymComponents = [gregorianCalendar_ components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];

	
	if([ymComponentsCurrentDate year] == [ymComponents year] &&
	   [ymComponentsCurrentDate month] == [ymComponents month]) {
		return YES;
	}

	return NO;
}

- (void)offsetMonth:(NSInteger)offsetMonth
{
	NSDateComponents *offsetomponent = [[NSDateComponents alloc] init];
	[offsetomponent setMonth:offsetMonth];
	NSDate *date = [gregorianCalendar_ dateByAddingComponents:offsetomponent toDate:firstDay_ options:0];
	[self setCurrentDate:date];
}

- (void)reloadData
{
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

#pragma mark - layout

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
	NSMutableSet *set = [cellQueue_ objectForKey:identifier];
	id cell = [set anyObject];
	if(cell) {
		[set removeObject:cell];
	}

	return cell;
}

- (FTCalenderViewCell *)cellForDate:(NSDate *)date
{
	NSDateComponents *components = [gregorianCalendar_ components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
														 fromDate:date];
	for(FTCalenderViewCell *cell in self.subviews) {
		NSDateComponents *cellComponents = [gregorianCalendar_ components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
																 fromDate:cell.date];
		if([components year] == [cellComponents year] &&
		   [components month] == [cellComponents month] &&
		   [components day] == [cellComponents day]) {
			return cell;
		}
	}
	
	return nil;
}

- (FTCalenderViewCell *)cellFromDelegateForDate:(NSDate *)date
{
	if(dataSource_) {
		return [dataSource_ calenderView:self cellForDate:date];
	}

	return nil;
}

- (CGRect)frameForCellAtColumn:(int)column	// x
						   row:(int)row		// y
{
	NSParameterAssert(0 <= column && column <= 6);
	NSParameterAssert(0 <= row && row <= 5);

	CGRect bounds = self.bounds;
	CGSize cellSize;
	cellSize.width = ceilf(bounds.size.width / 7.0f);
	cellSize.height = ceilf(bounds.size.height / 6.0f);

	CGRect cellFrame;
	cellFrame.origin.x = cellSize.width * column;
	cellFrame.origin.y = cellSize.height * row;
	cellFrame.size = cellSize;
	if(column == 6) {
		cellFrame.size.width = bounds.size.width - cellFrame.origin.x;
	}
	if(row == 5) {
		cellFrame.size.height = bounds.size.height - cellFrame.origin.y;
	}

	return cellFrame;
}

- (NSDate *)topLeftDate
{
	NSDateComponents *firstDayWeekDayComponents = [gregorianCalendar_ components:NSWeekdayCalendarUnit fromDate:firstDay_];
	
	NSDateComponents *firstCellOffsetDayComponent = [[NSDateComponents alloc] init];
	[firstCellOffsetDayComponent setDay:-(([firstDayWeekDayComponents weekday] + 7 - startWeekday_) % 7)];
	
	NSDate *date = [gregorianCalendar_ dateByAddingComponents:firstCellOffsetDayComponent toDate:firstDay_ options:0];
	return date;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	for(FTCalenderViewCell *cell in self.subviews) {
		[cell removeFromSuperview];
		NSMutableSet *set = [cellQueue_ objectForKey:cell.identifier];
		if(!set) {
			set = [NSMutableSet set];
			[cellQueue_ setObject:set forKey:cell.identifier];
		}
		[set addObject:cell];
	}

	NSDate *currentDate = [self topLeftDate];

	NSDateComponents *nextDayOffsetComponents = [[NSDateComponents alloc] init];
	[nextDayOffsetComponents setDay:1];

	for(int y = 0; y < 6; y++) {
		for(int x = 0; x < 7; x++) {			
			CGRect cellFrame = [self frameForCellAtColumn:x row:y];

			FTCalenderViewCell *cell = [self cellFromDelegateForDate:currentDate];
			NSParameterAssert(cell);

			cell.frame = cellFrame;
			cell.date = currentDate;
			cell.calenderView = self;

			[self addSubview:cell];

			cell.date = currentDate;

			currentDate = [gregorianCalendar_ dateByAddingComponents:nextDayOffsetComponents
															  toDate:currentDate
															 options:0];
		}
	}
}

- (void)handleCellTap:(FTCalenderViewCell *)cell
{
	if([delegate_ respondsToSelector:@selector(calenderView:didSelectCell:)]) {
		[delegate_ calenderView:self didSelectCell:cell];
	}
}

@end
