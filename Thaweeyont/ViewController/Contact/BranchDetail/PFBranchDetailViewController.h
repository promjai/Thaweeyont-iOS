//
//  PFBranchDetailViewController.h
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DLImageLoader.h"
#import "PagedImageScrollView.h"
#import "PFMapView.h"
#import "CMMapLauncher.h"

#import "PFApi.h"

#import "PFBranchesCell.h"
#import "PFMapViewController.h"
#import "PFBranchTelephoneViewController.h"

@protocol PFBranchDetailViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFBranchDetailViewControllerBack;

@end

@interface PFBranchDetailViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

//มีหมายเลขภายใน

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet PagedImageScrollView *pageScrollView;

@property (strong, nonatomic) IBOutlet UIView *imgscrollview;
@property (strong, nonatomic) NSMutableArray *ArrImgs;
@property (retain, nonatomic) NSMutableArray *arrcontactimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UILabel *faxLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

- (IBAction)phoneTapped:(id)sender;
- (IBAction)branchphoneTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *directionBt;
@property (strong, nonatomic) IBOutlet UILabel *directionLabel;

@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UIImageView *mapImg;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (IBAction)getDirectionTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;

- (IBAction)powerbyTapped:(id)sender;

//ไม่มีหมายเลขภายใน

@property (strong, nonatomic) IBOutlet UIView *footerView1;

@property (strong, nonatomic) IBOutlet UILabel *telephoneLabel1;
@property (strong, nonatomic) IBOutlet UILabel *faxLabel1;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel1;

@property (strong, nonatomic) IBOutlet UIButton *directionBt1;
@property (strong, nonatomic) IBOutlet UILabel *directionLabel1;

@property (strong, nonatomic) IBOutlet UIView *addressView1;
@property (strong, nonatomic) IBOutlet UIImageView *mapImg1;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel1;

@end
