//
//  HMJLabel.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/23.
//
//

#import <UIKit/UIKit.h>

@interface HMJLabel : UIView

//先设置这六个属性 再setSubView 再setNeedsDisplay


-(void)creatSubViewsisLeftAlignment:(BOOL)isLeft;
-(void)setAmountSize:(int)amountSize pointSize:(int)pointSize Currency:(NSString *)currency Amount:(NSString *)amount color:(UIColor *)color;

@end
