//
//  PFBranchDetailViewController.m
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFBranchDetailViewController.h"

@interface PFBranchDetailViewController ()

@end

@implementation PFBranchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"%@",self.obj);
    
    self.navigationItem.title = [self.obj objectForKey:@"branchName"];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.contactLabel.text = @"หมายเลขภายใน";
        self.directionLabel.text = @"Get Direction";
    } else {
        self.contactLabel.text = @"หมายเลขภายใน";
        self.directionLabel.text = @"นำทาง";
    }
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.directionBt.layer setMasksToBounds:YES];
    [self.directionBt.layer setCornerRadius:5.0f];
    
    [self.addressView.layer setMasksToBounds:YES];
    [self.addressView.layer setCornerRadius:5.0f];
    
    self.ArrImgs = [[NSMutableArray alloc] init];
    self.arrcontactimg = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.imgscrollview addGestureRecognizer:singleTap];
    
    self.current = @"0";
    
    for (int i=0; i<[[self.obj objectForKey:@"pictures"] count]; ++i) {
        [self.arrcontactimg addObject:[[[self.obj objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"url"]];
    }
    
    self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    self.pageScrollView.delegate = self;
    [self.pageScrollView setScrollViewContents:[self imageToArray:self.obj]];
    self.pageScrollView.pageControlPos = PageControlPositionCenterBottom;
    [self.imgscrollview addSubview:self.pageScrollView];
    
    self.telephoneLabel.text = [self.obj objectForKey:@"branchTel"];
    self.faxLabel.text = [self.obj objectForKey:@"branchFax"];
    self.emailLabel.text = [self.obj objectForKey:@"branchEmail"];
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",[[self.obj objectForKey:@"location"] objectForKey:@"lat"],@",",[[self.obj objectForKey:@"location"] objectForKey:@"lng"],@"&zoom=16&size=560x240&sensor=false&markers=color:red%7Clabel:o%7C",[[self.obj objectForKey:@"location"] objectForKey:@"lat"],@",",[[self.obj objectForKey:@"location"] objectForKey:@"lng"]];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImg.image = [UIImage imageWithData:imgData];
                          }];
    self.addressLabel.text = [self.obj objectForKey:@"branchAddress"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PagedImageScrollView:(id)sender current:(NSString *)current{
    self.current = current;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    int sum;
    sum = [self.current intValue]/32;
    NSString *num = [NSString stringWithFormat:@"%d",sum];
    [self.delegate PFGalleryViewController:self sum:self.arrcontactimg current:num];
    
}

- (NSArray *)imageToArray:(NSDictionary *)images {
    int countPicture = [[images objectForKey:@"pictures"] count];
    for (int i = 0; i < countPicture; i++) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[images objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"url"]];
        
        [self.ArrImgs addObject:urlStr];
    }
    return self.ArrImgs;
}

- (IBAction)phoneTapped:(id)sender {
    
    NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",self.telephoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    
}

- (IBAction)branchphoneTapped:(id)sender {

    PFBranchTelephoneViewController *branchTelView = [[PFBranchTelephoneViewController alloc] init];
    if(IS_WIDESCREEN) {
        branchTelView = [[PFBranchTelephoneViewController alloc] initWithNibName:@"PFBranchTelephoneViewController_Wide" bundle:nil];
    } else {
        branchTelView = [[PFBranchTelephoneViewController alloc] initWithNibName:@"PFBranchTelephoneViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    branchTelView.delegate = self;
    branchTelView.obj = self.obj;
    [self.navigationController pushViewController:branchTelView animated:YES];
    
}

- (IBAction)emailTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        
        // Email Subject
        NSString *emailTitle = nil;
        // Email Content
        NSString *messageBody = nil;
        // To address
        NSArray *toRecipents = [self.emailLabel.text componentsSeparatedByString: @","];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:237.0f/255.0f green:28.0f/255.0f blue:36.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)getDirectionTapped:(id)sender {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    self.currentLocation = newLocation;
    CLLocationCoordinate2D location;
    
    location.latitude = [[[self.obj objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    location.longitude = [[[self.obj objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    [self.locationManager stopUpdatingLocation];
    [CMMapLauncher launchMapApp:CMMapAppAppleMaps
              forDirectionsFrom:[CMMapPoint mapPointWithName:@"Origin"
                                                  coordinate:newLocation.coordinate]
                             to:[CMMapPoint mapPointWithName:@"Destination"
                                                  coordinate:location]];
    return;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    /*
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
     */
}

- (IBAction)mapTapped:(id)sender {
    
    PFMapViewController *mapView = [[PFMapViewController alloc] init];
    if(IS_WIDESCREEN) {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
    } else {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController" bundle:nil];
    }
    self.navigationItem.title = @" ";
    mapView.delegate = self;
    mapView.status = @"branchdetail";
    mapView.obj = self.obj;
    mapView.lat = [[self.obj objectForKey:@"location"] objectForKey:@"lat"];
    mapView.lng = [[self.obj objectForKey:@"location"] objectForKey:@"lng"];
    [self.navigationController pushViewController:mapView animated:YES];
    
}

- (IBAction)powerbyTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

- (void)PFBranchTelephoneViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"branchName"];
}

- (void)PFMapViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"branchName"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFBranchDetailViewControllerBack)]){
            [self.delegate PFBranchDetailViewControllerBack];
        }
    }
    
}

@end
