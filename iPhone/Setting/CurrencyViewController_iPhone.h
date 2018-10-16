//
//  CurrencyViewController_iPhone.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-30.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController_New.h"
#import "Settings.h"

@interface CurrencyViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}

@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSString *selectRowName;

-(void)back;


@end
