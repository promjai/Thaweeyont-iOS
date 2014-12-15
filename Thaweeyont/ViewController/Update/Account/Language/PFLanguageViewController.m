//
//  PFLanguageViewController.m
//  thaweeyont
//
//  Created by Pariwat on 7/16/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFLanguageViewController.h"

@interface PFLanguageViewController ()

@end

@implementation PFLanguageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        
        self.navigationItem.title = @"App Language";
        
        self.checkTH.hidden = YES;
        self.thai.textColor = RGB(170, 170, 170);
        self.thai.text = @"Thai (TH)";
        self.english.textColor = RGB(0, 0, 0);
        self.english.text = @"English (EN)";
        self.statusLanguage = @"EN";
        self.save.text = @"save";
    } else {
        
        self.navigationItem.title = @"ภาษาแอพพลิเคชั่น";
        
        self.checkEN.hidden = YES;
        self.thai.textColor = RGB(0, 0, 0);
        self.thai.text = @"ภาษาไทย (TH)";
        self.english.textColor = RGB(170, 170, 170);
        self.english.text = @"ภาษาอังกฤษ (EN)";
        self.statusLanguage = @"TH";
        self.save.text = @"บันทึก";
    }
    
    CALayer *saveButton = [self.saveButton layer];
    [saveButton setMasksToBounds:YES];
    [saveButton setCornerRadius:7.0f];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)ThaiTapped:(id)sender{
    self.checkEN.hidden = YES;
    self.checkTH.hidden = NO;
    self.thai.textColor = RGB(0, 0, 0);
    self.english.textColor = RGB(170, 170, 170);
    self.statusLanguage = @"TH";
}

- (IBAction)EnglishTapped:(id)sender{
    self.checkTH.hidden = YES;
    self.checkEN.hidden = NO;
    self.thai.textColor = RGB(170, 170, 170);
    self.english.textColor = RGB(0, 0, 0);
    self.statusLanguage = @"EN";
}

- (IBAction)saveTapped:(id)sender{
    [self.Api saveLanguage:self.statusLanguage];
    [self.delegate BackSetting];
    [self.Api saveReset:@"YES"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFLanguageViewControllerBack)]){
            [self.delegate PFLanguageViewControllerBack];
        }
    }
    
}

@end
