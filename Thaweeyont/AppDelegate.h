//
//  AppDelegate.h
//  Thaweeyont
//
//  Created by Promjai on 10/15/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

#import "TabBarViewController.h"

#import "PFUpdateViewController.h"
#import "PFProductViewController.h"
#import "PFCouponViewController.h"
#import "PFContactViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) TabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFProductViewController *product;
@property (strong, nonatomic) PFCouponViewController *coupon;
@property (strong, nonatomic) PFContactViewController *contact;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
