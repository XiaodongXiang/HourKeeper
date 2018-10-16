//
//  CalendarViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"
#import "KalDataSource.h"
#import "Clients.h"



@class KalLogic, KalDate;
@class HMJLabel;


@interface CalendarViewController : UIViewController <KalViewDelegate, KalDataSourceCallbacks,UITableViewDelegate,UITableViewDataSource>
{
    KalLogic *logic;
    UITableView *m_tableView;
    NSDate *initialDate;
    
    NSIndexPath *clientSelectedIndexPath;
}
@property (nonatomic,strong) id<UITableViewDelegate>    delegate;
@property (nonatomic,strong) id<KalDataSource>          dataSource;
@property (nonatomic,strong, readonly) NSDate           *selectedDate;

@property (nonatomic,strong) IBOutlet UILabel           *titleLbel;
@property (nonatomic,strong) NSDate                     *sel_weekDay;
@property (nonatomic,strong) UIView                     *m_calView;

@property (nonatomic,strong) IBOutlet UILabel           *m_totalTime;
@property (nonatomic,strong) IBOutlet HMJLabel          *m_totalMoney;
@property (nonatomic,strong) IBOutlet UILabel           *m_overTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel          *m_overMoneyLbel;

@property (nonatomic,weak)IBOutlet  UIView              *rightBarView;
@property (nonatomic,weak) IBOutlet UIButton            *clientBtn;
@property(nonatomic,weak)IBOutlet   UIButton            *calculatorBtn;
@property (nonatomic,strong) IBOutlet UIView            *clientView;
@property (nonatomic,strong) IBOutlet UITableView       *clientTable;
@property (nonatomic,strong) IBOutlet UIImageView       *clientViewArrowImage;
@property (nonatomic,strong) NSMutableArray             *clientArray;
@property (nonatomic,strong) Clients                    *sel_client;             //nil:all;

- (void)initWithSelectedDate:(NSDate *)selectedDate;
- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;

-(void)scanCalendar;
-(IBAction)leftBtn;
-(IBAction)rightBtn;
-(void)initCalendar;

-(void)initClientName;
-(void)initTotal:(NSArray *)logsArray;
-(IBAction)doselectClient;



@end
