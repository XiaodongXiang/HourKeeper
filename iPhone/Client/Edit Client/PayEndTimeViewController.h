//
//  PayEndTimeViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//

#import <UIKit/UIKit.h>

@class NewClientViewController_iphone;
@class NewClientViewController_ipad;



/**
    Bi-Weekly,Every Four Weeks,Quarterly支付日期类型，只有一个时间
 */
@interface PayEndTimeViewController : UIViewController
{
}

@property (nonatomic,strong) IBOutlet UIDatePicker          *datePicker;

//input
@property (nonatomic,strong) NewClientViewController_iphone *clientDelegate;
@property (nonatomic,strong) NewClientViewController_ipad   *clientDelegate_ipad;
@property (nonatomic,assign) int                            payStly;

-(void)done;
-(void)back;

@end
