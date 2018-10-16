//
//  todayTableViewCell.h
//  TodayWidget
//
//  Created by HMT on 14/10/28.
//  Copyright (c) 2014年 MTH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

// 主视图
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
