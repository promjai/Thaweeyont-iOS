//
//  PFUpdateViewController.m
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadFeed;
BOOL noDataFeed;
BOOL refreshDataFeed;

int updateInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.feedOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.waitView];
    [self startSpin];
    
    self.ThaweeyontApi = [[PFThaweeyontApi alloc] init];
    self.ThaweeyontApi.delegate = self;
    
    [self.ThaweeyontApi getFeed:@"15" link:@"NO"];
    
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:237.0f/255.0f green:28.0f/255.0f blue:36.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    [self.ThaweeyontApi checkBadge];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkN:) userInfo:nil repeats:YES];
    
    [self BarButtonItem];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = hv;
    self.tableView.tableFooterView = fv;
    
    loadFeed = NO;
    noDataFeed = NO;
    refreshDataFeed = NO;
    
    [self.feedOffline setObject:@"0" forKey:@"feed_updated"];
    
    self.arrObj = [[NSMutableArray alloc] init];
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
    self.statusProgress = @"startSpin";
    
    if (!self.popupProgressBar) {
        
        if(IS_WIDESCREEN) {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(150, 274, 20, 20)];
            self.popupProgressBar.image = [UIImage imageNamed:@"ic_loading"];
            [self.waitView addSubview:self.popupProgressBar];
        } else {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(150, 230, 20, 20)];
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

- (void)startPullToRefresh
{
    
    self.statusProgress = @"startPullToRefresh";
    
    if (!self.progressBar) {
        
        self.progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(150, 81, 20, 20)];
        self.progressBar.image = [UIImage imageNamed:@"ic_loading"];
        [self.view addSubview:self.progressBar];
        
    }
    
    self.progressBar.hidden = NO;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGRect frame = [self.progressBar frame];
    self.progressBar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.progressBar.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
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
    [self.progressBar.layer addAnimation:animation forKey:@"rotationAnimation"];
    
    [CATransaction commit];
}

- (void)stopPullToRefresh
{
    [self.progressBar.layer removeAllAnimations];
    self.progressBar.hidden = YES;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (finished)
    {
        
        if ([self.statusProgress isEqualToString:@"startSpin"]) {
            [self startSpin];
        } else {
            [self startPullToRefresh];
        }
        
    }
}

-(void)checkN:(NSTimer *)timer
{
    if ([self.ThaweeyontApi checkLogin] == 1){
        [self.ThaweeyontApi checkBadge];
    }
}

- (void)PFThaweeyontApi:(id)sender checkBadgeResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    //NSLog(@"badge %@",[response objectForKey:@"length"]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *badge = [[NSString alloc] initWithFormat:@"%@",[defaults objectForKey:@"badge"]];
    
    //NSLog(@"badge %@",badge);
    
    if ([[defaults objectForKey:@"badge"] intValue] != [[response objectForKey:@"length"] intValue]) {
        
        [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
        [defaults synchronize];
        [self BarButtonItem];
        
    }
    
}
- (void)PFThaweeyontApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];
}

-(void)BarButtonItem {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *badge = [[NSString alloc] initWithFormat:@"%@",[def objectForKey:@"badge"]];
    
    //notification if (noti = 0) else
    if ([[def objectForKey:@"badge"] intValue] == 0) {
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_notification"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
        self.navItem.rightBarButtonItem = rightButton;
        
    } else {
        
        UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [customButton addTarget:self action:@selector(notify) forControlEvents:UIControlEventTouchUpInside];
        [customButton setImage:[UIImage imageNamed:@"ic_notification"] forState:UIControlStateNormal];
        BBBadgeBarButtonItem *rightButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
        rightButton.badgeValue = badge;
        self.navItem.rightBarButtonItem = rightButton;
        
    }
    
    self.navItem.leftBarButtonItem = leftButton;
}

- (void)account {
    
    if ([self.ThaweeyontApi checkLogin] == 0){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"account";
        [self.view addSubview:self.loginView.view];
        
    } else{
    
        [self.delegate HideTabbar];
        
        PFAccountViewController *account = [[PFAccountViewController alloc] init];
        if(IS_WIDESCREEN) {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
        } else {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
        }
        account.delegate = self;
        self.navItem.title = @" ";
        [self.navController pushViewController:account animated:YES];
        
    }
    
}

- (void)PFAccountViewController:(id)sender{
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFAccountViewController *account = [[PFAccountViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
    } else {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
    }
    account.delegate = self;
    [self.navController pushViewController:account animated:YES];
    
}

- (void)notify {
    
    if ([self.ThaweeyontApi checkLogin] == 0){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"notify";
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        [self.delegate HideTabbar];
        
        PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
        } else {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
        }
        
        notify.delegate = self;
        self.navItem.title = @" ";
        [self.navController pushViewController:notify animated:YES];
        
    }

}

- (void)PFNotificationViewController:(id)sender {
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    notify.delegate = self;
    [self.navController pushViewController:notify animated:YES];
    
}

- (void)PFThaweeyontApi:(id)sender getFeedResponse:(NSDictionary *)response {
    //NSLog(@"feed %@",response);
    
    [self.waitView removeFromSuperview];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.obj = response;
    
    if (!refreshDataFeed) {
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
        noDataFeed = YES;
    } else {
        noDataFeed = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.feedOffline setObject:response forKey:@"feedArray"];
    [self.feedOffline synchronize];
    
    if ([[self.feedOffline objectForKey:@"feed_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self reloadData:YES];
        [self.feedOffline setObject:[response objectForKey:@"last_updated"] forKey:@"feed_updated"];
    }

}

- (void)PFThaweeyontApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    updateInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataFeed) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.feedOffline objectForKey:@"feed_updated"] intValue] != [[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"last_updated"] intValue]) {
        [self reloadData:YES];
        [self.feedOffline setObject:[[self.feedOffline objectForKey:@"feedArray"]objectForKey:@"last_updated"] forKey:@"feed_updated"];
    }
}

- (void)countDown {
    updateInt -= 1;
    if (updateInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataFeed){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    PFUpdateDetailViewController *detailView = [[PFUpdateDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
    } else {
        detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    detailView.obj = [self.arrObj objectAtIndex:indexPath.row];
    detailView.delegate = self;
    [self.navController pushViewController:detailView animated:YES];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f",scrollView.contentOffset.y);
    //[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y < 0.0f ) {
        //NSLog(@"refreshData < 0.0f");
        
        [self stopPullToRefresh];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        
        //[self stopPullToRefresh];

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        
        refreshDataFeed = YES;
        [self startPullToRefresh];
        [self.ThaweeyontApi getFeed:@"15" link:@"NO"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        self.tableView.frame = CGRectMake(0, 50, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            
            [self startPullToRefresh];
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataFeed) {
            refreshDataFeed = NO;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.ThaweeyontApi getFeed:@"NO" link:self.paging];
            }
            
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    [UIView commitAnimations];
    [self stopPullToRefresh];
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFAccountViewControllerBack {
    
    [self.delegate ShowTabbar];
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
    
    if ([[self.ThaweeyontApi getReset] isEqualToString:@"YES"]) {
        [self.delegate resetApp];
    }
    
}

- (void)PFUpdateDetailViewControllerBack {
    
    [self.delegate ShowTabbar];
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
    
}

- (void)PFNotificationViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
}

@end
