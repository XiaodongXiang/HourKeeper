//
//  Jobs_Cell.h
//  HoursKeeper
//
//  Created by xy_dev on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Jobs_Cell : UITableViewCell
{
}

@property(nonatomic,strong) IBOutlet UILabel *dateLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *totalTimerLbel;


@end
