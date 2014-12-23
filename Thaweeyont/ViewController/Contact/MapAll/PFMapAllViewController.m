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

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"PFMapAllViewController";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.allmapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.canShowCallout = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(getDistance) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    /*
     UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_location.png"]];
     annotationView.leftCalloutAccessoryView = myCustomImage;
     */
    if (annotation == self.allmapView.userLocation) {
        return nil;
    } else {
        annotationView.image = [UIImage imageNamed:@"pin_map.png"];
    }
    //add any image which you want to show on map instead of red pins
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Map";
    } else {
        self.navigationItem.title = @"แผนที่";
    }
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.obj = [[NSDictionary alloc] init];
    
    [self.Api getContactBranches];
    
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

-(CLLocationCoordinate2D) getLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (void)PFApi:(id)sender getContactBranchesResponse:(NSDictionary *)response {
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
        
    }
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    CLLocationCoordinate2D mylocation;
    mylocation.latitude = [latitude doubleValue];
    mylocation.longitude = [longitude doubleValue];
    
    [self.allmapView setCenterCoordinate:mylocation zoomLevel:6 animated:NO];
    
}

- (void)PFApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    MKPointAnnotation *selectedAnnotation = view.annotation;
    
    for (int i=0; i < [self.arrObj count]; i++) {
        
        if ([selectedAnnotation.title isEqualToString:[[self.arrObj objectAtIndex:i] objectForKey:@"branchName"]]) {
            
            self.obj = [self.arrObj objectAtIndex:i];
            
        }
        
    }
    
}

- (void)getDistance {
    
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
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
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
