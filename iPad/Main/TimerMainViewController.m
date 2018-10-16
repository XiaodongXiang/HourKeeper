//
//  TimerMainViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerMainViewController.h"
#import "Custom1ViewController.h"
#import "AppDelegate_iPad.h"
#import "SettingViewController_ipad.h"
#import "LogInViewController_iPad.h"
#import "CustomNavigationViewController.h"


@implementation TimerMainViewController

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appView.frame = CGRectMake(self.appView.frame.origin.x, self.appView.frame.origin.y+20, self.appView.frame.size.width, self.appView.frame.size.height);
    
    //默认最开始显示TimerSheetView
    _timersheetView = [[TimerSheetViewController_ipad alloc] initWithNibName:@"TimerSheetViewController_ipad" bundle:nil];
    [self.timersheetView.view setFrame:CGRectMake(0, 0, self.kindsofView.frame.size.width, self.kindsofView.frame.size.height)];
    [self.kindsofView addSubview:self.timersheetView.calendarView.view];
    self.selectPageNo = 0;
    [self timersheetBtnPressed:nil];
    
    _invoiceView = [[InvoiceViewController_newpad alloc] initWithNibName:@"InvoiceViewController_newpad" bundle:nil];
    [self.invoiceView.view setFrame:CGRectMake(0, 0, self.kindsofView.frame.size.width, self.kindsofView.frame.size.height)];
    
    _chartView = [[ChartViewController_newpad alloc] initWithNibName:@"ChartViewController_newpad" bundle:nil];
    [self.chartView.view setFrame:CGRectMake(0, 0, self.kindsofView.frame.size.width, self.kindsofView.frame.size.height)];
    
    
    
    //right
    _leftViewController = [[TimerLeftViewController_ipad alloc] initWithNibName:@"TimerLeftViewController_ipad" bundle:nil];
    self.leftViewController.mainView = self;
    _leftNaviController = [[UINavigationController alloc] initWithRootViewController:self.leftViewController];
    [self.leftNaviController.view setFrame:CGRectMake(0, 0, 320, self.leftView.frame.size.height)];
    [self.leftView addSubview:self.leftNaviController.view];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self reflashTimerMainView];
    
    
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isWidgetPrsent == YES && ![appDelegate.appSetting.isPasscodeOn boolValue])
    {
        [appDelegate enterWidgetDo];
        appDelegate.isWidgetPrsent = NO;
    }
    appDelegate.isWidgetFirst = NO;
    
    if (appDelegate.appUser == nil) {
        self.loginInBtn.hidden = NO;
        [self.loginInBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        self.loginInBtn.hidden = YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.passViewController != nil)
    {
        [appDelegate.passViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    if(appDelegate.rateControl != nil)
    {
        [appDelegate.rateControl willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark Action
-(void)loginBtnPressed:(id)sender
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    LogInViewController_iPad *logInViewController = [[LogInViewController_iPad alloc]initWithNibName:@"LogInViewController_iPad" bundle:nil];
    
    // Present the log in view controller
    CustomNavigationViewController *navi = [[CustomNavigationViewController alloc]initWithRootViewController:logInViewController];
    logInViewController.view.tag = 999;
    logInViewController.loadStyle = @"Present";
    [appDelegate.mainView presentViewController:navi animated:YES completion:nil];
    
}
-(IBAction)settingBtnPressed:(UIButton *)sender
{
    self.settingView = [[SettingViewController_ipad alloc] initWithNibName:@"SettingViewController_ipad" bundle:nil];
    
    Custom1ViewController *settingNavi = [[Custom1ViewController alloc]initWithRootViewController:self.settingView];
    settingNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    settingNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self presentViewController:settingNavi animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}

-(IBAction)timersheetBtnPressed:(UIButton *)sender
{
    if (self.selectPageNo != 0)
    {
        [self.timersheetBtn setSelected:YES];
        [self.invoiceBtn setSelected:NO];
        [self.reportsBtn setSelected:NO];
        
        for (UIView *view in self.kindsofView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (self.timersheetView.dateSty == 0)
        {
            [self.kindsofView addSubview:self.timersheetView.calendarView.view];
            [self.timersheetView.calendarView reloadData];
        }
        else if (self.timersheetView.dateSty == 1)
        {
            [self.kindsofView addSubview:self.timersheetView.view];
            [self.timersheetView ReflashRangeDateList];
        }
        else if (self.timersheetView.dateSty == 2)
        {
            [self.kindsofView addSubview:self.timersheetView.payPeriodView.view];
            [self.timersheetView.payPeriodView reflashTableAndBottom];
        }
        
        
        self.selectPageNo = 0;
    }
}

-(IBAction)invoiceBtnPressed:(UIButton *)sender
{
    if (self.selectPageNo != 1)
    {
        [self.timersheetBtn setSelected:NO];
        [self.invoiceBtn setSelected:YES];
        [self.reportsBtn setSelected:NO];
        
        for (UIView *view in self.kindsofView.subviews)
        {
            [view removeFromSuperview];
        }
        [self.kindsofView addSubview:self.invoiceView.view];
        [self.invoiceView initViewControllData];
        
        self.selectPageNo = 1;
    }
}

-(IBAction)reportsBtnPressed:(UIButton *)sender
{
    if (self.selectPageNo != 2)
    {
        [self.timersheetBtn setSelected:NO];
        [self.invoiceBtn setSelected:NO];
        [self.reportsBtn setSelected:YES];
        
        for (UIView *view in self.kindsofView.subviews)
        {
            [view removeFromSuperview];
        }
        [self.kindsofView addSubview:self.chartView.view];
        [self.chartView initChartView];
        
        self.selectPageNo = 2;
    }
}
-(void)reflashTimerMainView
{
    [self.leftViewController initTimerAarry];
    
    [self reflashLeftPageView];
}

-(void)reflashLeftPageView
{
    if (self.selectPageNo == 0)
    {
        [self.timersheetView ReflashRangeDateList];
        [self.timersheetView.calendarView reloadData];
        [self.timersheetView.payPeriodView reflashTableAndBottom];
    }
    else if (self.selectPageNo == 1)
    {
        [self.invoiceView initViewControllData];
        [self.invoiceView.pdfShowView initFlashIvoiceData];
    }
    else 
    {
        [self.chartView initChartView];
    }
}




















@end
