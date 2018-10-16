/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView_ipad, KalDate_ipad;

@interface KalMonthView_ipad : UIView
{
  NSUInteger numWeeks;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalTileView_ipad *)firstTileOfMonth;
- (KalTileView_ipad *)tileForDate:(KalDate_ipad *)date;

- (void)markTilesForDates:(NSArray *)dates;
- (void)markTilesForTotalTime:(NSArray *)totalTimes;

@end
