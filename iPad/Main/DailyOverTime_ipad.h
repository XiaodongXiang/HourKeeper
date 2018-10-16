//
//  DailyOverTime_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewClientViewController_ipad.h"


@interface DailyOverTime_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}
//input
@property (nonatomic,strong) NewClientViewController_ipad *taskController;
@property (nonatomic,assign) BOOL isDaily;

@property (nonatomic,strong) IBOutlet UITableViewCell *cell1;
@property (nonatomic,strong) IBOutlet UITableViewCell *cell2;
@property (nonatomic,strong) IBOutlet UITableViewCell *cell3;
@property (nonatomic,strong) IBOutlet UITableViewCell *cell4;
@property (nonatomic,strong) IBOutlet UITextField *afterField11;
@property (nonatomic,strong) IBOutlet UITextField *afterField22;
@property (nonatomic,strong) IBOutlet UITextField *afterField1;
@property (nonatomic,strong) IBOutlet UITextField *afterField2;

@property (nonatomic,strong) IBOutlet UIView *pickView;
@property (nonatomic,strong) IBOutlet UIPickerView *picker;


-(void)doneAndBack;
-(void)initData;



@end

