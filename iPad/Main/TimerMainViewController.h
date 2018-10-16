//
//  TimerMainViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerSheetViewController_ipad.h"
#import "InvoiceViewController_newpad.h"
#import "ChartViewController_newpad.h"
#import "TimerLeftViewController_ipad.h"
#import "SettingViewController_ipad.h"


@interface TimerMainViewController : UIViewController
{
}

//装整个页面的View
@property(nonatomic,strong) IBOutlet UIView     *appView;
@property(nonatomic,strong) IBOutlet UIButton   *timersheetBtn;
@property(nonatomic,strong) IBOutlet UIButton   *invoiceBtn;
@property(nonatomic,strong) IBOutlet UIButton   *reportsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginInBtn;

//左边装3种模块的容器
@property(nonatomic,strong) IBOutlet UIView     *kindsofView;
@property(nonatomic,strong) IBOutlet UIView     *leftView;
@property(nonatomic,strong) TimerSheetViewController_ipad   *timersheetView;
@property(nonatomic,strong) InvoiceViewController_newpad    *invoiceView;
@property(nonatomic,strong) ChartViewController_newpad      *chartView;
@property(nonatomic,strong) SettingViewController_ipad      *settingView;
@property(nonatomic,strong) TimerLeftViewController_ipad    *leftViewController;
@property(nonatomic,strong) UINavigationController          *leftNaviController;

//左边的VC选中的是哪个模块
@property(nonatomic,assign) NSInteger                       selectPageNo;


//刷新左边的模块
-(void)reflashLeftPageView;
-(void)reflashTimerMainView;

-(IBAction)timersheetBtnPressed:(UIButton *)sender;
-(IBAction)invoiceBtnPressed:(UIButton *)sender;
-(IBAction)reportsBtnPressed:(UIButton *)sender;
-(IBAction)settingBtnPressed:(UIButton *)sender;

@end
