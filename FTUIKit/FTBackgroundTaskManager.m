//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTBackgroundTaskManager.h"

static FTBackgroundTaskManager* s_self = nil;

@implementation FTBackgroundTaskManager

+(FTBackgroundTaskManager*) sharedManager
{
	if (!s_self) {
		s_self = [[FTBackgroundTaskManager alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:s_self selector:@selector(terminate:) name:UIApplicationWillTerminateNotification object:nil];
	}
	return s_self;	
}

+(BOOL) isMultitaskingSupported
{
	UIDevice* device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) {
		return YES;
	}
	return NO;
}

-(id) init
{
	if (self = [super init]) {
		taskCount = 0;
		
		if ([FTBackgroundTaskManager isMultitaskingSupported]) {
			NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
			[center addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
			[center addObserver:self selector:@selector(enterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
			bgTask = UIBackgroundTaskInvalid;
		}
	}
	return self;
}

-(void) dealloc
{
	if ([FTBackgroundTaskManager isMultitaskingSupported]) {
		NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
		[center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
		[center removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	}
}

-(void) beginTask
{
	@synchronized (self) {
		taskCount ++;
	}
}

-(void) endTask
{
	@synchronized (self) {
		taskCount --;
		if (taskCount < 0) {
			taskCount = 0;
		}
	}
}

-(void) enterForeground:(NSNotification*)notification
{
	bgTask = UIBackgroundTaskInvalid;
}

- (void)enterBackground:(NSNotification*)notification
{
	@synchronized (self) {
		if (taskCount == 0) {
			return;
		}
	}
	
	NSLog(@"enterBackground");
	UIApplication* application = [UIApplication sharedApplication];
	
    // Request permission to run in the background. Provide an
    // expiration handler in case the task runs long.
    NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
	
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Synchronize the cleanup call on the main thread in case
        // the task actually finishes at around the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
				NSLog(@"end task");
				
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
	
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSLog(@"enter other task");
		
        // Do the work associated with the task.
		while (1) {
			@synchronized (self) {
				if (taskCount <= 0) {
					break;
				}
			}
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
		}
		
        // Synchronize the cleanup call on the main thread in case
        // the expiration handler is fired at the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
				NSLog(@"end task");
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

-(void) terminate:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:s_self name:UIApplicationWillTerminateNotification object:nil];

	s_self = nil;
}

@end
