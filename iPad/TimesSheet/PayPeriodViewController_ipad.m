//
//  PayPeriodViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 8/19/13.
//
//

#import "PayPeriodViewController_ipad.h"

#import "TimesheetLogs_Cell_ipad.h"
#import "PopShowLogsViewController_ipad.h"

#import "AppDelegate_Shared.h"
#import "AppDelegate_iPad.h"






@implementation PayPeriodViewController_ipad


#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _dateLogArray = [[NSMutableArray alloc] init];
        self.app_allseconds = 0;
        self.app_allmoney = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (SCREEN_SCALE<1)
    {
        self.myTableView.width = 703.5;
    }
    [self.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.overMoneyLabel creatSubViewsisLeftAlignment:NO];
    
    
    [self.myTableView setExclusiveTouch:YES];
    
    
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    
    headDateFormatter = [[NSDateFormatter alloc] init];
    [headDateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    
    self.bottomView.width = self.view.width - SCREEN_SCALE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reflashTableAndBottom];
}


-(void)reflashTableAndBottom
{
    [self getPayPeriod];
    [self.myTableView reloadData];
}




-(IBAction)doShowStly:(UISegmentedControl *)sender
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    for (UIView *view in appDelegate.mainView.kindsofView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (sender.selectedSegmentIndex == 0)
    {
        [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.timersheetView.calendarView.view];
        appDelegate.mainView.timersheetView.dateSty = 0;
        
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.timersheetView.view];
        appDelegate.mainView.timersheetView.dateSty = 1;
    }
    
    [sender setSelectedSegmentIndex:2];
}








-(void)getPayPeriod
{
    self.app_allseconds = 0;
    self.app_allmoney = 0.0;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSArray *requests = [appDelegate getAllClient];
    
    NSMutableArray *all_clientUnitArray = [[NSMutableArray alloc] init];
    NSMutableArray *clientsArray = [[NSMutableArray alloc] initWithArray:requests];
    NSString *client_timelength;
    NSArray *client_timeArray;
    int unit_hours;
    int unit_minutes;
    for (Clients *sel_client in clientsArray)
    {
        NSArray *logArray = [appDelegate removeAlready_DeleteLog:[sel_client.logs allObjects]];
        if (logArray > 0)
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
                clientData.allseconds = unit_hours*3600+unit_minutes*60;
                clientData.allmoney = [sel_log.totalmoney doubleValue];
                
                [clientData.logsArray addObject:sel_log];
                clientData.client = sel_log.client;
                [client_logsArray removeObject:sel_log];
                
                
                NSDate *sel_firstDate = nil;
                NSDate *sel_endDate = nil;
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
    
    
    
    NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"client_endDate" ascending:NO];
    [all_clientUnitArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
    [self.dateLogArray removeAllObjects];
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
    
    
    

    self.totalTimeLbel.text = [appDelegate conevrtTime2:(int)self.app_allseconds];
    [self.totalMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",self.app_allmoney] color:[HMJNomalClass creatAmountColor]];
    [self.totalMoneyLbel setNeedsDisplay];
    
    
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:[appDelegate getOverTime_Log:nil startTime:nil endTime:nil isAscendingOrder:NO]];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [self.overMoneyLabel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [self.overMoneyLabel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];

}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dateLogArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PayPeriod_Unit *dataUnit = [self.dateLogArray objectAtIndex:section];
    return [dataUnit.pay_clientArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 704, 24)];
    v.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    if (section == 0)
    {
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_SCALE)];
        topLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        [v addSubview:topLine];
    }
    
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, v.height-SCREEN_SCALE, self.view.width, SCREEN_SCALE)];
    bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    [v addSubview:bottomLine];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200,20)];
	label.textAlignment = NSTextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    label.textColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
    [v addSubview:label];
    
    PayPeriod_Unit *dataUnit = [self.dateLogArray objectAtIndex:section];
    label.text = [[headDateFormatter stringFromDate:dataUnit.pay_endDate]uppercaseString];
    
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
    
    HMJLabel *totalAmountLabel = [[HMJLabel alloc]initWithFrame:CGRectMake(300, 0, v.width-15-300, v.height)];
    [totalAmountLabel creatSubViewsisLeftAlignment:NO];
    [totalAmountLabel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalAmount] color:label.textColor];
    [v addSubview:totalAmountLabel];
    totalAmountLabel.backgroundColor = [UIColor clearColor];
    
	
    return v;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* identifier = @"timesheetLogsCell_ipad-Identifier";
    TimesheetLogs_Cell_ipad *cell = (TimesheetLogs_Cell_ipad*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TimesheetLogs_Cell_ipad" owner:self options:nil];
        
        for (id oneObject in nibs)
        {
            if ([oneObject isKindOfClass:[TimesheetLogs_Cell_ipad class]])
            {
                cell = (TimesheetLogs_Cell_ipad*)oneObject;
                [cell.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
                [cell.overMoneyLbel creatSubViewsisLeftAlignment:NO];
            }
        }
    }
    
    
    
    
    PayPeriod_Unit *dateSection = [self.dateLogArray objectAtIndex:indexPath.section];
    Client_Unit *dateRow = [dateSection.pay_clientArray objectAtIndex:indexPath.row];
    
    cell.dateLbel.text = dateRow.client.clientName;
    
    
    NSString *countStr;
    if ([dateRow.logsArray count]<=1)
    {
        countStr = [NSString stringWithFormat:@"%d entry",(int)[dateRow.logsArray count]];
    }
    else
    {
        countStr = [NSString stringWithFormat:@"%d entries",(int)[dateRow.logsArray count]];
    }
    cell.logCountLabel.text = countStr;
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    cell.totalTimerLbel.text = [appDelegate conevrtTime2:(int)dateRow.allseconds];
    //total Amount
    [cell.totalMoneyLbel setAmountSize:18 pointSize:14 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",dateRow.allmoney] color:[HMJNomalClass creatAmountColor]];
    ;
    [cell.totalMoneyLbel setNeedsDisplay];

    
    
    
//    NSArray *backArray = [appDelegate overTimeMoney_logs:dateRow.logsArray];
//    NSNumber *back_money = [backArray objectAtIndex:0];
//    NSNumber *back_time = [backArray objectAtIndex:1];
//    long seconds = (long)([back_time doubleValue]*3600);
//    if (seconds/3600 == 0 && (seconds/60)%60 == 0)
//    {
//        [cell.overTimerLbel setHidden:YES];
//        [cell.overMoneyLbel setHidden:YES];
//        cell.totalMoneyLbel.frame = CGRectMake(cell.totalMoneyLbel.frame.origin.x, 13, cell.totalMoneyLbel.frame.size.width, cell.totalMoneyLbel.frame.size.height);
//        cell.totalTimerLbel.frame = CGRectMake(cell.totalTimerLbel.frame.origin.x, 13, cell.totalTimerLbel.frame.size.width, cell.totalTimerLbel.frame.size.height);
//    }
//    else
//    {
//        [cell.overTimerLbel setHidden:NO];
//        [cell.overMoneyLbel setHidden:NO];
//        cell.totalMoneyLbel.frame = CGRectMake(cell.totalMoneyLbel.frame.origin.x, 3, cell.totalMoneyLbel.frame.size.width, cell.totalMoneyLbel.frame.size.height);
//        cell.totalTimerLbel.frame = CGRectMake(cell.totalTimerLbel.frame.origin.x, 3, cell.totalTimerLbel.frame.size.width, cell.totalTimerLbel.frame.size.height);
//        
//        cell.overMoneyLbel.text = [NSString stringWithFormat:@"OT  %@",[appDelegate appMoneyShowStly3:[back_money doubleValue]]];
//        cell.overTimerLbel.text = [NSString stringWithFormat:@"OT  %01ldh %02ldm",seconds/3600,(seconds/60)%60];
//    }
    NSArray *backArray = [appDelegate overTimeMoney_logs:dateRow.logsArray];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    long seconds = (long)([back_time doubleValue]*3600);
    if (seconds/3600 == 0 && (seconds/60)%60 == 0)
    {
        [cell.overTimerLbel setHidden:YES];
        [cell.overMoneyLbel setHidden:YES];
    }
    else
    {
        [cell.overTimerLbel setHidden:NO];
        [cell.overMoneyLbel setHidden:NO];
        
        [cell.overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
        [cell.overMoneyLbel setNeedsDisplay];
        cell.overTimerLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
    }

    
    if (indexPath.row == [dateSection.pay_clientArray count]-1)
    {
        cell.bottomLine.left = 0;
    }
    else
        cell.bottomLine.left = 15;    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TimesheetLogs_Cell_ipad *mycell = (TimesheetLogs_Cell_ipad *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    PayPeriod_Unit *dateSection = [self.dateLogArray objectAtIndex:indexPath.section];
    Client_Unit *dateRow = [dateSection.pay_clientArray objectAtIndex:indexPath.row];
    
    PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
    
    popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
    popShowLogsView.myClient = dateRow.client;
    popShowLogsView.startDate = dateRow.client_startDate;
    popShowLogsView.endDate = dateRow.client_endDate;
    popShowLogsView.showStly = 0;
    [popShowLogsView.logsList addObjectsFromArray:dateRow.logsArray];
    popShowLogsView.overTimeStly = 1;
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
    
    if (appDelegate.mainView.timersheetView.popoverController != nil)
    {
        appDelegate.mainView.timersheetView.popoverController = nil;
    }
    appDelegate.mainView.timersheetView.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
    
    
    [appDelegate.mainView.timersheetView.popoverController presentPopoverFromRect:mycell.logCountLabel.frame inView:mycell.logCountLabel.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    
}



@end
