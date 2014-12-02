//
//  PFUpdateDetailViewController.h
//  Thaweeyont
//
//  Created by Promjai on 10/27/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "DLImageLoader.h"
#import "UILabel+UILabelDynamicHeight.h"

@protocol PFUpdateDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFUpdateDetailViewControllerBack;

@end

@interface PFUpdateDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *obj;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *name;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnails;

@end
