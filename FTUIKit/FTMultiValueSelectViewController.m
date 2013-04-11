//
//  Copyright (c) 2013 feedtailor Inc. All rights reserved.
//

#import "FTMultiValueSelectViewController.h"
#import "FTUIColor+Ex.h"

NSString * const FTMultiValueSelectTableViewStyleKey = @"FTMultiValueSelectTableViewStyleKey";
NSString * const FTMultiValueSelectTableViewBackgroundColorKey = @"FTMultiValueSelectTableViewBackgroundColorKey";

@interface FTMultiValueSelectViewController ()
@end

@implementation FTMultiValueSelectViewController
{
	NSOrderedSet *_itemTitles;
	NSOrderedSet *_itemValues;
	id _currentValue;
	UIColor *_tableBackgroundColor;
}

- (id)initWithTitle:(NSString *)title
		 itemTitles:(NSOrderedSet *)itemTitles
		 itemValues:(NSOrderedSet *)itemValues
	   currentValue:(id)currentValue
			options:(NSDictionary *)options
{
	UITableViewStyle style = UITableViewStylePlain;
	NSNumber *styleObject = options[FTMultiValueSelectTableViewStyleKey];
	if (styleObject) {
		style = [styleObject integerValue];
	}

	self = [super initWithStyle:style];
	if (self) {
		NSAssert(itemTitles.count == itemValues.count, @"Number of titles and values must be same.");
		NSAssert([itemValues containsObject:currentValue], @"itemValues must contain currentValue.");

		self.title = NSLocalizedString(title, nil);

		_itemTitles = itemTitles;
		_itemValues = itemValues;
		_currentValue = currentValue;

		_tableBackgroundColor = options[FTMultiValueSelectTableViewBackgroundColorKey];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	if (_tableBackgroundColor) {
		UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
		v.backgroundColor = _tableBackgroundColor;
		self.tableView.backgroundView = v;
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _itemValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * const cellIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

	cell.textLabel.text = NSLocalizedString(_itemTitles[indexPath.row], nil);
	NSObject *value = _itemValues[indexPath.row];

	if ([value isEqual:_currentValue]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor ft_tableCellValue1BlueColor];
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}

	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSUInteger oldIndex = [_itemValues indexOfObject:_currentValue];
	if (oldIndex == indexPath.row) {
		return;
	}

	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	newCell.accessoryType = UITableViewCellAccessoryCheckmark;
	newCell.textLabel.textColor = [UIColor ft_tableCellValue1BlueColor];

	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:0];
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	oldCell.accessoryType = UITableViewCellAccessoryNone;
	oldCell.textLabel.textColor = [UIColor blackColor];

	id newValue = _itemValues[indexPath.row];
	_currentValue = newValue;

	if (_completionBlock) {
		_completionBlock(newValue);
	}
}

@end
