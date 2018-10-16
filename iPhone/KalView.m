/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "AppDelegate_Shared.h"

@interface KalView ()

{
    UIView *my_headerView;
}

- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static CGFloat kHeaderHeight = 20.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
  if ((self = [super initWithFrame:frame])) 
  {
      if(IS_IPHONE_6)
          kHeaderHeight = 22;
      else if (IS_IPHONE_6PLUS)
          kHeaderHeight = 25;
    delegate = theDelegate;
    logic = theLogic;
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    
    my_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)];
    my_headerView.backgroundColor = [UIColor clearColor];
    [self reflashWeekStly];
    [self addSubview:my_headerView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)];
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
    
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}



-(void)reflashWeekStly
{
    for (UIView *view in my_headerView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    CGRect imageFrame = my_headerView.frame;
    imageFrame.origin = CGPointZero;
    backgroundView.frame = imageFrame;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_1.png"]];
    imageV.frame = CGRectMake(0, imageFrame.size.height-1, imageFrame.size.width, 1);
    [backgroundView addSubview:imageV];
    [my_headerView addSubview:backgroundView];
    
    
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSUInteger i = [appDelegate getFirstDayForWeek] - 1;
    
    float siez_w = my_headerView.width/7;
    for (CGFloat xOffset = 0.f; xOffset < my_headerView.width; xOffset += siez_w, i = (i+1)%7)
    {
        CGRect weekdayFrame = CGRectMake(xOffset, 1.f, siez_w, kHeaderHeight);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:153/255.0 alpha:1.f];
        NSString *weekString = [weekdayNames objectAtIndex:i];
        
        weekdayLabel.text = [[weekString substringToIndex:2]uppercaseString];
        [my_headerView addSubview:weekdayLabel];
    }
}





- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];

   shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_1.png"]];
   shadowView.frame = CGRectMake(0, 0, self.width, 1);
   [contentView addSubview:shadowView];
    
  // The list of events for the selected day
  tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [contentView addSubview:tableView];
  
    
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"])
  {
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.frame.size.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom-1;
  }
  else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"])
  {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
  }
  else
  {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }


- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }
- (void)markTilesForTotalTime:(NSArray *)totalTimes { [gridView markTilesForTotalTime:totalTimes]; }


- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  
  [gridView removeObserver:self forKeyPath:@"frame"];
    
    
    
}

@end


