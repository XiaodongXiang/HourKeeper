//
//  ChartCell_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface ChartCell_ipad : UITableViewCell
{
}
@property (nonatomic,strong) IBOutlet UIImageView *colorImageV;
@property (nonatomic,strong) IBOutlet UILabel *nameLbel;
@property (nonatomic,strong) IBOutlet UILabel *midLbel;
@property (nonatomic,strong) IBOutlet UILabel *percentageLbel;

@property(nonatomic,strong)IBOutlet UIView  *verticalLine;
@property(nonatomic,strong)IBOutlet HMJLabel    *amountView;


@end
