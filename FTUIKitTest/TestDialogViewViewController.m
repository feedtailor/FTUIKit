//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "TestDialogViewViewController.h"
#import "FTDialogView.h"

@implementation TestDialogViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showDialog:(id)sender 
{
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicator startAnimating];
	FTDialogView* dialog = [[FTDialogView alloc] initWithTitle:@"タイトル" contentView:indicator buttonTitle:@"ボタン1" shouldAutorotateToInterfaceOrientationBlock:^BOOL(UIInterfaceOrientation orientation) {
		return YES;
	}];
	[dialog show];
	[dialog setDidClickButtonBlock:^{
		NSLog(@"button clicked");
	}];
}

- (IBAction)showDialog2:(id)sender 
{
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicator startAnimating];
	FTDialogView* dialog = [[FTDialogView alloc] initWithTitle:@"タイトル" contentView:indicator button0Title:@"ボタン1" button1Title:@"ボタン2" shouldAutorotateToInterfaceOrientationBlock:^BOOL(UIInterfaceOrientation ori) {
		return YES;
	}];
	[dialog show];
	[dialog setDidClickWithIndexButtonBlock:^(NSInteger idx) {
		NSLog(@"button %d clicked", idx + 1);
	}];
}

- (IBAction)showDialog3:(id)sender 
{
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicator startAnimating];
	FTDialogView* dialog = [[FTDialogView alloc] initWithTitle:@"タイトルB" contentView:indicator buttonTitle:@"ボタン1" rotateDelegate:self];
	[dialog show];
	[dialog setDidClickButtonBlock:^{
		NSLog(@"button clicked");
	}];
}

- (IBAction)showDialog4:(id)sender 
{
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicator startAnimating];
	FTDialogView* dialog = [[FTDialogView alloc] initWithTitle:@"タイトルB" contentView:indicator button0Title:@"ボタン1" button1Title:@"ボタン2" rotateDelegate:self];
	[dialog show];
	[dialog setDidClickWithIndexButtonBlock:^(NSInteger idx) {
		NSLog(@"button %d clicked", idx + 1);
	}];
}

@end
