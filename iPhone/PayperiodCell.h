//
//  PayperiodCell.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/6.
//
//

#import <UIKit/UIKit.h>

@class HMJLabel;

@interface PayperiodCell : UITableViewCell
@property (strong, nonatomic)UILabel    *nameLabel;
@property (strong, nonatomic)UILabel *totalTimeLabel;
@property (strong, nonatomic)UILabel *pointInTimeLabel;
@property (strong, nonatomic)HMJLabel *amountView;
@property (strong, nonatomic)UIView *verticalLine;
@property (strong, nonatomic)UIView *bottomLine;
@property (strong, nonatomic)UIImageView    *clockImageV;
@end
