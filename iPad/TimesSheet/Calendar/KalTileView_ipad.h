/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate_ipad;

@interface KalTileView_ipad : UIView
{
  NSString *totalTime;
  KalDate_ipad *date;
  CGPoint origin;
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
}

@property (nonatomic,strong) NSString *totalTime;
@property (nonatomic, strong) KalDate_ipad *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic, assign) BOOL weekend;
@property (nonatomic) KalTileType type;
@property(nonatomic,strong)UIView   *bottomLine;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;

@end
