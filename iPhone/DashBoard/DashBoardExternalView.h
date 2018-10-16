//
//  DashBoardExternalView.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/1.
//
//

#import <UIKit/UIKit.h>

@interface DashBoardExternalView : UIView

@property(nonatomic,assign)long totalTime;
@property(nonatomic,assign)long currentTime;
@property (nonatomic,strong)UIImageView *internalImageView;

//对应client没有计时的时候是灰色的
@property(nonatomic,assign)BOOL isGray;
@end
