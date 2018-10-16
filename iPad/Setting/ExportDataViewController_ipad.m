//
//  ExportDataViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 5/16/13.
//
//

#import "ExportDataViewController_ipad.h"

#import "AppDelegate_iPad.h"
#import "Clients.h"
#import "Logs.h"




@implementation ExportDataViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _clientArray = [[NSMutableArray alloc] init];
        _logsArray = [[NSMutableArray alloc] init];
        self.sel_client = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Export CSV"];
    
    exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exportButton.titleLabel.font = appDelegate.naviFont;
    exportButton.frame = CGRectMake(0, 0, 61, 30);
    [exportButton setTitle:@"Export" forState:UIControlStateNormal];
    [exportButton addTarget:self action:@selector(exportData) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:exportButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isSetting == 1)
    {
        backButton.titleLabel.font = appDelegate.naviFont;
        backButton.frame = CGRectMake(0, 0, 60, 30);
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        backButton.frame = CGRectMake(0, 0, 80, 30);
        [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//        backButton.titleLabel.font = appDelegate.naviFont;
//        [backButton setTitle:@"Settings" forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    
    
    self.dateStly = 0;
    NSDate *firstDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&firstDate interval:NULL forDate:[NSDate date]];
    self.fromDate = firstDate;
    NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
    [componentsToSub setMonth:1];
    self.toDate = [calendar dateByAddingComponents:componentsToSub toDate:self.fromDate options:0];
    self.datePicker.date = self.fromDate;
    self.datePicker.maximumDate = self.toDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    self.fromDateLbel.text = [dateFormatter stringFromDate:self.fromDate];
    self.toDateLbel.text = [dateFormatter stringFromDate:self.toDate];

    
    if (self.sel_client == nil)
    {
        self.isAllClient = YES;
        [self.clientArray addObjectsFromArray:[appDelegate getAllClient]];
        
        if ([self.clientArray count] == 0)
        {
            self.clientLbel.text = @"0";
            
            [exportButton setTitleColor:[UIColor colorWithRed:121.0/255 green:178.0/255 blue:230.0/255 alpha:1] forState:UIControlStateNormal];
            [exportButton setUserInteractionEnabled:NO];
        }
        else
        {
            [exportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exportButton setUserInteractionEnabled:YES];
        }
    }
    else
    {
        self.isAllClient = NO;
        [self.clientArray addObject:self.sel_client];
        
        self.clientLbel.text = @"1";
        [exportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exportButton setUserInteractionEnabled:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}


                                                                                                                            





-(void)exportData
{
    for (int i=(int)([self.clientArray count]-1); i>=0; i--)
    {
        Clients *selclient = [self.clientArray objectAtIndex:i];
        if (selclient == nil || selclient.clientName == nil)
        {
            [self.clientArray removeObject:selclient];
        }
        
        if ([self.clientArray count] == 0)
        {
            self.clientLbel.text = @"0";
            [exportButton setTitleColor:[UIColor colorWithRed:121.0/255 green:178.0/255 blue:230.0/255 alpha:1] forState:UIControlStateNormal];
            [exportButton setUserInteractionEnabled:NO];
            
            return;
        }
    }
    
    
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            
            NSDate *date1 = self.fromDate;
            NSDate *date2 = [self.toDate dateByAddingTimeInterval:(NSTimeInterval)24*3600];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            [self.logsArray removeAllObjects];
            [self.logsArray addObjectsFromArray:[appDelegate getOverTime_Log:nil startTime:date1 endTime:date2 isAscendingOrder:NO]];
            
            if (self.isAllClient == NO)
            {
                for (int i=0; i<[self.logsArray count]; i++)
                {
                    Logs *_log = [self.logsArray objectAtIndex:i];
                    if ([self.clientArray indexOfObject:_log.client] == NSNotFound)
                    {
                        [self.logsArray removeObject:_log];
                        i--;
                    }
                }
            }
            
            
            
            NSMutableArray *mailSendArray = [[NSMutableArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
            NSString *key1 = [dateFormatter stringFromDate:self.fromDate];
            NSString *key2 = [dateFormatter stringFromDate:self.toDate];
            NSString *key = [NSString stringWithFormat:@"\"%@ - %@\"",key1,key2];
            
            [mailSendArray addObject:key];
            [mailSendArray addObject:@"\"Client Name\",\"Start Time\",\"End Time\",\"Break Time\",\"Worked Hours\",\"Rate/h\",\"Amount\",\"Note\""];
            
            
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateStyle:kCFDateFormatterLongStyle];
            [dateFormatter2 setTimeStyle:NSDateFormatterMediumStyle];
            for (Logs *_log in self.logsArray)
            {
                NSString *clientName = _log.client.clientName;
                NSString *startTime = [dateFormatter2 stringFromDate:_log.starttime];
                NSString *endTime = [dateFormatter2 stringFromDate:_log.endtime];
                
                
                
                NSString *breakTime;
                if (_log.finalmoney == nil)
                {
                    breakTime = [appDelegate conevrtTime2:0];
                }
                else
                {
                     breakTime  = [appDelegate conevrtTime:_log.finalmoney];
                }
                
                
                NSString *workedHours = [appDelegate conevrtTime:_log.worked];
                NSString *rateStr = [appDelegate appMoneyShowStly:_log.ratePerHour];
                NSString *amount = [appDelegate appMoneyShowStly:_log.totalmoney];

                NSString *note = _log.notes;
                
                [mailSendArray addObject:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"",clientName,startTime,endTime,breakTime,workedHours,rateStr,amount,note]];
            }
            
            
            
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setSubject:@"Hours Keeper CSV Export"];
            
            
            NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;
            NSDate * dateNow = [NSDate date];
            NSDateFormatter *formatDateNow = [[NSDateFormatter alloc] init];
            [formatDateNow setDateFormat:@"yyyy.M.d"];
            NSString *dateStrNow = [formatDateNow stringFromDate:dateNow];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeperData.csv"];
            NSString *dtabContents = [mailSendArray componentsJoinedByString:@"\n"];
            [dtabContents writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            [mailController addAttachmentData:[NSData dataWithContentsOfFile:appFile]
                                     mimeType:@"text/csv"
                                     fileName:[NSString stringWithFormat:@"HoursKeeper.data.%@.csv",dateStrNow]];
            [self presentViewController:mailController animated:YES completion:nil];
            appDelegate.m_widgetController = self;

            
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


-(void)back
{
    if (self.isSetting == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(IBAction)dateChange
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    
    if (self.dateStly == 0)
    {
        self.fromDateLbel.text = [dateFormatter stringFromDate:self.datePicker.date];
        self.fromDate = self.datePicker.date;
    }
    else
    {
        self.toDateLbel.text = [dateFormatter stringFromDate:self.datePicker.date];
        self.toDate = self.datePicker.date;
    }
}










#pragma mark - Table view data source


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
        [self.fromDateCell setBackgroundView:bv];
        
        return self.fromDateCell;
    }
    else if (indexPath.row == 1)
    {
        UIImage *image = [[UIImage imageNamed:@"cell1_middle_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
        [self.toDateCell setBackgroundView:bv];
        
        return self.toDateCell;
    }
    else
    {
        UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *bv = [[UIImageView alloc] initWithImage:image];
        [self.clientCell setBackgroundView:bv];
        
        return self.clientCell;
    }
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        self.dateStly = 0;
        self.datePicker.date = self.fromDate;
        self.datePicker.minimumDate = nil;
        self.datePicker.maximumDate = self.toDate;
    }
    else if (indexPath.row == 1)
    {
        self.dateStly = 1;
        self.datePicker.date = self.toDate;
        self.datePicker.minimumDate = self.fromDate;
        self.datePicker.maximumDate = nil;
    }
    else
    {
        ExportSelectClient_ipad *exportClientController = [[ExportSelectClient_ipad alloc] initWithNibName:@"ExportSelectClient_ipad" bundle:nil];
        
        exportClientController.delegate = self;
        if (self.isAllClient == YES)
        {
            [exportClientController initClientData:nil SelectStly:YES];
        }
        else
        {
            [exportClientController initClientData:self.clientArray SelectStly:NO];
        }

        [self.navigationController pushViewController:exportClientController animated:YES];

    }
}





-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



-(void)saveExportClient:(NSMutableArray *)_allClients SelectStly:(BOOL)_isAll;
{
    
    for (int i=(int)([_allClients count]-1); i>=0; i--)
    {
        Clients *selclient = [_allClients objectAtIndex:i];
        if (selclient == nil || selclient.clientName == nil)
        {
            [_allClients removeObject:selclient];
        }
    }
    
    self.isAllClient = _isAll;
    if (_isAll == NO)
    {
        [self.clientArray removeAllObjects];
        [self.clientArray addObjectsFromArray:_allClients];
        
        self.clientLbel.text = [NSString stringWithFormat:@"%d",(int)[_allClients count]];
    }
    else
    {
        self.clientLbel.text = @"All";
    }
    
    
    
    [self.clientArray removeAllObjects];
    [self.clientArray addObjectsFromArray:_allClients];
    self.isAllClient = _isAll;
    if (_isAll == NO)
    {
        self.clientLbel.text = [NSString stringWithFormat:@"%d",(int)[_allClients count]];
    }
    else
    {
        self.clientLbel.text = @"All";
    }
    
    
    if ([self.clientArray count] == 0)
    {
        self.clientLbel.text = @"0";
        [exportButton setTitleColor:[UIColor colorWithRed:121.0/255 green:178.0/255 blue:230.0/255 alpha:1] forState:UIControlStateNormal];
        [exportButton setUserInteractionEnabled:NO];
    }
    else
    {
        [exportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exportButton setUserInteractionEnabled:YES];
    }
}



@end

