//
//  FTFeedback.h
//  FTUIKit
//
//  Created by itok on 2013/02/27.
//  Copyright (c) 2013年 feedtailor inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTFeedback : NSObject

+(void) presentFeedback:(NSArray*)to body:(NSString*)body parentViewController:(UIViewController*)controller;

// prefix+[日時文字列]@domain というメールアドレスが生成される
+(NSArray*) numberedToReceipantsWithPrefix:(NSString*)prefix domain:(NSString*)domain;

@end
