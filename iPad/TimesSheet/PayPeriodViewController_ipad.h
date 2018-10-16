//
//  PayPeriodViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 8/19/13.
//
//

/**
    PayPeriod 对应的ViewController
 */
#import <UIKit/UIKit.h>

#import "TimeSheetViewController.h"
#import "HMJLabel.h"


@interface PayPeriodViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDateFormatter *headDateFormatter;
}
@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@property(nonatomic,strong) IBOutlet UILabel *totalTimeLbel;
@property (nonatomic,strong) IBOutlet UILabel *m_overTimeLbel;

@property (nonatomic,strong) IBOutlet HMJLabel *overMoneyLabel;
@property(nonatomic,strong) IBOutlet HMJLabel *totalMoneyLbel;

@property (nonatomic,strong) NSMutableArray *dateLogArray;
@property (nonatomic,assign) long app_allseconds;
@property (nonatomic,assign) double app_allmoney;

@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrol;

@property(nonatomic,weak)IBOutlet   UIView      *bottomView;


-(IBAction)doShowStly:(UISegmentedControl *)sender;

-(void)reflashTableAndBottom;

-(void)getPayPeriod;


@end
