//
//  XDDashBoardTableViewCell.h
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/1.
//

#import <UIKit/UIKit.h>

@protocol XDDashBoardTableViewCellDelegate <NSObject>

-(void)returnClientOperate:(ClienOperat)clientOperate client:(Clients*)client cell:(UITableViewCell*)currentCell;

@end


@interface XDDashBoardTableViewCell : UITableViewCell

@property(nonatomic, assign)BOOL open;
@property(nonatomic, strong)Clients * clients;

@property(nonatomic, weak)id<XDDashBoardTableViewCellDelegate> xxDelegate;

@end
