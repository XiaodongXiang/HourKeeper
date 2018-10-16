//
//  ProjectChartViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectChartViewController.h"

#import "AppDelegate_iPhone.h"
#import "Logs.h"
#import "Invoice.h"
#import "EditLogViewController_new.h"
#import "PayperiodCell.h"

#import "OverTimeViewController.h"




@implementation ProjectChartViewController



@synthesize tableView;

@synthesize navTitelView;
@synthesize clientNameLbel;
@synthesize dueDateLbel;

@synthesize totalLogsWorkedTimeLbel;
@synthesize totalLogsWorkedMoneyLbel;
@synthesize m_overMoneyLbel;
@synthesize m_overTimeLbel;

@synthesize allLogsList;
@synthesize sel_startDate;
@synthesize sel_endDate;
@synthesize clientName;
@synthesize dateStr;
@synthesize sel_client;

@synthesize delete_indexPath;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        allLogsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 80, 30);
    [leftButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    leftButton.titleLabel.font = appDelegate.naviFont;
//    [leftButton setTitle:@"Reports" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:leftButton];
    
    self.navigationItem.titleView = self.navTitelView;
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 32, 32);
    [addButton setImage:[UIImage imageNamed:@"icon_Calculator.png"] forState:UIControlStateNormal];
//    [addButton setImage:[UIImage imageNamed:@"icon_more_32_sel.png"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(doOverTime) forControlEvents:UIControlEventTouchUpInside];
    appDelegate.naviBarWitd = -6;
    [appDelegate setNaviGationItem:self isLeft:NO button:addButton];

    
    self.clientNameLbel.text = self.clientName;
    self.dueDateLbel.text = self.dateStr;
    
    [self.m_overMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.totalLogsWorkedMoneyLbel creatSubViewsisLeftAlignment:NO];
    
    [self reflashView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
//    self.tableView;
//    
//    self.navTitelView;
//    self.clientNameLbel;
//    self.dueDateLbel;
//    
//    self.totalLogsWorkedTimeLbel;
//    self.totalLogsWorkedMoneyLbel;
//    self.m_overTimeLbel;
//    self.m_overMoneyLbel;
//    
//    self.allLogsList;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    
    [self reflashView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}








-(void)reflashView
{
    
    if (self.sel_client == nil || self.sel_client.clientName == nil)
    {
        [self back];
        return;
    }
    self.clientNameLbel.text = self.sel_client.clientName;
    
    
    
    NSDate *date1 = self.sel_startDate;
    NSDate *date2 = self.sel_endDate;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [self.allLogsList removeAllObjects];
    [self.allLogsList addObjectsFromArray:[appDelegate getOverTime_Log:self.sel_client startTime:date1 endTime:date2 isAscendingOrder:NO]];
    
    [self reflashBootView];
    
    [self.tableView reloadData];
}

-(void)reflashBootView
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSString *client_timelength;
    NSArray *client_timeArray;
    int unit_hours;
    int unit_minutes;
    double allmoney = 0.0;
    long allseconds = 0;
    for (int j = 0; j<[self.allLogsList count]; j++)
    {
        Logs *mylog = [self.allLogsList objectAtIndex:j];
        client_timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
        client_timeArray = [client_timelength componentsSeparatedByString:@":"];
        unit_hours = [[client_timeArray objectAtIndex:0] intValue];
        unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
        allseconds = allseconds +unit_hours*3600+unit_minutes*60;
        
        allmoney = allmoney + [mylog.totalmoney doubleValue];
    }
    
    [self.totalLogsWorkedMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",allmoney] color:[HMJNomalClass creatAmountColor]];
    [self.totalLogsWorkedMoneyLbel setNeedsDisplay];
    self.totalLogsWorkedTimeLbel.text = [appDelegate conevrtTime2:(int)allseconds];
    
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:self.allLogsList];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [self.m_overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [self.m_overMoneyLbel setNeedsDisplay];
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
}




-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}






#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allLogsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString* identifier = @"identify";
    PayperiodCell *cell  = (PayperiodCell*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[PayperiodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
    }
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [self.allLogsList objectAtIndex:indexPath.row];

    if ([sel_log.isPaid intValue] == 1)
    {
        [cell.clockImageV setHidden:NO];
    }
    else
    {
        [cell.clockImageV setHidden:YES];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.pointInTimeLabel.text = [dateFormatter stringFromDate:sel_log.starttime];
    
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *compTimeStr = [dateFormatter stringFromDate:sel_log.starttime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *todayCompDate;
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&todayCompDate interval:NULL forDate:[NSDate date]];
    NSDate *yesterdayDate;
    yesterdayDate = [NSDate dateWithTimeInterval:-24*3600 sinceDate:todayCompDate];
    if ([[dateFormatter stringFromDate:todayCompDate] isEqualToString:compTimeStr])
    {
        cell.nameLabel.text = @"Today";
    }
    else if ([[dateFormatter stringFromDate:yesterdayDate] isEqualToString:compTimeStr])
    {
        cell.nameLabel.text = @"Yesterday";
    }
    else
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        cell.nameLabel.text = [dateFormatter stringFromDate:sel_log.starttime];
    }
    
    cell.totalTimeLabel.text = [appDelegate conevrtTime:sel_log.worked];
    [cell.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:sel_log.totalmoney color:[HMJNomalClass creatAmountColor]];
    [cell.amountView setNeedsDisplay];

    if(indexPath.row== [self.allLogsList count]-1)
        cell.bottomLine.left = 0;
    else
    {
        if (IS_IPHONE_6PLUS)
        {
            cell.bottomLine.left = 20;
        }
        else
            cell.bottomLine.left = 15;
    }
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditLogViewController_new  *editlogView = [[EditLogViewController_new alloc] initWithNibName:@"EditLogViewController_new" bundle:nil];
    editlogView.selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    [self.navigationController  pushViewController:editlogView animated:YES];
    
}





-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Logs *_selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    
    self.delete_indexPath = indexPath;
    
    if ([_selectLog.isInvoice boolValue])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This log was invoiced, delete this log will also affect the invoice. Do you want to process?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
        
        alertView.tag = 2;
        [alertView show];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        appDelegate.close_PopView = alertView;
        
        
    }
    else
    {
        [self deletLog_index:self.delete_indexPath];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



-(void)deletLog_index:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [self.allLogsList removeObject:_selectLog];
    
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    [context save:nil];

    
    
    //syncing
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];

    [appDelegate.parseSync updateLogFromLocal:_selectLog];
    
    
    
    [self.tableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    if (indexPath.row == [self.allLogsList count] && [self.allLogsList count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.allLogsList count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.tableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    [self reflashBootView];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self deletLog_index:self.delete_indexPath];
        }
    }
}



-(IBAction)doOverTime
{
    OverTimeViewController *overTimeView = [[OverTimeViewController alloc] initWithNibName:@"OverTimeViewController" bundle:nil];
    
    overTimeView.sel_client = self.sel_client;
    overTimeView.startDate = self.sel_startDate;
    overTimeView.endDate = self.sel_endDate;
    overTimeView.dateStly = 2;
    
    [self.navigationController pushViewController:overTimeView animated:YES];
    
}





@end
