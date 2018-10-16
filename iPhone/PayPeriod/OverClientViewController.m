//
//  OverClientViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 11/26/13.
//
//

#import "OverClientViewController.h"

#import "AppDelegate_Shared.h"




@implementation OverClientViewController


@synthesize myTableView;

@synthesize clientList;
@synthesize selectClient;
@synthesize delegate;

@synthesize regularView;
@synthesize regularRateLbel;

@synthesize dailyView;
@synthesize monRateLbel;
@synthesize tueRateLbel;
@synthesize wedRateLbel;
@synthesize thuRateLbel;
@synthesize friRateLbel;
@synthesize satRateLbel;
@synthesize sunRateLbel;

#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        clientList = [[NSMutableArray alloc] init];
        self.selectClient = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backAndSave) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Client"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    
    NSArray *requests = [appDelegate getAllClient];
    for (int i=0; i<[requests count]; i++)
    {
        Clients *client = [requests objectAtIndex:i];
        [self.clientList addObject:client];
    }
    
    if (IS_IPHONE_6PLUS)
    {
        self.regularratelabel1.left = 20;
        self.regularRateLbel.left = self.regularRateLbel.left - 5;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    [self.delegate saveSelectClient:self.selectClient];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initSelectClientView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
-(void)initSelectClientView
{
    [self.myTableView reloadData];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (self.selectClient != nil)
    {
        if (self.selectClient.r_isDaily.intValue == 1)
        {
            self.monRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_monRate];
            self.tueRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_tueRate];
            self.wedRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_wedRate];
            self.thuRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_thuRate];
            self.friRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_friRate];
            self.satRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_satRate];
            self.sunRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.r_sunRate];
            [self.regularView setHidden:YES];
            [self.dailyView setHidden:NO];
            
            self.myTableView.frame = CGRectMake(0, self.dailyView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.dailyView.frame.size.height);
        }
        else
        {
            self.regularRateLbel.text = [appDelegate appMoneyShowStly:self.selectClient.ratePerHour];
            [self.regularView setHidden:NO];
            [self.dailyView setHidden:YES];
            
            self.myTableView.frame = CGRectMake(0, self.regularView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.regularView.frame.size.height);
        }
        
        NSInteger rownum = [self.clientList indexOfObject:self.selectClient];
        NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:rownum inSection:0];
        [self.myTableView scrollToRowAtIndexPath:sel_indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else
    {
        self.regularRateLbel.text = [appDelegate appMoneyShowStly:ZERO_NUM];
        [self.regularView setHidden:NO];
        [self.dailyView setHidden:YES];
        
        self.myTableView.frame = CGRectMake(0, self.regularView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.regularView.frame.size.height);
    }
}




-(void)backAndSave
{
    [self.delegate saveSelectClient:self.selectClient];
	[self.navigationController popViewControllerAnimated:YES];
}






#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.clientList count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:61.0/255.0 green:63.0/255.0 blue:64.0/255.0 alpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    
    
    
    Clients *client = [self.clientList objectAtIndex:indexPath.row];
    cell.textLabel.text = client.clientName;
    
    
    if ([self.clientList indexOfObject:self.selectClient] != NSNotFound)
    {
        if (indexPath.row == [self.clientList indexOfObject:self.selectClient])
        {
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
        }
        else
        {
            cell.accessoryView = nil;
        }
    }
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectClient = [self.clientList objectAtIndex:indexPath.row];
    [self initSelectClientView];
}



@end

