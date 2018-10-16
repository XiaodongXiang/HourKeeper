//
//  EditLogViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Logs.h"



@interface EditLogViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
}
//input
@property(nonatomic,strong) Logs *selectLog;

@property(nonatomic,strong) IBOutlet UITableView *tableView;

@property(nonatomic,strong) IBOutlet UITableViewCell *startDateCell;
@property(nonatomic,strong) IBOutlet UILabel *startDateLbel;
@property(nonatomic,strong) NSDate *startDate;

@property(nonatomic,strong) IBOutlet UITableViewCell *endDateCell;
@property(nonatomic,strong) IBOutlet UILabel *endDateLbel;
@property(nonatomic,strong) NSDate *endDate;

@property(nonatomic,strong) IBOutlet UITableViewCell *timeWorkCell;
@property(nonatomic,strong) IBOutlet UILabel *timeWorkLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *rateCell;
@property(nonatomic,strong) IBOutlet UITextField *rateField;
@property(nonatomic,strong) NSString *rateStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *noteCell;
@property(nonatomic,strong) IBOutlet UITextView *noteTextV;
@property(strong,nonatomic) IBOutlet UILabel *noteLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *breakTimeCell;
@property(nonatomic,strong) IBOutlet UILabel *breakTimeLbel;

@property(nonatomic,strong)IBOutlet UITableViewCell *actionCell;
@property(nonatomic,strong)IBOutlet UIButton *paidBtn;
@property(nonatomic,assign)int isPaid;

@property(nonatomic,strong) IBOutlet UITableViewCell *tipCell;

@property(nonatomic,strong) IBOutlet UITableViewCell *taxCell;
@property(nonatomic,strong) IBOutlet UISwitch *taxSwitch;

@property(nonatomic,strong) NSString *m_timeStr;
@property(nonatomic,strong) NSString *m_breakStr;


-(void)back;
-(void)saveBack;

-(IBAction)Dopaid:(UIButton *)sender;
-(IBAction)Dodelete:(UIButton *)sender;

-(void)doPickerDate;
-(void)doPIckerView:(NSString *)pickerStr;

-(void)downKeyBroad;

@end

