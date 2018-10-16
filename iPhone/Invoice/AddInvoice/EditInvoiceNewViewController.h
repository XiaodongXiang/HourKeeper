//
//  EditInvoiceNewViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectClientViewController_iphone.h"
#import "SelectLogsViewController.h"
#import "OtherChangeController.h"

#import "Invoice.h"
#import "Clients.h"


/**
    编辑Invoice
 */
@interface EditInvoiceNewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,getSelectClientDelegate,getLogsInClientDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    
}
@property(nonatomic,strong) IBOutlet UITableView *myTableView;
//input
@property(nonatomic,strong) Invoice *myinvoce;
@property(nonatomic,strong) NSString *navi_tittle;
//option
@property(nonatomic,strong) Clients *selectClient;
//选中的log数组
@property(nonatomic,strong) NSMutableArray *jobsList;

@property(nonatomic,strong) IBOutlet UITableViewCell *clientCell;
@property(nonatomic,strong) IBOutlet UILabel *clientLbel;

//选中多少个Log
@property(nonatomic,strong) IBOutlet UITableViewCell *jobsCell;
@property(nonatomic,strong) IBOutlet UILabel *jobsLbel;

@property(nonatomic,strong) IBOutlet UILabel *subtotalLbel;
//总工资字符串（不算加班）
@property(nonatomic,strong) NSString *subtotalStr;

@property(nonatomic,strong) IBOutlet UILabel *overtimeLbel;
//加班工资字符串
@property(nonatomic,strong) NSString *overmoneyStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *discountCell;
@property(nonatomic,strong) IBOutlet UITextField *discountField;
//折扣字符串
@property(nonatomic,strong) NSString *discountStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *taxCell;
@property(nonatomic,strong) IBOutlet UITextField *taxField;
@property(nonatomic,strong) IBOutlet UILabel *taxTipLbel;
@property(nonatomic,strong) NSString *taxStr;
@property(nonatomic,strong) NSString *taxPercentage;

@property(nonatomic,strong) IBOutlet UITableViewCell *otherchargeCell;

//当前页面拥有的otherArray。
//@property(nonatomic,strong) NSMutableArray *otherArray;
@property(nonatomic,strong)NSMutableArray *propertyMutableArray;

@property(nonatomic,strong) IBOutlet UILabel *totalLbel;

@property(nonatomic,strong) NSString *totalStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *paidCell;
@property(nonatomic,strong) IBOutlet UITextField *paidField;
@property(nonatomic,strong) NSString *paidStr;

@property(nonatomic,strong) IBOutlet UILabel *balanceDueLbel;
@property(nonatomic,strong) NSString *balanceDueStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *subjectCell;
@property(nonatomic,strong) IBOutlet UITextField *subjectField;

@property(nonatomic,strong) IBOutlet UITableViewCell *invoiceCell;
@property(nonatomic,strong) IBOutlet UITextField *invoiceField;

@property(nonatomic,strong) IBOutlet UITableViewCell *dueDateCell;
@property(nonatomic,strong) IBOutlet UILabel *dueDateLbel;
@property(nonatomic,strong) NSDate *dueDate;

@property(nonatomic,strong) IBOutlet UITableViewCell *termsCell;
@property(nonatomic,strong) IBOutlet UITextField *termsField;

@property(nonatomic,strong) IBOutlet UITableViewCell *noteCell;
@property(nonatomic,strong) IBOutlet UITextView *noteTextV;
@property(nonatomic,strong) IBOutlet UILabel *noteLbel;

@property (strong, nonatomic) IBOutlet UIView *headview1;
@property (strong, nonatomic) IBOutlet UIView *headview2;
@property (strong, nonatomic) IBOutlet UIView   *footview;

@property (strong, nonatomic) IBOutlet UILabel  *clientlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *entrieslabel1;
@property (strong, nonatomic) IBOutlet UILabel  *subtitallabel1;
@property (strong, nonatomic) IBOutlet UILabel  *overtimelabel1;
@property (strong, nonatomic) IBOutlet UILabel  *discountlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *taxlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *otherlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *totallabel1;
@property (strong, nonatomic) IBOutlet UILabel  *paidlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *balancelabel1;
@property (strong, nonatomic) IBOutlet UILabel  *subjectlabel1;
@property (strong, nonatomic) IBOutlet UILabel  *invoicelabel1;
@property (strong, nonatomic) IBOutlet UILabel  *invoicedatelabel1;
@property (strong, nonatomic) IBOutlet UILabel  *termslabel1;

-(void)back:(BOOL)isDeleteOtherArray;
-(void)saveBack;
-(void)reflashCaculateMoney;
-(void)initInvoiceData;
-(void)doPickerDate;
-(void)downKeyborad;
-(void)saveOtherChange;

@end

