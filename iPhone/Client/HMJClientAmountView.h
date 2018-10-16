//
//  HMJClientAmountView.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/26.
//
//

#import <UIKit/UIKit.h>

@interface HMJClientAmountView : UIView

-(void)creatSubViewsisLeftAlignment:(BOOL)isLeft;
-(void)setAmountSize:(int)amountSize pointSize:(int)pointSize hourSize:(int)perHourSize Currency:(NSString *)currency Amount:(NSString *)amount color:(UIColor *)color;

@end
