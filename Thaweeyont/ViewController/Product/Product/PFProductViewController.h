//
//  PFProductViewController.h
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFThaweeyontApi.h"

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
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;

@property (strong, nonatomic) NSMutableArray *arrObjPromotion;
@property (strong, nonatomic) NSDictionary *objPromotion;

@property (strong, nonatomic) NSMutableArray *arrObjCatalog;
@property (strong, nonatomic) NSDictionary *objCatalog;

@property NSUserDefaults *promotionOffline;
@property NSUserDefaults *catalogOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) IBOutlet UILabel *loadLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) NSString *checksegmented;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIView *promotionView;
@property (strong, nonatomic) IBOutlet UITableView *promotiontableView;

@property (strong, nonatomic) IBOutlet UIView *catalogView;
@property (strong, nonatomic) IBOutlet UITableView *catalogtableView;

@property (strong, nonatomic) NSString *paging;

@end
