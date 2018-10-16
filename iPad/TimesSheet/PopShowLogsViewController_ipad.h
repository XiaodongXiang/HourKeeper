//
//  PopShowLogsViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Logs.h"
#import "Clients.h"



@interface PopShowLogsViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate >
{
    NSDateFormatter *pointInTimeDateFormatter;
    NSDateFormatter *dayDateFormatter;
}

@property(nonatomic,strong) IBOutlet UITableView *myTableView;

//input
@property(nonatomic,strong) NSMutableArray *logsList;
@property(nonatomic,assign) NSInteger showStly;            //  0 clientName;  1 date;
//option
@property(nonatomic,strong) Clients *myClient;

@property(nonatomic,strong) UIButton *editButton;
@property(nonatomic,strong) NSIndexPath * delete_indexPath;

@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSDate *endDate;
@property(nonatomic,assign) NSInteger overTimeStly;



-(void)doEdit;
-(void)doAdd;
-(void)deletLog_index:(NSIndexPath *)indexPath;
-(IBAction)doOverTimer;


@end
