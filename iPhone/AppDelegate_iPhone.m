//
//  AppDelegate_iPhone.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "Settings.h"
#import "TimeSheetViewController.h"
#import "DashBoardViewController.h"
#import "TimersViewController_iphone.h"
#import "InvoiceNewViewController.h"
#import "ChartViewController_new.h"
#import "SettingsViewController_New.h"
#import "Appirater.h"


#import "HMJMainViewController.h"
#import "Logs.h"
//#import "NomalTool.h"

@implementation AppDelegate_iPhone


@synthesize isShowTip,m_kTileSize;


#pragma mark aplication
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化session
//    if ([WCSession isSupported]) {
//        self.watchSession = [WCSession defaultSession];
//        self.watchSession.delegate = self;
//        [self.watchSession activateSession];
//    }
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.m_kTileSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/7, 35);
    if (IS_IPHONE_5)
    {
        self.m_kTileSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/7, 35);
    }
    else if (IS_IPHONE_6)
        self.m_kTileSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/7, 40);
    else if(IS_IPHONE_6PLUS)
        self.m_kTileSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/7, 43);

    
    //弹出登陆页面
    PFUser *tmpuser = [PFUser currentUser];
    if (tmpuser[@"username"] != nil)
    {
        //如果已经登陆上了，就要求继续登陆
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (![userDefault boolForKey:kAppUseAppNeedParse]) {
            [userDefault setBool:YES forKey:kAppUseAppNeedParse];
            [userDefault synchronize];
        }
        
        [self setCurrentUser];
        [self launchAfterSignIn];
        [self.parseSync syncAllWithTip:NO];
    }
    else if (!self.needLoginParse)
    {
        //不需要登陆parse也可以使用app
        [self launchAfterSignIn];
    }
    else
    {
        [self logInVC];
        [self doRateApp];
    }
//    [self add2000Client];
    return YES;
}

//-(void)add2000Client
//{
//    for (int i=0; i<1500; i++)
//    {
//        Clients *newClient = [NSEntityDescription insertNewObjectForEntityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
//        
//        newClient.beginTime = nil;
//        newClient.endTime = nil;
//        
//        newClient.clientName = [NSString stringWithFormat:@"Client%d",i];
//        newClient.sync_status = [NSNumber numberWithInteger:0];
//        newClient.uuid = [self getUuid];
//        newClient.r_isDaily = [NSNumber numberWithInt:0];
//        newClient.ratePerHour = [NSString stringWithFormat:@"%d",i+1];
//        newClient.accessDate = [NSDate date];
//        [self.managedObjectContext save:nil];
//        
//        [self.parseSync updateClientFromLocal:newClient];
//    }
//}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [super application:application handleOpenURL:url];
    
    return YES;
}

/**
 Widget使用URL打开应用,Dropbox也是
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    //加入密码页面，但是没有加touch事件
    self.isShowTip = [self addPassView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [super applicationWillEnterForeground:application];
    
    
    if (self.isShowTip == NO)
    {
        [self doRateApp];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [super applicationWillTerminate:application];
}



#pragma mark Action
- (BOOL)addPassView
{
    if ([self.appSetting.isPasscodeOn boolValue])
    {
        [self.passViewController.view removeFromSuperview];
        if (self.passViewController == nil)
        {
            _passViewController = [[CheckPasscodeViewController_iPhone alloc] initWithNibName:@"CheckPasscodeViewController_iPhone" bundle:nil];
            _passViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
        [self.window addSubview:self.passViewController.view];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

//显示rate页面
-(void)showRateOrWhatNew
{
    if (self.popAlertFlag == 1)
    {
        if (self.rateControl == nil)
        {
            _rateControl = [[RateViewController_iphone alloc] initWithNibName:@"RateViewController_iphone" bundle:nil];
            self.rateControl.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
        [self.rateControl.view removeFromSuperview];
        
        
        self.rateControl.stly = 0;
        [self.rateControl setRateOrWhatNew];
        [self.window addSubview:self.rateControl.view];
    }
    else if (self.popAlertFlag == 2)
    {
        if (self.rateControl == nil)
        {
            _rateControl = [[RateViewController_iphone alloc] initWithNibName:@"RateViewController_iphone" bundle:nil];
            self.rateControl.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
        [self.rateControl.view removeFromSuperview];
        
        
        self.rateControl.stly = 1;
        [self.rateControl setRateOrWhatNew];
        [self.window addSubview:self.rateControl.view];
    }
}





/**
    Widget触发的事件 iPhone版
 */
-(void)m_doWidgetAction
{
    
    //widget版本区分
    {
        //将timerstartvc pop掉
        if (self.m_widgetController != nil)
        {
            [self.m_widgetController dismissViewControllerAnimated:NO completion:nil];
        }
        //如果没有密码，并且可以弹widget的话就进入widget页面
        if (![self.appSetting.isPasscodeOn boolValue] && self.isWidgetFirst == NO)
        {
            [self enterWidgetDo];
        }
        else
        {
            if (self.passViewController.view.superview == nil && self.isWidgetFirst == NO)
            {
                [self enterWidgetDo];
            }
            else
            {
                self.isWidgetPrsent = YES;
            }
        }
    }
}

/**
    进入Widget触发的页面
 */
-(void)enterWidgetDo
{
    //添加log时，弹出主页面
    BOOL isPresent = NO;
    //添加log
    BOOL isAdd = NO;
    NSIndexPath *indexPath;

    NSRange range = [self.use_url.relativeString rangeOfString:WIDGET_URL0];
    
    if (range.length > 0)
    {
        //clock in
        if ([self.use_url.relativeString isEqualToString:WIDGET_URL0])
        {
            //弹到client页面
            [self.mainViewController.showingNavigationController popToRootViewControllerAnimated:NO];
            [self.mainViewController.leftMenu  btnClick:self.mainViewController.leftMenu.clientsBtn];
        }
        //点击cell进来到dashboard->timestart
        else
        {
            isPresent = YES;
            NSString *str = [self.use_url.relativeString stringByReplacingOccurrencesOfString:WIDGET_URL0 withString:@""];
            indexPath = [NSIndexPath indexPathForRow:str.intValue inSection:0];
        }
    }
    //添加额外的client在today中
    else
    {
        isPresent = YES;
        isAdd = YES;
    }
    
    
    if (isPresent == YES)
    {
        if (self.m_tabBarController.selectedIndex != 0)
        {
            [self.m_tabBarController setSelectedIndex:0];
        }
        
        //弹到最上层
        [self.mainViewController.showingNavigationController popToRootViewControllerAnimated:NO];
        [self.mainViewController.leftMenu  btnClick:self.mainViewController.leftMenu.dashBoardBtn];
        DashBoardViewController*dashVC = self.mainViewController.dashBoardVC;
        dashVC.timerstartVC = nil;
        BOOL needNext = YES;
        
        [dashVC getClientArray];
        if (isAdd == YES)
        {
            if (dashVC.clientArray.count >0)
            {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            else
            {
                needNext = NO;
            }
        }
        
        if (needNext == YES)
        {
            
            //添加第一层startVC
            dashVC.timerstartVC = [[TimerStartViewController alloc] initWithNibName:@"TimerStartViewController" bundle:nil];
            dashVC.timerstartVC.sel_client = [dashVC.clientArray objectAtIndex:indexPath.row];
            
            [dashVC.timerstartVC setHidesBottomBarWhenPushed:YES];
            [dashVC.navigationController pushViewController:dashVC.timerstartVC animated:!isAdd];
            
            
            if (isAdd == YES)
            {
                //添加第二层 addlogVC
                AddLogViewController *controller =  [[AddLogViewController alloc] initWithNibName:@"AddLogViewController" bundle:nil];
                
                controller.myclient = dashVC.timerstartVC.sel_client;
                controller.delegate = dashVC.timerstartVC;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                [dashVC.timerstartVC presentViewController:nav animated:YES completion:nil];
                self.m_widgetController = dashVC.timerstartVC;
                
            }
        }
    }
    
}





/*
    同步时刷新页面
 */
-(void)iphone_reflash_UI
{
    UIViewController *sel_viewController = (UIViewController *)[_mainViewController.showingNavigationController.viewControllers objectAtIndex:0];
    if ([sel_viewController isKindOfClass:[DashBoardViewController class]])
    {
        //该页面每秒刷新
//        DashBoardViewController *reflashViewController = (DashBoardViewController*)sel_viewController;
        
    }
    //client
    else if ([sel_viewController isKindOfClass:[TimersViewController_iphone  class]])
    {
        TimersViewController_iphone *reflashViewController = (TimersViewController_iphone*)sel_viewController;
        [reflashViewController fleshUI];
    }
    //period
    else if ([sel_viewController isKindOfClass:[TimeSheetViewController class]])
    {
        TimeSheetViewController *reflashViewController = (TimeSheetViewController*)sel_viewController;
        [reflashViewController reflashTableAndBottom];
    }
    //invoice
    else if ([sel_viewController isKindOfClass:[InvoiceNewViewController class]])
    {
        InvoiceNewViewController *reflashViewController = (InvoiceNewViewController*)sel_viewController;
        [reflashViewController initInvoiceData];
    }
    //report
    else if ([sel_viewController isKindOfClass:[ChartViewController_new class]])
    {
        ChartViewController_new *reflashViewController = (ChartViewController_new*)sel_viewController;
        [reflashViewController initChartView];
    }
}

#pragma mark LogIn
-(void)logInVC
{
    
    logInViewController = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    
    // Present the log in view controller
    logInViewController.view.tag = 999;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:logInViewController];
    self.window.rootViewController = navi;
    
}

-(void)setCurrentUser
{
    self.appUser = [PFUser currentUser];

    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.appSetting.lastUser != nil &&![appDelegate.appSetting.lastUser isEqualToString:self.appUser.objectId]  )
    {
        [appDelegate.parseSync deleteAllLocalDataBase];
        
        appDelegate.appSetting.lastUser = self.appUser.objectId;
        [appDelegate.managedObjectContext save:nil];
    }
    else
    {
        appDelegate.appSetting.lastUser = self.appUser.objectId;
        [appDelegate.managedObjectContext save:nil];
    }
}


-(void)launchAfterSignIn
{
    _mainViewController = [[HMJMainViewController alloc]init];
    _mainViewController.view.width = SCREEN_WITH;
    _mainViewController.view.height = SCREEN_HEIGHT;
    self.window.rootViewController = _mainViewController;
    [self.window makeKeyAndVisible];
    
    self.isShowTip = [self addPassView];
    
    //不弹密码的时候，判断要不要弹出评论页面
    if (self.isShowTip == NO)
    {
        [self doRateApp];
    }
}



#pragma mark PFLogInViewController Delegate
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self setCurrentUser];
    
    [self launchAfterSignIn];
    [logInController dismissViewControllerAnimated:YES completion:nil];
}
// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    
    
//    NSLog(@"Failed to log in...");
}

#pragma mark WatchOS Method
/*
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler
{
    //获取clients数组
    if ([[message objectForKey:GET_DASHBOARD_CLIENT_ARRAY]isEqualToString:GET_DASHBOARD_CLIENT_ARRAY]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status==0 && beginTime!=nil"];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if(error==nil)
        {
            NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
            for (int i=0; i<[fetchedObjects count]; i++) {
                Clients *oneClient = [fetchedObjects objectAtIndex:i];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                            oneClient.uuid,PF_CLIENT_UUID
                                            ,nil];
                
                if (oneClient.payPeriodNum1 !=nil)
                    [dic setObject:oneClient.payPeriodNum1 forKey:PF_CLIENT_PAYPERIODNUM1];
                
                if (oneClient.beginTime !=nil)
                    [dic setObject:oneClient.beginTime forKey:PF_CLIENT_BEGINTIME];
                
                if (oneClient.r_tueRate !=nil)
                    [dic setObject:oneClient.r_tueRate forKey:PF_CLIENT_R_TUERATE];
                
                if (oneClient.payPeriodStly !=nil)
                    [dic setObject:oneClient.payPeriodStly forKey:PF_CLIENT_PAYPERIODSTLY];
                
                if (oneClient.r_wedRate !=nil)
                    [dic setObject:oneClient.r_wedRate forKey:PF_CLIENT_R_WEDRATE];
                
                if (oneClient.r_satRate !=nil)
                    [dic setObject:oneClient.r_satRate forKey:PF_CLIENT_R_SATRATE];
                
                if (oneClient.r_sunRate !=nil)
                    [dic setObject:oneClient.r_sunRate forKey:PF_CLIENT_R_SUNRATE];
                
                if (oneClient.dailyOverFirstHour !=nil)
                    [dic setObject:oneClient.dailyOverFirstHour forKey:PF_CLIENT_DAILYOVERFIRSTHOUR];
                
                if (oneClient.address !=nil && [oneClient.address length]>0)
                    [dic setObject:oneClient.address forKey:PF_CLIENT_ADDRESS];
                
                if (oneClient.weeklyOverSecondTax !=nil)
                    [dic setObject:oneClient.weeklyOverSecondTax forKey:PF_CLIENT_WEEKLYOVERSECONDTAX];
                
                if (oneClient.clientName !=nil)
                    [dic setObject:oneClient.clientName forKey:PF_CLIENT_CLIENTNAME];
                
                if (oneClient.timeRoundTo !=nil)
                    [dic setObject:oneClient.timeRoundTo forKey:PF_CLIENT_TIMEROUNDTO];
                
                if (oneClient.dailyOverFirstTax !=nil)
                    [dic setObject:oneClient.dailyOverFirstTax forKey:PF_CLIENT_DAILYOVERFIRSTTAX];
                
                if (oneClient.accessDate !=nil)
                    [dic setObject:oneClient.accessDate forKey:PF_CLIENT_ACCESSDATE];
                
                if (oneClient.lunchTime !=nil)
                    [dic setObject:oneClient.lunchTime forKey:PF_CLIENT_LUNCHTIME];
                
                if (oneClient.website !=nil)
                    [dic setObject:oneClient.website forKey:PF_CLIENT_WEBSITE];
                
                if (oneClient.payPeriodDate !=nil)
                    [dic setObject:oneClient.payPeriodDate forKey:PF_CLIENT_PAYPERIODDATE];
                
                if (oneClient.r_thuRate !=nil)
                    [dic setObject:oneClient.r_thuRate forKey:PF_CLIENT_R_THURATE];
                
                if (oneClient.endTime !=nil)
                    [dic setObject:oneClient.endTime forKey:PF_CLIENT_ENDTIME];
                
                if (oneClient.payPeriodNum2 !=nil)
                    [dic setObject:oneClient.payPeriodNum2 forKey:PF_CLIENT_PAYPERIODNUM2];
                
                if (oneClient.email !=nil)
                    [dic setObject:oneClient.email forKey:PF_CLIENT_EMAIL];
                
                if (oneClient.dailyOverSecondHour !=nil)
                    [dic setObject:oneClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];
                
                if (oneClient.lunchStart !=nil)
                    [dic setObject:oneClient.lunchStart forKey:PF_CLIENT_LUNCHSTART];
                
                if (oneClient.r_friRate !=nil)
                    [dic setObject:oneClient.r_friRate forKey:PF_CLIENT_R_FRIRATE];
                
                if (oneClient.sync_status !=nil)
                    [dic setObject:oneClient.sync_status forKey:PF_SYNCSTATUS];
                
                if (oneClient.weeklyOverFirstTax !=nil)
                    [dic setObject:oneClient.weeklyOverFirstTax forKey:PF_CLIENT_WEEKLYOVERFIRSTTAX];
                
                if (oneClient.r_isDaily !=nil)
                    [dic setObject:oneClient.r_isDaily forKey:PF_CLIENT_R_ISDAILY];
                
                if (oneClient.dailyOverSecondTax !=nil)
                    [dic setObject:oneClient.dailyOverSecondTax forKey:PF_CLIENT_DAILYOVERSECONDTAX];
                
                if (oneClient.dailyOverSecondHour !=nil)
                    [dic setObject:oneClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];
                
                if (oneClient.r_monRate !=nil)
                    [dic setObject:oneClient.r_monRate forKey:PF_CLIENT_R_MONRATE];
                
                if (oneClient.ratePerHour !=nil)
                    [dic setObject:oneClient.ratePerHour forKey:PF_CLIENT_RATEPERHOUR];
                
                if (oneClient.fax !=nil)
                    [dic setObject:oneClient.fax forKey:PF_CLIENT_FAX];
                
                if (oneClient.r_weekRate !=nil)
                    [dic setObject:oneClient.r_weekRate forKey:PF_CLIENT_R_WEEKRATE];
                
                if (oneClient.weeklyOverFirstHour !=nil)
                    [dic setValue:oneClient.weeklyOverFirstHour forKey:PF_CLIENT_WEEKLYOVERFIRSTHOUR];
                
                if (oneClient.phone !=nil)
                    [dic setObject:oneClient.phone forKey:PF_CLIENT_PHONE];
                
                [tmpArray addObject:dic];
            }
            NSDictionary *tmpReplyInfo = [[NSDictionary alloc]initWithObjectsAndKeys:tmpArray,GET_DASHBOARD_CLIENT_ARRAY, nil];
            replyHandler(tmpReplyInfo);
        }
    }
    //添加新的log
    else if ([message objectForKey:ADD_DASHBOARD_CLIENT_LOG]!=nil)
    {
        NSString *uuid = [message objectForKey:ADD_DASHBOARD_CLIENT_LOG];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status==0 && uuid==%@",uuid];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([fetchedObjects count]>0) {
            Clients *oneClient = [fetchedObjects lastObject];
            if (oneClient.beginTime !=nil) {
                
                //还处于暂停状态
                NSDate *nowDate = [NSDate date];
                NSTimeInterval interval = 0;
                if (oneClient.lunchStart != nil && [oneClient.lunchStart compare:nowDate]== NSOrderedAscending)
                {
                    
                    if (oneClient.lunchStart != nil)
                    {
                        interval = [nowDate timeIntervalSinceDate:oneClient.lunchStart];
                    }
                    if (interval > 0)
                    {
                        oneClient.lunchTime = [NSNumber numberWithInt:(interval + [oneClient.lunchTime intValue])];
                    }
                }
                //重置
                oneClient.lunchStart = nil;
                
                oneClient.endTime = [NSDate date];
                oneClient.accessDate = [NSDate date];
                
                //添加log
                Logs *addLog = nil;
                if ( oneClient != nil && oneClient.clientName != nil && [oneClient.endTime compare:oneClient.beginTime] == NSOrderedDescending)
                {
                    NSTimeInterval timeInterval = [oneClient.endTime timeIntervalSinceDate:oneClient.beginTime];
                    int tmpTotalSeconds = (int)timeInterval;
                    int tmpTotalSecs = tmpTotalSeconds - [oneClient.lunchTime intValue];
                    int totalSecs = tmpTotalSecs >0 ?tmpTotalSecs:0;
                    
                    //总的工作时间需要比休息时间长
                    if (totalSecs <= 0)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Duration time cannot be 0!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                        
                        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                        appDelegate.close_PopView = alertView;
                        
                        return;
                    }
                    
                    if (totalSecs >= 1)
                    {
                        addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:self.managedObjectContext];
                        
                        
                        addLog.finalmoney = [self conevrtTime4:[oneClient.lunchTime intValue]];
                        //重置client
                        oneClient.lunchTime = nil;
                        addLog.client = oneClient;
                        addLog.starttime = oneClient.beginTime;
                        addLog.endtime = oneClient.endTime;
                        addLog.ratePerHour = [self getRateByClient:oneClient date:oneClient.beginTime];
                        
                        NSArray *backArray = [self getRoundWorkAndMoney_ByClient:oneClient rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSecs];
                        addLog.totalmoney = [backArray objectAtIndex:0];
                        addLog.worked = [backArray objectAtIndex:1];
                        
                        addLog.notes = @"";
                        addLog.isInvoice = [NSNumber numberWithBool:NO];
                        addLog.isPaid = [NSNumber numberWithInt:0];
                        
                        addLog.sync_status = [NSNumber numberWithInteger:0];
                        addLog.accessDate = [NSDate date];
                        addLog.uuid = [self getUuid];
                        addLog.client_Uuid = oneClient.uuid;
                        //                        self.changelog = addLog;
                    }
                    else
                    {
                        ;
                    }
                }
                oneClient.beginTime = nil;
                oneClient.endTime = nil;
                oneClient.lunchStart = nil;
                oneClient.lunchTime = 0;
                [self.managedObjectContext save:nil];
                
                [self.parseSync updateClientFromLocal:oneClient];
                [self.parseSync updateLogFromLocal:addLog];
                
                NSDictionary *tmpReplyInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],ADD_DASHBOARD_CLIENT_LOG, nil];
                replyHandler(tmpReplyInfo);
                //刷新ios端数据
                [self dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
            }
        }
        
    }
    //所有的client数组
    else if ([[message objectForKey:GET_CLIENTS_ARRAY] isEqualToString:GET_CLIENTS_ARRAY]) {
        Log(@"client 页面搜索数据");
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status==0"];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error==nil) {
            NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
            if ([fetchedObjects count]>0) {
                for (int i=0; i<[fetchedObjects count]; i++) {
                    Clients *oneClient = [fetchedObjects objectAtIndex:i];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                oneClient.uuid,PF_CLIENT_UUID
                                                ,nil];
                    
                    if (oneClient.payPeriodNum1 !=nil)
                        [dic setObject:oneClient.payPeriodNum1 forKey:PF_CLIENT_PAYPERIODNUM1];
                    
                    if (oneClient.beginTime !=nil)
                        [dic setObject:oneClient.beginTime forKey:PF_CLIENT_BEGINTIME];
                    
                    if (oneClient.r_tueRate !=nil)
                        [dic setObject:oneClient.r_tueRate forKey:PF_CLIENT_R_TUERATE];
                    
                    if (oneClient.payPeriodStly !=nil)
                        [dic setObject:oneClient.payPeriodStly forKey:PF_CLIENT_PAYPERIODSTLY];
                    
                    if (oneClient.r_wedRate !=nil)
                        [dic setObject:oneClient.r_wedRate forKey:PF_CLIENT_R_WEDRATE];
                    
                    if (oneClient.r_satRate !=nil)
                        [dic setObject:oneClient.r_satRate forKey:PF_CLIENT_R_SATRATE];
                    
                    if (oneClient.r_sunRate !=nil)
                        [dic setObject:oneClient.r_sunRate forKey:PF_CLIENT_R_SUNRATE];
                    
                    if (oneClient.dailyOverFirstHour !=nil)
                        [dic setObject:oneClient.dailyOverFirstHour forKey:PF_CLIENT_DAILYOVERFIRSTHOUR];
                    
                    if (oneClient.address !=nil && [oneClient.address length]>0)
                        [dic setObject:oneClient.address forKey:PF_CLIENT_ADDRESS];
                    
                    if (oneClient.weeklyOverSecondTax !=nil)
                        [dic setObject:oneClient.weeklyOverSecondTax forKey:PF_CLIENT_WEEKLYOVERSECONDTAX];
                    
                    if (oneClient.clientName !=nil)
                        [dic setObject:oneClient.clientName forKey:PF_CLIENT_CLIENTNAME];
                    
                    if (oneClient.timeRoundTo !=nil)
                        [dic setObject:oneClient.timeRoundTo forKey:PF_CLIENT_TIMEROUNDTO];
                    
                    if (oneClient.dailyOverFirstTax !=nil)
                        [dic setObject:oneClient.dailyOverFirstTax forKey:PF_CLIENT_DAILYOVERFIRSTTAX];
                    
                    if (oneClient.accessDate !=nil)
                        [dic setObject:oneClient.accessDate forKey:PF_CLIENT_ACCESSDATE];
                    
                    if (oneClient.lunchTime !=nil)
                        [dic setObject:oneClient.lunchTime forKey:PF_CLIENT_LUNCHTIME];
                    
                    if (oneClient.website !=nil)
                        [dic setObject:oneClient.website forKey:PF_CLIENT_WEBSITE];
                    
                    if (oneClient.payPeriodDate !=nil)
                        [dic setObject:oneClient.payPeriodDate forKey:PF_CLIENT_PAYPERIODDATE];
                    
                    if (oneClient.r_thuRate !=nil)
                        [dic setObject:oneClient.r_thuRate forKey:PF_CLIENT_R_THURATE];
                    
                    if (oneClient.endTime !=nil)
                        [dic setObject:oneClient.endTime forKey:PF_CLIENT_ENDTIME];
                    
                    if (oneClient.payPeriodNum2 !=nil)
                        [dic setObject:oneClient.payPeriodNum2 forKey:PF_CLIENT_PAYPERIODNUM2];
                    
                    if (oneClient.email !=nil)
                        [dic setObject:oneClient.email forKey:PF_CLIENT_EMAIL];
                    
                    if (oneClient.dailyOverSecondHour !=nil)
                        [dic setObject:oneClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];
                    
                    if (oneClient.lunchStart !=nil)
                        [dic setObject:oneClient.lunchStart forKey:PF_CLIENT_LUNCHSTART];
                    
                    if (oneClient.r_friRate !=nil)
                        [dic setObject:oneClient.r_friRate forKey:PF_CLIENT_R_FRIRATE];
                    
                    if (oneClient.sync_status !=nil)
                        [dic setObject:oneClient.sync_status forKey:PF_SYNCSTATUS];
                    
                    if (oneClient.weeklyOverFirstTax !=nil)
                        [dic setObject:oneClient.weeklyOverFirstTax forKey:PF_CLIENT_WEEKLYOVERFIRSTTAX];
                    
                    if (oneClient.r_isDaily !=nil)
                        [dic setObject:oneClient.r_isDaily forKey:PF_CLIENT_R_ISDAILY];
                    
                    if (oneClient.dailyOverSecondTax !=nil)
                        [dic setObject:oneClient.dailyOverSecondTax forKey:PF_CLIENT_DAILYOVERSECONDTAX];
                    
                    if (oneClient.dailyOverSecondHour !=nil)
                        [dic setObject:oneClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];
                    
                    if (oneClient.r_monRate !=nil)
                        [dic setObject:oneClient.r_monRate forKey:PF_CLIENT_R_MONRATE];
                    
                    if (oneClient.ratePerHour !=nil)
                        [dic setObject:oneClient.ratePerHour forKey:PF_CLIENT_RATEPERHOUR];
                    
                    if (oneClient.fax !=nil)
                        [dic setObject:oneClient.fax forKey:PF_CLIENT_FAX];
                    
                    if (oneClient.r_weekRate !=nil)
                        [dic setObject:oneClient.r_weekRate forKey:PF_CLIENT_R_WEEKRATE];
                    
                    if (oneClient.weeklyOverFirstHour !=nil)
                        [dic setValue:oneClient.weeklyOverFirstHour forKey:PF_CLIENT_WEEKLYOVERFIRSTHOUR];
                    
                    if (oneClient.phone !=nil)
                        [dic setObject:oneClient.phone forKey:PF_CLIENT_PHONE];
                    
                    [tmpArray addObject:dic];
                }
                
            }
            NSDictionary *tmpReplyInfo = [[NSDictionary alloc]initWithObjectsAndKeys:tmpArray,GET_CLIENTS_ARRAY, nil];
            replyHandler(tmpReplyInfo);
        }
        
    }
    //获取某个client下所有的log 数组,判断client的begintime还是不是nil
    else if ([message objectForKey:GET_CURRENTCLIENT_LOGS] != nil)
    {
        NSString *tmpUUID = [message objectForKey:GET_CURRENTCLIENT_LOGS];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"uuid==%@",tmpUUID];
        [fetchRequest setPredicate:pre];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error==nil) {
            NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
            NSMutableArray  *logsArray = [[NSMutableArray alloc]init];
            if ([fetchedObjects count]>0) {
                Clients *selClient = [fetchedObjects lastObject];
                
                [tmpArray addObjectsFromArray:[self removeAlready_DeleteLog:[selClient.logs allObjects]]];
                
                for (int i=0; i<[tmpArray count]; i++) {
                    Logs *oneLog = [tmpArray objectAtIndex:i];
                    //计算log总共工资
                    NSArray *tmpOvertimeArray = [self overTimeMoney_logs:[NSArray arrayWithObjects:oneLog, nil]];
                    double overtimePay = [[tmpOvertimeArray objectAtIndex:0]doubleValue];
                    double totalMoneyWithOvertime = [oneLog.totalmoney doubleValue] + overtimePay;
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:oneLog.uuid,PF_LOGS_UUID
                                                , nil];
                    if (oneLog.sync_status !=nil) {
                        [dic setObject:oneLog.sync_status forKey:PF_SYNCSTATUS];
                    }
                    
                    if (oneLog.totalmoney !=nil) {
                        [dic setObject:oneLog.totalmoney forKey:PF_LOGS_TOTALMONSY];
                    }
                    
                    if (oneLog.isInvoice !=nil) {
                        [dic setObject:oneLog.isInvoice forKey:PF_LOGS_ISINVOICE];
                    }
                    
                    if (oneLog.worked !=nil) {
                        [dic setObject:oneLog.worked forKey:PF_LOGS_WORKED];
                    }
                    
                    if (oneLog.starttime != nil) {
                        [dic setObject:oneLog.starttime forKey:PF_LOGS_STARTTIME];
                    }
                    
                    if (oneLog.overtimeFree!=nil) {
                        [dic setObject:oneLog.overtimeFree forKey:PF_LOGS_OVERTIMEFREE];
                    }
                    
                    if (oneLog.endtime !=nil) {
                        [dic setObject:oneLog.endtime forKey:PF_LOGS_ENDTIME];
                    }
                    
                    if (oneLog.isPaid !=nil) {
                        [dic setObject:oneLog.isPaid forKey:PF_LOGS_ISPAID];
                    }
                    
                    if (oneLog.ratePerHour !=nil) {
                        [dic setObject:oneLog.ratePerHour forKey:PF_LOGS_RATEPERHOUR];
                    }
                    
                    if (oneLog.accessDate!=nil) {
                        [dic setObject:oneLog.accessDate forKey:PF_LOGS_ACCESSDATE];
                    }
                    
                    if (oneLog.notes!=nil) {
                        [dic setObject:oneLog.notes forKey:PF_LOGS_NOTES];
                    }
                    
                    if (oneLog.finalmoney!=nil) {
                        [dic setObject:oneLog.finalmoney forKey:PF_LOGS_FINALMONEY];
                    }
                    
                    if (oneLog.client_Uuid !=nil) {
                        [dic setObject:oneLog.client_Uuid forKey:PF_LOGS_CLIENTUUID];
                    }
                    
                    [dic setObject:[NSNumber numberWithDouble:totalMoneyWithOvertime] forKey:PF_LOGS_TOTALMONEY_WITHOVERTIMEPAY];
                    
                    [logsArray addObject:dic];
                    
                }
                NSMutableDictionary *tmpReplyInfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:logsArray,GET_CURRENTCLIENT_LOGS, nil];
                if (selClient.beginTime==nil) {
                }
                else
                {
                    [tmpReplyInfo setObject:selClient.beginTime forKey:CURRENTCLIENT_BTGINTIME_HASVALUE];
                    
                }
                replyHandler(tmpReplyInfo);

            }
           
        }
        
        
    }
    //响应watchOS上 Client->Detail:clockin事件
    else if ([message objectForKey:CURRENTCLIENT_BTGINTIME_HASVALUE]!=nil)
    {
        NSString *tmpUUID = [message objectForKey:CURRENTCLIENT_BTGINTIME_HASVALUE];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"uuid==%@",tmpUUID];
        [fetchRequest setPredicate:pre];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([fetchedObjects count]>0) {
            Clients *selClient = [fetchedObjects lastObject];
            if(selClient.beginTime == nil)
            {
                selClient.beginTime = [NSDate date];
                selClient.accessDate = [NSDate date];
                selClient.sync_status = [NSNumber numberWithInteger:0];
                NSError *error = nil;
                [self.managedObjectContext save:&error];
                [self.parseSync updateClientFromLocal:selClient];
                //返回结果
                NSDictionary *tmpReplyInfo = [[NSDictionary alloc]initWithObjectsAndKeys:selClient.beginTime,CURRENTCLIENT_BTGINTIME_HASVALUE, nil];
                replyHandler(tmpReplyInfo);
                
                //刷新ios端数据
                [self dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                
            }
            
        }
    }
    //Clients 列表，第二页->log list:clock out
    else if ([message objectForKey:ADD_CLIENTDETAIL_LOG]!=nil)
    {
        NSString *uuid = [message objectForKey:ADD_CLIENTDETAIL_LOG];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Clients" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status==0 && uuid==%@",uuid];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([fetchedObjects count]>0) {
            Clients *oneClient = [fetchedObjects lastObject];
            if (oneClient.beginTime !=nil) {
                
                //还处于暂停状态
                NSDate *nowDate = [NSDate date];
                NSTimeInterval interval = 0;
                if (oneClient.lunchStart != nil && [oneClient.lunchStart compare:nowDate]== NSOrderedAscending)
                {
                    
                    if (oneClient.lunchStart != nil)
                    {
                        interval = [nowDate timeIntervalSinceDate:oneClient.lunchStart];
                    }
                    if (interval > 0)
                    {
                        oneClient.lunchTime = [NSNumber numberWithInt:(interval + [oneClient.lunchTime intValue])];
                    }
                }
                //重置
                oneClient.lunchStart = nil;
                
                oneClient.endTime = [NSDate date];
                oneClient.accessDate = [NSDate date];
                
                //添加log
                Logs *addLog = nil;
                if ( oneClient != nil && oneClient.clientName != nil && [oneClient.endTime compare:oneClient.beginTime] == NSOrderedDescending)
                {
                    NSTimeInterval timeInterval = [oneClient.endTime timeIntervalSinceDate:oneClient.beginTime];
                    int tmpTotalSeconds = (int)timeInterval;
                    int tmpTotalSecs = tmpTotalSeconds - [oneClient.lunchTime intValue];
                    int totalSecs = tmpTotalSecs >0 ?tmpTotalSecs:0;
                    
                    //总的工作时间需要比休息时间长
                    if (totalSecs <= 0)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Duration time cannot be 0!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                        
                        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                        appDelegate.close_PopView = alertView;
                        
                        return;
                    }
                    
                    if (totalSecs >= 1)
                    {
                        addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:self.managedObjectContext];
                        
                        
                        addLog.finalmoney = [self conevrtTime4:[oneClient.lunchTime intValue]];
                        //重置client
                        oneClient.lunchTime = nil;
                        addLog.client = oneClient;
                        addLog.starttime = oneClient.beginTime;
                        addLog.endtime = oneClient.endTime;
                        addLog.ratePerHour = [self getRateByClient:oneClient date:oneClient.beginTime];
                        
                        NSArray *backArray = [self getRoundWorkAndMoney_ByClient:oneClient rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSecs];
                        addLog.totalmoney = [backArray objectAtIndex:0];
                        addLog.worked = [backArray objectAtIndex:1];
                        
                        addLog.notes = @"";
                        addLog.isInvoice = [NSNumber numberWithBool:NO];
                        addLog.isPaid = [NSNumber numberWithInt:0];
                        
                        addLog.sync_status = [NSNumber numberWithInteger:0];
                        addLog.accessDate = [NSDate date];
                        addLog.uuid = [self getUuid];
                        addLog.client_Uuid = oneClient.uuid;
                        //                        self.changelog = addLog;
                    }
                    else
                    {
                        ;
                    }
                }
                oneClient.beginTime = nil;
                oneClient.endTime = nil;
                oneClient.lunchStart = nil;
                oneClient.lunchTime = 0;
                [self.managedObjectContext save:nil];
                
                [self.parseSync updateClientFromLocal:oneClient];
                [self.parseSync updateLogFromLocal:addLog];
                
                NSDictionary *tmpReplyInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],ADD_CLIENTDETAIL_LOG, nil];
                replyHandler(tmpReplyInfo);
                
                //刷新ios端数据
                [self dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                
            }
        }
        
    }
    else if ([message objectForKey:GET_REPORT] != nil)
    {
        //获取这一周的起始时间
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:[self getFirstDayForWeek]];
        NSDate *weekFirstDate = nil;
        NSDate *today = [NSDate date];
        [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:today];
        NSDate *weekStart = nil;
        NSDate  *weekEnd = nil;
        weekStart = weekFirstDate;
        weekEnd = [self getAfterMathDate:weekStart delayDays:6                                                                                                                                                                                            ];
        
        //月起始时间
        NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
        NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
        beginComponents.year = nowComponents.year;
        beginComponents.month = nowComponents.month;
        beginComponents.day = 1;
        NSDate *beginDate = [calendar dateFromComponents:beginComponents];
        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        endComponents.year = nowComponents.year;
        endComponents.month = nowComponents.month;
        if (nowComponents.month == 1 || nowComponents.month == 3 || nowComponents.month == 5 || nowComponents.month == 7
            || nowComponents.month == 8 || nowComponents.month == 10  || nowComponents.month == 12)
        {
            endComponents.day = 31;
        }
        if (nowComponents.month == 4 || nowComponents.month == 6 || nowComponents.month == 9
            || nowComponents.month == 11)
        {
            endComponents.day = 30;
        }
        if (nowComponents.month == 2)
        {
            if ([self isLeapYear:nowComponents.year])
            {
                endComponents.day = 29;
            }
            else
            {
                endComponents.day = 28;
            }
        }
        NSDate *endDate = [calendar dateFromComponents:endComponents];
        NSDate *monthStart = beginDate;
        NSDate *monthEnd = endDate;
        double monthMoney = 0;
        double monthTime = 0;
        double weekMoney = 0;
        double weekTime = 0;
        
        //获取周logs
        NSMutableArray *weekLogsArray = [[NSMutableArray alloc]init];
        [weekLogsArray addObjectsFromArray:[self getOverTime_Log:nil startTime:weekStart endTime:weekEnd isAscendingOrder:NO]];
        
        //计算log工作时间，所有的基本工资
        double weekBasicMoney = 0.0;
        for (int k=0; k<[weekLogsArray count]; k++)
        {
            Logs *mylog = [weekLogsArray objectAtIndex:k];
            NSString *timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
            NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
            int hours = [[timeArray objectAtIndex:0] intValue];
            int minutes = [[timeArray objectAtIndex:1] intValue];
            weekTime = weekTime +hours*3600+minutes*60;
            weekBasicMoney = weekBasicMoney + [mylog.totalmoney doubleValue];
        }
        
        NSArray *backArray = [self overTimeMoney_logs:weekLogsArray];
        double weekAddMoney = [[backArray objectAtIndex:0]doubleValue];
        weekMoney = weekBasicMoney + weekAddMoney;
        
        //获取月logs
        NSMutableArray *monthLogsArray = [[NSMutableArray alloc]init];
        [monthLogsArray addObjectsFromArray:[self getOverTime_Log:nil startTime:monthStart endTime:monthEnd isAscendingOrder:NO]];
        
        //计算log工作时间，所有的基本工资
        double monthBasicMoney = 0.0;
        for (int k=0; k<[monthLogsArray count]; k++)
        {
            Logs *mylog = [monthLogsArray objectAtIndex:k];
            NSString *timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
            NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
            int hours = [[timeArray objectAtIndex:0] intValue];
            int minutes = [[timeArray objectAtIndex:1] intValue];
            //monthtime
            monthTime = monthTime +hours*3600+minutes*60;
            monthBasicMoney = monthBasicMoney + [mylog.totalmoney doubleValue];
        }
        
        NSArray *monthBackArray = [self overTimeMoney_logs:monthLogsArray];
        double monthAddMoney = [[monthBackArray objectAtIndex:0]doubleValue];
        //month money
        monthMoney = monthBasicMoney + monthAddMoney;
        
        
        NSString *weekTimeString = [NSString stringWithFormat:@"%dh",(int)weekTime/3600];
        NSString *weekMoneyString = [self formatterString:weekMoney];
        NSString *monthTimeString = [NSString stringWithFormat:@"%dh",(int)monthTime/3600];
        NSString *monthMoneyString = [self formatterString:monthMoney];
        
        NSDictionary *tmpReplyInfo = [[NSDictionary alloc]initWithObjectsAndKeys:weekTimeString,WEEK_TIME,weekMoneyString,WEEK_MONEY,monthTimeString,MONTH_TIME,monthMoneyString,MONTH_MONEY, nil];
        replyHandler(tmpReplyInfo);
        
        
    }
}
 */

-(NSString *)customMoneyFormat:(double)tmpMoney
{
    //设置金额的显示text
    NSString *expenseAmountString=@"0.00";
    if (tmpMoney<1000000.0)//100k-1
    {
        expenseAmountString = [self formatterString:tmpMoney];
    }
//    else if (tmpMoney<100000000)//100k --- 100m-1
//        expenseAmountString =[NSString stringWithFormat:@"%.0f k", tmpMoney/1000];
    else if(tmpMoney < 1000000000.0)//100m -- 100b-1
        expenseAmountString =[NSString stringWithFormat:@"%.2f m", tmpMoney/1000000.0];
    else
        expenseAmountString =[NSString stringWithFormat:@"%.2f b", tmpMoney/1000000000.0];
    return expenseAmountString;
}

- (BOOL)isLeapYear:(NSInteger)year
{
    if (year%4 == 0)
    {
        if (year%100 == 0)
        {
            if (year%400 == 0)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    else 
    {
        return NO;
    }
    
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

- (NSString *)formatterString:(double)doubleContext
{
    NSString *string = @"";
    if(doubleContext >= 0)
        string = [NSString stringWithFormat:@"%.2f",doubleContext];
    else
        string = [NSString stringWithFormat:@"%.2f",-doubleContext];
    
    NSArray *tmp = [string componentsSeparatedByString:@"."];
    NSNumberFormatter *numberStyle = [[NSNumberFormatter alloc] init];
    [numberStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *tmpStr = [numberStyle stringFromNumber:[NSNumber numberWithDouble:[[tmp objectAtIndex:0] doubleValue]]];
    if([tmp count]<2)
    {
        string = tmpStr;
    }
    else
    {
        
        string = [[tmpStr stringByAppendingString:@"."] stringByAppendingString:[tmp objectAtIndex:1]];
    }
    
    
    NSString *typeOfDollar = self.currencyStr;
    NSArray *dollorArray = [typeOfDollar componentsSeparatedByString:@"-"];
    NSString *dollorStr = [[dollorArray objectAtIndex:0] substringToIndex:[[dollorArray objectAtIndex:0] length]-1];
    
    if (doubleContext<0) {
        dollorStr = [NSString stringWithFormat:@"-%@",dollorStr];
    }
    
    string = [dollorStr stringByAppendingString:string];
    
    if(doubleContext < 0)
        string = [NSString stringWithFormat:@"%@",string];
    
    
    
    return string;
    
}
@end

