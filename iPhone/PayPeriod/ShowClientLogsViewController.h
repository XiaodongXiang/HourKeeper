//
//  ShowClientLogsViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clients.h"
#import "HMJLabel.h"

/*
    显示Client某段时间的Log列表
 */

@interface ShowClientLogsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
}
//input
@property(nonatomic,strong) NSMutableArray          *logList;
@property(nonatomic,strong) NSDate                  *sel_startDate;
@property(nonatomic,strong) NSDate                  *sel_endDate;
@property(nonatomic,strong) Clients                 *sel_client;

@property (nonatomic,strong) IBOutlet UITableView   *myTableView;

@property (nonatomic,strong) IBOutlet UIView        *navTitelView;
@property (nonatomic,strong) IBOutlet UILabel       *clientNameLbel;
@property (nonatomic,strong) IBOutlet UILabel       *dueDateLbel;

@property (nonatomic,strong) IBOutlet UILabel       *totalLogsWorkedTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel      *totalLogsWorkedMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel       *m_overTimeLbel;
@property (nonatomic,strong) IBOutlet HMJLabel      *m_overMoneyLbel;
@property (nonatomic,strong) IBOutlet UILabel       *overtimelabel1;
@property (nonatomic,strong) IBOutlet UILabel       *totallabel1;

@property(nonatomic,strong) NSIndexPath             *delete_indexPath;

@property (nonatomic,weak)IBOutlet  UIView          *rightBarView;
@property (nonatomic,weak) IBOutlet UIButton        *addButton;
@property(nonatomic,weak)IBOutlet   UIButton        *calculatorBtn;

-(void)deletLog_index:(NSIndexPath *)indexPath;

-(void)reflashView;
-(void)reflashBootView;
-(void)back;
-(void)doAction;

-(IBAction)doOverTime;


@end
