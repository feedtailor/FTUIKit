//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FTFeedback.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
{
	NSArray *viewControllerNames;
}

- (void)setupMenu
{
	viewControllerNames = [NSArray arrayWithObjects:
						   @"TestDialogViewViewController",
						   @"TestCalendarViewViewController",
						   nil];
}

- (id)init
{
	self = [super initWithStyle:UITableViewStylePlain];
	if(self) {
		self.title = @"Main Menu";
		
		UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStyleBordered target:nil action:nil];
		self.navigationItem.backBarButtonItem = backBarButtonItem;
		[self setupMenu];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (section == 0) ? [viewControllerNames count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = [UIFont smallSystemFontSize];
	}

	cell.textLabel.text = (indexPath.section == 0) ? [viewControllerNames objectAtIndex:indexPath.row] : @"Feedback";
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        NSString *vcName = [viewControllerNames objectAtIndex:indexPath.row];
        Class class = NSClassFromString(vcName);
        UIViewController *vc = [[class alloc] initWithNibName:Nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [FTFeedback presentFeedback:[FTFeedback numberedToReceipantsWithPrefix:@"test" domain:@"example.com"] body:@"test" parentViewController:self];
    }
}

@end
