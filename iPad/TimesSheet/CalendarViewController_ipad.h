//
//  CalendarViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView_ipad.h"
#import "KalDataSource_ipad.h" 
#import "Clients.h"
#import "HMJLabel.h"



@class KalLogic_ipad, KalDate_ipad;

/*
    Pay Period日历页面
 */
@interface CalendarViewController_ipad : UIViewController <KalViewDelegate_ipad,KalDataSourceCallbacks_ipad,UITableViewDelegate,UITableViewDataSource>
{
    KalLogic_ipad *logic;
    UITableView *m_tableView;
    NSDate *initialDate;
}
@property (nonatomic, strong) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) id<KalDataSource_ipad> dataSource;
@property (nonatomic, strong, readonly) NSDate *selectedDate;

@property (nonatomic,strong) IBOutlet UILabel *titleLbel;
@property (nonatomic,strong) UIView *calView;
@property (nonatomic,strong) IBOutlet UILabel *totalTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel *totalMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel *m_overTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel *overMoneyLabel;

@property (nonatomic,strong) IBOutlet UILabel *date1Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date2Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date3Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date4Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date5Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date6Lbel;
@property (nonatomic,strong) IBOutlet UILabel *date7Lbel;

@property (nonatomic,strong) NSDate *sel_weekDate;


@property(nonatomic,weak)IBOutlet   UIView  *headView;
@property(nonatomic,weak)IBOutlet   UIView  *calendarLine;
@property(nonatomic,weak)IBOutlet   UIView  *selectedClientView;
@property(nonatomic,weak)IBOutlet   UIImageView *arrowImageView;
@property(nonatomic,weak)IBOutlet   UIButton    *selectedClientBtn;
@property (nonatomic,strong) IBOutlet UITableView *clientTable;
@property (nonatomic,strong) NSMutableArray *clientArray;
@property (nonatomic,strong) Clients *sel_client;             //nil:all;

@property (nonatomic,strong) IBOutlet UIView *sunShadowView;
@property (nonatomic,strong) IBOutlet UIView *satShadowView;

@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrol;

@property(nonatomic,weak)IBOutlet   UIButton    *dateLeftBtn;
@property(nonatomic,weak)IBOutlet   UIButton    *dateRightBtn;

@property(nonatomic,weak)IBOutlet   UIView      *bottomView;

- (void)initWithSelectedDate:(NSDate *)selectedDate;
- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;

-(IBAction)doShowStly:(UISegmentedControl *)sender;
-(void)ReflashDateStly;
-(IBAction)leftBtn;
-(IBAction)rightBtn;

-(void)initClientName;
-(IBAction)doselectClient;


@end
