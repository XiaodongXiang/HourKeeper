//
//  SyncViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 10/9/13.
//
//

#import <UIKit/UIKit.h>

@interface SyncViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}

@property(nonatomic,strong) IBOutlet UISwitch *dropbox_statu;
@property (strong, nonatomic) IBOutlet UIImageView *dropBv;
@property (strong, nonatomic) IBOutlet UIImageView *dropBv2;
@property(nonatomic,strong) IBOutlet UITableViewCell *tipCell;
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (strong, nonatomic) IBOutlet UIView *FreeView;
@property (strong, nonatomic) IBOutlet UILabel *drop_accoutLbel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statu_activty;



-(void)back;
-(IBAction)switchChanged;
-(void)flashView;
- (IBAction)toFullBtn:(id)sender;
-(void)flashView2;

-(void)pop_system_UnlockLite; //统一的 UnLock action 名


@end
