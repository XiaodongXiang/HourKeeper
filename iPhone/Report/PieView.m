//
//  PieView.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-2-8.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "PieView.h"


@implementation PieView
@synthesize percentArray;




int redList2[11] =   {14,2,0,19,83,118,148,202,175,202,253};
int greenList2[11] = {142,158,183,196,198,208,215,234,205,213,232};
int blueList2[11] = {192,223,241,234,222,225,227,231,216,217,220};



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.

    }
    return self;
}
- (id)init
{
	m_pieCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //    m_r = 68.5;
	m_r = 63;
	percentArray = [[NSMutableArray alloc] init];

	return self;
}

-(void)initPoint
{
    m_pieCenter = CGPointMake(SCREEN_WITH/2, self.frame.size.height/2);
//    m_r = 68.5;
    m_r = 63;

    percentArray = [[NSMutableArray alloc] init];
}


-(void)init_ipad
{
    m_pieCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	m_r = self.frame.size.width/2;
	percentArray = [[NSMutableArray alloc] init];
}


- (void) drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
    CGContextSaveGState(context);
    
    float startAngle = 0.0;
    for (int i = 0; i<[self.percentArray count]; i++) 
    {
        float a=0.0;
        float b=0.0;
        float c=0.0;
        
        a = redList2[i%11]/255.0;
        b = greenList2[i%11]/255.0;
        c = blueList2[i%11]/255.0;
        CGContextSetRGBFillColor(context, a, b,c, 0.7);
        
        NSString *percentStr = [self.percentArray objectAtIndex:i];
        float percentage = [percentStr  doubleValue]/100;
        CGContextMoveToPoint(context, m_pieCenter.x, m_pieCenter.y);
        CGContextAddArc(context, m_pieCenter.x, m_pieCenter.y, m_r, startAngle, startAngle + 2*M_PI*percentage, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        startAngle = startAngle + 2*M_PI*percentage;
    }
    CGContextRestoreGState(context);
    
}



- (void)drawMyView:(NSMutableArray *)myArray
{
    self.alpha = 1;
	[percentArray removeAllObjects];
	[percentArray addObjectsFromArray:myArray];
	[self setNeedsDisplay];

}


@end
