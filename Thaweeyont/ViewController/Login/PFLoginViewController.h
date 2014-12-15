//
//  PFLoginViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PFApi.h"

@protocol PFLoginViewControllerDelegate <NSObject>

- (void)PFAccountViewController:(id)sender;
- (void)PFCommentViewController:(id)sender;
- (void)PFCouponViewController:(id)sender;

@end

@interface PFLoginViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *menu;

//Login

@property (strong, nonatomic) IBOutlet UIButton *loginwithfacebookButton;

- (IBAction)loginwithfacebookTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIImageView *bgemailTextFieldView;
@property (strong, nonatomic) IBOutlet UIImageView *bgpasswordTextFieldView;

@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)loginwithemailTapped:(id)sender;
- (IBAction)signupTapped:(id)sender;

//Create

@property (strong, nonatomic) IBOutlet UITextField *usernameRegisTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailRegisTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordRegisTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmpasswordRegisTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderRegisTextField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayRegisTextField;

@property (strong, nonatomic) UIDatePicker *pick;
@property (strong, nonatomic) UIButton *pickDone;

- (IBAction)genderTapped:(id)sender;
- (IBAction)dateBTapped:(id)sender;

- (IBAction)closegenderTapped:(id)sender;
- (IBAction)closedateTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *createButton;
- (IBAction)createTapped:(id)sender;

@end
