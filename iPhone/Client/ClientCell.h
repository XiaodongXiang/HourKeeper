//
//  ClientCell.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/26.
//
//

#import <UIKit/UIKit.h>
#import "HMJClientAmountView.h"

@interface ClientCell : UITableViewCell

@property(nonatomic,strong)UILabel  *nameLabel;
@property(nonatomic,strong)HMJClientAmountView  *amountView;
@property(nonatomic,strong)UIView   *bottomLine;
@end
