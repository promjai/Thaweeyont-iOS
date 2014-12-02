//
//  PFTabBarItemButton.h
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCustomBadge.h"

@interface PFTabBarItemButton : UIButton
{
@private
    PFCustomBadge *_customBadge;
}
@property (weak, nonatomic) UIImage *highlightedImage;
@property (weak, nonatomic) UIImage *stanbyImage;
@property (weak, nonatomic) NSString *badge;

- (void)setBadge:(NSString *)badge;
- (void)presentStanbyState;
- (void)presentHighlightedState;
- (void)hideBadge;
@end
