//
//  PFAccountViewController.m
//  thaweeyont
//
//  Created by Pariwat on 6/20/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFAccountViewController.h"

@interface PFAccountViewController () <UIScrollViewDelegate>

@end

@implementation PFAccountViewController

NSString *removeBreckets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.meOffline = [NSUserDefaults standardUserDefaults];
        self.settingOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Setting";
        self.notificationLabel.text = @"Notification setting";
        self.newupdateLabel.text = @"News Update";
        self.messageLabel.text = @"Message from shop";
        self.languageLabel.text = @"Language setting";
        self.applanguageLabel.text = @"App Language";
        self.appstatuslanguageLabel.text = @"EN";
        [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        self.navigationItem.title = @"ตั้งค่า";
        self.notificationLabel.text = @"ตั้งค่าการแจ้งเตือน";
        self.newupdateLabel.text = @"ข่าวใหม่";
        self.messageLabel.text = @"ข้อความจากระบบ";
        self.languageLabel.text = @"ตั้งค่าภาษา";
        self.applanguageLabel.text = @"ภาษาแอพพลิเคชั่น";
        self.appstatuslanguageLabel.text = @"TH";
        [self.logoutButton setTitle:@"ออกจากระบบ" forState:UIControlStateNormal];
    }
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.bgEditView.layer.shadowOffset = CGSizeMake(0.5, -0.5);
    self.bgEditView.layer.shadowRadius = 2;
    self.bgEditView.layer.shadowOpacity = 0.1;
    
    CALayer *logoutButton = [self.logoutButton layer];
    [logoutButton setMasksToBounds:YES];
    [logoutButton setCornerRadius:5.0f];
    
    self.obj = [[NSDictionary alloc] init];
    self.rowCount = [[NSString alloc] init];
    
    [self.Api me];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFApi:(id)sender meResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"Me %@",response);
    
    [self.waitView removeFromSuperview];
    
    [self.meOffline setObject:response forKey:@"meOffline"];
    [self.meOffline synchronize];
    
    self.display_name.text = [response objectForKey:@"display_name"];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.Api getUserSetting];
    
}

- (void)PFApi:(id)sender meErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.display_name.text = [[self.meOffline objectForKey:@"meOffline"] objectForKey:@"display_name"];
    
    NSString *picStr = [[[self.meOffline objectForKey:@"meOffline"] objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.Api getUserSetting];
}

- (void)PFApi:(id)sender getUserSettingResponse:(NSDictionary *)response {
    NSLog(@"getUserSetting %@",response);
    
    [self.settingOffline setObject:response forKey:@"settingOffline"];
    [self.settingOffline synchronize];
    
    //switch
    
    if ([[response objectForKey:@"notify_update"] intValue] == 1) {
        self.switchNews.on = YES;
    } else {
        self.switchNews.on = NO;
    }
    
    if ([[response objectForKey:@"notify_message"] intValue] == 1) {
        self.switchMessage.on = YES;
    } else {
        self.switchMessage.on = NO;
    }
    
}

- (void)PFApi:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    if ([[[self.settingOffline objectForKey:@"settingOffline"] objectForKey:@"notify_update"] intValue] == 1) {
        self.switchNews.on = YES;
    } else {
        self.switchNews.on = NO;
    }
    
    if ([[[self.settingOffline objectForKey:@"settingOffline"] objectForKey:@"notify_message"] intValue] == 1) {
        self.switchMessage.on = YES;
    } else {
        self.switchMessage.on = NO;
    }
}

- (IBAction)switchNewsonoff:(id)sender{
    
    if(self.switchNews.on) {
        [self.Api settingNews:@"1"];
    } else {
        [self.Api settingNews:@"0"];
    }
    
}

- (IBAction)switchMessageonoff:(id)sender{
    
    if(self.switchMessage.on) {
        [self.Api settingMessage:@"1"];
    } else {
        [self.Api settingMessage:@"0"];
    }
    
}

- (void)PFApi:(id)sender settingNewsResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
}

- (void)PFApi:(id)sender settingNewsErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)editProfile:(id)sender {
    
    PFEditViewController *profileView = [[PFEditViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        profileView = [[PFEditViewController alloc] initWithNibName:@"PFEditViewController_Wide" bundle:nil];
    } else {
        profileView = [[PFEditViewController alloc] initWithNibName:@"PFEditViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    profileView.delegate = self;
    profileView.objEdit = self.obj;
    [self presentModalViewController:profileView animated:YES];
    
}

- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFAccountViewController:self viewPicture:link];
}

- (IBAction)applanguage:(id)sender {
    
    PFLanguageViewController *language = [[PFLanguageViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        language = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController_Wide" bundle:nil];
    } else {
        language = [[PFLanguageViewController alloc] initWithNibName:@"PFLanguageViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    language.delegate = self;
    [self.navigationController pushViewController:language animated:YES];
    
}

- (IBAction)fullimage:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:self.thumUser.image];
}

- (IBAction)logoutTapped:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.Api logOut];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)PFEditViewControllerBack {
    [self viewDidLoad];
}

- (void)PFLanguageViewControllerBack {
    [self viewDidLoad];
}

- (void)BackSetting {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFAccountViewControllerBack)]){
            [self.delegate PFAccountViewControllerBack];
        }
    }
    
}

@end
