//
//  Copyright (c) 2013 feedtailor Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTMultiValueSelectViewController : UITableViewController

@property (nonatomic, copy) void (^completionBlock)(id selectedValue);

- (id)initWithTitle:(NSString *)title
		 itemTitles:(NSOrderedSet *)itemTitles
		 itemValues:(NSOrderedSet *)itemValues
	   currentValue:(id)currentValue
			options:(NSDictionary *)options;

@end

// options key

extern NSString * const FTMultiValueSelectTableViewStyleKey;			// NSNumber(UITableViewStyle). default:UITableViewStylePlain
extern NSString * const FTMultiValueSelectTableViewBackgroundColorKey;
