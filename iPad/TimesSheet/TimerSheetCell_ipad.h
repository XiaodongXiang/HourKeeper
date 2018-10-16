//
//  TimerSheetCell_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerSheetCell_ipad : UITableViewCell
{
}
@property(nonatomic,strong) IBOutlet UIButton *sunBtn;
@property(nonatomic,strong) IBOutlet UIButton *monBtn;
@property(nonatomic,strong) IBOutlet UIButton *tueBtn;
@property(nonatomic,strong) IBOutlet UIButton *wedBtn;
@property(nonatomic,strong) IBOutlet UIButton *thuBtn;
@property(nonatomic,strong) IBOutlet UIButton *friBtn;
@property(nonatomic,strong) IBOutlet UIButton *satBtn;

@property(nonatomic,strong) IBOutlet UILabel *totalLbel;
@property(nonatomic,strong) IBOutlet UILabel *clientLbel;

@property(nonatomic,strong) IBOutlet UIImageView *bv;

@property(nonatomic,strong) IBOutlet    UIView  *blueBgView;



@end
