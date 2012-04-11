//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTTableContentView.h"

@interface FTTableViewCell : UITableViewCell {
	FTTableContentView* content;
}

@property (nonatomic, retain, readonly) FTTableContentView* content;

-(id) initWithContentViewClass:(Class)_class reuseIdentifier:(NSString *)reuseIdentifier;

@end
