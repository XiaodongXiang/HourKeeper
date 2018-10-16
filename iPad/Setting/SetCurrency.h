//
//  SetCurrency.h
//  HoursKeeper
//
//  Created by xy_dev on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetCurrency : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}

@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSString *selectRowName;

-(void)back;




@end
