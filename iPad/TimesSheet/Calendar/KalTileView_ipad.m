/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView_ipad.h"
#import "KalDate_ipad.h"
#import "KalPrivate_ipad.h"
#import "AppDelegate_Shared.h"


extern const CGSize kTileSize_ipad;

@implementation KalTileView_ipad

@synthesize date;
@synthesize totalTime;
@synthesize weekend;


- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
      
    [self setExclusiveTouch:YES];
      
      self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-SCREEN_SCALE, self.width+2, SCREEN_SCALE)];
      self.bottomLine.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
      [self addSubview:self.bottomLine];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGFloat fontSize = 18.f;
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
  int shadowColor = 0;
  UIColor *textColor = nil;


    
    
  BOOL isToday = NO;
  BOOL isTodaySel = NO;
  if ([self isToday] && !self.selected)
  {      
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"ipad_today.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((kTileSize_ipad.width-cycleImageWith)/2, (kTileSize_ipad.height - cycleImageWith)/2.0-24, cycleImageWith, cycleImageWith)];
     shadowColor = 1;
      isToday = YES;
  }
  else if ([self isToday] && self.selected)
  {
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"ipad_today_sel.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((kTileSize_ipad.width-cycleImageWith)/2, (kTileSize_ipad.height - cycleImageWith)/2.0-24, cycleImageWith, cycleImageWith)];
      shadowColor = 1;
      isTodaySel = YES;
      isToday = YES;
  }
  else if (self.selected) 
  {
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"ipad_today_sel.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((kTileSize_ipad.width-cycleImageWith)/2, (kTileSize_ipad.height - cycleImageWith)/2.0-24, cycleImageWith, cycleImageWith)];
     shadowColor = 1;
  }
  else if (self.belongsToAdjacentMonth)
  {
     shadowColor = 0;
  } 
  else 
  {
     shadowColor = 1;
  }
    
  
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%d", (int)n];
  CGSize textSize = [dayText sizeWithAttributes:@{NSFontAttributeName : font}];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize_ipad.width - textSize.width));
  textY = 11;
    
    //shadowColor 是文字颜色
  if (shadowColor == 0) 
  {
      textColor = [UIColor clearColor];
  }
  else 
  {
      UIColor *todayColor;
      if (isToday == YES || self.selected)
      {
          todayColor = [UIColor whiteColor];
      }
      else
      {
          todayColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:91/255.0 alpha:1.0];
      }
      textColor = todayColor;
  }
  [dayText drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName: textColor}];
    
    //时间文字
    if (flags.marked)
    {
        CGFloat fontSize1 = 13.f;
        UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize1];
        NSString *dayText1 = self.totalTime;
        CGSize textSize = [dayText1 sizeWithAttributes:@{NSFontAttributeName : font1}];
        textX = roundf(kTileSize_ipad.width - textSize.width)/2.0;
        
        UIColor *todayColor;
//        if (isTodaySel == YES)
//        {
//            todayColor = [UIColor whiteColor];
//        }
//        else
//        {
//            todayColor = [UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1];
//        }
        todayColor = [UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1];

        textColor = todayColor;
        
        [dayText1 drawAtPoint:CGPointMake(textX, textY+55-18) withAttributes:@{NSFontAttributeName : font1,NSForegroundColorAttributeName: textColor}];
    }
}

- (void)resetState
{
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize_ipad;
  self.frame = frame;
  
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}


- (void)setTotalTime:(NSString *)_totalTime
{
    if (totalTime == _totalTime)
    {
        return;
    }
    
    totalTime  = _totalTime;
    
    [self setNeedsDisplay];
}

- (void)setDate:(KalDate_ipad *)aDate
{
  if (date == aDate)
  {
      return;
  }
    
  date = aDate;

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
  {
      return;
  }
    
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
  {
      return;
  }
    
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
  {
      return;
  }
    
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
  {
      return;
  }
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }


@end
