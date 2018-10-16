//
//  PayEndFlagViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//

/**
    不需要具体时间的Pay Period选项
 */
#import <UIKit/UIKit.h>

@class NewClientViewController_iphone;
@class NewClientViewController_ipad;




@interface PayEndFlagViewController  : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
}
//input
@property (nonatomic,strong) NewClientViewController_iphone *clientDelegate;
@property (nonatomic,strong) NewClientViewController_ipad   *clientDelegate_ipad;
//选择的支付时间类型
@property (nonatomic,assign) int                            payStly;

@property (nonatomic,strong) IBOutlet UIPickerView          *pickView;

//picker的两个数据源
@property (nonatomic,strong) NSMutableArray                 *firstArray;
@property (nonatomic,strong) NSMutableArray                 *secondArray;

@property (nonatomic,strong) IBOutlet UILabel               *firstLbel;
@property (nonatomic,strong) IBOutlet UILabel               *secondLbel;
@property (nonatomic,strong) IBOutlet UILabel               *tipLbel;

//选择的两个数字
@property (nonatomic,assign) int                            payPeriodNum1;
@property (nonatomic,assign) int                            payPeriodNum2;



-(void)back;
-(void)backAndSave;


@end

