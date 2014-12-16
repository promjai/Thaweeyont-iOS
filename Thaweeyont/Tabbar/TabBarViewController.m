//
//  TabBarViewController.m
//  TabbarContoller
//
//  Created by Pariwat Promjai on 12/2/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "TabBarViewController.h"
#define kTabBarHeight 44

int oldIndex;

@interface TabBarViewController ()

- (void)updateTabBarItem:(id)sender;

@end

@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    [self updateTabBarItem:sender];
    if([self.delegate respondsToSelector:@selector(TabBarViewController:selectedIndex:)]){
        TabBarItemButton *barItemButton = (TabBarItemButton*)sender;
        [self.delegate TabBarViewController:self selectedIndex:barItemButton.tag];
    }
}


#pragma mark - private
- (void)updateTabBarItem:(id)sender{
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
    
    if( selectedIndex >= [self.itemButtons count] ) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    int i = 0;
    
    for (TabBarItemButton *button in self.itemButtons) {
        
        if (i == selectedIndex) {
            [button presentHighlightedState];
        } else {
            [button presentStanbyState];
        }
        i++;
    }
    
    self.tabBarView.alpha = 0.9;
    [self.tabBarView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    [[self.viewControllers objectAtIndex:selectedIndex] setWantsFullScreenLayout:YES];
    [self.mainView addSubview:[[self.viewControllers objectAtIndex:selectedIndex] view]];
    oldIndex = selectedIndex;
    
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
        
        self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight, self.view.frame.size.width, kTabBarHeight)];
        
        self.tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tabBarView.frame.size.width, kTabBarHeight)];
        
        [self.tabBarBackgroundImageView setImage:image];
        [self.tabBarView addSubview:self.tabBarBackgroundImageView];
        
        _viewControllers = [[NSMutableArray alloc] initWithArray:viewControllers];
        _itemButtons = [[NSMutableArray alloc] init];
        
        int i = 0;
        for (id obj in _viewControllers) {
            
            TabBarItemButton *button = [(TabBarItemButton*)[TabBarItemButton alloc] init];
            [button addTarget:self
                       action:@selector(tabBarItemTapped:)
             forControlEvents:UIControlEventTouchDown];
            [button setTag:i];
            button.frame = CGRectMake(i*(self.tabBarView.frame.size.width/[_viewControllers count]), 0, (self.tabBarView.frame.size.width/[_viewControllers count]), kTabBarHeight);
            [self.tabBarView addSubview:button];
            [_itemButtons addObject:(TabBarItemButton*)button];
            i++;
        }
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.view addSubview:self.mainView];
        [self.view addSubview:self.tabBarView];
        
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
            [self.tabBarView setFrame:CGRectMake(0, 524, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }else{
            [self.tabBarView setFrame:CGRectMake(0, 436, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
        }
        [UIView commitAnimations];
    }else{
        [self.tabBarView setFrame:CGRectMake(0, 416, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }
}

- (void)hideTabBar {
    if(IS_WIDESCREEN){
        [self.tabBarView setFrame:CGRectMake(0, 568, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }else{
        [self.tabBarView setFrame:CGRectMake(0, 480, self.tabBarView.frame.size.width, self.tabBarView.frame.size.height)];
    }
}

@end
