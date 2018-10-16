//
//  projectToTaskViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "projectToTaskViewController_ipad.h"
#import "Custom1ViewController.h"
#import "AppDelegate_iPad.h"
#import "Logs.h"
#import "TimesheetLogs_Cell2.h"
#import "EditLogViewController_ipad.h"
#import "OverTimeViewController.h"

#import "TimeStartViewCell.h"

@implementation projectToTaskViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _allLogsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.navi_tittle;
    pointInTimeDateFormatter = [[NSDateFormatter alloc] init];
    [pointInTimeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dayDateFormatter = [[NSDateFormatter alloc]init];
    [dayDateFormatter setDateFormat:@"MMM dd, yyyy"];
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



-(void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;

    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
    [self.allLogsList sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    
    [self.tableView reloadData];
}








#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allLogsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString* identifier = @"timesheetLogsCell2-Identifier";
//    TimesheetLogs_Cell2 *mytimeSheetLogsCells = (TimesheetLogs_Cell2*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
//    if (mytimeSheetLogsCells == nil)
//    {
//        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TimesheetLogs_Cell2" owner:self options:nil];
//        
//        for (id oneObject in nibs)
//        {
//            if ([oneObject isKindOfClass:[TimesheetLogs_Cell2 class]])
//            {
//                mytimeSheetLogsCells = (TimesheetLogs_Cell2*)oneObject;
//            }
//        }
//    }
//    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    
//    Logs *sel_log = [self.allLogsList objectAtIndex:indexPath.row];
//    
//    UIImageView *backImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
//    [mytimeSheetLogsCells setBackgroundView:backImage];
//    mytimeSheetLogsCells.high = 50;
//
//    
//    if ([sel_log.isPaid intValue] == 1)
//    {
//        [mytimeSheetLogsCells.clockImageV setHidden:NO];
//    }
//    else
//    {
//        [mytimeSheetLogsCells.clockImageV setHidden:YES];
//    }
//    
//    
//    if ([sel_log.isInvoice boolValue])
//    {
//        UIColor *grayColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
//        [mytimeSheetLogsCells.dateLbel setTextColor:grayColor];
//        [mytimeSheetLogsCells.totalMoneyLbel setTextColor:grayColor];
//        [mytimeSheetLogsCells.startDateLbel setTextColor:grayColor];
//        [mytimeSheetLogsCells.totalTimerLbel setTextColor:grayColor];
//    }
//    else
//    {
//        [mytimeSheetLogsCells.dateLbel setTextColor:[UIColor blackColor]];
//        [mytimeSheetLogsCells.startDateLbel setTextColor:[UIColor colorWithRed:84/255.0 green:94/255.0 blue:103/255.0 alpha:1]];
//        [mytimeSheetLogsCells.totalTimerLbel setTextColor:appDelegate.appTimeColor];
//        [mytimeSheetLogsCells.totalMoneyLbel setTextColor:appDelegate.appMoneyColor];
//    }
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    mytimeSheetLogsCells.startDateLbel.text = [dateFormatter stringFromDate:sel_log.starttime];
//    
//    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
//    mytimeSheetLogsCells.dateLbel.text = [dateFormatter stringFromDate:sel_log.starttime];
//    
//    mytimeSheetLogsCells.totalTimerLbel.text = [appDelegate conevrtTime:sel_log.worked];
//
//    mytimeSheetLogsCells.totalMoneyLbel.text = [appDelegate appMoneyShowStly:sel_log.totalmoney];
//    
//    return mytimeSheetLogsCells;
    
    NSString* identifier = @"identifier";
    TimeStartViewCell *cell = (TimeStartViewCell*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[TimeStartViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
        
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [self.allLogsList objectAtIndex:indexPath.row];
    
    
    
    if ([sel_log.isPaid intValue] == 1)
    {
        [cell.clockImageV setHidden:NO];
    }
    else
    {
        [cell.clockImageV setHidden:YES];
    }
    
    NSArray *backArray = [appDelegate overTimeMoney_logs:[NSArray arrayWithObject:sel_log]];
    NSNumber *back_time = [backArray objectAtIndex:1];
    long seconds = (long)([back_time doubleValue]*3600);
    NSString *overString = @"";
    NSNumber *overMoney = 0;
    if (seconds/3600 == 0 && (seconds/60)%60 == 0)
    {
        ;
    }
    else
    {
        overMoney = [backArray objectAtIndex:0];
        
        overString = [NSString stringWithFormat:@" (%01ldh %02ldm)",seconds/3600,(seconds/60)%60];
    }
    if([overString length]>0)
    {
        NSString *duationString = [appDelegate conevrtTime:sel_log.worked];
        NSString *totalString = [NSString stringWithFormat:@"%@%@",duationString,overString];
        NSMutableAttributedString *totalStringAttr = [[NSMutableAttributedString alloc]initWithString:totalString];
        NSRange duationRange = NSMakeRange(0, [duationString length]);
        NSRange overRange = NSMakeRange(duationRange.length, [overString length]);
        UIFont *duationFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
        UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
        UIColor *duationColor = [HMJNomalClass creatBlackColor_20_20_20];
        UIColor *overColor = [HMJNomalClass creatRedColor_244_79_68];
        [totalStringAttr addAttribute:NSFontAttributeName value:duationFont range:duationRange];
        [totalStringAttr addAttribute:NSFontAttributeName value:overFont range:overRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:duationColor range:duationRange];
        [totalStringAttr addAttribute:NSForegroundColorAttributeName value:overColor range:overRange];
        cell.totalTimeLabel.text = nil;
        cell.totalTimeLabel.attributedText = totalStringAttr;
    }
    else
        cell.totalTimeLabel.text = [appDelegate conevrtTime:sel_log.worked];
    cell.pointInTimeLabel.text = [NSString stringWithFormat:@"at %@",[[pointInTimeDateFormatter stringFromDate:sel_log.starttime] lowercaseString]];;
    cell.dateLabel.text = [dayDateFormatter stringFromDate:sel_log.starttime];
    double totalMoney = [sel_log.totalmoney doubleValue] + [overMoney doubleValue];
    [cell.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",totalMoney] color:[HMJNomalClass creatAmountColor]];
    [cell.amountView setNeedsDisplay];
    
    cell.bottomLine.left = 15;
    
    return cell;

}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate_ipad.mainView.chartView.popoverController isPopoverVisible])
    {
        [appDelegate_ipad.mainView.chartView.popoverController dismissPopoverAnimated:YES];
    }
    
    
    EditLogViewController_ipad *editLogView = [[EditLogViewController_ipad alloc] initWithNibName:@"EditLogViewController_ipad" bundle:nil];
    editLogView.selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    Custom1ViewController *editLogNavi = [[Custom1ViewController alloc]initWithRootViewController:editLogView];
    editLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [appDelegate_ipad.mainView presentViewController:editLogNavi animated:YES completion:nil];
    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
    
}




-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Logs *_selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    self.delete_indexPath = indexPath;
    
    if ([_selectLog.isInvoice boolValue])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This log was invoiced, delete this log will also affect the invoice. Do you want to process?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
        
        alertView.tag = 2;
        [alertView show];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        appDelegate.close_PopView = alertView;
        
    }
    else
    {
        [self deletLog_index:self.delete_indexPath];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)deletLog_index:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [self.allLogsList objectAtIndex:indexPath.row];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [self.allLogsList removeObject:_selectLog];
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    [context save:nil];

    
    
    //syncing
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];
    [appDelegate.parseSync updateLogFromLocal:_selectLog];


    
    
    [self.tableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    if (indexPath.row == [self.allLogsList count] && [self.allLogsList count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.allLogsList count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.tableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    
    appDelegate.isDeleteFlashPop = YES;
    [appDelegate.mainView reflashTimerMainView];
    
    if ([self.allLogsList count] == 0)
    {
        if ([appDelegate.mainView.chartView.popoverController isPopoverVisible])
        {
            [appDelegate.mainView.chartView.popoverController dismissPopoverAnimated:YES];
        }
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self deletLog_index:self.delete_indexPath];
        }
    }
}







-(IBAction)doOverTimer
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.mainView.chartView.popoverController isPopoverVisible])
    {
        [appDelegate.mainView.chartView.popoverController dismissPopoverAnimated:YES];
    }
    
    
    Logs *sel_log = [self.allLogsList objectAtIndex:0];
    
    OverTimeViewController *overTimeView = [[OverTimeViewController alloc] initWithNibName:@"OverTimeViewController_ipad" bundle:nil];
    
    overTimeView.sel_client = sel_log.client;
    overTimeView.dateStly = self.overTimeStly;
    overTimeView.startDate = self.startDate;
    if (self.overTimeStly != 0)
    {
        overTimeView.endDate = self.endDate;
    }
    Custom1ViewController *overTimeNavi = [[Custom1ViewController alloc]initWithRootViewController:overTimeView];
    overTimeNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    overTimeNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [appDelegate.mainView presentViewController:overTimeNavi animated:YES completion:nil];
    appDelegate.m_widgetController = appDelegate.mainView;
    
}





@end

