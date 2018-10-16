/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

#import "Logs.h"



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

@interface KalViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation KalViewController

@synthesize dataSource, delegate, initialDate, selectedDate;

- (id)initWithSelectedDate:(NSDate *)date
{
  if ((self = [super init])) {
    logic = [[KalLogic alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
  }
  return self;
}

- (id)init
{
  return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
  if (dataSource != aDataSource) {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate) {
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void)reloadData          //选出有记录的日期信息
{
  [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
  self.selectedDate = [date NSDate];
  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self reloadData];
}

- (void)showFollowingMonth
{
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
  NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    
    
  NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
  for (int i=0; i<[dates count]; i++)
  {
      Logs *log = [dates objectAtIndex:i];
      [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:log.starttime]];
  }
  [[self calendarView] markTilesForDates:dates];            //标记特殊有额外消息的日期，在日历上标记
  
    
  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  NSString *strdate1; 
  NSString *strdate2;
  Logs *log1;
  Logs *log2;
  NSMutableArray *sel_totalTime = [[markedDates mutableCopy] autorelease];
  NSMutableArray *_totalTime = [[NSMutableArray alloc] init];
  for(int i=0;i<[sel_totalTime count]; i++) 
  {
      int allseconds = 0;
      log1 = [sel_totalTime objectAtIndex:i];
      strdate1 = [dateFormatter stringFromDate:log1.starttime];      
      NSString *timelength = log1.worked;
      NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
      int hours = [[timeArray objectAtIndex:0] intValue];
      int minutes = [[timeArray objectAtIndex:1] intValue];
      int seconds = [[timeArray objectAtIndex:2] intValue];
      allseconds = allseconds +hours*3600+minutes*60+seconds;
      
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
              int secondsT = [[timeArray2 objectAtIndex:2] intValue];
              allseconds = allseconds +hoursT*3600+minutesT*60+secondsT;
              [sel_totalTime removeObject:log2];
              j--;
          }
      }
      
      int allhours = allseconds/3600;
      int allminutes = (allseconds%3600)/60;
      NSString *str;
      str = [NSString stringWithFormat:@"%.2d:%.2d",allhours,allminutes];
      [_totalTime addObject:str];
  }
  [[self calendarView] markTilesForTotalTime:_totalTime]; 
  [_totalTime release];
    
    
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

- (void)loadView
{

  if (!self.title)
    self.title = @"Calendar";
  KalView *kalView = [[[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic] autorelease];
  self.view = kalView;
  tableView = kalView.tableView;
  tableView.dataSource = dataSource;
  tableView.delegate = delegate;
  [tableView retain];
  [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
  [self reloadData];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [tableView release];
  tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
  [initialDate release];
  [selectedDate release];
  [logic release];
  [tableView release];
  [super dealloc];
}

@end
