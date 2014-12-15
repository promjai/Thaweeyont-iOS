//
//  PFCouponViewController.m
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFCouponViewController.h"

@interface PFCouponViewController ()

@end

@implementation PFCouponViewController

BOOL loadCoupon;
BOOL noDataCoupon;
BOOL refreshDataCoupon;

int couponInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.couponOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.waitView];
    [self startSpin];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getCoupon:@"15" link:@"NO"];
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Coupon";
    } else {
        self.navItem.title = @"คูปอง";
    }
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:237.0f/255.0f green:28.0f/255.0f blue:36.0f/255.0f alpha:1.0f]];
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = fv;
    
    loadCoupon = NO;
    noDataCoupon = NO;
    refreshDataCoupon = NO;
    
    [self.couponOffline setObject:@"0" forKey:@"coupon_updated"];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)startSpin
{
    if (!self.popupProgressBar) {
        
        if(IS_WIDESCREEN) {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(145, 269, 30, 30)];
            self.popupProgressBar.image = [UIImage imageNamed:@"ic_loading"];
            [self.waitView addSubview:self.popupProgressBar];
        } else {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(145, 225, 30, 30)];
            self.popupProgressBar.image = [UIImage imageNamed:@"ic_loading"];
            [self.waitView addSubview:self.popupProgressBar];
        }
        
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGRect frame = [self.popupProgressBar frame];
    self.popupProgressBar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.popupProgressBar.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:1.0] forKey:kCATransactionAnimationDuration];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [self.popupProgressBar.layer addAnimation:animation forKey:@"rotationAnimation"];
    
    [CATransaction commit];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (finished)
    {
        
        [self startSpin];
        
    }
}

- (void)PFApi:(id)sender getCouponResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.obj = response;
    
    if (!refreshDataCoupon) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataCoupon = YES;
    } else {
        noDataCoupon = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.couponOffline setObject:response forKey:@"couponArray"];
    [self.couponOffline synchronize];
    
    if ([[self.couponOffline objectForKey:@"coupon_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.couponOffline setObject:[response objectForKey:@"last_updated"] forKey:@"coupon_updated"];
    }
    
}

- (void)PFApi:(id)sender getCouponErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    couponInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataCoupon) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.couponOffline objectForKey:@"coupon_updated"] intValue] != [[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.couponOffline setObject:[[self.couponOffline objectForKey:@"couponArray"] objectForKey:@"last_updated"] forKey:@"coupon_updated"];
    }
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataCoupon = YES;
    [self.Api getCoupon:@"15" link:@"NO"];
    
}

- (void)countDown {
    couponInt -= 1;
    if (couponInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFCouponCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFCouponCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.NoInternetView removeFromSuperview];
    
    [self.delegate HideTabbar];
    
    PFCouponDetailViewController *couponView = [[PFCouponDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        couponView = [[PFCouponDetailViewController alloc] initWithNibName:@"PFCouponDetailViewController_Wide" bundle:nil];
    } else {
        couponView = [[PFCouponDetailViewController alloc] initWithNibName:@"PFCouponDetailViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    couponView.obj = [self.arrObj objectAtIndex:indexPath.row];
    couponView.checkinternet = self.checkinternet;
    couponView.delegate = self;
    [self.navController pushViewController:couponView animated:YES];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataCoupon) {
            refreshDataCoupon = NO;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.Api getCoupon:@"NO" link:self.paging];
            }
            
        }
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFCouponDetailViewControllerBack {
    
    [self.delegate ShowTabbar];
    [self.tableView reloadData];
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Coupon";
    } else {
        self.navItem.title = @"คูปอง";
    }
    
}

@end
