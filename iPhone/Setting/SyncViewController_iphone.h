//
//  SyncViewController_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 10/21/13.
//
//

#import <UIKit/UIKit.h>

@interface SyncViewController_iphone : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isAutoSync;
}



-(void)back;
//-(IBAction)switchChanged;
-(void)flashView;
//- (IBAction)toFullBtn:(id)sender;
-(void)flashView2;

-(void)pop_system_UnlockLite; //统一的 UnLock action 名

@end
