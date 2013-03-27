//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FTCalendarViewSelectionType) {
    FTCalendarViewSelectionTypeSingle = 0,
    FTCalendarViewSelectionTypeMultiple
};

@protocol FTCalenderViewDataSource;
@protocol FTCalenderViewDelegate;

@class FTCalenderViewCell;

#pragma mark -

@interface FTCalenderView : UIView

@property (nonatomic, readonly) NSCalendar *calendar;	// gregorianCalendar
@property (nonatomic, assign) NSInteger startWeekday;	// 1..7. 1 = sunday (default)
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) FTCalendarViewSelectionType selectionType;

@property (nonatomic, weak) id <FTCalenderViewDataSource> dataSource;
@property (nonatomic, weak) id <FTCalenderViewDelegate> delegate;

- (BOOL)currentMonthContainsDate:(NSDate *)date;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


- (FTCalenderViewCell *)cellForDate:(NSDate *)date;
- (void)offsetMonth:(NSInteger)offsetMonth;

- (CGRect)frameForCellAtColumn:(int)column row:(int)row;

- (void)reloadData;

@end

#pragma mark -

@protocol FTCalenderViewDataSource <NSObject>
@required
- (FTCalenderViewCell *)calenderView:(FTCalenderView *)calenderView cellForDate:(NSDate *)date;
@end

@protocol FTCalenderViewDelegate <NSObject>
@optional
- (void)calenderView:(FTCalenderView *)calenderView didSelectCell:(FTCalenderViewCell *)cell;
@end


#pragma mark -

@interface FTCalenderViewCell : UIView

- (id)initWithIdentifier:(NSString *)identifier;

- (void)setHighlighted:(BOOL)highlighted;

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly, strong) NSDate *date;
@property (nonatomic, readonly, weak) FTCalenderView *calenderView;

@end
