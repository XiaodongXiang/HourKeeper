//
//  PayEndStlyViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//

#import "PayEndStlyViewController.h"
#import "AppDelegate_Shared.h"
#import "PayEndFlagViewController.h"
#import "PayEndTimeViewController.h"




@implementation PayEndStlyViewController



@synthesize myTableView;
@synthesize payStlyArray;
@synthesize selectStly;
@synthesize clientDelegate;
@synthesize clientDelegate_ipad;






#pragma mark -
#pragma mark Memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Pay Setting"];

    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    
	self.payStlyArray = [[NSMutableArray alloc] initWithObjects:
                 @"Weekly",@"Bi-weekly",
				 @"Semi-monthly",@"Monthly",
				 @"Every Four Weeks",
                 @"Quarterly",
				 nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.payStlyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *timeStr = [self.payStlyArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [timeStr capitalizedString];
    [cell.textLabel setTextColor:[UIColor colorWithRed:61.0/255.0 green:63.0/255.0 blue:64.0/255.0 alpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    

	if (indexPath.row+1 == self.selectStly)
    {
		UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
        cell.accessoryView = accImageView;
	}
    else
    {
        cell.accessoryView = nil;
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置选择的是哪一种支付模式 从1开始
	self.selectStly = (int)(indexPath.row+1);
    
    [self.myTableView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (self.selectStly == 2 || self.selectStly == 5 || self.selectStly == 6)
        {
            PayEndTimeViewController *payTimeView = [[PayEndTimeViewController alloc] initWithNibName:@"PayEndTimeViewController_ipad" bundle:nil];
            
            payTimeView.clientDelegate_ipad = self.clientDelegate_ipad;
            payTimeView.payStly = self.selectStly;
            
            [self.navigationController pushViewController:payTimeView animated:YES];
            
        }
        else
        {
            PayEndFlagViewController *payFlagView = [[PayEndFlagViewController alloc] initWithNibName:@"PayEndFlagViewController_ipad" bundle:nil];
            
            payFlagView.clientDelegate_ipad = self.clientDelegate_ipad;
            payFlagView.payStly = self.selectStly;
            
            [self.navigationController pushViewController:payFlagView animated:YES];
            
        }
    }
    else
    {
        //Bi-Weekly,Every Four Weeks,Quarterly 参数是时间
        if (self.selectStly == 2 || self.selectStly == 5 || self.selectStly == 6)
        {
            PayEndTimeViewController *payTimeView = [[PayEndTimeViewController alloc] initWithNibName:@"PayEndTimeViewController" bundle:nil];
            
            payTimeView.clientDelegate = self.clientDelegate;
            payTimeView.payStly = self.selectStly;
            
            [self.navigationController pushViewController:payTimeView animated:YES];
            
        }
        //Weekly,Semi-Monthly,Monthly 参数是数字，星期也是用数字标识的，Sunday:1，3，4
        else
        {
            PayEndFlagViewController *payFlagView = [[PayEndFlagViewController alloc] initWithNibName:@"PayEndFlagViewController" bundle:nil];
            
            payFlagView.clientDelegate = self.clientDelegate;
            payFlagView.payStly = self.selectStly;
            
            [self.navigationController pushViewController:payFlagView animated:YES];
            
        }
    }
    
}




@end
