//
//  SelectClientViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clients.h"
#import "Logs.h"





@protocol getSelectClientDelegate_ipad <NSObject>

-(void)saveSelectClient:(Clients *)_selectClient;

@end


@interface SelectClientViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;

//input
@property (nonatomic,strong) Clients *selectClient;
@property (nonatomic,strong) id<getSelectClientDelegate_ipad> delegate;

@property (nonatomic,strong) NSMutableArray *clientList;


-(void)initSelectClientView;

-(void)back;




@end
