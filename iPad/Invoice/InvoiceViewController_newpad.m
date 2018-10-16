//
//  InvoiceViewController_newpad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvoiceViewController_newpad.h"
#import "Custom1ViewController.h"
#import "AppDelegate_iPad.h"
#import "Invoice.h"
#import "InvoiceCell_ipad.h"

#import "EditInvoiceNewViewController_ipad.h"
#import "HMJNomalClass.h"



@interface InvoiceViewController_newpad()
{
    double openMoney_float;
    NSString *currencyStr;
}

@end



@implementation InvoiceViewController_newpad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _openArray = [[NSMutableArray alloc] init];
        _paidArray = [[NSMutableArray alloc] init];
        openMoney_float = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pdfShowView = [[ShowPDFViewController_ipad alloc] initWithNibName:@"ShowPDFViewController_ipad" bundle:nil];
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

}


-(void)initViewControllData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

	NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
    currencyStr = appDelegate.currencyStr;
    
    [self.openArray removeAllObjects];
    [self.paidArray removeAllObjects];
    openMoney_float = 0;
    
    if ([requests count] == 0)
    {
        [self.tipImagV setHidden:NO];
    }
    else
    {
                
        NSMutableArray *invoiceArray = [[NSMutableArray alloc] initWithArray:requests];
        for (int i=0; i<[invoiceArray count]; i++)
        {
            Invoice *_invoice = [invoiceArray objectAtIndex:i];
//            if ([[appDelegate removeAlready_DeleteLog:[_invoice.logs allObjects]] count] == 0)
//            {
//                [[DataBaseManger getBaseManger] do_deletInvoice:_invoice withManual:YES fromServerDeleteAccount:NO isChildContext:NO];
//                [invoiceArray removeObject:_invoice];
//                i--;
//            }
//            else
//            {
                if ([_invoice.balanceDue doubleValue] > 0)
                {
                    [self.openArray addObject:_invoice];
                    openMoney_float = openMoney_float + [_invoice.balanceDue doubleValue];
                }
                else
                {
                    [self.paidArray addObject:_invoice];
                }
//            }
        }

        if (([self.openArray count]+[self.paidArray count]) >0)
        {
            [self.tipImagV setHidden:YES];
        }
        else
        {
            [self.tipImagV setHidden:NO];
        }
    }
    
    [self.myTableView reloadData];
}







#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || (section == 1 && [self.paidArray count] != 0))
    {
        return 24;
    }
    else
    {
        return 0;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 24)];
//    v.backgroundColor = [HMJNomalClass creatTableViewHeaderColor];
    v.backgroundColor = [UIColor clearColor];
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, v.width-SCREEN_SCALE, v.height)];
    bgView.backgroundColor = [HMJNomalClass creatTableViewHeaderColor];
    [v addSubview:bgView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 24-SCREEN_SCALE, self.view.width, SCREEN_SCALE)];
    line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    [v addSubview:line];
    
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200,20)];
    label.textAlignment = NSTextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
	[v addSubview:label];
    
    
    if (section == 0)
    {
        label.textColor = [HMJNomalClass creatAmountColor];

//        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//        NSString *showMoney = [appDelegate appMoneyShowStly4:openMoney_float];
//        label.text = [NSString stringWithFormat:@"Open:  %@%@",currencyStr,showMoney];
        label.text = @"UNPAID";
    }
    else
    {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_SCALE)];
        line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        [v addSubview:line];
        
        label.textColor = [HMJNomalClass creatAmountBlueColor_107_133_158];
        label.text = @"PAID";
    }
    
	
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return ([self.openArray count]+1)/3+(([self.openArray count]+1)%3==0?0:1);
    }
    else
    {
        return [self.paidArray count]/3+([self.paidArray count]%3==0?0:1);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"invoice_Cell_ipad";
    
    InvoiceCell_ipad *myInvoiceCells = (InvoiceCell_ipad*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (myInvoiceCells == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"InvoiceCell_ipad" owner:self options:nil];
        
        for (id oneObject in nibs)
        {
            if ([oneObject isKindOfClass:[InvoiceCell_ipad class]])
            {
                myInvoiceCells = (InvoiceCell_ipad*)oneObject;
                [myInvoiceCells.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
                [myInvoiceCells.totalMoneyLbel2 creatSubViewsisLeftAlignment:NO];
                [myInvoiceCells.totalMoneyLbel3 creatSubViewsisLeftAlignment:NO];
            }
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];


    
    [myInvoiceCells.showBtn removeTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
    [myInvoiceCells.showBtn2 removeTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
    [myInvoiceCells.showBtn3 removeTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
    [myInvoiceCells.isAddBtn removeTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
    int index = (int)indexPath.row*3;
    if (index == 0 && indexPath.section == 0)
    {
        [myInvoiceCells.isAddBtn setHidden:NO];
        [myInvoiceCells.isAddBtn addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
        myInvoiceCells.showBtn.hidden = YES;

    }
    else
    {
        [myInvoiceCells.isAddBtn setHidden:YES];
        myInvoiceCells.showBtn.hidden = NO;

    }
    

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    Invoice *sel_invoice;
    if (indexPath.section == 0)
    {

        [myInvoiceCells.showBtn setImage:[UIImage imageNamed:@"ipad_unpaid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn2 setImage:[UIImage imageNamed:@"ipad_unpaid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn3 setImage:[UIImage imageNamed:@"ipad_unpaid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn setImage:[UIImage imageNamed:@"ipad_unpaid_sel"] forState:UIControlStateHighlighted];
        [myInvoiceCells.showBtn2 setImage:[UIImage imageNamed:@"ipad_unpaid_sel"] forState:UIControlStateHighlighted];
        [myInvoiceCells.showBtn3 setImage:[UIImage imageNamed:@"ipad_unpaid_sel"] forState:UIControlStateHighlighted];

        
        for (int i=0; i<3; i++)
        {
            if (i==0)
            {

                if (index != 0)
                {
                    sel_invoice = [self.openArray objectAtIndex:(index-1)];
                    
                    myInvoiceCells.subjectLbel.text = sel_invoice.title;
                    myInvoiceCells.dateLbel.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                    [myInvoiceCells.totalMoneyLbel  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.balanceDue color:[HMJNomalClass creatAmountColor]];
                }
                myInvoiceCells.showBtn.tag = index;
                [myInvoiceCells.showBtn addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (i==1)
            {
                
                if (index <= [self.openArray count])
                {
                    [myInvoiceCells.allView2 setHidden:NO];
                    sel_invoice = [self.openArray objectAtIndex:(index-1)];

                    myInvoiceCells.showBtn2.tag = index;
                    [myInvoiceCells.showBtn2 addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
                    myInvoiceCells.subjectLbel2.text = sel_invoice.title;
                    myInvoiceCells.dateLbel2.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                    [myInvoiceCells.totalMoneyLbel2  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.balanceDue color:[HMJNomalClass creatAmountColor]];
                }
                else
                {
                    [myInvoiceCells.allView2 setHidden:YES];
                }

            }
            else
            {
                if (index <= [self.openArray count])
                {
                    [myInvoiceCells.allView3 setHidden:NO];
                    sel_invoice = [self.openArray objectAtIndex:(index-1)];
                    
                    myInvoiceCells.showBtn3.tag = index;
                    [myInvoiceCells.showBtn3 addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
                    myInvoiceCells.subjectLbel3.text = sel_invoice.title;
                    myInvoiceCells.dateLbel3.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                    [myInvoiceCells.totalMoneyLbel3  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.balanceDue color:[HMJNomalClass creatAmountColor]];
                }
                else
                {
                    [myInvoiceCells.allView3 setHidden:YES];
                }
            }
            
            index++;
        }
    }
    else
    {
        myInvoiceCells.showBtn.hidden = NO;

        [myInvoiceCells.showBtn setImage:[UIImage imageNamed:@"ipad_paid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn2 setImage:[UIImage imageNamed:@"ipad_paid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn3 setImage:[UIImage imageNamed:@"ipad_paid"] forState:UIControlStateNormal];
        [myInvoiceCells.showBtn setImage:[UIImage imageNamed:@"ipad_paid_sel"] forState:UIControlStateHighlighted];
        [myInvoiceCells.showBtn2 setImage:[UIImage imageNamed:@"ipad_paid_sel"] forState:UIControlStateHighlighted];
        [myInvoiceCells.showBtn3 setImage:[UIImage imageNamed:@"ipad_paid_sel"] forState:UIControlStateHighlighted];
        
        for (int i=0; i<3; i++)
        {
            if (i==0)
            {
                [myInvoiceCells.allView setHidden:NO];
                sel_invoice = [self.paidArray objectAtIndex:index];
                
//                [myInvoiceCells.dateLbel setTextColor:appDelegate.appTimeColor];
                myInvoiceCells.showBtn.tag = index+1+[self.openArray count];
                [myInvoiceCells.showBtn addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
                myInvoiceCells.subjectLbel.text = sel_invoice.title;
                myInvoiceCells.dateLbel.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                [myInvoiceCells.totalMoneyLbel  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.paidDue color:[HMJNomalClass creatAmountColor]];
            }
            else if (i==1)
            {
                if (index < [self.paidArray count])
                {
                    [myInvoiceCells.allView2 setHidden:NO];
                    sel_invoice = [self.paidArray objectAtIndex:index];
                    
//                    [myInvoiceCells.dateLbel2 setTextColor:appDelegate.appTimeColor];
                    myInvoiceCells.showBtn2.tag = index+1+[self.openArray count];
                    [myInvoiceCells.showBtn2 addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
                    myInvoiceCells.subjectLbel2.text = sel_invoice.title;
                    myInvoiceCells.dateLbel2.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                    [myInvoiceCells.totalMoneyLbel2  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.totalDue color:[HMJNomalClass creatAmountColor]];
                }
                else
                {
                    [myInvoiceCells.allView2 setHidden:YES];
                }
            }
            else
            {
                if (index < [self.paidArray count])
                {
                    [myInvoiceCells.allView3 setHidden:NO];
                    
                    sel_invoice = [self.paidArray objectAtIndex:index];
//                    [myInvoiceCells.dateLbel3 setTextColor:appDelegate.appTimeColor];
                    myInvoiceCells.showBtn3.tag = index+1+[self.openArray count];
                    [myInvoiceCells.showBtn3 addTarget:self action:@selector(pop_invoice:) forControlEvents:UIControlEventTouchUpInside];
                    myInvoiceCells.subjectLbel3.text = sel_invoice.title;
                    myInvoiceCells.dateLbel3.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
                    [myInvoiceCells.totalMoneyLbel3  setAmountSize:38 pointSize:30 Currency:appDelegate.currencyStr Amount:sel_invoice.totalDue color:[HMJNomalClass creatAmountColor]];
                }
                else
                {
                    [myInvoiceCells.allView3 setHidden:YES];
                }
            }
            
            index++;
        }

    }
    
    
    myInvoiceCells.backgroundColor = [UIColor clearColor];
    myInvoiceCells.contentView.backgroundColor = [UIColor clearColor];

    return myInvoiceCells;
}







/**
    显示Invoice
 */
-(void)pop_invoice:(UIButton *)sender
{
    Invoice *sel_invoice;
    
    if (sender.tag == 0)
    {
        [self newInvoice];
        return;
    }
    else if (sender.tag<= [self.openArray count])
    {
        sel_invoice = [self.openArray objectAtIndex:(sender.tag-1)];
    }
    else
    {
        sel_invoice = [self.paidArray objectAtIndex:(sender.tag-1-[self.openArray count])];
    }
    
    
    self.pdfShowView.selectInvoice = sel_invoice;
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    for (UIView *view in appDelegate.mainView.kindsofView.subviews) 
    {
        [view removeFromSuperview];
    }
    [appDelegate.mainView.kindsofView addSubview:self.pdfShowView.view];
    [self.pdfShowView initFlashIvoiceData];
}





-(void)newInvoice
{
    [Flurry logEvent:@"3_INV_ADD"];
    
    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if (appDelegate_ipad.isPurchased == NO)
    {
        NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
        if ([requests count]>1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of invoices allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
            alertView.tag = 1;
            [alertView show];
            
            appDelegate_ipad.close_PopView = alertView;
            
            return;
        }
    }

    
    EditInvoiceNewViewController_ipad *addInvoiceView =  [[EditInvoiceNewViewController_ipad alloc] initWithNibName:@"EditInvoiceNewViewController_ipad" bundle:nil];
    
    addInvoiceView.myinvoce = nil;
    addInvoiceView.navTittle = @"New Invoice";
    
    Custom1ViewController *editInvoiceNavi = [[Custom1ViewController alloc] initWithRootViewController:addInvoiceView];
    editInvoiceNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editInvoiceNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [appDelegate_ipad.mainView presentViewController:editInvoiceNavi animated:YES completion:nil];
    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
    
}






- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [Flurry logEvent:@"7_ADS_INV2"];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [appDelegate doPurchase_Lite];
        }
    }
}





@end
