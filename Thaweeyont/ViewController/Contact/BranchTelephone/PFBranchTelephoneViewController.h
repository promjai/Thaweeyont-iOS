//
//  PFBranchTelephoneViewController.h
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/7/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFThaweeyontApi.h"

#import "PFBranchTelCell.h"

@protocol PFBranchTelephoneViewControllerDelegate <NSObject>

- (void)PFBranchTelephoneViewControllerBack;

@end

@interface PFBranchTelephoneViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIImageView *popupProgressBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *paging;

@end
