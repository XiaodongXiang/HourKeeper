//
//  DashBoardViewController.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import "DashBoardViewController.h"
#import "AppDelegate_Shared.h"
#import "DashBoardTableViewCell.h"
#import "TimerStartViewController.h"
#import "DashBoardExternalView.h"
#import "AppDelegate_iPhone.h"

#import <Crashlytics/Crashlytics.h>
#import "XDDashBoardTableViewCell.h"
#import "EditInvoiceNewViewController.h"

#import "StartTimeViewController_iPhone.h"
#import "NewClientViewController_iphone.h"

#define ALREADY_LAUNCH @"ALREADY_LAUNCH"
@interface DashBoardViewController ()<XDDashBoardTableViewCellDelegate,StartTimeViewController_iPhoneDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet NSLayoutConstraint *left1;
    __weak IBOutlet NSLayoutConstraint *left3;
    __weak IBOutlet NSLayoutConstraint *left2;
    __weak IBOutlet UILabel *totalLbl;
    __weak IBOutlet UILabel *overTimeLbl;
    __weak IBOutlet UILabel *tarendLbl;
    __weak IBOutlet UIView *totalBackView;

    IBOutlet UIView *invoiceView;
    IBOutlet UIView *clockHeadView;
    
    XDDashBoardTableViewCell* _currentCell;
    NSIndexPath* _currentIndexPath;
    
    ClienOperat _selectClientOperat;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *invoiceUnpaidCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *invoicePaidCell;

@property (weak, nonatomic) IBOutlet UILabel *unpaidNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *paidNumCell;
@property (weak, nonatomic) IBOutlet UILabel *unpaidRecurringLbl;
@property (weak, nonatomic) IBOutlet UILabel *paidRecurringLbl;
@property (weak, nonatomic) IBOutlet UILabel *paidAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *unpaidAmountCell;

@property(nonatomic, strong)UIView * backCoverView;
@property(nonatomic, strong)UIView * datePickerView;
@property(nonatomic, strong)UIDatePicker * datePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *emptyOnClockCell;

@end



@implementation DashBoardViewController

-(UIView *)backCoverView{
    if (!_backCoverView) {
        _backCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT)];
        _backCoverView.backgroundColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:1];
        _backCoverView.alpha = 0;
        _backCoverView.hidden = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapClick)];
        [_backCoverView addGestureRecognizer:tap];
        [self.view.window addSubview:_backCoverView];
    }
    return _backCoverView;
}

-(UIView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WITH, 266)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 66, SCREEN_WITH, 180)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_datePickerView addSubview:_datePicker];
        //        [_datePicker setValue:RGBColor(113, 163, 245) forKey:@"textColor"];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 56)];
        label.centerX = SCREEN_WITH/2;
        label.font = [UIFont fontWithName:FontSFUITextMedium size:17];
        label.textColor = RGBColor(85, 85, 85);
        label.text = @"Select Date";
        label.textAlignment = NSTextAlignmentCenter;
        [_datePickerView addSubview:label];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WITH - 52, 19, 37, 19)];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [btn setTitleColor: RGBColor(113, 163, 245) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FontSFUITextRegular size:16];
        [btn addTarget: self action:@selector(selectDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:btn];
        
        [self.view.window addSubview:_datePickerView];
    }
    return _datePickerView;
}



#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPoint];
    [self getClientArray];

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontSFUITextMedium size:17],NSForegroundColorAttributeName:RGBColor(85, 85, 85)}];
    [self.navigationController.navigationBar setColor: [UIColor whiteColor]];
    self.title = @"DashBoard";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    CGFloat instance = (SCREEN_WITH - 30) / 3;
    left1.constant = 12 + 15;
    left2.constant = instance + 12 + 15;
    left3.constant = 2 * instance + 12 + 15;
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(left2.constant - 12, overTimeLbl.y, 1, overTimeLbl.height)];
    line1.backgroundColor = [UIColor whiteColor];
    [totalBackView addSubview:line1];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(left3.constant - 12, overTimeLbl.y, 1, overTimeLbl.height)];
    line2.backgroundColor = [UIColor whiteColor];
    [totalBackView addSubview:line2];
    

//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Dashboard"];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getClientArray];
    [self cancelSelectedCellDeleteState];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:ALREADY_LAUNCH])
    {
        self.tipImageView.hidden = YES;
    }
    else
    {
        self.tipImageView.hidden = NO;
        [self performSelector:@selector(hideTipImageView) withObject:nil afterDelay:5];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:ALREADY_LAUNCH];
        [userDefault synchronize];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isWidgetPrsent == YES && ![appDelegate.appSetting.isPasscodeOn boolValue])
    {
        [appDelegate enterWidgetDo];
        appDelegate.isWidgetPrsent = NO;
    }
    appDelegate.isWidgetFirst = NO;
    
}

#pragma mark action
-(void)initPoint
{
    _clientArray = [[NSMutableArray alloc]init];
    [_lite_Btn setImage:[UIImage imageNamed:[NSString customImageName:@"ads320_50"]] forState:UIControlStateNormal];

//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onMyTimer) userInfo:nil repeats:YES];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isPurchased == NO)
    {
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-64-self.lite_Btn.frame.size.height;
        self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
        
        if (appDelegate.lite_adv == YES)
        {
            [self.lite_Btn setHidden:NO];
        }
        else
        {
            [self.lite_Btn setHidden:YES];
        }
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }

}

-(void)getClientArray
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSArray *objects = [appDelegate getDashBoardClient];
    
    [_clientArray setArray:objects];
    if ([_clientArray count]>0)
    {
        _noClockImageView.hidden = YES;
    }
    else
        _noClockImageView.hidden = NO;
    
    //广告条
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == NO)
    {
        NSArray *requests2 = [appDelegate getAllLog];
        
        if ([requests2 count] > 0)
        {
            [self.lite_Btn setHidden:NO];
            appDelegate.lite_adv = YES;
            
            NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
            [defaults2 setInteger:1 forKey:NEED_SHOW_LITE_ADV_FLAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (appDelegate.isPurchased == NO)
    {
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-64-self.lite_Btn.frame.size.height;
        self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
        
        if (appDelegate.lite_adv == YES)
        {
            [self.lite_Btn setHidden:NO];
        }
        else
        {
            [self.lite_Btn setHidden:YES];
        }
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    [_myTableView reloadData];
    
    //head
    NSMutableArray *dataArray = [appDelegate.nomalClass  getAllOverTimeandMondy];
    overTimeLbl.text = [NSString stringWithFormat:@"%d h",[[dataArray firstObject]intValue]];
    totalLbl.text = [NSString stringWithFormat:@"%d h",[[dataArray objectAtIndex:1] intValue]];
    
    double amount = [[dataArray lastObject]doubleValue];
    tarendLbl.text = [NSString stringWithFormat:@"%@ %.2f",appDelegate.currencyStr,amount];
    
    
    NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
    NSMutableArray* openMuArr = [NSMutableArray array];
    NSMutableArray* paidMuArr = [NSMutableArray array];
    float openAmount = 0;
    float paidAmount = 0;
    
    for (Invoice* invo in requests) {
        if ([invo.balanceDue doubleValue] > 0) {
            [openMuArr addObject:invo];
            openAmount += [invo.balanceDue doubleValue];
        }else{
            [paidMuArr addObject:invo];
            paidAmount += [invo.paidDue doubleValue];
        }
    }
    
    self.unpaidNumLbl.text = [NSString stringWithFormat:@"%lu Unpaid",(unsigned long)openMuArr.count];
    self.paidNumCell.text = [NSString stringWithFormat:@"%lu Paid",(unsigned long)paidMuArr.count];

    self.unpaidAmountCell.text = [NSString stringWithFormat:@"%.2f",openAmount];
    self.paidAmountLbl.text = [NSString stringWithFormat:@"%.2f",paidAmount];
    
    self.unpaidRecurringLbl.text = self.paidRecurringLbl.text = appDelegate.currencyStr;
}

-(void)onMyTimer
{
    [self getClientArray];
}

-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)deleteBtnPressed:(UIButton *)sender
{
    [Flurry logEvent:@"1_CLI_DEL"];
    self.deleteClient = [_clientArray objectAtIndex:self.swipCellIndex.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Delete this client will also delete all the logs and invoices associated with it!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alertView.tag = 2;
    [alertView show];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = alertView;
}

-(void)pop_system_UnlockLite
{
    float higt;
    higt = [[UIScreen mainScreen] bounds].size.height-44-20;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];
    
    
    //    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    //    [appDelegate removeUnLock_Notificat:self];
}

-(void)hideTipImageView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.tipImageView.hidden = YES;
    [UIView commitAnimations];
    

}

-(void)tapClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.backCoverView.alpha = 0;
        self.datePickerView.y = SCREEN_HEIGHT;
        
    }completion:^(BOOL finished) {
        self.backCoverView.hidden = YES;
        
    }];
}

-(void)showDatePicker{
    self.backCoverView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.backCoverView.alpha = 0.5;
        self.datePickerView.y = SCREEN_HEIGHT - 266;
    }];
    
}

- (void)selectDateBtnClick{
    
    if (!_currentCell || !_currentIndexPath) {
        return;
    }
    
    Clients * client = _currentCell.clients;
    if (client.beginTime != nil) {
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        NSError *error = nil;

        if (_selectClientOperat == ClockOutAt) {
            client.endTime = self.datePicker.date;
            Logs * addLog = nil;
            if ( client != nil && client.clientName != nil && [client.endTime compare:client.beginTime] == NSOrderedDescending){
                NSTimeInterval timeInterval = [client.endTime timeIntervalSinceDate:client.beginTime];
                int totalSeconds = (int)timeInterval;
                
                if (totalSeconds >= 1)
                {
                    addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:appDelegate.managedObjectContext];
                    addLog.finalmoney = @"0:00";
                    addLog.client = client;
                    addLog.starttime = client.beginTime;
                    addLog.endtime = client.endTime;
                    addLog.ratePerHour = [appDelegate getRateByClient:client date:client.beginTime];
                    
                    NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                    addLog.totalmoney = [backArray objectAtIndex:0];
                    addLog.worked = [backArray objectAtIndex:1];
                    
                    addLog.notes = @"";
                    addLog.isInvoice = [NSNumber numberWithBool:NO];
                    addLog.isPaid = [NSNumber numberWithInt:0];
                    
                    addLog.sync_status = [NSNumber numberWithInteger:0];
                    addLog.accessDate = [NSDate date];
                    addLog.uuid = [appDelegate getUuid];
                    addLog.client_Uuid = client.uuid;
                }
            }
            
            client.beginTime = nil;
            client.endTime = nil;
            client.accessDate = [NSDate date];
            [appDelegate.managedObjectContext save:&error];
            
            [appDelegate.parseSync updateClientFromLocal:client];
            [appDelegate.parseSync updateLogFromLocal:addLog];
        }
    }
    
    _currentCell.open = NO;
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    [_clientArray removeObject:_currentCell.clients];
    [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    _currentCell = nil;
    _currentIndexPath = nil;
    
    [self tapClick];
}


-(void)clockOutNowClick{
    
    if (!_currentCell || !_currentIndexPath) {
        return;
    }
    
    Clients * client = _currentCell.clients;

    [Flurry logEvent:@"1_CLI_INFOCLOCKOUT"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //还处于暂停状态
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = 0;
    if (client.lunchStart != nil && [client.lunchStart compare:nowDate]== NSOrderedAscending)
    {
        if (client.lunchStart != nil)
        {
            interval = [nowDate timeIntervalSinceDate:client.lunchStart];
        }
        if (interval > 0)
        {
            client.lunchTime = [NSNumber numberWithInt:(interval + [client.lunchTime intValue])];
        }
    }
    //重置
    client.lunchStart = nil;
    client.endTime = [NSDate date];
    client.accessDate = [NSDate date];
    //添加log
    Logs *addLog = nil;
    if ( client != nil && client.clientName != nil && [client.endTime compare:client.beginTime] == NSOrderedDescending)
    {
        NSTimeInterval timeInterval = [client.endTime timeIntervalSinceDate:client.beginTime];
        int tmpTotalSeconds = (int)timeInterval;
        int tmpTotalSecs = tmpTotalSeconds - [client.lunchTime intValue];
        int totalSecs = tmpTotalSecs >0 ?tmpTotalSecs:0;
        
        //总的工作时间需要比休息时间长
        if (totalSecs <= 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Duration time cannot be 0!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = alertView;
            
            return;
        }
        
        if (totalSecs >= 1)
        {
            addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
            
            
            addLog.finalmoney = [appDelegate conevrtTime4:[client.lunchTime intValue]];
            //重置client
            client.lunchTime = nil;
            addLog.client = client;
            addLog.starttime = client.beginTime;
            addLog.endtime = client.endTime;
            addLog.ratePerHour = [appDelegate getRateByClient:client date:client.beginTime];
            
            NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSecs];
            addLog.totalmoney = [backArray objectAtIndex:0];
            addLog.worked = [backArray objectAtIndex:1];
            
            addLog.notes = @"";
            addLog.isInvoice = [NSNumber numberWithBool:NO];
            addLog.isPaid = [NSNumber numberWithInt:0];
            
            addLog.sync_status = [NSNumber numberWithInteger:0];
            addLog.accessDate = [NSDate date];
            addLog.uuid = [appDelegate getUuid];
            addLog.client_Uuid = client.uuid;
        }
    }
    client.beginTime = nil;
    client.endTime = nil;
    client.lunchStart = nil;
    client.lunchTime = 0;
    [context save:nil];
    
    [appDelegate.parseSync updateClientFromLocal:client];
    [appDelegate.parseSync updateLogFromLocal:addLog];
    
    
    _currentCell.open = NO;
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    [_clientArray removeObject:_currentCell.clients];
    [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    _currentCell = nil;
    _currentIndexPath = nil;
}

-(void)undoClockIn{
    if (!_currentCell || !_currentIndexPath) {
        return;
    }
    
    Clients * client = _currentCell.clients;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    client.beginTime = nil;
    client.endTime = nil;
    client.lunchStart = nil;
    client.lunchTime = nil;
    client.accessDate = [NSDate date];
    
    [context save:nil];
    
    //sync
    [appDelegate.parseSync updateClientFromLocal:client];
    
    
}

#pragma mark - other

- (IBAction)clockInClick:(id)sender {
    TimersViewController_iphone* vc = [[TimersViewController_iphone alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)createInvoiceClick:(id)sender {
    EditInvoiceNewViewController *controller =  [[EditInvoiceNewViewController alloc] initWithNibName:@"EditInvoiceNewViewController" bundle:nil];
    
    controller.navi_tittle = @"New Invoice";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - XDDashBoardTableViewCellDelegate

-(void)returnClientOperate:(ClienOperat)clientOperate client:(Clients *)client cell:(UITableViewCell *)currentCell{
    
    _selectClientOperat = clientOperate;
    if (clientOperate == ClockOutAt) {
        
        if (client.endTime != nil) {
            self.datePicker.minimumDate = client.beginTime;
            self.datePicker.date = client.endTime;
        }else{
            
            self.datePicker.minimumDate = client.beginTime;
            self.datePicker.date = [NSDate date];
        }
        
        [self showDatePicker];
    }else if (clientOperate == ClockOutNow){
        [self clockOutNowClick];
    }else if (clientOperate == UndoClockIn){
        NSString *tittleStr = @"Do you want to undo the clock in without saving an entry?";
        UIActionSheet* actionSheet3 =  [[UIActionSheet alloc] initWithTitle:tittleStr delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, Undo Clock In" otherButtonTitles:nil,nil];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        
        actionSheet3.tag = 3;
        actionSheet3.actionSheetStyle = UIBarStyleDefault;
        [actionSheet3 showInView:appDelegate.m_tabBarController.view];
        
    }else if(clientOperate == ViewClientDetail){
        TimerStartViewController *startTimeController = [[TimerStartViewController alloc] initWithNibName:@"TimerStartViewController" bundle:nil];
        
        //        NewClientViewController_iphone *  vc = [[NewClientViewController_iphone alloc]initWithNibName:@"NewClientViewController_iphone" bundle:nil];
        startTimeController.sel_client = client;
        [self.navigationController pushViewController:startTimeController animated:YES];
        
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED{
    if(buttonIndex == 0){
        [self undoClockIn];
        
        _currentCell.open = NO;
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        [_clientArray removeObject:_currentCell.clients];
        [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        _currentCell = nil;
        _currentIndexPath = nil;
    }
    
    
}


#pragma mark tableView delegate
#pragma mark Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return clockHeadView;
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 60)];
    view.backgroundColor = RGBColor(249, 249, 249);
    [view addSubview:invoiceView];
    invoiceView.y = 16;
    invoiceView.width = SCREEN_WITH;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 1)];
        UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WITH-30, 1)];

        view1.backgroundColor = RGBColor(245, 245, 245);
        [view addSubview:view1];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_clientArray.count > 0) {
            return _clientArray.count;
        }else{
            return 1;
        }
    }
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_clientArray.count == 0 && indexPath.section == 0) {
        return 130;
    }
    if (indexPath.section == 0) {
        if (_currentIndexPath == indexPath) {
            if (_currentCell.open) {
                return 247;
            }else{
                return 120;
            }
        }
    }else
        return 86;
    
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_clientArray.count == 0) {
        if (indexPath.section == 0) {
            return self.emptyOnClockCell;
        }
    }
    
    static NSString* cellID = @"cellID";
    XDDashBoardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDDashBoardTableViewCell" owner:self options:nil]lastObject];
    }
    cell.clipsToBounds = YES;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return self.invoiceUnpaidCell;
        }else if(indexPath.row == 1){
            return self.invoicePaidCell;
        }
    }else{
        Clients *oneClient = [_clientArray objectAtIndex:indexPath.row];
        cell.clients = oneClient;
        cell.xxDelegate = self;
    }
    
    return cell;
}
//{
//
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//
//    NSString* identifier = @"identify";
//    DashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell)
//    {
//        cell = [[DashBoardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.amountView creatSubViewsisLeftAlignment:NO];
//        cell.dashboardViewController = self;
//        [cell.deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    cell.cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//
//    Clients *oneClient = [_clientArray objectAtIndex:indexPath.row];
//
//    float totalSeconds = 0;
//    NSString *totalTimeString = @"";
//    NSDate *nowTime = [NSDate date];
//
////    NSLog(@"[NSDate date] == %@",[NSDate date]);
//
//    if ([oneClient.beginTime compare:nowTime] == NSOrderedDescending)
//    {
//        totalTimeString = [appDelegate conevrtTime5:0];
//    }
//    else
//    {
//
//        NSTimeInterval timeInterval = [nowTime timeIntervalSinceDate:oneClient.beginTime];
//        int allSeconds = (int)timeInterval;
//        int breakTime = 0;
//        if (oneClient.lunchStart != nil)
//        {
//            NSTimeInterval tmpBreak = [nowTime timeIntervalSinceDate:oneClient.lunchStart];
//            breakTime = tmpBreak>0?tmpBreak:0;
//        }
//        if ([oneClient.lunchTime intValue]>0)
//        {
//            breakTime += [oneClient.lunchTime intValue];
//        }
//        totalSeconds = (allSeconds - breakTime)>0?(allSeconds - breakTime):0;
//
//        totalTimeString = [appDelegate conevrtTime5:totalSeconds];
//    }
//
//    //多长时间以后算加班
//    double overTime = 0;
//    double dayTax1 = [appDelegate getMultipleNumber:oneClient.dailyOverFirstHour];
//    double dayTax2 = [appDelegate getMultipleNumber:oneClient.dailyOverFirstHour];
//    if (dayTax1<=0 && dayTax2<=0)
//    {
//        overTime = 0;
//    }
//    else if (dayTax1>0 && dayTax2>0)
//    {
//        overTime = dayTax1<dayTax2?dayTax1:dayTax2;
//    }
//    else
//    {
//        overTime = dayTax1>dayTax2?dayTax1:dayTax2;
//    }
//    cell.externalView.totalTime = overTime*3600;
//    cell.externalView.currentTime = totalSeconds;
//    [cell.externalView setNeedsDisplay];
//
//
//    NSMutableAttributedString *totalTimeAttr = [[NSMutableAttributedString alloc]initWithString:totalTimeString];
//    UIFont *hourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
//    UIFont *secsFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:10];
//    NSRange hourRange = NSMakeRange(0, [totalTimeString length]-3);
//    NSRange secsRange = NSMakeRange([totalTimeString length]-3, 3);
//    [totalTimeAttr addAttribute:NSFontAttributeName value:hourFont range:hourRange];
//    [totalTimeAttr addAttribute:NSFontAttributeName value:secsFont range:secsRange];
//    cell.timeLabel.attributedText = totalTimeAttr;
//    if (cell.externalView.totalTime<=0)
//    {
//        cell.timeLabel.textColor = [HMJNomalClass creatBtnBlueColor_17_155_227];
//    }
//    else
//    {
//        if (cell.externalView.totalTime>=cell.externalView.currentTime)
//        {
//            cell.timeLabel.textColor = [HMJNomalClass creatBtnBlueColor_17_155_227];
//        }
//        else
//        {
//            cell.timeLabel.textColor = [HMJNomalClass creatRedColor_244_79_68];
//        }
//    }
//
//
//    cell.nameLabel.text = oneClient.clientName;
//
//    NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:oneClient date:oneClient.beginTime]];
//    cell.perHourLabel.text = [NSString stringWithFormat:@"%@/h",showMoney];
//
//
//    //计算总工作时间正常时间下的报酬
//    NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:oneClient rate:[appDelegate getRateByClient:oneClient date:oneClient.beginTime] totalTime:nil totalTimeInt:totalSeconds];
//    NSString *money = [backArray objectAtIndex:0];
////    double money1 = [[appDelegate appMoneyShowStly:money]doubleValue];
//
//    NSArray *overAllMoneyArray = [appDelegate overTimeMoney_Clients:oneClient totalTime:totalSeconds rate:[appDelegate getRateByClient:oneClient date:oneClient.beginTime]];
//    NSString *overMoney = [overAllMoneyArray objectAtIndex:0];
//
//    double allMoney = [money doubleValue]+[overMoney doubleValue];
//
//    [cell.amountView setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",allMoney] color:[HMJNomalClass creatAmountColor]];
//    [cell.amountView setNeedsDisplay];
//
//
//    if (self.swipCellIndex.row==indexPath.row && self.swipCellIndex != nil) {
//        [cell layoutShowDeleteBtn:YES];
//    }
//    else
//        [cell layoutShowDeleteBtn:NO];
//
//    return cell;
//
//}








//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
//    return style;
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.swipCellIndex != nil) {
//        self.swipCellIndex = nil;
//        [self.myTableView reloadData];
//        return;
//    }
//
//
//    _timerstartVC  = [[TimerStartViewController alloc] initWithNibName:@"TimerStartViewController" bundle:nil];
//    self.timerstartVC.sel_client = [_clientArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:self.timerstartVC animated:YES];
    
    if (indexPath.section == 0) {
        XDDashBoardTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.open = !cell.open;
        if (cell != _currentCell) {
            _currentCell.open = NO;
            
            _currentCell = cell;
            _currentIndexPath = indexPath;
        }
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
//

//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.swipCellIndex!=nil) {
        self.swipCellIndex=nil;
        self.myTableView.scrollEnabled = NO;
        [self.myTableView reloadData];
        self.myTableView.scrollEnabled = YES;
        
    }
}

#pragma mark UIAlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        int row = (int)[_clientArray indexOfObject:self.deleteClient];
        [_clientArray removeObject:self.deleteClient];
        
        
        [self.myTableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
        [self.myTableView endUpdates];
        
        if (indexPath.row == [_clientArray count] && [_clientArray count]!=0)
        {
            NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[_clientArray count]-1 inSection:0];
            NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
            [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [[DataBaseManger getBaseManger] do_deletClient:self.deleteClient withManual:YES];
        
    }
    
    self.swipCellIndex = nil;
    [self.myTableView reloadData];

}

#pragma mark custome cell Action
-(void)cancelSelectedCellDeleteState
{
    if (self.swipCellIndex != nil)
    {
        self.swipCellIndex = nil;
        [self.myTableView reloadData];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
