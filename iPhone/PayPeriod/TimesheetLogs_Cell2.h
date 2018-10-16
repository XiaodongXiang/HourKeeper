//
//  TimesheetLogs_Cell2.h
//  HoursKeeper
//
//  Created by xy_dev on 6/7/13.
//
//

#import <UIKit/UIKit.h>

@interface TimesheetLogs_Cell2 : UITableViewCell
{
}

@property(nonatomic,strong) IBOutlet UILabel *dateLbel;
@property(nonatomic,strong) IBOutlet UILabel *startDateLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalTimerLbel;
@property(nonatomic,strong) IBOutlet UIImageView *clockImageV;

@property (nonatomic,assign) float high;
@property(nonatomic,strong)IBOutlet UIView  *bottomLine;

@end
