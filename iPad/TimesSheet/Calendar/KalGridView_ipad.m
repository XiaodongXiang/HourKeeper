/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "Custom1ViewController.h"
#import "KalGridView_ipad.h"
#import "KalView_ipad.h"
#import "KalMonthView_ipad.h"
#import "KalTileView_ipad.h"
#import "KalLogic_ipad.h"
#import "KalDate_ipad.h"
#import "KalPrivate_ipad.h"

#import "PopShowLogsViewController_ipad.h"
#import "AddLogViewController_ipad.h"
#import "AppDelegate_iPad.h"





#define SLIDE_NONE_IPAD 0
#define SLIDE_UP_IPAD 1
#define SLIDE_DOWN_IPAD 2

const CGSize kTileSize_ipad = { 100.f, 94 };

static NSString *kSlideAnimationId_ipad = @"KalSwitchMonths";







@interface KalGridView_ipad ()
@property (nonatomic, strong) KalTileView_ipad *selectedTile;
@property (nonatomic, strong) KalTileView_ipad *highlightedTile;
- (void)swapMonthViews;
@end


@implementation KalGridView_ipad



@synthesize selectedTile, highlightedTile, transitioning;





- (id)initWithFrame:(CGRect)frame logic:(KalLogic_ipad *)theLogic delegate:(id<KalViewDelegate_ipad>)theDelegate
{
  frame.size.width = 7 * kTileSize_ipad.width+4;
  
  if (self = [super initWithFrame:frame])
  {
      //添加手势，横滑手势
      UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toRight:)];
      swipRight.direction = UISwipeGestureRecognizerDirectionRight;
      [self addGestureRecognizer:swipRight];
      
      UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toLeft:)];
      
      swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      [self addGestureRecognizer:swipLeft];
      
    self.clipsToBounds = YES;
    logic = theLogic;
    delegate = theDelegate;
    
    CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
    frontMonthView = [[KalMonthView_ipad alloc] initWithFrame:monthRect];
    backMonthView = [[KalMonthView_ipad alloc] initWithFrame:monthRect];
    backMonthView.hidden = YES;
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];

    [self jumpToSelectedMonth];
  }
    
  self.backgroundColor = [UIColor clearColor];
  return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] setFill];
}

- (void)sizeToFit
{
  self.height = frontMonthView.height;
}

#pragma mark Guester Action
-(void)toRight:(UISwipeGestureRecognizer *)guester{
    [delegate showPreviousMonth];
}
-(void)toLeft:(UISwipeGestureRecognizer *)guester{
    [delegate showFollowingMonth];
}

#pragma mark -
#pragma mark Touches
- (void)setHighlightedTile:(KalTileView_ipad *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = tile;
    tile.highlighted = YES;
    [tile setNeedsDisplay];
  }
}

- (void)setSelectedTile:(KalTileView_ipad *)tile
{
  if (selectedTile != tile) {
    selectedTile.selected = NO;
    selectedTile = tile;
    tile.selected = YES;
    [delegate didSelectDate:tile.date];
  }
}

- (void)receivedTouches:(NSSet *)touches withEvent:event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
  
  if (hitView == nil)
    return;
  
  if ([hitView isKindOfClass:[KalTileView_ipad class]])
  {
    KalTileView_ipad *tile = (KalTileView_ipad*)hitView;
      
      if (tile.date == nil)
      {
          return;
      }
      
    if (tile.belongsToAdjacentMonth)
    {
      self.highlightedTile = tile;
    } else {
      self.highlightedTile = nil;
      self.selectedTile = tile;
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self receivedTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self receivedTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInView:self];
  UIView *hitView = [self hitTest:location withEvent:event];
    
    if (hitView == nil)
        return;
    
    
  
  KalTileView_ipad *tile = (KalTileView_ipad*)hitView;
    
    if(tile.date == nil)
        return;
    
    if (tile.belongsToAdjacentMonth) 
    {
        if ([tile.date compare:[KalDate_ipad dateFromNSDate:logic.baseDate]] == NSOrderedDescending)
        {
            [delegate showFollowingMonth];
        } 
        else
        {
            [delegate showPreviousMonth];
        }
        self.selectedTile = [frontMonthView tileForDate:tile.date];
    } 
    else
    {
        self.selectedTile = tile;
    }
  self.highlightedTile = nil;
    
    
    NSDate *fromDate;
    NSDate *toDate;
    fromDate = [tile.date NSDate];
    toDate = [fromDate dateByAddingTimeInterval:(NSTimeInterval)24*3600];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	NSArray *allresults = [appDelegate getOverTime_Log:nil startTime:fromDate endTime:toDate isAscendingOrder:YES];
    
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithArray:allresults];
    if (appDelegate.mainView.timersheetView.calendarView.sel_client != nil)
    {
        for (int i=0; i<allArray.count; i++)
        {
            Logs *log = [allArray objectAtIndex:i];
            if (log.client != appDelegate.mainView.timersheetView.calendarView.sel_client)
            {
                [allArray removeObject:log];
                i--;
            }
        }
    }
    
    if ([allArray count] > 0)
    {
        PopShowLogsViewController_ipad *popShowLogsView = [[PopShowLogsViewController_ipad alloc] initWithNibName:@"PopShowLogsViewController_ipad" bundle:nil];
        
        popShowLogsView.preferredContentSize = CGSizeMake(320, 409);
        popShowLogsView.startDate = fromDate;
        popShowLogsView.showStly = 1;
        [popShowLogsView.logsList addObjectsFromArray:allArray];
        popShowLogsView.overTimeStly = 0;
        
         UINavigationController *ShowNaiv = [[UINavigationController alloc] initWithRootViewController:popShowLogsView];
        
        if (appDelegate.mainView.timersheetView.popoverController != nil)
        {
            appDelegate.mainView.timersheetView.popoverController = nil;
        }
        appDelegate.mainView.timersheetView.popoverController = [[UIPopoverController alloc] initWithContentViewController:ShowNaiv];
        
        
        [appDelegate.mainView.timersheetView.popoverController presentPopoverFromRect:tile.frame inView:tile.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    else
    {
        AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
        
        addLogView.startDate = fromDate;
        
        Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
        addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
        addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [appDelegate.mainView.timersheetView.calendarView  presentViewController:addLogNavi animated:YES completion:nil];
        appDelegate.m_widgetController = appDelegate.mainView.timersheetView.calendarView;
        
    }
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
  backMonthView.hidden = NO;
  
  // set initial positions before the slide
  if (direction == SLIDE_UP_IPAD) 
  {
    backMonthView.top = keepOneRow
      ? frontMonthView.bottom - kTileSize_ipad.height
      : frontMonthView.bottom;
  } 
  else if (direction == SLIDE_DOWN_IPAD) 
  {
    NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
    NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
    backMonthView.top = -numWeeksToSlide * kTileSize_ipad.height;
  } 
  else 
  {
    backMonthView.top = 0.f;
  }
  
  // trigger the slide animation
  [UIView beginAnimations:kSlideAnimationId_ipad context:NULL]; {
    [UIView setAnimationsEnabled:direction!=SLIDE_NONE_IPAD];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    frontMonthView.top = -backMonthView.top;
    backMonthView.top = 0.f;

    frontMonthView.alpha = 0.f;
    backMonthView.alpha = 1.f;
    
    self.height = backMonthView.height;
    
    [self swapMonthViews];
  } [UIView commitAnimations];
 [UIView setAnimationsEnabled:YES];
}

- (void)slide:(int)direction
{
  transitioning = YES;
  
  [backMonthView showDates:logic.daysInSelectedMonth
      leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
     trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
  
  // At this point, the calendar logic has already been advanced or retreated to the
  // following/previous month, so in order to determine whether there are 
  // any cells to keep, we need to check for a partial week in the month
  // that is sliding offscreen.
  
  BOOL keepOneRow = (direction == SLIDE_UP_IPAD && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
                 || (direction == SLIDE_DOWN_IPAD && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
  
  [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
  
  self.selectedTile = [frontMonthView firstTileOfMonth];
}

- (void)slideUp { [self slide:SLIDE_UP_IPAD]; }
- (void)slideDown { [self slide:SLIDE_DOWN_IPAD]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  transitioning = NO;
  backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectDate:(KalDate_ipad *)date
{
  self.selectedTile = [frontMonthView tileForDate:date];
}

- (void)swapMonthViews
{
  KalMonthView_ipad *tmp = backMonthView;
  backMonthView = frontMonthView;
  frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE_IPAD];
}

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }
- (void)markTilesForTotalTime:(NSArray *)totalTimes { [frontMonthView markTilesForTotalTime:totalTimes]; }

- (KalDate_ipad *)selectedDate { return selectedTile.date; }

#pragma mark -


@end
