//
//  Timer_Cell.h
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJClientAmountView.h"
#import "HMJLabel.h"

@interface Timer_Cell : UITableViewCell
{
}

@property (nonatomic,strong) IBOutlet UILabel *startDateLbel;
@property (nonatomic,strong) IBOutlet UILabel *totalTimeLbel;
@property (nonatomic,strong) IBOutlet UILabel *clientNameLbel;
//@property (nonatomic,strong) IBOutlet UILabel *rateLbel;
@property (nonatomic,strong) IBOutlet HMJLabel *totalMoneyView;

@property (nonatomic,strong) IBOutlet UIView *BackView;
@property (nonatomic,assign) float high;

@property(nonatomic,strong)IBOutlet HMJClientAmountView  *amountView;
@property(nonatomic,strong)IBOutlet UIView      *verticalLine;
@property(nonatomic,strong)IBOutlet UIView      *bottomLine;

@end
