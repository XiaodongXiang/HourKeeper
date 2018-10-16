//
//  ExportSelectClient_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 5/16/13.
//
//

#import <UIKit/UIKit.h>



@protocol getExportClientDelegate_ipad <NSObject>

-(void)saveExportClient:(NSMutableArray *)_allClients SelectStly:(BOOL)_isAll;

@end



@interface ExportSelectClient_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}

@property(nonatomic,strong) IBOutlet UITableView *myTableView;

@property(nonatomic,assign) BOOL isAll;
@property(nonatomic,strong) NSMutableArray *clientList;
@property(nonatomic,strong) NSMutableArray *myclients;

@property(nonatomic,strong) id<getExportClientDelegate_ipad> delegate;


-(void)back;
-(void)saveBack;
-(void)initClientData:(NSMutableArray *)_clientArray SelectStly:(BOOL)_isAll;



@end



