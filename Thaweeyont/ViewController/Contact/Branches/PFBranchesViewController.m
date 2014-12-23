//
//  PFBranchesViewController.m
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFBranchesViewController.h"

@interface PFBranchesViewController ()

@end

@implementation PFBranchesViewController

BOOL loadBranch;
BOOL noDataBranch;
BOOL refreshDataBranch;

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
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getContactBranches];
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Our Branches";
    } else {
        self.navigationItem.title = @"สาขาของเรา";
    }
    
    loadBranch = NO;
    noDataBranch = NO;
    refreshDataBranch = NO;
    
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

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataBranch = YES;
    [self.Api getContactBranches];
    
}

- (void)PFApi:(id)sender getContactBranchesResponse:(NSDictionary *)response {
    //NSLog(@"contactBranch %@",response);
    
    [self.refreshControl endRefreshing];
    
    if (!refreshDataBranch) {
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
    
    [self.contactOffline setObject:response forKey:@"branchesArray"];
    [self.contactOffline synchronize];
    
    [self.tableView reloadData];

}

- (void)PFApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.refreshControl endRefreshing];
    
    if (!refreshDataBranch) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.contactOffline objectForKey:@"branchesArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.contactOffline objectForKey:@"branchesArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.contactOffline objectForKey:@"branchesArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.contactOffline objectForKey:@"branchesArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFBranchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFBranchesCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFBranchesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.branchName.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"branchName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PFBranchDetailViewController *branchesView = [[PFBranchDetailViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        branchesView = [[PFBranchDetailViewController alloc] initWithNibName:@"PFBranchDetailViewController_Wide" bundle:nil];
    } else {
        branchesView = [[PFBranchDetailViewController alloc] initWithNibName:@"PFBranchDetailViewController" bundle:nil];
    }
    branchesView.delegate = self;
    branchesView.obj = [self.arrObj objectAtIndex:indexPath.row];
    self.navigationItem.title = @" ";
    [self.navigationController pushViewController:branchesView animated:YES];
    
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFBranchDetailViewControllerBack {
    
    [self.Api getContactBranches];
    
    if (![[self.Api getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Our Branches";
    } else {
        self.navigationItem.title = @"สาขาของเรา";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFBranchesViewControllerBack)]){
            [self.delegate PFBranchesViewControllerBack];
        }
    }
    
}

@end
