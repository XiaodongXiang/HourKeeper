//
//  TimerLeftViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 5/23/13.
//
//

#import "TimerLeftViewController_ipad.h"

#import "Custom1ViewController.h"
#import "UINavigationBar_ipad.h"

#import "AppDelegate_Shared.h"
#import "Invoice.h"
#import "Logs.h"

#import "CaculateMoney.h"
#import "Timer_Cell.h"
#import "TimerMainViewController.h"

@implementation TimerLeftViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _onClockTimerLogsArray = [[NSMutableArray alloc] init];
        _pauseTimerLogsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initPoint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getTodayAllWorkTime];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.flashTimerStartView = nil;
    [self initTimerAarry];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.myTimer isValid])
    {
        [self.myTimer  invalidate];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{

    if ([self.myTimer isValid])
    {
        [self.myTimer  invalidate];
    }
}

#pragma mark Action
-(void)initPoint
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.titleLabel.font = appDelegate.naviFont;
    self.editButton.frame = CGRectMake(0, 0, 48, 30);
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton setTitle:@"Done" forState:UIControlStateSelected];
    self.editButton.selected = NO;
    [self.editButton addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:self.editButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 30);
    [addButton setImage:[UIImage imageNamed:@"ipad_icon_add3.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"ipad_icon_add3_sel.png"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    appDelegate.naviBarWitd = -7;
    
    [appDelegate setNaviGationItem:self isLeft:NO button:addButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Clients"];
    [self.navigationController.navigationBar drawNavigationBarFor_ipad];
    
    
    [self.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.overMoneyLabel creatSubViewsisLeftAlignment:NO];
}

//设置底下的totalTime,totalMoney,overTime,overMoney
-(void)getTodayAllWorkTime
{
    
    //获取所有有效的client
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSArray *requests = [appDelegate getAllClient];
    allSeconds = 0;
    allMoney = 0;
    allOverSeconds = 0;
    allOverMoney = 0;
    
    for(int i=0;i<[requests count]; i++)
    {
        
        
        //获取这个Client今天的Logs
        Clients *oneClient = [requests objectAtIndex:i];
        NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
        NSDate *today = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        dateComponent = [cal components:unit fromDate:today];
        dateComponent.hour = 0;
        dateComponent.minute = 0;
        dateComponent.second=0;
        
        NSDateComponents *dateComp2 = [cal components:unit fromDate:today];
        dateComp2.hour = 23;
        dateComp2.minute = 59;
        dateComp2.second=59;
        
        NSDate *todayStart = [cal dateFromComponents:dateComponent];
        NSDate *todayEnd = [cal dateFromComponents:dateComp2];
        
        NSArray *logsArray = [appDelegate getOverTime_Log:oneClient    startTime:todayStart endTime:todayEnd isAscendingOrder:YES];
        
        //计算总时间与走看总金额
        for (int m=0; m<[logsArray count]; m++)
        {
            Logs *oneLog = [logsArray objectAtIndex:m];
            
            NSString *client_timelength = (oneLog.worked == nil) ? @"0:00":oneLog.worked;
            NSArray *client_timeArray = [client_timelength componentsSeparatedByString:@":"];
            int unit_hours = [[client_timeArray objectAtIndex:0] intValue];
            int unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
            allSeconds += unit_hours*3600+unit_minutes*60;
            allMoney += [oneLog.totalmoney doubleValue];
        }
        
        //计算每一个Client超出的时间与金钱
        if ([logsArray count]>0)
        {
            NSArray *backArray = [appDelegate overTimeMoney_logs:logsArray];
            NSNumber *back_money = [backArray objectAtIndex:0];
            NSNumber *back_time = [backArray objectAtIndex:1];
            allOverSeconds += (long)([back_time doubleValue]*3600);
            allOverMoney += [back_money doubleValue];
        }
        
        
    }
    
    
    self.totalTimeLbel.text = [appDelegate conevrtTime2:(int)allSeconds];
    [self.totalMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",allMoney] color:[HMJNomalClass creatAmountColor]];
    [self.totalMoneyLbel setNeedsDisplay];
    
    self.m_overTimeLbel.text = [appDelegate conevrtTime2:(int)allOverSeconds];
    [self.overMoneyLabel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",allOverMoney] color:[HMJNomalClass creatAmountColor]];
    [self.overMoneyLabel setNeedsDisplay];
    
}

//获取数组
-(void)initTimerAarry
{

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    [self.onClockTimerLogsArray removeAllObjects];
    [self.pauseTimerLogsArray removeAllObjects];
    
    NSArray *requests = [appDelegate getAllClient];
    
    //免费版第一次需要显示广告
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == NO)
    {
        NSArray *requests2 = [appDelegate getAllLog];
        
        if ([requests2 count] > 0)
        {
            [self.lite_Btn setHidden:NO];
            appDelegate.lite_adv = YES;
            
            NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
            [defaults2 setInteger:1 forKey:NEED_SHOW_LITE_ADV_FLAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    //显示广告
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == YES)
    {
        float higt = self.view.frame.size.height-self.lite_Btn.frame.size.height;
        self.containView.frame = CGRectMake(self.containView.left, self.containView.top, self.containView.width, higt);
        
        if (appDelegate.lite_adv == YES)
        {
            [self.lite_Btn setHidden:NO];
        }
        else
        {
            [self.lite_Btn setHidden:YES];
        }
        
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    
    
    
    
    
    
    for (int i=0; i<[requests count]; i++)
    {
        Clients *_client = [requests objectAtIndex:i];
        
        if (_client.beginTime != nil)
        {
            [self.onClockTimerLogsArray addObject:_client];
        }
        else
        {
            [self.pauseTimerLogsArray addObject:_client];
        }
    }
    
    
    
    NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:NO];
    [self.onClockTimerLogsArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    
    
    if (self.selectClient != nil && self.selectClient.clientName != nil)
    {
        int section = 0;
        int row = 0;
        if ([self.onClockTimerLogsArray indexOfObject:self.selectClient] != NSNotFound)
        {
            section = 0;
            row = (int)[self.onClockTimerLogsArray indexOfObject:self.selectClient];
            
            if (self.animation_CellPath != nil && self.animation_CellPath.section != section)
            {
                [self.onClockTimerLogsArray removeObject:self.selectClient];
                [self.tableView reloadData];
                [self.onClockTimerLogsArray insertObject:self.selectClient atIndex:row];
                
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self.tableView insertRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
        else if ([self.pauseTimerLogsArray indexOfObject:self.selectClient] != NSNotFound)
        {
            section = 1;
            row = (int)[self.pauseTimerLogsArray indexOfObject:self.selectClient];
            
            if ((self.animation_CellPath != nil && self.animation_CellPath.section != section)
                || self.animation_CellPath == nil)
            {
                [self.pauseTimerLogsArray removeObject:self.selectClient];
                [self.tableView reloadData];
                [self.pauseTimerLogsArray insertObject:self.selectClient atIndex:row];
                
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self.tableView insertRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
            else
            {
                [self.tableView reloadData];
            }
        }
        else
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        [self.tableView reloadData];
    }
    
    self.animation_CellPath = nil;
    self.selectClient = nil;
    
    
    if (self.flashTimerStartView != nil)
    {
        [self.flashTimerStartView initClientData];
    }
    
    
    
    if ([self.onClockTimerLogsArray count]+[self.pauseTimerLogsArray count] == 0)
    {
        [self.tableView setEditing:NO animated:YES];
        
        [self.editButton setUserInteractionEnabled:NO];
    }
    else
    {
        [self.editButton setUserInteractionEnabled:YES];
    }
    
    
    [self getTodayAllWorkTime];
    
    if ([self.myTimer isValid])
    {
        [self.myTimer  invalidate];
    }
    if ([self.onClockTimerLogsArray count] > 0)
    {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onMyTimer) userInfo:nil repeats:YES];
    }
    
}









-(void)onMyTimer
{
    for (int i=0;i<[self.onClockTimerLogsArray count];i++)
    {
        Clients *ontimerClient = [self.onClockTimerLogsArray objectAtIndex:i];
        
        Timer_Cell *mycell = (Timer_Cell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:i inSection:0]];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
        int totalSeconds;
        if ([ontimerClient.beginTime compare:[NSDate date]] == NSOrderedDescending)
        {
            mycell.totalTimeLbel.text = [appDelegate conevrtTime3:0];
            
            
            [mycell.totalMoneyView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];
        }
        else
        {
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:ontimerClient.beginTime];
            totalSeconds = (int)timeInterval;
            mycell.totalTimeLbel.text = [appDelegate conevrtTime3:totalSeconds];
            
            NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:ontimerClient rate:[appDelegate getRateByClient:ontimerClient date:ontimerClient.beginTime] totalTime:nil totalTimeInt:totalSeconds];
            NSString *moneyStr = [backArray objectAtIndex:0];
            
            [mycell.totalMoneyView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:moneyStr color:[HMJNomalClass creatAmountColor]];
            
        }
        
        //endTime 到点了会添加一个Log。
        if (ontimerClient != nil && ontimerClient.clientName != nil && ontimerClient.endTime != nil)
        {
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            totalSeconds = [ontimerClient.endTime timeIntervalSinceDate:ontimerClient.beginTime];
            
            Logs *addLog = nil;
            //???
            if (totalSeconds >= 1)
            {
                addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
                
                addLog.finalmoney = @"0:00";
                addLog.client = ontimerClient;
                addLog.starttime = ontimerClient.beginTime;
                addLog.endtime = ontimerClient.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:ontimerClient date:ontimerClient.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:ontimerClient rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = ontimerClient.uuid;
            }
            ontimerClient.beginTime = nil;
            ontimerClient.endTime = nil;
            
            ontimerClient.accessDate = [NSDate date];
            
            [context save:nil];
            
            
            
            //syncing
//            NSMutableArray *dataMarray = [[NSMutableArray alloc] initWithObjects:ontimerClient, nil];
//            if (addLog != nil)
//            {
//                [dataMarray addObject:addLog];
//            }
            [appDelegate.parseSync updateClientFromLocal:ontimerClient];
            [appDelegate.parseSync updateLogFromLocal:addLog];
//            [appDelegate localToServerSync:dataMarray isRelance:NO];
            
            
            
            [self.mainView reflashTimerMainView];
            
            
            [self.onClockTimerLogsArray removeObject:ontimerClient];
            [self.tableView reloadData];
            [self.pauseTimerLogsArray insertObject:ontimerClient atIndex:0];
            NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"clientName" ascending:YES];
            [self.pauseTimerLogsArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
            
            if ([self.pauseTimerLogsArray count]+[self.onClockTimerLogsArray count] == 1)
            {
                [self.tableView reloadData];
            }
            else
            {
                int indext = (int)[self.pauseTimerLogsArray indexOfObject:ontimerClient];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indext inSection:1];
                NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
            i--;
            
            
            if ([self.onClockTimerLogsArray count] == 0)
            {
                [self.myTimer  invalidate];
            }
            
        }
    }
    
    
//    //设置总时间，金钱，超出的时间，金钱
//    [self getTodayAllWorkTime];
}


-(void)doEdit
{
    if ([self.tableView isEditing])
    {
//        self.editButton.titleLabel.font = appDelegate.naviFont;
//        self.editButton.frame = CGRectMake(self.editButton.frame.origin.x, self.editButton.frame.origin.y, 48, 30);
//        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        
		[self.tableView setEditing:NO animated:YES];
	}
    else
    {
//        self.editButton.titleLabel.font = appDelegate.naviFont2;
//        self.editButton.frame = CGRectMake(self.editButton.frame.origin.x, self.editButton.frame.origin.y, 51, 30);
//        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        
		[self.tableView setEditing:YES animated:YES];
	}
}

-(void)doAdd
{
    [Flurry logEvent:@"1_CLI_ADD"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isPurchased == NO)
    {
        NSArray *requests = [appDelegate getAllClient];
        
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        if ([requests count]>1 && [[defaults2 stringForKey:LITE_CLIENT_UNLIMITCONUT] isEqualToString:@"NO"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of clients allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
            alertView.tag = 1;
            [alertView show];
            
            appDelegate.close_PopView = alertView;
            
            return;
        }
    }
    
    NewClientViewController_ipad *addClientView = [[NewClientViewController_ipad alloc] initWithNibName:@"NewClientViewController_ipad" bundle:nil];
    
    addClientView.navTittle = @"New Client";
    addClientView.delegate = self;
    addClientView.myclient = nil;
    
    Custom1ViewController *addClientNavi = [[Custom1ViewController alloc]initWithRootViewController:addClientView];
    addClientNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    addClientNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.mainView presentViewController:addClientNavi animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
    
}





#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.onClockTimerLogsArray count] == 0)
    {
        return 0;
    }
    
    if (section == 1 && [self.pauseTimerLogsArray count] == 0)
    {
        return 0;
    }
    
    return 24;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.onClockTimerLogsArray count]+[self.pauseTimerLogsArray count] == 0)
    {
        [self.tipImagV setHidden:NO];
    }
    else
    {
        [self.tipImagV setHidden:YES];
    }
    
    if (section == 0)
    {
        return [self.onClockTimerLogsArray count];
    }
    else
    {
        return [self.pauseTimerLogsArray count];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    v.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 24-SCREEN_SCALE, SCREEN_WITH, SCREEN_SCALE)];
    line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    [v addSubview:line];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200,20)];
	label.textAlignment = NSTextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    label.textColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
	[v addSubview:label];
    
    if ([self.onClockTimerLogsArray count]>0 && section == 0)
    {
        label.text = [@"On the clock"uppercaseString];
    }
    if ([self.pauseTimerLogsArray count]>0 && section == 1)
    {
        label.text = [@"Off the clock"uppercaseString];
        
    }
	
    return v;
}


#pragma mark -   change
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    Timer_Cell *seleCell = (Timer_Cell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //---根据选定的cell的状态来更改tableView的状态
    if (seleCell.editing) {
        self.editButton.selected = NO;
        return NO;
    }
    else{
//        self.editButton.selected = YES;
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editButton.selected = YES;
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier;
    if (self.tableView.isEditing == YES)
    {
        identifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    }
    else
    {
        identifier = @"timerCell-Identifier";
    }
	Timer_Cell *mytimerCells = (Timer_Cell*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
	if (mytimerCells == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"Timer_Cell" owner:self options:nil];
		
		for (id oneObject in nibs)
		{
			if ([oneObject isKindOfClass:[Timer_Cell class]])
			{
				mytimerCells = (Timer_Cell*)oneObject;
                mytimerCells.accessoryType = UITableViewCellAccessoryNone;

			}
		}
    }
    
//    UIImageView *backImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
//    [mytimerCells setBackgroundView:backImage];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    Clients *showclient;
    
    //on the clock
    if (indexPath.section == 0)
    {
        showclient = [self.onClockTimerLogsArray objectAtIndex:indexPath.row];
        
        mytimerCells.startDateLbel.text = [NSString stringWithFormat:@"Since %@",[dateFormatter stringFromDate:showclient.beginTime]];
        
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
        if ([showclient.beginTime compare:[NSDate date]] == NSOrderedDescending)
        {
            mytimerCells.totalTimeLbel.text = [appDelegate conevrtTime3:0];
            
            [mytimerCells.totalMoneyView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",0.00] color:[HMJNomalClass creatAmountColor]];
            
        }
        else
        {
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:showclient.beginTime];
            int totalSeconds = (int)timeInterval;
            mytimerCells.totalTimeLbel.text = [appDelegate conevrtTime3:totalSeconds];
            
            NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:showclient rate:[appDelegate getRateByClient:showclient date:showclient.beginTime] totalTime:nil totalTimeInt:totalSeconds];
            NSString *moneyStr = [backArray objectAtIndex:0];
            
            [mytimerCells.totalMoneyView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:moneyStr color:[HMJNomalClass creatAmountColor]];

        }

        [mytimerCells.startDateLbel setHidden:NO];
        [mytimerCells.totalTimeLbel setHidden:NO];
        mytimerCells.totalMoneyView.hidden = NO;
        mytimerCells.amountView.hidden = YES;

        
        if (indexPath.row == [self.onClockTimerLogsArray count]-1)
        {
            mytimerCells.bottomLine.left = 0;
        }
        else
            mytimerCells.bottomLine.left = 15;
        
    }
    else
    {
        
        showclient = [self.pauseTimerLogsArray objectAtIndex:indexPath.row];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        mytimerCells.totalTimeLbel.text = [appDelegate conevrtTime3:0];
        mytimerCells.startDateLbel.text = @"";
        
        NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:showclient date:showclient.beginTime]];
        
        [mytimerCells.startDateLbel setHidden:YES];
        [mytimerCells.totalTimeLbel setHidden:YES];
        [mytimerCells.totalMoneyView setHidden:YES];
        mytimerCells.amountView.hidden = NO;
        
        [mytimerCells.amountView setAmountSize:25 pointSize:20 hourSize:13 Currency:appDelegate.currencyStr Amount:showMoney color:[HMJNomalClass creatAmountColor]];

        
        
//        mytimerCells.clientNameLbel.top = (50-mytimerCells.clientNameLbel.height)/2;
        
        
        
        if (indexPath.row == [self.pauseTimerLogsArray count]-1)
        {
            mytimerCells.bottomLine.left = 0;
        }
        else
            mytimerCells.bottomLine.left = 15;
    }
    mytimerCells.clientNameLbel.text = showclient.clientName;
    mytimerCells.totalTimeLbel.textColor=[HMJNomalClass creatBtnBlueColor_17_155_227];

    
    
    return mytimerCells;
    
}













- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing == YES)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Clients *sel_client;
        if (indexPath.section == 0)
        {
            sel_client = [self.onClockTimerLogsArray objectAtIndex:indexPath.row];
        }
        else
        {
            sel_client = [self.pauseTimerLogsArray objectAtIndex:indexPath.row];
        }
        
        
        NewClientViewController_ipad *editClientView = [[NewClientViewController_ipad alloc] initWithNibName:@"NewClientViewController_ipad" bundle:nil];
        
        editClientView.navTittle = @"Edit Client";
        editClientView.delegate = self;
        editClientView.myclient = sel_client;
        
        Custom1ViewController *editClientNavi = [[Custom1ViewController alloc]initWithRootViewController:editClientView];
        editClientNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        editClientNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [self.mainView presentViewController:editClientNavi animated:YES completion:nil];
        appDelegate.m_widgetController = self.mainView;
        
    }
    else
    {
        self.animation_CellPath = indexPath;
        
        if (indexPath.section == 0)
        {
            self.selectClient = [self.onClockTimerLogsArray objectAtIndex:indexPath.row];
        }
        else
        {
            self.selectClient = [self.pauseTimerLogsArray objectAtIndex:indexPath.row];
        }
        
        
        self.startTimeController = [[TimerStartViewController_ipad alloc] initWithNibName:@"TimerStartViewController_ipad" bundle:nil];
        
        self.startTimeController.sel_client = self.selectClient;
        self.startTimeController.mainView = self.mainView;
        
        self.flashTimerStartView = self.startTimeController;
        
        [self.navigationController pushViewController:self.startTimeController animated:YES];
        
    }
    
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Flurry logEvent:@"1_CLI_DEL"];
    
    if (indexPath.section == 0)
    {
        self.delectClient = [self.onClockTimerLogsArray objectAtIndex:indexPath.row];
    }
    else
    {
        self.delectClient = [self.pauseTimerLogsArray objectAtIndex:indexPath.row];
    }
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Delete this client will also delete all the logs and invoices associated with it!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alertView.tag = 2;
    [alertView show];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = alertView;
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            if (self.delectClient.beginTime != nil)
            {
                int row = (int)[self.onClockTimerLogsArray indexOfObject:self.delectClient];
                [self.onClockTimerLogsArray removeObject:self.delectClient];
                
                
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                
                if ([self.pauseTimerLogsArray count] == 0 && indexPath.row == [self.onClockTimerLogsArray count] && [self.onClockTimerLogsArray count] != 0)
                {
                    NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.onClockTimerLogsArray count]-1 inSection:0];
                    NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
                    [self.tableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
                }
                
                [[DataBaseManger getBaseManger] do_deletClient:self.delectClient withManual:YES];

            }
            else
            {
                int row = (int)[self.pauseTimerLogsArray indexOfObject:self.delectClient];
                [self.pauseTimerLogsArray removeObject:self.delectClient];
                
                
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                if (indexPath.row == [self.pauseTimerLogsArray count] && [self.pauseTimerLogsArray count] != 0)
                {
                    NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.pauseTimerLogsArray count]-1 inSection:1];
                    NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
                    [self.tableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
            //delete & sync
            [[DataBaseManger getBaseManger] do_deletClient:self.delectClient withManual:YES];
            
            
            //刷新
            [self.mainView reflashLeftPageView];
            
            if ([self.onClockTimerLogsArray count] == 0)
            {
                [self.myTimer  invalidate];
            }
            
            if ([self.onClockTimerLogsArray count]+[self.pauseTimerLogsArray count] == 0)
            {
//                self.editButton.frame = CGRectMake(self.editButton.frame.origin.x, self.editButton.frame.origin.y, 48, 30);
                [self.tableView setEditing:NO animated:YES];
                
                [self.editButton setUserInteractionEnabled:NO];
            }
        }
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"7_ADS_CLI2"];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPurchase_Lite];
        }
    }

}





-(void)saveClient:(Clients *)_client
{
    [self initTimerAarry];
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
    float higt = self.view.height;
    self.containView.frame = CGRectMake(self.containView.frame.origin.x, self.containView.frame.origin.y, self.containView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];

}

-(void)setContainViewHeight
{
    
}


@end
