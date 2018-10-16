/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView_ipad, KalMonthView_ipad, KalLogic_ipad, KalDate_ipad;
@protocol KalViewDelegate_ipad;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 */
@interface KalGridView_ipad : UIView
{
  id<KalViewDelegate_ipad> delegate;  // Assigned.
  KalLogic_ipad *logic;
  KalMonthView_ipad *frontMonthView;
  KalMonthView_ipad *backMonthView;
  KalTileView_ipad *selectedTile;
  KalTileView_ipad *highlightedTile;
  BOOL transitioning;
    
  
    
}

@property (nonatomic, readonly) BOOL transitioning;
@property (weak, nonatomic, readonly) KalDate_ipad *selectedDate;



- (id)initWithFrame:(CGRect)frame logic:(KalLogic_ipad *)logic delegate:(id<KalViewDelegate_ipad>)delegate;
- (void)selectDate:(KalDate_ipad *)date;

- (void)markTilesForDates:(NSArray *)dates;
- (void)markTilesForTotalTime:(NSArray *)totalTimes;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end
