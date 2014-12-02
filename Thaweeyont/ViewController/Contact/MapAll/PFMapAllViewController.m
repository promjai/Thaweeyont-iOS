//
//  PFMapAllViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/10/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFMapAllViewController.h"

@interface PFMapAllViewController ()

@end

@implementation PFMapAllViewController

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
    
    self.ThaweeyontApi = [[PFThaweeyontApi alloc] init];
    self.ThaweeyontApi.delegate = self;
    
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Map";
    } else {
        self.navigationItem.title = @"แผนที่";
    }
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.obj = [[NSDictionary alloc] init];
    
    [self.ThaweeyontApi getContactBranches];
    
    self.allmapView.delegate = self;
    self.allmapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFThaweeyontApi:(id)sender getContactBranchesResponse:(NSDictionary *)response {
    //NSLog(@"contactBranch %@",response);
    
    for (int i=0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        
        NSString *getlat = [NSString stringWithFormat:@"%@", [[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"]];
        
        NSString *getlng = [NSString stringWithFormat:@"%@", [[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"]];
        
        NSString *getname = [NSString stringWithFormat:@"%@", [[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"branchName"]];
        
        //
        CLLocationCoordinate2D location;
        location.latitude = [getlat doubleValue];
        location.longitude = [getlng doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = location;
        point.title = getname;
        
        [self.allmapView addAnnotation:point];
        [self.allmapView setCenterCoordinate:location zoomLevel:5 animated:NO];
        //
        
    }
}

- (void)PFThaweeyontApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    MKPointAnnotation *selectedAnnotation = view.annotation;
    self.lat = [[NSString alloc] initWithFormat:@"%f",selectedAnnotation.coordinate.latitude];
    self.lng = [[NSString alloc] initWithFormat:@"%f",selectedAnnotation.coordinate.longitude];
    
    for (int i=0; i < [self.arrObj count]; i++) {
        
        self.chklat = [[[[self.arrObj objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"] substringToIndex:9];
        self.chklng = [[[[self.arrObj objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"] substringToIndex:9];

        
        if ([self.chklat isEqualToString:self.lat] && [self.chklng isEqualToString:self.lng]) {
            
            self.obj = [self.arrObj objectAtIndex:i];
            
        }
        
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [view addGestureRecognizer:singleTap];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    PFBranchDetailViewController *branchesView = [[PFBranchDetailViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        branchesView = [[PFBranchDetailViewController alloc] initWithNibName:@"PFBranchDetailViewController_Wide" bundle:nil];
    } else {
        branchesView = [[PFBranchDetailViewController alloc] initWithNibName:@"PFBranchDetailViewController" bundle:nil];
    }
    branchesView.delegate = self;
    branchesView.obj = self.obj;
    self.navigationItem.title = @" ";
    [self.navigationController pushViewController:branchesView animated:YES];
    
}

//full image
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFBranchDetailViewControllerBack {
    
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Map";
    } else {
        self.navigationItem.title = @"แผนที่";
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFMapAllViewControllerBack)]){
            [self.delegate PFMapAllViewControllerBack];
        }
    }
}

@end
