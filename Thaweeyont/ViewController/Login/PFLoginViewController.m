//
//  PFLoginViewController.m
//  thaweeyont
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFLoginViewController.h"

@interface PFLoginViewController ()

@end

@implementation PFLoginViewController

FBLoginView *fbloginview;
NSString *password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        
        self.usernameTextField.placeholder = @"User name";
        self.passwordTextField.placeholder = @"Password";
        
        self.usernameRegisTextField.placeholder = @"User name";
        self.emailRegisTextField.placeholder = @"E-mail";
        self.passwordRegisTextField.placeholder = @"Password";
        self.confirmpasswordRegisTextField.placeholder = @"Confirm Password";
        self.genderRegisTextField.placeholder = @"Gender (Optional)";
        self.birthdayRegisTextField.placeholder = @"Date of Birth (Optional)";
        
    } else {
        
        self.usernameTextField.placeholder = @"ชื่อผู้ใช้";
        self.passwordTextField.placeholder = @"รหัสผ่าน";
        
        self.usernameRegisTextField.placeholder = @"ชื่อผู้ใช้";
        self.emailRegisTextField.placeholder = @"อีเมล";
        self.passwordRegisTextField.placeholder = @"รหัสผ่าน";
        self.confirmpasswordRegisTextField.placeholder = @"ยืนยันรหัสผ่าน";
        self.genderRegisTextField.placeholder = @"เพศ (ไม่จำเป็น)";
        self.birthdayRegisTextField.placeholder = @"วันเกิด (ไม่จำเป็น)";
        
    }
    
    //Facebook
    fbloginview = [[FBLoginView alloc]init];
    fbloginview.readPermissions = @[@"public_profile",@"email",@"user_birthday"];
    fbloginview.frame = CGRectMake(0, 0, 0, 0);
    fbloginview.delegate = self;
    [self.view addSubview:fbloginview];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:[[NSArray alloc] initWithObjects:@"basic_info",@"email",@"user_birthday", nil]];
    [FBSession setActiveSession:session];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeloginView:)];
    [self.blurView addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view from its nib.
    self.loginView.layer.masksToBounds = NO;
    self.loginView.layer.cornerRadius = 5; // if you like rounded corners
    self.loginView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.loginView.layer.shadowRadius = 5;
    self.loginView.layer.shadowOpacity = 0.5;
    
    [self.loginwithfacebookButton.layer setMasksToBounds:YES];
    [self.loginwithfacebookButton.layer setCornerRadius:5.0f];
    
    [self.logInButton.layer setMasksToBounds:YES];
    [self.logInButton.layer setCornerRadius:5.0f];
    
    [self.signUpButton.layer setMasksToBounds:YES];
    [self.signUpButton.layer setCornerRadius:5.0f];
    
    // Do any additional setup after loading the view from its nib.
    self.registerView.layer.masksToBounds = NO;
    self.registerView.layer.cornerRadius = 5; // if you like rounded corners
    self.registerView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.registerView.layer.shadowRadius = 5;
    self.registerView.layer.shadowOpacity = 0.5;
    
    [self.createButton.layer setMasksToBounds:YES];
    [self.createButton.layer setCornerRadius:5.0f];
    
    self.loginView.frame = CGRectMake(20, 100, self.loginView.frame.size.width, self.loginView.frame.size.height);
    [self.view addSubview:self.loginView];
    
    self.pick = [[UIDatePicker alloc] init];
    self.pickDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickDone setFrame:CGRectMake(50, 370, 200, 44)];
    self.pickDone.alpha = 0;
    [self.pick setFrame:CGRectMake(0,200,320,120)];
    self.pick.alpha = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)closeloginView:(UITapGestureRecognizer *)gesture
{
    [self.view removeFromSuperview];
}

- (void)registerView:(UITapGestureRecognizer *)gesture
{
    [self.registerView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.view addSubview:self.loginView];
}

- (IBAction)loginwithfacebookTapped:(id)sender {
    for (id obj in fbloginview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]){
            [obj sendActionsForControlEvents: UIControlEventTouchUpInside];
            {
            }
        }
    }
}

//Facebook
#pragma mark - Facebook Delegate
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    
    NSLog(@"facebook %@",user);
    
    [self.Api loginWithFacebookToken:fbAccessToken];
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"You're logged in as");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"You're not logged in!");
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)PFThaweeyontApi:(id)sender loginWithFacebookTokenResponse:(NSDictionary *)response {
    //NSLog(@"FacebookResponse %@",response);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"access_token"] forKey:@"access_token"];
    [defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
    [defaults synchronize];
    
    [self.view removeFromSuperview];
    
    if ([self.menu isEqualToString:@"account"]) {
        self.menu = @"";
        [self.delegate PFAccountViewController:self];
        
    } else if ([self.menu isEqualToString:@"comment"]) {
        self.menu = @"";
        [self.delegate PFCommentViewController:self];
        
    } else if ([self.menu isEqualToString:@"coupon"]) {
        self.menu = @"";
        [self.delegate PFCouponViewController:self];
        
    }
    
}
- (void)PFThaweeyontApi:(id)sender LoginWithFacebookTokenErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (IBAction)loginwithemailTapped:(id)sender {
    [self.Api loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
}

- (IBAction)signupTapped:(id)sender {
    [self.loginView removeFromSuperview];
    
    self.registerView.frame = CGRectMake(20, 85, self.registerView.frame.size.width, self.registerView.frame.size.height);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerView:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    [self.scrollView addSubview:self.registerView];
    [self.view addSubview:self.scrollView];
}

- (void)PFThaweeyontApi:(id)sender loginWithUsernameResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    if ([[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Main\\CTL\\Exception\\NeedParameterException"] || [[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"NotAuthorized"] || [[[response objectForKey:@"error"] objectForKey:@"type"] isEqualToString:@"Error"]) {
        [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[response objectForKey:@"access_token"] forKey:@"access_token"];
        [defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
        [defaults synchronize];
        
        [self.view removeFromSuperview];
        
        if ([self.menu isEqualToString:@"account"]) {
            self.menu = @"";
            [self.delegate PFAccountViewController:self];
            
        } else if ([self.menu isEqualToString:@"comment"]) {
            self.menu = @"";
            [self.delegate PFCommentViewController:self];
        } else if ([self.menu isEqualToString:@"coupon"]) {
            self.menu = @"";
            [self.delegate PFCouponViewController:self];
            
        }
        
    }
    
}

- (void)PFThaweeyontApi:(id)sender loginWithUsernameErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

//register
- (IBAction)dateBTapped:(id)sender {
    [self hideKeyboard];
    [UIView animateWithDuration:0.0
                          delay:0.0  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         [self.pickDone setFrame:CGRectMake(0, 362, 320, 44)];
                         [self.pickDone setBackgroundColor:[UIColor whiteColor]];
                         [self.pickDone setTintColor:[UIColor blackColor]];
                         [self.pickDone setTitle:@"Ok !" forState:UIControlStateNormal];
                         [self.pickDone addTarget:self action:@selector(dateBirthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                         self.pickDone.alpha = 1;
                         [self.view addSubview:self.pickDone];
                         self.pick.alpha = 1;
                         
                         [self.pick setFrame:CGRectMake(0,200,320,120)];
                         self.pick.backgroundColor = [UIColor whiteColor];
                         self.pick.hidden = NO;
                         self.pick.datePickerMode = UIDatePickerModeDate;
                         
                         self.pick.tintColor = [UIColor whiteColor];
                         [self.view addSubview:self.pick];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)dateBirthButtonClicked {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.dateFormat = @"dd-MM-yyyy";
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:enUSPOSIXLocale];
    
    NSArray *temp = [[NSString stringWithFormat:@"%@",[date stringFromDate:self.pick.date]] componentsSeparatedByString:@""];
    NSString *dateString = [[NSString alloc] init];
    dateString = [[NSString alloc] initWithString:[temp objectAtIndex:0]];
    
    [self.birthdayRegisTextField setText:dateString];
    self.pick.alpha = 0;
    self.pickDone.alpha = 0;
    [self.pickDone removeFromSuperview];
    [self.pick removeFromSuperview];
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (IBAction)genderTapped:(id)sender {
    [self hideKeyboard];
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                          message:@"Select gender."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Male", @"Female", nil];
        [message show];
        
    } else {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                          message:@"เลือก เพศ"
                                                         delegate:self
                                                cancelButtonTitle:@"ยกเลิก"
                                                otherButtonTitles:@"ชาย", @"หญิง", nil];
        [message show];
        
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.genderRegisTextField.text = @"male";
    } else if (buttonIndex == 2) {
        self.genderRegisTextField.text = @"female";
    }
}

- (IBAction)closedateTapped:(id)sender {
    self.birthdayRegisTextField.text = @"";
}

- (IBAction)closegenderTapped:(id)sender {
    self.genderRegisTextField.text = @"";
}

- (IBAction)createTapped:(id)sender {

    password = self.passwordRegisTextField.text;
    
    if ( [self.usernameRegisTextField.text isEqualToString:@""]) {
        if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"Username Incorrect"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"ชื่อผู้ใช้ไม่ถูกต้อง"
                                                             delegate:nil
                                                    cancelButtonTitle:@"ตกลง"
                                                    otherButtonTitles:nil];
            [message show];
        }
        return;
    } else if ( [self.emailRegisTextField.text isEqualToString:@""]) {
        if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"Email Incorrect"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"Email ไม่ถูกต้อง"
                                                             delegate:nil
                                                    cancelButtonTitle:@"ตกลง"
                                                    otherButtonTitles:nil];
            [message show];
        }
        return;
    } else if ( ![self validateEmail:[self.emailRegisTextField text]] ) {
        if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"Enter a valid email address"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"ป้อนที่อยู่ email ที่ถูกต้อง"
                                                             delegate:nil
                                                    cancelButtonTitle:@"ตกลง"
                                                    otherButtonTitles:nil];
            [message show];
        }
        return;
    } else if ( [self.passwordRegisTextField.text isEqualToString:@""]) {
        if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"Password Incorrect"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"รหัสผ่านไม่ถูกต้อง"
                                                             delegate:nil
                                                    cancelButtonTitle:@"ตกลง"
                                                    otherButtonTitles:nil];
            [message show];
        }
        return;
    } else if (![self.passwordRegisTextField.text isEqualToString:self.confirmpasswordRegisTextField.text]) {
        if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"And password do not match."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                                              message:@"รหัสผ่านไม่ตรงกัน"
                                                             delegate:nil
                                                    cancelButtonTitle:@"ตกลง"
                                                    otherButtonTitles:nil];
            [message show];
        }
        return;
    } else {
        [self.Api registerWithUsername:self.usernameRegisTextField.text email:self.emailRegisTextField.text password:self.passwordRegisTextField.text gender:self.genderRegisTextField.text birth_date:self.birthdayRegisTextField.text];
    }

}

- (void)PFThaweeyontApi:(id)sender registerWithUsernameResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([response objectForKey:@"error"] != nil ) {
        [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        
        [self hideKeyboard];
        [self.Api loginWithUsername:[response objectForKey:@"username"] password:password];
        
    }
}

- (void)PFThaweeyontApi:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse {
    NSLog(@"error%@",errorResponse);
    
    [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, -10, self.loginView.frame.size.width, self.loginView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.passwordTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, -10, self.loginView.frame.size.width, self.loginView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.usernameRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, -10, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.emailRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, -45, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.passwordRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, -80, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.confirmpasswordRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, -115, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, 100, self.loginView.frame.size.width, self.loginView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.passwordTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.loginView.frame = CGRectMake(self.loginView.frame.origin.x, 100, self.loginView.frame.size.width, self.loginView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.usernameRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, 85, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.emailRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, 85, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.passwordRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, 85, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == self.confirmpasswordRegisTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.registerView.frame = CGRectMake(self.registerView.frame.origin.x, 85, self.registerView.frame.size.width, self.registerView.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self.usernameRegisTextField resignFirstResponder];
    [self.emailRegisTextField resignFirstResponder];
    [self.passwordRegisTextField resignFirstResponder];
    [self.confirmpasswordRegisTextField resignFirstResponder];
    
    return YES;
}

- (void)hideKeyboard {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self.usernameRegisTextField resignFirstResponder];
    [self.emailRegisTextField resignFirstResponder];
    [self.passwordRegisTextField resignFirstResponder];
    [self.confirmpasswordRegisTextField resignFirstResponder];
    
}

@end
