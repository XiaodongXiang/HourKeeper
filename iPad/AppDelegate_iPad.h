//
//  AppDelegate_iPad.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "TimerMainViewController.h"
#import "Ipad_CheckEnter.h"
#import "RateViewController_iphone.h"

#import "LogInViewController_iPad.h"

@interface AppDelegate_iPad : AppDelegate_Shared
{
    
}

@property(nonatomic,strong)TimerMainViewController *mainView;
@property(nonatomic,strong)Ipad_CheckEnter *passViewController;

@property (nonatomic,strong) RateViewController_iphone *rateControl;
@property(nonatomic,assign) BOOL isShowTip;
//???
@property(nonatomic,assign) BOOL isDeleteFlashPop;
@property(nonatomic,strong)PFUser   *appUser;

@property(nonatomic,strong)LogInViewController_iPad *logInViewController;
-(void)showRateOrWhatNew;
-(BOOL)addPassView;

//widget
-(void)m_doWidgetAction;
-(void)enterWidgetDo;

//LogIn
-(void)logInVC;
-(void)setCurrentUser;
-(void)launchAfterSignIn;
@end

