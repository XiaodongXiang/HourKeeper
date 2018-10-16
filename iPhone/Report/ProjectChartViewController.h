//
//  ProjectChartViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clients.h"
#import "HMJLabel.h"

@interface ProjectChartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
}
//input
@property (nonatomic,strong) NSMutableArray *allLogsList;
@property (nonatomic,strong) NSDate *sel_startDate;
@property (nonatomic,strong) NSDate *sel_endDate;
@property (nonatomic,strong) NSString *clientName;
@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic,strong) Clients *sel_client;

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) IBOutlet UIView *navTitelView;
@property (nonatomic,strong) IBOutlet UILabel *clientNameLbel;
@property (nonatomic,strong) IBOutlet UILabel *dueDateLbel;

@property (nonatomic,strong) IBOutlet UILabel *totalLogsWorkedTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel *totalLogsWorkedMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel *m_overTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel *m_overMoneyLbel;

@property (nonatomic,strong) NSIndexPath * delete_indexPath;



-(void)deletLog_index:(NSIndexPath *)indexPath;
-(void)reflashView;
-(void)reflashBootView;
-(void)back;



@end
