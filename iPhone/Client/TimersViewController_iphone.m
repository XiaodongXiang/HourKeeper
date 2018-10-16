//
//  TimersViewController_iphone.m
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimersViewController_iphone.h"
#import "AppDelegate_iPhone.h"
#import "Invoice.h"
#import "Logs.h"
#import "CaculateMoney.h"
#import "ClientCell.h"
#import "XDDashBoardTableViewCell.h"
#import "XDOffClockTableViewCell.h"
#import <Parse/Parse.h>


@interface TimersViewController_iphone()<XDDashBoardTableViewCellDelegate,XDOffClockTableViewDelegate>
{
    NSMutableArray* _onClockMuArr;
    NSMutableArray* _offClockMuArr;
    
    NSIndexPath* _currentIndexPath;
    XDDashBoardTableViewCell* _currentOnCell;
    XDOffClockTableViewCell* _currentOffCell;
    
    ClienOperat  _selectClientOperat;
    
    NSIndexPath* _deleteIndexPath;
}
@property (strong, nonatomic) IBOutlet UIView *onClockCell;
@property (strong, nonatomic) IBOutlet UIView *offClockCell;


@property(nonatomic, strong)UIView * backCoverView;
@property(nonatomic, strong)UIView * datePickerView;
@property(nonatomic, strong)UIDatePicker * datePicker;

@end ;

@implementation TimersViewController_iphone

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


#pragma mark Init
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
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self.myTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.frame = CGRectMake(0, 0, 50, 44);
//    [addButton setImage:[UIImage imageNamed:@"icon_add3.png"] forState:UIControlStateNormal];
//    [addButton setImage:[UIImage imageNamed:@"icon_add3_sel.png"] forState:UIControlStateHighlighted];
//    [addButton addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    flexible.width = -20;
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:addButton];
//    self.navigationItem.rightBarButtonItems = @[flexible,rightBar];


    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Clients"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    _clientArray = [[NSMutableArray alloc] init];
    
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
    
    [self.lite_Btn setImage:[UIImage imageNamed:[NSString customImageName:@"ads320_50"]] forState:UIControlStateNormal];
    
    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
//            [self.navigationController popViewControllerAnimated:YES];
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClick) image:[UIImage imageNamed:@"Return_icon_normal"]];
//            self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
            
        }
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initTimerAarry];
}

-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    self.dropboxStartViewCtor = nil;
    
//    if (appDelegate.isWidgetPrsent == YES && ![appDelegate.appSetting.isPasscodeOn boolValue])
//    {
//        [appDelegate enterWidgetDo];
//        appDelegate.isWidgetPrsent = NO;
//    }
//    appDelegate.isWidgetFirst = NO;
}





#pragma mark Action
-(void)initTimerAarry
{
    if (_currentOffCell.open) {
        _currentOffCell.open = NO;
    }
    if (_currentOnCell.open) {
        _currentOnCell.open = NO;
    }
    _currentOffCell = nil;
    _currentOnCell = nil;
    _currentIndexPath = nil;
    
    [_clientArray removeAllObjects];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    if (self.clientArray == nil)
    {
        _clientArray = [[NSMutableArray alloc]init];
    }
    
    NSArray* allArr = [NSArray arrayWithArray:[appDelegate getAllClient]];
    
    _offClockMuArr = [NSMutableArray arrayWithArray:[allArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beginTime = nil"]]];
    _onClockMuArr = [NSMutableArray arrayWithArray:[allArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beginTime != nil"]]];
    
    if (_onClockMuArr.count > 0) {
        [_clientArray addObject:_onClockMuArr];
    }
    if (_offClockMuArr.count > 0) {
        [_clientArray addObject:_offClockMuArr];
    }
//    [_clientArray setArray:[appDelegate getAllClient]];
    

    //判断是否需要显示广告
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
    
    [self.myTableView reloadData];

    
    self.animation_CellPath = nil;
//    self.selectClient = nil;
    
    //同步刷新UI
    if (self.dropboxStartViewCtor != nil)
    {
        [self.dropboxStartViewCtor fleshUI];
    }
}

- (IBAction)addClientClick:(id)sender {
    [self doAdd];

}


-(void)doAdd
{
    [Flurry logEvent:@"1_CLI_ADD"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isPurchased == NO)
    {
        NSArray *requests = [appDelegate getAllClient];
        
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        if ([requests count]>1 && [[defaults2 stringForKey:LITE_CLIENT_UNLIMITCONUT] isEqualToString:@"NO"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of clients allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
            alertView.tag = 1;
            [alertView show];
            
            appDelegate.close_PopView = alertView;
            
            return;
        }
    }

    
    NewClientViewController_iphone *controller =  [[NewClientViewController_iphone alloc] initWithNibName:@"NewClientViewController_iphone" bundle:nil];
    
    controller.navi_tittle = @"New Client";
    controller.myclient = nil;
//    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}


//-(void)saveNewClient:(Clients *)sel_client
//{
//    self.selectClient = sel_client;
//}


-(void)fleshUI
{
    [self initTimerAarry];
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


-(void)undoClockIn{
    if (!_currentOnCell || !_currentIndexPath) {
        return;
    }
    
    Clients * client = _currentOnCell.clients;
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

-(void)clockOutNowClick{
    
    if (!_currentOnCell || !_currentIndexPath) {
        return;
    }
    
    Clients * client = _currentOnCell.clients;
    
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
    
    
    _currentOnCell.open = NO;
    
    [_clientArray[_currentIndexPath.section] removeObject:_currentOnCell.clients];
    [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
//
//    if (_offClockMuArr) {
//        [_clientArray[1] addObject:_currentOnCell.clients];
//        [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
//    }else{
//        _offClockMuArr = [NSMutableArray arrayWithObject:_currentOnCell.clients];
//        [_clientArray addObject:_offClockMuArr];
//        [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
//    }
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    _currentOnCell = nil;
    _currentIndexPath = nil;
    _currentOffCell = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTimerAarry];
            [self.myTableView reloadData];
        });
    });
}

- (void)selectDateBtnClick{
    
    if (_selectClientOperat == ClockOutAt) {
        
    
        if (!_currentOnCell || !_currentIndexPath) {
            return;
        }
        
        Clients * client = _currentOnCell.clients;
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
        
        _currentOnCell.open = NO;
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        [_clientArray[_currentIndexPath.section] removeObject:_currentOnCell.clients];
        [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        _currentOnCell = nil;
        _currentIndexPath = nil;
        _currentOffCell = nil;
    }else if (_selectClientOperat == ClockInAt){
        
        if (!_currentOffCell || !_currentIndexPath) {
            return;
        }
        
        Clients * client = _currentOffCell.clients;

        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        NSError *error = nil;
        client.beginTime = self.datePicker.date;
        client.accessDate = [NSDate date];
        [appDelegate.managedObjectContext save:&error];
        [appDelegate.parseSync updateClientFromLocal:client];
        
        _currentOffCell.open = NO;
        
        [_clientArray[_currentIndexPath.section] removeObject:_currentOffCell.clients];
        [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
//        if (_onClockMuArr) {
//            [_clientArray[0] addObject:_currentOffCell.clients];
//            [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
//        }else{
//            _onClockMuArr = [NSMutableArray arrayWithObject:_currentOffCell.clients];
//            [_clientArray insertObject:_onClockMuArr atIndex:0];
//            [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
//        }
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];

        _currentOnCell = nil;
        _currentIndexPath = nil;
        _currentOffCell = nil;
        
    }
    
    [self tapClick];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTimerAarry];
            [self.myTableView reloadData];
        });
    });
}

-(void)clockInNow{
    
    Clients* client = _currentOffCell.clients;
    [Flurry logEvent:@"1_CLI_INFOCLOCKIN"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //设置开始为该client工作的时间
    client.beginTime = [NSDate date];
    client.accessDate = [NSDate date];
    [context save:nil];
    [appDelegate.parseSync updateClientFromLocal:client];
    
    
    _currentOffCell.open = NO;
    
    [_clientArray[_currentIndexPath.section] removeObject:_currentOffCell.clients];
    [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    _currentOnCell = nil;
    _currentIndexPath = nil;
    _currentOffCell = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTimerAarry];
            [self.myTableView reloadData];
        });
    });
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED{
    if(buttonIndex == 0){
        [self undoClockIn];
        
        _currentOnCell.open = NO;
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        [_clientArray[_currentIndexPath.section] removeObject:_currentOnCell.clients];
        [self.myTableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        _currentOnCell = nil;
        _currentIndexPath = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initTimerAarry];
                [self.myTableView reloadData];
            });
        });
    }
    
    
}


#pragma mark Tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _clientArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_clientArray count] == 0)
    {
        [self.tipImagV setHidden:NO];
    }
    else 
    {
        [self.tipImagV setHidden:YES];
        
        return [_clientArray[section] count];
        
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_clientArray.count == 0) {
        return nil;
    }else if(_clientArray.count == 1){
        if (_onClockMuArr.count > 0) {
            return _onClockCell;
        }else{
            return _offClockCell;
        }
    }else if(_clientArray.count == 2){
        if (section == 0) {
            return _onClockCell;
        }else{
            return _offClockCell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndexPath) {
        if (_currentIndexPath == indexPath) {
            if (_currentOnCell) {
                if (_currentOnCell.open == YES) {
                    return 247;
                }else{
                    return 120;
                }
            }
            if (_currentOffCell) {
                if (_currentOffCell.open == YES) {
                    return 183;
                }else{
                    return 65;
                }
            }
        }else{
            if (_clientArray.count == 1) {
                if (_onClockMuArr.count > 0) {
                    return 120;
                }else{
                    return 65;
                }
            }else if (_clientArray.count == 2){
                if (indexPath.section == 0) {
                    return 120;
                }else{
                    return 65;
                }
            }
        }
    }else{
        if (_clientArray.count == 1) {
            if (_onClockMuArr.count > 0) {
                return 120;
            }else{
                return 65;
            }
        }else if (_clientArray.count == 2){
            if (indexPath.section == 0) {
                return 120;
            }else{
                return 65;
            }
        }
    }
	return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_clientArray.count == 1) {
        if (_onClockMuArr.count > 0) {
            static NSString* cellID = @"cellID";
            XDDashBoardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XDDashBoardTableViewCell" owner:self options:nil]lastObject];
            }
            cell.clipsToBounds = YES;
            Clients *oneClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
            cell.clients = oneClient;
            cell.xxDelegate = self;
            return cell;
        }else if (_offClockMuArr.count > 0){
            
            static NSString* cellID = @"offCellID";
            XDOffClockTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XDOffClockTableViewCell" owner:self options:nil]lastObject];
            }
            cell.clipsToBounds = YES;
            Clients *oneClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
            cell.clients = oneClient;
            cell.xxDelegate =self;
            return cell;

        }
    }else if(_clientArray.count == 2){
        if (indexPath.section == 0) {
            static NSString* cellID = @"cellID";
            XDDashBoardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XDDashBoardTableViewCell" owner:self options:nil]lastObject];
            }
            cell.clipsToBounds = YES;
            
            Clients *oneClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
            cell.clients = oneClient;
            cell.xxDelegate = self;
            return cell;

        }else if(indexPath.section == 1){
            static NSString* cellID = @"offCellID";
            XDOffClockTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XDOffClockTableViewCell" owner:self options:nil]lastObject];
            }
            cell.clipsToBounds = YES;
            Clients *oneClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
            cell.clients = oneClient;
            cell.xxDelegate = self;
            return cell;

        }
    }
    
//    NSString* identifier = @"identify";
//    ClientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell)
//    {
//        cell = [[ClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        [cell.amountView creatSubViewsisLeftAlignment:NO];
//    }
//
//    Clients *oneClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
//    cell.nameLabel.text = oneClient.clientName;
//
//    Clients *showclient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];
//
//
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//
//    cell.nameLabel.text = showclient.clientName;
//    NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:showclient date:showclient.beginTime]];
//    [cell.amountView setAmountSize:25 pointSize:20 hourSize:13 Currency:appDelegate.currencyStr Amount:showMoney color:[HMJNomalClass creatAmountColor]];
//    [cell.amountView setNeedsDisplay];
    
    return nil;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_clientArray.count == 1) {
        if (_offClockMuArr.count > 0) {
            XDOffClockTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.open = !cell.open;
            if (indexPath == _currentIndexPath) {
                [tableView beginUpdates];
                [tableView endUpdates];
                return;
            }
            if (_currentOnCell && _currentOnCell.open) {
                _currentOnCell.open = NO;
            }
            if (_currentOffCell && _currentOffCell.open) {
                _currentOffCell.open = NO;
            }
            _currentOnCell = nil;
            _currentOffCell = cell;
            _currentIndexPath = indexPath;
        }else if (_onClockMuArr.count > 0){
            XDDashBoardTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.open = !cell.open;
            if (indexPath == _currentIndexPath) {
                [tableView beginUpdates];
                [tableView endUpdates];
                return;
            }
            if (_currentOnCell && _currentOnCell.open) {
                _currentOnCell.open = NO;
            }
            if (_currentOffCell && _currentOffCell.open) {
                _currentOffCell.open = NO;
            }
            _currentOnCell = cell;
            _currentOffCell = nil;
            _currentIndexPath = indexPath;
        }
    }else if(_clientArray.count == 2){
        
        if (indexPath.section == 0) {
                XDDashBoardTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.open = !cell.open;
                if (indexPath == _currentIndexPath) {
                    [tableView beginUpdates];
                    [tableView endUpdates];
                    return;
                }
                if (_currentOnCell && _currentOnCell.open) {
                    _currentOnCell.open = NO;
                }
                if (_currentOffCell && _currentOffCell.open) {
                    _currentOffCell.open = NO;
                }
                _currentOnCell = cell;
                _currentOffCell = nil;
                _currentIndexPath = indexPath;
        }else{
                XDOffClockTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.open = !cell.open;
                if (indexPath == _currentIndexPath) {
                    [tableView beginUpdates];
                    [tableView endUpdates];
                    return;
                }
                if (_currentOnCell && _currentOnCell.open) {
                    _currentOnCell.open = NO;
                }
                if (_currentOffCell && _currentOffCell.open) {
                    _currentOffCell.open = NO;
                }
                _currentOnCell = nil;
                _currentOffCell = cell;
                _currentIndexPath = indexPath;
        }
        
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
//    self.animation_CellPath = indexPath;
//    Clients *selectClient = [_clientArray objectAtIndex:indexPath.row];
//    TimerStartViewController *startTimeController = [[TimerStartViewController alloc] initWithNibName:@"TimerStartViewController" bundle:nil];
//
//    self.dropboxStartViewCtor = startTimeController;
//    startTimeController.sel_client = selectClient;
//
//    [startTimeController setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:startTimeController animated:YES];
    
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_onClockMuArr.count > 0) {
        if (indexPath.section == 0) {
            return NO;
        }
    }
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [Flurry logEvent:@"1_CLI_DEL"];
    self.deleteClient = [_clientArray[indexPath.section] objectAtIndex:indexPath.row];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Delete this client will also delete all the logs and invoices associated with it!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alertView.tag = 2;
    [alertView show];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = alertView;
    
    _deleteIndexPath = indexPath;
}
#pragma mark - XDDashBoardTableViewCellDelegate
-(void)returnClientOperate:(ClienOperat)clientOperate client:(Clients *)client cell:(UITableViewCell *)currentCell{
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



#pragma mark - XDOffClockTableViewDelegate
-(void)returnOffClockClient:(Clients *)client cell:(UITableViewCell *)cell operate:(ClienOperat)clientOperate{
    if (clientOperate == ClockInAt) {
        _selectClientOperat = ClockInAt;
        self.datePicker.date = [NSDate date];
        self.datePicker.minimumDate = nil;
        self.datePicker.maximumDate = nil;
        
        [self showDatePicker];
    }else if (clientOperate == ClockInNow){
        
        [self clockInNow];
    }else if (clientOperate == ViewClientDetail){
        TimerStartViewController *startTimeController = [[TimerStartViewController alloc] initWithNibName:@"TimerStartViewController" bundle:nil];
        startTimeController.sel_client = client;
        [self.navigationController pushViewController:startTimeController animated:YES];
    }
}
#pragma mark -   UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            int row = (int)[_clientArray[_deleteIndexPath.section] indexOfObject:self.deleteClient];
            [_clientArray[_deleteIndexPath.section] removeObject:self.deleteClient];
            
            
            [self.myTableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:_deleteIndexPath.section];
            NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
            [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
            [self.myTableView endUpdates];
            
            if (indexPath.row == [_clientArray[_deleteIndexPath.section] count] && [_clientArray[_deleteIndexPath.section] count]!=0)
            {
                NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[_clientArray[_deleteIndexPath.section] count]-1 inSection:0];
                NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
                [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
            }

            [[DataBaseManger getBaseManger] do_deletClient:self.deleteClient withManual:YES];
            _deleteIndexPath = nil;
        }
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"7_ADS_CLI2"];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPurchase_Lite];
        }
    }
}





-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)pop_system_UnlockLite
{
    float higt;
    higt = [[UIScreen mainScreen] bounds].size.height-64;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
