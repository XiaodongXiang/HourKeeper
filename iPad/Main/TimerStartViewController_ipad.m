//
//  TimerStartViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 5/23/13.
//
//

#import "TimerStartViewController_ipad.h"
#import "Custom1ViewController.h"
#import "AppDelegate_iPad.h"
#import "Logs.h"
#import "CaculateMoney.h"
#import "TimesheetLogs_Cell2.h"
#import "EditLogViewController_ipad.h"
#import "AddLogViewController_ipad.h"
#import "TimerMainViewController.h"
#import "EditInvoiceNewViewController_ipad.h"
#import "ExportDataViewController_ipad.h"
#import "UINavigationBar_ipad.h"
#import "TimeStartViewCell.h"



@implementation TimerStartViewController_ipad
@synthesize popoverController;

#pragma mark Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _clientLogArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPoint];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.myTimer isValid])
    {
        [self.myTimer  invalidate];
    }
}
-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;

    
    if ([self.myTimer isValid])
    {
        [self.myTimer  invalidate];
    }
    
    if (self.popoverController != nil)
    {
    }

    
}


#pragma mark Action
-(void)initPoint
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 76, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 32, 32);
    [addButton setImage:[UIImage imageNamed:@"icon_more_32.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_more_32_sel.png"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    appDelegate.naviBarWitd = -11;
    [appDelegate setNaviGationItem:self isLeft:NO button:addButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Client Info"];
    [self.navigationController.navigationBar drawNavigationBarFor_ipad];
    
    [self.totalMoneyView creatSubViewsisLeftAlignment:YES];
    self.changelog = nil;
    
    
    self.startOrEndNowBtn.layer.cornerRadius = 2;
    self.startOrEndNowBtn.layer.masksToBounds = YES;
//    pointInTimeDateFormatter = [[NSDateFormatter alloc]init];
//    [pointInTimeDateFormatter setDateFormat:@"H:mm aa"];
    pointInTimeDateFormatter = [[NSDateFormatter alloc] init];
    [pointInTimeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    dayDateFormatter = [[NSDateFormatter alloc]init];
    [dayDateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [self.overMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.todayMoney creatSubViewsisLeftAlignment:NO];
    
    [self initClientData];
}

-(void)initClientData
{
    if (self.popoverController != nil)
    {
        if ([self.popoverController isPopoverVisible])
        {
            [self.popoverController dismissPopoverAnimated:YES];
        }
        self.popoverController = nil;
    }
    
    if (self.sel_client == nil || self.sel_client.clientName == nil)
    {
        [self back];
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
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
    
    //显示广告
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == YES)
    {
        float higt = self.view.frame.size.height-210-self.lite_Btn.frame.size.height;
        self.containView.frame = CGRectMake(self.containView.frame.origin.x, self.containView.frame.origin.y, self.containView.frame.size.width, higt);
        
        [self.lite_Btn setHidden:NO];
        
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    
    
    [self doTodayTimeAndMoney];
    
    NSString *name = [NSString stringWithFormat:@"%@,",self.sel_client.clientName];
    NSString *rate = [NSString stringWithFormat:@" %@%@/h",appDelegate.currencyStr,self.sel_client.ratePerHour];
    NSString *titleStr = [NSString stringWithFormat:@"%@%@",name,rate];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:26]}range:NSMakeRange(0,name.length)];
    self.clientNameLbel.attributedText = attributedString;
    
    //没有计时
    if (self.sel_client.beginTime == nil)
    {
        self.startTimeLbel.text = @"Since";
        [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];

        [self.startOrEndNowBtn setTitle:@"CLOCK IN" forState:UIControlStateNormal];
        [self.startOrEndNowBtn setBackgroundColor:[HMJNomalClass creatBtnBlueColor_17_155_227]];

        [self.startOrEndNextBtn setTitle:@"Clock in at..." forState:UIControlStateNormal];
        [self.startOrEndNextBtn setTitleColor:[UIColor colorWithRed:17.0/255.0 green:155.0/255.0 blue:227.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        
        
        self.externalView.isGray = YES;
        [self.externalView setNeedsDisplay];
        
        [self setTotalTimeLbelText:0 withBeginTimeNil:YES];
        
        
        
        if ([self.myTimer isValid])
        {
            [self.myTimer  invalidate];
        }
    }
    //计时
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.startTimeLbel.text = [NSString stringWithFormat:@"Since %@",[dateFormatter stringFromDate:self.sel_client.beginTime]];
        
        float totalSeconds = 0;
        if ([self.sel_client.beginTime compare:[NSDate date]] == NSOrderedDescending)
        {
            [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];
        }
        else
        {

            
            NSDate *nowTime = [NSDate date];
            if ([self.sel_client.beginTime compare:nowTime] == NSOrderedDescending)
            {
//                totalTimeString = [appDelegate conevrtTime5:0];
            }
            else
            {
                
                NSTimeInterval timeInterval = [nowTime timeIntervalSinceDate:self.sel_client.beginTime];
                int allSeconds = (int)timeInterval;
                int breakTime = 0;
                if (self.sel_client.lunchStart != nil)
                {
                    NSTimeInterval tmpBreak = [nowTime timeIntervalSinceDate:self.sel_client.lunchStart];
                    breakTime = tmpBreak>0?tmpBreak:0;
                }
                if ([self.sel_client.lunchTime intValue]>0)
                {
                    breakTime += [self.sel_client.lunchTime intValue];
                }
                totalSeconds = (allSeconds - breakTime)>0?(allSeconds - breakTime):0;
                
//                totalTimeString = [appDelegate conevrtTime5:totalSeconds];
            }

            
            
            NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:[appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime] totalTime:nil totalTimeInt:totalSeconds];
            NSString *money = [backArray objectAtIndex:0];
            if ( [money doubleValue] == 0)
            {
                [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];
            }
            else
            {
                [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:money color:[HMJNomalClass creatAmountColor]];

            }
            
            
            //多长时间以后算加班
            double overTime = 0;
            double dayTax1 = [appDelegate getMultipleNumber:self.sel_client.dailyOverFirstHour];
            double dayTax2 = [appDelegate getMultipleNumber:self.sel_client.dailyOverFirstHour];
            if (dayTax1<=0 && dayTax2<=0)
            {
                overTime = 0;
            }
            else if (dayTax1>0 && dayTax2>0)
            {
                overTime = dayTax1<dayTax2?dayTax1:dayTax2;
            }
            else
            {
                overTime = dayTax1>dayTax2?dayTax1:dayTax2;
            }
            self.externalView.isGray = NO;
            self.externalView.totalTime = overTime*3600;
            self.externalView.currentTime = totalSeconds;
            [self.externalView setNeedsDisplay];
            
        }
        
        //设置时间
        [self setTotalTimeLbelText:totalSeconds withBeginTimeNil:NO];
        
        
        
        UIColor *on = [UIColor colorWithRed:239.0/255.0 green:98.0/255.0 blue:88.0/255.0 alpha:1];
        [self.startOrEndNowBtn setTitle:@"CLOCK OUT" forState:UIControlStateNormal];
        [self.startOrEndNowBtn setBackgroundColor:on];

        [self.startOrEndNextBtn setTitle:@"Clock out at..." forState:UIControlStateNormal];
        [self.startOrEndNextBtn setTitleColor:on forState:UIControlStateNormal];
        
        
        if ([self.myTimer isValid])
        {
            [self.myTimer  invalidate];
        }
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onMyTimer) userInfo:nil repeats:YES];
        
        
    }
    
    
    
    if (self.changelog != nil && self.changelog.client == self.sel_client)
    {
        [self.clientLogArray insertObject:self.changelog atIndex:0];
        NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
        [self.clientLogArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
        
        int row = (int)[self.clientLogArray indexOfObject:self.changelog];
        [self.myTableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.myTableView insertRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];
        [self.myTableView endUpdates];
        if (indexPath.row == [self.clientLogArray count]-1 && [self.clientLogArray count] > 1)
        {
            NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.clientLogArray count]-2 inSection:0];
            NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
            [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
        }
        
        self.changelog = nil;
    }
    else
    {
        [self.clientLogArray removeAllObjects];
        [self.clientLogArray addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.sel_client.logs allObjects]]];
        NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
        [self.clientLogArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
        
        [self.myTableView reloadData];
    }
}

-(void)setTotalTimeLbelText:(int)tmpTotalTime withBeginTimeNil:(BOOL)isBegainTimeNil
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    if (isBegainTimeNil)
    {
        self.totalTimeLbel.textColor = [UIColor colorWithRed:168.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1];
        NSString *totalTimeString  = [appDelegate conevrtTime5:tmpTotalTime];

        NSMutableAttributedString *totalTimeAttr = [[NSMutableAttributedString alloc]initWithString:totalTimeString];
        UIFont *hourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:22];
        UIFont *secsFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:14];
        NSRange hourRange = NSMakeRange(0, [totalTimeString length]-3);
        NSRange secsRange = NSMakeRange([totalTimeString length]-3, 3);
        [totalTimeAttr addAttribute:NSFontAttributeName value:hourFont range:hourRange];
        [totalTimeAttr addAttribute:NSFontAttributeName value:secsFont range:secsRange];
        self.totalTimeLbel.attributedText = totalTimeAttr;
    }
    else
    {
        NSString *totalTimeString  = [appDelegate conevrtTime5:tmpTotalTime];

        NSMutableAttributedString *totalTimeAttr = [[NSMutableAttributedString alloc]initWithString:totalTimeString];
        UIFont *hourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:22];
        UIFont *secsFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:14];
        NSRange hourRange = NSMakeRange(0, [totalTimeString length]-3);
        NSRange secsRange = NSMakeRange([totalTimeString length]-3, 3);
        [totalTimeAttr addAttribute:NSFontAttributeName value:hourFont range:hourRange];
        [totalTimeAttr addAttribute:NSFontAttributeName value:secsFont range:secsRange];
        self.totalTimeLbel.attributedText = totalTimeAttr;
        if (self.externalView.totalTime<=0)
        {
            self.totalTimeLbel.textColor = [HMJNomalClass creatBtnBlueColor_17_155_227];
        }
        else
        {
            if (self.externalView.totalTime>=self.externalView.currentTime)
            {
                self.totalTimeLbel.textColor = [HMJNomalClass creatBtnBlueColor_17_155_227];
            }
            else
            {
                self.totalTimeLbel.textColor = [HMJNomalClass creatRedColor_244_79_68];
            }
        }

    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}








-(IBAction)clockNextBtn
{
    if (self.sel_client.beginTime != nil)
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKOUTAT"];
        
        StartTimeViewController *startDateView = [[StartTimeViewController alloc] initWithNibName:@"StartTimeViewController" bundle:nil];
        
        startDateView.delegate = self;
        startDateView.naiv_tittle = @"End Time";
        startDateView.preferredContentSize = CGSizeMake(320, 416);
        if (self.sel_client.endTime != nil)
        {
            startDateView.minDate = self.sel_client.beginTime;
            startDateView.inputDate = self.sel_client.endTime;
        }
        else
        {
            startDateView.minDate = self.sel_client.beginTime;
            startDateView.inputDate = [NSDate date];
        }
        startDateView.maxDate = nil;
        
        UINavigationController *startNavi = [[UINavigationController alloc] initWithRootViewController:startDateView];
        startNavi.preferredContentSize = CGSizeMake(320, 416);
        
        if (self.popoverController != nil)
        {
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:startNavi];
        [self.popoverController presentPopoverFromRect:self.startOrEndNextBtn.frame inView:self.startOrEndNextBtn.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        
        
    }
    else
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKINAT"];
        
        StartTimeViewController *startDateView = [[StartTimeViewController alloc] initWithNibName:@"StartTimeViewController" bundle:nil];
        
        startDateView.delegate = self;
        startDateView.naiv_tittle = @"Start Time";
        startDateView.preferredContentSize = CGSizeMake(320, 416);
        if (self.sel_client.beginTime != nil)
        {
            startDateView.inputDate = self.sel_client.beginTime;
        }
        else
        {
            startDateView.inputDate = [NSDate date];
        }
        startDateView.maxDate = nil;
        startDateView.minDate = nil;
        
        UINavigationController *startNavi = [[UINavigationController alloc] initWithRootViewController:startDateView];
        
        
        
        if (self.popoverController != nil)
        {
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:startNavi];
        [self.popoverController presentPopoverFromRect:self.startOrEndNextBtn.frame inView:self.startOrEndNextBtn.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        
        
    }
}


-(IBAction)clockNowBtn
{
    if (self.sel_client.beginTime != nil)
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKOUT"];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        
        self.changelog = nil;
        
        self.sel_client.endTime = [NSDate date];
        Logs *addLog = nil;
        if ( self.sel_client != nil && self.sel_client.clientName != nil && [self.sel_client.endTime compare:self.sel_client.beginTime] == NSOrderedDescending)
        {
            NSTimeInterval timeInterval = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
            int totalSeconds = (int)timeInterval;
            
            if (totalSeconds >= 1)
            {
                addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
                
                addLog.finalmoney = @"0:00";
                addLog.client = self.sel_client;
                addLog.starttime = self.sel_client.beginTime;
                addLog.endtime = self.sel_client.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = self.sel_client.uuid;

                self.changelog = addLog;
            }
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        
        self.sel_client.accessDate = [NSDate date];
        
        [context save:nil];
        
        
        
        //syncing
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [appDelegate.parseSync updateLogFromLocal:addLog];
        
        [self initClientData];
        [self.myTimer  invalidate];
        [self.mainView reflashLeftPageView];
    }
    else
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKIN"];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        self.sel_client.beginTime = [NSDate date];
        self.sel_client.accessDate = [NSDate date];
        [context save:nil];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];

        [self initClientData];
    }
}








-(void)doTodayTimeAndMoney
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSDate *start;
    NSDate *end;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&start interval:NULL forDate:[NSDate date]];
    end = [NSDate dateWithTimeInterval:24*3600 sinceDate:start];
    
    NSArray *logsArray = [appDelegate getOverTime_Log:self.sel_client startTime:start endTime:end isAscendingOrder:NO];
    int all_time = 0;
    double all_money = 0.0;
    for (Logs *sel_log in logsArray)
    {
        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
        NSString *str1 = [array objectAtIndex:0];
        NSString *str2 = [array objectAtIndex:1];
        int firstRow = [str1 intValue];
        int secondRow = [str2 intValue];
        all_time = all_time + firstRow*3600+secondRow*60;
        all_money = all_money + [sel_log.totalmoney doubleValue];
    }
    
    self.todayTime.text = [appDelegate conevrtTime2:all_time];

    [self.todayMoney setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",all_money] color:[HMJNomalClass creatAmountColor]];
    [self.todayMoney setNeedsDisplay];
    

    
    NSArray *backArray = [appDelegate overTimeMoney_logs:logsArray];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [self.overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [self.overMoneyLbel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.overTimeLbel.text = [appDelegate conevrtTime2:(int)seconds];

    
}

-(void)addInvoice
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
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
    
    
    EditInvoiceNewViewController_ipad *addInvoiceView =  [[EditInvoiceNewViewController_ipad alloc] initWithNibName:@"EditInvoiceNewViewController_ipad" bundle:nil];
    
    addInvoiceView.myinvoce = nil;
    addInvoiceView.navTittle = @"New Invoice";
    addInvoiceView.selectClient = self.sel_client;
    
    Custom1ViewController *editInvoiceNavi = [[Custom1ViewController alloc] initWithRootViewController:addInvoiceView];
    editInvoiceNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editInvoiceNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.mainView presentViewController:editInvoiceNavi animated:YES completion:nil];
    appDelegate.m_widgetController = self.mainView;
    
}








-(void)doAction
{
    UIActionSheet *actionSheet = [UIActionSheet alloc];
    
    if (self.sel_client.beginTime != nil)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:self.sel_client.clientName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Undo Clock In" otherButtonTitles:@"Add Entry",@"Add Invoice",@"Export Entries",@"Edit Client",nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:self.sel_client.clientName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Entry",@"Add Invoice",@"Export Entries",@"Edit Client",nil];
    }
    
    
    actionSheet.tag = 2;
	actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
	[actionSheet showInView:self.mainView.view];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = actionSheet;
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}

-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    if (actionSheet.tag == 2)
    {
        int flag = 0;   // 1:clock in at;  11:clock out at;  2:undo clock in;  3:add log;  4:edit client;  5:export jobs;
        if (self.sel_client.beginTime != nil)
        {
            if (buttonIndex == 0)
            {
                flag = 1;
            }
            else if (buttonIndex == 1)
            {
                flag = 2;
            }
            else if (buttonIndex == 2)
            {
                flag = 3;
            }
            else if (buttonIndex == 3)
            {
                flag = 4;
            }
            else if (buttonIndex == 4)
            {
                flag = 5;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                flag = 2;
            }
            else if (buttonIndex == 1)
            {
                flag = 3;
            }
            else if (buttonIndex == 2)
            {
                flag = 4;
            }
            else if (buttonIndex == 3)
            {
                flag = 5;
            }
        }
        
        
        
        if (flag == 1)
        {
            UIActionSheet *actionSheet3 = [UIActionSheet alloc];
            
            NSString *tittleStr = @"Do you want to undo the clock in without saving an entry?";
            actionSheet3 = [[UIActionSheet alloc] initWithTitle:tittleStr delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, Undo Clock In" otherButtonTitles:nil,nil];
            
            actionSheet3.tag = 3;
            actionSheet3.actionSheetStyle = UIBarStyleBlackTranslucent;
            [actionSheet3 showInView:self.mainView.view];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = actionSheet;
            
        }
        else if (flag == 2)
        {
            [Flurry logEvent:@"1_CLI_INFOMORADDE"];
            
            AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
            
            addLogView.myclient = self.sel_client;
            
            Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
            addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
            addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [self.mainView presentViewController:addLogNavi animated:YES completion:nil];
            appDelegate.m_widgetController = self.mainView;
            
        }
        else if (flag == 3)
        {
            [Flurry logEvent:@"1_CLI_INFOMORADDI"];
            
            [self addInvoice];
        }
        else if (flag == 4)
        {
            [Flurry logEvent:@"1_CLI_INFOMOREXPE"];
            
            ExportDataViewController_ipad *exportDataController = [[ExportDataViewController_ipad alloc] initWithNibName:@"ExportDataViewController_ipad" bundle:nil];
            
            exportDataController.isSetting = 1;
            exportDataController.sel_client = self.sel_client;
            
            Custom1ViewController *exportDataNavi = [[Custom1ViewController alloc]initWithRootViewController:exportDataController];
            exportDataNavi.modalPresentationStyle = UIModalPresentationFormSheet;
            exportDataNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [self.mainView presentViewController:exportDataNavi animated:YES completion:nil];
            appDelegate.m_widgetController = self.mainView;
            
        }
        else if (flag == 5)
        {
            [Flurry logEvent:@"1_CLI_INFOMOREDITC"];
            
            NewClientViewController_ipad *editClientView = [[NewClientViewController_ipad alloc] initWithNibName:@"NewClientViewController_ipad" bundle:nil];
            
            editClientView.navTittle = @"Edit Client";
            editClientView.delegate = self;
            editClientView.myclient = self.sel_client;
            
            Custom1ViewController *editClientNavi = [[Custom1ViewController alloc]initWithRootViewController:editClientView];
            editClientNavi.modalPresentationStyle = UIModalPresentationFormSheet;
            editClientNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [self.mainView presentViewController:editClientNavi animated:YES completion:nil];
            appDelegate.m_widgetController = self.mainView;
            
        }
        
    }
    else if (actionSheet.tag == 3)
    {
        if (buttonIndex == 0)
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            self.changelog = nil;
            self.sel_client.beginTime = nil;
            self.sel_client.endTime = nil;
            
            self.sel_client.accessDate = [NSDate date];
            
            [context save:nil];
            
            
            //syncing
            [appDelegate.parseSync updateClientFromLocal:self.sel_client];
            
            
            
            [self initClientData];
            [self.myTimer  invalidate];
        }
    }
}








-(void)onMyTimer
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    int totalSeconds;
    
    //开始时间比当前时间要早，设置时间，金钱的显示
    if (!([self.sel_client.beginTime compare:[NSDate date]] == NSOrderedDescending))
    {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.sel_client.beginTime];
        totalSeconds = (int)timeInterval;
        //设置时间
        [self setTotalTimeLbelText:totalSeconds withBeginTimeNil:NO];
        
        NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:[appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime] totalTime:nil totalTimeInt:totalSeconds];
        NSString *money = [backArray objectAtIndex:0];
        if ( [money doubleValue] == 0)
        {
            [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];

        }
        else
        {
            [self.totalMoneyView setAmountSize:27 pointSize:21 Currency:appDelegate.currencyStr Amount:money color:[HMJNomalClass creatAmountColor]];
        }
    }
    
    
    if ( self.sel_client != nil && self.sel_client.clientName != nil && self.sel_client.endTime != nil)
    {
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        totalSeconds = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
        
        self.changelog = nil;
        
        Logs *addLog = nil;
        if (totalSeconds >= 1)
        {
            addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
            
            addLog.finalmoney = @"0:00";
            addLog.client = self.sel_client;
            addLog.starttime = self.sel_client.beginTime;
            addLog.endtime = self.sel_client.endTime;
            addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
            
            NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
            addLog.totalmoney = [backArray objectAtIndex:0];
            addLog.worked = [backArray objectAtIndex:1];
            
            addLog.notes = @"";
            addLog.isInvoice = [NSNumber numberWithBool:NO];
            addLog.isPaid = [NSNumber numberWithInt:0];
            
            addLog.sync_status = [NSNumber numberWithInteger:0];
            addLog.accessDate = [NSDate date];
            addLog.uuid = [appDelegate getUuid];
            addLog.client_Uuid = self.sel_client.uuid;
            
            self.changelog = addLog;
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        
        self.sel_client.accessDate = [NSDate date];
        
        [context save:nil];
        
        
        
        //syncing
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];

        
        
        [self initClientData];
        [self.myTimer  invalidate];
        [self.mainView reflashLeftPageView];
    }
}






-(void)saveStartTimeDate:(NSDate *)_startDate
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (self.sel_client.beginTime != nil)
    {
        self.sel_client.endTime = _startDate;
        
        self.changelog = nil;
        
        Logs *addLog = nil;
        if ( self.sel_client != nil && self.sel_client.clientName != nil && [self.sel_client.endTime compare:self.sel_client.beginTime] == NSOrderedDescending)
        {
            NSTimeInterval timeInterval = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
            int totalSeconds = (int)timeInterval;
            
            if (totalSeconds >= 1)
            {
                addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
                
                addLog.finalmoney = @"0:00";
                addLog.client = self.sel_client;
                addLog.starttime = self.sel_client.beginTime;
                addLog.endtime = self.sel_client.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = self.sel_client.uuid;

                self.changelog = addLog;
            }
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        
        self.sel_client.accessDate = [NSDate date];
    
        [context save:nil];
        
        
        
        //syncing
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [appDelegate.parseSync updateLogFromLocal:addLog];
        
        
        
        [self initClientData];
        [self.mainView reflashLeftPageView];
    }
    else
    {
        self.sel_client.beginTime = _startDate;
        self.sel_client.accessDate = [NSDate date];
        [context save:nil];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [self initClientData];
    }
    
    
    if ([self.popoverController isPopoverVisible])
    {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}











#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

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
    return [self.clientLogArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString* identifier = @"identifier";
    TimeStartViewCell *cell = (TimeStartViewCell*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[TimeStartViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
        
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [self.clientLogArray objectAtIndex:indexPath.row];
    
    
    
    if ([sel_log.isPaid intValue] == 1)
    {
        [cell.clockImageV setHidden:NO];
    }
    else
    {
        [cell.clockImageV setHidden:YES];
    }
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:[NSArray arrayWithObject:sel_log]];
    NSNumber *back_time = [backArray objectAtIndex:1];
    long seconds = (long)([back_time doubleValue]*3600);
    NSString *overString = @"";
    NSNumber *overMoney = 0;
    if (seconds/3600 == 0 && (seconds/60)%60 == 0)
    {
        ;
    }
    else
    {
        overMoney = [backArray objectAtIndex:0];
        
        overString = [NSString stringWithFormat:@" (%01ldh %02ldm)",seconds/3600,(seconds/60)%60];
    }
    if([overString length]>0)
    {
        NSString *duationString = [appDelegate conevrtTime:sel_log.worked];
        NSString *totalString = [NSString stringWithFormat:@"%@%@",duationString,overString];
        NSMutableAttributedString *totalStringAttr = [[NSMutableAttributedString alloc]initWithString:totalString];
        NSRange duationRange = NSMakeRange(0, [duationString length]);
        NSRange overRange = NSMakeRange(duationRange.length, [overString length]);
        UIFont *duationFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
        UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
        UIColor *duationColor = [HMJNomalClass creatBlackColor_20_20_20];
        UIColor *overColor = [HMJNomalClass creatRedColor_244_79_68];
        [totalStringAttr addAttribute:NSFontAttributeName value:duationFont range:duationRange];
        [totalStringAttr addAttribute:NSFontAttributeName value:overFont range:overRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:duationColor range:duationRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:overColor range:overRange];
        cell.totalTimeLabel.text = nil;
        cell.totalTimeLabel.attributedText = totalStringAttr;
    }
    else
        cell.totalTimeLabel.text = [appDelegate conevrtTime:sel_log.worked];
    cell.pointInTimeLabel.text = [NSString stringWithFormat:@"at %@",[[pointInTimeDateFormatter stringFromDate:sel_log.starttime] lowercaseString]];;
    cell.dateLabel.text = [dayDateFormatter stringFromDate:sel_log.starttime];
    double totalMoney = [sel_log.totalmoney doubleValue] + [overMoney doubleValue];
    [cell.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalMoney] color:[HMJNomalClass creatAmountColor]];
    [cell.amountView setNeedsDisplay];
    
    
    if (indexPath.row == [self.clientLogArray count]-1)
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditLogViewController_ipad *editLogView = [[EditLogViewController_ipad alloc] initWithNibName:@"EditLogViewController_ipad" bundle:nil];
    editLogView.selectLog = [self.clientLogArray objectAtIndex:indexPath.row];
    
    Custom1ViewController *editLogNavi = [[Custom1ViewController alloc]initWithRootViewController:editLogView];
    editLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self.mainView presentViewController:editLogNavi animated:YES completion:nil];
    appDelegate.m_widgetController = self.mainView;
    
}



-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Logs *_selectLog = [self.clientLogArray objectAtIndex:indexPath.row];
    
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
    Logs *_selectLog = [self.clientLogArray objectAtIndex:indexPath.row];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [self.clientLogArray removeObject:_selectLog];
    
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    [context save:nil];
    
    
    //syncing
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];

    
    
    //syncing
    [appDelegate.parseSync updateLogFromLocal:_selectLog];
    
    

    [self.myTableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.myTableView endUpdates];
    if (indexPath.row == [self.clientLogArray count] && [self.clientLogArray count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.clientLogArray count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    [self.mainView reflashLeftPageView];
}


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








-(void)saveClient:(Clients *)_client
{
    [self initClientData];
    [self.mainView reflashLeftPageView];
    
}



-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)pop_system_UnlockLite
{
    float higt = self.view.frame.size.height-160;
    self.containView.frame = CGRectMake(self.containView.frame.origin.x, self.containView.frame.origin.y, self.containView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];

}


@end
