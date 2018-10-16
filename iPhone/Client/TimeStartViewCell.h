//
//  TimeStartViewCell.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface TimeStartViewCell : UITableViewCell

@property (strong, nonatomic)UIView     *containView;
@property (strong, nonatomic)UILabel *totalTimeLabel;
@property (strong, nonatomic)UILabel *pointInTimeLabel;
@property (strong, nonatomic)UILabel *dateLabel;
@property (strong, nonatomic)HMJLabel *amountView;
@property (strong, nonatomic)UIView *verticalLine;
@property (strong, nonatomic)UIView *bottomLine;
@property (strong, nonatomic)UIImageView    *clockImageV;
@end
