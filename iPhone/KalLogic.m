/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSArray *daysInSelectedMonth;
@property (nonatomic, strong) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, strong) NSArray *daysInFirstWeekOfFollowingMonth;

@end






@implementation KalLogic



@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;
@synthesize iphoneCalendarView;




+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
  if ((self = [super init])) {
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
    [self moveToMonthForDate:date];
  }
  return self;
}

- (id)init
{
  return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
  self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
  [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
    
    
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = -1;
    iphoneCalendarView.sel_weekDay = [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:iphoneCalendarView.sel_weekDay options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (void)advanceToFollowingMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
    
    
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = 1;
    iphoneCalendarView.sel_weekDay = [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:iphoneCalendarView.sel_weekDay options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSString *)selectedMonthNameAndYear;
{
  return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
  return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  c.day = [self.baseDate cc_numberOfDaysInMonth];
  NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
  return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
  int n = (int)[beginningOfPreviousMonth cc_numberOfDaysInMonth];
  int numPartialDays = (int)[self numberOfDaysInPreviousPartialWeek];
  NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
  for (int i = n - (numPartialDays - 1); i < n + 1; i++)
    [days addObject:[KalDate dateForDay:i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:(int)c.month year:(int)c.year]];
  
  return days;
}

- (void)recalculateVisibleDays
{
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
  self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
  self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
  KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
  KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
  self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
  self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
}

#pragma mark -


@end
