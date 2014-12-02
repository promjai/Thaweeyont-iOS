//
//  PFTabBarViewController.m
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFTabBarViewController.h"
#define kTabBarHeight 48
int oldIndex;
@interface PFTabBarViewController ()
- (void)updateTabBarItem:(id)sender;
- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex;
- (void)showNotificationViewFor:(NSUInteger)tabIndex;
@end
@interface PFTabBarViewController ()

@end

@implementation PFTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidUnload {
    [self setTabBarBackgroundImageView:nil];
    [self setMesg0Label:nil];
    [self setMesg1Label:nil];
    [self setMesg2Label:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - IBAction
- (IBAction)tabBarItemTapped:(id)sender {
    self.tabBarView.alpha = 0.9;
    [self updateTabBarItem:sender];
    if([self.delegate respondsToSelector:@selector(PFTabBarViewController:selectedIndex:)]){
        PFTabBarItemButton *barItemButton = (PFTabBarItemButton*)sender;
        [self.delegate PFTabBarViewController:self selectedIndex:barItemButton.tag];
    }
}


#pragma mark - private
- (void)updateTabBarItem:(id)sender{
    self.tabBarView.alpha = 0.9;
    int i = 0;
    UIButton *tabBarItemButton = (UIButton*)sender;
    for (UIButton *button in self.itemButtons) {
        if (tabBarItemButton==button) {
            [self setSelectedIndex:i];
            return;
        }
        i++;
    }
}

#pragma mark - private
- (void)setSelectedIndex:(int)selectedIndex{
    if(selectedIndex>=[self.itemButtons count]) {
        return;
    }
    _selectedIndex = selectedIndex;
    int i = 0;
    for (PFTabBarItemButton *button in self.itemButtons) {
        
        if (i==selectedIndex) {
            [button presentHighlightedState];
        }else{
            [button presentStanbyState];
        }
        i++;
    }
    self.tabBarView.alpha = 0.9;
    
    [self.tabBarView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:9.0f]];
    
    [[self.viewControllers objectAtIndex:selectedIndex] setWantsFullScreenLayout:YES];
    [self.mainView addSubview:[[self.viewControllers objectAtIndex:selectedIndex] view]];
    oldIndex = selectedIndex;
    
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = (self.tabBarView.frame.size.width/[_viewControllers count]);
    // A half width is tabItemWidth divided by 2 minus half the width of the notification view
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (self.notificationView.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

#pragma mark - public
#pragma mark init
- (id)initWithBackgroundImage:(UIImage*)image viewControllers:(id)firstObj, ... {
    self = [super init];
    if (self) {
        // Custom initialization
        va_list args;
        va_start(args, firstObj); // clear the first param
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:firstObj,nil];
        id obj;
        while ((obj = va_arg(args, id)) != nil) {
            [viewControllers addObject:obj];
        }
        va_end(args);
        
        self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight+4, self.view.frame.size.width, kTabBarHeight-4)];
        
        self.tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBarView.frame.size.width, kTabBarHeight-4)];
        
        [self.tabBarBackgroundImageView setImage:image];
        [self.tabBarView addSubview:self.tabBarBackgroundImageView];
        
        _viewControllers = [[NSMutableArray alloc] initWithArray:viewControllers];
        _itemButtons = [[NSMutableArray alloc] init];
        int i = 0;
        for (id obj in _viewControllers) {
            PFTabBarItemButton *button = [(PFTabBarItemButton*)[PFTabBarItemButton alloc] init];
            [button addTarget:self
                       action:@selector(tabBarItemTapped:)
             forControlEvents:UIControlEventTouchDown];
            [button setTag:i];
            button.frame = CGRectMake(i*(self.tabBarView.frame.size.width/[_viewControllers count]), 0, (self.tabBarView.frame.size.width/[_viewControllers count]), kTabBarHeight-4);
            [self.tabBarView addSubview:button];
            [_itemButtons addObject:(PFTabBarItemButton*)button];
            i++;
        }
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //[_mainView setBlurTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.8]];
        [self.view addSubview:self.mainView];
        [self.view addSubview:self.tabBarView];
        
        UINib *notificationView = [UINib nibWithNibName:@"notificationView" bundle:[NSBundle mainBundle]];
        NSArray *notificationViews = [notificationView instantiateWithOwner:self options:nil];
        self.notificationView = [notificationViews objectAtIndex:0];
    }
    
    return self;
}

#pragma mark - show hide tabbar

- (void)hideTabBarWithAnimation:(BOOL)isAnimated{
    if (isAnimated) {
        [UIView beginAnimations:@"hideTab" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if(IS_WIDESCREEN){
            [self.tabBarView setFrame:CGRectMake(0, 568, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }else{
            [self.tabBarView setFrame:CGRectMake(0, 480, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }
        [UIView commitAnimations];
    }else{
        if(IS_WIDESCREEN){
            [self.tabBarView setFrame:CGRectMake(0, 548, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }else{
            [self.tabBarView setFrame:CGRectMake(0, 460, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }
    }
}

- (void)showTabBarWithAnimation:(BOOL)isAnimated{
    if (isAnimated) {
        [UIView beginAnimations:@"showTab" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if(IS_WIDESCREEN){
            [self.tabBarView setFrame:CGRectMake(0, 568-44, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }else{
            [self.tabBarView setFrame:CGRectMake(0, 411+26, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }
        [UIView commitAnimations];
    }else{
        [self.tabBarView setFrame:CGRectMake(0, 411+4, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }
}

- (void)hideTabBar {
    if(IS_WIDESCREEN){
        [self.tabBarView setFrame:CGRectMake(0, 568, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }else{
        [self.tabBarView setFrame:CGRectMake(0, 480, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }
}

#pragma mark set notification
- (void)setNotificationViewForIndex:(NSUInteger)tabIndex
                              mesg0:(NSString*)mesg0
                              mesg1:(NSString*)mesg1
                              mesg2:(NSString*)mesg2{
    self.mesg0Label.text = mesg0;
    self.mesg1Label.text = mesg1;
    self.mesg2Label.text = mesg2;
    [self showNotificationViewFor:tabIndex];
}

- (void) showNotificationViewFor:(NSUInteger)tabIndex
{
    // To get the vertical location we start at the top of the tab bar (0), go up by the height of the notification view, then go up another 2 pixels so our view is slightly above the tab bar
    CGFloat verticalLocation = - self.notificationView.frame.size.height - 2.0;
    self.notificationView.frame = CGRectMake([self horizontalLocationFor:tabIndex], verticalLocation, self.notificationView.frame.size.width, self.notificationView.frame.size.height);
    
    if (!self.notificationView.superview)
        [self.tabBarView addSubview:self.notificationView];
    
    self.notificationView.alpha = 0.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.8];
    [UIView setAnimationDuration:0.5];
    self.notificationView.alpha = 1.0;
    [UIView commitAnimations];
    _shownNotificationIndex = tabIndex;
}

- (void)hideNotificationView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.notificationView.alpha = 0.0;
    [UIView commitAnimations];
}
@end
