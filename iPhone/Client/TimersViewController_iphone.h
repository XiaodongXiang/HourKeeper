//
//  TimersViewController_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Clients.h"

#import "NewClientViewController_iphone.h"
#import "TimerStartViewController.h"

/**
    TimersViewController 记录Clients的viewController
 */
@interface TimersViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
}

@property(nonatomic,strong) IBOutlet UITableView    *myTableView;
@property(nonatomic,strong) NSMutableArray          *clientArray;
@property(nonatomic,strong) IBOutlet UIImageView    *tipImagV;
@property(nonatomic,strong) Clients                 *deleteClient;
//@property(nonatomic,strong) Clients                 *selectClient;

//1.选中了哪个cell  2.client info计时页面
@property(nonatomic,strong) NSIndexPath             *animation_CellPath;
@property(nonatomic,strong) TimerStartViewController *dropboxStartViewCtor;

//广告btn
@property(nonatomic,strong) IBOutlet UIButton *lite_Btn;


-(void)doAdd;


-(IBAction)doLiteBtn;
-(void)pop_system_UnlockLite; //统一的 UnLock action 名
-(void)fleshUI;

-(void)initTimerAarry;
@end
