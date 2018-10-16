//
//  SettingViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController_ipad.h"

#import "AppDelegate_iPad.h"

#import "Settings.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import "PasscodeSettingViewController_iPd.h"
#import "PasscodeViewController_iPd.h"
#import "SetCurrency.h"
#import "SetBackupAndRestore.h"
#import "SetProfile.h"
#import "SetStartWeek.h"
#import "ExportDataViewController_ipad.h"
#import "SyncViewController_ipad.h"
#import "ProfileDetailViewController_iPad.h"


@interface SettingViewController_ipad ()
{
    int isUnLock_lite;
    int isPassBack;
}
@end



@implementation SettingViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = appDelegate.naviFont;
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Settings"];
    

    [self initTouchId];
    
    [self initSetting];
    
    self.badges_statu.frame = CGRectMake(490-self.badges_statu.frame.size.width, self.badges_statu.frame.origin.y, self.badges_statu.frame.size.width, self.badges_statu.frame.size.height);
    
    if (appDelegate.isPurchased == NO)
    {
        isUnLock_lite = 0;
    }
    else
    {
        isUnLock_lite = 1;
    }
    
    isPassBack = 0;
    
    _signOutBtn.backgroundColor = [UIColor colorWithRed:244.f/255.f green:79.f/255.f blue:68.f/255.f alpha:1];
    _signOutBtn.layer.cornerRadius = 3.5;
    _signOutBtn.layer.masksToBounds = YES;
    [_signOutBtn addTarget:self action:@selector(signOutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.autosyncSwitch addTarget:self action:@selector(autosyncSwitch:) forControlEvents:UIControlEventValueChanged];
    if([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
        self.autosyncSwitch.on = NO;
    else
        self.autosyncSwitch.on = YES;
    

    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if (appDelegate_iPad.appUser!=nil) {
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
        self.autosyncLabel1.textColor = self.touchLbel.textColor;
    }

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}





-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initSetting];
    
    self.myTableView.frame = CGRectMake(0, 0, 500, 500-44);
    if (isPassBack == 1)
    {
        self.view.frame = CGRectMake(0, 0, 500, 500);
        self.myTableView.frame = CGRectMake(0, 44, 500, 500-44);
        isPassBack = 0;
    }
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.passSetTouchCheckViewContor = nil;
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

-(void)initSetting
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    self.currency_name.text = [[appDelegate.appSetting.currency componentsSeparatedByString:@" - "] objectAtIndex:0];
    self.isPassOn =[appDelegate.appSetting.isPasscodeOn boolValue];
    if (self.isPassOn == NO)
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
    

}







-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)switchChanged:(UISwitch *)switchUI
{
    if (switchUI.tag == 2)
    {
        [Flurry logEvent:@"6_SET_BADGES"];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        appDelegate.appSetting.isBadgeOn = [NSNumber numberWithBool:self.badges_statu.on];
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
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
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
        //如果上一次还没同步完，这次反复打开会反复开启线程
        [appDelegate.parseSync syncAllWithTip:NO];
    }
    else
    {
        appDelegate.appSetting.autoSync = @"NO";
        [Flurry logEvent:@"6_SET_SYNC"];
    }
    [appDelegate.managedObjectContext save:nil];
    [self.myTableView reloadData];
}

//-(void)syncNowBtnPressed:(UIButton *)sender
//{
//    NSLog(@"点击了同步按钮");
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//    if ([appDelegate.appSetting.autoSync isEqualToString:@"NO"]) {
//        self.syncNowBtn.userInteractionEnabled = NO;
//        [appDelegate.parseSync syncAll];
//
//    }
//    else
//    {
//        NSLog(@"自动同步状态开启，不能手动同步");
//    }
//
//}

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
    if((appDelegate.isPurchased && section==1) || (!appDelegate.isPurchased && section == 2))
        return 50;
    return 35;
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
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

-(UIView *)generateNoteView
{
    float left = 15;
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.width, 50)];
    v.backgroundColor = self.myTableView.backgroundColor;
    
    UILabel *note = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, v.size.width-left*2, v.height)];
    note.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    note.textColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
    note.text = @"Notice: It supports to sync directly with your account now, so sync with dropbox will be cancelled in future releases.";
    note.numberOfLines = 0;
    //        [note setLineBreakMode:NSLineBreakByWordWrapping];
    [v addSubview:note];
//    [note setNeedsDisplay];
    return v;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //正式版 logout cell 
    if (isUnLock_lite == 1)
    {
        return 4;
    }
    else
    {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //正式版
    if (isUnLock_lite == 1)
    {
        if (section == 0)
        {
            return 3;
        }
        else if (section == 1)
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            //手动同步
            if ([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
            {
                return 7;
            }
            else
                return 6;
        }
        else if(section==2)
        {
            return 1;
        }
        else
            return 1;
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
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            //手动同步
            if ([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
            {
                return 7;
            }
            else
                return 6;
        }
        else if(section==3)
        {
            return 1;
        }
        else
            return 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    _logoutCell.backgroundColor = [UIColor clearColor];
    [_logoutCell.backgroundView removeFromSuperview];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int base;
    if (isUnLock_lite == 1)
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
        UIImage *image = [[UIImage imageNamed:@"cell1_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
        [self.lite_restoreCell setBackgroundView:bv];
        
        return self.lite_restoreCell;
    }
    else if (base == 1)
    {
        if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.profileCell setBackgroundView:bv];
            
            return self.profileCell;
        }
        else if (indexPath.row == 1)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.weekStartCell setBackgroundView:bv];
            
            return self.weekStartCell;
        }
        else
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.currencyCell setBackgroundView:bv];
            
            return self.currencyCell;
        }
    }
    else if (base == 2)
    {
        if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.exportDataCell setBackgroundView:bv];
            
            return self.exportDataCell;
        }
        else if (indexPath.row == 1)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.backAndResCell setBackgroundView:bv];
            
            return self.backAndResCell;
        }
        else if (indexPath.row == 2)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.autosyncCell setBackgroundView:bv];
            
            return self.autosyncCell;
        }
        else
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            //手动同步
            if([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
            {
                if (indexPath.row==3)
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.syncNowCell setBackgroundView:bv];
                    return self.syncNowCell;
                }
//                else if(indexPath.row==4)
//                {
//                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//                    [self.restoreFromDropboxCell setBackgroundView:bv];
//                    
//                    return self.restoreFromDropboxCell;
//                }
                else if (indexPath.row == 4)
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.passcodeCell setBackgroundView:bv];
                    
                    return self.passcodeCell;
                }
                else if (indexPath.row == 5)
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.touchIdCell setBackgroundView:bv];
                    
                    return self.touchIdCell;
                }
                else
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.badgersCell setBackgroundView:bv];
                    
                    return self.badgersCell;
                }

            }
            else
            {
//                if (indexPath.row==3)
//                {
//                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//                    [self.restoreFromDropboxCell setBackgroundView:bv];
//                    
//                    return self.restoreFromDropboxCell;
//
//                }
                if (indexPath.row == 3)
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.passcodeCell setBackgroundView:bv];
                    
                    return self.passcodeCell;
                }
                else if (indexPath.row == 4)
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.touchIdCell setBackgroundView:bv];
                    
                    return self.touchIdCell;
                }
                else
                {
                    UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                    UIImageView *bv = [[UIImageView alloc] initWithImage:image];
                    [self.badgersCell setBackgroundView:bv];
                    
                    return self.badgersCell;
                }

            }
        }
        
    }
    else if(base == 3)
    {
//        if (indexPath.row == 0)
//        {
            UIImage *image = [[UIImage imageNamed:@"cell1_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.supportCell setBackgroundView:bv];
            
            return self.supportCell;
//        }
//        else if (indexPath.row == 1)
//        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.facebookCell setBackgroundView:bv];
//            
//            return self.facebookCell;
//        }
//        else
//        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.twitterCell setBackgroundView:bv];
//            
//            return self.twitterCell;
//        }
    }
    else
    {
//        UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//        [self.logoutCell setBackgroundView:bv];
        
        return self.logoutCell;
        
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.parseSync updateAllLocalDatatoServerAfterDropboxLinked];
//    return;
    
    
    
    
    int base;
    if (isUnLock_lite == 1)
    {
        if (indexPath.section == 0)
        {
            base = 1;
        }
        else if (indexPath.section == 1)
        {
            base = 2;
        }
        else
        {
            base = 3;
        }
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
        else
        {
            base = 3;
        }
    }
    
    
    
    if (base == 0)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [appDelegate doRePurchase_Lite];
    }
    else if (base == 1)
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"6_SET_PRO"];
            
            ProfileDetailViewController_iPad  *profileViewController = [[ProfileDetailViewController_iPad alloc]init];
            profileViewController.isSetupProfile = NO;
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"6_SET_WEESTAON"];
            
            SetStartWeek *startWeekViewController = [[SetStartWeek alloc] initWithNibName:@"SetStartWeek" bundle:nil];
            
            [self.navigationController pushViewController:startWeekViewController animated:YES];
        }
        else
        {
            SetCurrency *currencyViewController = [[SetCurrency alloc] initWithNibName:@"SetCurrency" bundle:nil];
            [self.navigationController pushViewController:currencyViewController animated:YES];
            
        }
    }
    else if (base == 2)
    {
        if (indexPath.row == 0) 
        {
            [Flurry logEvent:@"6_SET_EXPCSV"];
            
            ExportDataViewController_ipad *exportDataController = [[ExportDataViewController_ipad alloc] initWithNibName:@"ExportDataViewController_ipad" bundle:nil];

            [self.navigationController pushViewController:exportDataController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"6_SET_BACKUP"];
            
            SetBackupAndRestore *backupController = [[SetBackupAndRestore alloc] initWithNibName:@"SetBackupAndRestore" bundle:nil];
            
            [self.navigationController pushViewController:backupController animated:YES];
        }
        else if (indexPath.row == 2)
        {
//            [Flurry logEvent:@"6_SET_SYNC"];
            
//            SyncViewController_ipad *syncController = [[SyncViewController_ipad alloc] initWithNibName:@"SyncViewController_ipad" bundle:nil];
//            
//            [self.navigationController pushViewController:syncController animated:YES];
        }
        else
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            if([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
            {
                if(indexPath.row==3)
                {

                    if (!appDelegate.isSyncing)
                    {
                        NSLog(@"开始自动同步");
                        appDelegate.isSyncing = YES;
                        [self syncNowAnimation];
                        [appDelegate.parseSync syncAllWithTip:YES];
                    }
                   
                    
                }
//                else if (indexPath.row==4)
//                {
//                    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"We are sorry to announced that the sync function via Dropbox will be removed in next update since Dropbox have decided to deprecate their Sync API.\nHowever, you can still sync your data via our new sync service by registering as our users in the settings. To prevent any data lost in next update, it is highly recommend to unlink Dropbox account from now on and sync your data with new service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    alertview.tag = 99;
//                    [alertview show];
//                    
//                    
//                }
                else if (indexPath.row == 4)
                {
                    [Flurry logEvent:@"6_SET_PASS"];
                    
                    if (self.isPassOn == NO)
                    {
                        isPassBack = 1;
                        PasscodeViewController_iPd *passcodeViewController =  [[PasscodeViewController_iPd alloc] initWithNibName:@"PasscodeViewController_iPd" bundle:nil];
                        
                        [self.navigationController pushViewController:passcodeViewController animated:YES];
                    }
                    else
                    {
                        PasscodeSettingViewController_iPd *passViewController = [[PasscodeSettingViewController_iPd alloc] initWithNibName:@"PasscodeSettingViewController_iPd" bundle:nil];
                        
                        [self.navigationController pushViewController:passViewController animated:YES];
                    }
                }
            }
            else
            {
//                if (indexPath.row==3)
//                {
//                    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"We are sorry to announced that the sync function via Dropbox will be removed in next update since Dropbox have decided to deprecate their Sync API.\nHowever, you can still sync your data via our new sync service by registering as our users in the settings. To prevent any data lost in next update, it is highly recommend to unlink Dropbox account from now on and sync your data with new service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    alertview.tag = 99;
//                    [alertview show];
//
//                    
//                    
//                }
                if (indexPath.row == 3)
                {
                    [Flurry logEvent:@"6_SET_PASS"];
                    
                    if (self.isPassOn == NO)
                    {
                        isPassBack = 1;
                        PasscodeViewController_iPd *passcodeViewController =  [[PasscodeViewController_iPd alloc] initWithNibName:@"PasscodeViewController_iPd" bundle:nil];
                        
                        [self.navigationController pushViewController:passcodeViewController animated:YES];
                    }
                    else
                    {
                        PasscodeSettingViewController_iPd *passViewController = [[PasscodeSettingViewController_iPd alloc] initWithNibName:@"PasscodeSettingViewController_iPd" bundle:nil];
                        
                        [self.navigationController pushViewController:passViewController animated:YES];
                    }
                }
            }
        }
        
    }
    else
    {
        if (indexPath.row == 0)
        {
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
//        else if (indexPath.row == 1)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Appxy/487861014615213"]];
//        }
//        else
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/appxy_official"]];
//        }
    }
    
}



-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}




-(void)pop_system_UnlockLite
{
    isUnLock_lite = 1;
    [self.myTableView reloadData];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        [appDelegate.parseSync syncAllWithTip:NO];

    }
    else if(alertView.tag ==100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            [appDelegate showIndicator];
            NSLog(@"开始转圈");

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
            if (appDelegate.isSyncing)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Data is syncing, please don't disconnect the internet and wait a moment, then try to sign out again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                appDelegate.close_PopView = alertView;
                [appDelegate hideIndicator];

                [alertView show];
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
                        alertView.tag = 101;
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
            
            
            
            [PFUser logOutInBackgroundWithBlock:^(NSError *error)
             {
                 appDelegate.appUser = nil;

                 [appDelegate logInVC];
                 [appDelegate hideIndicator];
             }];
            
        }
    }
    else if(alertView.tag == 99)
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
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

#pragma mark Syncing... animation
-(void)syncNowAnimation
{
    [self performSelector:@selector(animate1) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(animate2) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(animate3) withObject:nil afterDelay:1.5f];
    [self performSelector:@selector(animate4) withObject:nil afterDelay:2.0f];

    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isSyncing)
    {
        [self performSelector:@selector(syncNowAnimation) withObject:nil afterDelay:2.1f];
    }
    else
    {
        [self performSelector:@selector(animate) withObject:nil afterDelay:2.5f];
    }
}

-(void)animate
{
//    _svc_syncNowLabel.text=@"Sync now";
    self.syncNowLabel.text = @"Sync now";
//    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//    [appDelegate.parseSync SyncTip];
}
-(void)animate1
{
//    _svc_syncNowLabel.text=@"Syncing";
    self.syncNowLabel.text = @"Syncing";
}
-(void)animate2
{
//    _svc_syncNowLabel.text=@"Syncing.";
      self.syncNowLabel.text = @"Syncing.";
    

}
-(void)animate3
{
//    _svc_syncNowLabel.text=@"Syncing..";
        self.syncNowLabel.text = @"Syncing..";
    

}
-(void)animate4
{
//    _svc_syncNowLabel.text=@"Syncing...";
    
self.syncNowLabel.text = @"Syncing...";
}

@end




@implementation UIDevice (BHI_Extensions3)

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
