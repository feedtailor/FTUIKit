//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTTableViewCell.h"


@implementation FTTableViewCell

@synthesize content;

-(id) initWithContentViewClass:(Class)_class reuseIdentifier:(NSString *)reuseIdentifier
{
	if (![_class isSubclassOfClass:[FTTableContentView class]]) {
		return nil;
	}
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		content = [[_class alloc] initWithFrame:self.bounds];
		[self.contentView addSubview:content];
		content.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		content.parentCell = self;
    }
    return self;	
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
	
	content.highlighted = selected;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
	content.highlighted = highlighted;
}

- (void)dealloc {
}


@end
