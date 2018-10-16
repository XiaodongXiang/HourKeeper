//
//  InvoiceNewViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvoiceNewViewController.h"

#import "AppDelegate_iPhone.h"
#import "Invoice.h"
#import "invoiceShow_Cell.h"

#import "EditInvoiceNewViewController.h"




@interface InvoiceNewViewController()
{
    double openMoney_float;
    NSString *currencyStr;
}

@end




@implementation InvoiceNewViewController

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [HMJNomalClass creatTableViewHeaderColor];
    
    
    //+按钮
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    _rightBarView.backgroundColor = [UIColor clearColor];
    [_addBtn addTarget:self action:@selector(addInvoice) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = -16;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:_rightBarView];
    self.navigationItem.rightBarButtonItems = @[flexible,rightBar];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Invoices"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    
    _openArray = [[NSMutableArray alloc] init];
    _paidArray = [[NSMutableArray alloc] init];
    openMoney_float = 0;
    
    if (appDelegate.isPurchased == NO)
    {
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height;
        self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
        
        if (appDelegate.lite_adv == YES)
        {
            [self.lite_Btn setHidden:NO];
        }
        else
        {
            [self.lite_Btn setHidden:YES];
        }
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    [self.lite_Btn setImage:[UIImage imageNamed:[NSString customImageName:@"ads320_50"]] forState:UIControlStateNormal];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == NO)
    {
        NSArray *requests2 = [appDelegate getAllLog];
        if ([requests2 count] > 0)
        {
            appDelegate.lite_adv = YES;
            
            NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
            [defaults2 setInteger:1 forKey:NEED_SHOW_LITE_ADV_FLAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (appDelegate.isPurchased == NO && appDelegate.lite_adv == YES)
    {
        [self.lite_Btn setHidden:NO];
        
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height;
        self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    self.dropboxShowPDFContor = nil;
    [self initInvoiceData];
    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    
//    NSFetchRequest  *fetchRequest = [[NSFetchRequest alloc]init];
//    NSEntityDescription *InvoiceEntity = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:appDelegate.managedObjectContext];
//    [fetchRequest setEntity:InvoiceEntity];
//    NSArray *requests = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    Invoice *invocie = [requests firstObject];
//    NSLog(@"invoice log 个数:%lu",(unsigned long)[invocie.logs count]);
}

#pragma mark Action
-(void)initInvoiceData
{
    
    if (self.dropboxShowPDFContor != nil)
    {
        [self.dropboxShowPDFContor initPDFdata];
    }
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //获取所有存在的invoice数组
    NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
    currencyStr = appDelegate.currencyStr;
    
    [self.openArray removeAllObjects];
    [self.paidArray removeAllObjects];
    openMoney_float = 0;
    
    if ([requests count] == 0)
    {
        [self.tipImagV setHidden:NO];
    }
    
    //这里有问题
    else
    {
        //syncing  dataMarray存放的是什么
        //        NSMutableArray *dataMarray = [[NSMutableArray alloc] init];
        
        //获取到的存在的invoice数组
        NSMutableArray *invoiceArray = [[NSMutableArray alloc] initWithArray:requests];
        for (int i=0; i<[invoiceArray count]; i++)
        {
            //如果该invoice中不存在合法的log，标明这个invoice中没有一个log，那么这个invoice是不应该存在的，应该删除该invoice及其关联
            Invoice *_invoice = [invoiceArray objectAtIndex:i];
//            if ([[appDelegate removeAlready_DeleteLog:[_invoice.logs allObjects]] count] == 0)
//            {
//                
//                //                //syncing
//                //                if ([dataMarray containsObject:_invoice] == NO)
//                //                {
//                //                    [dataMarray addObject:_invoice];
//                //                }
//                //                for (Logs *_log in [_invoice.logs allObjects])
//                //                {
//                //                    if ([dataMarray containsObject:_log] == NO)
//                //                    {
//                //                        [dataMarray addObject:_log];
//                //                    }
//                //                }
//                //                for (Invoiceproperty *_invproty in [_invoice.invoicepropertys allObjects])
//                //                {
//                //                    if ([dataMarray containsObject:_invproty] == NO)
//                //                    {
//                //                        [dataMarray addObject:_invproty];
//                //                    }
//                //                }
//                
//                
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
        
        //hmj delete
        //        //syncing
        //        [appDelegate localToServerSync:dataMarray isRelance:NO];
        
        
        
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}








/*
    添加Invoice功能，免费版限制的个数是2个Invoice
 */
-(void)addInvoice
{
    [Flurry logEvent:@"3_INV_ADD"];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isPurchased == NO)
    {
        //获取Invoice表单的个数
        NSArray *requests = [[DataBaseManger getBaseManger] do_getInvoiceData];
        if ([requests count]>1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"You've reached the maximum number of invoices allowed for this lite version." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
            alertView.tag = 1;
            [alertView show];
            
            appDelegate.close_PopView = alertView;
            
            return;
        }
    }
    
    
    EditInvoiceNewViewController *controller =  [[EditInvoiceNewViewController alloc] initWithNibName:@"EditInvoiceNewViewController" bundle:nil];
    
    controller.navi_tittle = @"New Invoice";
    controller.myinvoce = nil;
    
    [controller setHidesBottomBarWhenPushed:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
    appDelegate.m_widgetController = self;
    
}


-(void)searchBtnPressed:(id)sender
{
    NSLog(@"Pressed SearchBar");
}








#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.openArray count] == 0)
    {
        return 0;
    }
    else if (section == 1 && [self.paidArray count] == 0)
    {
        return 0;
    }
    
    return 24;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    v.backgroundColor = [HMJNomalClass creatTableViewHeaderColor];
    
   
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 200,v.height)];
	label.textAlignment = NSTextAlignmentLeft;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    label.textColor = [HMJNomalClass creatAmountColor];
    [v addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, v.height-SCREEN_SCALE, v.width, SCREEN_SCALE)];
    line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    [v addSubview:line];
    if (section == 0)
    {
//        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//        NSString *showMoney = [appDelegate appMoneyShowStly4:openMoney_float];
//        
//        label.text = [NSString stringWithFormat:@"Open:  %@%@",currencyStr,showMoney];
        
        label.textColor = [HMJNomalClass creatAmountColor];
        label.text = @"UNPAID";

    }
    else
    {
        label.textColor = [HMJNomalClass creatAmountBlueColor_107_133_158];
        label.text = @"PAID";
    }
    
    
	
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.openArray count];
    }
    else
    {
        return [self.paidArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"cell";
    
    invoiceShow_Cell *myInvoiceCells = (invoiceShow_Cell*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (myInvoiceCells == nil)
    {
        myInvoiceCells = [[invoiceShow_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [myInvoiceCells.totalMoneyLbel creatSubViewsisLeftAlignment:NO];
    }
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    Invoice *sel_invoice;
    
    float left=0;
    if (IS_IPHONE_6PLUS)
        left = 20;
    else
        left = 15;
    if (indexPath.section == 0)
    {
        sel_invoice = [self.openArray objectAtIndex:indexPath.row];
        [myInvoiceCells.totalMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[sel_invoice.balanceDue doubleValue]] color:[HMJNomalClass creatAmountColor]];
        [myInvoiceCells.totalMoneyLbel setNeedsDisplay];

        if (indexPath.row == [self.openArray count]-1)
        {
            myInvoiceCells.bottomLine.left = 0;
        }
        else
            myInvoiceCells.bottomLine.left = left;
    }
    else
    {
        sel_invoice = [self.paidArray objectAtIndex:indexPath.row];
        [myInvoiceCells.totalMoneyLbel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[sel_invoice.paidDue doubleValue]] color:[HMJNomalClass creatAmountBlueColor_107_133_158]];
        [myInvoiceCells.totalMoneyLbel setNeedsDisplay];
        
        if (indexPath.row == [self.paidArray count]-1)
        {
            myInvoiceCells.bottomLine.left = 0;
        }
        else
            myInvoiceCells.bottomLine.left = left;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMM dd, yyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *dateString = [NSString stringWithFormat:@" - %@",[dateFormatter stringFromDate:sel_invoice.dueDate]];
    NSString *totalString = [NSString stringWithFormat:@"%@%@",sel_invoice.title,dateString];
    
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc]initWithString:totalString];
    NSRange nameRange = NSMakeRange(0, [sel_invoice.title length]);
    NSRange dateRange = NSMakeRange(nameRange.length, [dateString length]);
    UIFont *nameFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:15];
    UIFont *dateFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
    UIColor *nameColor = [HMJNomalClass creatBlackColor_20_20_20];
    UIColor *dateColor = [HMJNomalClass creatGrayColor_164_164_164];
    
    [mutableAttrString addAttribute:NSFontAttributeName value:nameFont range:nameRange];
    [mutableAttrString addAttribute:NSFontAttributeName value:dateFont range:dateRange];
    [mutableAttrString addAttribute:NSForegroundColorAttributeName value:nameColor range:nameRange];
    [mutableAttrString addAttribute:NSForegroundColorAttributeName value:dateColor range:dateRange];
    
    myInvoiceCells.invoiceNameLbel.attributedText = mutableAttrString;
//    myInvoiceCells.invoiceNameLbel.text = sel_invoice.title;
    
    
    myInvoiceCells.clientNameLabel.text = sel_invoice.client.clientName;
    
//    myInvoiceCells.dueDateLbel.text = [dateFormatter stringFromDate:sel_invoice.dueDate];
    
    
//    UIImageView *backImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
//    [myInvoiceCells setBackgroundView:backImage];
    
    
    return myInvoiceCells;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Invoice *sel_invoice;
    if (indexPath.section == 0)
    {
        sel_invoice = [self.openArray objectAtIndex:indexPath.row];
    }
    else
    {
        sel_invoice = [self.paidArray objectAtIndex:indexPath.row];
    }
    

    ShowPDFViewController *pdfShowView = [[ShowPDFViewController alloc] initWithNibName:@"ShowPDFViewController" bundle:nil];
    
    self.dropboxShowPDFContor = pdfShowView;
    
    pdfShowView.selectInvoice = sel_invoice;
    
    [pdfShowView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:pdfShowView animated:YES];
    
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




/*
    点击该页面免费版的广告事件
 */
-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)pop_system_UnlockLite
{
    float higt;
    higt = [[UIScreen mainScreen] bounds].size.height-44-20;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];

}







@end
