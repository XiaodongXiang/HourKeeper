/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalGridView_ipad, KalLogic_ipad, KalDate_ipad;
@protocol KalViewDelegate_ipad, KalDataSourceCallbacks_ipad;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *       |                                         |
 *       |           table view (events)           |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */
@interface KalView_ipad : UIView
{
  UILabel *headerTitleLabel;
  KalGridView_ipad *gridView;
  UITableView *__weak tableView;
  UIImageView *shadowView;
  id<KalViewDelegate_ipad> delegate;
  KalLogic_ipad *logic;
}

@property (nonatomic, strong) id<KalViewDelegate_ipad> delegate;
@property (weak, nonatomic, readonly) UITableView *tableView;
@property (weak, nonatomic, readonly) KalDate_ipad *selectedDate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate_ipad>)delegate logic:(KalLogic_ipad *)logic;
- (BOOL)isSliding;
- (void)selectDate:(KalDate_ipad *)date;

- (void)markTilesForDates:(NSArray *)dates;
- (void)markTilesForTotalTime:(NSArray *)totalTimes;

- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

@end

#pragma mark -

@class KalDate_ipad;




@protocol KalViewDelegate_ipad

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate_ipad *)date;

@end



