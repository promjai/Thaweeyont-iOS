//
//  PFCouponViewController.h
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFThaweeyontApi.h"

#import "PFCouponCell.h"
#import "PFCouponDetailViewController.h"

@protocol PFCouponViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFCouponViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *couponOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIImageView *popupProgressBar;
@property (strong, nonatomic) UIImageView *progressBar;
@property (strong, nonatomic) NSString *statusProgress;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *paging;

@end
