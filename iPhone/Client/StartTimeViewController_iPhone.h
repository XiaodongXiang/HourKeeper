//
//  StartTimeViewController_iPhone.h
//  HoursKeeper
//
//  Created by humingjing on 16/4/21.
//
//

@protocol StartTimeViewController_iPhoneDelegate <NSObject>

@optional
- (void)cancelSelectedDate;
- (void)saveSelectedDate:(NSDate *)date;

@end

#import <UIKit/UIKit.h>

@interface StartTimeViewController_iPhone : UIViewController

@property (nonatomic , strong) UIView *contaionView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UIButton *saveBtn;
@property (nonatomic , strong) UIDatePicker *datePicker;

@property (nonatomic , strong) NSDate *minDate;
@property (nonatomic , strong) NSDate *maxDate;
@property (nonatomic , strong) NSDate *inputDate;

@property (nonatomic , weak) id<StartTimeViewController_iPhoneDelegate> delegate;
@end
