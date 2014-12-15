//
//  PFMapAllViewController.h
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/10/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

#import "PFApi.h"

#import "PFBranchDetailViewController.h"

@protocol PFMapAllViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFMapAllViewControllerBack;

@end

@interface PFMapAllViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (retain, nonatomic) IBOutlet PFMapView *allmapView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;

@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) NSString *locationSum;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@property (strong, nonatomic) NSString *chklat;
@property (strong, nonatomic) NSString *chklng;

@end
