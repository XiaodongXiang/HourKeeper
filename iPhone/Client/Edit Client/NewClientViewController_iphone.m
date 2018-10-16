//
//  NewClientViewController_iphone.m
//  HoursKeeper
//
//  Created by xy_dev on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewClientViewController_iphone.h"

#import "AppDelegate_Shared.h"

#import "DailyOverTime_iPhone.h"
#import "PayEndStlyViewController.h"
#import "AppDelegate_iPhone.h"



@interface NewClientViewController_iphone ()
{
    //当前正在编辑的textfield
    UITextField *currentField;
    BOOL isEditStatus;
    float keyHigh;
    
    int isFirst;
}
@end





@implementation NewClientViewController_iphone

#pragma mark Life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        keyHigh = 286;
        isFirst = 1;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    
    _showMoreOrLessBtn.width = SCREEN_WITH - 30;
    _showMoreOrLessBtn.x = 15;
    _showMoreOrLessBtn.layer.cornerRadius = 2;
    _showMoreOrLessBtn.layer.masksToBounds = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = appDelegate.naviFont;
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:self.navi_tittle];
    
    if([self.navi_tittle isEqualToString:@"New Client"])
    {
        [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    }
    
    self.isDaily = NO;
    self.regularStr = ZERO_NUM;
    self.rateR_Lbel.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.regularStr];
    [self.rateR_Lbel setHidden:NO];
    self.rateL_Lbel.text = @"Regular Rate/h";
    self.monStr = self.regularStr;
    self.tueStr = self.regularStr;
    self.wedStr = self.regularStr;
    self.thuStr = self.regularStr;
    self.friStr = self.regularStr;
    self.satStr = self.regularStr;
    self.sunStr = self.regularStr;
    self.weekStr = self.regularStr;
    
    
    self.dayOverFirstTax = OVER_NONE;
    self.dayOverFirstHour = @"0";
    self.dayOverSecondTax = OVER_NONE;
    self.dayOverSecondHour = @"0";
    self.dailyOvertimeLbel.hidden = NO;
    self.dailyOvertimeLbel1.hidden = YES;
    self.dailyOvertimeLbel2.hidden = YES;
    self.weekOverFirstTax = OVER_NONE;
    self.weekOverFirstHour = @"0";
    self.weekOverSecondTax = OVER_NONE;
    self.weekOverSecondHour = @"0";
    self.weeklyOvertimeLbel.hidden = NO;
    self.weeklyOvertimeLbel1.hidden = YES;
    self.weeklyOvertimeLbel2.hidden = YES;
    
    
    // payPeriodStly -------  1:weekly(sunday:1--saturday:7); 2:bi-weekly; 3:semi-monthly; 4:monthly; 5:every four weeks;6:quarterly;
    // payPeriodNum1 -------  1~30;
    // payPeriodNum2 -------  2~31;
    // payPeriodDate ------- 选择的结束日期；
    
    self.payPeriodStly = 1;
    self.payPeriodNum1 = 1;
    self.payPeriodNum2 = 31;
    self.payPeriodDate = nil;
    
    
    self.phoneField.text = @"";
    self.addressField.text = @"";
    self.emailField.text = @"";
    self.faxField.text = @"";
    self.websiteField.text = @"";
    
    
    if (self.myclient != nil)
    {
        isEditStatus = YES;
        
        self.isMore = NO;
		[_showMoreOrLessBtn setTitle:@"Show Fewer" forState:UIControlStateNormal];
        [_showMoreOrLessBtn setHidden:YES];
        
        
        self.clientField.text = self.myclient.clientName;

        if (self.myclient.r_isDaily.intValue == 1)
        {
            self.isDaily = YES;
        }
        else
        {
            self.isDaily = NO;
        }
        if (self.myclient.r_monRate == nil || [self.myclient.r_monRate isEqualToString:@""])
        {
            self.myclient.r_monRate = self.regularStr;
        }
        if (self.myclient.r_tueRate == nil || [self.myclient.r_tueRate isEqualToString:@""])
        {
            self.myclient.r_tueRate = self.regularStr;
        }
        if (self.myclient.r_wedRate == nil || [self.myclient.r_wedRate isEqualToString:@""])
        {
            self.myclient.r_wedRate = self.regularStr;
        }
        if (self.myclient.r_thuRate == nil || [self.myclient.r_thuRate isEqualToString:@""])
        {
            self.myclient.r_thuRate = self.regularStr;
        }
        if (self.myclient.r_friRate == nil || [self.myclient.r_friRate isEqualToString:@""])
        {
            self.myclient.r_friRate = self.regularStr;
        }
        if (self.myclient.r_satRate == nil || [self.myclient.r_satRate isEqualToString:@""])
        {
            self.myclient.r_satRate = self.regularStr;
        }
        if (self.myclient.r_sunRate == nil || [self.myclient.r_sunRate isEqualToString:@""])
        {
            self.myclient.r_sunRate = self.regularStr;
        }
        if (self.myclient.r_weekRate == nil || [self.myclient.r_weekRate isEqualToString:@""])
        {
            self.myclient.r_weekRate = self.regularStr;
        }
        [self saveClientRate:self.isDaily regular:self.myclient.ratePerHour mon:self.myclient.r_monRate tue:self.myclient.r_tueRate wed:self.myclient.r_wedRate thu:self.myclient.r_thuRate fri:self.myclient.r_friRate sat:self.myclient.r_satRate sun:self.myclient.r_sunRate week:self.myclient.r_weekRate];
        
        self.timeRoundToLbel.text = [self.myclient.timeRoundTo capitalizedString];
        
        NSMutableString *firstText = [NSMutableString stringWithString:self.myclient.dailyOverFirstTax];
        NSMutableString *secondText = [NSMutableString stringWithString:self.myclient.dailyOverSecondTax];
        self.dayOverFirstTax = self.myclient.dailyOverFirstTax;
        self.dayOverFirstHour = self.myclient.dailyOverFirstHour;
        self.dayOverSecondTax = self.myclient.dailyOverSecondTax;
        self.dayOverSecondHour = self.myclient.dailyOverSecondHour;
        if (![self.myclient.dailyOverFirstTax isEqualToString:OVER_NONE])
        {
            [firstText appendString:@" after "];
            [firstText appendString:self.myclient.dailyOverFirstHour];
            [firstText appendString:@"h"];
            firstText = (NSMutableString *)[firstText lowercaseString];
        }
        if (![self.myclient.dailyOverSecondTax isEqualToString:OVER_NONE])
        {
            [secondText appendString:@" after "];
            [secondText appendString:self.myclient.dailyOverSecondHour];
            [secondText appendString:@"h"];
            secondText = (NSMutableString *)[secondText lowercaseString];
        }
        if (![self.myclient.dailyOverSecondTax isEqualToString:OVER_NONE])
        {
            self.dailyOvertimeLbel.hidden = YES;
            self.dailyOvertimeLbel1.hidden = NO;
            self.dailyOvertimeLbel2.hidden = NO;
            self.dailyOvertimeLbel1.text = firstText;
            self.dailyOvertimeLbel2.text = secondText;
        }
        else
        {
            self.dailyOvertimeLbel.hidden = NO;
            self.dailyOvertimeLbel1.hidden = YES;
            self.dailyOvertimeLbel2.hidden = YES;
            self.dailyOvertimeLbel.text = firstText;
        }
        
        NSMutableString *firstText1 = [NSMutableString stringWithString:self.myclient.weeklyOverFirstTax];
        NSMutableString *secondText1 = [NSMutableString stringWithString:self.myclient.weeklyOverSecondTax];
        self.weekOverFirstTax = self.myclient.weeklyOverFirstTax;
        self.weekOverFirstHour = self.myclient.weeklyOverFirstHour;
        self.weekOverSecondTax = self.myclient.weeklyOverSecondTax;
        self.weekOverSecondHour = self.myclient.weeklyOverSecondHour;
        if (![self.myclient.weeklyOverFirstTax isEqualToString:OVER_NONE])
        {
            [firstText1 appendString:@" after "];
            [firstText1 appendString:self.myclient.weeklyOverFirstHour];
            [firstText1 appendString:@"h"];
            firstText1 = (NSMutableString *)[firstText1 lowercaseString];
        }
        if (![self.myclient.weeklyOverSecondTax isEqualToString:OVER_NONE])
        {
            [secondText1 appendString:@" after "];
            [secondText1 appendString:self.myclient.weeklyOverSecondHour];
            [secondText1 appendString:@"h"];
            secondText1 = (NSMutableString *)[secondText1 lowercaseString];
        }
        if (![self.myclient.weeklyOverSecondTax isEqualToString:OVER_NONE])
        {
            self.weeklyOvertimeLbel.hidden = YES;
            self.weeklyOvertimeLbel1.hidden = NO;
            self.weeklyOvertimeLbel2.hidden = NO;
            self.weeklyOvertimeLbel1.text = firstText1;
            self.weeklyOvertimeLbel2.text = secondText1;
        }
        else
        {
            self.weeklyOvertimeLbel.hidden = NO;
            self.weeklyOvertimeLbel1.hidden = YES;
            self.weeklyOvertimeLbel2.hidden = YES;
            self.weeklyOvertimeLbel.text = firstText1;
        }
        
        [self savePayStly:[self.myclient.payPeriodStly intValue] EndFlag1:[self.myclient.payPeriodNum1 intValue] endFlag2:[self.myclient.payPeriodNum2 intValue] endDate:self.myclient.payPeriodDate];
        
        self.phoneField.text = self.myclient.phone;
        self.addressField.text = self.myclient.address;
        self.emailField.text = self.myclient.email;
        self.faxField.text = self.myclient.fax;
        self.websiteField.text = self.myclient.website;
        
        isFirst = 0;
    }
    else
    {
        isEditStatus = NO;
        self.isMore = YES;
    }
    


//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 568)];
//    imageV.image = [[UIImage imageNamed:@"app_bg_320_568.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    self.myTableView.backgroundView = imageV;
    
    [self setSubViewFrame];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (![self.navi_tittle isEqualToString:@"New Client"])
    {
        [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    }
    else
    {
        [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    }
    
    if (isFirst == 1)
    {
        currentField = self.clientField;
        [self.clientField  becomeFirstResponder];
        
        isFirst = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Action

-(void)back
{
    if (currentField != nil && [currentField isFirstResponder])
    {
        [currentField resignFirstResponder];
    }
    if(![self.navi_tittle isEqualToString:@"New Client"])
    {
//        [self.navigationController popViewControllerAnimated:YES];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
     
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
    save client
 */
-(void)saveBack
{
    if (currentField != nil && [currentField isFirstResponder])
    {
        [currentField resignFirstResponder];
    }
    
    if (isEditStatus == YES)
    {
        if (self.myclient == nil || self.myclient.clientName == nil)
        {
            [self back];
            return;
        }
    }
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	if ([self.clientField.text isEqualToString:@""]) 
    {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"'Client Name' is needed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
        
        appDelegate.close_PopView = alertView;
        
	}
    else 
    {
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
        if (self.myclient == nil)
        {
            self.myclient = [NSEntityDescription insertNewObjectForEntityForName:@"Clients" inManagedObjectContext:context];

            self.myclient.beginTime = nil;
            self.myclient.endTime = nil;
            
            self.myclient.sync_status = [NSNumber numberWithInteger:0];
            self.myclient.uuid = [appDelegate getUuid];
        }

        //最后保存的时间
        self.myclient.accessDate = [NSDate date];
        //name
        self.myclient.clientName = self.clientField.text;
        //是不是每一天都不一样
        if (self.isDaily == YES)
        {
            self.myclient.r_isDaily = [NSNumber numberWithInt:1];
        }
        else
        {
            self.myclient.r_isDaily = [NSNumber numberWithInt:0];
        }
        //平均每小时的报酬
        self.myclient.ratePerHour = self.regularStr;
        //每星期几每小时的报酬
        self.myclient.r_monRate = self.monStr;
        self.myclient.r_tueRate = self.tueStr;
        self.myclient.r_wedRate = self.wedStr;
        self.myclient.r_thuRate = self.thuStr;
        self.myclient.r_friRate = self.friStr;
        self.myclient.r_satRate = self.satStr;
        self.myclient.r_sunRate = self.sunStr;
        self.myclient.r_weekRate = self.weekStr;
        
        //每个小时分成多少等份，以及零头时间怎么算
        self.myclient.timeRoundTo = [self.timeRoundToLbel.text lowercaseString];
        //天超出的时间，报酬率 1，2
        self.myclient.dailyOverFirstTax = self.dayOverFirstTax;
        self.myclient.dailyOverFirstHour = self.dayOverFirstHour;
        self.myclient.dailyOverSecondTax = self.dayOverSecondTax;
        self.myclient.dailyOverSecondHour = self.dayOverSecondHour;
        //周超出的时间，报酬率 1，2
        self.myclient.weeklyOverFirstTax = self.weekOverFirstTax;
        self.myclient.weeklyOverFirstHour = self.weekOverFirstHour;
        self.myclient.weeklyOverSecondTax = self.weekOverSecondTax;
        self.myclient.weeklyOverSecondHour = self.weekOverSecondHour;
        
        self.myclient.email = self.emailField.text;
        self.myclient.phone = self.phoneField.text;
        self.myclient.fax = self.faxField.text;
        self.myclient.website = self.websiteField.text;
        self.myclient.address = self.addressField.text;
        
        //支付间隔的形式
        self.myclient.payPeriodStly = [NSNumber numberWithInt:self.payPeriodStly];
        self.myclient.payPeriodNum1 = [NSNumber numberWithInt:self.payPeriodNum1];
        self.myclient.payPeriodNum2 = [NSNumber numberWithInt:self.payPeriodNum2];
        self.myclient.payPeriodDate = self.payPeriodDate;
        
        [context save:nil];
        
        
//        if (self.delegate != nil)
//        {
//            [self.delegate saveNewClient:self.myclient];
//        }

        AppDelegate_Shared *appDelegate_iPhone = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
        [appDelegate_iPhone.parseSync updateClientFromLocal:_myclient];
        
        if(![self.navi_tittle isEqualToString:@"New Client"])
        {
//            [self.navigationController popViewControllerAnimated:YES];
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
	}
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UIEdgeInsets size = {0,0,keyHigh,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    NSIndexPath *sel_indexPath;
    if (textField == self.clientField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if (textField == self.phoneField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else if (textField == self.addressField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    }
    else if (textField == self.emailField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    }
    else if (textField == self.faxField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    }
    else if (textField == self.websiteField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:4 inSection:2];
    }
    
    [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
    
    currentField = textField;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
	return NO;
}

//+按钮事件
-(IBAction)AddressBtn
{
    [Flurry logEvent:@"1_CLI_NEWCONT"];
    
    if (currentField != nil && [currentField isFirstResponder])
    {
        [currentField resignFirstResponder];
    }
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
    //获取联系人
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self presentViewController:picker animated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }];
    appDelegate.m_widgetController = self;
    
    
    
}

-(void)setSubViewFrame
{
    if (IS_IPHONE_6PLUS)
    {
        float left = 20;
        _clientField.left = left;
        _rateL_Lbel.left = left;
        _timeRoundLabel1.left = left;
        _dailyoverLabel1.left = left;
        _weeklyovertimeLabel1.left = left;
        _payperiodLabel1.left = left;
        _phoneLabel1.left = left;
        _addressLabel1.left = left;
        _emailLabel1.left = left;
        _faxLabel1.left = left;
        _websiteLabel1.left = left;
        
        _addBtn.left = _addBtn.left - 5;
        _regularRateArrowImageView1.left = _regularRateArrowImageView1.left - 5;
        _rateR_Lbel.left = _rateR_Lbel.left - 5;
        _timeRoundArrowImageView1.left = _timeRoundArrowImageView1.left - 5;
        _timeRoundToLbel.left = _timeRoundToLbel.left - 5;
        _dailyOvertimeLbel.left = _dailyOvertimeLbel.left - 5;
        _dailyOvertimeLbel1.left = _dailyOvertimeLbel1.left - 5;
        _dailyOvertimeLbel2.left = _dailyOvertimeLbel2.left - 5;
        _dailyoverArrowImageView1.left = _dailyoverArrowImageView1.left - 5;
        _weeklyOvertimeLbel.left = _weeklyOvertimeLbel.left - 5;
        _weeklyOvertimeLbel1.left = _weeklyOvertimeLbel1.left - 5;
        _weeklyOvertimeLbel2.left = _weeklyOvertimeLbel2.left - 5;
        _weeklyouverArrowImageView1.left = _weeklyouverArrowImageView1.left - 5;
        _payperiodArrowImageView1.left = _payperiodArrowImageView1.left - 5;
        _payPeriodStlyLbel.left = _payPeriodStlyLbel.left - 5;
        _payPeriodEndLbel.left = _payPeriodEndLbel.left - 5;
        _phoneField.left = _phoneField.left - 5;
        _addressField.left = _addressField.left - 5;
        _emailField.left = _emailField.left - 5;
        _faxField.left = _faxField.left - 5;
        _websiteField.left = _websiteField.left - 5;
        
        
    }
}

#pragma mark    ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)peoplePickerController: (ABPeoplePickerNavigationController *)peoplePicker Person:(ABRecordRef)person
{
    //获取联系人姓名
    NSString *sel_name = @"";
    sel_name = (NSString*)CFBridgingRelease(ABRecordCopyCompositeName(person));
    
    
    //获取联系人电话   及  Fax;
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    NSMutableArray *faxs = [[NSMutableArray alloc] init];
    NSString *sel_phone = @"";
    NSString *sel_fax = @"";
    int i;
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        NSString *aPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        NSString *aLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneMulti, i)));
        
        if([aLabel isEqualToString:@"home fax"] || [aLabel isEqualToString:@"work fax"] || [aLabel isEqualToString:@"other fax"])
        {
            [faxs addObject:aPhone];
        }
        else
        {
            [phones addObject:aPhone];
        }
    }
    if([phones count]>0)
    {
        sel_phone = [phones objectAtIndex:0];
    }
    if([faxs count]>0)
    {
        sel_fax = [faxs objectAtIndex:0];
    }
    
    
    //获取联系人地址
    ABMutableMultiValueRef addressMulti = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSMutableArray *address = [[NSMutableArray alloc] init];
    NSString *sel_addressStr = @"";
    for (i = 0; i < ABMultiValueGetCount(addressMulti); i++)
    {
        NSString *addressStr = [[NSString alloc] init];
        NSDictionary* personaddress =(NSDictionary*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(addressMulti, i));
        
        
        NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
        if(country != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@"%@",country];
        }
        NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
        if(city != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@",%@",city];
        }
        NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
        if(state != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@",%@",state];
        }
        NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
        if(street != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@",%@",street];
        }
        NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
        if(zip != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@",%@",zip];
        }
        NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        if(coutntrycode != nil)
        {
            addressStr = [addressStr stringByAppendingFormat:@",%@",coutntrycode];
        }
        
        
        [address addObject:addressStr];
    }
    if([address count]>0)
    {
        sel_addressStr = [address objectAtIndex:0];
    }
    
    
    //获取联系人邮箱
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    NSString *sel_email = @"";
    for (i = 0;i < ABMultiValueGetCount(emailMulti); i++)
    {
        NSString *emailAdress = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailMulti, i));
        [emails addObject:emailAdress];
    }
    if([emails count]>0)
    {
        sel_email=[emails objectAtIndex:0];
    }
    
    
    
    //获取URL多值
    ABMutableMultiValueRef websiteMuti = ABRecordCopyValue(person, kABPersonURLProperty);
    NSMutableArray *websites = [[NSMutableArray alloc] init];
    NSString *sel_website = @"";
    for (int m = 0; m < ABMultiValueGetCount(websiteMuti); m++)
    {
        NSString * urlContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(websiteMuti,m));
        [websites addObject:urlContent];
    }
    if ([websites count]>0)
    {
        sel_website =[websites objectAtIndex:0];
    }
    
    
    self.clientField.text = sel_name;
    self.phoneField.text = sel_phone;
    self.addressField.text = sel_addressStr;
    self.emailField.text = sel_email;
    self.faxField.text = sel_fax;
    self.websiteField.text = sel_website;
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self peoplePickerController:peoplePicker Person:person];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self peoplePickerController:peoplePicker Person:person];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
    






-(IBAction)isShowMoreOrLess
{
    if (currentField != nil && [currentField isFirstResponder])
    {
        [currentField resignFirstResponder];
    }
    
    if (self.isMore)
    {
		self.isMore = NO;	
		[_showMoreOrLessBtn setTitle:@"Show Fewer" forState:UIControlStateNormal];
		
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
		[self.myTableView beginUpdates];
		[self.myTableView insertSections:sections withRowAnimation:UITableViewRowAnimationBottom];
		[self.myTableView endUpdates];
        
        UIEdgeInsets size = {0,0,0,0};
        [self.myTableView setContentInset:size];
	}
    else
	{
		self.isMore = YES;
		[_showMoreOrLessBtn setTitle:@"Show More" forState:UIControlStateNormal];
        
		NSIndexSet *sections1 = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
		[self.myTableView beginUpdates];
		[self.myTableView deleteSections:sections1 withRowAnimation:UITableViewRowAnimationTop];
		[self.myTableView endUpdates];
	}
}







#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isMore)
    {
		return 1;
	}
    else
	{
		return 3;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 4;
    }
    else 
    {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.clientCell setBackgroundView:bv];
            
            return self.clientCell;
        }
        else 
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.rateCell setBackgroundView:bv];
            
            return self.rateCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.timeRoundCell setBackgroundView:bv];
            
            return self.timeRoundCell;
        }   
        else if(indexPath.row == 1)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.dailyOverCell setBackgroundView:bv];
            
            return self.dailyOverCell;
        }
        else if(indexPath.row == 2)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.weeklyOverCell setBackgroundView:bv];
            
            return self.weeklyOverCell;
        }
        else
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.payPeriodCell setBackgroundView:bv];
            
            return self.payPeriodCell;
        }
    }
    else 
    {
        if(indexPath.row == 0)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.phoneCell setBackgroundView:bv];
            
            return self.phoneCell;
        }   
        else if(indexPath.row == 1)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.addressCell setBackgroundView:bv];
            
            return self.addressCell;
        }
        else if(indexPath.row == 2)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.emailCell setBackgroundView:bv];
            
            return self.emailCell;
        }
        else if(indexPath.row == 3)
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.faxCell setBackgroundView:bv];
            
            return self.faxCell;
        }
        else
        {
//            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
//            [self.websiteCell setBackgroundView:bv];
            
            return self.websiteCell;
        }
    }
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.clientField becomeFirstResponder];
        }
        else
        {
            ClientRateController *clientRateView = [[ClientRateController alloc] initWithNibName:@"ClientRateController" bundle:nil];
            clientRateView.delegate = self;
            clientRateView.regularStr = self.regularStr;
            clientRateView.isDaily = self.isDaily;
            clientRateView.monStr = self.monStr;
            clientRateView.tueStr = self.tueStr;
            clientRateView.wedStr = self.wedStr;
            clientRateView.thuStr = self.thuStr;
            clientRateView.friStr = self.friStr;
            clientRateView.satStr = self.satStr;
            clientRateView.sunStr = self.sunStr;
            clientRateView.weekStr = self.weekStr;
            
            [self.navigationController pushViewController:clientRateView animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (currentField != nil && [currentField isFirstResponder])
        {
            [currentField resignFirstResponder];
        }
        
        if (indexPath.row == 0)
        {
            [Flurry logEvent:@"1_CLI_NEWROUND"];
            
            TimeViewController_iPhone *timeRoundView = [[TimeViewController_iPhone alloc] initWithNibName:@"TimeViewController_iPhone" bundle:nil];
            timeRoundView.delegate = self;
            timeRoundView.selectRowName = [_timeRoundToLbel.text lowercaseString];
            
            [self.navigationController pushViewController:timeRoundView animated:YES];
        }
        else if (indexPath.row == 1)
        {
            DailyOverTime_iPhone *dailyTimeView = [[DailyOverTime_iPhone alloc] initWithNibName:@"DailyOverTime_iPhone" bundle:nil];
            dailyTimeView.clientController = self;
            dailyTimeView.isDaily = YES;
            
            [self.navigationController  pushViewController:dailyTimeView animated:YES];
        }
        else if (indexPath.row == 2)
        {
            DailyOverTime_iPhone *dailyTimeView = [[DailyOverTime_iPhone alloc] initWithNibName:@"DailyOverTime_iPhone" bundle:nil];
            dailyTimeView.clientController = self;
            dailyTimeView.isDaily = NO;
            
            [self.navigationController  pushViewController:dailyTimeView animated:YES];
        }
        else
        {
            [Flurry logEvent:@"1_CLI_NEWPAYPER"];
            
            PayEndStlyViewController *payEndStlyView2 = [[PayEndStlyViewController alloc] initWithNibName:@"PayEndStlyViewController" bundle:nil];
            
            payEndStlyView2.clientDelegate = self;
            payEndStlyView2.selectStly = self.payPeriodStly;
            
            [self.navigationController  pushViewController:payEndStlyView2 animated:YES];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            [self.phoneField becomeFirstResponder];
        }
        else if (indexPath.row == 1)
        {
            [self.addressField becomeFirstResponder];
        }
        else if (indexPath.row == 2)
        {
            [self.emailField becomeFirstResponder];
        }
        else if (indexPath.row == 3)
        {
            [self.faxField becomeFirstResponder];
        }
        else
        {
            [self.websiteField becomeFirstResponder];
        }
    }
}








#pragma mark getTimeRoundDelegate
-(void)saveTimeRound:(NSString *)timeRoundStr
{
    if (timeRoundStr != nil)
    {
        self.timeRoundToLbel.text = [timeRoundStr capitalizedString];
    }
}

/**
    保存client的支付日期模式，以及支付的两个日期
 */
-(void)savePayStly:(int )stly EndFlag1:(int)flag1 endFlag2:(int)flag2 endDate:(NSDate *)payDate
{
    self.payPeriodStly = stly;
    self.payPeriodNum1 = flag1;
    self.payPeriodNum2 = flag2;
    self.payPeriodDate = payDate;
    
    if (stly == 1)
    {
        self.payPeriodStlyLbel.text = @"Weekly";
        NSString *weekdayStr;
        if (flag1 == 1)
        {
            weekdayStr = @"Sundays";
        }
        else if (flag1 == 2)
        {
            weekdayStr = @"Mondays";
        }
        else if (flag1 == 3)
        {
            weekdayStr = @"Tuesdays";
        }
        else if (flag1 == 4)
        {
            weekdayStr = @"Wednesdays";
        }
        else if (flag1 == 5)
        {
            weekdayStr = @"Thursdays";
        }
        else if (flag1 == 6)
        {
            weekdayStr = @"Fridays";
        }
        else
        {
            weekdayStr = @"Saturdays";
        }
        self.payPeriodEndLbel.text = [NSString stringWithFormat:@"Period ends: %@",weekdayStr];
    }
    else if (stly == 2 || stly == 5)
    {
        if (stly == 2)
        {
            self.payPeriodStlyLbel.text = @"Bi-weekly";
        }
        else
        {
            self.payPeriodStlyLbel.text = @"4 weeks";
            
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]]];
        self.payPeriodEndLbel.text = [NSString stringWithFormat:@"Period ends: %@s",[dateFormatter stringFromDate:payDate]];
    }
    else if (stly == 6)
    {
        self.payPeriodStlyLbel.text = @"Quarterly";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
        self.payPeriodEndLbel.text = [NSString stringWithFormat:@"Period ends: %@",[dateFormatter stringFromDate:payDate]];
    }
    else if (stly == 3)
    {
        self.payPeriodStlyLbel.text = @"Semi-monthly";
        self.payPeriodEndLbel.text = [NSString stringWithFormat:@"Period ends: %d and %d",flag1,flag2];
    }
    else if (stly == 4)
    {
        self.payPeriodStlyLbel.text = @"Monthly";
        self.payPeriodEndLbel.text = [NSString stringWithFormat:@"Period ends: %d",flag1];
    }
    
}


-(void)saveClientRate:(BOOL)isDaily regular:(NSString *)regularStr mon:(NSString *)monStr tue:(NSString *)tueStr wed:(NSString *)wedStr thu:(NSString *)thuStr fri:(NSString *)friStr sat:(NSString *)satStr sun:(NSString *)sunStr week:(NSString *)weekStr
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.isDaily = isDaily;
    self.regularStr = regularStr;
    self.monStr = monStr;
    self.tueStr = tueStr;
    self.wedStr = wedStr;
    self.thuStr = thuStr;
    self.friStr = friStr;
    self.satStr = satStr;
    self.sunStr = sunStr;
    self.weekStr = weekStr;
    
    if (self.isDaily == NO)
    {
        self.rateL_Lbel.text = @"Regular Rate/h";
        [self.rateR_Lbel setHidden:NO];
        self.rateR_Lbel.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.regularStr];
    }
    else
    {
        self.rateL_Lbel.text = @"Daily Rate/h";
        [self.rateR_Lbel setHidden:YES];
    }
}





@end
