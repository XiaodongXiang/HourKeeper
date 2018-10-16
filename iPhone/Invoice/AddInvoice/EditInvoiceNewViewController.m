//
//  EditInvoiceNewViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditInvoiceNewViewController.h"
#import "Logs.h"
#import "AppDelegate_Shared.h"
#import "invpropertyCell.h"
#import "Invoiceproperty.h"
#import "HMJInviocePropertyObject.h"


@interface EditInvoiceNewViewController()
{
    UITextField *currentField;
    
    //是编辑一个Invoice还是新建一个Invoice
    BOOL isEditStatus;
    
    int exportRow;   // 0: 空;  1:invoice date;
    UIDatePicker *sel_datePicker1;
    
    float keyHigh;
}
@end




@implementation EditInvoiceNewViewController


#pragma mark  Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       _jobsList = [[NSMutableArray alloc] init];
       _selectClient = nil;
//       _otherArray = [[NSMutableArray alloc] init];
        _propertyMutableArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPoint];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    if (sel_datePicker1 == nil)
    {
        sel_datePicker1 = [[UIDatePicker alloc] init];
        sel_datePicker1.frame = CGRectMake(0, 44, self.view.frame.size.width, 216);
        [sel_datePicker1 setDatePickerMode:UIDatePickerModeDate];
        [self.dueDateCell addSubview:sel_datePicker1];
        [sel_datePicker1 addTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}









#pragma mark -
#pragma mark  Save & Back
-(void)initPoint
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    //save btn
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    //left btn
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = appDelegate.naviFont;
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:leftButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:self.navi_tittle];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    
    exportRow = 0;
    sel_datePicker1 = nil;
    keyHigh = 286;
    
    [self initInvoiceData];
    
    
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
        self.clientlabel1.left = left;
        self.entrieslabel1.left = left;
        
        self.subtitallabel1.left = left;
        self.overtimelabel1.left = left;
        self.discountlabel1.left = left;
        self.taxlabel1.left = left;
        self.otherlabel1.left = left;
        self.totallabel1.left = left;
        self.paidlabel1.left = left;
        self.balancelabel1.left = left;
        
        self.subjectlabel1.left = left;
        self.invoicedatelabel1.left = left;
        self.invoicelabel1.left = left;
        self.termslabel1.left = left;
        
        self.noteLbel.left = self.noteLbel.left + 5;
        self.noteTextV.left = self.noteTextV.left = 5;
        
        
        self.discountField.left = self.discountField.left - 5;
        self.taxTipLbel.left = self.taxTipLbel.left - 5;
        self.taxField.left = self.taxField.left - 5;
        self.paidField.left = self.paidField.left - 5;
        self.subjectField.left = self.subjectField.left - 5;
        self.invoiceField.left = self.invoiceField.left - 5;
        self.dueDateLbel.left = self.dueDateLbel.left - 5;
        self.termsField.left = self.termsField.left - 5;
        self.subtotalLbel.left = self.subtotalLbel.left - 5;
        self.overtimeLbel.left =self.overtimeLbel.left - 5;
        self.totalLbel.left = self.totalLbel.left - 5;
        self.balanceDueLbel.left = self.balanceDueLbel.left - 5;
        
    }
    
    self.noteTextV.width = SCREEN_WITH - self.noteTextV.left*2;
    

}
/*
 初始化该Invoice显示的内容
 */
-(void)initInvoiceData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //新建一个Invoice
    if (self.myinvoce == nil || self.myinvoce.title == nil)
    {
        isEditStatus = NO;
        
        self.subtotalStr = ZERO_NUM;
        self.discountStr = ZERO_NUM;
        self.taxStr = ZERO_NUM;
        self.taxPercentage = ZERO_NUM;
        self.totalStr = ZERO_NUM;
        self.paidStr = ZERO_NUM;
        self.balanceDueStr = ZERO_NUM;
        
        if (self.selectClient != nil)
        {
            self.clientLbel.text = self.selectClient.clientName;
        }
        else
        {
            self.clientLbel.text = @"";
        }
        self.jobsLbel.text = [NSString stringWithFormat:@"%d",(int)[self.jobsList count]];
        self.invoiceField.text = @"1";
        self.subjectField.text = @"New Invoice";
        
        //获取Invoice表单内所有状态为存在的Invocie数据
        NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
        
        //给InvoiceNO自动填充，填充为数据表中最后一个Invocie的NO+1
        for (Invoice *sel_invoice in requests)
        {
            if (sel_invoice.invoiceNO != nil && ![sel_invoice.invoiceNO isEqualToString:@""])
            {
                self.invoiceField.text = [NSString stringWithFormat:@"%d",sel_invoice.invoiceNO.intValue+1];
                break;
            }
        }
        
        self.dueDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        self.dueDateLbel.text = [dateFormatter stringFromDate:self.dueDate];
        self.termsField.text = @"";
        self.noteTextV.text = @"";
    }
    else
    {
        isEditStatus = YES;
        
        self.subjectField.text = self.myinvoce.title;
        self.invoiceField.text = self.myinvoce.invoiceNO;
        
        self.selectClient = self.myinvoce.client;
        self.clientLbel.text = self.myinvoce.client.clientName;
        
        //jobList 为 当前Invoice下存在的log的数组
        [self.jobsList addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.myinvoce.logs allObjects]]];
        self.jobsLbel.text = [NSString stringWithFormat:@"%d",(int)[self.jobsList count]];
        
        //初始化所有存在的property,放到一个数组中备用
        for (int i=0; i<[[self.myinvoce.invoicepropertys allObjects]count]; i++)
        {
            Invoiceproperty *oneInvoiceProperty = [[self.myinvoce.invoicepropertys allObjects]objectAtIndex:i];
            if ([oneInvoiceProperty.sync_status intValue]==0)
            {
                HMJInviocePropertyObject *oneproperty = [[HMJInviocePropertyObject alloc]init];
                oneproperty.name = oneInvoiceProperty.name;
                oneproperty.quantity = oneInvoiceProperty.quantity;
                NSString *amountString = [appDelegate.nomalClass changeStringtoDoubleString:oneInvoiceProperty.price];
                oneproperty.price = amountString;
                oneproperty.tax = oneInvoiceProperty.tax;
                oneproperty.uuid = oneInvoiceProperty.uuid;
                [self.propertyMutableArray addObject:oneproperty];
            }
        }
        
        self.subtotalStr = self.myinvoce.subtotal;
        self.discountStr = self.myinvoce.discount;
        self.taxPercentage = self.myinvoce.tax;
        self.totalStr = self.myinvoce.totalDue;
        self.paidStr = self.myinvoce.paidDue;
        self.balanceDueStr = self.myinvoce.balanceDue;
        
        self.dueDate = self.myinvoce.dueDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        self.dueDateLbel.text = [dateFormatter stringFromDate:self.myinvoce.dueDate];
        self.termsField.text = self.myinvoce.terms;
        self.noteTextV.text = self.myinvoce.message;
    }
    //计算这个账单总的金额
    [self reflashCaculateMoney];
    
    [self.taxTipLbel setHidden:YES];
    if ([self.noteTextV.text isEqualToString:@""])
    {
        [self.noteLbel setHidden:NO];
    }
    else
    {
        [self.noteLbel setHidden:YES];
    }
    
    [self.myTableView reloadData];
}
-(void)back:(BOOL)isDeleteOtherArray
{
    //hmj delete more
//    AppDelegate_Shared *appdelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    [appdelegate databaseRollback];
    
    if (isDeleteOtherArray)
    {
        //hmj delete
//        AppDelegate_Shared *appdelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//        NSError *error = nil;
//        for(int i=0;i<[_otherArray count];i++)
//        {
//            [appdelegate.managedObjectContext deleteObject:[_otherArray objectAtIndex:i]];
//        }
//        [appdelegate.managedObjectContext save:&error];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
    save 功能
 */
-(void)saveBack
{
    if (isEditStatus == YES)
    {
        if (self.myinvoce.title == nil)
        {
            [self back:YES];
            return;
        }
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSArray *last_logsArray = [appDelegate removeAlready_DeleteLog:self.jobsList];
    
    //hmj delete
//    NSArray *last_otherArray = [appDelegate removeAlready_DeleteInvpty:self.otherArray];
    
    if ([self.subjectField.text isEqualToString:@""] || self.selectClient == nil || self.selectClient.clientName == nil || [last_logsArray count] == 0)
    {
        if (self.selectClient == nil || self.selectClient.clientName == nil)
        {
            self.selectClient = nil;
            self.clientLbel.text = @"";
            
            self.jobsLbel.text = @"0";
            [self.jobsList removeAllObjects];
            
            [self reflashCaculateMoney];
        }
        
        
        if ([last_logsArray count] == 0)
        {
            self.jobsLbel.text = @"0";
            [self.jobsList removeAllObjects];
            
            [self reflashCaculateMoney];
        }
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"'Subject','Client' and 'job' are needed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
        
        appDelegate.close_PopView = alertView;
        
    }
    else
    {
        [self.jobsList removeAllObjects];
        [self.jobsList addObjectsFromArray:last_logsArray];
        
        [self reflashCaculateMoney];
        
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        //syncing
        NSMutableArray *needParseSyncArray = [[NSMutableArray alloc]init];

        if (self.myinvoce == nil)
        {
            self.myinvoce = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:context];
            self.myinvoce.sync_status = [NSNumber numberWithInteger:0];
            self.myinvoce.uuid = [appDelegate getUuid];
        }
        else 
        {
            if ([[self.myinvoce.logs allObjects] count] > 0)
            {
                [needParseSyncArray addObjectsFromArray:[self.myinvoce.logs allObjects]];
            }
            if ([[self.myinvoce.invoicepropertys allObjects] count] > 0)
            {
                [needParseSyncArray addObjectsFromArray:[self.myinvoce.invoicepropertys allObjects]];
            }
            
            //删除原先的log关联的invoice，再重新关联
            NSArray *logsArray = [appDelegate removeAlready_DeleteLog:[self.myinvoce.logs allObjects]];
            
            for (int i=0; i<[logsArray count]; i++)
            {
                Logs *sel_log = [logsArray objectAtIndex:i];
                sel_log.isInvoice = [NSNumber numberWithBool:NO];
                sel_log.isPaid = [NSNumber numberWithInt:0];
                
                sel_log.invoice_uuid = nil;
                sel_log.accessDate = [NSDate date];
                [sel_log removeInvoiceObject:self.myinvoce];
            }

        }
        
        
        self.myinvoce.accessDate = [NSDate date];
        self.myinvoce.parentUuid = self.selectClient.uuid;
        
        //subject
        self.myinvoce.title = self.subjectField.text;
        //invoice的小标记 invoice#
        self.myinvoce.invoiceNO = self.invoiceField.text;
        self.myinvoce.client = self.selectClient;
        
        //log
        NSNumber *paid;
        if ([self.balanceDueStr doubleValue] <= 0)
        {
            paid = [NSNumber numberWithInt:1];
        }
        else
        {
            paid = [NSNumber numberWithInt:0];
        }
        
        //添加新的log关联
        for (int i=0;i<[self.jobsList count];i++)
        {
            Logs *_log = [self.jobsList objectAtIndex:i];
            //标记是不是已经出过账单了
            _log.isInvoice = [NSNumber numberWithBool:YES];
            //给log添加invoice的时候，就代表这个log支付过了
            _log.isPaid = paid;
            
            _log.accessDate = [NSDate date];
            _log.invoice_uuid = self.myinvoce.uuid;
            
            //给log添加唯一的Invocie,所以是一个log对应一个Invocie,一个Invoice可以对应多个log的关系
            if (_log.invoice != nil && [_log.invoice allObjects] > 0)
            {
                [_log removeInvoice:_log.invoice];
            }
            [_log addInvoiceObject:self.myinvoce];

            
            if ([needParseSyncArray containsObject:_log] == NO)
            {
                [needParseSyncArray addObject:_log];
            }
        }
        //invoice对应很多logs
        self.myinvoce.logs = [NSSet setWithArray:self.jobsList];

        
        
        
        self.myinvoce.subtotal = self.subtotalStr;
        self.myinvoce.discount = self.discountStr;
        self.myinvoce.tax = self.taxPercentage;
        self.myinvoce.totalDue = self.totalStr;
        self.myinvoce.paidDue = self.paidStr;
        self.myinvoce.balanceDue = self.balanceDueStr;
        
        self.myinvoce.dueDate = self.dueDate;
        self.myinvoce.terms = self.termsField.text;
        self.myinvoce.message = self.noteTextV.text;
        [context save:nil];
        
        //先上传Invoice
        [appDelegate.parseSync updateInvoiceFromLocal:self.myinvoce];
        
        //再上传log
        for (id oneObject in needParseSyncArray)
        {
            
            if ([oneObject isKindOfClass:[Logs class]])
            {
                [appDelegate.parseSync updateLogFromLocal:oneObject];
            }
        }

        for (int i=0; i<[[self.myinvoce.invoicepropertys allObjects]count]; i++)
        {
            Invoiceproperty *oneproperty = [[self.myinvoce.invoicepropertys allObjects]objectAtIndex:i];
            if ([oneproperty.sync_status intValue]==0)
            {
                BOOL hasFound = NO;
                for (int m=0; m<[self.propertyMutableArray count]; m++)
                {
                    HMJInviocePropertyObject *propertyObject = [self.propertyMutableArray objectAtIndex:m];
                    if (oneproperty.uuid == propertyObject.uuid)
                    {
                        hasFound = YES;
                    }
                }
                
                //没发现，这个invoice已经被删除.
                if (!hasFound)
                {
                    oneproperty.sync_status = [NSNumber numberWithInt:1];
                    oneproperty.accessDate = [NSDate date];
                    [oneproperty.managedObjectContext save:nil];
                    [appDelegate.parseSync updateInvoicePropertyFromLocal:oneproperty];
                }
            }
            
        }
        
        
        //添加新的invoiceProperty
        for (int i=0; i<[self.propertyMutableArray count]; i++)
        {
            HMJInviocePropertyObject *sel_invpty = [self.propertyMutableArray objectAtIndex:i];
            
            BOOL hasFound = NO;
            for (int m=0; m<[[self.myinvoce.invoicepropertys allObjects] count]; m++)
            {
                Invoiceproperty *oneProperty = [[self.myinvoce.invoicepropertys allObjects]objectAtIndex:m];
                if (oneProperty.uuid == sel_invpty.uuid)
                {
                    oneProperty.name = sel_invpty.name;
                    oneProperty.quantity = sel_invpty.quantity;
                    oneProperty.price = sel_invpty.price;
                    oneProperty.tax = sel_invpty.tax;
                    
                    oneProperty.accessDate = [NSDate date];
                    oneProperty.sync_status = [NSNumber numberWithInt:0];
                    oneProperty.invoice  = self.myinvoce;
                    
                    [oneProperty.managedObjectContext save:nil];
                    [appDelegate.parseSync updateInvoicePropertyFromLocal:oneProperty];
                    hasFound = YES;
                    break;
                }
            }
            //没找到，是新建的
            if (!hasFound)
            {
                Invoiceproperty *newProperty = [NSEntityDescription insertNewObjectForEntityForName:@"Invoiceproperty" inManagedObjectContext:context];
                newProperty.name = sel_invpty.name;
                newProperty.quantity = sel_invpty.quantity;
                newProperty.price = sel_invpty.price;
                newProperty.tax = sel_invpty.tax;
                
                newProperty.accessDate = [NSDate date];
                newProperty.sync_status = [NSNumber numberWithInt:0];
                newProperty.invoice  = self.myinvoce;
                newProperty.uuid = sel_invpty.uuid;
                
                [newProperty.managedObjectContext save:nil];
                [appDelegate.parseSync updateInvoicePropertyFromLocal:newProperty];
            }
        }
        
        [self back:NO];
    }
}






#pragma mark -
#pragma mark  TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentField = textField;
    
    exportRow = 0;
    
    UIEdgeInsets size = {0,0,keyHigh,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    NSIndexPath *sel_indexPath;
    if (textField == self.discountField)
    {
        textField.text = self.discountStr;
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else if (textField == self.taxField)
    {
        [self.taxTipLbel setHidden:NO];
        [textField setFrame:CGRectMake(130, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
        if (IS_IPHONE_6PLUS)
        {
            [textField setFrame:CGRectMake(125, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];

        }
        textField.text = self.taxPercentage;
        sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    else if (textField == self.paidField)
    {
        textField.text = self.paidStr;
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else if (textField == self.subjectField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else if (textField == self.invoiceField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
    }
    else if (textField == self.termsField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:3 inSection:3];
    }

    [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.discountField || textField == self.taxField || textField == self.paidField)
    {
        if (textField == self.taxField)
        {
            [self.taxTipLbel setHidden:YES];
            [textField setFrame:CGRectMake(150, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
            if (IS_IPHONE_6PLUS)
            {
                [textField setFrame:CGRectMake(145, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];

            }
        }
        
        [self reflashCaculateMoney];
    }

    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.subjectField || textField == self.invoiceField || textField == self.termsField)
    {
        return YES;
    }
    else
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Tip"message:@"Please input number！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = alert;
            
            return NO;
        }
        
        
        
        if (range.location == [textField.text length])
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i<[textField.text length]; i++)
            {
                NSString *myStr = [textField.text substringWithRange:NSMakeRange(i, 1)];
                if (![myStr isEqualToString:@"."])
                {
                    [array addObject:[textField.text substringWithRange:NSMakeRange(i, 1)]];
                }
            }
            
            if ([[array objectAtIndex:0] isEqualToString:@"0"])
            {
                [array addObject:string];
                [array removeObjectAtIndex:0];
                [array insertObject:@"." atIndex:[array count]-2];
            }
            else
            {
                [array addObject:string];
                [array insertObject:@"." atIndex:[array count]-2];
            }
            
            NSMutableString *newString = [[NSMutableString alloc] init];
            for (int j=0; j<[array count]; j++)
            {
                [newString appendString:[array objectAtIndex:j]];
            }
            
            textField.text = newString;
            
            if (textField == self.discountField)
            {
                self.discountStr = newString;
            }
            else if (textField == self.taxField)
            {
                self.taxPercentage = newString;
            }
            else if (textField == self.paidField)
            {
                self.paidStr = newString;
            }

            return NO;
        }
        else if (range.location == [textField.text length]-1 && [string isEqualToString:@""])
        {
            NSMutableArray *array1 = [[NSMutableArray alloc] init];
            for (int k = 0; k<[textField.text length]; k++)
            {
                NSString *myStr1 = [textField.text substringWithRange:NSMakeRange(k, 1)];
                if (![myStr1 isEqualToString:@"."])
                {
                    [array1 addObject:[textField.text substringWithRange:NSMakeRange(k, 1)]];
                }
            }
            if ([array1 count]>3)
            {
                [array1 removeLastObject];
                [array1 insertObject:@"." atIndex:[array1 count]-2];
            }
            else
            {
                [array1 removeLastObject];
                [array1 insertObject:@"0" atIndex:0];
                [array1 insertObject:@"." atIndex:[array1 count]-2];
            }
            NSMutableString *newString1 = [[NSMutableString alloc] init];
            for (int m=0; m<[array1 count]; m++)
            {
                [newString1 appendString:[array1 objectAtIndex:m]];
            }
            
            textField.text = newString1;
            
            if (textField == self.discountField)
            {
                self.discountStr = newString1;
            }
            else if (textField == self.taxField)
            {
                self.taxPercentage = newString1;
            }
            else if (textField == self.paidField)
            {
                self.paidStr = newString1;
            }
            
            return NO;
        }
        else
        {
            return NO;
        }
    }
}






#pragma mark -
#pragma mark  TextView Delegate

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        [self.noteLbel setHidden:NO];
    }
    else
    {
        [self.noteLbel setHidden:YES];
    }
    
    exportRow = 0;
    
    UIEdgeInsets size = {0,0,keyHigh,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:4 inSection:3];
    [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
}

-(void) textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        [self.noteLbel setHidden:NO];
    }
    else
    {
        [self.noteLbel setHidden:YES];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        [self.noteLbel setHidden:NO];
    }
    else
    {
        [self.noteLbel setHidden:YES];
    }
    
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
}




#pragma mark -
#pragma mark  TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else if (section==1)
    {
        return 44*3;
    }
    else if (section==2)
        return 44;
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0 || section==1)
    {
        return 0.1;
    }
    else if (section==2)
        return 44*2;
    else
        return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2)
    {
        return self.footview;
    }
    else
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else if (section==1)
    {
        return self.headview1;
    }
    else if (section==2)
        return self.headview2;
    else
    {
        
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 3+self.propertyMutableArray.count;
    }
    else if (section==2)
        return 1;
    else
    {
        return 5;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 4)
    {
        return 108;
    }
    else if (indexPath.section == 2 && indexPath.row == 2 && exportRow == 1 )
    {
        return 260;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return self.clientCell;
        }
        else 
        {
            return self.jobsCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
            return self.discountCell;
        }
        else if (indexPath.row == 1)
        {
            return self.taxCell;
        }
        else if (indexPath.row == 2+self.propertyMutableArray.count)
        {
            return self.otherchargeCell;
        }
        else
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            
            NSString* identifier = @"invpertyCell-Identifier";
            invpropertyCell *invptycell = (invpropertyCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (invptycell == nil)
            {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"invpropertyCell" owner:self options:nil];
                
                for (id oneObject in nibs)
                {
                    if ([oneObject isKindOfClass:[invpropertyCell class]])
                    {
                        invptycell = (invpropertyCell*)oneObject;
                    }
                }
            }
            
            HMJInviocePropertyObject *sel_invpty = [self.propertyMutableArray objectAtIndex:indexPath.row-2];
            invptycell.nameLbel.text = sel_invpty.name;
            
            NSString *price1 = [appDelegate appMoneyShowStly2:sel_invpty.price];
            invptycell.priceLbel.text = [NSString stringWithFormat:@"%@%@/p",appDelegate.currencyStr,price1];
            
            double otherTax = 1.0;
            if (sel_invpty.tax.intValue == 1)
            {
                otherTax = otherTax + [self.taxPercentage doubleValue]/100;
            }
            invptycell.totalLbel.text = [appDelegate appMoneyShowStly3:[sel_invpty.price doubleValue]*sel_invpty.quantity.intValue*otherTax];
            
            if (IS_IPHONE_6PLUS)
            {
                invptycell.nameLbel.left = 20;
                invptycell.priceLbel.left = invptycell.priceLbel.left - 5;
                invptycell.totalLbel.left = invptycell.totalLbel.left - 5;
            }
            return invptycell;
        }

    }
    else if (indexPath.section==2)
    {
        return self.paidCell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return self.subjectCell;
        }
        else if (indexPath.row == 1)
        {
            return self.invoiceCell;
        }
        else if (indexPath.row == 2)
        {
            return self.dueDateCell;
        }
        else if (indexPath.row == 3)
        {
            return self.termsCell;
        }
        else 
        {
            return _noteCell;
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        exportRow = 0;
        [self downKeyborad];
        
        if (indexPath.row == 0)
        {
            SelectClientViewController_iphone *selectClientView = [[SelectClientViewController_iphone alloc] initWithNibName:@"SelectClientViewController_iphone" bundle:nil];
            selectClientView.selectClient = self.selectClient;
            selectClientView.delegate = self;
            
            [self.navigationController pushViewController:selectClientView animated:YES];
            
        }
        else
        {
            if (self.selectClient == nil || self.selectClient.clientName == nil)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select Client First!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                appDelegate.close_PopView = alertView;
                
            }
            else 
            {
                SelectLogsViewController *selectLogsView = [[SelectLogsViewController alloc] initWithNibName:@"SelectLogsViewController" bundle:nil];
                
                selectLogsView.delegate = self;
                selectLogsView.selectClient = self.selectClient;
                selectLogsView.selectInvoice = self.myinvoce;
                [selectLogsView.mylogs addObjectsFromArray:self.jobsList];
                
                [self.navigationController pushViewController:selectLogsView animated:YES];
                
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"3_INV_ADDDIST"];
            
            [self.discountField becomeFirstResponder];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"3_INV_ADDTAX"];
            
            [self.taxField becomeFirstResponder];
        }
        else if (indexPath.row == 2+self.propertyMutableArray.count)
        {
            [Flurry logEvent:@"3_INV_ADDCHAR"];
            
            exportRow = 0;
            [self downKeyborad];
            
            OtherChangeController *otherChangeView = [[OtherChangeController alloc] initWithNibName:@"OtherChangeController" bundle:nil];
            
            otherChangeView.myInvoiceProperty = nil;
            otherChangeView.editInvocieVC = self;

            
            [self.navigationController pushViewController:otherChangeView animated:YES];
        }
        else if (indexPath.row > 1 && indexPath.row < 2+self.propertyMutableArray.count)
        {
            exportRow = 0;
            [self downKeyborad];
            
            OtherChangeController *otherChangeView = [[OtherChangeController alloc] initWithNibName:@"OtherChangeController" bundle:nil];
            
            otherChangeView.myInvoiceProperty = [self.propertyMutableArray objectAtIndex:indexPath.row-2];
            otherChangeView.editInvocieVC = self;
            
            [self.navigationController pushViewController:otherChangeView animated:YES];
        }
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"3_INV_ADDPAID"];
            [self.paidField becomeFirstResponder];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"3_INV_ADDSUB"];
            
            [self.subjectField becomeFirstResponder];
        }
        else if (indexPath.row == 1)
        {
            [Flurry logEvent:@"3_INV_ADDINV#"];
            
            [self.invoiceField becomeFirstResponder];
        }
        else if (indexPath.row == 2)
        {
            [self downKeyborad];
            
            if (exportRow == 0)
            {
                [Flurry logEvent:@"3_INV_ADDDATE"];
                
                exportRow = 1;
                
                if (self.dueDate == nil)
                {
                    sel_datePicker1.date = [NSDate date];
                    self.dueDate = [NSDate date];
                }
                else
                {
                    sel_datePicker1.date = self.dueDate;
                }
            }
            else
            {
                exportRow = 0;
            }
            
            
            if (exportRow == 0)
            {
                
                [UIView animateWithDuration:0.25 animations:^
                 {
                     NSIndexPath *sel_indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
                     [self.myTableView scrollToRowAtIndexPath:sel_indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                     
                     [self.myTableView beginUpdates];
                     [self.myTableView endUpdates];
                 }
                                 completion:^(BOOL finished)
                 {
                     
                 }
                 ];
            }
            else
            {
                [self.myTableView beginUpdates];
                [self.myTableView endUpdates];
                
                [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else if (indexPath.row == 3)
        {
            [Flurry logEvent:@"3_INV_ADDTERM"];
            
            [self.termsField becomeFirstResponder];
        }
        else
        {
            [Flurry logEvent:@"3_INV_ADDNOTE"];
            
            [self.noteTextV becomeFirstResponder];
        }
    }
}


-(void)saveLogsForClient:(NSMutableArray *)_allLogs
{
    for (int i=(int)([_allLogs count]-1); i>=0; i--)
    {
        Logs *selLog = [_allLogs objectAtIndex:i];
        if (selLog == nil || selLog.starttime == nil)
        {
            [_allLogs removeObject:selLog];
        }
    }
    
    [self.jobsList removeAllObjects];
    [self.jobsList addObjectsFromArray:_allLogs];
    self.jobsLbel.text = [NSString stringWithFormat:@"%d",(int)[self.jobsList count]];
    
    [self reflashCaculateMoney];
}

-(void)saveSelectClient:(Clients *)selectClient
{
    if (selectClient != nil && selectClient.clientName != nil)
    {
        self.selectClient = selectClient;
        self.clientLbel.text = selectClient.clientName;
        
        self.jobsLbel.text = @"0";
        [self.jobsList removeAllObjects];
        
        [self reflashCaculateMoney];
    }
}




#pragma mark -
#pragma mark   Public
/**
    计算这个账单总的金额
 */
-(void)reflashCaculateMoney
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //打折的信息，以及已经支付多少的信息
    self.discountField.text = [appDelegate appMoneyShowStly:self.discountStr];
    self.paidField.text = [appDelegate appMoneyShowStly:self.paidStr];
    
    //获取所有选中的log的金额总和
    double getSubtotalMoney = 0.0;
    for (Logs *_log in self.jobsList)
    {
        getSubtotalMoney = getSubtotalMoney + [_log.totalmoney doubleValue];
    }
    
    self.subtotalStr = [appDelegate appMoneyShowStly4:getSubtotalMoney];
    self.subtotalLbel.text = [appDelegate appMoneyShowStly:self.subtotalStr];
    
    //这些log的加班工资
    if (self.selectClient != nil)
    {
        NSArray *backArray = [appDelegate overTimeMoney_logs:self.jobsList];
        NSNumber *over_money = [backArray objectAtIndex:0];
        self.overmoneyStr = [appDelegate appMoneyShowStly4:[over_money doubleValue]];
    }
    else
    {
        self.overmoneyStr = ZERO_NUM;
    }
    self.overtimeLbel.text = [appDelegate appMoneyShowStly:self.overmoneyStr];
    
    
    double getTaxMoney = 0.0;
    //税收 =（正常工资 + 加班工资）* 税收率
    getTaxMoney = ([self.subtotalStr doubleValue]+[self.overmoneyStr doubleValue])*[self.taxPercentage doubleValue]/100;
    self.taxStr = [appDelegate appMoneyShowStly4:getTaxMoney];
    self.taxField.text = [appDelegate appMoneyShowStly:self.taxStr];
    
    //其他要收费的总和
    double getOterMoney = 0.0;
    double otherTax;
    for (HMJInviocePropertyObject *_invpty in self.propertyMutableArray)
    {
        otherTax = 1.0;
        if (_invpty.tax.intValue == 1)
        {
            otherTax = otherTax + [self.taxPercentage doubleValue]/100;
        }
        getOterMoney = getOterMoney + _invpty.price.doubleValue*_invpty.quantity.intValue*otherTax;
    }
    
    //将所以减去之后实际获得报酬的金额
    double getTotalMoney = 0.0;
    getTotalMoney = getOterMoney + [self.overmoneyStr doubleValue] + [self.subtotalStr doubleValue] + [self.taxStr doubleValue] - [self.discountStr doubleValue];
    if (getTotalMoney < 0)
    {
        self.totalStr = ZERO_NUM;
    }
    else
    {
        self.totalStr = [appDelegate appMoneyShowStly4:getTotalMoney];
    }
    self.totalLbel.text = [appDelegate appMoneyShowStly:self.totalStr];
    
    double getBalanceDueMoney = 0.0;
    getBalanceDueMoney = [self.totalStr doubleValue] - [self.paidStr doubleValue];
    if (getBalanceDueMoney < 0)
    {
        self.balanceDueStr = ZERO_NUM;
    }
    else 
    {
        self.balanceDueStr = [appDelegate appMoneyShowStly4:getBalanceDueMoney];
    }
    self.balanceDueLbel.text = [appDelegate appMoneyShowStly:self.balanceDueStr];
}

-(void)downKeyborad
{
    if (currentField != nil && [currentField isFirstResponder])
    {
        [currentField resignFirstResponder];
    }
    if ([self.noteTextV isFirstResponder])
    {
        [self.noteTextV resignFirstResponder];
    }
}



#pragma mark -
#pragma mark  DatePicker Delegate

-(void)doPickerDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    self.dueDateLbel.text = [dateFormatter stringFromDate:sel_datePicker1.date];
    self.dueDate = sel_datePicker1.date;
}

-(void)saveOtherChange
{
    [self.myTableView reloadData];
    [self reflashCaculateMoney];
}
@end
