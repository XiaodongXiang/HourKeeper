//
//  TimeSheetViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeSheetViewController.h"

#import "TimesheetLogs_Cell.h"
#import "AppDelegate_iPhone.h"
#import "EventKitDataSource.h"
#import "AddLogViewController.h"
#import "OverTimeViewController.h"
#import "HMJLabel.h"
#import "XDOverTimeViewController.h"

@interface TimeSheetViewController()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation PayPeriod_Unit
-(id)init
{
    self = [super init];
    
    _pay_clientArray = [[NSMutableArray alloc] init];
    
    return self;
}

@end

@implementation Client_Unit

-(id)init
{
    self = [super init];
    
    self.client_startDate = nil;
    self.client_endDate = nil;
    self.allseconds = 0;
    self.allmoney = 0.0;
    _logsArray = [[NSMutableArray alloc] init];
    
    return self;
}

@end


@implementation TimeSheetViewController

#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPoint];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == NO)
    {
        NSArray *requests2 = [appDelegate getAllLog];
        
        if ([requests2 count] > 0)
        {
            appDelegate.lite_adv = YES;
            
            NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
            [defaults2 setInteger:1 forKey:NEED_SHOW_LITE_ADV_FLAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == YES)
    {
        [self.lite_Btn setHidden:NO];
        
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height-self.bootView.frame.size.height;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
        self.bootView.frame = CGRectMake(self.bootView.frame.origin.x, self.tableView.frame.origin.y+higt, self.bootView.frame.size.width, self.bootView.frame.size.height);
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == NO )
    {
        [self.bootView setHidden:YES];
    }
    else
    {
        [self.bootView setHidden:NO];
    }
    
    self.showClientLogsVC = nil;
    self.calendarVC = nil;
    [self reflashTableAndBottom];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Method
-(void)initPoint
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    _rightBarView.backgroundColor = [UIColor clearColor];
    [_calendarBtn addTarget:self action:@selector(scanCalendar) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    [_calculatorBtn addTarget:self action:@selector(doOverTime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -16;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItems = @[flexible,rightBar];
    
    
    if(IS_IPHONE_4||IS_IPHONE_5)
        [appDelegate setNaviGationTittle:self with:90 high:44 tittle:@""];
    else
        [appDelegate setNaviGationTittle:self with:90 high:44 tittle:@"Pay Period"];
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    
    _dateLogArray = [[NSMutableArray alloc] init];
    self.app_allseconds = 0;
    self.app_allmoney = 0.0;
    
    if (appDelegate.isPurchased == NO)
    {
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height-self.bootView.frame.size.height;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
        self.bootView.frame = CGRectMake(self.bootView.frame.origin.x, self.tableView.frame.origin.y+higt, self.bootView.frame.size.width, self.bootView.frame.size.height);
        
        if (appDelegate.lite_adv == YES)
        {
            [self.bootView setHidden:NO];
            [self.lite_Btn setHidden:NO];
        }
        else
        {
            [self.bootView setHidden:YES];
            [self.lite_Btn setHidden:YES];
        }
    }
    else
    {
        [self.bootView setHidden:NO];
        [self.lite_Btn setHidden:YES];
    }
    [self.lite_Btn setImage:[UIImage imageNamed:[NSString customImageName:@"ads320_50"]] forState:UIControlStateNormal];
    
    [_m_overMoneyLbel creatSubViewsisLeftAlignment:NO];
    [_totalLogsWorkedMoneyLbel creatSubViewsisLeftAlignment:NO];
    
    
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

//获取数据刷新tableview
-(void)reflashTableAndBottom
{
    [self getPayPeriod];
    [self.tableView reloadData];
    
    if (self.showClientLogsVC != nil)
    {
        [self.showClientLogsVC reflashView];
    }
    else if (self.calendarVC != nil)
    {
        [self.calendarVC initCalendar];
    }
}

//获取数据
-(void)getPayPeriod
{
    self.app_allseconds = 0;
    self.app_allmoney = 0.0;
    
    //获取所有有效的client
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSArray *requests = [appDelegate getAllClient];
    
    //存放每个client下 每个支付时间段的数据
    NSMutableArray *all_clientUnitArray = [[NSMutableArray alloc] init];
    NSMutableArray *clientsArray = [[NSMutableArray alloc] initWithArray:requests];
    NSString *client_timelength;
    NSArray *client_timeArray;
    int unit_hours;
    int unit_minutes;
    
    //将每个client下的log按照支付时间分组
    for (Clients *sel_client in clientsArray)
    {
        //获取这个Client下所有的Log按照时间排序
        NSArray *logArray = [appDelegate removeAlready_DeleteLog:[sel_client.logs allObjects]];
        if (logArray> 0)
        {
            NSMutableArray *client_logsArray = [[NSMutableArray alloc] initWithArray:logArray];
            NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
            [client_logsArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
            
            
            for (; [client_logsArray count]>0 ;)
            {
                Logs *sel_log = [client_logsArray objectAtIndex:0];
                
                Client_Unit *clientData = [[Client_Unit alloc] init];
                
                client_timelength = (sel_log.worked == nil) ? @"0:00":sel_log.worked;
                client_timeArray = [client_timelength componentsSeparatedByString:@":"];
                unit_hours = [[client_timeArray objectAtIndex:0] intValue];
                unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
                //统计所有的时间金钱
                clientData.allseconds = unit_hours*3600+unit_minutes*60;
                clientData.allmoney = [sel_log.totalmoney doubleValue];
                
                [clientData.logsArray addObject:sel_log];
                clientData.client = sel_log.client;
                [client_logsArray removeObject:sel_log];
                
                
                NSDate *sel_firstDate = nil;
                NSDate *sel_endDate = nil;
                //设置这个log需要支付的时间段
                [appDelegate getPayPeroid_selClient:sel_client payPeroidDate:sel_log.starttime backStartDate:&sel_firstDate backEndDate:&sel_endDate];
                clientData.client_startDate = sel_firstDate;
                clientData.client_endDate = sel_endDate;
                
                
                for (; [client_logsArray count]>0 ;)
                {
                    Logs *_log = [client_logsArray objectAtIndex:0];
                    
                    if ([sel_firstDate compare:_log.starttime] == NSOrderedDescending)
                    {
                        break;
                    }
                    else
                    {
                        client_timelength = (_log.worked == nil) ? @"0:00":_log.worked;
                        client_timeArray = [client_timelength componentsSeparatedByString:@":"];
                        unit_hours = [[client_timeArray objectAtIndex:0] intValue];
                        unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
                        clientData.allseconds = clientData.allseconds +unit_hours*3600+unit_minutes*60;
                        clientData.allmoney = clientData.allmoney + [_log.totalmoney doubleValue];
                        
                        [clientData.logsArray addObject:_log];
                        [client_logsArray removeObject:_log];
                    }
                }
                
                
                self.app_allseconds = self.app_allseconds + clientData.allseconds;
                self.app_allmoney = self.app_allmoney + clientData.allmoney;
                
                
                [all_clientUnitArray addObject:clientData];
            }
            
            
        }
        
    }
    
    
    //把每一笔Log按照支付结束日期排序
    NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"client_endDate" ascending:NO];
    [all_clientUnitArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
    [self.dateLogArray removeAllObjects];
    //将相同结束日期放一个数组，组成二维数组
    for (; [all_clientUnitArray count]>0 ;)
    {
        Client_Unit *clientData = [all_clientUnitArray objectAtIndex:0];
        
        PayPeriod_Unit *payUnit = [[PayPeriod_Unit alloc] init];
        payUnit.pay_endDate = clientData.client_endDate;
        [payUnit.pay_clientArray addObject:clientData];
        [all_clientUnitArray removeObject:clientData];
        
        for (; [all_clientUnitArray count]>0 ;)
        {
            Client_Unit *clientData2 = [all_clientUnitArray objectAtIndex:0];
            
            if ([payUnit.pay_endDate compare:clientData2.client_endDate] == NSOrderedSame)
            {
                [payUnit.pay_clientArray addObject:clientData2];
                [all_clientUnitArray removeObject:clientData2];
            }
            else
            {
                break;
            }
        }
        
        NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"allseconds" ascending:NO];
        [payUnit.pay_clientArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
        
        [self.dateLogArray addObject:payUnit];
    }
    
    
    
    
    self.totalLogsWorkedTimeLbel.text = [appDelegate conevrtTime2:(int)self.app_allseconds];
    
    [_totalLogsWorkedMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",self.app_allmoney] color:[HMJNomalClass creatAmountColor]];
    [_totalLogsWorkedMoneyLbel setNeedsDisplay];
    
    //    self.totalLogsWorkedMoneyLbel.text = [appDelegate appMoneyShowStly3:self.app_allmoney];
    
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:[appDelegate getOverTime_Log:nil startTime:nil endTime:nil isAscendingOrder:NO]];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [_m_overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [_m_overMoneyLbel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
}

/*
 日历点击事件
 */
-(void)scanCalendar
{
    [Flurry logEvent:@"2_PPD_CAL"];
    
    CalendarViewController *calendView = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    
    self.calendarVC = calendView;
    
    [calendView setHidesBottomBarWhenPushed:YES];
    
    self.dataSource = [[EventKitDataSource alloc] init];
    calendView.dataSource = self.dataSource;
    calendView.delegate = self.dataSource;
    [calendView.dataSource getCalendarView:calendView];
    
    [self.navigationController pushViewController:calendView animated:YES];
    
}

-(void)doAdd
{
    AddLogViewController *controller =  [[AddLogViewController alloc] initWithNibName:@"AddLogViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self presentViewController:nav animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}





-(IBAction)doOverTime
{
    XDOverTimeViewController *overTimeView = [[XDOverTimeViewController alloc] initWithNibName:@"XDOverTimeViewController" bundle:nil];
    
    [overTimeView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:overTimeView animated:YES];
    
}

-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)pop_system_UnlockLite
{
    float higt;
    higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.bootView.frame.size.height;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
    self.bootView.frame = CGRectMake(self.bootView.frame.origin.x, self.tableView.frame.origin.y+higt, self.bootView.frame.size.width, self.bootView.frame.size.height);
    
    [self.lite_Btn setHidden:YES];
    [self.bootView setHidden:NO];
    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    [appDelegate removeUnLock_Notificat:self];
}


#pragma mark TabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([self.dateLogArray count] == 0)
    {
        [self.tipImagV setHidden:NO];
    }
    else
    {
        [self.tipImagV setHidden:YES];
    }
    
    return [self.dateLogArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    PayPeriod_Unit *dataUnit = [self.dateLogArray objectAtIndex:section];
    return [dataUnit.pay_clientArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    v.backgroundColor = RGBColor(249, 249, 249);
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 24-SCREEN_SCALE, SCREEN_WITH, SCREEN_SCALE)];
//    line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
//    [v addSubview:line];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 130,20)];
	label.textAlignment = NSTextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:FontSFUITextRegular size:14];
	label.textColor = RGBColor(193, 197, 209);
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    PayPeriod_Unit *dataUnit = [self.dateLogArray objectAtIndex:section];
    label.text = [[dateFormatter stringFromDate:dataUnit.pay_endDate]uppercaseString];

    
	[v addSubview:label];
    
    PayPeriod_Unit *dateSection = [self.dateLogArray objectAtIndex:section];
    float totalAmount = 0;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    for(int i=0;i<[dateSection.pay_clientArray count];i++)
    {
        Client_Unit *dateRow = [dateSection.pay_clientArray objectAtIndex:i];
        totalAmount += dateRow.allmoney;
        NSArray *backArray = [appDelegate overTimeMoney_logs:dateRow.logsArray];
        NSNumber *back_money = [backArray objectAtIndex:0];
        totalAmount += [back_money doubleValue];
    }

    HMJLabel *totalAmountLabel = [[HMJLabel alloc]initWithFrame:CGRectMake(150, 0, SCREEN_WITH-15-150, v.height)];
    [totalAmountLabel creatSubViewsisLeftAlignment:NO];
    [totalAmountLabel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalAmount] color:label.textColor];
    [v addSubview:totalAmountLabel];
    totalAmountLabel.backgroundColor = [UIColor clearColor];
    
    
//    if (IS_IPHONE_6PLUS)
//    {
//        float left = 20;
//        label.left = left;
//        totalAmountLabel.left = 145;
//
//    }
    
	
    return v;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"timesheetLogsCell-Identifier";
    TimesheetLogs_Cell *cell = (TimesheetLogs_Cell*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TimesheetLogs_Cell" owner:self options:nil];
        
        for (id oneObject in nibs)
        {
            if ([oneObject isKindOfClass:[TimesheetLogs_Cell class]])
            {
                cell = (TimesheetLogs_Cell*)oneObject;
                [cell.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
            }
        }
    }
    
    
    PayPeriod_Unit *dateSection = [self.dateLogArray objectAtIndex:indexPath.section];
    Client_Unit *dateRow = [dateSection.pay_clientArray objectAtIndex:indexPath.row];

    cell.dateLbel.text = dateRow.client.clientName;
    
    
    
    NSString *countStr;
    if ([dateRow.logsArray count]<=1)
    {
        countStr = [NSString stringWithFormat:@"%lu entry",(unsigned long)[dateRow.logsArray count]];
    }
    else
    {
        countStr = [NSString stringWithFormat:@"%lu entries",(unsigned long)[dateRow.logsArray count]];
    }
    cell.logCountLabel.text = countStr;
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    
    //total Amount
    [cell.totalMoneyLbel setAmountSize:18 pointSize:14 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",dateRow.allmoney] color:[HMJNomalClass creatAmountColor]];
    ;

    cell.totalTimerLbel.text = [appDelegate conevrtTime2:(int)dateRow.allseconds];
    
    [cell.totalMoneyLbel setNeedsDisplay];

    
    NSArray *backArray = [appDelegate overTimeMoney_logs:dateRow.logsArray];
    NSNumber *back_time = [backArray objectAtIndex:1];
    long seconds = (long)([back_time doubleValue]*3600);
    if (seconds/3600 == 0 && (seconds/60)%60 == 0)
    {
        [cell.overTimerLbel setHidden:YES];
        cell.overTimerLbel.text = nil;
    }
    else
    {
        [cell.overTimerLbel setHidden:NO];
        cell.overTimerLbel.text = [NSString stringWithFormat:@"(%01ldh %02ldm)",seconds/3600,(seconds/60)%60];
    }
    
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
//        left = 20;
        cell.dateLbel.left = left;
        cell.logCountLabel.left = left;
    }
    cell.totalMoneyLbel.left = SCREEN_WITH - left - cell.totalMoneyLbel.width;
    
  
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowClientLogsViewController *logsShowView = [[ShowClientLogsViewController alloc] initWithNibName:@"ShowClientLogsViewController" bundle:nil];
    
    self.showClientLogsVC = logsShowView;
    
    [logsShowView setHidesBottomBarWhenPushed:YES];

    PayPeriod_Unit *dateSection = [self.dateLogArray objectAtIndex:indexPath.section];
    Client_Unit *dateRow = [dateSection.pay_clientArray objectAtIndex:indexPath.row];
    
    logsShowView.sel_startDate = dateRow.client_startDate;
    logsShowView.sel_endDate = dateRow.client_endDate;
    logsShowView.sel_client = dateRow.client;
    
    [self.navigationController pushViewController:logsShowView animated:YES];
    
}









@end
