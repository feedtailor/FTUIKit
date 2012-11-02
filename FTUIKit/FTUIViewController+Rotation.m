//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTUIViewController+Rotation.h"

@implementation UIViewController (FTUIViewControllerRotation)

- (NSUInteger)ft_supportedInterfaceOrientationsFromShouldAutorotateToInterfaceOrientation
{
	static const UIInterfaceOrientation interfaceOrientations[] = {
		UIInterfaceOrientationPortrait,
		UIInterfaceOrientationPortraitUpsideDown,
		UIInterfaceOrientationLandscapeLeft,
		UIInterfaceOrientationLandscapeRight,
	};

	static const UIInterfaceOrientationMask interfaceOrientationMasks[] = {
		UIInterfaceOrientationMaskPortrait,
		UIInterfaceOrientationMaskPortraitUpsideDown,
		UIInterfaceOrientationMaskLandscapeLeft,
		UIInterfaceOrientationMaskLandscapeRight,
	};

	const int count = sizeof(interfaceOrientations) / sizeof(interfaceOrientations[0]);
	NSUInteger mask = 0;

	for(int i = 0; i < count; i++) {
		if([self shouldAutorotateToInterfaceOrientation:interfaceOrientations[i]]) {
			mask |= interfaceOrientationMasks[i];
		}
	}

	return mask;
}

@end
