//
//  ChartViewController_newpad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"
#import "HMJLabel.h"


/**
    iPad主界面Reports页面
 */
@interface ChartViewController_newpad : UIViewController
{
}
@property (nonatomic,strong) NSDate *sel_weekDay;
@property (nonatomic,strong) NSDate *firstDate;
@property (nonatomic,strong) NSDate *lastDate;
@property (nonatomic,assign) NSInteger dateStly;            //0 每周； 1 每月； 2 每季度； 3 每年
@property (nonatomic,assign)  NSInteger tableShowStly;      // 0 hours;  1 amonunt

@property(nonatomic,strong) IBOutlet UILabel *dateShowLbel;
@property(nonatomic,strong)IBOutlet UIButton    *dateLeftBtn;
@property(nonatomic,strong)IBOutlet UIButton    *dateRightBtn;


//日期选择
@property(nonatomic,strong) IBOutlet UIView *dateView;
@property(nonatomic,strong) IBOutlet UIButton *dateStyBtn;
@property(nonatomic,strong) IBOutlet UIButton *weekBtn;
@property(nonatomic,strong) IBOutlet UIButton *monthBtn;
@property(nonatomic,strong) IBOutlet UIButton *queterBtn;
@property(nonatomic,strong) IBOutlet UIButton *yearBtn;
@property(nonatomic,weak)   IBOutlet    UIImageView *arrowImageView;

@property(nonatomic,strong) IBOutlet PieView    *pieView;
@property(nonatomic,strong) NSString            *showMoneyStr;
@property(nonatomic,strong) NSString            *showTimeStr;

@property(nonatomic,strong) IBOutlet UIView         *tableViewTopLine;
@property(nonatomic,strong) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UIView         *bgView;

@property (nonatomic,strong) NSMutableArray *clientTotalList;
@property (nonatomic,strong) NSMutableArray *clientMPercentageList;
@property (nonatomic,strong) NSMutableArray *clientTPercentageList;
@property (nonatomic,strong) NSMutableArray *allLogsList;

@property(nonatomic,strong)  UIPopoverController *popoverController;

@property(nonatomic,strong) IBOutlet UITableViewCell *totalCell;
@property(nonatomic,strong) IBOutlet UILabel *totalLbel;
@property(nonatomic,strong) IBOutlet HMJLabel   *totalAmountView;
@property(nonatomic,assign)double   money_sub;
@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrol;
@property(nonatomic,strong) IBOutlet UIImageView *segmentImagV;

@property(nonatomic,strong)IBOutlet UIView  *headLine;
-(void)initChartView;
-(void)reflashTable;
-(void)reflashPercentChart;
-(void)getAllLogsList;
-(void)getclientList;

-(IBAction)leftBtnDone;
-(IBAction)rightBtnDone;
-(IBAction)doShowStly:(UISegmentedControl *)sender;
-(void)showSegmentImage;

-(IBAction)selectDateStly;
-(IBAction)nowWeekBtn;
-(IBAction)nowMonthBtn;
-(IBAction)nowQuarterBtn;
-(IBAction)nowYearBtn;
-(void)showDateBtnImage:(int)Stly;

- (NSString *)getNowWeek;
- (NSString *)getNowMonth;
-(NSString *)getNowQuarter;
-(NSString *)getNowYear;
- (BOOL)isLeapYear:(NSInteger)year;
-(void)getPreviousDate;
-(void)getNextDate;
- (NSString *)changeDate:(int)num;
-(NSDate *)getAfterMathDate:(NSDate *)nowDate delayDays:(int)num;




@end



