//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTBackgroundTaskManager : NSObject 
{
	int taskCount;
	UIBackgroundTaskIdentifier bgTask;
}

+(FTBackgroundTaskManager*) sharedManager;
+(BOOL) isMultitaskingSupported;

-(void) beginTask;
-(void) endTask;

@end
