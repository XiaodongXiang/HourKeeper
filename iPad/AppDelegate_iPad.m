//
//  AppDelegate_iPad.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "Settings.h"
#import "AddLogViewController_ipad.h"
#import "Custom1ViewController.h"
#import "CustomNavigationViewController.h"
#import "Appirater.h"

@implementation AppDelegate_iPad


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.isDeleteFlashPop = NO;
    
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
        
        //第一次打开应用同步一次
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
    
    return YES;
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    [super applicationWillEnterForeground:application];
    
    if (self.isShowTip == NO)
    {
        [self doRateApp];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    
    self.isShowTip = [self addPassView];
}




- (void)applicationWillTerminate:(UIApplication *)application
{
    [super applicationWillTerminate:application];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [super application:application handleOpenURL:url];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
}

#if __IPAD_OS_VERSION_MAX_ALLOWED >= __IPAD_6_0

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}
#endif



#pragma mark Action
-(void)showRateOrWhatNew
{
    if (self.popAlertFlag == 1 || self.popAlertFlag == 2)
    {
        if (self.rateControl == nil)
        {
            self.rateControl = [[RateViewController_iphone alloc] initWithNibName:@"RateViewController_ipad" bundle:nil];
            [self.rateControl willRotateToInterfaceOrientation:self.mainView.interfaceOrientation duration:0.0];
            self.rateControl.view.frame = CGRectMake(0.0, 0.0, self.rateControl.view.frame.size.width, self.rateControl.view.frame.size.height);
        }
        [self.rateControl.view removeFromSuperview];

        if (self.popAlertFlag == 1)
        {
            self.rateControl.stly = 0;
        }
        else
        {
            self.rateControl.stly = 1;
        }
        
        [self.rateControl setRateOrWhatNew];
        [self.window addSubview:self.rateControl.view];
    }
}


#pragma mark set方法
-(Ipad_CheckEnter *)passViewController
{
    if(_passViewController == nil)
    {
        _passViewController = [[Ipad_CheckEnter alloc] initWithNibName:@"Ipad_CheckEnter" bundle:nil];
    }
    return _passViewController;
}



- (BOOL)addPassView
{
    if ([self.appSetting.isPasscodeOn boolValue])
    {
        [_passViewController willRotateToInterfaceOrientation:self.mainView.interfaceOrientation duration:0.0];
        _passViewController.view.frame = CGRectMake(0.0, 0.0, self.passViewController.view.frame.size.width, self.passViewController.view.frame.size.height);
        [self.window addSubview:_passViewController.view];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)m_doWidgetAction
{
    
    //widget版本区分
    {
        if (self.m_widgetController != nil)
        {
            [self.m_widgetController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if (![self.appSetting.isPasscodeOn boolValue] && self.isWidgetFirst == NO)
        {
            [self enterWidgetDo];
        }
        else
        {
            if (_passViewController.view.superview == nil && self.isWidgetFirst == NO)
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

-(void)enterWidgetDo
{
    BOOL isPresent = NO;
    BOOL isAdd = NO;
    NSIndexPath *indexPath;
    
    NSRange range = [self.use_url.relativeString rangeOfString:WIDGET_URL0];
    if (range.length > 0)
    {
        if ([self.use_url.relativeString isEqualToString:WIDGET_URL0])
        {
            [self.mainView.leftNaviController popToRootViewControllerAnimated:YES];
        }
        else
        {
            isPresent = YES;
            NSString *str = [self.use_url.relativeString stringByReplacingOccurrencesOfString:WIDGET_URL0 withString:@""];
            indexPath = [NSIndexPath indexPathForRow:str.intValue inSection:0];
        }
    }
    else
    {
        isPresent = YES;
        isAdd = YES;
    }
    
    if (isPresent == YES)
    {
        [self.mainView.leftNaviController popToRootViewControllerAnimated:NO];
        self.mainView.leftViewController.flashTimerStartView = nil;
        BOOL needNext = YES;
        
        [self.mainView.leftViewController initTimerAarry];
        if (isAdd == YES)
        {
            if (self.mainView.leftViewController.onClockTimerLogsArray.count >0)
            {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            else
            {
                if (self.mainView.leftViewController.pauseTimerLogsArray.count >0)
                {
                    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                }
                else
                {
                    needNext = NO;
                }
            }
        }
        
        if (needNext == YES)
        {
            self.mainView.leftViewController.animation_CellPath = indexPath;
            
            if (indexPath.section == 0)
            {
                self.mainView.leftViewController.selectClient = [self.mainView.leftViewController.onClockTimerLogsArray objectAtIndex:indexPath.row];
            }
            else
            {
                self.mainView.leftViewController.selectClient = [self.mainView.leftViewController.pauseTimerLogsArray objectAtIndex:indexPath.row];
            }
            
            TimerStartViewController_ipad *startTimeController = [[TimerStartViewController_ipad alloc] initWithNibName:@"TimerStartViewController_ipad" bundle:nil];
            
            startTimeController.sel_client = self.mainView.leftViewController.selectClient;
            startTimeController.mainView = self.mainView;
            
            self.mainView.leftViewController.flashTimerStartView = startTimeController;
            [self.mainView.leftViewController.navigationController pushViewController:startTimeController animated:!isAdd];
            
            
            if (isAdd == YES)
            {
                AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
                
                addLogView.myclient = self.mainView.leftViewController.flashTimerStartView.sel_client;
                
                Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
                addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
                addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self.mainView presentViewController:addLogNavi animated:YES completion:nil];
                self.m_widgetController = self.mainView;
                
            }
        }
    }
}


#pragma mark LogIn
-(void)logInVC
{
    
    self.logInViewController = [[LogInViewController_iPad alloc]initWithNibName:@"LogInViewController_iPad" bundle:nil];
    
    // Present the log in view controller
    CustomNavigationViewController *navi = [[CustomNavigationViewController alloc]initWithRootViewController:self.logInViewController];
    self.logInViewController.view.tag = 999;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];

    
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
    self.mainView = [[TimerMainViewController alloc]initWithNibName:@"TimerMainViewController" bundle:nil];
    self.window.rootViewController = self.mainView;
    [self.window makeKeyAndVisible];
    

    
    self.isShowTip = [self addPassView];
    if (self.isShowTip == NO)
    {
        [self doRateApp];
    }

}




@end

