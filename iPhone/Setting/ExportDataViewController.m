//
//  ExportDataViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 5/14/13.
//
//

#import "ExportDataViewController.h"

#import "AppDelegate_iPhone.h"
#import "Clients.h"
#import "Logs.h"




@implementation ExportDataViewController



@synthesize myTableView;

@synthesize fromDateCell;
@synthesize fromDateLbel;
@synthesize toDateCell;
@synthesize toDateLbel;
@synthesize clientCell;
@synthesize clientLbel;
@synthesize datePicker;

@synthesize dateStly;
@synthesize fromDate;
@synthesize toDate;
@synthesize clientArray;
@synthesize isAllClient;

@synthesize logsArray;

@synthesize isSetting;
@synthesize sel_client;



//-(void)dealloc
//{
//    self.myTableView;
//    
//    self.fromDateCell;
//    self.fromDateLbel;
//    self.toDateCell;
//    self.toDateLbel;
//    self.clientCell;
//    self.clientLbel;
//    self.datePicker;
//    
//    self.clientArray;
//    self.logsArray;
//    
//}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        clientArray = [[NSMutableArray alloc] init];
        logsArray = [[NSMutableArray alloc] init];
        self.sel_client = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Export CSV"];
    
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

        [appDelegate customFingerMove:self canMove:NO isBottom:YES];
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
    
    
    if(IS_IPHONE_6PLUS)
    {
        self.fromlabel1.left = 20;
        self.tolabel1.left = 20;
        self.clientlable1.left = 20;
        self.fromDateLbel.left = self.fromDateLbel.left - 5;
        self.toDateLbel.left = self.toDateLbel.left - 5;
        self.clientLbel.left = self.clientLbel.left - 5;
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
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (self.isSetting != 1)
    {
        [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    }
    else
    {
        [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    }
    
    [self.myTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
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
            
            
            appDelegate.appMailController = mailController;
            
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
        return self.fromDateCell;
    }
    else if (indexPath.row == 1)
    {
        return self.toDateCell;
    }
    else
    {
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
        ExportSelectClient *exportClientController = [[ExportSelectClient alloc] initWithNibName:@"ExportSelectClient" bundle:nil];
        
        
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
