//
//  SyncViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 10/9/13.
//
//

#import "SyncViewController_ipad.h"

#import <Dropbox/Dropbox.h>
#import "AppDelegate_Shared.h"



@interface SyncViewController_ipad ()
{
    int isUnLock_lite;
}
@end





@implementation SyncViewController_ipad

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
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];

    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Sync Data"];


    
    UIImage *image = [[UIImage imageNamed:@"cell1_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    _dropBv.image = image;
    _dropBv2.image = image;
    [self.drop_accoutLbel setHidden:YES];
    [self.statu_activty setHidden:YES];
    
    if (appDelegate.isPurchased == NO)
    {
        isUnLock_lite = 0;
        [_FullView setHidden:YES];
        [_FreeView setHidden:NO];
    }
    else
    {
        isUnLock_lite = 1;
        self.dropbox_statu.frame = CGRectMake(490-self.dropbox_statu.frame.size.width, self.dropbox_statu.frame.origin.y, self.dropbox_statu.frame.size.width, self.dropbox_statu.frame.size.height);
        [_FullView setHidden:NO];
        [_FreeView setHidden:YES];
        [self flashView];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)switchChanged
{
    [self.drop_accoutLbel setHidden:YES];
    self.drop_accoutLbel.text = @"";
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate.dropboxHelper linkDropbox:self.dropbox_statu.on Observer:self];
    if (self.dropbox_statu.on == YES)
    {
        self.dropbox_statu.on = NO;
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)flashView
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    self.dropbox_statu.on = [appDelegate.dropboxHelper.dropbox_account isLinked];
    
    if (self.dropbox_statu.on == YES)
    {
        DBAccountInfo *acountInfo = appDelegate.dropboxHelper.dropbox_account.info;
        self.drop_accoutLbel.text = acountInfo.userName;
        [self.drop_accoutLbel setHidden:NO];
    }
    else
    {
        [self.drop_accoutLbel setHidden:YES];
        self.drop_accoutLbel.text = @"";
    }
}

-(void)flashView2
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    self.dropbox_statu.on = [appDelegate.dropboxHelper.dropbox_account isLinked];
    
    DBAccountInfo *acountInfo = appDelegate.dropboxHelper.dropbox_account.info;
    if (self.dropbox_statu.on == YES && acountInfo != nil)
    {
        self.drop_accoutLbel.text = acountInfo.userName;
        [self.drop_accoutLbel setHidden:NO];
        [self.dropbox_statu setHidden:NO];
        [self.statu_activty setHidden:YES];
        [self.statu_activty stopAnimating];
    }
    else
    {
        [self.drop_accoutLbel setHidden:YES];
        self.drop_accoutLbel.text = @"";
        [self.dropbox_statu setHidden:YES];
        [self.statu_activty setHidden:NO];
        [self.statu_activty startAnimating];
    }
}



- (IBAction)toFullBtn:(id)sender
{
    [Flurry logEvent:@"7_ADS_DROP"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bv = [[UIView alloc] init];
    bv.backgroundColor = [UIColor clearColor];
    return bv;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bv = [[UIView alloc] init];
    bv.backgroundColor = [UIColor clearColor];
    return bv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tipCell setBackgroundColor:[UIColor clearColor]];
    
    return self.tipCell;
}





-(void)pop_system_UnlockLite
{
    isUnLock_lite = 1;
    
    self.dropbox_statu.frame = CGRectMake(310-self.dropbox_statu.frame.size.width, self.dropbox_statu.frame.origin.y, self.dropbox_statu.frame.size.width, self.dropbox_statu.frame.size.height);
    [_FullView setHidden:NO];
    [_FreeView setHidden:YES];
    [self flashView];
}




- (void)viewDidUnload
{
    [self setDropBv:nil];
    [self setDropBv2:nil];
    [self setFullView:nil];
    [self setFreeView:nil];
    
    
    if (isUnLock_lite != 1)
    {
//        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//        [appDelegate removeUnLock_Notificat:self];
    }
    
    [super viewDidUnload];
}



@end
