//
//  PFDetailFoldertypeViewController.m
//  Thaweeyont
//
//  Created by Pariwat Promjai on 11/4/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFDetailFoldertypeViewController.h"

@interface PFDetailFoldertypeViewController ()

@end

@implementation PFDetailFoldertypeViewController

BOOL loadFolder;
BOOL noDataFolder;
BOOL refreshDataFolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.foldertypeOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    loadFolder = NO;
    noDataFolder = NO;
    refreshDataFolder = NO;
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    self.tableView.tableHeaderView = hv;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.ThaweeyontApi = [[PFThaweeyontApi alloc] init];
    self.ThaweeyontApi.delegate = self;
    
    [self.ThaweeyontApi getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFThaweeyontApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataFolder) {
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
        noDataFolder = YES;
    } else {
        noDataFolder = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.foldertypeOffline setObject:response forKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    [self.foldertypeOffline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFThaweeyontApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataFolder) {
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFFoldertypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertypeCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertypeCell" owner:self options:nil];
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
        
        return cell;
        
    } else {
        
        PFCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFCatalogCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFCatalogCell" owner:self options:nil];
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
        NSString *price = [[NSString alloc] initWithFormat:@"%@ %@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"],@"Baht"];
        cell.price.text = price;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"item"]) {
        
        PFCatalogDetailViewController *catalogDetail = [[PFCatalogDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            catalogDetail = [[PFCatalogDetailViewController alloc] initWithNibName:@"PFCatalogDetailViewController_Wide" bundle:nil];
        } else {
            catalogDetail = [[PFCatalogDetailViewController alloc] initWithNibName:@"PFCatalogDetailViewController" bundle:nil];
        }
        self.navigationItem.title = @" ";
        catalogDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
        catalogDetail.delegate = self;
        [self.navigationController pushViewController:catalogDetail animated:YES];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
        
        if ([children_length isEqualToString:@"0"]) {
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reload:) userInfo:nil repeats:NO];
            
            if (![[self.ThaweeyontApi getLanguage] isEqualToString:@"TH"]) {
                [[[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"ทวียนต์!"
                                            message:@"เร็วๆ นี้."
                                           delegate:nil
                                  cancelButtonTitle:@"ตกลง"
                                  otherButtonTitles:nil] show];
            }
            
        } else {
            
            PFDetailFoldertype1ViewController *folderDetail = [[PFDetailFoldertype1ViewController alloc] init];
            if(IS_WIDESCREEN) {
                folderDetail = [[PFDetailFoldertype1ViewController alloc] initWithNibName:@"PFDetailFoldertype1ViewController_Wide" bundle:nil];
            } else {
                folderDetail = [[PFDetailFoldertype1ViewController alloc] initWithNibName:@"PFDetailFoldertype1ViewController" bundle:nil];
            }
            self.navigationItem.title = @" ";
            folderDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
            folderDetail.delegate = self;
            [self.navigationController pushViewController:folderDetail animated:YES];
        }
        
    }
    
}

-(void)reload:(NSTimer *)timer
{
    [self.tableView reloadData];
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
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@" "];
        self.act.alpha = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataFolder = YES;
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha = 1;
        
        [self.ThaweeyontApi getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        self.tableView.frame = CGRectMake(0, 60, self.tableView.frame.size.width, self.tableView.frame.size.height);
        [UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha = 1;

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataFolder) {
            refreshDataFolder = NO;
            
            [self.ThaweeyontApi getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFDetailFoldertype1ViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    [self.tableView reloadData];
}

- (void)PFCatalogDetailViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFDetailFoldertypeViewControllerBack)]){
            [self.delegate PFDetailFoldertypeViewControllerBack];
        }
    }
}

@end
