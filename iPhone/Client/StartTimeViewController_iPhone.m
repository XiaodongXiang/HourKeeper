//
//  StartTimeViewController_iPhone.m
//  HoursKeeper
//
//  Created by humingjing on 16/4/21.
//
//

#import "StartTimeViewController_iPhone.h"

@implementation StartTimeViewController_iPhone


//弹框高度
#define CONTENTVIEW_HEIGH 260
#define PICKERVIEW_HEIGH    216

#define BTN_LEFT_MARGIN 0
#define BTN_HEIGH       44
#define BTN_WITH        90

- (UIView *)contaionView
{
    if (_contaionView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - CONTENTVIEW_HEIGH, SCREEN_WITH, CONTENTVIEW_HEIGH)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        _contaionView = view;
    }
    
    return _contaionView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, BTN_HEIGH)];
        [label setTextColor:[UIColor blackColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
		[label setFont:[UIFont boldSystemFontOfSize:15]];
        [self.contaionView addSubview:label];
        _titleLabel = label;
    }
    
    return _titleLabel;
}

- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(BTN_LEFT_MARGIN, 0, BTN_WITH, BTN_HEIGH);
        [btn setTitle:@"Cancel" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor grayColor]];
        [btn addTarget:self action:@selector(cancelSelectedDate) forControlEvents:UIControlEventTouchUpInside];
        [self.contaionView addSubview:btn];
        _cancelBtn = btn;
    }
    
    return _cancelBtn;
}

-(UIButton *)saveBtn
{
    if (_saveBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
		[btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        int left = SCREEN_WITH - BTN_LEFT_MARGIN - BTN_WITH;
        btn.frame = CGRectMake(left, 0, BTN_WITH, BTN_HEIGH);
        [btn setTitle:@"Save" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor grayColor]];
        [btn addTarget:self action:@selector(saveSelectedDate) forControlEvents:UIControlEventTouchUpInside];
        [self.contaionView addSubview:btn];
        _saveBtn = btn;
    }
    return _saveBtn;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker==nil) {
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.contaionView.height - PICKERVIEW_HEIGH, SCREEN_WITH, PICKERVIEW_HEIGH)];
        [self.contaionView addSubview:picker];
        _datePicker = picker;
    }
    
    return _datePicker;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    [self contaionView];
    [self cancelBtn];
    [self saveBtn];
    [self datePicker];
    
    self.datePicker.date = self.inputDate;
    self.datePicker.maximumDate = self.maxDate;
    self.datePicker.minimumDate = self.minDate;
}

- (void)cancelSelectedDate
{
//    [self.delegate cancelSelectedDate];
    
    [self.view removeFromSuperview];
}

- (void)saveSelectedDate
{
    [self.delegate saveSelectedDate:self.datePicker.date];
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
