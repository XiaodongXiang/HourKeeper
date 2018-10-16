//
//  SelectClientViewController_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clients.h"
#import "Logs.h"


/**
    选择Client
 */
@protocol getSelectClientDelegate <NSObject>

-(void)saveSelectClient:(Clients *)_selectClient;

@end


@interface SelectClientViewController_iphone : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}
@property (nonatomic,strong) IBOutlet UITableView           *tableView;

@property (nonatomic,strong) NSMutableArray                 *clientList;
//input
@property (nonatomic,strong) Clients                        *selectClient;
@property (nonatomic,strong) id<getSelectClientDelegate>    delegate;



-(void)initSelectClientView;
-(void)back;



@end
