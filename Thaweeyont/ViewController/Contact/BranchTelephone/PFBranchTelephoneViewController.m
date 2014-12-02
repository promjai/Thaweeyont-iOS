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
    
    self.ThaweeyontApi = [[PFThaweeyontApi alloc] init];
    self.ThaweeyontApi.delegate = self;
    
    [self.ThaweeyontApi getBranchTelephone:[self.obj objectForKey:@"id"]];
    
    loadTel = NO;
    noDataTel = NO;
    refreshDataTel = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
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

- (void)PFThaweeyontApi:(id)sender getBranchTelephoneResponse:(NSDictionary *)response{
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

- (void)PFThaweeyontApi:(id)sender getBranchTelephoneErrorResponse:(NSString *)errorResponse {
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
