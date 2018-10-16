//
//  SettingsViewController_New.h
//  HoursKeeper
//
//  Created by xy_dev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>




@interface SettingsViewController_New : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
   
}

@property (weak, nonatomic) IBOutlet UITableView *settingTableview;

@property (nonatomic,strong) IBOutlet UITableViewCell *supportCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *backAndResCell;

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

@property (nonatomic,strong) IBOutlet UITableViewCell *facebookCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *twitterCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *lite_restoreCell;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property(nonatomic,strong) IBOutlet    UIButton    *signOutBtn;

@property(nonatomic,strong) IBOutlet UITableViewCell *autosyncCell;
@property(nonatomic,strong) IBOutlet UISwitch         *autosyncSwitch;

@property(nonatomic,strong)IBOutlet UITableViewCell *restoreFromDropboxCell;

@property(nonatomic,weak)IBOutlet   UILabel *profileLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *weekstartonLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *currencyLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *csvLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *backupLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *autosyncLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *passcodeLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *touchicLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *badgetLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *contactLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *likeusLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *followusLabel1;
@property(nonatomic,weak)IBOutlet   UILabel     *restorepurchasedLabel1;
@property(nonatomic,weak)IBOutlet   UILabel *syncLabel1;
@property (nonatomic , weak) IBOutlet UILabel*reminderLabel1;;


-(IBAction)switchChanged:(UISwitch *)switchUI;
-(void)initTouchId;
-(void)checkTouchId;
-(void)doSetTouchId;
-(void)initSetting;

-(void)pop_system_UnlockLite; //统一的 UnLock action 名


@end



#pragma mark -
#pragma mark UIDevice Extensions
@interface UIDevice (BHI_Extensions2)

+(NSString*)platform;
+(NSString*)platformString;


@end


