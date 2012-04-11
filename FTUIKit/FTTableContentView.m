//
//  Copyright 2010 feedtailor Inc. All rights reserved.
//

#import "FTTableContentView.h"


@implementation FTTableContentView

@synthesize highlighted, object, parentCell;

-(void) dealloc
{
}

-(void) setHighlighted:(BOOL)value
{
	if (highlighted != value) {
		highlighted = value;
		[self setNeedsDisplay];
	}
}

+(float) rowHeightWithObject:(NSObject*)object
{
	return 44;
}

@end
