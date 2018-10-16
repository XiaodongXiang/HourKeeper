//
//  ChartViewController_new.h
//  HoursKeeper
//
//  Created by xy_dev on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"

#import "ProjectChartViewController.h"
#import "HMJLabel.h"


/**
    ChartViewController_new:Report
 */
@interface ChartViewController_new : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UIView *naviTitelView;
@property (nonatomic,strong) IBOutlet UILabel *titleLbel;

@property (nonatomic,strong) IBOutlet PieView *pieView;
@property (nonatomic,strong) IBOutlet UIImageView   *pieBgImageView;
@property(nonatomic,assign) double totalAmount;
@property(nonatomic,strong) NSString *showTimeStr;

@property (nonatomic,strong) NSMutableArray *allLogsList;
@property (nonatomic,strong) NSMutableArray *clientTotalList;
@property (nonatomic,strong) NSMutableArray *clientMPercentageList;
@property (nonatomic,strong) NSMutableArray *clientTPercentageList;

@property (nonatomic,strong) NSDate *firstDate;
@property (nonatomic,strong) NSDate *lastDate;
@property (nonatomic,assign) NSInteger dateStly;           //0 每周； 1 每月； 2 每季度； 3 每年
@property (nonatomic,assign) NSInteger tableShowStly;      // 0 hours;  1 amonunt
@property (nonatomic,strong) NSDate *sel_weekDay;

@property (strong, nonatomic) ProjectChartViewController *dropboxChartContor;

@property(nonatomic,strong) IBOutlet UIButton *lite_Btn;

@property(nonatomic,strong) IBOutlet UIButton *weekBtn;
@property(nonatomic,strong) IBOutlet UIButton *monthBtn;
@property(nonatomic,strong) IBOutlet UIButton *quarterBtn;
@property(nonatomic,strong) IBOutlet UIButton *yearBtn;

@property(nonatomic,strong) IBOutlet UITableViewCell *totalCell;
@property(nonatomic,strong) IBOutlet UILabel *totalLbel;
@property(nonatomic,strong) IBOutlet HMJLabel   *totalAmountLabel;
@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrol;
@property(nonatomic,strong) IBOutlet UIImageView *segmentImagV;

@property(nonatomic,weak) IBOutlet UIView   *line;
@property(nonatomic,weak)IBOutlet   UIView  *totallabel1;

-(void)initChartView;
-(void)reflashTable;
-(void)reflashPercentChart;
-(void)getAllLogsList;
-(void)getclientList;

-(IBAction)leftBtnDone;
-(IBAction)rightBtnDone;
-(IBAction)doShowStly:(UISegmentedControl *)sender;
-(void)showSegmentImage;

-(IBAction)dateStlyBtn:(UIButton *)sender;
-(void)setDateStlyImage:(int)flag;

-(NSString *)getNowWeek;
-(NSString *)getNowMonth;
-(NSString *)getNowQuarter;
-(NSString *)getNowYear;
-(BOOL)isLeapYear:(NSInteger)year;
-(void)getPreviousDate;
-(void)getNextDate;
-(NSString *)changeDate:(int)num;
-(NSDate *)getAfterMathDate:(NSDate *)nowDate delayDays:(int)num;

-(IBAction)doLiteBtn;
-(void)pop_system_UnlockLite; //统一的 UnLock action 名


@end
