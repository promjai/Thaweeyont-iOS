//
//  PFTabBarViewController.h
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTabBarItemButton.h"

@protocol PFTabBarViewControllerDelegate <NSObject>
@optional
- (void)PFTabBarViewController:(id)sender selectedIndex:(int)index;
@end

@interface PFTabBarViewController : UIViewController

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *tabBarView;
@property (strong, nonatomic) UIImageView *tabBarBackgroundImageView;
@property (assign, nonatomic) id <PFTabBarViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mesg0Label;
@property (weak, nonatomic) IBOutlet UILabel *mesg1Label;
@property (weak, nonatomic) IBOutlet UILabel *mesg2Label;
@property (readonly, nonatomic) NSMutableArray *itemButtons;
@property (readonly, nonatomic) NSMutableArray *viewControllers;

@property (nonatomic, weak) UIView* notificationView;

@property (nonatomic) int selectedIndex;
@property (readonly, nonatomic) int shownNotificationIndex;

- (id)initWithBackgroundImage:(UIImage*)image viewControllers:(id)firstObj, ... ;

- (void)hideTabBarWithAnimation:(BOOL)isAnimated;
- (void)showTabBarWithAnimation:(BOOL)isAnimated;

- (void)setNotificationViewForIndex:(NSUInteger)tabIndex mesg0:(NSString*)mesg0 mesg1:(NSString*)mesg1 mesg2:(NSString*)mesg2;
- (void)hideNotificationView;

- (void)hideTabBar;

@end
