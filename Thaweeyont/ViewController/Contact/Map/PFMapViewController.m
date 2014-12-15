//
//  PFMapViewController.m
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFMapViewController.h"

@interface PFMapViewController ()

@end

@implementation PFMapViewController

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
    static NSString *AnnotationViewID = @"PFMapViewController";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
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
    if (annotation == self.mapView.userLocation) {
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
    
    CLLocationCoordinate2D location;
    location.latitude = [self.lat doubleValue];
    location.longitude = [self.lng doubleValue];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    point.title = [self.obj objectForKey:@"branchName"];
    
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:NO];
    [self.mapView setCenterCoordinate:location zoomLevel:5 animated:NO];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
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

- (void)getDistance {

    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate PFMapViewControllerBack];

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
        if([self.delegate respondsToSelector:@selector(PFMapViewControllerBack)]){
            [self.delegate PFMapViewControllerBack];
        }
    }
}

@end
