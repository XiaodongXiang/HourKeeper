//
//  invoiceShow_Cell.h
//  HoursKeeper
//
//  Created by xy_dev on 5/22/13.
//
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@interface invoiceShow_Cell : UITableViewCell
{
}

@property(nonatomic,strong) UILabel *invoiceNameLbel;
@property(nonatomic,strong) UILabel *clientNameLabel;
@property(nonatomic,strong) HMJLabel *totalMoneyLbel;
@property(nonatomic,strong) UIView  *bottomLine;


@end
