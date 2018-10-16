//
//  AppDelegate_iPhone.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

/**
    日加班工资与周加班工资说明：
    日，周是叠加，日内部是阶梯算的。
    例：日8小时，8小时之外的算加班，周40小时，超出40小时算加班。每天工作9小时，那么总共的工资是：
    100*9*1*5+100*(9-8)*(2-1)*5+100*(45-40)*(3-1)
    公式：每小时工资*总时间+ 每小时工资*每天超出多少小时*每小时额外的工资 + 每小时工资*周超出多少小时*周每小时额外工资
 */
#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "CheckPasscodeViewController_iPhone.h"

#import "RateViewController_iphone.h"
#import "ParseSyncHelper.h"
#import "LogInViewController.h"

#import "HMJMainViewController.h"

//@import WatchConnectivity;

@class MyLogInViewController;
//@interface AppDelegate_iPhone : AppDelegate_Shared<PFLogInViewControllerDelegate,WCSessionDelegate>
@interface AppDelegate_iPhone : AppDelegate_Shared<PFLogInViewControllerDelegate>
{
    LogInViewController *logInViewController;
}

//watch 沟通
//@property(nonatomic)WCSession                               *watchSession;
@property(nonatomic,strong)PFUser                           *appUser;

@property(nonatomic,strong) IBOutlet UITabBarController     *m_tabBarController;
@property(nonatomic,strong)HMJMainViewController            *mainViewController;

@property(nonatomic,strong) CheckPasscodeViewController_iPhone  *passViewController;
@property(nonatomic,strong) RateViewController_iphone           *rateControl;
@property(nonatomic,assign) BOOL                                isShowTip;
@property(nonatomic,assign) CGSize                              m_kTileSize;



-(void)showRateOrWhatNew;
-(BOOL)addPassView;
-(void)iphone_reflash_UI;

//widget
-(void)m_doWidgetAction;
-(void)enterWidgetDo;

//parse
-(void)logInVC;
-(void)setCurrentUser;
-(void)launchAfterSignIn;
@end


