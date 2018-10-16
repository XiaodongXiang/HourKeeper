//
//  EditLogViewController_new.h
//  HoursKeeper
//
//  Created by xy_dev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
    编辑一个已经存在的log,可以支付这个log
 */
#import <UIKit/UIKit.h>

#import "Logs.h"


@interface EditLogViewController_new : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}
//input
@property(nonatomic,strong) Logs                        *selectLog;

@property(nonatomic,strong) IBOutlet UITableView        *myTableView;

@property(nonatomic,strong) IBOutlet UITableViewCell    *rateCell;
@property(nonatomic,strong) IBOutlet UITextField        *rateField;
@property(nonatomic,strong) NSString                    *rateStr;

@property(nonatomic,strong) IBOutlet UITableViewCell    *startDateCell;
@property(nonatomic,strong) IBOutlet UILabel            *startDateLbel;
@property(nonatomic,strong) NSDate                      *startDate;

@property(nonatomic,strong) IBOutlet UITableViewCell    *endDateCell;
@property(nonatomic,strong) IBOutlet UILabel            *endDateLbel;
@property(nonatomic,strong) NSDate                      *endDate;

@property(nonatomic,strong) IBOutlet UITableViewCell    *timeWorkCell;
@property(nonatomic,strong) IBOutlet UILabel            *timeWorkLbel;
@property(nonatomic,strong) NSString                    *m_timeStr;

@property(nonatomic,strong) IBOutlet UITableViewCell    *breakTimeCell;
@property(nonatomic,strong) IBOutlet UILabel            *breakTimeLbel;
@property(nonatomic,strong) NSString                    *m_breakStr;

@property(nonatomic,strong) IBOutlet UITableViewCell    *taxCell;
@property(nonatomic,strong) IBOutlet UISwitch           *taxSwitch;

@property(nonatomic,strong) IBOutlet UITableViewCell    *noteCell;
@property(nonatomic,strong) IBOutlet UITextView         *noteTextV;
@property(strong,nonatomic) IBOutlet UILabel            *noteLabel;

@property(nonatomic,strong) IBOutlet UIView             *headView;
@property(nonatomic,strong) IBOutlet UIView             *footView;
@property(nonatomic,strong) IBOutlet UIButton           *paidBtn;
@property(nonatomic,assign) int                         isPaid;

@property(nonatomic,strong) IBOutlet UILabel            *ratePerHourLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *startLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *endLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *duationLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *breaktimeLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *overtimeLabel1;



-(void)back;
-(void)saveBack;

-(IBAction)Dopaid:(UIButton *)sender;
-(IBAction)Dodelete:(UIButton *)sender;

-(void)doPickerDate;
-(void)doPIckerView:(NSString *)pickerStr;

-(void)downKeyBroad;


@end
