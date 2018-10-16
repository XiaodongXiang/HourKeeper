//
//  SettingsViewController_New.m
//  HoursKeeper
//
//  Created by xy_dev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController_New.h"

#import "AppDelegate_Shared.h"
#import "AppDelegate_iPhone.h"
#import "Settings.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import "PasscodeSettingViewController_iPhone.h"
#import "PasscodeViewController_iPhone.h"
#import "CurrencyViewController_iPhone.h"
#import "BackUpAndRestoreViewController.h"
#import "SetStartWeek_iphone.h"
#import "ExportDataViewController.h"
#import "SyncViewController_iphone.h"
#import "ProfileDetailViewController_iPhone.h"



@interface SettingsViewController_New ()
{
    int lineLeft;
}
@end

@implementation SettingsViewController_New

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE_6PLUS)
    {
        lineLeft = 20;
    }
    else
        lineLeft = 15;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Settings"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    [self initTouchId];
    
    [self initSetting];
    
    self.badges_statu.frame = CGRectMake(310-self.badges_statu.frame.size.width, self.badges_statu.frame.origin.y, self.badges_statu.frame.size.width, self.badges_statu.frame.size.height);
    

    
    
    _signOutBtn.backgroundColor = [UIColor colorWithRed:244.f/255.f green:79.f/255.f blue:68.f/255.f alpha:1];
    _signOutBtn.layer.cornerRadius = 3.5;
    _signOutBtn.layer.masksToBounds = YES;
    [_signOutBtn addTarget:self action:@selector(signOutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.autosyncSwitch addTarget:self action:@selector(autosyncSwitch:) forControlEvents:UIControlEventValueChanged];
    if([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
        self.autosyncSwitch.on = NO;
    else
        self.autosyncSwitch.on = YES;
    
    if (IS_IPHONE_6PLUS)
    {
        float left = 20;
        self.profileLabel1.left = left;
        self.weekstartonLabel1.left = left;
        self.currencyLabel1.left = left;
        self.csvLabel1.left = left;
        self.backupLabel1.left = left;
        self.autosyncLabel1.left = left;
        self.passcodeLabel1.left = left;
        self.touchicLabel1.left = left;
        self.badgetLabel1.left = left;
        self.contactLabel1.left = left;
        self.likeusLabel1.left = left;
        self.followusLabel1.left = left;
        self.syncLabel1.left = left;
        self.reminderLabel1.left = left;
        

        self.weekStartLbel.left -= 5;

        self.autosyncSwitch.left -=5;
        self.touchIdSwicth.left -= 5;
        self.badges_statu.left -= 5;
        self.passcode_statu.left -= 5;

        self.signOutBtn.left = left;
        self.currency_name.left -= 5;
        self.restorepurchasedLabel1.left = left;
    }
    
    self.signOutBtn.width = SCREEN_WITH - self.signOutBtn.left*2;


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    [self initSetting];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.passSetTouchCheckViewContor = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super   viewWillAppear:YES];
    AppDelegate_iPhone  *appDelegate_iPhone = (AppDelegate_iPhone  *)[[UIApplication sharedApplication]delegate];
    if ([appDelegate_iPhone.appUser.username length]==0 || appDelegate_iPhone.appUser == nil)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
    
}

#pragma mark Action

-(void)initTouchId
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegate canTouchId] != TouchNotAvOrTH)
    {
        [self.touchIdSwicth setUserInteractionEnabled:YES];
    }
    else
    {
        self.touchIdSwicth.on = NO;
        [self.touchIdSwicth setUserInteractionEnabled:NO];
        self.touchLbel.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1];
    }
}

-(void)initSetting
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.currency_name.text = [[appDelegate.appSetting.currency componentsSeparatedByString:@" - "] objectAtIndex:0];
    self.isPassOn =[appDelegate.appSetting.isPasscodeOn boolValue];
    if (_isPassOn == NO)
    {
        self.passcode_statu.text = @"OFF";
    }
    else
    {
        self.passcode_statu.text = @"ON";
    }
    self.badges_statu.on = [appDelegate.appSetting.isBadgeOn boolValue];
    
    int selectDay = [appDelegate getFirstDayForWeek];
    self.weekStartLbel.text = [appDelegate.m_weekDateArray objectAtIndex:selectDay-1];
    
    
    [self doSetTouchId];
    if ([appDelegate canTouchId] != TouchNotAvOrTH)
    {
        appDelegate.passSetTouchCheckViewContor = self;
    }
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPhone.appUser!=nil) {
        self.signOutBtn.enabled = YES;
        self.signOutBtn.hidden = NO;
        self.autosyncSwitch.userInteractionEnabled = YES;
        self.autosyncLabel1.textColor = self.profileLabel1.textColor;

    }
    else
    {
        self.signOutBtn.enabled = NO;
        self.signOutBtn.hidden = YES;
        self.autosyncSwitch.userInteractionEnabled = NO;
        self.autosyncSwitch.on = NO;
        self.autosyncLabel1.textColor = self.touchicLabel1.textColor;
    }

}

-(void)doSetTouchId
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.appSetting.istouchid.intValue == 2)
    {
        self.touchIdSwicth.on = YES;
    }
    else
    {
        self.touchIdSwicth.on = NO;
    }
}

-(void)checkTouchId
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate canTouchId] != TouchYes)
    {
        self.touchIdSwicth.on = NO;
    }
    [appDelegate setTouchIdPassword:self.touchIdSwicth.on];
    [self doSetTouchId];
}

- (IBAction)switchChanged:(UISwitch *)switchUI
{
    if (switchUI.tag == 2)
    {
        [Flurry logEvent:@"6_SET_BADGES"];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        appDelegate.appSetting.isBadgeOn = [NSNumber numberWithBool:_badges_statu.on];
        [context save:nil];
    }
    else if (switchUI.tag == 1)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (self.isPassOn == YES)
        {
            if ([appDelegate canTouchId] != TouchYes)
            {
                if (switchUI.on == YES)
                {
                    [appDelegate showTouchIdFaildTip_havePass:YES];
                }
                switchUI.on = NO;
            }
        }
        else
        {
            switchUI.on = NO;
            [appDelegate showTouchIdFaildTip_havePass:NO];
        }
        [appDelegate setTouchIdPassword:switchUI.on];
        [self doSetTouchId];
    }
}


-(void)signOutBtnPressed:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Sure to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign out", nil];
    alertView.tag = 100;
    AppDelegate_Shared  *appDelegate = (AppDelegate_Shared  *)[[UIApplication sharedApplication]delegate];
    appDelegate.close_PopView = alertView;
    
    [alertView show];
    
}

-(void)autosyncSwitch:(UISwitch *)sender
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    if (self.autosyncSwitch.on)
    {
        appDelegate.appSetting.autoSync = @"YES";
        [appDelegate.parseSync syncAllWithTip:NO];
    }
    else
    {
        appDelegate.appSetting.autoSync = @"NO";
         [Flurry logEvent:@"6_SET_SYNC"];
    }
    [appDelegate.managedObjectContext save:nil];
    [_settingTableview reloadData];
}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased && section==2)
    {
        return 110;
    }
    else if (!appDelegate.isPurchased && section==3)
        return 110;
    else if((appDelegate.isPurchased && section==1) || (!appDelegate.isPurchased && section == 2))
        return 50;
    else
        return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    

    
    if (appDelegate.isPurchased)
    {
        if(section==1)
        {
            
            UIView *v = [self generateNoteView];
            
            return v;
        }
        
    }
    else
    {
        if (section == 2) {
            UIView *v = [self generateNoteView];
            return v;
        }
    }

    
    
    if (appDelegate.isPurchased && section==2)
    {
        return self.footView;
    }
    else if (!appDelegate.isPurchased && section==3)
        return self.footView;
    else
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
        
    }
    
}

-(UIView *)generateNoteView
{
    float left = self.profileLabel1.left;

    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    v.backgroundColor = [UIColor clearColor];
    
    UILabel *note = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, [UIScreen mainScreen].bounds.size.width-left*2, v.height)];
    note.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    note.textColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
    note.text = @"Notice: It supports to sync directly with your account now, so sync with dropbox will be cancelled in future releases.";
    note.numberOfLines = 0;
    //        [note setLineBreakMode:NSLineBreakByWordWrapping];
    [v addSubview:note];
    [note setNeedsDisplay];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else
    {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    if (appDelegate.isPurchased)
    {
        return 3;
    }
    else
    {
        return 4;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    if (appDelegate.isPurchased)
    {
        if (section == 0)
        {
            return 3;
        }
        else if (section == 1)
        {
            return 6;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 3;
        }
        else if (section == 2)
        {
            return 6;
                
        }
        else
            return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    int base;
    if (appDelegate.isPurchased)
    {
        if (indexPath.section == 0)
        {
            base = 1;
        }
        else if (indexPath.section == 1)
        {
            base = 2;
        }
        else if(indexPath.section==2)
        {
            base = 3;
        }
        else
            base = 4;
    }
    else
    {
        if (indexPath.section == 0)
        {
            base = 0;
        }
        else if (indexPath.section == 1)
        {
            base = 1;
        }
        else if (indexPath.section == 2)
        {
            base = 2;
        }
        else if(indexPath.section==3)
        {
            base = 3;
        }
        else
            base = 4;
    }
    
    
    if (base == 0)
    {
        return self.lite_restoreCell;
    }
    else if (base == 1)
    {
        if (indexPath.row == 0)
        {
            return self.profileCell;
        }
        else if (indexPath.row == 1)
        {
            return self.weekStartCell;
        }
        else
        {
            return self.currencyCell;
        }
    }
    else if (base == 2)
    {
        if (indexPath.row == 0)
        {
            return self.exportDataCell;
        }
        else if (indexPath.row == 1)
        {
            return self.backAndResCell;
        }
        else if (indexPath.row == 2)
        {
            return self.autosyncCell;
        }
//        else if (indexPath.row==3)
//        {
//            return self.restoreFromDropboxCell;
//        }
        else if (indexPath.row == 3)
            return self.passcodeCell;
        else if (indexPath.row==4)
            return self.touchIdCell;
        else
            return self.badgersCell;
    }
    else
    {
        return self.supportCell;

    }

}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.settingTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    
    int base;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    


    if (appDelegate.isPurchased)
    {
        if (indexPath.section == 0)
        {
            base = 1;
        }
        else if (indexPath.section == 1)
        {
            base = 2;
        }
        else if(indexPath.section==2)
        {
            base = 3;
        }
        else
            base = 4;
    }
    else
    {
        if (indexPath.section == 0)
        {
            base = 0;
        }
        else if (indexPath.section == 1)
        {
            base = 1;
        }
        else if (indexPath.section == 2)
        {
            base = 2;
        }
        else if(indexPath.section==3)
        {
            base = 3;
        }
        else
            base = 4;
    }
    
    
    if (base == 0)
    {
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        [appDelegate doRePurchase_Lite];
    }
    else if (base == 1)
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"6_SET_PRO"];
            
            ProfileDetailViewController_iPhone *profileViewController = [[ProfileDetailViewController_iPhone alloc]init];
            profileViewController.isSetupProfile = NO;
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"6_SET_WEESTAON"];
            
            SetStartWeek_iphone *startWeekViewController = [[SetStartWeek_iphone alloc] initWithNibName:@"SetStartWeek_iphone" bundle:nil];
            
            [startWeekViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:startWeekViewController animated:YES];
        }
        else
        {
            CurrencyViewController_iPhone *currencyViewController = [[CurrencyViewController_iPhone alloc] initWithNibName:@"CurrencyViewController_iPhone" bundle:nil];
            
            [currencyViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:currencyViewController animated:YES];
        }
    }
    else if (base == 2)
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"6_SET_EXPCSV"];
            
            ExportDataViewController *exportDataController = [[ExportDataViewController alloc] initWithNibName:@"ExportDataViewController" bundle:nil];
            
            [exportDataController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:exportDataController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"6_SET_BACKUP"];
            
            BackUpAndRestoreViewController *backupController = [[BackUpAndRestoreViewController alloc] initWithNibName:@"BackUpAndRestoreViewController" bundle:nil];
            
            [backupController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:backupController animated:YES];
        }
        else if (indexPath.row == 2)
        {
//            [Flurry logEvent:@"6_SET_SYNC"];
            
//            SyncViewController_iphone *syncController = [[SyncViewController_iphone alloc] initWithNibName:@"SyncViewController_iphone" bundle:nil];
//            
//            [syncController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:syncController animated:YES];
        }
//        else if (indexPath.row==3)
//        {
//            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"We are sorry to announced that the sync function via Dropbox will be removed in next update since Dropbox have decided to deprecate their Sync API.\nHowever, you can still sync your data via our new sync service by registering as our users in the settings. To prevent any data lost in next update, it is highly recommend to unlink Dropbox account from now on and sync your data with new service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            alertview.tag = 99;
//            [alertview show];
//        }
        else if (indexPath.row==3)
        {
            [Flurry logEvent:@"6_SET_PASS"];
            
            if (_isPassOn == NO)
            {
                PasscodeViewController_iPhone *passcodeViewController =  [[PasscodeViewController_iPhone alloc] initWithNibName:@"PasscodeViewController_iPhone" bundle:nil];
                
                passcodeViewController.navi_tittle = @"Set Passcode";
                
                [passcodeViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:passcodeViewController animated:YES];
            }
            else
            {
                PasscodeSettingViewController_iPhone *passViewController = [[PasscodeSettingViewController_iPhone alloc] initWithNibName:@"PasscodeSettingViewController_iPhone" bundle:nil];
                
                [passViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:passViewController animated:YES];
            }
        }
    }
    else if(base == 3)
    {
//        if (indexPath.row == 0)
//        {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                if ([mailClass canSendMail])
                {
                    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                    mailController.mailComposeDelegate = self;
                    [mailController setSubject:@"Hours Keeper Feedback"];
                    [mailController setToRecipients:[NSArray arrayWithObject:@"hourskeeper@bluetgs.com"]];
        
                    NSString *liteorpro;
                    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

#ifdef LITE
                    
                    if(appDelegate.isPurchased)
                    {
                        liteorpro = @"Pur";
                    }
                    else
                    {
                        liteorpro = @"Lite";
                    }
#else
                    liteorpro = @"Pro";
#endif

                    
                    NSString * versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    NSString * deviceStr = [UIDevice platformString];
                    NSString * deviceType = [[UIDevice currentDevice] systemName];
                    NSString * deviceVersion = [[UIDevice currentDevice] systemVersion];
                    NSString *mailBody = [NSString stringWithFormat:@"<html><body>App: Hours Keeper v%@ %@<br/>%@：v%@<br/>Device: %@<br/>Feedback here: </body></html>",versionStr,liteorpro,deviceType,deviceVersion,deviceStr];
                    
                    [mailController setMessageBody:mailBody isHTML:YES];
                    
                    
                    appDelegate.appMailController = mailController;
                    
                    [self presentViewController:mailController animated:YES completion:nil];
                    appDelegate.m_widgetController = self;
                    
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a mail account in order to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                    appDelegate.close_PopView = alertView;
                    
                }
            }

    }
    else
    {
        
    }
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}




-(void)pop_system_UnlockLite
{

    [_settingTableview reloadData];
    
//    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
//    [appDelegate removeUnLock_Notificat:self];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        //最后一次同步
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        [appDelegate.parseSync syncAllWithTip:NO];

    }
    //登出提示
    else if(alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            
            
            [appDelegate showIndicator];

            
            //Dropbox也要登出
            if ([appDelegate.dropboxHelper.dropbox_account isLinked])
            {
                [appDelegate.dropboxHelper dropnUnlink];
            }
            

            
            //上传所有数据
//            [appDelegate.parseSync updateAllLocalDatatoServerBeforeLogout];
            
            /**
             逻辑：
             1.判断有没有在同步
             （1）在：提醒用户等待，然后再试一次
             （2）不在：判断当前有没有没有被同步的数据
             （a）有：手动同步，提醒用户去同步，自动同步，提醒用户等待同步完成
             （b）没有
             */
            //有数据在同步，让用户等待
//            NSLog(@"appDelegate.isSyncing:%d",appDelegate.isSyncing);
            if (appDelegate.isSyncing)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Data is syncing, please don't disconnect the internet and wait a moment, then try to sign out again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                appDelegate.close_PopView = alertView;
                [alertView show];
                [appDelegate hideIndicator];

                return;
            }
            else
            {
                if ([appDelegate.parseSync isAnyDataWerenotSync])
                {
                    //自动同步
                    if (![appDelegate.appSetting.autoSync isEqualToString:@"NO"])
                    {
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Data is syncing, please don't disconnect the internet and wait a moment, then try to sign out again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        appDelegate.close_PopView = alertView;
                        [alertView show];
                        [appDelegate hideIndicator];

                        return;
                    }
                    else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Data is syncing, please don't disconnect the internet and wait a moment, then try to sign out again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        appDelegate.close_PopView = alertView;
                        alertView.tag = 101;
                        [alertView show];
                        [appDelegate hideIndicator];

                        return;
                    }
                }
            }
            
            
            
            //如果已经登出了，就不需要再登出了
            AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            if (appDelegate_iPhone.appUser==nil) {
                [appDelegate hideIndicator];

                return;
            }
            
            [PFUser logOutInBackgroundWithBlock:^(NSError *error)
             {
                 appDelegate_iPhone.appUser = nil;
                 self.signOutBtn.enabled = NO;
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                 
                 LogInViewController *loginVC=[[LogInViewController alloc]init];
                 UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
                 appDelegate.window.rootViewController=navi;
                 
                 
                 [appDelegate hideIndicator];
             }];
            
        }
    }
    else if (alertView.tag == 99)
    {
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        //Dropbox同步
        if (appDelegate.dropboxHelper.dropbox_account.linked)
        {
            NSLog(@"已经登陆上Dropbox了");
            [appDelegate.dropboxHelper detcetAllServertoLocal];
            appDelegate.appSetting.lastSyncDate = nil;
            [appDelegate.managedObjectContext save:nil];
        }
        else
        {
            //跳转到Dropbox
            [appDelegate.dropboxHelper linkDropbox:YES Observer:self];
            
        }

    }

}

@end






@implementation UIDevice (BHI_Extensions2)

+(NSString*)platform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	//NSString *platform = [NSString stringWithCString:machine];
	NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding]; 
	free(machine);
	return platform;
}

+(NSString*)platformString
{
    NSString *platform = [self platform];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    //还有6s plus没有验证
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    
    //touch
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad air 2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad air 2";
    
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}







@end

