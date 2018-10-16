//
//  TimerStartViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 5/23/13.
//
//

#import <UIKit/UIKit.h>

#import "Clients.h"

#import "StartTimeViewController.h"
#import "NewClientViewController_ipad.h"
#import "DashBoardExternalView.h"
#import "HMJLabel.h"


@class TimerMainViewController;



@interface TimerStartViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,getStartTimeDate,getClientDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSDateFormatter *pointInTimeDateFormatter;
    NSDateFormatter *dayDateFormatter;
}
@property(nonatomic,strong) IBOutlet UILabel        *clientNameLbel;
@property(nonatomic,strong) IBOutlet UILabel        *startTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel        *totalTimeLbel;
@property(nonatomic,strong) IBOutlet HMJLabel       *totalMoneyView;
@property(nonatomic,strong) IBOutlet UIButton       *startOrEndNowBtn;
@property(nonatomic,strong) IBOutlet UIButton       *startOrEndNextBtn;
@property(nonatomic,strong) IBOutlet UILabel        *todayTime;
@property(nonatomic,strong) IBOutlet HMJLabel       *todayMoney;
@property(nonatomic,strong) IBOutlet UIButton       *lite_Btn;

//tableview + 底下的统计
@property(nonatomic,strong) IBOutlet UIView         *containView;
@property(nonatomic,strong) IBOutlet UITableView    *myTableView;
@property(nonatomic,strong) IBOutlet UILabel        *overTimeLbel;
@property(nonatomic,strong) IBOutlet HMJLabel       *overMoneyLbel;


@property(nonatomic,strong) NSMutableArray          *clientLogArray;
@property(nonatomic,strong) UIPopoverController     *popoverController;
@property(nonatomic,strong) NSIndexPath             *delete_indexPath;
@property(nonatomic,strong) NSTimer                 *myTimer;
@property(nonatomic,strong) Clients                 *sel_client;
@property(nonatomic,strong) Logs                    *changelog;


@property(nonatomic,strong) TimerMainViewController         *mainView;
@property(nonatomic,weak)IBOutlet DashBoardExternalView     *externalView;

-(void)deletLog_index:(NSIndexPath *)indexPath;
-(void)initClientData;

-(void)back;
-(void)doAction;

-(void)addInvoice;
-(void)doTodayTimeAndMoney;

-(IBAction)clockNowBtn;
-(IBAction)clockNextBtn;

-(void)onMyTimer;
-(void)pop_system_UnlockLite;

@end
