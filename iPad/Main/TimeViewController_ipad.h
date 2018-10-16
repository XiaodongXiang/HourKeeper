//
//  TimeViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/**
    新建Client的Time Round 页面
 */
#import <UIKit/UIKit.h>


@protocol getTimeRoundDelegate_ipad <NSObject>

-(void)saveTimeRound:(NSString *)timeRoundStr;

@end




@interface TimeViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}

@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSString *selectRowName;

@property (nonatomic,strong) id<getTimeRoundDelegate_ipad> delegate;

-(void)back;




@end
