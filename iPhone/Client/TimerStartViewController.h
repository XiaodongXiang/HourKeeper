//
//  TimerStartViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 5/21/13.
//
//

#import <UIKit/UIKit.h>

#import "Clients.h"

#import "StartTimeViewController.h"
#import "AddLogViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "StartTimeViewController_iPhone.h"

/**
    Client Info页面
 */
@interface TimerStartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,getNewLogDelegate,MFMailComposeViewControllerDelegate,StartTimeViewController_iPhoneDelegate>
{
    NSDateFormatter *pointInTimeDateFormatter;
    NSDateFormatter *dayDateFormatter;
    
    StartTimeViewController_iPhone *startTimeViewControllerVC;
    
}
//input
@property(nonatomic,strong) Clients *sel_client;
//定时器
//@property(nonatomic,strong) NSTimer *myTimer;
//某个log是新添加的，以动画显示出来
@property(nonatomic,strong) Logs *changelog;

//client的名称以及每小时的回报
@property(nonatomic,weak)IBOutlet   UILabel *clientNameLbel;
@property(nonatomic,weak)IBOutlet   UILabel *perHourLabel;

@property(nonatomic,weak)IBOutlet   UIButton    *backBtn;
@property(nonatomic,weak)IBOutlet   UIButton    *phoneBtn;
@property(nonatomic,weak)IBOutlet   UIButton    *emailBtn;
@property(nonatomic,weak)IBOutlet   UIButton    *moreBtn;
@property(nonatomic,weak)IBOutlet   UITableView *myTableView;


//tabbar view
@property(nonatomic,weak)IBOutlet   UIView  *line;
@property(nonatomic,weak)IBOutlet   UIImageView *stateImageViewInternal;
@property(nonatomic,weak)IBOutlet   UIImageView *stateImageViewExternal;
@property(nonatomic,weak)IBOutlet   UILabel *totalTimeLbel;
@property(nonatomic,weak)IBOutlet UIButton *startOrEndNowBtn;

//add
@property(nonatomic,weak) IBOutlet UILabel *startTimeLbel;
@property(nonatomic,weak) IBOutlet UIButton *startOrEndNextBtn;



//该client下工作记录 log数组
@property(nonatomic,strong) NSMutableArray *clientLogArray;
//删除的index
@property(nonatomic,strong) NSIndexPath * delete_indexPath;




-(void)setClientData;

-(void)doAction;

-(void)addInvoice;

-(IBAction)clockNowBtn;

-(void)onMyTimer;

-(void)deletLog_index:(NSIndexPath *)indexPath;

-(void)fleshUI;
@end

