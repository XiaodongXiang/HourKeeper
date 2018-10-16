//
//  SelectLogsViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Clients.h"
#import "Invoice.h"


@protocol getLogsInClientDelegate_ipad <NSObject>

-(void)saveLogsForClient:(NSMutableArray *)_allLogs;

@end





@interface SelectLogsViewController_ipad : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
}

@property(nonatomic,strong) IBOutlet UITableView *tableView;

@property(nonatomic,strong) Invoice *selectInvoice;
@property(nonatomic,strong) Clients *selectClient;;
@property(nonatomic,strong) NSMutableArray *logsList;
@property(nonatomic,strong) NSMutableArray *mylogs;

@property(nonatomic,strong) id<getLogsInClientDelegate_ipad>delegate;


-(void)back;
-(void)saveBack;





@end
