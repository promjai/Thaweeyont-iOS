//
//  PFCouponDetailViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/5/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFCouponDetailViewController.h"

@interface PFCouponDetailViewController ()

@end

@implementation PFCouponDetailViewController

int sum;
NSString *dte;
NSTimer *timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.couponDetailOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.redeemTxt.text = @"Redeem";
        self.usedTxt.text = @"Used";
    } else {
        self.redeemTxt.text = @"Redeem";
        self.usedTxt.text = @"Used";
    }
    
    [self.redeemBt.layer setMasksToBounds:YES];
    [self.redeemBt.layer setCornerRadius:5.0f];
    
    [self.usedBt.layer setMasksToBounds:YES];
    [self.usedBt.layer setCornerRadius:5.0f];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    self.thumbnails.layer.masksToBounds = YES;
    self.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    //name
    self.name.text = [self.obj objectForKey:@"name"];
    
    CGRect frameName = self.name.frame;
    frameName.size = [self.name sizeOfMultiLineLabel];
    [self.name sizeOfMultiLineLabel];
    
    [self.name setFrame:frameName];
    int linesName = self.name.frame.size.height/15;
    self.name.numberOfLines = linesName;
    
    UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
    descTextName.textColor = RGB(190, 30, 30);
    descTextName.text = self.name.text;
    descTextName.numberOfLines = linesName;
    [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
    self.name.alpha = 0;
    [self.headerView addSubview:descTextName];
    
    //detail
    self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y+self.name.frame.size.height-20, self.detail.frame.size.width, self.detail.frame.size.height);
    
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    CGRect frame = self.detail.frame;
    frame.size = [self.detail sizeOfMultiLineLabel];
    [self.detail sizeOfMultiLineLabel];
    
    [self.detail setFrame:frame];
    int lines = self.detail.frame.size.height/15;
    self.detail.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.textColor = RGB(102, 102, 102);
    descText.text = self.detail.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.detail.alpha = 0;
    [self.headerView addSubview:descText];
    
    //condition
    self.condition.frame = CGRectMake(self.condition.frame.origin.x, self.condition.frame.origin.y+self.detail.frame.size.height-10, self.condition.frame.size.width, self.condition.frame.size.height);
    
    self.condition.text = [self.obj objectForKey:@"condition"];
    CGRect frame1 = self.condition.frame;
    frame1.size = [self.condition sizeOfMultiLineLabel];
    [self.condition sizeOfMultiLineLabel];
    
    [self.condition setFrame:frame1];
    int lines1 = self.condition.frame.size.height/15;
    self.condition.numberOfLines = lines1;
    
    UILabel *descText1 = [[UILabel alloc] initWithFrame:frame1];
    descText1.textColor = RGB(102, 102, 102);
    descText1.text = self.condition.text;
    descText1.numberOfLines = lines1;
    [descText1 setFont:[UIFont systemFontOfSize:15]];
    self.condition.alpha = 0;
    [self.headerView addSubview:descText1];
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detail.frame.size.height+self.condition.frame.size.height-20);
    
    self.tableView.tableHeaderView = self.headerView;
    
    if ([self.checkinternet isEqualToString:@"connect"]) {
        
        if ([[self.obj objectForKey:@"used_status"] isEqualToString:@"none"]) {
            
            self.tableView.tableFooterView = self.redeemView;
            
        } else if ([[self.obj objectForKey:@"used_status"] isEqualToString:@"countdown"]) {
            
            [self.Api getCouponRequest:[self.obj objectForKey:@"id"]];
            
        } else if ([[self.obj objectForKey:@"used_status"] isEqualToString:@"timeout"]) {
            
            self.tableView.tableFooterView = self.usedView;
            
        }
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFCouponViewController:(id)sender {

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"คุณสามารถใช้คูปองได้ภายใน 60 นาที ต้องการใช้คูปองหรือไม่ ?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Confirm", nil];
    [message show];
    
}

- (IBAction)redeemTapped:(id)sender {
    if ([self.Api checkLogin] == 0){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"coupon";
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"คุณสามารถใช้คูปองได้ภายใน 60 นาที ต้องการใช้คูปองหรือไม่ ?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Confirm", nil];
        
        [message show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        [self.redeemView removeFromSuperview];
        self.tableView.tableFooterView = self.codeView;
        
        [self.Api getCouponRequest:[self.obj objectForKey:@"id"]];
        
    }
}

- (void)PFApi:(id)sender getCouponRequestResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[response objectForKey:@"expire"] intValue] == 0) {
        
        [self.codeView removeFromSuperview];
        self.tableView.tableFooterView = self.usedView;
        
    } else {
    
        self.tableView.tableFooterView = self.codeView;
        
        self.codeTxt.text = [response objectForKey:@"code"];
        
        NSDate *today = [NSDate date];
        NSTimeInterval interval  = [today timeIntervalSince1970] ;
        int myInt = (int)interval;
        
        NSLog(@"%d",myInt);
        
        sum = [[response objectForKey:@"expire"] intValue] - myInt;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        
        dte = [dateFormatter stringFromDate:date];
        
        self.timeTxt.text = [[NSString alloc] initWithFormat:@"เหลือเวลาอีก 00:%@",dte];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
        
    }
    
}

-(void)countTime:(NSTimer *)timer
{
    
    sum = sum - 1;
    
    if (sum == 0) {
        
        [self.codeView removeFromSuperview];
        self.tableView.tableFooterView = self.usedView;
    
    } else {
    
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sum];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        
        dte = [dateFormatter stringFromDate:date];
        self.timeTxt.text = [[NSString alloc] initWithFormat:@"เหลือเวลาอีก 00:%@",dte];
        
    }
}

- (void)PFApi:(id)sender getCouponRequestErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:self.thumbnails.image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFCouponDetailViewControllerBack)]){
            [self.delegate PFCouponDetailViewControllerBack];
            [timer invalidate];
        }
    }
}

@end
