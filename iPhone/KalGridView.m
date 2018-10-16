/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "AppDelegate_iPhone.h"


#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2



static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()
@property (nonatomic, strong) KalTileView *selectedTile;
@property (nonatomic, strong) KalTileView *highlightedTile;
- (void)swapMonthViews;
@end

@implementation KalGridView
@synthesize selectedTile, highlightedTile, transitioning;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate
{
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
    frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
    backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
    backMonthView.hidden = YES;
    [self addSubview:backMonthView];
    [self addSubview:frontMonthView];

    [self jumpToSelectedMonth];
  }
    
  self.backgroundColor = [UIColor whiteColor];
    
    
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGRect line;
    line.origin = CGPointMake(0.f, self.height);// - 1.f);
  line.size = CGSizeMake(self.width, 1.f);
  CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

- (void)sizeToFit
{
  self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView *)tile
{
  if (highlightedTile != tile) {
    highlightedTile.highlighted = NO;
    highlightedTile = tile;
    tile.highlighted = YES;
    [tile setNeedsDisplay];
  }
}

- (void)setSelectedTile:(KalTileView *)tile
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
  
  if (!hitView)
    return;
  
  if ([hitView isKindOfClass:[KalTileView class]])
  {
    KalTileView *tile = (KalTileView*)hitView;
    if (tile.belongsToAdjacentMonth)
    {
      self.highlightedTile = tile;
    }
    else
    {
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
    
    
  if (!hitView)
    return;
    
    
  if ([hitView isKindOfClass:[KalTileView class]])
  {
    KalTileView *tile = (KalTileView*)hitView;
    if (tile.belongsToAdjacentMonth)
    {
      if ([tile.date compare:[KalDate dateFromNSDate:logic.baseDate]] == NSOrderedDescending)
      {
        [delegate showFollowingMonth];
      }
      else
      {
        [delegate showPreviousMonth];
      }
        
        
      self.highlightedTile = nil;  
      self.selectedTile = [frontMonthView tileForDate:tile.date];
    }
    else
    {
      self.highlightedTile = nil;
      self.selectedTile = tile;
    }
  }
}

-(void)toRight:(UISwipeGestureRecognizer *)guester{
    [delegate showPreviousMonth];
}
-(void)toLeft:(UISwipeGestureRecognizer *)guester{
    [delegate showFollowingMonth];
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    
  backMonthView.hidden = NO;
  
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.left = frontMonthView.right;
    } else if (direction == SLIDE_DOWN) {
        backMonthView.left = -frontMonthView.right;
    }
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.left = -backMonthView.left;
        
        backMonthView.left = 0.f;
        
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
    
  // set initial positions before the slide
//    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//  if (direction == SLIDE_UP) 
//  {
//    backMonthView.top = keepOneRow
//      ? frontMonthView.bottom - appDelegate.m_kTileSize.height
//      : frontMonthView.bottom;
//  } 
//  else if (direction == SLIDE_DOWN) 
//  {
//    NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
//    NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
//    backMonthView.top = -numWeeksToSlide * appDelegate.m_kTileSize.height;
//  } 
//  else 
//  {
//    backMonthView.top = 0.f;
//  }
//  
//  // trigger the slide animation
//  [UIView beginAnimations:kSlideAnimationId context:NULL];
//  {
//    [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    
//    frontMonthView.top = -backMonthView.top;
//    backMonthView.top = 0.f;
//
//    frontMonthView.alpha = 0.f;
//    backMonthView.alpha = 1.f;
//    
//    self.height = backMonthView.height;
//    
//    [self swapMonthViews];
//  } [UIView commitAnimations];
//  [UIView setAnimationsEnabled:YES];
    
}

- (void)slide:(int)direction
{
  transitioning = YES;
  
  [backMonthView showDates:logic.daysInSelectedMonth
      leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
     trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth];
  
  BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
                 || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
  
  [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
  
  self.selectedTile = [frontMonthView firstTileOfMonth];
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  transitioning = NO;
  backMonthView.hidden = YES;
}

#pragma mark -

- (void)selectDate:(KalDate *)date
{
  self.selectedTile = [frontMonthView tileForDate:date];
}

- (void)swapMonthViews
{
  KalMonthView *tmp = backMonthView;
  backMonthView = frontMonthView;
  frontMonthView = tmp;
  [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
  [self slide:SLIDE_NONE];
}

- (void)markTilesForDates:(NSArray *)dates { [frontMonthView markTilesForDates:dates]; }
- (void)markTilesForTotalTime:(NSArray *)totalTimes { [frontMonthView markTilesForTotalTime:totalTimes]; }

- (KalDate *)selectedDate { return selectedTile.date; }

#pragma mark -


@end
