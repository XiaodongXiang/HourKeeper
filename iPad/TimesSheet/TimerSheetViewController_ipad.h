//
//  TimerSheetViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController_ipad.h"
#import "PayPeriodViewController_ipad.h"


/**
    iPad主界面 TimesSheet的日历列表 Week对应的VC
 */
@interface TimerSheetViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}

@property(nonatomic,strong) IBOutlet UITableView *tableView;

@property(nonatomic,strong) IBOutlet UILabel *tittleLbel;

@property(nonatomic,strong) IBOutlet UILabel *sunDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *monDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *tueDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *wedDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *thuDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *friDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *staDateLbel;

@property(nonatomic,strong) IBOutlet UILabel *sunSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *sunSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *monSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *monSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *tueSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *tueSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *wedSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *wedSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *thuSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *thuSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *friSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *friSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *staSubTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *staSubMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalMoneyLbel;

@property(nonatomic,strong) NSMutableArray *allLogsList;
@property(nonatomic,strong) NSMutableArray *sel_weekLogsList;
@property(nonatomic,strong) NSMutableArray *sel_taskSubLogsList;
@property(nonatomic,strong) NSMutableArray *taskArray;

@property(nonatomic,strong) NSDate *sel_weekDay;
@property(nonatomic,strong) NSDate *selectStartDate;
@property(nonatomic,strong) NSDate *selectEndDate;

@property(nonatomic,strong)  UIPopoverController *popoverController;

@property(nonatomic,strong) PayPeriodViewController_ipad *payPeriodView;
@property(nonatomic,strong) CalendarViewController_ipad *calendarView;
@property(nonatomic,strong) id dataSource;

@property(nonatomic,assign) NSInteger dateSty;  //0 为month;  1 为week;  2 为payPeriod;

@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrol;

@property(nonatomic,weak)IBOutlet   UIButton    *dateLeftBtn;
@property(nonatomic,weak)IBOutlet   UIButton    *dateRightBtn;
@property(nonatomic,weak)IBOutlet   UIView      *bottomView;

-(IBAction)doShowStly:(UISegmentedControl *)sender;
-(IBAction)leftDateBtn;
-(IBAction)rightDateBtn;


-(void)ReflashDateStly;


-(NSDate *)getAfterMathDate:(NSDate *)nowDate delayDays:(int)num;
-(void)ReflashRangeDateList;
-(void)getNowWeekStartAndEndTime;
-(void)getNextOrBeforeStartAndEndTime:(NSInteger)direct;
-(void)getSelectLogs;

-(void)clickCellSunBtn:(UIButton *)sender;
-(void)clickCellMonBtn:(UIButton *)sender;
-(void)clickCellTueBtn:(UIButton *)sender;
-(void)clickCellWedBtn:(UIButton *)sender;
-(void)clickCellThuBtn:(UIButton *)sender;
-(void)clickCellFriBtn:(UIButton *)sender;
-(void)clickCellSatBtn:(UIButton *)sender;




@end
