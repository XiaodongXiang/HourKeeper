/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDataSource.h"
#import "KalPrivate.h"

@implementation SimpleKalDataSource












-(void)getCalendarView:(UIViewController *)_calendarView
{
    
}



+ (SimpleKalDataSource*)dataSource
{
  return [[[self class] alloc] init];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  cell.textLabel.text = @"Filler text";
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate client:(Clients *)sel_client
{
  [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate     //返回对应有标记的日期
{
  return [NSArray array];
}

- (NSArray *)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  // do nothing
    
    return nil;
}

- (void)removeAllItems
{
  // do nothing
}

@end
