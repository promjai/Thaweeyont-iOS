//
//  PFPromotionDetailViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/5/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFPromotionDetailViewController.h"

@interface PFPromotionDetailViewController ()

@end

@implementation PFPromotionDetailViewController

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
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullimage:)];
    [self.thumbnails addGestureRecognizer:singleTap];
    [self.thumbnails setMultipleTouchEnabled:YES];
    [self.thumbnails setUserInteractionEnabled:YES];
    
    self.thumbnails.layer.masksToBounds = YES;
    self.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"],@"?width=640&height=420"];
    
    NSString *getheight = [[self.obj objectForKey:@"thumb"] objectForKey:@"height"];
    int height = [getheight intValue];
    
    NSString *getwidth = [[self.obj objectForKey:@"thumb"] objectForKey:@"width"];
    int width = [getwidth intValue];
    
    if (width == 320) {
        
        self.thumbnails.frame = CGRectMake(self.thumbnails.frame.origin.x, self.thumbnails.frame.origin.y, 320, height);
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  self.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        //name
        self.name.text = [self.obj objectForKey:@"name"];
        
        CGRect frameName = self.name.frame;
        frameName.size = [self.name sizeOfMultiLineLabel];
        [self.name sizeOfMultiLineLabel];
        
        [self.name setFrame:frameName];
        int linesName = self.name.frame.size.height/15;
        self.name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(190, 30, 45);
        descTextName.text = self.name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.name.alpha = 0;
        [self.footerView addSubview:descTextName];
        
        //detail
        self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y+self.name.frame.size.height-20, self.detail.frame.size.width, self.detail.frame.size.height);
        
        self.detail.text = [self.obj objectForKey:@"detail"];
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.footerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+height-10);
        
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height+self.name.frame.size.height+self.detail.frame.size.height-10);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
    } else {
        
        int sumheight = (height*320)/width;
        
        self.thumbnails.frame = CGRectMake(self.thumbnails.frame.origin.x, self.thumbnails.frame.origin.y, 320, sumheight);
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  self.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        //name
        self.name.text = [self.obj objectForKey:@"name"];
        
        CGRect frameName = self.name.frame;
        frameName.size = [self.name sizeOfMultiLineLabel];
        [self.name sizeOfMultiLineLabel];
        
        [self.name setFrame:frameName];
        int linesName = self.name.frame.size.height/15;
        self.name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(190, 30, 45);
        descTextName.text = self.name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.name.alpha = 0;
        [self.footerView addSubview:descTextName];
        
        //detail
        self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y+self.name.frame.size.height-20, self.detail.frame.size.width, self.detail.frame.size.height);
        
        self.detail.text = [self.obj objectForKey:@"detail"];
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.footerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+sumheight-10);
        
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y, self.footerView.frame.size.width, self.footerView.frame.size.height+self.detail.frame.size.height-10);
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)share {
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:[[self.obj objectForKey:@"node"] objectForKey:@"share"]];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nil, @"name",
                                       nil, @"caption",
                                       nil, @"description",
                                       [[self.obj objectForKey:@"node"] objectForKey:@"share"], @"link",
                                       nil, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }

}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)fullimage:(UIGestureRecognizer *)gesture {
    [self.delegate PFImageViewController:self viewPicture:self.thumbnails.image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFPromotionDetailViewControllerBack)]){
            [self.delegate PFPromotionDetailViewControllerBack];
        }
    }
}

@end
