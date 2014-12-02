//
//  PFMessageViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/29/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFMessageViewController.h"

@interface PFMessageViewController ()

@end

@implementation PFMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ThaweeyontApi = [[PFThaweeyontApi alloc] init];
    self.ThaweeyontApi.delegate = self;
    
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Message";
    } else {
        self.navigationItem.title = @"ข้อความ";
    }
    
    self.detail.text = self.message;
    
    CGRect frame = self.detail.frame;
    frame.size = [self.detail sizeOfMultiLineLabel];
    [self.detail sizeOfMultiLineLabel];
    
    [self.detail setFrame:frame];
    int lines = self.detail.frame.size.height/15;
    self.detail.numberOfLines = lines;
    
    if (lines > 1) {
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(0, 0, 0);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont boldSystemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height-20);
        
    }
    
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFMessageViewControllerBack)]){
            [self.delegate PFMessageViewControllerBack];
        }
    }
}

@end
