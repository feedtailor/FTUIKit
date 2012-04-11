//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "MainMenuViewController.h"

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
						   @"TestCalenderViewViewController",
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [viewControllerNames count];;
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

	cell.textLabel.text = [viewControllerNames objectAtIndex:indexPath.row];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSString *vcName = [viewControllerNames objectAtIndex:indexPath.row];
	Class class = NSClassFromString(vcName);
	UIViewController *vc = [[class alloc] initWithNibName:Nil bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
