//
//  TimerLeftViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 5/23/13.
//
//

#import <UIKit/UIKit.h>

#import "Clients.h"

#import "TimerStartViewController_ipad.h"
#import "NewClientViewController_ipad.h"


/**
    主界面右面的Clients列表视图
 */
@class TimerMainViewController;

@interface TimerLeftViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,getClientDelegate>
{
    long    allSeconds;
    double  allMoney;
    long    allOverSeconds;
    double  allOverMoney;
}

@property(nonatomic,strong) UIButton                *editButton;

@property(nonatomic,strong) IBOutlet UIView         *containView;
@property(nonatomic,strong) IBOutlet UITableView    *tableView;
@property(nonatomic,strong) IBOutlet UIImageView    *tipImagV;

@property(nonatomic,strong) IBOutlet UILabel        *totalTimeLbel;
@property(nonatomic,strong) IBOutlet HMJLabel       *totalMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel        *m_overTimeLbel;
@property(nonatomic,strong) IBOutlet HMJLabel       *overMoneyLabel;
@property(nonatomic,strong) IBOutlet UIButton       *lite_Btn;

@property(nonatomic,strong) NSMutableArray          *onClockTimerLogsArray;
@property(nonatomic,strong) NSMutableArray          *pauseTimerLogsArray;
@property(nonatomic,strong) NSTimer                 *myTimer;

@property(nonatomic,strong) Clients                 *selectClient;
@property(nonatomic,strong) Clients                 *delectClient;
@property(nonatomic,strong) NSIndexPath             *animation_CellPath;


@property(nonatomic,strong) TimerMainViewController         *mainView;
@property(nonatomic,strong) TimerStartViewController_ipad   *flashTimerStartView;

@property(nonatomic,strong)TimerStartViewController_ipad *startTimeController;

-(void)doEdit;
-(void)doAdd;

-(void)onMyTimer;
-(void)initTimerAarry;


-(IBAction)doLiteBtn;
-(void)pop_system_UnlockLite; //统一的 UnLock action 名

@end
