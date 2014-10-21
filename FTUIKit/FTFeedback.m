//
//  FTFeedback.m
//  FTUIKit
//
//  Created by itok on 2013/02/27.
//  Copyright (c) 2013年 feedtailor inc. All rights reserved.
//

#import "FTFeedback.h"
#import "FTUIDevice+Ex.h"

#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>

@interface FTFeedbackDelegate : NSObject <MFMailComposeViewControllerDelegate>

@end

@implementation FTFeedback

+(void) presentFeedback:(NSArray*)to body:(NSString*)body parentViewController:(UIViewController*)controller
{
    if (!controller) {
        controller = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    NSAssert(controller, @"");
    
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please check E-mail setting", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    FTFeedbackDelegate* delegate = [[FTFeedbackDelegate alloc] init];
    
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString* appname = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString* appver = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString* osver = [[UIDevice currentDevice] systemVersion];
    NSString* devname = [UIDevice ft_platformString];
    
    MFMailComposeViewController* ctl = [[MFMailComposeViewController alloc] init];
    [ctl setSubject:[NSString stringWithFormat:@"%@ Feedback", appname]];
    NSMutableString* bodyStr = [NSMutableString string];
    if (body) {
        [bodyStr appendString:body];
    }
    [bodyStr appendString:@"\n\n-------------\n"];
    [bodyStr appendFormat:@"Name: %@\nVersion: %@\nDevice: %@\niOS: %@", appname, appver, devname, osver];
    [ctl setMessageBody:bodyStr isHTML:NO];
    [ctl setToRecipients:to];
    
    [ctl setMailComposeDelegate:delegate];
    static char delegateKey;
	objc_setAssociatedObject(ctl, &delegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    ctl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [controller presentViewController:ctl animated:YES completion:nil];
}

+(NSArray*) numberedToReceipantsWithPrefix:(NSString*)prefix domain:(NSString*)domain
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* addr = [NSString stringWithFormat:@"%@+%@@%@", prefix, [formatter stringFromDate:[NSDate date]], domain];
    return @[addr];
}

@end

@implementation FTFeedbackDelegate

-(void) dealloc
{
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
