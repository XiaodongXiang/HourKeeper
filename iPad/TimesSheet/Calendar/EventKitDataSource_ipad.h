/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "Kal_ipad.h"
#import <dispatch/dispatch.h>
#import "CalendarViewController_ipad.h"


@class EKEventStore, EKEvent;

@interface EventKitDataSource_ipad : NSObject <KalDataSource_ipad,UITableViewDelegate>
{
  NSMutableArray *items;            // The list of events corresponding to the currently selected day in the calendar. These events are used to configure cells vended by the UITableView below the calendar month view.
  NSMutableArray *events;           // Must be used on the main thread
  EKEventStore *eventStore;         // Must be used on a background thread managed by eventStoreQueue
  dispatch_queue_t eventStoreQueue; // Serializes access to eventStore and offloads the query work to a background thread.
    
  CalendarViewController_ipad *calendarView;
}

+ (EventKitDataSource_ipad *)dataSource;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol.

@end
