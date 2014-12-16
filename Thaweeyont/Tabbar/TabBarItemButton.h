//
//  TabBarItemButton.h
//  TabbarContoller
//
//  Created by Pariwat Promjai on 12/2/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarItemButton : UIButton
{
@private

}
@property (weak, nonatomic) UIImage *highlightedImage;
@property (weak, nonatomic) UIImage *stanbyImage;

- (void)presentStanbyState;
- (void)presentHighlightedState;

@end
