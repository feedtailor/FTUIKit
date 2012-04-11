//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "CAAnimationFactory.h"


@implementation CAAnimationFactory

+(CAAnimation*) popAnimation
{
    NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                       [NSNumber numberWithFloat:1.1],
                       [NSNumber numberWithFloat:0.9],
                       [NSNumber numberWithFloat:1.0], nil];
	
    NSArray *keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.5],
                         [NSNumber numberWithFloat:0.75],
                         [NSNumber numberWithFloat:1.0], nil];
	
    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
	
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    popAnimation.values = values;
	popAnimation.duration = 0.4;
    popAnimation.keyTimes = keyTimes;
    popAnimation.timingFunctions = timingFunctions;
    popAnimation.removedOnCompletion = YES;
    popAnimation.calculationMode = kCAAnimationLinear;	
	
	return popAnimation;
}

@end
