//
//  PFNotificationViewController.h
//  thaweeyont
//
//  Created by Pariwat on 26/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "PFNotificationCell.h"

#import "PFThaweeyontApi.h"

#import "PFUpdateDetailViewController.h"
#import "PFPromotionDetailViewController.h"
#import "PFCouponDetailViewController.h"
#import "PFMessageViewController.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFNotificationViewControllerBack;

@end

@interface PFNotificationViewController : UIViewController

@property AFHTTPRequestOperationManager *manager;
@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;

@property NSUserDefaults *notifyOffline;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSMutableArray *arrObj;

@property (retain, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *checkinternet;

@end
