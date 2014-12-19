//
//  PFProductViewController.h
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFPromotionCell.h"
#import "PFCatalogCell.h"
#import "PFFoldertypeCell.h"

#import "PFPromotionDetailViewController.h"
#import "PFCatalogDetailViewController.h"
#import "PFDetailFoldertypeViewController.h"

@protocol PFProductViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFProductViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) NSMutableArray *arrObjPromotion;
@property (strong, nonatomic) NSDictionary *objPromotion;

@property (strong, nonatomic) NSMutableArray *arrObjCatalog;
@property (strong, nonatomic) NSDictionary *objCatalog;

@property NSUserDefaults *promotionOffline;
@property NSUserDefaults *catalogOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) NSString *checksegmented;
@property (strong, nonatomic) NSString *checkstatus;

@property (strong, nonatomic) NSString *paging;

@end
