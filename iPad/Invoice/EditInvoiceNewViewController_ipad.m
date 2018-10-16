//
//  EditInvoiceNewViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditInvoiceNewViewController_ipad.h"
#import "Logs.h"
#import "AppDelegate_iPad.h"
#import "invpropertyCell.h"
#import "Invoiceproperty.h"



@interface EditInvoiceNewViewController_ipad ()
{
    UITextField *currentField;
    BOOL isEditStatus;
    
    int exportRow;   // 0: 空;  1:invoice date;
    UIDatePicker *sel_datePicker1;
    
    float keyHigh;
}
@end




@implementation EditInvoiceNewViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _jobsList = [[NSMutableArray alloc] init];
        _selectClient = nil;
        _propertyMutableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = appDelegate.naviFont;
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:leftButton];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:self.navTittle];
    

    exportRow = 0;
    sel_datePicker1 = nil;
    keyHigh = 220;
    
    [self initInvoiceData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (sel_datePicker1 == nil)
    {
        sel_datePicker1 = [[UIDatePicker alloc] init];
        sel_datePicker1.frame = CGRectMake(0, 44, 500, 216);
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

//-(void)dealloc
//{
//    self.myTableView;
//    self.jobsList;
//    
//    self.subjectCell;
//    self.subjectField;
//    
//    self.invoiceCell;
//    self.invoiceField;
//    
//    self.clientCell;
//    self.clientLbel;
//    
//    self.jobsCell;
//    self.jobsLbel;
//    
//    self.subtotalCell;
//    self.subtotalLbel;
//    
//    self.discountCell;
//    self.discountField;
//    
//    self.taxCell;
//    self.taxField;
//    self.taxTipLbel;
//    
//    self.totalCell;
//    self.totalLbel;
//    
//    self.paidCell;
//    self.paidField;
//    
//    self.balanceDueCell;
//    self.balanceDueLbel;
//    
//    self.dueDateCell;
//    self.dueDateLbel;
//    
//    self.termsCell;
//    self.termsField;
//    
//    self.noteCell;
//    self.noteTextV;
//    self.noteLbel;
//    
//    
//    self.otherchargeCell;
//    self.otherArray;
//    
//    self.overtimeCell;
//    self.overtimeLbel;
//    
//}


-(void)initInvoiceData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if (self.myinvoce == nil)
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
        self.jobsLbel.text = @"0";
        self.invoiceField.text = @"1";
        self.subjectField.text = @"New Invoice";
        
        NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
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

        [self.jobsList addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.myinvoce.logs allObjects]]];
        self.jobsLbel.text = [NSString stringWithFormat:@"%d",(int)[self.jobsList count]];
        
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








#pragma mark -
#pragma mark  Save & Back

-(void)back
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveBack
{
    NSError *error = nil;
    if (isEditStatus == YES)
    {
        if (self.myinvoce.title == nil)
        {
            [self back];
            return;
        }
    }
    
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    NSArray *last_logsArray = [appDelegate removeAlready_DeleteLog:self.jobsList];
    
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
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
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
            
            //syncing
            if ([[self.myinvoce.logs allObjects] count] > 0)
            {
                [needParseSyncArray addObjectsFromArray:[self.myinvoce.logs allObjects]];
            }
            
            
            
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
        
        self.myinvoce.title = self.subjectField.text;
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
        for (int i=0;i<[self.jobsList count];i++)
        {
            Logs *_log = [self.jobsList objectAtIndex:i];
            _log.isInvoice = [NSNumber numberWithBool:YES];
            _log.isPaid = paid;
            
            _log.accessDate = [NSDate date];
            _log.invoice_uuid = self.myinvoce.uuid;
            
            if (_log.invoice != nil && [_log.invoice allObjects] > 0)
            {
                [_log removeInvoice:_log.invoice];
            }
            [_log addInvoiceObject:self.myinvoce];
            
            
            //syncing
            if ([needParseSyncArray containsObject:_log] == NO)
            {
                [needParseSyncArray addObject:_log];
            }
        }
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
        
        [context save:&error];
        
        
        
        //syncing
        //先上传Invoice
        [appDelegate.parseSync updateInvoiceFromLocal:self.myinvoce];
        //再上传log
        for (id oneObject in needParseSyncArray)
        {
            
            if ([oneObject isKindOfClass:[Logs class]])
            {
                {
                    [appDelegate.parseSync updateLogFromLocal:oneObject];
                }
                
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
                    [oneproperty.managedObjectContext save:&error];
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

                    [appDelegate.managedObjectContext save:&error];
                    hasFound = YES;
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
                newProperty.invoice = self.myinvoce;
                newProperty.uuid = sel_invpty.uuid;

                [appDelegate.managedObjectContext save:&error];
                
            }
        }

        [appDelegate.managedObjectContext save:&error];
        [appDelegate.mainView reflashTimerMainView];
        [self back];
    }
}





#pragma mark -
#pragma mark  TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentField = textField;
    
    
    NSIndexPath *sel_indexPath;
    if (textField == self.discountField)
    {
        textField.text = self.discountStr;
        sel_indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    else if (textField == self.taxField)
    {
        [self.taxTipLbel setHidden:NO];
        [textField setFrame:CGRectMake(285, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
        textField.text = self.taxPercentage;
        sel_indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    }
    else if (textField == self.paidField)
    {
        textField.text = self.paidStr;
        sel_indexPath = [NSIndexPath indexPathForRow:6+self.propertyMutableArray.count inSection:1];
    }
    else if (textField == self.subjectField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else if (textField == self.invoiceField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    }
    else if (textField == self.termsField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    }
    
    

    if (exportRow == 0)
    {
        UIEdgeInsets size = {0,0,keyHigh,0};
        [self.myTableView setContentInset:size];
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
    }
    else
    {
        exportRow = 0;
        
        [UIView animateWithDuration:0.25 animations:^
         {
             NSIndexPath *sel_indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
             [self.myTableView scrollToRowAtIndexPath:sel_indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             
             UIEdgeInsets size = {0,0,keyHigh,0};
             [self.myTableView setContentInset:size];
             
             [self.myTableView beginUpdates];
             [self.myTableView endUpdates];
             
             [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
             [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
         }
                         completion:^(BOOL finished)
         {
         }
         ];
    }
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
            [textField setFrame:CGRectMake(305, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
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

    
    if (exportRow == 0)
    {
        UIEdgeInsets size = {0,0,keyHigh,0};
        [self.myTableView setContentInset:size];
        
        [self.myTableView beginUpdates];
        [self.myTableView endUpdates];
        
        NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:4 inSection:2];
        [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
    }
    else
    {
        exportRow = 0;
        
        [UIView animateWithDuration:0.25 animations:^
         {
             NSIndexPath *sel_indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
             [self.myTableView scrollToRowAtIndexPath:sel_indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             
             UIEdgeInsets size = {0,0,keyHigh,0};
             [self.myTableView setContentInset:size];
             
             [self.myTableView beginUpdates];
             [self.myTableView endUpdates];
             
             NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:4 inSection:2];
             [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
             [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
         }
                         completion:^(BOOL finished)
         {
         }
         ];
    }
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
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 8+self.propertyMutableArray.count;
    }
    else
    {
        return 5;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 4)
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
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.clientCell setBackgroundView:bv];
            
            return self.clientCell;
        }
        else
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.jobsCell setBackgroundView:bv];
            
            return self.jobsCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.subtotalCell.backgroundColor = [UIColor clearColor];
            
            return self.subtotalCell;
        }
        else if (indexPath.row == 1)
        {
            self.overtimeCell.backgroundColor = [UIColor clearColor];
            
            return self.overtimeCell;
        }
        else if (indexPath.row == 2)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.discountCell setBackgroundView:bv];
            
            return self.discountCell;
        }
        else if (indexPath.row == 3)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.taxCell setBackgroundView:bv];
            
            return self.taxCell;
        }
        else if (indexPath.row == 4+self.propertyMutableArray.count)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.otherchargeCell setBackgroundView:bv];
            
            return self.otherchargeCell;
        }
        else if (indexPath.row == 5+self.propertyMutableArray.count)
        {
            self.totalCell.backgroundColor = [UIColor clearColor];
            
            return self.totalCell;
        }
        else if (indexPath.row == 6+self.propertyMutableArray.count)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.paidCell setBackgroundView:bv];
            
            return self.paidCell;
        }
        else if (indexPath.row == 7+self.propertyMutableArray.count)
        {
            self.balanceDueCell.backgroundColor = [UIColor clearColor];
            
            return self.balanceDueCell;
        }
        else
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            
            NSString* identifier = @"invpertyCell-Identifier";
            invpropertyCell *invptycell = (invpropertyCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (invptycell == nil)
            {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"invpropertyCell_ipad" owner:self options:nil];
                
                for (id oneObject in nibs)
                {
                    if ([oneObject isKindOfClass:[invpropertyCell class]])
                    {
                        invptycell = (invpropertyCell*)oneObject;
                    }
                }
            }
            
            Invoiceproperty *sel_invpty = [self.propertyMutableArray objectAtIndex:indexPath.row-4];
            invptycell.nameLbel.text = sel_invpty.name;
            NSString *price1 = [appDelegate appMoneyShowStly2:sel_invpty.price];
            invptycell.priceLbel.text = [NSString stringWithFormat:@"%@%@/p",appDelegate.currencyStr,price1];
            
            double otherTax = 1.0;
            if (sel_invpty.tax.intValue == 1)
            {
                otherTax = otherTax + [self.taxPercentage doubleValue]/100;
            }

            invptycell.totalLbel.text = [appDelegate appMoneyShowStly3:[sel_invpty.price doubleValue]*sel_invpty.quantity.intValue*otherTax];
            
            UIImageView *backV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [invptycell setBackgroundView:backV];
            
            return invptycell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.subjectCell setBackgroundView:bv];
            
            return self.subjectCell;
        }
        else if (indexPath.row == 1)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.invoiceCell setBackgroundView:bv];
            
            return self.invoiceCell;
        }
        else if (indexPath.row == 2)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.dueDateCell setBackgroundView:bv];
            
            return self.dueDateCell;
        }
        else if (indexPath.row == 3)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.termsCell setBackgroundView:bv];
            
            return self.termsCell;
        }
        else
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.noteCell setBackgroundView:bv];
            
            return self.noteCell;
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
            SelectClientViewController_ipad *selectClientView = [[SelectClientViewController_ipad alloc] initWithNibName:@"SelectClientViewController_ipad" bundle:nil];
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
                SelectLogsViewController_ipad *selectLogsView = [[SelectLogsViewController_ipad alloc] initWithNibName:@"SelectLogsViewController_ipad" bundle:nil];
                
                selectLogsView.delegate = self;
                selectLogsView.selectInvoice = self.myinvoce;
                selectLogsView.selectClient = self.selectClient;
                [selectLogsView.mylogs addObjectsFromArray:self.jobsList];
                
                [self.navigationController pushViewController:selectLogsView animated:YES];
                
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 2)
        {
            [Flurry logEvent:@"3_INV_ADDDIST"];
            
            [self.discountField becomeFirstResponder];
        }
        else if (indexPath.row == 3)
        {
            [Flurry logEvent:@"3_INV_ADDTAX"];
            
            [self.taxField becomeFirstResponder];
        }
        else if (indexPath.row == 6+self.propertyMutableArray.count)
        {
            [Flurry logEvent:@"3_INV_ADDPAID"];
            
            [self.paidField becomeFirstResponder];
        }
        else if (indexPath.row == 4+self.propertyMutableArray.count)
        {
            [Flurry logEvent:@"3_INV_ADDCHAR"];
            
            exportRow = 0;
            [self downKeyborad];
            
            OtherChangeController *otherChangeView = [[OtherChangeController alloc] initWithNibName:@"OtherChangeController_ipad" bundle:nil];
            
            //hmj delete
            otherChangeView.myInvoiceProperty = nil;
            otherChangeView.editInvoiceVC_iPad = self;
            
            [self.navigationController pushViewController:otherChangeView animated:YES];
        }
        else if (indexPath.row > 3 && indexPath.row < 4+self.propertyMutableArray.count)
        {
            exportRow = 0;
            [self downKeyborad];
            
            OtherChangeController *otherChangeView = [[OtherChangeController alloc] initWithNibName:@"OtherChangeController_ipad" bundle:nil];
            
            otherChangeView.myInvoiceProperty = [self.propertyMutableArray objectAtIndex:indexPath.row-4];
            otherChangeView.editInvoiceVC_iPad = self;
            
            [self.navigationController pushViewController:otherChangeView animated:YES];
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


-(void)saveSelectClient:(Clients *)tmpselectClient
{
    if (tmpselectClient != nil && tmpselectClient.clientName != nil)
    {
        self.selectClient = tmpselectClient;
        self.clientLbel.text = tmpselectClient.clientName;
        
        self.jobsLbel.text = @"0";
        [self.jobsList removeAllObjects];
        
        [self reflashCaculateMoney];
    }
}






#pragma mark -
#pragma mark   Public

-(void)reflashCaculateMoney
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.discountField.text = [appDelegate appMoneyShowStly:self.discountStr];
    self.paidField.text = [appDelegate appMoneyShowStly:self.paidStr];
    
    double getSubtotalMoney = 0.0;
    for (Logs *_log in self.jobsList)
    {
        getSubtotalMoney = getSubtotalMoney + [_log.totalmoney doubleValue];
    }
    
    //subtotal
    self.subtotalStr = [appDelegate appMoneyShowStly4:getSubtotalMoney];
    self.subtotalLbel.text = [appDelegate appMoneyShowStly:self.subtotalStr];
    
    //overmoney
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
    
    //tax
    double getTaxMoney = 0.0;
    getTaxMoney = ([self.subtotalStr doubleValue]+[self.overmoneyStr doubleValue])*[self.taxPercentage doubleValue]/100;
    self.taxStr = [appDelegate appMoneyShowStly4:getTaxMoney];
    self.taxField.text = [appDelegate appMoneyShowStly:self.taxStr];
    
    //other charge
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
    
    //balance due
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



#pragma mark -
#pragma mark  OtherChange Delegate
///*
//    正在编辑一个Invoice里的property的时候，这个property被删除了，那么就需要将这个property从当前页面删掉
// */
//-(void)saveOtherChange:(Invoiceproperty *)_invperty isDelete:(BOOL)_delete
//{
//    if (_delete == YES)
//    {
//        [self.otherArray removeObject:_invperty];
//        
//        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context = [appDelegate managedObjectContext];
//        NSError *error = nil;        
//        _invperty.sync_status = [NSNumber numberWithInteger:1];
//        _invperty.accessDate = [NSDate date];
//        [context save:&error];
//    }
//    else
//    {
//        if ([self.otherArray containsObject:_invperty] == NO)
//        {
//            [self.otherArray addObject:_invperty];
//        }
//    }
//    [self.myTableView reloadData];
//    [self reflashCaculateMoney];
//}


-(void)saveOtherChange
{
    [self.myTableView reloadData];
    [self reflashCaculateMoney];
}


@end

