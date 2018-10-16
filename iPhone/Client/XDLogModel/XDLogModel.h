//
//  XDLogModel.h
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/8.
//

#import <Foundation/Foundation.h>
#import "Logs.h"

@interface XDLogModel : NSObject

@property(nonatomic, strong)Clients * client;
@property(nonatomic, strong)Logs * log;
@property(nonatomic, assign)float totalAmount;
@property(nonatomic, assign)float overTime;
@property(nonatomic, strong)NSDate* startTime;

@end
