//
//  XDOffClockTableViewCell.h
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/6.
//

#import <UIKit/UIKit.h>

@protocol XDOffClockTableViewDelegate <NSObject>

-(void)returnOffClockClient:(Clients*)client cell:(UITableViewCell*)cell operate:(ClienOperat)clientOperate;

@end

@interface XDOffClockTableViewCell : UITableViewCell

@property(nonatomic, assign)BOOL open;
@property(nonatomic, strong)Clients * clients;

@property(nonatomic, weak)id<XDOffClockTableViewDelegate> xxDelegate;


@end
