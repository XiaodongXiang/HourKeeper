//
//  InvoiceCell_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface InvoiceCell_ipad : UITableViewCell
{
}

@property(nonatomic,strong) IBOutlet UILabel *subjectLbel;
@property(nonatomic,strong) IBOutlet HMJLabel *totalMoneyLbel;
@property(nonatomic,strong) IBOutlet UILabel *dateLbel;
@property(nonatomic,strong) IBOutlet UIButton *showBtn;
@property(nonatomic,strong) IBOutlet UIView *allView;
@property(nonatomic,strong) IBOutlet UIButton *isAddBtn;

@property(nonatomic,strong) IBOutlet UILabel *subjectLbel2;
@property(nonatomic,strong) IBOutlet HMJLabel *totalMoneyLbel2;
@property(nonatomic,strong) IBOutlet UILabel *dateLbel2;
@property(nonatomic,strong) IBOutlet UIButton *showBtn2;
@property(nonatomic,strong) IBOutlet UIView *allView2;

@property(nonatomic,strong) IBOutlet UILabel *subjectLbel3;
@property(nonatomic,strong) IBOutlet HMJLabel *totalMoneyLbel3;
@property(nonatomic,strong) IBOutlet UILabel *dateLbel3;
@property(nonatomic,strong) IBOutlet UIButton *showBtn3;
@property(nonatomic,strong) IBOutlet UIView *allView3;



@end
