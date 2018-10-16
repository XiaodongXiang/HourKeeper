//
//  DashBoardViewController.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import <UIKit/UIKit.h>
#import "Clients.h"
#import "TimerStartViewController.h"


@interface DashBoardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong) NSTimer                 *myTimer;
@property(nonatomic,strong)Clients                  *deleteClient;
@property(nonatomic,weak)IBOutlet   UIImageView     *noClockImageView;
@property (weak, nonatomic) IBOutlet UITableView    *myTableView;
@property (strong,nonatomic)NSMutableArray          *clientArray;
@property(nonatomic,strong)NSIndexPath              *swipCellIndex;
@property(nonatomic,strong)TimerStartViewController *timerstartVC;

//广告btn
@property(nonatomic,strong) IBOutlet UIButton *lite_Btn;

@property(nonatomic,weak)IBOutlet UIImageView   *tipImageView;



-(void)cancelSelectedCellDeleteState;
-(void)pop_system_UnlockLite;


-(void)getClientArray;

@end
