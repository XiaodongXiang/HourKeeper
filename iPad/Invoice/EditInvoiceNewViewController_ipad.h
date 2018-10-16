//
//  EditInvoiceNewViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Invoice.h"
#import "Clients.h"

#import "SelectClientViewController_ipad.h"
#import "SelectLogsViewController_ipad.h"
#import "OtherChangeController.h"



@interface EditInvoiceNewViewController_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,getSelectClientDelegate_ipad,getLogsInClientDelegate_ipad,UITextFieldDelegate,UITextViewDelegate>
{
    
}
@property(nonatomic,strong) IBOutlet UITableView *myTableView;
//input
@property(nonatomic,strong) Invoice *myinvoce;
@property(nonatomic,strong) NSString *navTittle;
//option
@property(nonatomic,strong) Clients *selectClient;
@property(nonatomic,strong) NSMutableArray *jobsList;

@property(nonatomic,strong) IBOutlet UITableViewCell *subjectCell;
@property(nonatomic,strong) IBOutlet UITextField *subjectField;

@property(nonatomic,strong) IBOutlet UITableViewCell *invoiceCell;
@property(nonatomic,strong) IBOutlet UITextField *invoiceField;

@property(nonatomic,strong) IBOutlet UITableViewCell *clientCell;
@property(nonatomic,strong) IBOutlet UILabel *clientLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *jobsCell;
@property(nonatomic,strong) IBOutlet UILabel *jobsLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *subtotalCell;
@property(nonatomic,strong) IBOutlet UILabel *subtotalLbel;
@property(nonatomic,strong) NSString *subtotalStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *discountCell;
@property(nonatomic,strong) IBOutlet UITextField *discountField;
@property(nonatomic,strong) NSString *discountStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *taxCell;
@property(nonatomic,strong) IBOutlet UITextField *taxField;
@property(nonatomic,strong) IBOutlet UILabel *taxTipLbel;
@property(nonatomic,strong) NSString *taxStr;
@property(nonatomic,strong) NSString *taxPercentage;

@property(nonatomic,strong) IBOutlet UITableViewCell *totalCell;
@property(nonatomic,strong) IBOutlet UILabel *totalLbel;
@property(nonatomic,strong) NSString *totalStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *paidCell;
@property(nonatomic,strong) IBOutlet UITextField *paidField;
@property(nonatomic,strong) NSString *paidStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *balanceDueCell;
@property(nonatomic,strong) IBOutlet UILabel *balanceDueLbel;
@property(nonatomic,strong) NSString *balanceDueStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *dueDateCell;
@property(nonatomic,strong) IBOutlet UILabel *dueDateLbel;
@property(nonatomic,strong) NSDate *dueDate;

@property(nonatomic,strong) IBOutlet UITableViewCell *termsCell;
@property(nonatomic,strong) IBOutlet UITextField *termsField;

@property(nonatomic,strong) IBOutlet UITableViewCell *noteCell;
@property(nonatomic,strong) IBOutlet UITextView *noteTextV;
@property(strong,nonatomic) IBOutlet UILabel *noteLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *otherchargeCell;
@property(nonatomic,strong) NSMutableArray *propertyMutableArray;

@property(nonatomic,strong) IBOutlet UITableViewCell *overtimeCell;
@property(nonatomic,strong) IBOutlet UILabel *overtimeLbel;
@property(nonatomic,strong) NSString *overmoneyStr;


-(void)back;
-(void)saveBack;
-(void)reflashCaculateMoney;
-(void)initInvoiceData;
-(void)doPickerDate;
-(void)downKeyborad;
-(void)saveOtherChange;
@end
