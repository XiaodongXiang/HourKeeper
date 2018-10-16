//
//  SyncViewController_iphone.m
//  HoursKeeper
//
//  Created by xy_dev on 10/21/13.
//
//

#import "SyncViewController_iphone.h"

#import <Dropbox/Dropbox.h>
#import "AppDelegate_Shared.h"




@interface SyncViewController_iphone ()
{
    int isUnLock_lite;
}
@end


@implementation SyncViewController_iphone

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
    [self initPoint];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
-(void)initPoint
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton setImage:[UIImage imageNamed:@"icon_arrow.png"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = appDelegate.naviFont;
    [backButton setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Sync Data"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    if ([appDelegate.appSetting.autoSync isEqualToString:@"NO"])
    {
        isAutoSync = NO;
    }
    else
        isAutoSync = YES;

}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)flashView
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    self.dropbox_statu.on = [appDelegate.dropboxHelper.dropbox_account isLinked];
//    
//    if (self.dropbox_statu.on == YES)
//    {
//        DBAccountInfo *acountInfo = appDelegate.dropboxHelper.dropbox_account.info;
//        self.drop_accoutLbel.text = acountInfo.userName;
//        [self.drop_accoutLbel setHidden:NO];
//    }
//    else
//    {
//        [self.drop_accoutLbel setHidden:YES];
//        self.drop_accoutLbel.text = @"";
//    }
}

-(void)flashView2
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    self.dropbox_statu.on = [appDelegate.dropboxHelper.dropbox_account isLinked];
//    
//    DBAccountInfo *acountInfo = appDelegate.dropboxHelper.dropbox_account.info;
//    if (self.dropbox_statu.on == YES && acountInfo != nil)
//    {
//        self.drop_accoutLbel.text = acountInfo.userName;
//        [self.drop_accoutLbel setHidden:NO];
//        [self.dropbox_statu setHidden:NO];
//        [self.statu_activty setHidden:YES];
//        [self.statu_activty stopAnimating];
//    }
//    else
//    {
//        [self.drop_accoutLbel setHidden:YES];
//        self.drop_accoutLbel.text = @"";
//        [self.dropbox_statu setHidden:YES];
//        [self.statu_activty setHidden:NO];
//        [self.statu_activty startAnimating];
//    }
}





#pragma mark TabelView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Sync Automatically";
    }
    else
        cell.textLabel.text = @"Sync Manually";
    
    if (isAutoSync)
    {
        if (indexPath.row==0)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        if (indexPath.row==0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (indexPath.row==0)
    {
        isAutoSync = YES;
    }
    else
        isAutoSync = NO;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    if (isAutoSync)
    {
        appDelegate.appSetting.autoSync = @"YES";
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        cell1.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        appDelegate.appSetting.autoSync = @"NO";
        cell0.accessoryType = UITableViewCellAccessoryNone;
        cell1.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [appDelegate.managedObjectContext save:nil];
    
    
}





-(void)pop_system_UnlockLite
{
    isUnLock_lite = 1;
    [self flashView];
}



@end
