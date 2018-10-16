//
//  AddLogViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddLogViewController_ipad.h"

#import "AppDelegate_iPad.h"
#import "Logs.h"
#import "CaculateMoney.h"



@interface AddLogViewController_ipad ()
{
    int exportRow;   // 0: 空;  1:start;  ...  4:break time;
    UIDatePicker *sel_datePicker1;
    UIDatePicker *sel_datePicker2;
    UIPickerView *sel_Picker1;
    UIPickerView *sel_Picker2;
    NSMutableArray *hoursArray;
	NSMutableArray *minutesArray;
    NSInteger hourMax;
    NSInteger minMax;
    BOOL isNeedMax;
    NSInteger nowHourRow;
    
    float keyHigh;
}
@end





@implementation AddLogViewController_ipad

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
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = appDelegate.naviFont2;
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Add Entry"];
    
    self.rateStr = ZERO_NUM;
    self.rateField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,ZERO_NUM];
    
    if (self.startDate == nil)
    {
        self.startDate = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDate;
    [calendar rangeOfUnit:kCFCalendarUnitMinute startDate:&firstDate interval:NULL forDate:self.startDate];
    self.startDate = firstDate;
    
    self.endDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdhmm" options:0 locale:[NSLocale currentLocale]]];
    self.endDateLbel.text = @"";
    self.startDateLbel.text = [dateFormatter stringFromDate:self.startDate];

    self.m_timeStr = @"0:00";
    self.m_breakStr = @"0:00";
    
    if (self.myclient != nil)
    {
        self.clientLbel.text = self.myclient.clientName;
        
        self.rateStr = [appDelegate getRateByClient:self.myclient  date:self.startDate];;
        self.rateField.text = [appDelegate appMoneyShowStly:self.rateStr];
    }
    
    self.taxSwitch.on = NO;
    
    exportRow = 0;
    sel_datePicker1 = nil;
    sel_datePicker2 = nil;
    sel_Picker1 = nil;
    sel_Picker2 = nil;
    hoursArray = [[NSMutableArray alloc] init];
    minutesArray = [[NSMutableArray alloc] init];
    
    keyHigh = 220;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    if (sel_datePicker1 == nil)
    {
        sel_datePicker1 = [[UIDatePicker alloc] init];
        sel_datePicker1.frame = CGRectMake(0, 44, 500, 216);
        [sel_datePicker1 setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.startDateCell addSubview:sel_datePicker1];
    }
    if (sel_datePicker2 == nil)
    {
        sel_datePicker2 = [[UIDatePicker alloc] init];
        sel_datePicker2.frame = CGRectMake(0, 44, 500, 216);
        [sel_datePicker2 addTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
        [sel_datePicker2 setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.endDateCell addSubview:sel_datePicker2];
    }
    if (sel_Picker1 == nil)
    {
        sel_Picker1 = [[UIPickerView alloc] init];
        sel_Picker1.showsSelectionIndicator = YES;
        sel_Picker1.frame = CGRectMake(0, 44, 500, 216);
        [self.timeWorkCell addSubview:sel_Picker1];
    }
    if (sel_Picker2 == nil)
    {
        sel_Picker2 = [[UIPickerView alloc] init];
        sel_Picker2.showsSelectionIndicator = YES;
        sel_Picker2.frame = CGRectMake(0, 44, 500, 216);
        [self.breakTimeCell addSubview:sel_Picker2];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.tableView setContentInset:size];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}


#pragma mark Action
-(void)saveBack
{
    if (self.myclient == nil || self.myclient.clientName == nil || self.startDate == nil || self.endDate == nil)
    {
        if (self.myclient == nil || self.myclient.clientName == nil)
        {
            self.myclient = nil;
            self.clientLbel.text = @"";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"'Client' and start/end time are needed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        appDelegate.close_PopView = alertView;
        
    }
    else 
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        
        if ([appDelegate  getLogsWorkedTimeSecond:self.m_timeStr] < 60)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Duration time cannot be 0!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            
            appDelegate.close_PopView = alertView;
            
            
            return;
        }

        if (self.taxSwitch.on == YES)
        {
            [Flurry logEvent:@"2_PPD_ADDENYOTF"];
        }
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        Logs *addLog = [NSEntityDescription insertNewObjectForEntityForName:@"Logs" inManagedObjectContext:context];
        
        addLog.finalmoney = self.m_breakStr;
        addLog.client = self.myclient;
        addLog.starttime = self.startDate;
        addLog.endtime = self.endDate;
        addLog.ratePerHour = self.rateStr;
        
        NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:self.myclient rate:self.rateStr totalTime:self.m_timeStr totalTimeInt:0];
        addLog.totalmoney = [backArray objectAtIndex:0];
        addLog.worked = [backArray objectAtIndex:1];
    
        addLog.notes = self.noteTextV.text;
        addLog.isInvoice = [NSNumber numberWithBool:NO];
        addLog.isPaid = [NSNumber numberWithInt:0];
        
        addLog.sync_status = [NSNumber numberWithInteger:0];
        addLog.accessDate = [NSDate date];
        addLog.uuid = [appDelegate getUuid];
        addLog.client_Uuid = self.myclient.uuid;
        
        if (self.taxSwitch.on == YES)
        {
            addLog.overtimeFree = [NSNumber numberWithInt:1];
        }
        else
        {
            addLog.overtimeFree = [NSNumber numberWithInt:0];
        }
        
        //client
        self.myclient.accessDate = [NSDate date];
        [context save:nil];
        [context save:nil];        
        
        [appDelegate.mainView reflashTimerMainView];

        
        //syncing
        [appDelegate.parseSync updateLogFromLocal:addLog];
        [appDelegate.parseSync updateClientFromLocal:self.myclient];
        
        [self back];
    }
}



-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}








#pragma mark -
#pragma mark  TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.rateField.text = self.rateStr;
    
    exportRow = 0;
    
    UIEdgeInsets size = {0,0,keyHigh,0};
    [self.tableView setContentInset:size];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.tableView deselectRowAtIndexPath:sel_indexPath animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    self.rateField.text = [appDelegate appMoneyShowStly:self.rateStr];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.tableView setContentInset:size];
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
        self.rateStr = newString;
        
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
        self.rateStr = newString1;
        
        return NO;
    }
    else
    {
        return NO;
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
    
    
    [UIView animateWithDuration:0.25 animations:^
     {
         NSIndexPath *sel_indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
         [self.tableView scrollToRowAtIndexPath:sel_indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
         
         UIEdgeInsets size = {0,0,keyHigh,0};
         [self.tableView setContentInset:size];
         
         [self.tableView beginUpdates];
         [self.tableView endUpdates];
         
         
         NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
         [self.tableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
         [self.tableView deselectRowAtIndexPath:sel_indexPath animated:YES];
     }
                     completion:^(BOOL finished)
     {
     }
     ];
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
    [self.tableView setContentInset:size];
}








#pragma mark -
#pragma mark  TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 5;
    }
    else
    {
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        return 108;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row+1 == exportRow)
        {
            return 260;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        return 44;
    }
}

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
            [self.rateCell setBackgroundView:bv];
            
            return self.rateCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.startDateCell setBackgroundView:bv];
            
            return self.startDateCell;
        }
        else if (indexPath.row == 1)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.endDateCell setBackgroundView:bv];
            
            return self.endDateCell;
        }
        else if (indexPath.row == 2)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.timeWorkCell setBackgroundView:bv];
            
            return self.timeWorkCell;
        }
        else if (indexPath.row == 3)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.breakTimeCell setBackgroundView:bv];
            
            return self.breakTimeCell;
        }
        else
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.taxCell setBackgroundView:bv];
            
            return self.taxCell;
        }
    }
    else
    {
        UIImage *image = [[UIImage imageNamed:@"cell1_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
        [self.noteCell setBackgroundView:bv];
        
        return self.noteCell;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            [self.rateField becomeFirstResponder];
        }
        else
        {
            exportRow = 0;
            [self downKeyBroad];
            
            SelectClientViewController_ipad *selectClientView = [[SelectClientViewController_ipad alloc] initWithNibName:@"SelectClientViewController_ipad" bundle:nil];
            
            selectClientView.selectClient = self.myclient;
            selectClientView.delegate = self;
            
            [self.navigationController pushViewController:selectClientView animated:YES];
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 4)
        {
            return;
        }
        [self downKeyBroad];
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (indexPath.row == 0 && exportRow != 1)
        {
            [Flurry logEvent:@"2_PPD_ADDENYSTA"];
            
            exportRow = 1;
            
            [sel_datePicker2 removeTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
            [sel_datePicker1 addTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
            sel_datePicker1.date = self.startDate;
            if (self.endDate != nil)
            {
                NSDate *end = [NSDate dateWithTimeInterval:-[appDelegate getLogsWorkedTimeSecond:self.m_breakStr] sinceDate:self.endDate];
                sel_datePicker1.maximumDate = end;
            }
            else
            {
                sel_datePicker1.maximumDate = nil;
            }
            sel_datePicker1.minimumDate = nil;
        }
        else if(indexPath.row == 1 && exportRow != 2)
        {
            [Flurry logEvent:@"2_PPD_ADDENYEND"];
            
            exportRow = 2;
            
            [sel_datePicker1 removeTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
            [sel_datePicker2 addTarget:self action:@selector(doPickerDate) forControlEvents:UIControlEventValueChanged];
            NSDate *start = [NSDate dateWithTimeInterval:[appDelegate  getLogsWorkedTimeSecond:self.m_breakStr] sinceDate:self.startDate];
            sel_datePicker2.minimumDate = start;
            if (self.endDate != nil)
            {
                sel_datePicker2.date = self.endDate;
            }
            else
            {
                sel_datePicker2.date = start;
            }
            sel_datePicker2.maximumDate = nil;
        }
        else if (indexPath.row == 2 && exportRow != 3)
        {
            [Flurry logEvent:@"2_PPD_ADDENYDUR"];
            
            exportRow = 3;
            
            if (sel_Picker2 != nil)
            {
                sel_Picker2.delegate = nil;
                sel_Picker2.dataSource = nil;
            }
            sel_Picker1.delegate = self;
            sel_Picker1.dataSource = self;
            
            [hoursArray removeAllObjects];
            [minutesArray removeAllObjects];
            
            isNeedMax = NO;
            hourMax = 101;
            minMax = 60;
            for (int i=0 ; i<hourMax; i++)
            {
                [hoursArray addObject:[NSString stringWithFormat:@"%d Hours",i]];
            }
            for (int i=0; i<minMax; i++)
            {
                [minutesArray addObject:[NSString stringWithFormat:@"%d Minutes",i]];
            }
            if (![self.m_timeStr isEqualToString:@""])
            {
                NSArray *array = [self.m_timeStr componentsSeparatedByString:@":"];
                NSString *str1 = [array objectAtIndex:0];
                NSString *str2 = [array objectAtIndex:1];
                int firstRow = [str1 intValue];
                int secondRow = [str2 intValue];
                firstRow = firstRow>100?100:firstRow;
                [sel_Picker1 selectRow:firstRow inComponent:0 animated:YES];
                [sel_Picker1 selectRow:secondRow inComponent:1 animated:YES];
                
                nowHourRow = firstRow;
                [sel_Picker1 reloadComponent:1];
            }
        }
        else if (indexPath.row == 3 && exportRow != 4)
        {
            [Flurry logEvent:@"2_PPD_ADDENYBRK"];
            
            exportRow = 4;
            
            if (sel_Picker1 != nil)
            {
                sel_Picker1.delegate = nil;
                sel_Picker1.dataSource = nil;
            }
            sel_Picker2.delegate = self;
            sel_Picker2.dataSource = self;
            
            [hoursArray removeAllObjects];
            [minutesArray removeAllObjects];
            
            isNeedMax = YES;
            if (self.endDate == nil || self.startDate == nil)
            {
                minMax = 1;
                hourMax = 1;
            }
            else
            {
                NSInteger seconde = [self.endDate timeIntervalSinceDate:self.startDate];
                hourMax = seconde/3600;
                hourMax = hourMax>100?101:hourMax+1;
                seconde = seconde%3600;
                minMax = seconde/60;
                minMax= minMax>59?60:minMax+1;
            }
            for (int i=0 ; i<hourMax; i++)
            {
                [hoursArray addObject:[NSString stringWithFormat:@"%d Hours",i]];
            }
            for (int i=0; i<minMax; i++)
            {
                [minutesArray addObject:[NSString stringWithFormat:@"%d Minutes",i]];
            }
            if (![self.m_breakStr isEqualToString:@""])
            {
                NSArray *array = [self.m_breakStr componentsSeparatedByString:@":"];
                NSString *str1 = [array objectAtIndex:0];
                NSString *str2 = [array objectAtIndex:1];
                int firstRow = [str1 intValue];
                int secondRow = [str2 intValue];
                firstRow = firstRow>100?100:firstRow;
                [sel_Picker2 selectRow:firstRow inComponent:0 animated:YES];
                [sel_Picker2 selectRow:secondRow inComponent:1 animated:YES];
                
                nowHourRow = firstRow;
                [sel_Picker2 reloadComponent:1];
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
                 [self.tableView scrollToRowAtIndexPath:sel_indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                 
                 [self.tableView beginUpdates];
                 [self.tableView endUpdates];
             }
                             completion:^(BOOL finished)
             {
                 
             }
             ];
        }
        else
        {
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        [Flurry logEvent:@"2_PPD_ADDENYNOTE"];
        
        [self.noteTextV becomeFirstResponder];
    }
    else
    {
        return;
    }
}


-(void)downKeyBroad
{
    if ([self.rateField isFirstResponder])
    {
        [self.rateField resignFirstResponder];
    }
    if ([self.noteTextV isFirstResponder])
    {
        [self.noteTextV resignFirstResponder];
    }
}



#pragma mark -
#pragma mark   Save Client

-(void)saveSelectClient:(Clients *)_selectClient
{
    if (_selectClient != nil)
    {
        self.myclient = _selectClient;
        self.clientLbel.text = _selectClient.clientName;
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        self.rateStr = [appDelegate getRateByClient:_selectClient  date:self.startDate];
        self.rateField.text = [appDelegate appMoneyShowStly:self.rateStr];
    }
}






#pragma mark -
#pragma mark  DatePicker Delegate

-(void)doPickerDate
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdhmm" options:0 locale:[NSLocale currentLocale]]];
    
    if (exportRow == 1)
    {
        NSDate *end = [NSDate dateWithTimeInterval:-[appDelegate getLogsWorkedTimeSecond:self.m_breakStr] sinceDate:self.endDate];
        
        if ([sel_datePicker1.date compare:end] == NSOrderedDescending)
        {
            return;
        }
        
        self.startDateLbel.text = [dateFormatter stringFromDate:sel_datePicker1.date];
        self.startDate = sel_datePicker1.date;
    }
    else
    {
        NSDate *start = [NSDate dateWithTimeInterval:[appDelegate getLogsWorkedTimeSecond:self.m_breakStr] sinceDate:self.startDate];
        
        if ([sel_datePicker2.date compare:start] == NSOrderedAscending)
        {
            return;
        }
        
        self.endDateLbel.text = [dateFormatter stringFromDate:sel_datePicker2.date];
        self.endDate = sel_datePicker2.date;
    }
    
    
    
    NSTimeInterval timecount = [self.endDate timeIntervalSinceDate:self.startDate] - [appDelegate getLogsWorkedTimeSecond:self.m_breakStr];
    self.timeWorkLbel.text = [appDelegate conevrtTime2:(int)timecount];
    self.m_timeStr = [appDelegate conevrtTime4:(int)timecount];
}






#pragma mark -
#pragma mark  PickerView Delegate

-(void)doPIckerView:(NSString *)pickerStr
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (exportRow == 3)
    {
        self.m_timeStr = pickerStr;
        int workCount = [appDelegate getLogsWorkedTimeSecond:pickerStr];
        self.timeWorkLbel.text = [appDelegate conevrtTime2:workCount];
        
        
        NSInteger lastTotalSeconds = workCount + [appDelegate getLogsWorkedTimeSecond:self.m_breakStr];
        
        self.endDate = [[NSDate date] initWithTimeInterval:lastTotalSeconds sinceDate:self.startDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdhmm" options:0 locale:[NSLocale currentLocale]]];
        
        self.endDateLbel.text = [dateFormatter stringFromDate:self.endDate];
    }
    else
    {        
        self.m_breakStr = pickerStr;
        int breakCount = [appDelegate getLogsWorkedTimeSecond:pickerStr];
        self.breakTimeLbel.text = [appDelegate conevrtTime2:breakCount];
        
        NSTimeInterval timecount = [self.endDate timeIntervalSinceDate:self.startDate] - breakCount;
        self.timeWorkLbel.text = [appDelegate conevrtTime2:(int)timecount];
        self.m_timeStr = [appDelegate conevrtTime4:(int)timecount];
    }
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0)
    {
		return hourMax;
	}
	else
    {
        if (isNeedMax == YES)
        {
            int hourbig = (int)[pickerView selectedRowInComponent:0];
            [minutesArray removeAllObjects];
            if (hourbig == hourMax-1)
            {
                for (int i=0; i<minMax; i++)
                {
                    [minutesArray addObject:[NSString stringWithFormat:@"%d Minutes",i]];
                }
                
                return minMax;
            }
            else
            {
                for (int i=0; i<60; i++)
                {
                    [minutesArray addObject:[NSString stringWithFormat:@"%d Minutes",i]];
                }
                
                return 60;
            }
        }
        
        return minMax;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isNeedMax == YES)
    {
        int hourbig = (int)[pickerView selectedRowInComponent:0];
        if ((hourbig == hourMax-1 && hourbig != nowHourRow) || (nowHourRow == hourMax-1 && hourbig != hourMax-1))
        {
            [pickerView reloadComponent:1];
        }
        nowHourRow = hourbig;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self doPIckerView:[appDelegate conevrtTime4:((int)[pickerView selectedRowInComponent:0]*3600+(int)[pickerView selectedRowInComponent:1]*60)]];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
	if (component == 0)
    {
		return [hoursArray objectAtIndex:row];
	}
    else
    {
		return [minutesArray objectAtIndex:row];
	}
}


@end
