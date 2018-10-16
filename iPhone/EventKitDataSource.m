/*
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "EventKitDataSource.h"
#import <EventKit/EventKit.h>

#import "Logs.h"
#import "Clients.h"
#import "AppDelegate_iPhone.h"

#import "EditLogViewController_new.h"
#import "PayperiodCell.h"

#import "Invoice.h"


static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end



@implementation EventKitDataSource


@synthesize delete_indexPath;


-(void)getCalendarView:(CalendarViewController *)_calendarView
{
    calendarView = _calendarView;
}


+ (EventKitDataSource *)dataSource
{
  return [[[self class] alloc] init];
}

- (id)init
{
  if ((self = [super init]))
  {
      pointInTimeDateFormatter = [[NSDateFormatter alloc] init];
      [pointInTimeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
      
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
  [[NSNotificationCenter defaultCenter] postNotificationName:KalDataSourceChangedNotification object:nil];
}

- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath
{
  return [items objectAtIndex:indexPath.row];
}









#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString* identifier = @"cell";
    PayperiodCell  *cell = (PayperiodCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[PayperiodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [items objectAtIndex:indexPath.row];
    
    
    if ([sel_log.isPaid intValue] == 1)
    {
        [cell.clockImageV setHidden:NO];
    }
    else
    {
        [cell.clockImageV setHidden:YES];
    }
    
    Clients *sel_client = sel_log.client;
    cell.nameLabel.text = sel_client.clientName;
    cell.pointInTimeLabel.text = [NSString stringWithFormat:@"at %@",[[pointInTimeDateFormatter stringFromDate:sel_log.starttime] lowercaseString]];;

    //time
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
        
        overString = [NSString stringWithFormat:@"(%01ldh %02ldm)",seconds/3600,(seconds/60)%60];
    }
    if([overString length]>0)
    {
        NSString *duationString = [appDelegate conevrtTime:sel_log.worked];
        NSString *totalString = [NSString stringWithFormat:@"%@ %@",overString,duationString];
        NSMutableAttributedString *totalStringAttr = [[NSMutableAttributedString alloc]initWithString:totalString];
        NSRange overRange = NSMakeRange(0, [overString length]+1);
        NSRange duationRange = NSMakeRange(overRange.length, [duationString length]);
        UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
        UIFont *duationFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:13];
        UIColor *overColor = [HMJNomalClass creatRedColor_244_79_68];
        UIColor *duationColor = [HMJNomalClass creatGrayColor_152_152_152];
        [totalStringAttr addAttribute:NSFontAttributeName value:overFont range:overRange];
        [totalStringAttr addAttribute:NSFontAttributeName value:duationFont range:duationRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:overColor range:overRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:duationColor range:duationRange];
        cell.totalTimeLabel.text = nil;
        cell.totalTimeLabel.attributedText = totalStringAttr;
    }
    else
        cell.totalTimeLabel.text = [appDelegate conevrtTime:sel_log.worked];

    double totalMoney = [sel_log.totalmoney doubleValue] + [overMoney doubleValue];
    [cell.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalMoney] color:[HMJNomalClass creatAmountColor]];
    [cell.amountView setNeedsDisplay];
    
    if (indexPath.row == [items count]-1)
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
     return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([items count]==0)
        return 0;
    return 24;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([items count]>0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 24)];
        v.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 24-SCREEN_SCALE, SCREEN_WITH, SCREEN_SCALE)];
        line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        [v addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 130,20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        label.textColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        label.text = [[dateFormatter stringFromDate:calendarView.selectedDate]uppercaseString];
        [v addSubview:label];
        return v;

    }
    else
        return nil;
}








- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditLogViewController_new  *editlogView = [[EditLogViewController_new alloc] initWithNibName:@"EditLogViewController_new" bundle:nil];
    editlogView.selectLog = [items objectAtIndex:indexPath.row];
    
    [editlogView setHidesBottomBarWhenPushed:YES];
    [calendarView.navigationController  pushViewController:editlogView animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    int unm = (int)[items count] - 1;
    if (indexPath.row > unm)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [items objectAtIndex:indexPath.row];
    
    self.delete_indexPath = indexPath;
    
    if ([_selectLog.isInvoice boolValue])
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


-(void)deletLog_index:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [items objectAtIndex:indexPath.row];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    
    [items removeObject:_selectLog];
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    

    
    //syncing
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];
    
    [appDelegate.parseSync updateLogFromLocal:_selectLog];
    
    
    [calendarView reloadData];
}



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self deletLog_index:self.delete_indexPath];
        }
    }
}













#pragma mark KalDataSource protocol conformance

//载入所有的记录；
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate client:(Clients *)sel_client
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

- (NSArray *)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  // synchronous callback on the main thread
    
  [items removeAllObjects];  
  [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
    
  return items;
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
