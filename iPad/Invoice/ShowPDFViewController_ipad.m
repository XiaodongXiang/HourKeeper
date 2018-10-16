//
//  ShowPDFViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowPDFViewController_ipad.h"
#import "Custom1ViewController.h"
#import "AppDelegate_iPad.h"
#import "FileController.h"
#import "Profile.h"
#import "EditInvoiceNewViewController_ipad.h"
#import "PDFView_iphone2.h"



@implementation ShowPDFViewController_ipad

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
    
    pdfView2 = [[PDFView_iphone2 alloc] initWithFrame:CGRectMake(0, 0, self.pdfView.frame.size.width, self.pdfView.frame.size.height)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initFlashIvoiceData];
}




/**
    ???
 */
-(void)initFlashIvoiceData
{
    if (self.sel_printInteraction != nil)
    {
        [self.sel_printInteraction dismissAnimated:YES];
        self.sel_printInteraction = nil;
    }
    
    for (UIView *view in self.pdfView.subviews) 
    {
        [view removeFromSuperview];
    }
    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
    
    int isShouldRemove = 0;
    if ([requests indexOfObject:self.selectInvoice] == NSNotFound)
    {
        isShouldRemove = 1;
    }
    else
    {
//        if ([[appDelegate removeAlready_DeleteLog:[self.selectInvoice.logs allObjects]] count] == 0)
//        {
//            isShouldRemove = 1;
//
//            [[DataBaseManger getBaseManger] do_deletInvoice:self.selectInvoice withManual:YES fromServerDeleteAccount:NO isChildContext:NO];
//        }
    }
    
    if (isShouldRemove == 1)
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        
        for (UIView *view in appDelegate.mainView.kindsofView.subviews)
        {
            [view removeFromSuperview];
        }
        [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.invoiceView.view];
        return;
    }
    

    
    pdfView2._invoice = self.selectInvoice;
    [pdfView2 setNeedsDisplay];
    [self.pdfView addSubview:pdfView2];
    
}


-(IBAction)back
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    for (UIView *view in appDelegate.mainView.kindsofView.subviews) 
    {
        [view removeFromSuperview];
    }
    [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.invoiceView.view];
    [appDelegate.mainView.invoiceView initViewControllData];
}


-(IBAction)doEdit
{
    [Flurry logEvent:@"3_INV_DETALEDIT"];
    
    EditInvoiceNewViewController_ipad *editInvoiceView =  [[EditInvoiceNewViewController_ipad alloc] initWithNibName:@"EditInvoiceNewViewController_ipad" bundle:nil];
    editInvoiceView.navTittle = @"Edit Invoice";
    
    Invoice *sel_invoice;
    sel_invoice = self.selectInvoice;
    editInvoiceView.myinvoce = sel_invoice;
    
    Custom1ViewController *editInvoiceNavi = [[Custom1ViewController alloc] initWithRootViewController:editInvoiceView];
    editInvoiceNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editInvoiceNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate_ipad.mainView presentViewController:editInvoiceNavi animated:YES completion:nil];
    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
    
}




-(IBAction)sentEmail
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send Email",@"Print",nil];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    actionSheet.tag = 2;
	actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:appDelegate.mainView.view];
    
    appDelegate.close_PopView = actionSheet;
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
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


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];

            
            
            [[DataBaseManger getBaseManger] do_deletInvoice:self.selectInvoice withManual:YES fromServerDeleteAccount:NO isChildContext:NO];
            
            

            for (UIView *view in appDelegate.mainView.kindsofView.subviews)
            {
                [view removeFromSuperview];
            }
            [appDelegate.mainView.kindsofView addSubview:appDelegate.mainView.invoiceView.view];
            [appDelegate.mainView reflashTimerMainView];
        }
    }
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}


-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = [array objectAtIndex:0];
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    //more按钮触发的ActionSheet事件
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
                    NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
                    
                    
                    NSString *pdfStr;
                    pdfStr = [NSString stringWithFormat:@"invoice.%@.%@.pdf",[dateFormatter stringFromDate:self.selectInvoice.dueDate],self.selectInvoice.client.clientName];
                    
                    [mailController addAttachmentData:myData mimeType:@"pdf" fileName:pdfStr];
                    
                    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
                    [appDelegate_ipad.mainView presentViewController:mailController animated:YES completion:nil];
                    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
                    
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
                
                
                [printInteraction presentFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1) inView:self.view animated:YES completionHandler:^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                 }];
            }
            
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
