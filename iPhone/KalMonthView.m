/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "AppDelegate_iPhone.h"


@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) 
    {
      for (int j=0; j<7; j++)
      {
        CGRect r = CGRectMake(j*appDelegate.m_kTileSize.width, i*appDelegate.m_kTileSize.height, appDelegate.m_kTileSize.width, appDelegate.m_kTileSize.height);
        [self addSubview:[[KalTileView alloc] initWithFrame:r]];
      }
    }
  }
  return self;
}



      //画出所有的gridview 的小单元格
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++)
  {
    for (KalDate *d in dates[i])
    {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}


- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews)
  {
    if (!t.belongsToAdjacentMonth)
    {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews)
  {
    if ([t.date isEqual:date])
    {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
  AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
  self.height = appDelegate.m_kTileSize.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates     //标记gridview 单元格
{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    
   for (KalTileView *tile in self.subviews)
   {
      tile.marked = [dates containsObject:tile.date];
       
      if(tile.date.NSDate != nil)
      {
          comps =[calendar components:NSWeekdayCalendarUnit
                             fromDate:tile.date.NSDate];
          if ([comps weekday] == 1 || [comps weekday] == 7)
          {
              tile.weekend = YES;
          }
      }
   }
}


- (void)markTilesForTotalTime:(NSArray *)totalTimes
{
    int i = 0;
    for (KalTileView *tile in self.subviews)
    {
        if (tile.marked && i<[totalTimes count])
        {
            tile.totalTime = [totalTimes objectAtIndex:i];
            i++;
        }
    }
}



@end
