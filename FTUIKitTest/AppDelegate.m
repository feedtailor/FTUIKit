//
//  Copyright (c) 2012年 feedtailor Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

	MainMenuViewController *vc = [[MainMenuViewController alloc] init];
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
	self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
