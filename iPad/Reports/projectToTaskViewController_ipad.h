//
//  projectToTaskViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface projectToTaskViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate >
{
    NSDateFormatter *pointInTimeDateFormatter;
    NSDateFormatter *dayDateFormatter;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *allLogsList;

@property(nonatomic,strong) NSIndexPath * delete_indexPath;
@property(nonatomic,strong) NSString *navi_tittle;

@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,strong) NSDate *endDate;
@property(nonatomic,assign) NSInteger overTimeStly;



-(void)deletLog_index:(NSIndexPath *)indexPath;

-(IBAction)doOverTimer;


@end
