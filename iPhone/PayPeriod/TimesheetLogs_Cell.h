//
//  TimesheetLogs_Cell.h
//  HoursKeeper
//
//  Created by xy_dev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface TimesheetLogs_Cell : UITableViewCell
{
}

@property(nonatomic,weak) IBOutlet UILabel *dateLbel;
@property(nonatomic,weak) IBOutlet UILabel *logCountLabel;

@property(nonatomic,weak) IBOutlet HMJLabel *totalMoneyLbel;
@property(nonatomic,weak) IBOutlet UILabel *totalTimerLbel;
@property(nonatomic,weak) IBOutlet UILabel *overTimerLbel;


 

@end
