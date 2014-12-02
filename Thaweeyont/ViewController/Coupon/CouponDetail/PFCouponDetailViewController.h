//
//  PFCouponDetailViewController.h
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/5/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFThaweeyontApi.h"

#import "PFLoginViewController.h"

@protocol PFCouponDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFCouponDetailViewControllerBack;

@end

@interface PFCouponDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *couponDetailOffline;

@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *name;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *condition;

- (IBAction)fullimgTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *redeemView;
@property (strong, nonatomic) IBOutlet UIButton *redeemBt;
@property (strong, nonatomic) IBOutlet UILabel *redeemTxt;
- (IBAction)redeemTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *usedView;
@property (strong, nonatomic) IBOutlet UIButton *usedBt;
@property (strong, nonatomic) IBOutlet UILabel *usedTxt;

@property (strong, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UILabel *codeTxt;
@property (strong, nonatomic) IBOutlet UILabel *timeTxt;


@end
