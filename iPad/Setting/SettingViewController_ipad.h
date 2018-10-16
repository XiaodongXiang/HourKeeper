//
//  SettingViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>




@interface SettingViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
}

@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) IBOutlet UITableViewCell *supportCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *backAndResCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *dropboxCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *profileCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *passcodeCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *currencyCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *touchIdCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *badgersCell;

@property (nonatomic,strong) IBOutlet UILabel *passcode_statu;
@property (nonatomic,strong) IBOutlet UILabel *currency_name;
@property (nonatomic,strong) IBOutlet UISwitch *badges_statu;
@property (nonatomic,strong) IBOutlet UISwitch *touchIdSwicth;
@property (nonatomic,strong) IBOutlet UILabel *touchLbel;
@property (nonatomic,assign) BOOL isPassOn;

@property (nonatomic,strong) IBOutlet UITableViewCell *weekStartCell;
@property (nonatomic,strong) IBOutlet UILabel *weekStartLbel;
@property (nonatomic,strong) IBOutlet UITableViewCell *exportDataCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *lite_restoreCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property(nonatomic,strong) IBOutlet    UIButton    *signOutBtn;

@property(nonatomic,strong) IBOutlet UITableViewCell *autosyncCell;
@property(nonatomic,strong) IBOutlet UISwitch         *autosyncSwitch;

@property(nonatomic,strong)IBOutlet   UITableViewCell *syncNowCell;
//@property(nonatomic,strong)IBOutlet     UIButton    *syncNowBtn;
@property(nonatomic,strong)IBOutlet     UILabel     *syncNowLabel;

@property(nonatomic,strong)IBOutlet UITableViewCell *restoreFromDropboxCell;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel1;
@property (weak, nonatomic) IBOutlet UILabel *autosyncLabel1;

-(void)initTouchId;
-(void)doSetTouchId;
-(void)checkTouchId;
-(void)initSetting;
-(IBAction)switchChanged:(UISwitch *)switchUI;
-(void)back;

-(void)pop_system_UnlockLite; //统一的 UnLock action 名

@end



#pragma mark -
#pragma mark UIDevice Extensions
@interface UIDevice (BHI_Extensions3)

+(NSString*)platform;
+(NSString*)platformString;

@end
