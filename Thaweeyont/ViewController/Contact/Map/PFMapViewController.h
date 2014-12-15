//
//  PFMapViewController.h
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

#import "PFApi.h"

#import "PFBranchDetailViewController.h"

@protocol PFMapViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFMapViewControllerBack;

@end

@interface PFMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet PFMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@property (strong, nonatomic) NSString *status;

@end
