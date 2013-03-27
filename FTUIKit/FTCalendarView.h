//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FTCalendarViewSelectionType) {
    FTCalendarViewSelectionTypeSingle = 0,
    FTCalendarViewSelectionTypeMultiple
};

@protocol FTCalendarViewDataSource;
@protocol FTCalendarViewDelegate;

@class FTCalendarViewCell;

#pragma mark -

@interface FTCalendarView : UIView

@property (nonatomic, readonly) NSCalendar *calendar;	// gregorianCalendar
@property (nonatomic, assign) NSInteger startWeekday;	// 1..7. 1 = sunday (default)
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) FTCalendarViewSelectionType selectionType;

@property (nonatomic, weak) id <FTCalendarViewDataSource> dataSource;
@property (nonatomic, weak) id <FTCalendarViewDelegate> delegate;

- (BOOL)currentMonthContainsDate:(NSDate *)date;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


- (FTCalendarViewCell *)cellForDate:(NSDate *)date;
- (void)offsetMonth:(NSInteger)offsetMonth;

- (CGRect)frameForCellAtColumn:(int)column row:(int)row;

- (void)reloadData;

@end

#pragma mark -

@protocol FTCalendarViewDataSource <NSObject>
@required
- (FTCalendarViewCell *)calendarView:(FTCalendarView *)calendarView cellForDate:(NSDate *)date;
@end

@protocol FTCalendarViewDelegate <NSObject>
@optional
- (void)calendarView:(FTCalendarView *)calendarView didSelectCell:(FTCalendarViewCell *)cell;
@end


#pragma mark -

@interface FTCalendarViewCell : UIView

- (id)initWithIdentifier:(NSString *)identifier;

- (void)setHighlighted:(BOOL)highlighted;

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly, strong) NSDate *date;
@property (nonatomic, readonly, weak) FTCalendarView *calendarView;

- (void)prepareForReuse;
@end
