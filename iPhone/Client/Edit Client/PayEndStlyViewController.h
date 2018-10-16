//
//  PayEndStlyViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//


/**
    Pay Period页面
 */
#import <UIKit/UIKit.h>

@class NewClientViewController_iphone;
@class NewClientViewController_ipad;




@interface PayEndStlyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

}
@property (nonatomic,strong) IBOutlet UITableView           *myTableView;
@property (nonatomic,strong) NSMutableArray                 *payStlyArray;

//支付时间类型
@property (nonatomic,assign) int                            selectStly;
@property (nonatomic,strong) NewClientViewController_iphone *clientDelegate;
@property (nonatomic,strong) NewClientViewController_ipad   *clientDelegate_ipad;


-(void)back;



@end
