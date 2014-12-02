//
//  PFAccountViewController.h
//  thaweeyont
//
//  Created by Pariwat on 6/20/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <FacebookSDK/FacebookSDK.h>

#import "PFThaweeyontApi.h"

#import "PFAccountCell.h"
#import "PFEditViewController.h"
#import "PFLanguageViewController.h"

@protocol PFAccountViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFAccountViewControllerBack;

@end

@interface PFAccountViewController : UIViewController < UITextViewDelegate >

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *meOffline;
@property NSUserDefaults *settingOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bgEditView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) NSString *rowCount;

@property (strong, nonatomic) IBOutlet UIView *bgnewsView;
@property (strong, nonatomic) IBOutlet UIView *bgmessageView;

@property (strong, nonatomic) IBOutlet UIImageView *thumUser;
@property (strong, nonatomic) IBOutlet UITextField *display_name;

- (IBAction)fullimage:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *newupdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *languageLabel;
@property (strong, nonatomic) IBOutlet UILabel *applanguageLabel;
@property (strong, nonatomic) IBOutlet UILabel *appstatuslanguageLabel;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)editProfile:(id)sender;
- (IBAction)applanguage:(id)sender;

- (IBAction)switchNewsonoff:(id)sender;
- (IBAction)switchMessageonoff:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *switchNews;
@property (strong, nonatomic) IBOutlet UISwitch *switchMessage;

- (IBAction)logoutTapped:(id)sender;


@end