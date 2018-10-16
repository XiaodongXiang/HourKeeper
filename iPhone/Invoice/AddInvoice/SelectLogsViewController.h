//
//  SelectLogsViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Clients.h"
#import "Invoice.h"

/**
    选择某些log然后制作一个Invoice出来。Log的选择页面
 */
@protocol getLogsInClientDelegate <NSObject>

-(void)saveLogsForClient:(NSMutableArray *)_allLogs;

@end



@interface SelectLogsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}

@property(nonatomic,strong) IBOutlet UITableView *tableView;

//???
@property(nonatomic,strong) Invoice *selectInvoice;
//???
@property(nonatomic,strong) Clients *selectClient;
//存放当前选中的client下 存在的log
@property(nonatomic,strong) NSMutableArray *logsList;
//选中的log数组
@property(nonatomic,strong) NSMutableArray *mylogs;

//input
@property(nonatomic,strong) id<getLogsInClientDelegate>delegate;
//option ???
@property(nonatomic,assign) BOOL isLogFirst;

//???
-(void)cancel;
-(void)back;
-(void)saveBack;



@end
