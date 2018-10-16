//
//  StartTimeViewController.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-17.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getStartTimeDate <NSObject>

-(void)saveStartTimeDate:(NSDate *)_startDate;

@end


/**
    ipad中client info页面的startat按钮界面
 */
@interface StartTimeViewController : UIViewController
{
}
//input
@property (nonatomic,strong) id<getStartTimeDate> delegate;
@property (nonatomic,strong) NSDate *inputDate;
@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSDate *maxDate;
@property (nonatomic,strong) NSString *naiv_tittle;

@property (nonatomic,strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong) IBOutlet UILabel *dateTipLbel;
@property (nonatomic,strong) IBOutlet UIView *ipadView;



- (void)done;
-(void)back;
-(IBAction)dateChange;


@end
