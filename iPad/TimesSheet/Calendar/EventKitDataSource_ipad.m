/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource_ipad.h"
#import <EventKit/EventKit.h>
#import "Logs.h"

#import "AppDelegate_Shared.h"
#import "EditLogViewController_new.h"




static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource_ipad ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end





@implementation EventKitDataSource_ipad



-(void)getCalendarView:(CalendarViewController_ipad *)_calendarView
{
    calendarView = _calendarView;
}


+ (EventKitDataSource_ipad *)dataSource
{
  return [[[self class] alloc] init];
}

- (id)init
{
  if ((self = [super init])) {
    eventStore = [[EKEventStore alloc] init];
    events = [[NSMutableArray alloc] init];
    items = [[NSMutableArray alloc] init];
    eventStoreQueue = dispatch_queue_create("com.thepolypeptides.nativecalexample", NULL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EKEventStoreChangedNotification object:nil];
  }
  return self;
}

- (void)eventStoreChanged:(NSNotification *)note
{
  [[NSNotificationCenter defaultCenter] postNotificationName:KalDataSourceChangedNotification_ipad object:nil];
}

- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath
{
  return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditLogViewController_new  *editlogView = [[EditLogViewController_new alloc] initWithNibName:@"EditLogViewController_new" bundle:nil];
    editlogView.selectLog = [items objectAtIndex:indexPath.row];
    
    [editlogView setHidesBottomBarWhenPushed:YES];
    [calendarView.navigationController  pushViewController:editlogView animated:YES];
    
}



-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark KalDataSource protocol conformance

           //载入所有的记录；
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks_ipad>)delegate client:(Clients *)sel_client
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    [events removeAllObjects];
    [events addObjectsFromArray:[appDelegate getOverTime_Log:sel_client startTime:fromDate endTime:toDate isAscendingOrder:YES]];
    [delegate loadedDataSource:self];
}
          //选中标记的记录
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  // synchronous callback on the main thread
    
    return [self eventsFrom:fromDate to:toDate];
    //return nil;
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  // synchronous callback on the main thread
    
  [items removeAllObjects];  
  [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
  // synchronous callback on the main thread
  [items removeAllObjects];
}

#pragma mark -

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
  NSMutableArray *matches = [NSMutableArray array];
  for (Logs *event in events)
    if (IsDateBetweenInclusive(event.starttime, fromDate, toDate))
      [matches addObject:event];
  
  return matches;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:nil];
  dispatch_sync(eventStoreQueue, ^{
  });
}

@end
