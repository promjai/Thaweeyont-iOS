//
//  PFBranchTelephoneViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/7/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFBranchTelephoneViewController.h"

@interface PFBranchTelephoneViewController ()

@end

@implementation PFBranchTelephoneViewController

BOOL loadTel;
BOOL noDataTel;
BOOL refreshDataTel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.contactOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"หมายเลขภายใน";
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getBranchTelephone:[self.obj objectForKey:@"id"]];
    
    loadTel = NO;
    noDataTel = NO;
    refreshDataTel = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.waitView];
    [self startSpin];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = hv;
    
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

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (finished)
    {
        
        [self startSpin];
        
    }
}

- (void)PFApi:(id)sender getBranchTelephoneResponse:(NSDictionary *)response{
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    [self.contactOffline setObject:response forKey:@"branchTelArray"];
    [self.contactOffline synchronize];
    
    if (!refreshDataTel) {
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
        noDataTel = YES;
    } else {
        noDataTel = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.tableView reloadData];
}

- (void)PFApi:(id)sender getBranchTelephoneErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];

    if (!refreshDataTel) {
        for (int i=0; i<[[[self.contactOffline objectForKey:@"branchTelArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.contactOffline objectForKey:@"branchTelArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.contactOffline objectForKey:@"branchTelArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.contactOffline objectForKey:@"branchTelArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFBranchTelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFBranchTelCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFBranchTelCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.brach.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.tel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"tel"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reload:) userInfo:nil repeats:NO];
    
    NSString *branch = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"tel"]];
    NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@%@%@",[self.obj objectForKey:@"branchTel"],@",",branch];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    
}

-(void)reload:(NSTimer *)timer
{
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFBranchTelephoneViewControllerBack)]){
            [self.delegate PFBranchTelephoneViewControllerBack];
        }
    }
    
}

@end
