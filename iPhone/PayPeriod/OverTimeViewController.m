//
//  OverTimeViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 11/26/13.
//
//

#import "OverTimeViewController.h"

#import "AppDelegate_Shared.h"



@implementation OverTimeViewController


@synthesize myTableView;

@synthesize clientCell;
@synthesize clientNameLbel;
@synthesize sel_client;
@synthesize dateStly;

@synthesize dateCell;
@synthesize dateLbel;
@synthesize startDate;
@synthesize endDate;

@synthesize totalTimeLbel;
@synthesize totalMoneyLbel;

@synthesize totalCell;
@synthesize day1Lbel;
@synthesize day2Lbel;
@synthesize week1Lbel;
@synthesize week2Lbel;
@synthesize lineImageV;


#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sel_client = nil;
        self.startDate = [NSDate date];
        self.endDate =  nil;
        self.dateStly = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        backButton.frame = CGRectMake(0, 0, 56, 30);
        [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        backButton.titleLabel.font = appDelegate.naviFont;
        backButton.frame = CGRectMake(0, 0, 60, 30);
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Overtime Pay"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    [self.lineImageV setImage:[UIImage imageNamed:@"line_1.png"]];
    
    [self initData];
    
    
    [Flurry logEvent:@"2_PPD_OTCALR"];
    
    if (IS_IPHONE_6PLUS)
    {
        float left = 20;
        self.clientlabel1.left = left;
        self.datelabel1.left = left;
    }
    self.line1.top = 44-SCREEN_SCALE;
    self.line1.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    
    [self doCalculate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Action
-(void)back
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)initData
{
    if (self.sel_client != nil && self.sel_client.clientName != nil)
    {
        [self saveSelectDate:self.startDate second:self.endDate dateStly:self.dateStly];
        self.clientNameLbel.text = self.sel_client.clientName;
        
        NSMutableString *firstText = [NSMutableString stringWithString:self.sel_client.dailyOverFirstTax];
        [firstText appendString:@" after "];
        [firstText appendString:self.sel_client.dailyOverFirstHour];
        [firstText appendString:@"h"];
        firstText = (NSMutableString *)[firstText lowercaseString];
        self.day1Lbel.text = firstText;
        
        NSMutableString *secondText = [NSMutableString stringWithString:self.sel_client.dailyOverSecondTax];
        [secondText appendString:@" after "];
        [secondText appendString:self.sel_client.dailyOverSecondHour];
        [secondText appendString:@"h"];
        secondText = (NSMutableString *)[secondText lowercaseString];
        self.day2Lbel.text = secondText;
        
        NSMutableString *firstText2 = [NSMutableString stringWithString:self.sel_client.weeklyOverFirstTax];
        [firstText2 appendString:@" after "];
        [firstText2 appendString:self.sel_client.weeklyOverFirstHour];
        [firstText2 appendString:@"h"];
        firstText2 = (NSMutableString *)[firstText2 lowercaseString];
        self.week1Lbel.text = firstText2;
        
        NSMutableString *secondText2 = [NSMutableString stringWithString:self.sel_client.weeklyOverSecondTax];
        [secondText2 appendString:@" after "];
        [secondText2 appendString:self.sel_client.weeklyOverSecondHour];
        [secondText2 appendString:@"h"];
        secondText2 = (NSMutableString *)[secondText2 lowercaseString];
        self.week2Lbel.text = secondText2;
    }
    else
    {
        self.clientNameLbel.text = @"";
        self.dateLbel.text = @"";
        self.day1Lbel.text = @"";
        self.day2Lbel.text = @"";
        self.week1Lbel.text = @"";
        self.week2Lbel.text = @"";
    }
}

-(void)doCalculate
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if (self.startDate != nil && self.sel_client != nil && self.sel_client.clientName != nil)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *end = nil;
        NSDate *start = nil;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&start interval:NULL forDate:self.startDate];
        

        NSMutableArray *allLog = [[NSMutableArray alloc] init];
        if (self.dateStly == 0)
        {
            end = [start dateByAddingTimeInterval:(NSTimeInterval)24*3600];
        }
        else
        {
            [calendar rangeOfUnit:NSDayCalendarUnit startDate:&end interval:NULL forDate:self.endDate];
            end = [end dateByAddingTimeInterval:(NSTimeInterval)24*3600];
        }
        [allLog addObjectsFromArray:[appDelegate getOverTime_Log:self.sel_client startTime:start endTime:end isAscendingOrder:NO]];
        
        NSArray *backArray = [appDelegate overTimeMoney_logs:allLog];
        NSNumber *back_money = [backArray objectAtIndex:0];
        NSNumber *back_time = [backArray objectAtIndex:1];
        
        self.totalMoneyLbel.text = [appDelegate appMoneyShowStly3:[back_money doubleValue]];
        long seconds = (long)([back_time doubleValue]*3600);
        self.totalTimeLbel.text = [appDelegate conevrtTime2:(int)seconds];
        
    }
    else
    {
        self.totalMoneyLbel.text = [appDelegate appMoneyShowStly3:0];
        self.totalTimeLbel.text = [appDelegate conevrtTime2:0];
    }
}

#pragma mark -
#pragma mark  TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2)
    {
        return self.totalCell.frame.size.height;
    }
    else
    {
        return 44;
    }
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (ISPAD)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.clientCell setBackgroundView:bv];
            
        }

        return self.clientCell;
    }
    else if (indexPath.row == 1)
    {
        if (ISPAD)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.dateCell setBackgroundView:bv];
            
        }

        return self.dateCell;
    }
    else
    {
        [self.totalCell setBackgroundColor:[UIColor clearColor]];
        
        return self.totalCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        OverClientViewController *overClientView;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            overClientView = [[OverClientViewController alloc] initWithNibName:@"OverClientViewController" bundle:nil];
        }
        else
        {
            overClientView = [[OverClientViewController alloc] initWithNibName:@"OverClientViewController_ipad" bundle:nil];
        }
        
        overClientView.delegate = self;
        overClientView.selectClient = self.sel_client;
        
        [self.navigationController pushViewController:overClientView animated:YES];
        
    }
    else if (indexPath.row == 1)
    {
        if (self.sel_client == nil || self.sel_client.clientName == nil)
        {
            self.sel_client = nil;
            [self saveSelectClient:nil];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select Client First!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = alertView;
            
        }
        else
        {
            OverDateViewController *overDateView;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                overDateView = [[OverDateViewController alloc] initWithNibName:@"OverDateViewController" bundle:nil];
            }
            else
            {
                overDateView = [[OverDateViewController alloc] initWithNibName:@"OverDateViewController_ipad" bundle:nil];
            }
            
            overDateView.delegate = self;
            if (self.startDate != nil)
            {
                overDateView.startDate = self.startDate;
                
            }
            if (self.endDate != nil)
            {
                overDateView.endDate = self.endDate;
            }
            overDateView.sel_client = self.sel_client;
            overDateView.dateStly = self.dateStly;
            
            [self.navigationController  pushViewController:overDateView animated:YES];
        }
    }
}

#pragma mark saveSelectClient
-(void)saveSelectClient:(Clients *)_selectClient
{
    self.startDate = nil;
    self.endDate = nil;
    self.dateLbel.text = @"";
    self.dateStly = 0;
    
    if (_selectClient != nil && _selectClient.clientName != nil)
    {
        self.sel_client = _selectClient;
    }
    else
    {
        self.sel_client = nil;
    }
    
    [self initData];
}


-(void)saveSelectDate:(NSDate *)_startDate second:(NSDate *)_endDate dateStly:(NSInteger)_dateStly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *key;
    
    self.dateStly = _dateStly;
    self.startDate = _startDate;
    if (self.dateStly == 0)
    {
        self.endDate = nil;
        key = [dateFormatter stringFromDate:self.startDate];
    }
    else
    {
        self.endDate = _endDate;
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
        NSString *key1 = [dateFormatter2 stringFromDate:self.startDate];
        NSString *key2 = [dateFormatter stringFromDate:self.endDate];
        key = [NSString stringWithFormat:@"From %@ to %@",key1,key2];
    }
    self.dateLbel.text = key;
}




@end

