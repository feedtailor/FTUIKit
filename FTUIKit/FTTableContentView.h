//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTTableContentView : UIView {
	BOOL highlighted;
	NSObject* object;
	
	__weak UITableViewCell* parentCell;
}

@property (nonatomic) BOOL highlighted;
@property (nonatomic, retain) NSObject* object;
@property (nonatomic, weak) UITableViewCell* parentCell;

+(float) rowHeightWithObject:(NSObject*)object;

@end
