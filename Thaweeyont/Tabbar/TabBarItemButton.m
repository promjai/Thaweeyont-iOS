//
//  TabBarItemButton.m
//  TabbarContoller
//
//  Created by Pariwat Promjai on 12/2/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "TabBarItemButton.h"

@implementation TabBarItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
- (void)presentStanbyState {

    [self setImage:self.stanbyImage forState:UIControlStateNormal];
    [self setImage:self.stanbyImage forState:UIControlStateHighlighted];
    [self setImage:self.highlightedImage forState:UIControlStateDisabled];
    
}

- (void)presentHighlightedState {

    [self setImage:self.highlightedImage forState:UIControlStateNormal];
    [self setImage:self.highlightedImage forState:UIControlStateHighlighted];
    [self setImage:self.stanbyImage forState:UIControlStateDisabled];
    
}

@end
