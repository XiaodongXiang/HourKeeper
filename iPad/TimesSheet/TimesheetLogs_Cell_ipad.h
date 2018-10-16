//
//  TimesheetLogs_Cell_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface TimesheetLogs_Cell_ipad : UITableViewCell
{

}

@property(nonatomic,strong) IBOutlet UILabel *dateLbel;
@property(nonatomic,strong) IBOutlet UILabel *logCountLabel;

@property(nonatomic,strong) IBOutlet UILabel *overTimerLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalTimerLbel;

@property(nonatomic,strong)IBOutlet HMJLabel    *overMoneyLbel;
@property(nonatomic,strong)IBOutlet HMJLabel    *totalMoneyLbel;

@property(nonatomic,strong)IBOutlet UIView  *line;
@property(nonatomic,strong)IBOutlet UIView  *bottomLine;

@end
