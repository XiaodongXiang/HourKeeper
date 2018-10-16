//
//  CaculateMoney.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-16.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "CaculateMoney.h"


@implementation CaculateMoney

/**
    获取除掉报销部分的工资
 */
+(double) allFormularForTime:(double)time AtRate:(double)rate AtTax:(double)tax
{
	return time*rate*(1-tax);
}
/**
    获取加班工资1
 */
+(double) firstFormularForTime:(double)time ForTimeLength:(int)length ForMultiple:(double)multiple AtRate:(double)rate AtTax:(double)tax
{
	return (time-length)*(multiple-1)*rate*(1-tax);
}

/**
    获取加班工资2
 */
+(double) secondFormularForTime:(double)time ForFirstTime:(int)firsttime ForSecondTime:(int)secondtime ForMultiple1:(double)multiple1 ForMultiple2:(double)multiple2 AtRate:(double)rate AtTax:(double)tax
{
	if (secondtime<firsttime)
    {
		return ((firsttime - secondtime)*(multiple2 - 1) + (time-firsttime)*(multiple2 - multiple1))*rate*(1-tax);
	}
    else
    {
		return (time-secondtime)*(multiple2 - multiple1)*rate*(1-tax);
	}
}

@end
