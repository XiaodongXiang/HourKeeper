//
//  CaculateMoney.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-16.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CaculateMoney : NSObject {

}
+(double)allFormularForTime:(double)time
					   AtRate:(double)rate
						AtTax:(double)tax;
+(double)firstFormularForTime:(double)time
                     ForTimeLength:(int)length
                        ForMultiple:(double)multiple
							AtRate:(double)rate
						  AtTax:(double)tax;

+(double)secondFormularForTime:(double)time
				 ForFirstTime:(int)firsttime
				ForSecondTime:(int)secondtime                    
				 ForMultiple1:(double)multiple1
				 ForMultiple2:(double)multiple2
					   AtRate:(double)rate
                       AtTax:(double)tax;
@end
