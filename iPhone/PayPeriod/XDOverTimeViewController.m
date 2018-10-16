//
//  XDOverTimeViewController.m
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/8.
//

#import "XDOverTimeViewController.h"

#import "OverClientViewController.h"
#import "OverDateViewController.h"
#import "AppDelegate_Shared.h"
#import "Clients.h"


@interface XDOverTimeViewController ()<getOverClientDelegate,getOverDateDelegate>
{
    Clients* _selectedClient;
}
@property(nonatomic, strong)NSDate * startDate;
@property(nonatomic, strong)NSDate * endDate;
@property(nonatomic, assign)NSInteger dateStly;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *selectClientCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *selectDateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *DailyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *weeklyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *totalCell;

@property (weak, nonatomic) IBOutlet UILabel *dailyOverTimeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *dailyOverTimeLbl2;
@property (weak, nonatomic) IBOutlet UILabel *dailyTimeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *dailyTimeLbl2;
@property (weak, nonatomic) IBOutlet UILabel *dailyAmountLbl1;
@property (weak, nonatomic) IBOutlet UILabel *dailyAmountLbl2;

@property (weak, nonatomic) IBOutlet UILabel *weeklyOverTimeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *weeklyOverTimeLbl2;
@property (weak, nonatomic) IBOutlet UILabel *weeklyAmountLbl1;
@property (weak, nonatomic) IBOutlet UILabel *weeklyAmountLbl2;
@property (weak, nonatomic) IBOutlet UILabel *weeklyTimeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *weeklyTimeLbl2;
@property (weak, nonatomic) IBOutlet UILabel *selectClientDetailLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectDateDetailLbl;

@end

@implementation XDOverTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Overtime Pay";
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - other

-(void)initData
{
    if (_selectedClient != nil && _selectedClient.clientName != nil)
    {
//        [self saveSelectDate:self.startDate second:self.endDate dateStly:self.dateStly];

        NSMutableString *firstText = [NSMutableString stringWithString:_selectedClient.dailyOverFirstTax];
        [firstText appendString:@" after "];
        [firstText appendString:_selectedClient.dailyOverFirstHour];
        [firstText appendString:@"h"];
        firstText = (NSMutableString *)[firstText lowercaseString];
        self.dailyOverTimeLbl1.text = firstText;
        
        NSMutableString *secondText = [NSMutableString stringWithString:_selectedClient.dailyOverSecondTax];
        [secondText appendString:@" after "];
        [secondText appendString:_selectedClient.dailyOverSecondHour];
        [secondText appendString:@"h"];
        secondText = (NSMutableString *)[secondText lowercaseString];
        self.dailyOverTimeLbl2.text = secondText;
        
        NSMutableString *firstText2 = [NSMutableString stringWithString:_selectedClient.weeklyOverFirstTax];
        [firstText2 appendString:@" after "];
        [firstText2 appendString:_selectedClient.weeklyOverFirstHour];
        [firstText2 appendString:@"h"];
        firstText2 = (NSMutableString *)[firstText2 lowercaseString];
        self.weeklyOverTimeLbl1.text = firstText2;
        
        NSMutableString *secondText2 = [NSMutableString stringWithString:_selectedClient.weeklyOverSecondTax];
        [secondText2 appendString:@" after "];
        [secondText2 appendString:_selectedClient.weeklyOverSecondHour];
        [secondText2 appendString:@"h"];
        secondText2 = (NSMutableString *)[secondText2 lowercaseString];
        self.weeklyOverTimeLbl2.text = secondText2;

    }else{
        self.selectClientDetailLbl.text = @"";
        self.selectDateDetailLbl.text = @"";
        self.dailyOverTimeLbl1.text = @"";
        self.dailyOverTimeLbl2.text = @"";
        self.weeklyOverTimeLbl1.text = @"";
        self.weeklyOverTimeLbl2.text = @"";
    }
}

#pragma mark -
#pragma mark  TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 104;
    }else
        return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.selectClientCell;
    }else if(indexPath.section == 1){
        return self.selectDateCell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return self.DailyCell;
        }else{
            return self.weeklyCell;
        }
    }
    return self.totalCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
       OverClientViewController* overClientView = [[OverClientViewController alloc] initWithNibName:@"OverClientViewController" bundle:nil];
        overClientView.delegate = self;
       [self.navigationController pushViewController:overClientView animated:YES];
    }else if (indexPath.section == 1){
        if (_selectedClient == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select Client First!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = alertView;
        }else{
            OverDateViewController *overDateView= [[OverDateViewController alloc] initWithNibName:@"OverDateViewController" bundle:nil];
            overDateView.delegate = self;
            overDateView.sel_client = _selectedClient;
            [self.navigationController  pushViewController:overDateView animated:YES];

        }
        
    }
   
}
#pragma mark - getOverDateDelegate
-(void)saveSelectDate:(NSDate *)_startDate second:(NSDate *)_endDate dateStly:(NSInteger)_dateStly{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *key;
    
    self.dateStly = _dateStly;
    self.startDate = _startDate;
    if (self.dateStly == 0)
    {
        self.endDate = nil;
        key = [dateFormatter stringFromDate:self.startDate];
    }
    else
    {
        self.endDate = _endDate;
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
        NSString *key1 = [dateFormatter2 stringFromDate:self.startDate];
        NSString *key2 = [dateFormatter stringFromDate:self.endDate];
        key = [NSString stringWithFormat:@"From %@ to %@",key1,key2];
    }
    self.selectDateDetailLbl.text = key;
    
    [self initData];
}

#pragma mark - getOverClientDelegate
-(void)saveSelectClient:(Clients *)_selectClient{
    _selectedClient = _selectClient;
    self.selectClientDetailLbl.text = _selectClient.clientName;
    [self initData];
}

@end
