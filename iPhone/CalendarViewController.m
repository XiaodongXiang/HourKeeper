//
//  CalendarViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"

#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

#import "Logs.h"
#import "AddLogViewController.h"

#import "AppDelegate_iPhone.h"
#import "OverTimeViewController.h"
#import "HMJLabel.h"


#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
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



NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";


@interface CalendarViewController ()
@property (nonatomic, strong, readwrite) NSDate *initialDate;
@property (nonatomic, strong, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end




@implementation CalendarViewController


@synthesize dataSource, delegate, initialDate, selectedDate;
@synthesize titleLbel;
@synthesize m_calView;
@synthesize sel_weekDay;
@synthesize clientTable;
@synthesize clientBtn;
@synthesize clientArray;
@synthesize sel_client;
@synthesize m_overMoneyLbel;
@synthesize m_overTimeLbel;
@synthesize m_totalMoney;
@synthesize m_totalTime;

#pragma mark Lifecycle
- (void)initWithSelectedDate:(NSDate *)date
{
    logic = [[KalLogic alloc] initForDate:date];
    logic.iphoneCalendarView = self;
    
    self.initialDate = date;
    self.selectedDate = date;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sel_weekDay = [NSDate date];
        [self initWithSelectedDate:self.sel_weekDay];
        self.sel_client = nil;
        clientArray = [[NSMutableArray alloc] init];
    }

    return self;
}



- (KalView*)calendarView { return (KalView*)self.m_calView; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
        m_tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate) {
        delegate = aDelegate;
        m_tableView.delegate = delegate;
    }
}

- (void)clearTable
{
    [dataSource removeAllItems];
    [m_tableView reloadData];
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

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
    NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    
    [self initTotal:[dataSource loadItemsFromDate:from toDate:to]];
    
    [m_tableView reloadData];
    [m_tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
    [self clearTable];
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
    [self reloadData];
    
    self.titleLbel.text = [[logic selectedMonthNameAndYear]uppercaseString];
}

- (void)showFollowingMonth
{
    [self clearTable];
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
    [self reloadData];
    
    self.titleLbel.text = [[logic selectedMonthNameAndYear]uppercaseString];
}



// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    
    //标记日历上是否有记录
    NSMutableArray *dates = [markedDates mutableCopy];
    for (int i=0; i<[dates count]; i++)
    {
        Logs *log = [dates objectAtIndex:i];
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:log.starttime]];
    }
    [[self calendarView] markTilesForDates:dates];            //标记特殊有额外消息的日期，在日历上标记
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *strdate1;
    NSString *strdate2;
    Logs *log1;
    Logs *log2;
    NSMutableArray *sel_totalTime = [markedDates mutableCopy];
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
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [_totalTime addObject:[appDelegate conevrtTime2:(int)allseconds]];
    }
    
    [[self calendarView] markTilesForTotalTime:_totalTime];
    
    
    [self didSelectDate:self.calendarView.selectedDate];      //在tableView下显示选中日期的信息
}



// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
    [self reloadData];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}




// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    calendar.frame = CGRectMake(0, 0, 98, 30);
    [calendar setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [calendar setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [calendar addTarget:self action:@selector(scanCalendar) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:calendar];

    
    [appDelegate setNaviGationTittle:self with:80 high:44 tittle:@"Calendar"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    _rightBarView.backgroundColor = [UIColor clearColor];
    [self.clientBtn addTarget:self action:@selector(doselectClient) forControlEvents:UIControlEventTouchUpInside];
    [_calculatorBtn addTarget:self action:@selector(doOverTime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -16;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItems = @[flexible,rightBar];

    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    KalView *kalView = [[KalView alloc] initWithFrame:CGRectMake(0, 33, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-49-33-20) delegate:self logic:logic];
    self.m_calView = kalView;
    m_tableView = kalView.tableView;
    m_tableView.dataSource = dataSource;
    m_tableView.delegate = delegate;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.backgroundColor = [UIColor clearColor];
    
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
    clientSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadData];
    
    self.titleLbel.text = [[logic selectedMonthNameAndYear]uppercaseString];
    
    [self.view insertSubview:self.m_calView atIndex:0];
    
    
    self.clientTable.backgroundColor = [UIColor colorWithRed:66.f/255.f green:74.f/255.f blue:81.f/255.f alpha:1];
    self.clientTable.layer.cornerRadius = 5;
    self.clientTable.layer.masksToBounds = YES;
    _clientViewArrowImage.hidden = YES;
    [self.m_overMoneyLbel creatSubViewsisLeftAlignment:NO];
    [self.m_totalMoney creatSubViewsisLeftAlignment:NO];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    m_tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    
    [self initCalendar];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
   
}




-(void)initCalendar
{
//    [self initClientName];
    
    logic = [logic initForDate:self.sel_weekDay];

    [(KalView *)self.m_calView reflashWeekStly];
    
    NSDate *before_selDate = self.selectedDate;
    
    [(KalView *)self.m_calView redrawEntireMonth];
    [self reloadData];
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:before_selDate]];
    [self didSelectDate:self.calendarView.selectedDate];
    
    [m_tableView flashScrollIndicators];
}







- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
//    self.m_calView;
//    
//    self.clientView;
//    self.clientTable;
//    self.clientLbel;
//    self.clientBtn;
//    self.clientArray;
//    self.m_totalTime;
//    self.m_totalMoney;
//    self.m_overTimeLbel;
//    self.m_overMoneyLbel;
    
}

#pragma mark Action
-(void)filterBtnPressed:(UIButton *)sender
{
    
}

-(void)doOverTime
{
    OverTimeViewController *overTimeView = [[OverTimeViewController alloc] initWithNibName:@"OverTimeViewController" bundle:nil];
    
    [overTimeView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:overTimeView animated:YES];
    
}
-(void)scanCalendar
{
    [self.navigationController popViewControllerAnimated:YES];
    m_tableView.dataSource = nil;
    m_tableView.delegate = nil;
}

-(IBAction)leftBtn
{
    [self showPreviousMonth];
}

-(IBAction)rightBtn
{
    [self showFollowingMonth];
}





-(IBAction)doselectClient
{
    
    float high;
    if (self.clientView.frame.origin.y == 0)
    {
        high = -self.clientView.frame.size.height;
        _clientViewArrowImage.hidden = YES;
    }
    else
    {
        _clientViewArrowImage.hidden = NO;
        [Flurry logEvent:@"2_PPD_CALFIR"];
        
        high = 0;
        [self.clientArray removeAllObjects];
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [self.clientArray addObjectsFromArray:[appDelegate getAllClient]];
        [self.clientTable reloadData];
    }
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.clientView.frame = CGRectMake(self.clientView.frame.origin.x, high, self.clientView.frame.size.width, self.clientView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
     }
     ];
}

-(void)initClientName
{
//    if (self.sel_client == nil || self.sel_client.clientName == nil)
//    {
//        self.sel_client = nil;
//        self.clientLbel.text = @"All Clients";
//    }
//    else
//    {
//        self.clientLbel.text = self.sel_client.clientName;
//    }
//    
//     NSDictionary* attributes1 = [NSDictionary dictionaryWithObjectsAndKeys: self.clientLbel.font, NSFontAttributeName, nil];
//    float witd;
//    float max = [UIScreen mainScreen].bounds.size.width/2-20;
//    
//    witd = ceilf([self.clientLbel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.clientLbel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size.width);
//    
//    if (witd > max)
//    {
//        witd = max;
//    }
//    self.clientLbel.frame = CGRectMake(10, self.clientLbel.frame.origin.y, witd, self.clientLbel.frame.size.height);
//    self.clientBtn.frame = CGRectMake(witd+self.clientLbel.frame.origin.x, self.clientBtn.frame.origin.y, self.clientBtn.frame.size.width, self.clientBtn.frame.size.height);
//    
//    self.titleView.frame = CGRectMake(0, 0, self.clientBtn.frame.origin.x+self.clientBtn.frame.size.width, self.titleView.frame.size.height);
//    self.navigationItem.titleView = nil;
//    self.navigationItem.titleView = self.titleView;
    
}

-(void)initTotal:(NSArray *)logsArray
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSDate *start;
    NSDate *end;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&start interval:NULL forDate:[NSDate date]];
    end = [NSDate dateWithTimeInterval:24*3600 sinceDate:start];
    
    int all_time = 0;
    double all_money = 0.00;
    for (Logs *sel_log in logsArray)
    {
        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
        NSString *str1 = [array objectAtIndex:0];
        NSString *str2 = [array objectAtIndex:1];
        int firstRow = [str1 intValue];
        int secondRow = [str2 intValue];
        all_time = all_time + firstRow*3600+secondRow*60;
        all_money = all_money + [sel_log.totalmoney doubleValue];
    }
    self.m_totalTime.text = [appDelegate conevrtTime2:all_time];
    [self.m_totalMoney setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",all_money] color:[HMJNomalClass creatAmountColor]];
    [self.m_totalMoney setNeedsDisplay];
    
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:logsArray];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    
    [self.m_overMoneyLbel setAmountSize:15 pointSize:12 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[back_money doubleValue]] color:[HMJNomalClass creatAmountColor]];
    [self.m_overMoneyLbel setNeedsDisplay];
    
    long seconds = (long)([back_time doubleValue]*3600);
    self.m_overTimeLbel.text = [NSString stringWithFormat:@"%01ldh %02ldm",seconds/3600,(seconds/60)%60];
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.clientTable)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, self.clientTable.width, SCREEN_SCALE)];
//            line.backgroundColor = [UIColor colorWithRed:95.f/255.f green:102.f/255.f blue:108.f/255.f alpha:1];
//            [cell addSubview:line];
        }
        
        if (indexPath.row == clientSelectedIndexPath.row)
        {
            cell.backgroundColor = [UIColor colorWithRed:67/255.0 green:83/255.0 blue:99/255.0 alpha:1];

            cell.selected = YES;
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
            cell.selected = NO;


        }
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"All Clients";
        }
        else
        {
            Clients *_client = [self.clientArray objectAtIndex:indexPath.row-1];
            NSString *clientStr = _client.clientName;
            cell.textLabel.text = clientStr;
        }
        
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        
        
        UIView *selView = [[UIView alloc] init];
        selView.backgroundColor = [UIColor colorWithRed:67/255.0 green:83/255.0 blue:99/255.0 alpha:1];
        cell.selectedBackgroundView = selView;

        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,cell.height, self.clientTable.width, SCREEN_SCALE)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        [cell addSubview:line];
        
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
    
    clientSelectedIndexPath = indexPath;
    [self reloadData];
    [self doselectClient];
}




@end

