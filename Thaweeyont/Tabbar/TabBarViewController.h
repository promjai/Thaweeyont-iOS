//
//  TabBarViewController.h
//  TabbarContoller
//
//  Created by Pariwat Promjai on 12/2/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItemButton.h"

@protocol TabBarViewControllerDelegate <NSObject>

@optional

- (void)TabBarViewController:(id)sender selectedIndex:(int)index;

@end

@interface TabBarViewController : UIViewController

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *tabBarView;
@property (strong, nonatomic) UIImageView *tabBarBackgroundImageView;
@property (assign, nonatomic) id <TabBarViewControllerDelegate> delegate;
@property (readonly, nonatomic) NSMutableArray *itemButtons;
@property (readonly, nonatomic) NSMutableArray *viewControllers;

@property (nonatomic) int selectedIndex;

- (id)initWithBackgroundImage:(UIImage*)image viewControllers:(id)firstObj, ... ;

- (void)hideTabBarWithAnimation:(BOOL)isAnimated;
- (void)showTabBarWithAnimation:(BOOL)isAnimated;

- (void)hideTabBar;

@end
