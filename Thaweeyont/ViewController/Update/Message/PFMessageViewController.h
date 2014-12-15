//
//  PFMessageViewController.h
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/29/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

@protocol PFMessageViewControllerDelegate <NSObject>

- (void)PFMessageViewControllerBack;

@end

@interface PFMessageViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (retain, nonatomic) NSString *message;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;

@end
