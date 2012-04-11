//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTSwitchCell.h"


@implementation FTSwitchCell

- (void)commonInit
{
	UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
	self.accessoryView = switchControl;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if(self) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	
	if(self) {
		[self commonInit];
	}
	
	return self;
}

- (void)dealloc
{
}

- (UISwitch *)switchControl
{
	return (UISwitch *)self.accessoryView;
}

@end
