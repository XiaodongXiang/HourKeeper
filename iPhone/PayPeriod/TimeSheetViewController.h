//
//  TimeSheetViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "KalViewController.h"

#import "Logs.h"
#import "Clients.h"

#import "ShowClientLogsViewController.h"
#import "CalendarViewController.h"
#import "HMJLabel.h"


/**
    TimeSheetViewController Pay period的viewController
    tableview数据源：相同最迟支付结束日期每个client一组
 
 */
@interface PayPeriod_Unit : NSObject

@property(nonatomic,strong) NSDate *pay_endDate;
@property(nonatomic,strong) NSMutableArray *pay_clientArray;

@end



//每一个Client单元
@interface Client_Unit : NSObject

//起始，结束时间
@property(nonatomic,strong) NSDate *client_startDate;
@property(nonatomic,strong) NSDate *client_endDate;
@property(nonatomic,strong) Clients *client;
@property(nonatomic,assign) long allseconds;
@property(nonatomic,assign) double allmoney;
//所有的log数组
@property(nonatomic,strong) NSMutableArray *logsArray;

@end



@interface TimeSheetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView           *tableView;
@property (nonatomic,strong) IBOutlet UIImageView           *tipImagV;
@property(nonatomic,strong) IBOutlet UIButton               *lite_Btn;

//底下的计算器以及统计view
@property(nonatomic,strong) IBOutlet UIView                 *bootView;
//总共的工作时间，工作报酬，加班时间，加班报酬
@property (nonatomic,strong) IBOutlet UILabel               *totalLogsWorkedTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel              *totalLogsWorkedMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel               *m_overTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel              *m_overMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel               *overtimelabel1;
@property (nonatomic,strong) IBOutlet UILabel               *totallabel1;

@property(nonatomic,weak)IBOutlet UIView                    *rightBarView;
@property(nonatomic,weak)IBOutlet   UIButton                *calendarBtn;
@property(nonatomic,weak)IBOutlet   UIButton                *calculatorBtn;

@property (nonatomic,strong) id                             dataSource;
@property (nonatomic,strong) NSMutableArray                 *dateLogArray;
//所有工作时间，以及金钱
@property (nonatomic,assign) long                           app_allseconds;
@property (nonatomic,assign) double                         app_allmoney;

//显示当前Client该段时间的Log数组
@property (nonatomic,strong) ShowClientLogsViewController   *showClientLogsVC;
@property (nonatomic,strong) CalendarViewController         *calendarVC;






//计算器点击事件，刷新bootomview统计文本
-(IBAction)doOverTime;
-(void)reflashTableAndBottom;

//navigation bar左右按钮事件
-(void)doAdd;
-(void)scanCalendar;

//统计待支付以及支付完成的列表
-(void)getPayPeriod;

-(IBAction)doLiteBtn;
-(void)pop_system_UnlockLite;

@end
