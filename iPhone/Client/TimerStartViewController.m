//
//  TimerStartViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 5/21/13.
//
//

#import "TimerStartViewController.h"

#import "AppDelegate_iPhone.h"
#import "Logs.h"

#import "CaculateMoney.h"
#import "TimeStartViewCell.h"

#import "EditLogViewController_new.h"
#import "NewClientViewController_iphone.h"
#import "ExportDataViewController.h"
#import "SelectLogsViewController.h"

#import "StartTimeViewController_iPhone.h"
#import "XDTimingTableViewCell.h"

@interface TimerStartViewController()<XDTimingTableViewCellDelegate>
{
    ClienOperat _selectClientOperat;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property(nonatomic, strong)XDTimingTableViewCell * timingCell;


@property(nonatomic, strong)UIView * backCoverView;
@property(nonatomic, strong)UIView * datePickerView;
@property(nonatomic, strong)UIDatePicker * datePicker;

@end

@implementation TimerStartViewController

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

-(XDTimingTableViewCell *)timingCell{
    if (!_timingCell) {
        _timingCell = [[[NSBundle mainBundle]loadNibNamed:@"XDTimingTableViewCell" owner:self options:nil]lastObject];
        _timingCell.xxDelegate = self;
        _timingCell.clients = _sel_client;
    }
    return _timingCell;
}

#pragma mark Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavStyle];
    [self initPoint];
    
    [self.myTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setClientData];
//     [self.myTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    if ([self.myTimer isValid])
//    {
//        [self.myTimer  invalidate];
//    }
}



#pragma mark Custom Action

-(void)selectDateBtnClick{
    if (_selectClientOperat == ClockOutAt) {
        
        Clients * client = _sel_client;
        if (client.beginTime != nil) {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            
            //        if (_selectClientOperat == ClockOutAt) {
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
                //            }
                
                client.beginTime = nil;
                client.endTime = nil;
                client.accessDate = [NSDate date];
                [appDelegate.managedObjectContext save:&error];
                
                [appDelegate.parseSync updateClientFromLocal:client];
                [appDelegate.parseSync updateLogFromLocal:addLog];
            }
        }
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        self.bottomConstant.constant = 60;
        
    }else if(_selectClientOperat == ClockInAt){
        [self saveSelectedDate:self.datePicker.date];
    }
    [self tapClick];

}

-(void)backBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavStyle
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Client Info"];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}
-(void)initPoint
{
    [_startOrEndNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [_phoneBtn addTarget:self action:@selector(phoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_emailBtn addTarget:self action:@selector(emailBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //下稿加功能
//    [_breakTimeBtn addTarget:self action:@selector(breakTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    _clientLogArray = [[NSMutableArray alloc] init];
    self.changelog = nil;
    
    
    _startOrEndNowBtn.layer.cornerRadius = 2;
    _startOrEndNowBtn.layer.masksToBounds = YES;

    _line.height = SCREEN_SCALE;
    
    
//    pointInTimeDateFormatter = [[NSDateFormatter alloc]init];
//    [pointInTimeDateFormatter setDateFormat:@"H:mm aa"];
    pointInTimeDateFormatter = [[NSDateFormatter alloc] init];
    [pointInTimeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    dayDateFormatter = [[NSDateFormatter alloc]init];
    [dayDateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    
    if (IS_IPHONE_6PLUS)
    {
        _phoneBtn.left = _phoneBtn.left + 30;
        _moreBtn.left = _moreBtn.left - 30;
    }
}



/**
    more 按钮事件
 */
-(void)doAction
{
    UIActionSheet *actionSheet;
    
    if (self.sel_client.beginTime != nil)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:self.sel_client.clientName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Entry",@"Add Invoice",@"Export Entries",@"Edit Client",nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:self.sel_client.clientName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Entry",@"Add Invoice",@"Export Entries",@"Edit Client",nil];
    }
    
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    actionSheet.tag = 2;
    actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:appDelegate.m_tabBarController.view];
    
    appDelegate.close_PopView = actionSheet;
    
    
}

-(void)phoneBtnPressed:(UIButton *)sender
{
    NSString *sureString = [NSString stringWithFormat:@"Are you sure to call support %@?",_sel_client.phone];
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:sureString delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Call" otherButtonTitles:nil, nil];
    actionsheet.tag = 100;
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    AppDelegate_Shared *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    appDelegate.close_PopView  = actionsheet;
    return;

}
-(void)emailBtnPressed:(UIButton *)sender
{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setToRecipients:[NSArray arrayWithObject:_sel_client.email]];
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.appMailController = mailController;
            [self presentViewController:mailController animated:YES completion:nil];
            
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

-(void)breakTimeBtnPressed:(UIButton *)sender
{
    //暂停状态重新启动
    if (sender.selected)
    {
        [self moveOnTime];
    }
    //暂停
    else
    {
        [self stopTime];
    }
    sender.selected = !sender.selected;
    
    //暂停计时
//    if (_sel_client.lunchStart != nil)
//    {
//        _sel_client.lunchStart = nil;
//        [self stopTime];
//    }
//    else
//    {
//        [self moveOnTime];
//    }


}

-(void)stopTime
{
    
    _sel_client.lunchStart = [NSDate date];
    _sel_client.accessDate = [NSDate date];
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    [appDelegate.managedObjectContext save:nil];
    [appDelegate.parseSync updateClientFromLocal:_sel_client];
    
    _stateImageViewInternal.image = [UIImage imageNamed:@"pause"];
    [_stateImageViewExternal.layer removeAllAnimations];

}
-(void)moveOnTime
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    NSTimeInterval interval  = 0;
    if (_sel_client.lunchStart!= nil && [_sel_client.lunchStart compare:[NSDate date]]==NSOrderedAscending)
    {
        if (_sel_client.lunchStart != nil)
        {
            interval = [[NSDate date] timeIntervalSinceDate:_sel_client.lunchStart];
        }
        _sel_client.lunchTime =  [NSNumber numberWithInt:(interval+[_sel_client.lunchTime intValue])];
        
    }
    _sel_client.lunchStart = nil;
    _sel_client.accessDate = [NSDate date];
    [appDelegate.managedObjectContext save:nil];
    [appDelegate.parseSync updateClientFromLocal:_sel_client];
    
    _stateImageViewInternal.image = [UIImage imageNamed:@"in_progress"];
    
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.4;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = YES;
    [_stateImageViewExternal.layer addAnimation:animation forKey:nil ];

}

/*
 点击Clock in按钮
 */
-(IBAction)clockNowBtn
{
    if (self.sel_client.beginTime != nil)
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKOUT"];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        self.changelog = nil;
        
        //还处于暂停状态
        NSDate *nowDate = [NSDate date];
        NSTimeInterval interval = 0;
        if (_sel_client.lunchStart != nil && [_sel_client.lunchStart compare:nowDate]== NSOrderedAscending)
        {
            
            if (_sel_client.lunchStart != nil)
            {
                interval = [nowDate timeIntervalSinceDate:_sel_client.lunchStart];
            }
            if (interval > 0)
            {
                _sel_client.lunchTime = [NSNumber numberWithInt:(interval + [_sel_client.lunchTime intValue])];
            }
        }
        //重置
        _sel_client.lunchStart = nil;
        
        self.sel_client.endTime = [NSDate date];
        self.sel_client.accessDate = [NSDate date];
        
        //添加log
        Logs *addLog = nil;
        if ( self.sel_client != nil && self.sel_client.clientName != nil && [self.sel_client.endTime compare:self.sel_client.beginTime] == NSOrderedDescending)
        {
            NSTimeInterval timeInterval = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
            int tmpTotalSeconds = (int)timeInterval;
            int tmpTotalSecs = tmpTotalSeconds - [_sel_client.lunchTime intValue];
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
                
                
                addLog.finalmoney = [appDelegate conevrtTime4:[_sel_client.lunchTime intValue]];
                //重置client
                _sel_client.lunchTime = nil;
                addLog.client = self.sel_client;
                addLog.starttime = self.sel_client.beginTime;
                addLog.endtime = self.sel_client.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSecs];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = self.sel_client.uuid;
                self.changelog = addLog;
            }
            else
            {
                ;
            }
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        self.sel_client.lunchStart = nil;
        self.sel_client.lunchTime = 0;
        [context save:nil];
        
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [appDelegate.parseSync updateLogFromLocal:addLog];
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setClientData];
            });
        });
        
//        [self.myTableView reloadData];
//        [self.myTimer  invalidate];
        
        
    }
    //开始工作 计时
    else
    {
       
        
        [Flurry logEvent:@"1_CLI_INFOCLOCKIN"];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        //设置开始为该client工作的时间
        self.sel_client.beginTime = [NSDate date];
        self.sel_client.accessDate = [NSDate date];
        [context save:nil];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        self.timingCell.clients = self.sel_client;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setClientData];
            });
        });
    }
}

-(IBAction)clockNextBtn
{
    if (self.sel_client.beginTime != nil)
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKOUTAT"];
        
        startTimeViewControllerVC = [[StartTimeViewController_iPhone alloc]init];
        startTimeViewControllerVC.titleLabel.text = @"Clock out at";
        if (self.sel_client.endTime != nil)
        {
            startTimeViewControllerVC.minDate = self.sel_client.beginTime;
            startTimeViewControllerVC.inputDate = self.sel_client.endTime;
        }
        else
        {
            startTimeViewControllerVC.minDate = self.sel_client.beginTime;
            startTimeViewControllerVC.inputDate = [NSDate date];
        }
        startTimeViewControllerVC.maxDate = nil;
        
        startTimeViewControllerVC.delegate =self;
        [self.view addSubview:startTimeViewControllerVC.view];
        
        
        
    }
    else
    {
        [Flurry logEvent:@"1_CLI_INFOCLOCKINAT"];

        
//        startTimeViewControllerVC = [[StartTimeViewController_iPhone alloc]init];
//        startTimeViewControllerVC.titleLabel.text = @"Clock in at";
//        startTimeViewControllerVC.inputDate = [NSDate date];
//        startTimeViewControllerVC.maxDate = nil;
//        startTimeViewControllerVC.minDate = nil;
//        startTimeViewControllerVC.delegate =self;
//
//
//        [self.view addSubview:startTimeViewControllerVC.view];
        _selectClientOperat = ClockInAt;
        self.datePicker.date = [NSDate date];
        [self showDatePicker];
    }
}

-(void)fleshUI
{
    [self setClientData];
    [self.myTableView reloadData];
}

//-(void)setClientData{
//    if (self.sel_client == nil || self.sel_client.clientName == nil)
//    {
//        [self backBtnPressed:nil];
//        return;
//    }
//    NSArray* array = [[_sel_client.logs allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO]]];
//    self.clientLogArray = [NSMutableArray arrayWithArray:array];
//
//}
/**
    设置页面Client信息
 */
-(void)setClientData
{
    [self.clientLogArray removeAllObjects];
    NSMutableArray* array = [NSMutableArray array];
    for (Logs *log in [self.sel_client.logs allObjects]) {
        XDLogModel* model = [[XDLogModel alloc]init];
        model.log = log;
        model.client = self.sel_client;
        
        [array addObject:model];
        
    }
    NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
    [array sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    [self.clientLogArray addObjectsFromArray:array];
    
    
    
    return;
    if (self.sel_client == nil || self.sel_client.clientName == nil)
    {
        [self backBtnPressed:nil];
        return;
    }
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    self.clientNameLbel.text = _sel_client.clientName;
    NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:_sel_client date:_sel_client.beginTime]];
    _perHourLabel.text = [NSString stringWithFormat:@"%@%@/h",appDelegate.currencyStr,showMoney];
    
    NSString * deviceStr = [UIDevice platformString];
    if ([_sel_client.phone length]>0 && [deviceStr containsString:@"iPhone"])
    {
        _phoneBtn.enabled = YES;
    }
    else
        _phoneBtn.enabled = NO;

    
    if ([_sel_client.email length]>0)
    {
        _emailBtn.enabled = YES;
    }else
        _emailBtn.enabled = NO;
    
    //未计时
    if (self.sel_client.beginTime == nil)
    {
        _stateImageViewInternal.image = [UIImage imageNamed:@"in_progress"];
        _stateImageViewExternal.image = [UIImage imageNamed:@"Not_counting"];
        
        [self.startOrEndNowBtn setTitle:@"Clock in now" forState:UIControlStateNormal];
//        [_startOrEndNowBtn setBackgroundColor:[HMJNomalClass creatBtnBlueColor_17_155_227]];
        
        [_stateImageViewExternal.layer removeAllAnimations];
        self.totalTimeLbel.text = [appDelegate conevrtTime5:0];
        
        UIColor *off = [UIColor colorWithRed:17/255.0 green:155/255.0 blue:227/255.0 alpha:1];
        [self.startOrEndNextBtn setTitle:@"Clock in at..." forState:UIControlStateNormal];
//        [self.startOrEndNextBtn setTitleColor:off forState:UIControlStateNormal];
        self.startTimeLbel.text = nil;
        self.startOrEndNextBtn.top =  9;

        self.bottomConstant.constant = 60.f;
    }
    else
    {
        _stateImageViewExternal.image = [UIImage imageNamed:@"round"];
        
        [self.startOrEndNowBtn setTitle:@"CLOCK OUT" forState:UIControlStateNormal];
//        [_startOrEndNowBtn setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:98.0/255.0 blue:88.0/255.0 alpha:1]];
        
        UIColor *on = [UIColor colorWithRed:239.0/255.0 green:98.0/255.0 blue:88.0/255.0 alpha:1];
        [self.startOrEndNextBtn setTitle:@"Clock out at..." forState:UIControlStateNormal];
//        [self.startOrEndNextBtn setTitleColor:on forState:UIControlStateNormal];
        self.startTimeLbel.text = [NSString stringWithFormat:@"since %@",[pointInTimeDateFormatter stringFromDate:self.sel_client.beginTime]];
        self.startOrEndNextBtn.top =  15;

        self.bottomConstant.constant = 0.01f;

        //下稿加功能
//        _breakTimeBtn.hidden = NO;
        
        
        //暂停状态
        if(_sel_client.lunchStart != nil)
        {
            _stateImageViewInternal.image = [UIImage imageNamed:@"pause"];
            

            [_stateImageViewExternal.layer removeAllAnimations];
        }
        else
        {
            
            _stateImageViewInternal.image = [UIImage imageNamed:@"in_progress"];
            
            
            if([self.stateImageViewExternal.layer  animationForKey:@"image_animation"] == nil)
            {
                CABasicAnimation *animation = [ CABasicAnimation
                                               animationWithKeyPath: @"transform" ];
                
                animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
                //围绕Z轴旋转，垂直与屏幕
                animation.toValue = [ NSValue valueWithCATransform3D:
                                     CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0) ];
                animation.duration = 0.3;
                //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
                animation.cumulative = YES;
                animation.repeatCount = HUGE_VALF;
                animation.removedOnCompletion = YES;
                [_stateImageViewExternal.layer addAnimation:animation forKey:@"image_animation" ];
            }
        }

        
        //还没有开始计时
        if ([self.sel_client.beginTime compare:[NSDate date]] == NSOrderedDescending)
        {
            self.totalTimeLbel.text = [appDelegate conevrtTime5:0];
        }
        else
        {
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.sel_client.beginTime];
            int totalSeconds = (int)timeInterval;
            
            NSTimeInterval relaxTime1 = [_sel_client.lunchTime intValue];
            NSTimeInterval relaxTime2 = 0;
            if (_sel_client.lunchStart != nil)
            {
                relaxTime2 = [[NSDate date] timeIntervalSinceDate:_sel_client.lunchStart];
            }
            
            totalSeconds = (totalSeconds - relaxTime1 - relaxTime2)>0?(totalSeconds - relaxTime1 - relaxTime2):0;
            
            self.totalTimeLbel.text = [appDelegate conevrtTime5:totalSeconds];

        }

//        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onMyTimer) userInfo:nil repeats:YES];
    }
    
    
    if (self.changelog != nil && self.changelog.client == self.sel_client)
    {
        [self.clientLogArray insertObject:self.changelog atIndex:0];
        NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
        [self.clientLogArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
        
        int row = (int)[self.clientLogArray indexOfObject:self.changelog];
        [self.myTableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.myTableView insertRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];
        [self.myTableView endUpdates];
        if (indexPath.row == [self.clientLogArray count]-1 && [self.clientLogArray count] > 1)
        {
            NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.clientLogArray count]-2 inSection:0];
            NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
            [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
        }
        
        self.changelog = nil;
    }
    else
    {
        [self.clientLogArray removeAllObjects];
        [self.clientLogArray addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.sel_client.logs allObjects]]];
        NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
        [self.clientLogArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    }
    [self.myTableView reloadData];

}

-(void)onMyTimer
{
    //刷新时间
//    [self.myTimer  invalidate];
    [self setClientData];
}

/**
    获取今天之内所有的工资
 */
/*
-(void)doTodayTimeAndMoney
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //获取今天开始的第一秒时间，与今天结束的最后一秒
    NSDate *start;
    NSDate *end;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&start interval:NULL forDate:[NSDate date]];
    end = [NSDate dateWithTimeInterval:24*3600 sinceDate:start];
    
    NSArray *logsArray = [appDelegate getOverTime_Log:self.sel_client startTime:start endTime:end isAscendingOrder:NO];
    int all_time = 0;
    float all_money = 0.0;
    for (Logs *sel_log in logsArray)
    {
        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
        NSString *str1 = [array objectAtIndex:0];
        NSString *str2 = [array objectAtIndex:1];
        int firstRow = [str1 intValue];
        int secondRow = [str2 intValue];
        all_time = all_time + firstRow*3600+secondRow*60;
        all_money = all_money + [sel_log.totalmoney douleValue];
    }
    
    self.todayTime.text = [appDelegate conevrtTime2:all_time];
    self.todayMoney.text = [appDelegate appMoneyShowStly3:all_money];
    
    //加班工资 以及加班时间 
    NSArray *backArray = [appDelegate overTimeMoney_logs:logsArray];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    self.overMoneyLbel.text = [NSString stringWithFormat:@"OT  %@",[appDelegate appMoneyShowStly3:[back_money douleValue]]];
    long seconds = (long)([back_time doubleValue]*3600);
    self.overTimeLbel.text = [NSString stringWithFormat:@"OT  %01ldh %02ldm",seconds/3600,(seconds/60)%60];
    
}
*/


#pragma mark getNewLogDelegate
-(void)saveNewLog:(Logs *)sel_log
{
    self.changelog = sel_log;
}

#pragma mark ActionSheet
/**
 ActionSheet 事件
 */
-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    if (actionSheet.tag == 2)
    {
        int flag = 0;   // 1:clock in at;  11:clock out at;  2:undo clock in;  3:add log;  4:edit client;  5:export jobs;
        //当该client已经开始计时的话，就从这里走
        if (self.sel_client.beginTime != nil)
        {
            if (buttonIndex == 0)
            {
                flag = 1;
            }
            else if (buttonIndex == 1)
            {
                flag = 2;
            }
            else if (buttonIndex == 2)
            {
                flag = 3;
            }
            else if (buttonIndex == 3)
            {
                flag = 4;
            }
            else if (buttonIndex == 4)
            {
                flag = 5;
            }
        }
        //该client还没开始计时，重新打开一个log
        else
        {
            //顺序为0:Add Entry（Add log） 1:Add Invoice 2:Export Entries 3:Edit Client
            if (buttonIndex == 0)
            {
                flag = 1;
            }
            else if (buttonIndex == 1)
            {
                flag = 2;
            }
            else if (buttonIndex == 2)
            {
                flag = 3;
            }
            else if (buttonIndex == 3)
            {
                flag = 4;
            }
        }
        
        
//        if (flag == 1)
//        {
//            UIActionSheet *actionSheet3;
//
//            NSString *tittleStr = @"Do you want to undo the clock in without saving an entry?";
//            actionSheet3 =  [[UIActionSheet alloc] initWithTitle:tittleStr delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, Undo Clock In" otherButtonTitles:nil,nil];
//
//            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
//
//            actionSheet3.tag = 3;
//            actionSheet3.actionSheetStyle = UIBarStyleDefault;
//            [actionSheet3 showInView:appDelegate.m_tabBarController.view];
//
//            appDelegate.close_PopView = actionSheet;
//
//        }
        //新建logViewController
        if (flag == 1)
        {
            [Flurry logEvent:@"1_CLI_INFOMORADDE"];
            
            AddLogViewController *controller =  [[AddLogViewController alloc] initWithNibName:@"AddLogViewController" bundle:nil];
            
            controller.myclient = self.sel_client;
            controller.delegate = self;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
            appDelegate.m_widgetController = self;
            
        }
        //添加Invoice
        else if (flag == 2)
        {
            [Flurry logEvent:@"1_CLI_INFOMORADDI"];
            
            [self addInvoice];
        }
        else if (flag == 3)
        {
            [Flurry logEvent:@"1_CLI_INFOMOREXPE"];
            
            ExportDataViewController *exportDataController = [[ExportDataViewController alloc] initWithNibName:@"ExportDataViewController" bundle:nil];
            
            exportDataController.isSetting = 1;
            exportDataController.sel_client = self.sel_client;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:exportDataController];
            [self presentViewController:nav animated:YES completion:nil];
            appDelegate.m_widgetController = self;
            
        }
        else if (flag == 4)
        {
            [Flurry logEvent:@"1_CLI_INFOMOREDITC"];
            
            NewClientViewController_iphone *editClientView = [[NewClientViewController_iphone alloc] initWithNibName:@"NewClientViewController_iphone" bundle:nil];
            
            editClientView.navi_tittle = @"Edit Client";
            editClientView.myclient = self.sel_client;
            //            editClientView.delegate = nil;
            
            [self.navigationController pushViewController:editClientView animated:YES];
            
        }
        
    }
    else if (actionSheet.tag == 3)
    {
        if (buttonIndex == 0)
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            
            self.changelog = nil;
            self.sel_client.beginTime = nil;
            self.sel_client.endTime = nil;
            self.sel_client.lunchStart = nil;
            self.sel_client.lunchTime = nil;
            self.sel_client.accessDate = [NSDate date];
            
            [context save:nil];
            
            //sync
            [appDelegate.parseSync updateClientFromLocal:self.sel_client];
            [self setClientData];
//            [self.myTimer  invalidate];
        }
    }
}

/**
    添加Invoice
 */
-(void)addInvoice
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isPurchased == NO)
    {
        //获取到的Invoice数组
        NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
        if ([requests count]>1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of invoices allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
            alertView.tag = 1;
            [alertView show];
            
            appDelegate.close_PopView = alertView;
            
            return;
        }
    }

    
    SelectLogsViewController *selectLogsView = [[SelectLogsViewController alloc] initWithNibName:@"SelectLogsViewController" bundle:nil];
    
    selectLogsView.delegate = nil;
    selectLogsView.isLogFirst = YES;
    selectLogsView.selectClient = self.sel_client;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectLogsView];
    [self presentViewController:nav animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}

#pragma mark getStartTimeDate
-(void)saveStartTimeDate:(NSDate *)_startDate
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    if (self.sel_client.beginTime != nil)
    {
        self.sel_client.endTime = _startDate;
        
        self.changelog = nil;
        
        Logs *addLog = nil;
        if ( self.sel_client != nil && self.sel_client.clientName != nil && [self.sel_client.endTime compare:self.sel_client.beginTime] == NSOrderedDescending)
        {
            NSTimeInterval timeInterval = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
            int totalSeconds = (int)timeInterval;
            
            if (totalSeconds >= 1)
            {
                addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:appDelegate.managedObjectContext];
                
                addLog.finalmoney = @"0:00";
                addLog.client = self.sel_client;
                addLog.starttime = self.sel_client.beginTime;
                addLog.endtime = self.sel_client.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = self.sel_client.uuid;
                self.changelog = addLog;
            }
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        self.sel_client.accessDate = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [appDelegate.parseSync updateLogFromLocal:addLog];

        
        
    }
    else
    {
        self.sel_client.beginTime = _startDate;
        self.sel_client.accessDate = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        
  

    }
    
}

#pragma mark - XDTimingTableViewCellDelegate
-(void)returnTimingOperate:(ClienOperat)clientOperate client:(Clients *)client cell:(UITableViewCell *)currentCell{
    
    self.timingCell.open = NO;
    if (clientOperate == ClockOutAt) {
        _selectClientOperat = ClockOutAt;
        
        if (client.endTime != nil) {
            self.datePicker.minimumDate = client.beginTime;
            self.datePicker.date = client.endTime;
        }else{
            
            self.datePicker.minimumDate = client.beginTime;
            self.datePicker.date = [NSDate date];
        }
        [self showDatePicker];
        
    }else if (clientOperate == ClockOutNow){
        [self clockNowBtn];
        
    }else if(clientOperate == UndoClockIn){
        NSString *tittleStr = @"Do you want to undo the clock in without saving an entry?";
        UIActionSheet* actionSheet3 =  [[UIActionSheet alloc] initWithTitle:tittleStr delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, Undo Clock In" otherButtonTitles:nil,nil];
        
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        
        actionSheet3.tag = 3;
        actionSheet3.actionSheetStyle = UIBarStyleDefault;
        [actionSheet3 showInView:appDelegate.m_tabBarController.view];
        
    }
}

#pragma mark StartTimeViewController_iPhoneDelegate
- (void)cancelSelectedDate
{
    [startTimeViewControllerVC.view removeFromSuperview];
    startTimeViewControllerVC = nil;
}
- (void)saveSelectedDate:(NSDate *)date
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    if (self.sel_client.beginTime != nil)
    {
        self.sel_client.endTime = date;
        
        self.changelog = nil;
        
        Logs *addLog = nil;
        if ( self.sel_client != nil && self.sel_client.clientName != nil && [self.sel_client.endTime compare:self.sel_client.beginTime] == NSOrderedDescending)
        {
            NSTimeInterval timeInterval = [self.sel_client.endTime timeIntervalSinceDate:self.sel_client.beginTime];
            int totalSeconds = (int)timeInterval;
            
            if (totalSeconds >= 1)
            {
                addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:appDelegate.managedObjectContext];
                
                addLog.finalmoney = @"0:00";
                addLog.client = self.sel_client;
                addLog.starttime = self.sel_client.beginTime;
                addLog.endtime = self.sel_client.endTime;
                addLog.ratePerHour = [appDelegate getRateByClient:self.sel_client date:self.sel_client.beginTime];
                
                NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.sel_client rate:addLog.ratePerHour totalTime:nil totalTimeInt:totalSeconds];
                addLog.totalmoney = [backArray objectAtIndex:0];
                addLog.worked = [backArray objectAtIndex:1];
                
                addLog.notes = @"";
                addLog.isInvoice = [NSNumber numberWithBool:NO];
                addLog.isPaid = [NSNumber numberWithInt:0];
                
                addLog.sync_status = [NSNumber numberWithInteger:0];
                addLog.accessDate = [NSDate date];
                addLog.uuid = [appDelegate getUuid];
                addLog.client_Uuid = self.sel_client.uuid;
                self.changelog = addLog;
            }
        }
        self.sel_client.beginTime = nil;
        self.sel_client.endTime = nil;
        self.sel_client.accessDate = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
        [appDelegate.parseSync updateLogFromLocal:addLog];
        
        [self setClientData];
//        [self.myTimer  invalidate];
        
    }
    else
    {
        self.sel_client.beginTime = date;
        self.sel_client.accessDate = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        [appDelegate.parseSync updateClientFromLocal:self.sel_client];
//        [self setClientData];
        self.timingCell.clients = self.sel_client;
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setClientData];
            });
        });
    }
    
    [startTimeViewControllerVC.view removeFromSuperview];
    startTimeViewControllerVC = nil;

}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_sel_client.beginTime == nil) {
            return 0.01;
        }else{
            if (self.timingCell.open) {
                return 223;
            }else{
                return 93.5;
            }
        }
    }
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.clientLogArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* identifier = @"identifier";
    TimeStartViewCell *cell = (TimeStartViewCell*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[TimeStartViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];

     }
    
    if (indexPath.row == 0) {
        return self.timingCell;
    }else{
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
//        Logs *sel_log = [self.clientLogArray objectAtIndex:indexPath.row-1];

        XDLogModel* model  = [self.clientLogArray objectAtIndex:indexPath.row-1];
        Logs *sel_log = model.log;
        
        if ([sel_log.isPaid intValue] == 1)
        {
            [cell.clockImageV setHidden:NO];
        }
        else
        {
            [cell.clockImageV setHidden:YES];
        }
        
        NSArray *backArray = [appDelegate overTimeMoney_logs:[NSArray arrayWithObject:sel_log]];
        NSNumber *back_time = [backArray objectAtIndex:1];
        long seconds = (long)([back_time doubleValue]*3600);
        NSString *overString = @"";
        NSNumber *overMoney = 0;
        if (seconds/3600 == 0 && (seconds/60)%60 == 0)
        {
            ;
        }
        else
        {
            overMoney = [backArray objectAtIndex:0];

            overString = [NSString stringWithFormat:@" (%01ldh %02ldm)",seconds/3600,(seconds/60)%60];
        }
        if([overString length]>0)
        {
            NSString *duationString = [appDelegate conevrtTime:sel_log.worked];
            NSString *totalString = [NSString stringWithFormat:@"%@%@",duationString,overString];
            NSMutableAttributedString *totalStringAttr = [[NSMutableAttributedString alloc]initWithString:totalString];
            NSRange duationRange = NSMakeRange(0, [duationString length]);
            NSRange overRange = NSMakeRange(duationRange.length, [overString length]);
            UIFont *duationFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
            UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
            UIColor *duationColor = [HMJNomalClass creatBlackColor_20_20_20];
            UIColor *overColor = [HMJNomalClass creatRedColor_244_79_68];
            [totalStringAttr addAttribute:NSFontAttributeName value:duationFont range:duationRange];
            [totalStringAttr addAttribute:NSFontAttributeName value:overFont range:overRange];
            [totalStringAttr addAttribute:NSForegroundColorAttributeName value:duationColor range:duationRange];
            [totalStringAttr addAttribute:NSForegroundColorAttributeName value:overColor range:overRange];
            cell.totalTimeLabel.text = nil;
            cell.totalTimeLabel.attributedText = totalStringAttr;
        }
        else
        cell.totalTimeLabel.text = [appDelegate conevrtTime:sel_log.worked];
        cell.pointInTimeLabel.text = [NSString stringWithFormat:@"Started: %@,",[[pointInTimeDateFormatter stringFromDate:sel_log.starttime] lowercaseString]];;
        cell.dateLabel.text = [dayDateFormatter stringFromDate:sel_log.starttime];
//        double totalMoney = [sel_log.totalmoney doubleValue] + [overMoney doubleValue];
        double totalMoney = model.totalAmount;
        [cell.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalMoney] color:[HMJNomalClass creatAmountColor]];
        [cell.amountView setNeedsDisplay];
        
        if (indexPath.row == [self.clientLogArray count]-1)
        {
            cell.bottomLine.left = 0;
        }
        else
        {
            float left = 15;
            if (IS_IPHONE_6PLUS)
            {
                left = 20;
            }
            cell.bottomLine.left = left;
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.timingCell.open = !self.timingCell.open;
        [tableView beginUpdates];
        [tableView endUpdates];
    }else{
        EditLogViewController_new  *editlogView = [[EditLogViewController_new alloc] initWithNibName:@"EditLogViewController_new" bundle:nil];
        
        XDLogModel* logModel = [self.clientLogArray objectAtIndex:indexPath.row-1];
        editlogView.selectLog = logModel.log;
        [self.navigationController  pushViewController:editlogView animated:YES];
    }
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDLogModel *_selectLog = [self.clientLogArray objectAtIndex:indexPath.row-1];
    
    self.delete_indexPath = indexPath;
    
    if ([_selectLog.log.isInvoice boolValue])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This log was invoiced, delete this log will also affect the invoice. Do you want to process?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
        
        alertView.tag = 2;
        [alertView show];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        appDelegate.close_PopView = alertView;
        
    }
    else
    {
        [self deletLog_index:self.delete_indexPath];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


/*
    删除log 及其 关联
 */
-(void)deletLog_index:(NSIndexPath *)indexPath
{
    XDLogModel *_selectLog = [self.clientLogArray objectAtIndex:indexPath.row-1];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    [self.clientLogArray removeObject:_selectLog];
    
    //hmj delete
    _selectLog.log.accessDate = [NSDate date];
    _selectLog.log.sync_status = [NSNumber numberWithInteger:1];
    
    
//    //syncing
//    NSMutableArray *dataMarray = [[NSMutableArray alloc] initWithObjects:_selectLog, nil];
//    if ([_selectLog.isInvoice boolValue] == YES && [[_selectLog.invoice allObjects] count] > 0)
//    {
//        Invoice *sel_invoice = [[_selectLog.invoice allObjects] objectAtIndex:0];
//        [dataMarray insertObject:sel_invoice atIndex:0];
//    }
    
    
    //修改log对应的invoice
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog.log stly:1];

    [context save:nil];
    
    //parse update local
    [appDelegate.parseSync updateLogFromLocal:_selectLog.log];

    
    [self.myTableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.myTableView endUpdates];
    if (indexPath.row == [self.clientLogArray count] && [self.clientLogArray count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.clientLogArray count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        if (buttonIndex==1) {
            return;
        }
        else
        {
            if (_sel_client.phone != nil) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_sel_client.phone]]];
            }
        }
        
        return;
        
    }
    else
    {
        NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
        [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
    }

}

#pragma mark AlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"7_ADS_INV2"];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPurchase_Lite];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self deletLog_index:self.delete_indexPath];
        }
    }
}

#pragma mark Mail Delegate
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;

//    if ([self.myTimer isValid])
//    {
//        [self.myTimer  invalidate];
//    }
    
}
@end

