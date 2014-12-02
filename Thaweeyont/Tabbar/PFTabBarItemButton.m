//
//  PFTabBarItemButton.m
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFTabBarItemButton.h"

@implementation PFTabBarItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark -
- (void)presentStanbyState{
    [self setImage:self.stanbyImage forState:UIControlStateNormal];
    [self setImage:self.stanbyImage forState:UIControlStateHighlighted];
    [self setImage:self.highlightedImage forState:UIControlStateDisabled];
}

- (void)presentHighlightedState{
    [self setImage:self.highlightedImage forState:UIControlStateNormal];
    [self setImage:self.highlightedImage forState:UIControlStateHighlighted];
    [self setImage:self.stanbyImage forState:UIControlStateDisabled];
}

- (void)setBadge:(NSString *)badge{
    _badge = badge;
    [_customBadge removeFromSuperview];
    _customBadge = [PFCustomBadge customBadgeWithString:_badge
                                      withStringColor:[UIColor whiteColor]
                                       withInsetColor:[UIColor redColor]
                                       withBadgeFrame:YES
                                  withBadgeFrameColor:[UIColor whiteColor]
                                            withScale:1.0
                                          withShining:YES];
    [_customBadge setFrame:CGRectMake(self.frame.size.width - _customBadge.frame.size.width,
                                      0,
                                      _customBadge.frame.size.width,
                                      _customBadge.frame.size.height)];
	[self addSubview:_customBadge];
    [_customBadge setHidden:NO];
}

- (void)hideBadge{
    [_customBadge setHidden:YES];
}
@end
