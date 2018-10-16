//
//  CurrencyViewController_iPhone.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-30.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getTimeRoundDelegate <NSObject>

-(void)saveTimeRound:(NSString *)timeRoundStr;

@end


/**
    Time round VC
 */
@interface TimeViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

}

@property (nonatomic,strong) IBOutlet UITableView       *myTableView;

@property (nonatomic,strong) NSMutableArray             *timeArray;
@property (nonatomic,strong) NSString                   *selectRowName;
@property (nonatomic,strong) id<getTimeRoundDelegate>   delegate;

-(void)back;


@end
