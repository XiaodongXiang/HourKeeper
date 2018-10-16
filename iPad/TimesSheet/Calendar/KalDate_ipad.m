/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDate_ipad.h"
#import "KalPrivate_ipad.h"

static KalDate_ipad *today;


@interface KalDate_ipad ()
+ (void)cacheTodaysDate;
@end


@implementation KalDate_ipad

+ (void)initialize
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheTodaysDate) name:UIApplicationSignificantTimeChangeNotification object:nil];
  [self cacheTodaysDate];
}

+ (void)cacheTodaysDate
{
  today = [KalDate_ipad dateFromNSDate:[NSDate date]];
}

+ (KalDate_ipad *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  return [[KalDate_ipad alloc] initForDay:day month:month year:year];
}

+ (KalDate_ipad *)dateFromNSDate:(NSDate *)date
{
  NSDateComponents *parts = [date cc_componentsForMonthDayAndYear];
  return [KalDate_ipad dateForDay:(int)[parts day] month:(int)[parts month] year:(int)[parts year]];
}

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
  if ((self = [super init])) {
    a.day = day;
    a.month = month;
    a.year = year;
  }
  return self;
}

- (unsigned int)day { return a.day; }
- (unsigned int)month { return a.month; }
- (unsigned int)year { return a.year; }

- (NSDate *)NSDate
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.day = a.day;
  c.month = a.month;
  c.year = a.year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (BOOL)isToday { return [self isEqual:today]; }

- (NSComparisonResult)compare:(KalDate_ipad *)otherDate
{
  NSInteger selfComposite = a.year*10000 + a.month*100 + a.day;
  NSInteger otherComposite = [otherDate year]*10000 + [otherDate month]*100 + [otherDate day];
  
  if (selfComposite < otherComposite)
    return NSOrderedAscending;
  else if (selfComposite == otherComposite)
    return NSOrderedSame;
  else
    return NSOrderedDescending;
}

#pragma mark -
#pragma mark NSObject interface

- (BOOL)isEqual:(id)anObject
{
  if (![anObject isKindOfClass:[KalDate_ipad class]])
    return NO;
  
  KalDate_ipad *d = (KalDate_ipad*)anObject;
  return a.day == [d day] && a.month == [d month] && a.year == [d year];
}

- (NSUInteger)hash
{
  return a.day;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%u/%u/%u", a.month, a.day, a.year];
}

@end
