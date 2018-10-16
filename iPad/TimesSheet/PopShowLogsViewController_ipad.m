//
//  PopShowLogsViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopShowLogsViewController_ipad.h"
#import "Custom1ViewController.h"
#import "TimesheetLogs_Cell2.h"
#import "EditLogViewController_ipad.h"
#import "AddLogViewController_ipad.h"

#import "AppDelegate_iPad.h"
#import "Logs.h"

#import "OverTimeViewController.h"

#import "TimeStartViewCell.h"


@implementation PopShowLogsViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.logsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pointInTimeDateFormatter = [[NSDateFormatter alloc] init];
    [pointInTimeDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dayDateFormatter = [[NSDateFormatter alloc]init];
    [dayDateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    UILabel *titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1];
    titleLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *naviStr;
    if (self.showStly == 0)
    {
        naviStr = self.myClient.clientName;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        
        naviStr = [dateFormatter stringFromDate:self.startDate];
    }
    titleLabel.text = naviStr;
    self.navigationItem.titleView = titleLabel;
    
    

    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIColor *color1 = [UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:117.0/255 green:175.0/255 blue:229.0/255 alpha:1];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.titleLabel.font = appDelegate.naviFont;
    [self.editButton addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.frame = CGRectMake(0, 0, 48, 30);
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton setTitle:@"Done" forState:UIControlStateSelected];
    [appDelegate setNaviGationItem:self isLeft:YES button:self.editButton];
    [self.editButton setTitleColor:color1 forState:UIControlStateNormal];
    [self.editButton setTitleColor:color2 forState:UIControlStateHighlighted];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.titleLabel.font = appDelegate.naviFont;
    addButton.frame = CGRectMake(0, 0, 48, 30);
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:addButton];
    [addButton setTitleColor:color1 forState:UIControlStateNormal];
    [addButton setTitleColor:color1 forState:UIControlStateHighlighted];
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
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    
//    self.myTableView;
//    self.logsList;
    
}





-(void)doEdit
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if ([self.myTableView isEditing])
    {
//        self.editButton.titleLabel.font = appDelegate.naviFont;
//        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.myTableView setEditing:NO animated:YES];
        self.editButton.selected = NO;
    }
    else
    {
//        self.editButton.titleLabel.font = appDelegate.naviFont2;
//        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.myTableView setEditing:YES animated:YES];
        self.editButton.selected = YES;

    }
}

-(void)doAdd
{
    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate_ipad.mainView.timersheetView.popoverController isPopoverVisible])
    {
        [appDelegate_ipad.mainView.timersheetView.popoverController dismissPopoverAnimated:YES];
    }
    
    
    AddLogViewController_ipad *addLogView = [[AddLogViewController_ipad alloc] initWithNibName:@"AddLogViewController_ipad" bundle:nil];
    if (self.showStly == 0)
    {
        addLogView.myclient = self.myClient;
    }
    addLogView.startDate = self.startDate;
    
    Custom1ViewController *addLogNavi = [[Custom1ViewController alloc]initWithRootViewController:addLogView];
    addLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    addLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [appDelegate_ipad.mainView presentViewController:addLogNavi animated:YES completion:nil];
    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
    
}













#pragma mark TableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    TimeStartViewCell *seleCell = (TimeStartViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    //---根据选定的cell的状态来更改tableView的状态
    if (seleCell.editing) {
        self.editButton.selected = NO;
        return NO;
    }
    else{
        //        self.editButton.selected = YES;
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editButton.selected = YES;
    return UITableViewCellEditingStyleDelete;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logsList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString* identifier = @"timesheetLogsCell2-Identifier";
//    TimesheetLogs_Cell2 *mytimeSheetLogsCells = (TimesheetLogs_Cell2*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
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
//    Logs *sel_log = [self.logsList objectAtIndex:indexPath.row];
//    mytimeSheetLogsCells.backgroundColor = [UIColor whiteColor];
////    UIImageView *backImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
////    [mytimeSheetLogsCells setBackgroundView:backImage];
////    mytimeSheetLogsCells.high = 50;
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
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    mytimeSheetLogsCells.startDateLbel.text = [dateFormatter stringFromDate:sel_log.starttime];
//    
//    
//    if (showStly == 0)
//    {
//        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
//        mytimeSheetLogsCells.dateLbel.text = [dateFormatter stringFromDate:sel_log.starttime];
//    }
//    else
//    {
//        mytimeSheetLogsCells.dateLbel.text = sel_log.client.clientName;
//    }
//    
//    mytimeSheetLogsCells.totalTimerLbel.text = [appDelegate conevrtTime:sel_log.worked];
//
//    mytimeSheetLogsCells.totalMoneyLbel.text = [appDelegate appMoneyShowStly:sel_log.totalmoney];
//    
//    return mytimeSheetLogsCells;
    
    
    NSString* identifier = @"identifier";
    TimeStartViewCell *cell = (TimeStartViewCell*)[self.myTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[TimeStartViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.amountView creatSubViewsisLeftAlignment:NO];
        
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    Logs *sel_log = [self.logsList objectAtIndex:indexPath.row];
    
    
    
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
//    if (indexPath.row == [self.clientLogArray count]-1)
//    {
//        cell.bottomLine.left = 0;
//    }
//    else
//    {
//        float left = 15;
//        if (IS_IPHONE_6PLUS)
//        {
//            left = 20;
//        }
//        cell.bottomLine.left = left;
//    }
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_iPad * appDelegate_ipad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate_ipad.mainView.timersheetView.popoverController isPopoverVisible])
    {
        [appDelegate_ipad.mainView.timersheetView.popoverController dismissPopoverAnimated:YES];
    }
    
    
    EditLogViewController_ipad *editLogView = [[EditLogViewController_ipad alloc] initWithNibName:@"EditLogViewController_ipad" bundle:nil];
    editLogView.selectLog = [self.logsList objectAtIndex:indexPath.row];
    
    Custom1ViewController *editLogNavi = [[Custom1ViewController alloc]initWithRootViewController:editLogView];
    editLogNavi.modalPresentationStyle = UIModalPresentationFormSheet;
    editLogNavi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [appDelegate_ipad.mainView presentViewController:editLogNavi animated:YES completion:nil];
    appDelegate_ipad.m_widgetController = appDelegate_ipad.mainView;
    
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    Logs *_selectLog = [self.logsList objectAtIndex:indexPath.row];
    
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



-(void)deletLog_index:(NSIndexPath *)indexPath
{
    Logs *_selectLog = [self.logsList objectAtIndex:indexPath.row];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    
    [self.logsList removeObject:_selectLog];
    _selectLog.accessDate = [NSDate date];
    _selectLog.sync_status = [NSNumber numberWithInteger:1];
    [appDelegate.managedObjectContext save:nil];
    
    
    //syncing
    [[DataBaseManger getBaseManger] do_changeLogToInvoice:_selectLog stly:1];

    [appDelegate.parseSync updateLogFromLocal:_selectLog];
    
    
    
    
    [self.myTableView beginUpdates];
    NSArray *deleteArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.myTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationLeft];
    [self.myTableView endUpdates];
    if (indexPath.row == [self.logsList count] && [self.logsList count] != 0)
    {
        NSIndexPath *reflashPath = [NSIndexPath indexPathForRow:[self.logsList count]-1 inSection:0];
        NSArray *reflashArray = [[NSArray alloc] initWithObjects:reflashPath, nil];
        [self.myTableView reloadRowsAtIndexPaths:reflashArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    appDelegate.isDeleteFlashPop = YES;
    [appDelegate.mainView reflashTimerMainView];
    
    if ([self.logsList count] == 0)
    {
        if ([appDelegate.mainView.timersheetView.popoverController isPopoverVisible])
        {
            [appDelegate.mainView.timersheetView.popoverController dismissPopoverAnimated:YES];
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
    if([appDelegate.mainView.timersheetView.popoverController isPopoverVisible])
    {
        [appDelegate.mainView.timersheetView.popoverController dismissPopoverAnimated:YES];
    }
    
    Logs *sel_log = [self.logsList objectAtIndex:0];
    
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
