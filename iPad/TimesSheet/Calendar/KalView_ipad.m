/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView_ipad.h"
#import "KalGridView_ipad.h"
#import "KalLogic_ipad.h"
#import "KalPrivate_ipad.h"

@interface KalView_ipad ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 0;  //kHeaderHeight = 44.f;  60

@implementation KalView_ipad

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_ipad>)theDelegate logic:(KalLogic_ipad *)theLogic
{
  if ((self = [super initWithFrame:frame])) 
  {
    delegate = theDelegate;
    logic = theLogic;
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      contentView.backgroundColor = [UIColor clearColor];
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
    
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic_ipad. Use the initWithFrame:delegate:logic: method."];
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

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_back_320_20.png"]];
  CGRect imageFrame = headerView.frame;
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [headerView addSubview:backgroundView];

  NSArray *weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
  NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
  NSUInteger i = firstWeekday - 1;
  int k = 0;
  for (CGFloat xOffset = 30.f; xOffset < headerView.width; xOffset += 78.f, i = (i+1)%7) 
  {
      if (k>6)
      {
          break;
      }
      //xOffset, 30.f, 46.f, kHeaderHeight - 29.f  46  45
    CGRect weekdayFrame = CGRectMake(xOffset, 0.f, 46.f, kHeaderHeight); 
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
    weekdayLabel.backgroundColor = [UIColor clearColor];
    weekdayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10.f];
    weekdayLabel.textAlignment = NSTextAlignmentCenter;
    weekdayLabel.textColor = [UIColor colorWithRed:45/255.0 green:80/255.0 blue:123/255.0 alpha:1.f];
    weekdayLabel.shadowColor = [UIColor whiteColor];
    weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    weekdayLabel.text = [weekdayNames objectAtIndex:i];
    [headerView addSubview:weekdayLabel];
    k++;
  }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView_ipad alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];

    
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
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

- (void)selectDate:(KalDate_ipad *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }


- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }
- (void)markTilesForTotalTime:(NSArray *)totalTimes { [gridView markTilesForTotalTime:totalTimes]; }


- (KalDate_ipad *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  
  [gridView removeObserver:self forKeyPath:@"frame"];
}

@end
