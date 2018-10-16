/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView_ipad.h"
#import "KalTileView_ipad.h"
#import "KalView_ipad.h"
#import "KalDate_ipad.h"
#import "KalPrivate_ipad.h"

extern const CGSize kTileSize_ipad;

@implementation KalMonthView_ipad

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) 
    {
      for (int j=0; j<7; j++)
      {
        CGRect r = CGRectMake(j*kTileSize_ipad.width+j*0.5, i*kTileSize_ipad.height-i*0.9+0.3, kTileSize_ipad.width, kTileSize_ipad.height);
        [self addSubview:[[KalTileView_ipad alloc] initWithFrame:r]];
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
  
  for (int i=0; i<3; i++) {
    for (KalDate_ipad *d in dates[i])
    {
      KalTileView_ipad *tile = [self.subviews objectAtIndex:tileNum];
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

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
}

- (KalTileView_ipad *)firstTileOfMonth
{
  KalTileView_ipad *tile = nil;
  for (KalTileView_ipad *t in self.subviews)
  {
    if (!t.belongsToAdjacentMonth)
    {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView_ipad *)tileForDate:(KalDate_ipad *)date
{
  KalTileView_ipad *tile = nil;
  for (KalTileView_ipad *t in self.subviews)
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
  self.height = kTileSize_ipad.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates     //标记gridview 单元格
{
  for (KalTileView_ipad *tile in self.subviews)
  {
      tile.marked = [dates containsObject:tile.date];
  }
}


- (void)markTilesForTotalTime:(NSArray *)totalTimes
{
    int i = 0;
    for (KalTileView_ipad *tile in self.subviews)
    {
        if (tile.marked && i<[totalTimes count])
        {
            tile.totalTime = [totalTimes objectAtIndex:i];
            i++;
        }
    }
}



@end
