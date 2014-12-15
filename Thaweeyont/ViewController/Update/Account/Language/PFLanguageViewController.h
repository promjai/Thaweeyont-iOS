//
//  PFLanguageViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@protocol PFLanguageViewControllerDelegate <NSObject>

- (void)PFLanguageViewControllerBack;
- (void)BackSetting;

@end

@interface PFLanguageViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel *thai;
@property (strong, nonatomic) IBOutlet UILabel *english;
@property (strong, nonatomic) IBOutlet UIImageView *checkTH;
@property (strong, nonatomic) IBOutlet UIImageView *checkEN;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *save;

@property (strong, nonatomic) NSString *statusSetting;
@property (strong, nonatomic) NSString *statusLanguage;

- (IBAction)ThaiTapped:(id)sender;
- (IBAction)EnglishTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;

@end
