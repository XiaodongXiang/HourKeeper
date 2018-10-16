//
//  ShowPDFViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowPDFViewController.h"

#import "AppDelegate_iPhone.h"
#import "FileController.h"
#import "Profile.h"
#import "EditInvoiceNewViewController.h"

#import "PDFView_iphone2.h"




@implementation ShowPDFViewController

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //返回按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 80, 30);
    [_leftButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    _leftButton.titleLabel.font = appDelegate.naviFont;
//    [_leftButton setTitle:@"Invoices" forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:self.leftButton];
    
    //编辑按钮
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.titleLabel.font = appDelegate.naviFont;
    self.editButton.frame = CGRectMake(0, 0, 80, 30);
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:self.editButton];
    
    [appDelegate setNaviGationTittle:self with:200 high:44 tittle:self.selectInvoice.title];
    
    
    self.pdfView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-49-20);
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    //当全部支付完成的话，支付按钮就不显示了
    if ([self.selectInvoice.balanceDue doubleValue] == 0)
    {
        [self.paymentBtn setHidden:YES];
    }
    else
    {
        [self.paymentBtn setHidden:NO];
    }

    pdfView2 = [[PDFView_iphone2 alloc] initWithFrame:CGRectMake(0, 0, self.pdfView.frame.size.width, self.pdfView.frame.size.height)];
    
    [self.payView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    
    //初始化PDF显示需要的信息
    [self initPDFdata];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 初始化PDF所需的数据
 */
-(void)initPDFdata
{
    if (self.sel_printInteraction != nil)
    {
        [self.sel_printInteraction dismissAnimated:YES];
        self.sel_printInteraction = nil;
    }
    
    if (self.selectInvoice == nil || self.selectInvoice.title == nil)
    {
        [self back];
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate setNaviGationTittle:self with:200 high:44 tittle:self.selectInvoice.title];
    
    
    if ([self.selectInvoice.balanceDue doubleValue] == 0)
    {
        [self.paymentBtn setHidden:YES];
    }
    else
    {
        [self.paymentBtn setHidden:NO];
    }
    
    
    for (UIView *view in self.pdfView.subviews)
    {
        [view removeFromSuperview];
    }
    
    pdfView2._invoice = self.selectInvoice;
    [pdfView2 setNeedsDisplay];
    [self.pdfView addSubview:pdfView2];
}


#pragma mark Method
-(void)back
{
    [self.navigationController  popViewControllerAnimated:YES];
}


-(void)doEdit
{
    [Flurry logEvent:@"3_INV_DETALEDIT"];
    
    EditInvoiceNewViewController *controller =  [[EditInvoiceNewViewController alloc] initWithNibName:@"EditInvoiceNewViewController" bundle:nil];
    
    controller.navi_tittle = @"Edit Invoice";
    controller.myinvoce = self.selectInvoice;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self presentViewController:nav animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}

-(IBAction)deleteInvoice
{
    [Flurry logEvent:@"3_INV_DETALDEL"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Are you sure to delete this Invoice?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alertView.tag = 2;
    [alertView show];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = alertView;
    
}

/*
    支付功能
 */
-(IBAction)addPayment
{
    [Flurry logEvent:@"3_INV_DETALPAY"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.amountLable.text = [appDelegate appMoneyShowStly:self.selectInvoice.balanceDue];
    [self.payView setHidden:NO];
    self.inputField.text = ZERO_NUM;
    [self.inputField becomeFirstResponder];
    [self.leftButton setUserInteractionEnabled:NO];
    [self.editButton setUserInteractionEnabled:NO];
    
}

-(IBAction)sentEmail
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send Email",@"Print",@"Fax Now",nil];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    actionSheet.tag = 2;
    actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:appDelegate.m_tabBarController.view];
    
    appDelegate.close_PopView = actionSheet;
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/*
    支付取消，支付保存按钮触发事件
 */
-(IBAction)doPayAmount_action:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
        double amount = [self.inputField.text doubleValue];
        double balance = [self.selectInvoice.balanceDue doubleValue];
        double total = balance - amount;
        total = total<0?0:total;
        
        self.selectInvoice.paidDue = [appDelegate appMoneyShowStly4:amount+[self.selectInvoice.paidDue doubleValue]];
        self.selectInvoice.balanceDue = [appDelegate appMoneyShowStly4:total];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        if (total == 0)
        {
            Invoice *invoice = self.selectInvoice;
            NSArray *logArray = [appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]];
            for (Logs *log in logArray)
            {
                log.isPaid = [NSNumber numberWithInt:1];
                
                log.accessDate = [NSDate date];
            }
            
            [self.paymentBtn setHidden:YES];
        }
        else
        {
            Invoice *invoice = self.selectInvoice;
            NSArray *logArray = [appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]];
            for (Logs *log in logArray)
            {
                log.isPaid = [NSNumber numberWithInt:0];

                log.accessDate = [NSDate date];
            }
        }

        self.selectInvoice.accessDate = [NSDate date];
        [context save:nil];
        
        
        //hmj delete
//        //syncing
//        NSMutableArray *dataMarray = [[NSMutableArray alloc] initWithObjects:self.selectInvoice, nil];
//        [appDelegate localToServerSync:dataMarray isRelance:YES];
        
        //parse update local
        [appDelegate.parseSync updateInvoiceFromLocal:self.selectInvoice];
        
        
        
        for (UIView *view in self.pdfView.subviews)
        {
            [view removeFromSuperview];
        }
        
        pdfView2._invoice = self.selectInvoice;
        [pdfView2 setNeedsDisplay];
        [self.pdfView addSubview:pdfView2];
    }
    
    [self.payView setHidden:YES];
    [self.inputField resignFirstResponder];
    [self.leftButton setUserInteractionEnabled:YES];
    [self.editButton setUserInteractionEnabled:YES];
    
}



- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
        
        return NO;
    }
    else
    {
        return NO;
    }
}





#pragma mark UIAlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        //删除Invoice及其以下
        if (buttonIndex == 1)
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            
            
            [[DataBaseManger getBaseManger] do_deletInvoice:self.selectInvoice withManual:YES fromServerDeleteAccount:NO isChildContext:NO];
            
            
            
            //syncing
            [appDelegate.parseSync updateInvoiceFromLocal:self.selectInvoice];
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}

-(void)sharePDFWithData:(NSData *)pdfData{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"faxnow://"]]){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            [pasteboard setData:pdfData forPasteboardType:@"HoursKeeperSharePDF"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:@"faxnow://"]];
            });
        });
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1197930396"]]];
    }
}

-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [Flurry logEvent:@"3_INV_DETALSEND"];
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                if ([mailClass canSendMail])
                {
                    
                    NSString *subjectStr;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMd" options:0 locale:[NSLocale currentLocale]]];
                    subjectStr = [NSString stringWithFormat:@"[invoice]%@.%@",[dateFormatter stringFromDate:self.selectInvoice.dueDate],self.selectInvoice.client.clientName];
                    
                    
                    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                    mailController.mailComposeDelegate = self;
                    [mailController setSubject:subjectStr];
                    [mailController setMessageBody:@"This invoice was generated by Hours Keeper." isHTML:NO];
                    NSString *path = [[FileController documentPath] stringByAppendingPathComponent:@"myPDF.pdf"];
                    
                    
                    NSString *pdfStr;
                    pdfStr = [NSString stringWithFormat:@"invoice.%@.%@.pdf",[dateFormatter stringFromDate:self.selectInvoice.dueDate],self.selectInvoice.client.clientName];
                    
                    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                    
                    NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
                    [mailController addAttachmentData:myData mimeType:@"pdf" fileName:pdfStr];
                    [self presentViewController:mailController animated:YES completion:nil];
                    appDelegate.m_widgetController = self;
                    
                    appDelegate.appMailController = mailController;
                    
                    
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a mail account in order to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
                    appDelegate.close_PopView = alertView;
                    
                }
            }
        }
        else if (buttonIndex == 1)
        {
            [Flurry logEvent:@"3_INV_DETALPRINT"];
            
            Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
            
            NSString *path = [[FileController documentPath] stringByAppendingPathComponent:@"myPDF.pdf"];
            NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
            
            
            if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable] && [UIPrintInteractionController canPrintData:myData])
            {
                UIPrintInteractionController *printInteraction = [printInteractionController sharedPrintController];
                
                
                self.sel_printInteraction = printInteraction;
                
                
                printInteraction.delegate = self;
                UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
                
                printInfo.duplex = UIPrintInfoDuplexLongEdge;
                printInfo.outputType = UIPrintInfoOutputGeneral;
                printInfo.jobName = self.selectInvoice.title;
                
                printInteraction.printInfo = printInfo;
                printInteraction.showsPageRange = YES;
                
                printInteraction.printingItem = myData;
                
                
                [printInteraction presentAnimated:YES completionHandler:^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                 }
                 ];
                
            }
            
        }else{
            
            NSString *path = [[FileController documentPath] stringByAppendingPathComponent:@"myPDF.pdf"];
            NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
            
            [self sharePDFWithData:myData];
        }
    }
}

#pragma mark -
#pragma mark UIPrintInteractionControllerDelegate

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    printInteractionController = nil;
}







@end
