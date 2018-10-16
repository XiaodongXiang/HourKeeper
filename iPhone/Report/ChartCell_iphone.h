//
//  ChartCell_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface ChartCell_iphone : UITableViewCell
{
}
@property (nonatomic,strong) IBOutlet UIImageView *colorImageV;
@property (nonatomic,strong) IBOutlet UILabel *nameLbel;
@property (nonatomic,strong) IBOutlet UILabel *percentageLbel;
@property (nonatomic,strong) IBOutlet   HMJLabel    *amountLabel;
@property (nonatomic,retain) IBOutlet UILabel *midLbel;

@property(nonatomic,weak) IBOutlet  UIView  *line;

@property(nonatomic,weak) IBOutlet  UIImageView  *bottomLine;
@end
