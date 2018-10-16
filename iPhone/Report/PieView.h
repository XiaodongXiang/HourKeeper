//
//  PieView.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-2-8.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PieView : UIView 
{
	NSMutableArray *percentArray;
	CGPoint m_pieCenter;
    float m_r;
}
@property (nonatomic,strong) NSMutableArray *percentArray;


- (void)drawMyView:(NSMutableArray *)myArray;
-(void)init_ipad;
-(void)initPoint;

@end
