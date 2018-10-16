//
//  TimerSheetViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerSheetViewController_ipad.h"
#import "Custom1ViewController.h"
#import "TimerSheetCell_ipad.h"
#import "PopShowLogsViewController_ipad.h"
#import "AddLogViewController_ipad.h"
#import "AppDelegate_iPad.h"
#import "Clients.h"
#import "Logs.h"
#import "EventKitDataSource_ipad.h"
#import "Kal_ipad.h"





@implementation TimerSheetViewController_ipad
@synthesize popoverController;

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.allLogsList = [[NSMutableArray alloc] init];
        self.taskArray = [[NSMutableArray alloc] init];
        self.sel_taskSubLogsList = [[NSMutableArray alloc] init];
        self.sel_weekLogsList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加手势，横滑手势
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftDateBtn)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipRight];
    //右边按钮
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightDateBtn)];
    
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipLeft];
    
    
    self.sel_weekDay = [NSDate date];

    [self getNowWeekStartAndEndTime];
    
    
    self.calendarView = [[CalendarViewController_ipad alloc] initWithNibName:@"CalendarViewController_ipad" bundle:nil];
    self.dataSource = [[EventKitDataSource_ipad alloc] init];
    self.calendarView.dataSource = self.dataSource;
    self.calendarView.delegate = self.dataSource;
    [self.calendarView.dataSource getCalendarView:self.calendarView];
    
    
    self.payPeriodView = [[PayPeriodViewController_ipad alloc] initWithNibName:@"PayPeriodViewController_ipad" bundle:nil];
    
    self.dateSty = 0;
    
    
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    
    [self.segmentCtrol setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self ReflashRangeDateList];
    self.dateSty = 0;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

#pragma mark Action
-(IBAction)doShowStly:(UISegmentedControl *)sender
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    for (UIView *view in appDelegate.mainView.kindsofView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (sender.selectedSegmentIndex == 0)
    {
        [appDelegate.mainView.kindsofView addSubview:self.calendarView.view];
        self.dateSty = 0;
    }
    else if (sender.selectedSegmentIndex == 2)
    {
        [appDelegate.mainView.kindsofView addSubview:self.payPeriodView.view];
        self.dateSty = 2;
    }
    
    [sender setSelectedSegmentIndex:1];
}


-(IBAction)leftDateBtn
{
    [self getNextOrBeforeStartAndEndTime:0];
    [self ReflashRangeDateList];
}

-(IBAction)rightDateBtn
{
    [self getNextOrBeforeStartAndEndTime:1];
    [self ReflashRangeDateList];
}




-(void)ReflashDateStly
{
    [self getNowWeekStartAndEndTime];
    [self ReflashRangeDateList];
    [self.calendarView ReflashDateStly];
}




-(NSDate *)getAfterMathDate:(NSDate *)nowDate delayDays:(int)num
{
	NSCalendar *calendar = [NSCalendar currentCalendar];	
	NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
	[componentsToSub setDay:num];
    [componentsToSub setHour:23];
    [componentsToSub setMinute:59];
    [componentsToSub setSecond:59];
    NSDate *afterMathDate = [calendar dateByAddingComponents:componentsToSub toDate:nowDate options:0];
	return afterMathDate;
}


-(void)ReflashRangeDateList;
{
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    
    if (self.popoverController != nil && appDelegate.isDeleteFlashPop == NO)
    {
        if ([self.popoverController isPopoverVisible])
        {
            [self.popoverController dismissPopoverAnimated:YES];
        }
//        self.popoverController;
        self.popoverController = nil;
    }
    else
    {
        appDelegate.isDeleteFlashPop = NO;
    }
    

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *key1 = [dateFormatter2 stringFromDate:self.selectStartDate];
	NSString *key2 = [dateFormatter stringFromDate:self.selectEndDate];
    NSString *key = [[NSString stringWithFormat:@"%@ - %@",key1,key2] uppercaseString];
    self.tittleLbel.text = key;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.tittleLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [key sizeWithAttributes:dic];

    //高清
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.tittleLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.tittleLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
    
    
    
    NSDate *sel_date;
    [dateFormatter setDateFormat:@"EEE dd"];
//    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEE" options:0 locale:[NSLocale currentLocale]]];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEE" options:0 locale:[NSLocale currentLocale]]];
    
    sel_date = self.selectStartDate;
    self.sunDateLbel.text = [[[dateFormatter stringFromDate:sel_date]uppercaseString]uppercaseString];
    self.calendarView.date1Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:1];
    self.monDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date2Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:2];
    self.tueDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date3Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:3];
    self.wedDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date4Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:4];
    self.thuDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date5Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:5];
    self.friDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date6Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    sel_date = [self getAfterMathDate:self.selectStartDate delayDays:6];
    self.staDateLbel.text = [[dateFormatter stringFromDate:sel_date]uppercaseString];
    self.calendarView.date7Lbel.text = [[dateFormatter3 stringFromDate:sel_date]uppercaseString];
    
    int weekStart = [appDelegate getFirstDayForWeek];
    self.calendarView.sunShadowView.frame = CGRectMake((8-weekStart)%7*0.5+100*((8-weekStart)%7), self.calendarView.sunShadowView.frame.origin.y,self.calendarView.sunShadowView.frame.size.width,self.calendarView.sunShadowView.frame.size.height);
    self.calendarView.satShadowView.frame = CGRectMake((7-weekStart)%7*0.5+100*(7-weekStart), self.calendarView.satShadowView.frame.origin.y,self.calendarView.satShadowView.frame.size.width,self.calendarView.satShadowView.frame.size.height);

    
    [self getSelectLogs];
    [self.tableView reloadData];
    
    
    long totalTime = 0;
    double totalMoney = 0.0;
    for (int i=0; i<7; i++) 
    {
        NSMutableArray *daylogsList = [self.sel_weekLogsList objectAtIndex:i];
        long dayAllTime = 0;
        double dayAllMoney = 0.0;
        
        for (int k=0; k<[daylogsList count]; k++)
        {
            Logs *log1 = [daylogsList objectAtIndex:k];
            NSString *workedTime = log1.worked;
            NSArray *timeArray = [workedTime componentsSeparatedByString:@":"];
            int hours = [[timeArray objectAtIndex:0] intValue];
            int minutes = [[timeArray objectAtIndex:1] intValue];
            
            dayAllTime = dayAllTime + hours*3600+minutes*60;
            dayAllMoney = dayAllMoney + [log1.totalmoney doubleValue];
        }
        
        totalTime = totalTime + dayAllTime;
        totalMoney = totalMoney + dayAllMoney;
        

        NSString *timeshow;
        if (dayAllTime <= 0)
        {
            timeshow = @"";
        }
        else 
        {
            timeshow = [appDelegate conevrtTime2:(int)dayAllTime];
        }
        
        NSString *moneyshow;
        if (dayAllMoney == 0.0)
        {
            moneyshow = @"";
        }
        else 
        {
            moneyshow = [appDelegate appMoneyShowStly3:dayAllMoney];
        }
        
        if (i == 0)
        {
            self.sunSubTimeLbel.text = timeshow;
            self.sunSubMoneyLbel.text = moneyshow;
        }
        else if (i == 1)
        {
            self.monSubTimeLbel.text = timeshow;
            self.monSubMoneyLbel.text = moneyshow;
        }
        else if (i == 2)
        {
            self.tueSubTimeLbel.text = timeshow;
            self.tueSubMoneyLbel.text = moneyshow;
        }
        else if (i == 3)
        {
            self.wedSubTimeLbel.text = timeshow;
            self.wedSubMoneyLbel.text = moneyshow;
        }
        else if (i == 4)
        {
            self.thuSubTimeLbel.text = timeshow;
            self.thuSubMoneyLbel.text = moneyshow;
        }
        else if (i == 5)
        {
            self.friSubTimeLbel.text = timeshow;
            self.friSubMoneyLbel.text = moneyshow;
        }
        else 
        {
            self.staSubTimeLbel.text = timeshow;
            self.staSubMoneyLbel.text = moneyshow;
        }
    }
    

    NSString *timeshow;
    if (totalTime <= 0)
    {
        timeshow = @"";
    }
    else 
    {
        timeshow = [appDelegate conevrtTime2:(int)totalTime];
    }
    self.totalTimeLbel.text = timeshow;
    NSString *moneyshow;
    if (totalMoney == 0.0)
    {
        moneyshow = @"";
    }
    else 
    {
        moneyshow = [appDelegate appMoneyShowStly3:totalMoney];
    }
    self.totalMoneyLbel.text = moneyshow;
}


-(void)getNowWeekStartAndEndTime
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:[appDelegate getFirstDayForWeek]];
    NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self.sel_weekDay];
    
    self.selectStartDate = weekFirstDate;
    self.selectEndDate = [self getAfterMathDate:self.selectStartDate delayDays:6                                                                                                                                                                                            ];
}


-(void)getNextOrBeforeStartAndEndTime:(NSInteger)direct
{
    int num = 7;

    //direct 0 表示时间向后推移    1 表示时间向前推移
    if (direct == 0)
    {
        num = -num;
    }
    
    self.sel_weekDay = [self getAfterMathDate:self.sel_weekDay delayDays:num];
    
    [self getNowWeekStartAndEndTime];
}


-(void)getSelectLogs
{
    NSDate *date1 = self.selectStartDate;
    NSDate *date2 = self.selectEndDate;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [self.allLogsList removeAllObjects];
    [self.allLogsList addObjectsFromArray:[appDelegate getOverTime_Log:nil startTime:date1 endTime:date2 isAscendingOrder:NO]];
    
    [self.taskArray removeAllObjects];
    [self.sel_taskSubLogsList removeAllObjects];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.allLogsList];
    NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"client.clientName" ascending:YES];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
    for (int i=0; i<[tempArray count]; i++)
    {
        Logs *logs1 = [tempArray objectAtIndex:i];
        NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
        [tempArray2 addObject:logs1];
        
        Clients *client1;
        client1 = logs1.client;
        if(client1==nil)
            continue;
        
        [self.taskArray addObject:client1];
        
        for (int j=i+1; j<[tempArray count]; j++)
        {
            Logs *logs2 = [tempArray objectAtIndex:j];
            
            Clients *client2;
            client2 = logs2.client;
            
            if (client1 == client2) 
            {
                [tempArray2 addObject:logs2];
                [tempArray removeObject:logs2];
                j--;
            }
        }
        
        [self.sel_taskSubLogsList addObject:tempArray2];
    }

    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
    [self.sel_weekLogsList removeAllObjects];
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:self.allLogsList];
    for (int k=0; k<7; k++)
    {
        NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:k];
        NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
        NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
        
        for (int n=0; n<[tempArray count]; n++)
        {
            Logs *log1 = [tempArray objectAtIndex:n];
            NSDate *logsDate = log1.starttime;
            NSString *dateStr2 = [dateFormatter stringFromDate:logsDate];
            
            if ([dateStr1 isEqualToString:dateStr2])
            {
                [tempArray2 addObject:log1];
                [tempArray removeObject:log1];
                n--;
            }
        }
        
        [self.sel_weekLogsList addObject:tempArray2];
    }
    
}

-(void)clickCellSunBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:0];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
    
}
-(void)clickCellMonBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:1];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}
-(void)clickCellTueBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:2];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}
-(void)clickCellWedBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:3];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}
-(void)clickCellThuBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:4];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}
-(void)clickCellFriBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:5];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}
-(void)clickCellSatBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:6];
    NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
    
    NSMutableArray *selLogs = [[NSMutableArray alloc] init];
    [selLogs addObjectsFromArray:[self.sel_taskSubLogsList objectAtIndex:sender.tag]];
    
    for (int i=0; i<[selLogs count]; i++)
    {
        Logs *logs1 = [selLogs objectAtIndex:i];
        NSString *dateStr2 = [dateFormatter stringFromDate:logs1.starttime];
        
        if (![dateStr1 isEqualToString:dateStr2])
        {
            [selLogs removeObject:logs1];
            i--;
        }
    }
    
    
    Clients *sel_client = [self.taskArray objectAtIndex:sender.tag];
    if ([selLogs count] == 0)
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.myclient = sel_client;
        addLogView.startDate = sel_date;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
        
    }
    else
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.myClient = sel_client;
        popShowLogsView.showStly = 0;
        [popShowLogsView.logsList addObjectsFromArray:selLogs];
        popShowLogsView.overTimeStly = 2;
        popShowLogsView.startDate = self.selectStartDate;
        popShowLogsView.endDate = self.selectEndDate;
        
        UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (self.popoverController != nil)
        {
            //            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        
        [self.popoverController presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
    
}



#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 39;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"timerSheetCell_ipad-Identifier";
	TimerSheetCell_ipad *timerSheetCells = (TimerSheetCell_ipad*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
	if (timerSheetCells == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TimerSheetCell_ipad" owner:self options:nil];
		
		for (id oneObject in nibs) 
		{
			if ([oneObject isKindOfClass:[TimerSheetCell_ipad class]]) 
			{
				timerSheetCells = (TimerSheetCell_ipad*)oneObject;
			}
		}
    }
    
    [timerSheetCells.sunBtn setExclusiveTouch:YES];
    [timerSheetCells.monBtn setExclusiveTouch:YES];
    [timerSheetCells.tueBtn setExclusiveTouch:YES];
    [timerSheetCells.wedBtn setExclusiveTouch:YES];
    [timerSheetCells.thuBtn setExclusiveTouch:YES];
    [timerSheetCells.friBtn setExclusiveTouch:YES];
    [timerSheetCells.satBtn setExclusiveTouch:YES];

    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Clients *sel_client = [self.taskArray objectAtIndex:indexPath.row];
    timerSheetCells.clientLbel.text = sel_client.clientName;
    
    
    NSMutableArray *logsList = [[NSMutableArray alloc] initWithArray:[self.sel_taskSubLogsList objectAtIndex:indexPath.row]];
    long totalTime = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
    for (int i=0; i<7; i++)
    {
        NSDate *sel_date = [self getAfterMathDate:self.selectStartDate delayDays:i];
        NSString *dateStr1 = [dateFormatter stringFromDate:sel_date];
        long sel_dayTime = 0;
        int ishave = 0;
        
        for (int n=0; n<[logsList count]; n++)
        {
            Logs *log1 = [logsList objectAtIndex:n];
            NSDate *logsDate = log1.starttime;
            NSString *dateStr2 = [dateFormatter stringFromDate:logsDate];
            
            if ([dateStr1 isEqualToString:dateStr2])
            {
                NSString *workedTime = log1.worked;
                NSArray *timeArray = [workedTime componentsSeparatedByString:@":"];
                int hours = [[timeArray objectAtIndex:0] intValue];
                int minutes = [[timeArray objectAtIndex:1] intValue];
                sel_dayTime = sel_dayTime +hours*3600+minutes*60;
                
                [logsList removeObject:log1];
                n--;
                
                ishave = 1;
            }
        }
      
        totalTime = totalTime + sel_dayTime;

       
        if (ishave == 0) 
        {
            if (i == 0)
            {
                [timerSheetCells.sunBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.sunBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 1)
            {
                [timerSheetCells.monBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.monBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 2)
            {
                [timerSheetCells.tueBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.tueBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 3)
            {
                [timerSheetCells.wedBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.wedBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 4)
            {
                [timerSheetCells.thuBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.thuBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 5)
            {
                [timerSheetCells.friBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.friBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else 
            {
                [timerSheetCells.satBtn setTitle:@"" forState:UIControlStateNormal];
                [timerSheetCells.satBtn setBackgroundImage:[UIImage imageNamed:@"addLog_73_41.png"] forState:UIControlStateHighlighted];
            }
        }
        else 
        {
            NSString *dateshow = [appDelegate conevrtTime2:(int)sel_dayTime];
            
            if (i == 0)
            {
                [timerSheetCells.sunBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.sunBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 1)
            {
                [timerSheetCells.monBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.monBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 2)
            {
                [timerSheetCells.tueBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.tueBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 3)
            {
                [timerSheetCells.wedBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.wedBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 4)
            {
                [timerSheetCells.thuBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.thuBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else if (i == 5)
            {
                [timerSheetCells.friBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.friBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
            else
            {
                [timerSheetCells.satBtn setTitle:dateshow forState:UIControlStateNormal];
                [timerSheetCells.satBtn setBackgroundImage:[UIImage imageNamed:@"showLog_73_41.png"] forState:UIControlStateHighlighted];
            }
        }
        
    }


    NSString *dateshow;
    dateshow = [appDelegate conevrtTime2:(int)totalTime];
    timerSheetCells.totalLbel.text = dateshow;
    
    
    [[timerSheetCells sunBtn] removeTarget:self action:@selector(clickCellSunBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells monBtn] removeTarget:self action:@selector(clickCellMonBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells tueBtn] removeTarget:self action:@selector(clickCellTueBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells wedBtn] removeTarget:self action:@selector(clickCellWedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells thuBtn] removeTarget:self action:@selector(clickCellThuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells friBtn] removeTarget:self action:@selector(clickCellFriBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells satBtn] removeTarget:self action:@selector(clickCellSatBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [[timerSheetCells sunBtn] addTarget:self action:@selector(clickCellSunBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells sunBtn] setTag:indexPath.row];
    [[timerSheetCells monBtn] addTarget:self action:@selector(clickCellMonBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells monBtn] setTag:indexPath.row];
    [[timerSheetCells tueBtn] addTarget:self action:@selector(clickCellTueBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells tueBtn] setTag:indexPath.row];
    [[timerSheetCells wedBtn] addTarget:self action:@selector(clickCellWedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells wedBtn] setTag:indexPath.row];
    [[timerSheetCells thuBtn] addTarget:self action:@selector(clickCellThuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells thuBtn] setTag:indexPath.row];
    [[timerSheetCells friBtn] addTarget:self action:@selector(clickCellFriBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells friBtn] setTag:indexPath.row];
    [[timerSheetCells satBtn] addTarget:self action:@selector(clickCellSatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [[timerSheetCells satBtn] setTag:indexPath.row];
    

    timerSheetCells.backgroundColor = [UIColor clearColor];
    
    
    return timerSheetCells;
}

@end
