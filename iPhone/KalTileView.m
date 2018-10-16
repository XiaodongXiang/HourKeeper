/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "AppDelegate_iPhone.h"



@implementation KalTileView

@synthesize date;
@synthesize totalTime;
@synthesize weekend;


- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
  }
  return self;
}
- (void)drawRect:(CGRect)rect
{
    //  CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat fontSize = 16.f;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    int shadowColor = 0;
    UIColor *textColor = nil;
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if (self.weekend == YES)
    {
        UIColor *showColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        UIImage *showImange = [appDelegate m_imageWithColor:showColor size:CGSizeMake(appDelegate.m_kTileSize.width, appDelegate.m_kTileSize.height)];
        
        [showImange drawInRect:CGRectMake(0, 0, appDelegate.m_kTileSize.width, appDelegate.m_kTileSize.height)];
    }
    
    BOOL isToday = NO;
    BOOL isTodaySel = NO;
    float cicleImageTop = 5;
    if (IS_IPHONE_6)
        cicleImageTop = 7;
    else if (IS_IPHONE_6PLUS)
        cicleImageTop = 9;
    
    if ([self isToday] && !self.selected)
    {
        UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today.png"]];
        float cycleImageWith = cycleImage.size.width;
        [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0-cicleImageTop, cycleImageWith, cycleImageWith)];
        shadowColor = 1;
        isToday = YES;
    }
    else if ([self isToday] && self.selected)
    {
        UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today_sel.png"]];
        float cycleImageWith = cycleImage.size.width;
        [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0-cicleImageTop, cycleImageWith, cycleImageWith)];
        shadowColor = 1;
        isTodaySel = YES;
        isToday = YES;
    }
    else if (self.selected)
    {
        UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today_sel.png"]];
        float cycleImageWith = cycleImage.size.width;
        [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0-cicleImageTop, cycleImageWith, cycleImageWith)];
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
    textX = roundf(0.5f * (appDelegate.m_kTileSize.width - textSize.width));
    textY = 4;
    if (shadowColor == 0)
    {
        //    textColor = [UIColor colorWithRed:144/255.0 green:141/255.0 blue:137/255.0 alpha:1.0];
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
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],NSParagraphStyleAttributeName:ps};
    
    CGRect textRect=CGRectMake(0, 3,appDelegate.m_kTileSize.width, 30);
    
    [dayText drawInRect:textRect withAttributes:attr];

//    [dayText drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName: textColor}];
    
    
    if (flags.marked && !self.belongsToAdjacentMonth)
    {
        UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
        
        NSString *dayText1 = self.totalTime;
        CGSize textSize = [dayText1 sizeWithAttributes:@{NSFontAttributeName : font1}];
        textX = roundf(appDelegate.m_kTileSize.width - textSize.width)/2.0;
        
        UIColor *todayColor;
        todayColor = [UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1];
        textColor = todayColor;
        
        NSDictionary *attr = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName:font1,NSParagraphStyleAttributeName:ps};
        CGRect timeRect=CGRectMake(0, 22,appDelegate.m_kTileSize.width, 15);
        CGRect timeRect_iPhone6 = CGRectMake(0, 24,appDelegate.m_kTileSize.width, 15);
        CGRect timeRect_iPhone6p = CGRectMake(0, 25,appDelegate.m_kTileSize.width, 15);

        if (IS_IPHONE_6)
        {
            [dayText1 drawInRect:timeRect_iPhone6 withAttributes:attr];
        }
        else if (IS_IPHONE_6PLUS)
        {
            [dayText1 drawInRect:timeRect_iPhone6p withAttributes:attr];

        }
        else
            [dayText1 drawInRect:timeRect withAttributes:attr];
    }
}
/*
- (void)drawRect:(CGRect)rect
{
  CGFloat fontSize = 16.f;
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
  int shadowColor = 0;
  UIColor *textColor = nil;

  AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
  if (self.weekend == YES)
  {
      UIColor *showColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
      UIImage *showImange = [appDelegate m_imageWithColor:showColor size:CGSizeMake(appDelegate.m_kTileSize.width, appDelegate.m_kTileSize.height)];
      
      [showImange drawInRect:CGRectMake(0, 0, appDelegate.m_kTileSize.width, appDelegate.m_kTileSize.height)];
  }
 
  BOOL isToday = NO;
  BOOL isTodaySel = NO;
  if ([self isToday] && !self.selected)
  {
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2-1, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0, cycleImageWith, cycleImageWith)];
      
//    [[UIImage imageNamed:[NSString customImageName:@"today.png"]] drawInRect:CGRectMake((appDelegate.m_kTileSize.width-24)/2-1, 2, 24, 24)];
    shadowColor = 1;
    isToday = YES;
  }
  else if ([self isToday] && self.selected)
  {
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today_sel.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2-1, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0, cycleImageWith, cycleImageWith)];
      
//      [[UIImage imageNamed:@"cal_today_47_43.png"] drawInRect:CGRectMake(-0.1, 0.5, appDelegate.m_kTileSize.width+0.5, appDelegate.m_kTileSize.height)];
      shadowColor = 1;
      isTodaySel = YES;
      isToday = YES;
  }
  else if (self.selected)
  {
      UIImage *cycleImage = [UIImage imageNamed:[NSString customImageName:@"today_sel.png"]];
      float cycleImageWith = cycleImage.size.width;
      [cycleImage drawInRect:CGRectMake((appDelegate.m_kTileSize.width-cycleImageWith)/2-1, (appDelegate.m_kTileSize.height - cycleImageWith)/2.0, cycleImageWith, cycleImageWith)];
      
//     [[UIImage imageNamed:@"cal_47_43.png"] drawInRect:CGRectMake(-0.1, 0.5, appDelegate.m_kTileSize.width+0.5, appDelegate.m_kTileSize.height)];
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
  
    //date
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%d", (int)n];
  CGSize textSize = [dayText sizeWithAttributes:@{NSFontAttributeName : font}];
  CGFloat textX, textY;
  textX = roundf(0.5f * (appDelegate.m_kTileSize.width - textSize.width));
  textY = 4;
  if (shadowColor == 0) 
  {
      textColor = [UIColor redColor];
  }
  else 
  {
      UIColor *todayColor;
      if (isToday == YES)
      {
          todayColor = [UIColor whiteColor];
      }
      else
      {
          todayColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:91/255.0 alpha:1.0];
      }
      textColor = todayColor;
  }
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: [UIColor colorWithRed:86/255.0 green:86/255.0 blue:91/255.0 alpha:1.0], NSFontAttributeName: [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:15],NSParagraphStyleAttributeName:ps};

    CGRect textRect=CGRectMake(0, 3,appDelegate.m_kTileSize.width, 30);

    [dayText drawInRect:textRect withAttributes:attr];
//  [dayText drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName: textColor}];
    

    if (flags.marked)
    {
        CGFloat fontSize1 = 10.f;
        UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize1];
        
        NSString *dayText1 = self.totalTime;
        CGSize textSize = [dayText1 sizeWithAttributes:@{NSFontAttributeName : font1}];
        textX = roundf(appDelegate.m_kTileSize.width - textSize.width)/2.0;
        
        UIColor *todayColor;
        if (isTodaySel == YES)
        {
            todayColor = [UIColor whiteColor];
        }
        else
        {
            todayColor = appDelegate.appTimeColor;
        }
        textColor = todayColor;
        
        [dayText1 drawAtPoint:CGPointMake(textX, textY+23) withAttributes:@{NSFontAttributeName : font1,NSForegroundColorAttributeName: textColor}];
    }
}
*/
- (void)resetState
{
  AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = appDelegate.m_kTileSize;
  self.frame = frame;
  
  date = nil;
    
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
  self.weekend = NO;
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

- (void)setDate:(KalDate *)aDate
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
