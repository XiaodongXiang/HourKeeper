//
//  CalendarViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController_ipad.h"
#import "KalLogic_ipad.h"
#import "KalDataSource_ipad.h"
#import "KalDate_ipad.h"
#import "KalPrivate_ipad.h"

#import "Logs.h"
#import "AppDelegate_iPad.h"

#import "AddLogViewController_ipad.h"
#import "SelectedClientCell.h"



#define PROFILER_IPAD 0
#if PROFILER_IPAD
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>

void mach_absolute_difference_ipad(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}

#endif



NSString *const KalDataSourceChangedNotification_ipad = @"KalDataSourceChangedNotification";











@interface CalendarViewController_ipad ()
@property (nonatomic, strong, readwrite) NSDate *initialDate;
@property (nonatomic, strong, readwrite) NSDate *selectedDate;
- (KalView_ipad*)calendarView;
@end




@implementation CalendarViewController_ipad

@synthesize dataSource, delegate, initialDate, selectedDate;
@synthesize calView;


#pragma mark Init
-(void)ReflashDateStly
{
    [self initClientName];
    
    logic = [logic initForDate:self.sel_weekDate];
    NSDate *before_selDate = self.selectedDate;
    [(KalView_ipad *)self.calView redrawEntireMonth];
    [[self calendarView] selectDate:[KalDate_ipad dateFromNSDate:before_selDate]];
    [self reloadData];
}




- (KalView_ipad*)calendarView { return (KalView_ipad*)self.calView; }

- (void)setDataSource:(id<KalDataSource_ipad>)aDataSource
{
    if (dataSource != aDataSource)
    {
        dataSource = aDataSource;
        m_tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate)
    {
        delegate = aDelegate;
        m_tableView.delegate = delegate;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
}

- (void)reloadData          //选出有记录的日期信息
{
    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self client:self.sel_client];
}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
    [self reloadData];
}




#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate_ipad *)date
{
    self.selectedDate = [date NSDate];
    NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    [self clearTable];
    [dataSource loadItemsFromDate:from toDate:to];
}

- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
    NSString *dateString = [[logic selectedMonthNameAndYear]uppercaseString];
    self.titleLbel.text = dateString;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [dateString sizeWithAttributes:dic];
    //设置左右按钮的位置
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
    
    NSString *dateString = [[logic selectedMonthNameAndYear]uppercaseString];
    self.titleLbel.text = dateString;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [dateString sizeWithAttributes:dic];
    //高清
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
}



// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource_ipad>)theDataSource;
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    
    
    NSMutableArray *dates = [markedDates mutableCopy];
    for (int i=0; i<[dates count]; i++)
    {
        Logs *log = [dates objectAtIndex:i];
        [dates replaceObjectAtIndex:i withObject:[KalDate_ipad dateFromNSDate:log.starttime]];
    }
    [[self calendarView] markTilesForDates:dates];            //标记特殊有额外消息的日期，在日历上标记
    
    
    long timeAll = 0;
    double moneyAll = 0.0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *strdate1; 
    NSString *strdate2;
    Logs *log1;
    Logs *log2;
    NSMutableArray *sel_totalTime = [markedDates mutableCopy];
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:sel_totalTime];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    [self.overMoneyLabel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [self.overMoneyLabel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
    
    NSMutableArray *_totalTime = [[NSMutableArray alloc] init];
    for(int i=0;i<[sel_totalTime count]; i++) 
    {
        double moneySub = 0.0;
        long allseconds = 0;
        log1 = [sel_totalTime objectAtIndex:i];
        strdate1 = [dateFormatter stringFromDate:log1.starttime];      
        NSString *timelength = log1.worked;
        NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
        int hours = [[timeArray objectAtIndex:0] intValue];
        int minutes = [[timeArray objectAtIndex:1] intValue];
        allseconds = allseconds +hours*3600+minutes*60;
        moneySub = [log1.totalmoney doubleValue];
        
        for(int j=i+1;j<[sel_totalTime count];j++)
        {
            log2 = [sel_totalTime objectAtIndex:j];
            strdate2 = [dateFormatter stringFromDate:log2.starttime];
            
            if ([strdate2 isEqualToString:strdate1]) 
            {
                NSString *timelength2 = log2.worked;
                NSArray *timeArray2 = [timelength2 componentsSeparatedByString:@":"];
                int hoursT = [[timeArray2 objectAtIndex:0] intValue];
                int minutesT = [[timeArray2 objectAtIndex:1] intValue];
                allseconds = allseconds +hoursT*3600+minutesT*60;
                moneySub = moneySub + [log2.totalmoney doubleValue];
                [sel_totalTime removeObject:log2];
                j--;
            }
        }
        

        [_totalTime addObject:[appDelegate conevrtTime2:(int)allseconds]];
        
        if ([log1.starttime compare:logic.nowMonthFirstDate] == NSOrderedDescending && [log1.starttime compare:logic.nowMonthLastDate] == NSOrderedAscending) 
        {
            timeAll = timeAll + allseconds;
            moneyAll = moneyAll + moneySub;
        }
    }
    
    [[self calendarView] markTilesForTotalTime:_totalTime]; 
    
    
    self.totalTimeLbel.text = [appDelegate conevrtTime2:(int)timeAll];    
    [self.totalMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",moneyAll] color:[HMJNomalClass creatAmountColor]];
    [self.totalMoneyLbel setNeedsDisplay];
    
    
    
    [self didSelectDate:self.calendarView.selectedDate];      //在tableView下显示选中日期的信息
}



// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER_IPAD
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER_IPAD
    end = mach_absolute_time();
    mach_absolute_difference_ipad(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [[self calendarView] selectDate:[KalDate_ipad dateFromNSDate:date]];
    [self reloadData];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}







// -----------------------------------------------------------------------------------
#pragma mark UIViewController



- (void)initWithSelectedDate:(NSDate *)date
{
    logic = [[KalLogic_ipad alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification_ipad object:nil];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.sel_weekDate = [NSDate date];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _clientArray = [[NSMutableArray alloc] init];
        [self initWithSelectedDate:self.sel_weekDate];
    }
    
    return self;
}



- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.overMoneyLabel creatSubViewsisLeftAlignment:NO];
    self.calendarLine.height = SCREEN_SCALE;
    
    self.selectedClientView.layer.borderWidth = 1;
    UIColor *tmpBlueColor = [UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:227.0/255.0 alpha:1];
    self.selectedClientView.layer.borderColor = tmpBlueColor.CGColor;
    self.selectedClientView.layer.cornerRadius = 4;
    self.selectedClientView.layer.masksToBounds = YES;
    self.selectedClientBtn.titleEdgeInsets =  UIEdgeInsetsMake(0, 9, 0, 0);
    self.selectedClientView.height = self.selectedClientBtn.height;
    
    
    CGRect fram1 = CGRectMake(0, 87.5, 703, 564);
    KalView_ipad *kalView = [[KalView_ipad alloc] initWithFrame:fram1 delegate:self logic:logic];
    self.calView = kalView;
    m_tableView = kalView.tableView;
    m_tableView.dataSource = dataSource;
    m_tableView.delegate = delegate;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [kalView selectDate:[KalDate_ipad dateFromNSDate:self.initialDate]];
    [self reloadData];
    
    NSString *dateString = [[logic selectedMonthNameAndYear]uppercaseString];
    self.titleLbel.text = dateString;
    //设置左右按钮的位置
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [dateString sizeWithAttributes:dic];
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.titleLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
    
    
    
    //插入日历
    [self.view insertSubview:self.calView belowSubview:self.headView];
    
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainView.timersheetView ReflashRangeDateList];
    
    [self initClientName];
    
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    
    
    self.clientTable.backgroundColor = [UIColor whiteColor];
    
    self.bottomView.width = self.view.width - SCREEN_SCALE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    m_tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification_ipad object:nil];
    
   
    
}




-(IBAction)doShowStly:(UISegmentedControl *)sender
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    for (UIView *view in appDelegate.mainView.kindsofView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (sender.selectedSegmentIndex == 1)
    {
        [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.timersheetView.view];
        appDelegate.mainView.timersheetView.dateSty = 1;
    }
    else if (sender.selectedSegmentIndex == 2)
    {
        [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.timersheetView.payPeriodView.view];
        appDelegate.mainView.timersheetView.dateSty = 2;
    }
    
    [sender setSelectedSegmentIndex:0];
}


-(IBAction)leftBtn
{
    [self showPreviousMonth];
}


-(IBAction)rightBtn
{
    [self showFollowingMonth];
}



/**
    selectedClientBtn点击事件
 */
-(IBAction)doselectClient
{
    if(self.selectedClientView.height > self.selectedClientBtn.height)
    {
        [self hideSelectedClientViewAnimation:YES];
    }
    else
    {
        [Flurry logEvent:@"2_PPD_CALFIR"];
        
        [self.clientArray removeAllObjects];
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [self.clientArray addObjectsFromArray:[appDelegate getAllClient]];
        [self.clientTable reloadData];

        
        [self showSelectedClientViewAnimation:YES];
        
        
    }
}

-(void)showSelectedClientViewAnimation:(BOOL)isAnimation
{
    int clientNum = (([self.clientArray count]+1)>6)?6:((int)[self.clientArray count]+1);
    if (isAnimation)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.selectedClientView.height = self.selectedClientBtn.height + 30*clientNum;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12_sel"];
        [UIView commitAnimations];
    }
    else
    {
        self.selectedClientView.height = self.selectedClientBtn.height + 30*clientNum;

        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12_sel"];
    }
  

    NSLog(@"行:%d",clientNum);
    NSLog(@"view height:%f",self.selectedClientView.height);
    NSLog(@"tableview y:%f height:%f",self.clientTable.top,self.clientTable.height);
}

-(void)hideSelectedClientViewAnimation:(BOOL)isAnimation
{
    if (isAnimation)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.selectedClientView.height = self.selectedClientBtn.height;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12"];
        [UIView commitAnimations];

    }
    else
    {
        self.selectedClientView.height = self.selectedClientBtn.height;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12"];
    }
}

-(void)initClientName
{
    if (self.sel_client == nil || self.sel_client.clientName == nil)
    {
        self.sel_client = nil;
        [self.selectedClientBtn setTitle:@"All Clients" forState:UIControlStateNormal];
    }
    else
    {
        [self.selectedClientBtn setTitle:self.sel_client.clientName forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.clientArray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.clientTable)
    {
        static NSString *CellIdentifier = @"Cell";
        
        SelectedClientCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[SelectedClientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.selectedBackgroundView = [[UIView alloc]init];
        }
        
        
        if (indexPath.row == 0)
        {
            cell.nameLabel.text = @"All Clients";
            if([self.selectedClientBtn.currentTitle isEqualToString:@"All Clients"])
                cell.nameLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
            else
                cell.nameLabel.textColor = [UIColor colorWithRed:41.0/255.f green:131.0/255.0 blue:227.0/255.0 alpha:1];

        }
        else
        {
            Clients *_client = [self.clientArray objectAtIndex:indexPath.row-1];
            NSString *clientStr = _client.clientName;
            cell.nameLabel.text = clientStr;
            
            if ([_client isEqual:self.sel_client])
            {
                cell.nameLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
                
            }
            else
                cell.nameLabel.textColor = [UIColor colorWithRed:41.0/255.f green:131.0/255.0 blue:227.0/255.0 alpha:1];
        }
        
        //        if ([cell.nameLabel.text isEqualToString:self.selectedClientBtn.currentTitle])
//        {
//            cell.nameLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
//        }
//        else
//            cell.nameLabel.textColor = [UIColor colorWithRed:41.0/255.f green:131.0/255.0 blue:227.0/255.0 alpha:1];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else
    {
        return nil;
    }
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.sel_client = nil;
    }
    else
    {
        self.sel_client = [self.clientArray objectAtIndex:indexPath.row-1];
    }
    
    [self reloadData];
    [self initClientName];
    [self doselectClient];
}



@end

