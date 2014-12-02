//
//  ScrollView.m
//  FighterPedia
//
//  Created by CS561 on 08/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScrollView.h"


@implementation ScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.nextResponder touchesBegan:touches withEvent:event];
}
@end
