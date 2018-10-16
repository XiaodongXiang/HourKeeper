//
//  ShowClientLogsViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowClientLogsViewController.h"

#import "AppDelegate_iPhone.h"
#import "Logs.h"


#import "EditLogViewController_new.h"
#import "ExportDataViewController.h"
#import "SelectLogsViewController.h"

#import "OverTimeViewController.h"
#import "PayperiodCell.h"



@implementation ShowClientLogsViewController

#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _logList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //back btn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 90, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"PayPeriod" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    _rightBarView.backgroundColor = [UIColor clearColor];
    [_addButton setImage:[UIImage imageNamed:@"icon_more_32.png"] forState:UIControlStateNormal];
    [_addButton setImage:[UIImage imageNamed:@"icon_more_32_sel.png"] forState:UIControlStateHighlighted];
    [_addButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [_calculatorBtn addTarget:self action:@selector(doOverTime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -16;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItems = @[flexible,rightBar];

    //title
    self.navigationItem.titleView = self.navTitelView;
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    

    
    self.clientNameLbel.text = self.sel_client.clientName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    self.dueDateLbel.text = [dateFormatter stringFromDate:self.sel_endDate];
    
    
    [self.totalLogsWorkedMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.m_overMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self reflashView];
    
    
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
    }
    
    self.overtimelabel1.left = left;
    
    self.totallabel1.left = left;
    
    self.m_overTimeLbel.left = SCREEN_WITH*3.0/4.0 - left - self.m_overTimeLbel.width + (1-SCREEN_SCALE);
    self.totalLogsWorkedTimeLbel.left = self.m_overTimeLbel.left;
    
    self.m_overMoneyLbel.left = SCREEN_WITH - self.m_overMoneyLbel.width - left + (1-SCREEN_SCALE);
    self.totalLogsWorkedMoneyLbel.left = self.m_overMoneyLbel.left;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Method
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSDate *date2 = [self.sel_endDate dateByAddingTimeInterval:(NSTimeInterval)24*3600];
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [self.logList removeAllObjects];
    [self.logList addObjectsFromArray:[appDelegate getOverTime_Log:self.sel_client startTime:date1 endTime:date2 isAscendingOrder:NO]];
 
    [self reflashBootView];
    
    [self.myTableView reloadData];
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
    for (int j = 0; j<[self.logList count]; j++)
    {
        Logs *mylog = [self.logList objectAtIndex:j];
        client_timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
        client_timeArray = [client_timelength componentsSeparatedByString:@":"];
        unit_hours = [[client_timeArray objectAtIndex:0] intValue];
        unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
        allseconds = allseconds +unit_hours*3600+unit_minutes*60;
        
        allmoney = allmoney + [mylog.totalmoney doubleValue];
    }
    
    [_totalLogsWorkedMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",allmoney] color:[HMJNomalClass creatAmountColor]];
    [_totalLogsWorkedMoneyLbel setNeedsDisplay];
    
    self.totalLogsWorkedTimeLbel.text = [appDelegate conevrtTime2:(int)allseconds];
    
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:self.logList];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [_m_overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [_m_overMoneyLbel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
}

-(IBAction)doOverTime
{
    OverTimeViewController *overTimeView = [[OverTimeViewController alloc] initWithNibName:@"OverTimeViewController" bundle:nil];
    
    overTimeView.sel_client = self.sel_client;
    overTimeView.startDate = self.sel_startDate;
    overTimeView.endDate = self.sel_endDate;
    overTimeView.dateStly = 1;
    
    [self.navigationController pushViewController:overTimeView animated:YES];
    
}

/*
    more btn action
 */
-(void)doAction
{
    
   UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Invoice",@"Export Entries",nil];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    actionSheet.tag = 2;
	actionSheet.actionSheetStyle = UIBarStyleDefault;
	[actionSheet showInView:appDelegate.m_tabBarController.view];
    
    appDelegate.close_PopView = actionSheet;
    
}

-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate];
    if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            if (appDelegate.isPurchased == NO)
            {
                NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
                if ([requests count]>1)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of invoices allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
                    alertView.tag = 1;
                    [alertView show];
                    
                    appDelegate.close_PopView = alertView;
                    
                    return;
                }
            }
            
            
            SelectLogsViewController *selectLogsView = [[SelectLogsViewController alloc] initWithNibName:@"SelectLogsViewController" bundle:nil];
            
            selectLogsView.delegate = nil;
            selectLogsView.isLogFirst = YES;
            selectLogsView.selectClient = self.sel_client;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectLogsView];
            [self presentViewController:nav animated:YES completion:nil];
            appDelegate.m_widgetController = self;
            
        }
        else if (buttonIndex == 1)
        {
            ExportDataViewController *exportDataController = [[ExportDataViewController alloc] initWithNibName:@"ExportDataViewController" bundle:nil];
            
            exportDataController.isSetting = 1;
            exportDataController.sel_client = self.sel_client;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:exportDataController];
            [self presentViewController:nav animated:YES completion:nil];
            appDelegate.m_widgetController = self;
            
            
        }
    }
}

#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"identify";
    PayperiodCell *cell  = (PayperiodCell*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[PayperiodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [self.logList objectAtIndex:indexPath.row];

    
    
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
    
    //nameLabel 用来显示日期
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
    
    if (indexPath.row == [self.logList count]-1)
    {
        cell.bottomLine.left = 0;
    }
    else
    {
        float left = 15;
        if (IS_IPHONE_6PLUS)
        {
            left = 20;
        }
        cell.bottomLine.left = left;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditLogViewController_new  *editlogView = [[EditLogViewController_new alloc] initWithNibName:@"EditLogViewController_new" bundle:nil];
    editlogView.selectLog = [self.logList objectAtIndex:indexPath.row];
    
    [self.navigationController  pushViewController:editlogView animated:YES];
}



-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [self.logList objectAtIndex:indexPath.row];
    
    
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

/*
    删除log事件
 */
-(void)deletLog_index:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [self.logList objectAtIndex:indexPath.row];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [self.logList removeObject:_selectLog];
    
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    [appDelegate.managedObjectContext save:nil];
    [appDelegate.parseSync updateLogFromLocal:_selectLog];
    
    
    
//    //syncing
//    NSMutableArray *dataMarray = [[NSMutableArray alloc] initWithObjects:_selectLog, nil];
//    if ([_selectLog.isInvoice boolValue] == YES && [[_selectLog.invoice allObjects] count] > 0)
//    {
//        Invoice *sel_invoice = [[_selectLog.invoice allObjects] objectAtIndex:0];
//        [dataMarray insertObject:sel_invoice atIndex:0];
//    }
    
    
    
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];
//    if (appDelegate.isPurchased == NO)
//    {
//        [context deleteObject:_selectLog];
//    }
//    [context save:nil];
    
    
    
    //syncing
//    [appDelegate localToServerSync:dataMarray isRelance:NO];
    
    
    
    [self.myTableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.myTableView endUpdates];
    if (indexPath.row == [self.logList count] && [self.logList count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.logList count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self reflashBootView];
}

#pragma mark AlerView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"7_ADS_INV2"];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPurchase_Lite];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self deletLog_index:self.delete_indexPath];
        }
    }
}

#pragma mark ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}






-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}


@end
