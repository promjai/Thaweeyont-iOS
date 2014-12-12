//
//  PFBranchesViewController.h
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFThaweeyontApi.h"

#import "PFBranchesCell.h"
#import "PFBranchDetailViewController.h"

@protocol PFBranchesViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFBranchesViewControllerBack;

@end

@interface PFBranchesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFThaweeyontApi *ThaweeyontApi;
@property (strong, nonatomic) NSMutableArray *arrObj;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
