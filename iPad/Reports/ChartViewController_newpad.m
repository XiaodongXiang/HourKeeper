//
//  ChartViewController_newpad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartViewController_newpad.h"

#import "AppDelegate_iPad.h"
#import "Logs.h"
#import "Clients.h"

#import "ChartCell_ipad.h"
#import "projectToTaskViewController_ipad.h"




@interface dataTotalUnit_ipad : NSObject
{
    double moneyOrder;
    int timeOrder;
    NSMutableArray *all;
}
@property (nonatomic,assign) double moneyOrder;
@property (nonatomic,assign) int timeOrder;
@property (nonatomic,strong) NSMutableArray *all;

@end


@implementation dataTotalUnit_ipad

@synthesize moneyOrder;
@synthesize timeOrder;
@synthesize all;

-(id)init
{
    if (!(self = [super init])) return nil;
    
    all = [[NSMutableArray alloc] init];
    
    return self;
}





@end




@implementation ChartViewController_newpad
@synthesize popoverController;



int redList1_ipad[11] =   {14,2,0,19,83,118,148,202,175,202,253};
int greenList1_ipad[11] = {142,158,183,196,198,208,215,234,205,213,232};
int blueList1_ipad[11] = {192,223,241,234,222,225,227,231,216,217,220};

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _clientTotalList = [[NSMutableArray alloc] init];
        _clientTPercentageList = [[NSMutableArray alloc] init];
        _clientMPercentageList = [[NSMutableArray alloc] init];
        _allLogsList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIEdgeInsets separator = {0,0,0,0};
    [self.tableView setSeparatorInset:separator];
    
    self.tableShowStly = 1;
    self.dateStly = 0;
    self.sel_weekDay = [NSDate date];
    self.dateShowLbel.text = [[self getNowWeek]uppercaseString];
    [self.dateStyBtn setTitle:@"Week" forState:UIControlStateNormal];
    self.dateView.layer.borderWidth = 1;
    UIColor *tmpBlueColor = [UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:227.0/255.0 alpha:1];
    self.dateView.layer.borderColor = tmpBlueColor.CGColor;
    self.dateView.layer.cornerRadius = 4;
    self.dateView.layer.masksToBounds = YES;
    [self hideDateViewAnimation:NO];

    
    [self.pieView init_ipad];
    [self.tableView setExclusiveTouch:YES];
    
     [self.totalAmountView creatSubViewsisLeftAlignment:NO];
    
    
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    [self showSegmentImage];
    self.tableViewTopLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    self.tableViewTopLine.height = SCREEN_SCALE;
    
    
    self.bgView.width = self.view.width - SCREEN_SCALE;
    self.headLine.top = 66 - SCREEN_SCALE;
    self.headLine.height = SCREEN_SCALE;
    
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
    
    [self initChartView];
}





-(void)initChartView
{
     AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    if (self.popoverController != nil && appDelegate.isDeleteFlashPop == NO)
    {
        if ([self.popoverController isPopoverVisible])
        {
            [self.popoverController dismissPopoverAnimated:YES];
        }
        self.popoverController = nil;
    }
    else
    {
        appDelegate.isDeleteFlashPop = NO;
    }
    
    
    if (self.dateStly == 0)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:[appDelegate getFirstDayForWeek]];
        NSDate *weekFirstDate = nil;
        [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self.sel_weekDay];
        
        self.firstDate = weekFirstDate;
        self.lastDate = [self getAfterMathDate:self.firstDate delayDays:6                                                                                                                                                                                            ];
        
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        
        NSString *key1 = [dateFormatter2 stringFromDate:self.firstDate];
        NSString *key2 = [dateFormatter stringFromDate:self.lastDate];
        NSString *key = [[NSString stringWithFormat:@"%@ - %@",key1,key2]uppercaseString];
        
        self.dateShowLbel.text = key;
        //设置左右按钮的位置
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
        CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
        //高清
        if (SCREEN_SCALE<1)
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
        }
        else
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
        }
    }
    
    
    
    [self getAllLogsList];
    [self getclientList];
    
    [self reflashTable];
    [self reflashPercentChart];
    [self showDateBtnImage:(int)self.dateStly];
}


-(void)reflashTable
{
    [self.tableView reloadData];
}


-(void)reflashPercentChart
{
    if (self.tableShowStly == 0)
    {
        [self.pieView drawMyView:self.clientTPercentageList];
    }
    else
    {
       [self.pieView drawMyView:self.clientMPercentageList];
    }
}






-(IBAction)selectDateStly
{
    if (self.dateView.height>self.dateStyBtn.height)
    {
        [self hideDateViewAnimation:YES];
    }
    else
    {
        [self showDateViewAnimation:YES];
    }
}

-(void)hideDateViewAnimation:(BOOL)isAnimation
{
    if (isAnimation)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.dateView.height = self.dateStyBtn.height;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12"];
        [UIView commitAnimations];
    }
    else
    {
        self.dateView.height = self.dateStyBtn.height;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12"];
    }
}

-(void)showDateViewAnimation:(BOOL)isAnimation
{
    if (isAnimation)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.dateView.height = self.dateStyBtn.height+self.weekBtn.height*4;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12_sel"];
        [UIView commitAnimations];
    }
    else
    {
        self.dateView.height = self.dateStyBtn.height+self.weekBtn.height*4;
        self.arrowImageView.image = [UIImage imageNamed:@"ipad_client2_19_12_sel"];
    }
}


-(IBAction)leftBtnDone
{
    [self getPreviousDate];
}


-(IBAction)rightBtnDone
{
    [self getNextDate];
}

-(IBAction)doShowStly:(UISegmentedControl *)sender
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    self.tableShowStly = sender.selectedSegmentIndex;
    [self showSegmentImage];
    
    [self.clientTPercentageList removeAllObjects];
    [self.clientMPercentageList removeAllObjects];
    if (self.tableShowStly == 0)
    {
        [Flurry logEvent:@"5_REPO_DUR"];
        
        self.totalLbel.hidden = NO;
        self.totalAmountView.hidden = YES;
        self.totalLbel.text = self.showTimeStr;
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"timeOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    else
    {
        [Flurry logEvent:@"5_REPO_AMO"];
        
        self.totalLbel.hidden = YES;
        self.totalAmountView.hidden = NO;
        [self.totalAmountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",self.money_sub] color:[HMJNomalClass creatAmountColor]];
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"moneyOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    for (dataTotalUnit_ipad *unit in self.clientTotalList)
    {
        [self.clientTPercentageList addObject:[unit.all objectAtIndex:3]];
        [self.clientMPercentageList addObject:[unit.all objectAtIndex:5]];
    }
    
    [self reflashTable];
    [self reflashPercentChart];
}

-(void)showSegmentImage
{
    NSString *imageStr = nil;
    if (self.tableShowStly == 0)
    {
        imageStr = @"btn_duration_190_29.png";
    }
    else
    {
        imageStr = @"btn_amount_190_29.png";
    }
    [self.segmentImagV setImage:[UIImage imageNamed:imageStr]];
}

-(void)showDateBtnImage:(int)Stly
{
    if (Stly == 0)
    {
        [self.weekBtn setSelected:YES];
        [self.monthBtn setSelected:NO];
        [self.queterBtn setSelected:NO];
        [self.yearBtn setSelected:NO];
    }
    else if (Stly == 1)
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:YES];
        [self.queterBtn setSelected:NO];
        [self.yearBtn setSelected:NO];
    }
    else if (Stly == 2)
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:NO];
        [self.queterBtn setSelected:YES];
        [self.yearBtn setSelected:NO];
    }
    else
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:NO];
        [self.queterBtn setSelected:NO];
        [self.yearBtn setSelected:YES];
    }
}


-(IBAction)nowWeekBtn
{
    if (self.dateStly != 0)
    {
        [Flurry logEvent:@"5_REPO_WEEK"];
        
        self.dateStly = 0;
        self.dateShowLbel.text = [[self getNowWeek]uppercaseString];
        //设置左右按钮的位置
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
        CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
        //高清
        if (SCREEN_SCALE<1)
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
        }
        else
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
        }
        [self.dateStyBtn setTitle:@"Week" forState:UIControlStateNormal];
        [self showDateBtnImage:(int)self.dateStly];
        
        [self getAllLogsList];
        [self getclientList];
        
        [self reflashTable];
        [self reflashPercentChart];
    }
    
    [self hideDateViewAnimation:YES];
}


-(IBAction)nowMonthBtn
{
    if (self.dateStly != 1)
    {
        [Flurry logEvent:@"5_REPO_MON"];
        
        self.dateStly = 1;
        self.dateShowLbel.text = [[self getNowMonth]uppercaseString];
        //设置左右按钮的位置
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
        CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
        //高清
        if (SCREEN_SCALE<1)
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
        }
        else
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
        }
        
        [self.dateStyBtn setTitle:@"Month" forState:UIControlStateNormal];
        [self showDateBtnImage:(int)self.dateStly];
        
        [self getAllLogsList];
        [self getclientList];
        
        [self reflashTable];
        [self reflashPercentChart];
    }
    
    [self hideDateViewAnimation:YES];
}


-(IBAction)nowQuarterBtn
{
    if (self.dateStly != 2)
    {
        [Flurry logEvent:@"5_REPO_QUA"];
        
        self.dateStly = 2;
        self.dateShowLbel.text = [[self getNowQuarter]uppercaseString];
        //设置左右按钮的位置
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
        CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
        //高清
        if (SCREEN_SCALE<1)
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
        }
        else
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
        }
        [self.dateStyBtn setTitle:@"Quarter" forState:UIControlStateNormal];
        [self showDateBtnImage:(int)self.dateStly];
        
        [self getAllLogsList];
        [self getclientList];
        
        [self reflashTable];
        [self reflashPercentChart];
    }
    
    [self hideDateViewAnimation:YES];
}


-(IBAction)nowYearBtn
{
    if (self.dateStly != 3)
    {
        [Flurry logEvent:@"5_REPO_YEAR"];
        
        self.dateStly = 3;
        self.dateShowLbel.text = [[self getNowYear]uppercaseString];
        //设置左右按钮的位置
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
        CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
        //高清
        if (SCREEN_SCALE<1)
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
        }
        else
        {
            self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
            self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
        }
        [self.dateStyBtn setTitle:@"Year" forState:UIControlStateNormal];
        [self showDateBtnImage:(int)self.dateStly];
        
        [self getAllLogsList];
        [self getclientList];
        
        [self reflashTable];
        [self reflashPercentChart];
    }
    
    [self hideDateViewAnimation:YES];

}







-(void)getAllLogsList
{
    NSDate *date1 = self.firstDate;
    NSDate *date2 = self.lastDate;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self.allLogsList removeAllObjects];
    [self.allLogsList addObjectsFromArray:[appDelegate getOverTime_Log:nil startTime:date1 endTime:date2 isAscendingOrder:NO]];
}

-(void)getclientList
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    long time_sub = 0;
    self.money_sub = 0.0;
    for (int k=0; k<[self.allLogsList count]; k++)
    {
        Logs *mylog = [self.allLogsList objectAtIndex:k];
        NSString *timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
        NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
        int hours = [[timeArray objectAtIndex:0] intValue];
        int minutes = [[timeArray objectAtIndex:1] intValue];
        time_sub = time_sub +hours*3600+minutes*60;
        self.money_sub = self.money_sub + [mylog.totalmoney doubleValue];
    }
    NSArray *backArray = [appDelegate overTimeMoney_logs:self.allLogsList];
    double weekAddMoney = [[backArray objectAtIndex:0]doubleValue];
    self.money_sub = self.money_sub + weekAddMoney;
    
    
    [self.clientTotalList removeAllObjects];
    
	NSMutableArray *results = [[NSMutableArray alloc] init];
    [results addObjectsFromArray:self.allLogsList];
    
	for (int i=0; i<[results count]; i++)
    {
        Log(@"i=%d",i);
        dataTotalUnit_ipad *totalClientcell = [[dataTotalUnit_ipad alloc] init];
        
		NSMutableArray *myArray = [[NSMutableArray alloc] init];
		Logs *log1 = [results objectAtIndex:i];
        Clients *client1 = log1.client;
        if (client1==nil) {
            continue;
        }
		[myArray addObject:log1];
        
		for (int j = i+1; j<[results count]; j++)
        {
			Logs *log2 = [results objectAtIndex:j];
            Clients *client2 = log2.client;
            
			if (client1 == client2)
            {
				[myArray addObject:log2];
				[results removeObject:log2];
				j--;
			}
		}
        
		long allseconds = 0;
        double allmoney = 0.0;
        NSMutableArray *recorde = myArray;
        
        for (int j=0; j<[recorde count]; j++)
        {
            Logs *mylog = [recorde objectAtIndex:j];
            NSString *timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
            NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
            int hours = [[timeArray objectAtIndex:0] intValue];
            int minutes = [[timeArray objectAtIndex:1] intValue];
            allseconds = allseconds +hours*3600+minutes*60;
            allmoney = allmoney + [mylog.totalmoney doubleValue];
        }
        NSArray *tmpbackArray = [appDelegate overTimeMoney_logs:recorde];
        double tmpAddMoney = [[tmpbackArray objectAtIndex:0]doubleValue];
        allmoney = allmoney + tmpAddMoney;
        
        
        NSString *totalTime = [appDelegate conevrtTime2:(int)allseconds];
        NSString *totalMoney = [appDelegate appMoneyShowStly4:allmoney];
        
        NSString *timePercent;
        if (time_sub == 0)
        {
            timePercent = ZERO_NUM;
        }
        else
        {
            timePercent = [appDelegate appMoneyShowStly4:allseconds/(double)time_sub*100];
        }
        
        NSString *moneyPercent;
        if (self.money_sub == 0)
        {
            moneyPercent = ZERO_NUM;
        }
        else
        {
            moneyPercent = [appDelegate appMoneyShowStly4:allmoney/self.money_sub*100];
        }
        
        [totalClientcell.all addObject:client1.clientName];
        [totalClientcell.all addObject:myArray];
        [totalClientcell.all addObject:totalTime];
        [totalClientcell.all addObject:timePercent];
        [totalClientcell.all addObject:totalMoney];
        [totalClientcell.all addObject:moneyPercent];
        [totalClientcell.all addObject:client1];
        
        totalClientcell.timeOrder = (int)allseconds;
        totalClientcell.moneyOrder = allmoney;
        
        [self.clientTotalList addObject:totalClientcell];
        
	}
    
    
    self.showTimeStr = [appDelegate conevrtTime2:(int)time_sub];
    self.showMoneyStr = [appDelegate appMoneyShowStly3:self.money_sub];
    
    [self.clientTPercentageList removeAllObjects];
    [self.clientMPercentageList removeAllObjects];
    if (self.tableShowStly == 0)
    {
        self.totalLbel.hidden = NO;
        self.totalAmountView.hidden = YES;
        self.totalLbel.text = self.showTimeStr;
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"timeOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    else
    {
        self.totalLbel.hidden = YES;
        self.totalAmountView.hidden = NO;
        [self.totalAmountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",self.money_sub] color:[HMJNomalClass creatAmountColor]];
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"moneyOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    for (dataTotalUnit_ipad *unit in self.clientTotalList)
    {
        [self.clientTPercentageList addObject:[unit.all objectAtIndex:3]];
        [self.clientMPercentageList addObject:[unit.all objectAtIndex:5]];
    }
    
//    if (self.clientTotalList.count == 0)
//    {
//        [self.segmentCtrol setHidden:YES];
//        [self.segmentImagV setHidden:YES];
//    }
//    else
//    {
//        [self.segmentCtrol setHidden:NO];
//        [self.segmentImagV setHidden:NO];
//    }
}
 







- (BOOL)isLeapYear:(NSInteger)year
{
	if (year%4 == 0)
    {
		if (year%100 == 0) 
        {
			if (year%400 == 0)
            {
				return YES;
			}
            else
            {
				return NO;
			}
		}
		else 
        {
			return YES;
		}
	}
    else 
    {
		return NO;
	}
    
}



- (NSString *)getNowWeek
{
    self.dateStly = 0;
    self.sel_weekDay = [NSDate date];
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:[appDelegate getFirstDayForWeek]];
    NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self.sel_weekDay];
    
    self.firstDate = weekFirstDate;
    self.lastDate = [self getAfterMathDate:self.firstDate delayDays:6                                                                                                                                                                                            ];
    
    
	NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    
    NSString *key1 = [dateFormatter2 stringFromDate:self.firstDate];
    NSString *key2 = [dateFormatter stringFromDate:self.lastDate];
	NSString *key = [NSString stringWithFormat:@"%@ - %@",key1,key2];
    
   
	return key;
}



- (NSString *)getNowMonth
{
    self.dateStly = 1;
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSDate *nowdate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
    
	NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:nowdate];
	NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
	beginComponents.year = nowComponents.year;
	beginComponents.month = nowComponents.month;
	beginComponents.day = 1;
	NSDate *beginDate = [calendar dateFromComponents:beginComponents];
	NSDateComponents *endComponents = [[NSDateComponents alloc] init];
	endComponents.year = nowComponents.year;
	endComponents.month = nowComponents.month;
	if (nowComponents.month == 1 || nowComponents.month == 3 || nowComponents.month == 5 || nowComponents.month == 7
        || nowComponents.month == 8 || nowComponents.month == 10  || nowComponents.month == 12) 
    {
		endComponents.day = 31;
	}
	if (nowComponents.month == 4 || nowComponents.month == 6 || nowComponents.month == 9
        || nowComponents.month == 11) 
    {
		endComponents.day = 30;
	}
	if (nowComponents.month == 2) 
    {
		if ([self isLeapYear:nowComponents.year]) 
        {
			endComponents.day = 29;
		}
        else 
        {
			endComponents.day = 28;
		}
	}
	NSDate *endDate = [calendar dateFromComponents:endComponents];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMyyyy" options:0 locale:[NSLocale currentLocale]]];
	NSString *key = [dateFormatter stringFromDate:beginDate];
	self.firstDate = beginDate;
	self.lastDate = endDate;
	return key;
}


-(NSString *)getNowQuarter
{
    self.dateStly = 2;
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSDate *nowdate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:nowdate];
    NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
	beginComponents.year = nowComponents.year;
	if (nowComponents.month>=1 && nowComponents.month<=3)
    {
		beginComponents.month = 1;
	}
	if (nowComponents.month>=4 && nowComponents.month<=6)
    {
		beginComponents.month = 4;
	}
	if (nowComponents.month>=7 && nowComponents.month<=9)
    {
		beginComponents.month = 7;
	}
	if (nowComponents.month>=10 && nowComponents.month<=12)
    {
		beginComponents.month = 10;
	}
	beginComponents.day = 1;
	NSDate *beginDate = [calendar dateFromComponents:beginComponents];
	NSDateComponents *endComponents = [[NSDateComponents alloc] init];
	endComponents.year = nowComponents.year;
	if (nowComponents.month>=1 && nowComponents.month<=3) 
    {
		endComponents.month = 3;
		endComponents.day = 31;
	}
	if (nowComponents.month>=4 && nowComponents.month<=6)
    {
		endComponents.month = 6;
		endComponents.day = 30;
	}
	if (nowComponents.month>=7 && nowComponents.month<=9) 
    {
		endComponents.month = 9;
		endComponents.day = 30;
	}
	if (nowComponents.month>=10 && nowComponents.month<=12) 
    {
		endComponents.month = 12;
		endComponents.day = 31;
	}
    
    
    NSDate *endDate = [calendar dateFromComponents:endComponents];
	self.firstDate = beginDate;
	self.lastDate = endDate;
    
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMM" options:0 locale:[NSLocale currentLocale]]];
    NSString *key1 = [dateFormatter stringFromDate:self.firstDate];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMy" options:0 locale:[NSLocale currentLocale]]];
    NSString *key2 = [dateFormatter stringFromDate:self.lastDate];
    
	NSString *key = [NSString stringWithFormat:@"%@ - %@",key1,key2];
    
	return key;
}


-(NSString *)getNowYear
{
    self.dateStly = 3;
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSDate *nowdate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit fromDate:nowdate];
	NSDateComponents *beginComponents = [[NSDateComponents alloc] init];
	beginComponents.year = nowComponents.year;
	beginComponents.month = 1;
	beginComponents.day = 1;
	NSDate *beginDate = [calendar dateFromComponents:beginComponents];
	NSDateComponents *endComponents = [[NSDateComponents alloc] init];
	endComponents.year = nowComponents.year;
	endComponents.month = 12;
	endComponents.day = 31;
	NSDate *endDate = [calendar dateFromComponents:endComponents];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyy" options:0 locale:[NSLocale currentLocale]]];
	NSString *key = [dateFormatter stringFromDate:beginDate];
	self.firstDate = beginDate;
	self.lastDate = endDate;
	return key;
}




-(void)getPreviousDate
{
    int num;
    
    if (self.dateStly == 0)
    {
        num = -1;
    }
    else if (self.dateStly == 1)
    {
        num = -1;
    }
    else if (self.dateStly == 2)
    {
        num = -3;
    }
    else 
    {
        num = -1;
    }   
    
    self.dateShowLbel.text = [[self changeDate:num]uppercaseString];
    //设置左右按钮的位置
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
    //高清
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
    [self getAllLogsList];
    [self getclientList];
    
    [self reflashTable];
    [self reflashPercentChart];
}



-(void)getNextDate
{
    int num;
    
    if (self.dateStly == 0)
    {
        num = 1;
    }
    else if (self.dateStly == 1)
    {
        num = 1;
    }
    else if (self.dateStly == 2)
    {
        num = 3;
    }
    else 
    {
        num = 1;
    }   
    
    self.dateShowLbel.text = [[self changeDate:num]uppercaseString];
    //设置左右按钮的位置
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dateShowLbel.font,NSFontAttributeName,nil];
    CGSize tmpStringSize = [self.dateShowLbel.text sizeWithAttributes:dic];
    //高清
    if (SCREEN_SCALE<1)
    {
        self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-12;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-26;
    }
    else
    {
        self.dateLeftBtn.left = self.dateShowLbel.left + tmpStringSize.width + 20-6;
        self.dateRightBtn.left = self.dateLeftBtn.left + self.dateLeftBtn.width+20-12.5;
    }
    [self getAllLogsList];
    [self getclientList];
    
    [self reflashTable];
    [self reflashPercentChart];
}


- (NSString *)changeDate:(int)num
{
    
    if (self.dateStly == 0)
    {
        self.sel_weekDay = [self moveDateFrom:self.sel_weekDay bySteps:num];
    }
    
    
    self.firstDate = [self moveDateFrom:self.firstDate bySteps:num];
	self.lastDate = [self moveDateFrom:self.lastDate bySteps:num];
	if(self.dateStly == 1 || self.dateStly == 2)
	{
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self.lastDate];
		NSDateComponents *lastComponents = [[NSDateComponents alloc] init];
		lastComponents.year = nowComponents.year;
		lastComponents.month = nowComponents.month;
		if (nowComponents.month == 1 || nowComponents.month == 3 || nowComponents.month == 5 || nowComponents.month == 7
			|| nowComponents.month == 8 || nowComponents.month == 10  || nowComponents.month == 12)
        {
			lastComponents.day = 31;
		}
		if (nowComponents.month == 4 || nowComponents.month == 6 || nowComponents.month == 9
			|| nowComponents.month == 11) 
        {
			lastComponents.day = 30;
		}
		if (nowComponents.month == 2)
        {
			if ([self isLeapYear:nowComponents.year])
            {
				lastComponents.day = 29;
			}
            else
            {
				lastComponents.day = 28;
			}
		}
		self.lastDate = [calendar dateFromComponents:lastComponents];
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    NSString *key1;
    NSString *key2;
    NSString *key;
    
    if (self.dateStly == 0)
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
        key1 = [dateFormatter stringFromDate:self.firstDate];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdy" options:0 locale:[NSLocale currentLocale]]];
        key2 = [dateFormatter stringFromDate:self.lastDate];
        key = [NSString stringWithFormat:@"%@ - %@",key1,key2];
    }
    else if (self.dateStly == 1)
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMyyyy" options:0 locale:[NSLocale currentLocale]]];
        key = [dateFormatter stringFromDate:self.firstDate];
    }
    else if (self.dateStly == 2)
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMM" options:0 locale:[NSLocale currentLocale]]];
        key1 = [dateFormatter stringFromDate:self.firstDate];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMy" options:0 locale:[NSLocale currentLocale]]];
        key2 = [dateFormatter stringFromDate:self.lastDate];
        
        key = [NSString stringWithFormat:@"%@ - %@",key1,key2];
    }
    else
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyy" options:0 locale:[NSLocale currentLocale]]];
        key = [dateFormatter stringFromDate:self.firstDate];
    }
    
	
	return key;
}


-(NSDate *)getAfterMathDate:(NSDate *)nowDate delayDays:(int)num
{
    NSCalendar *calendar = [NSCalendar currentCalendar];	
	NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
	if (self.dateStly == 0)
    {
		[componentsToSub setDay:num];
	}
	else if (self.dateStly == 1)
    {
		[componentsToSub setMonth:num];
	}
	else if (self.dateStly == 2)
    {
		[componentsToSub setMonth:num];
	}
	else 
    {
		[componentsToSub setYear:num];
	}
    [componentsToSub setHour:23];
    [componentsToSub setMinute:59];
    [componentsToSub setSecond:59];
	NSDate *afterMathDate = [calendar dateByAddingComponents:componentsToSub toDate:nowDate options:0];
	return afterMathDate;
}

-(NSDate *)moveDateFrom:(NSDate *)date bySteps:(int)num
{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* component = [[NSDateComponents alloc] init];
	
	if (self.dateStly == 0) {
		[component setWeek:num];
	}
	else if (self.dateStly == 1) {
		[component setMonth:num];
	}
	else if (self.dateStly == 2) {
		[component setMonth:num];
	}
	else {
		[component setYear:num];
	}
	
	NSDate* resultDate = [calendar dateByAddingComponents:component toDate:date options:0];
	return resultDate;
}










#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.clientTotalList count] == 0)
    {
        return 0;
    }
    else
    {
        return [self.clientTotalList count]+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.clientTotalList count])
    {
        self.totalCell.backgroundColor = [UIColor clearColor];
        
        return self.totalCell;
    }
    else
    {
        NSString* identifier = @"chartipadCell-Identifier";
        ChartCell_ipad *mychartCells = (ChartCell_ipad*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (mychartCells == nil)
        {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ChartCell_ipad" owner:self options:nil];
            
            for (id oneObject in nibs)
            {
                if ([oneObject isKindOfClass:[ChartCell_ipad class]])
                {
                    mychartCells = (ChartCell_ipad*)oneObject;
                    [mychartCells.amountView creatSubViewsisLeftAlignment:NO];
                }
            }
        }
        
        dataTotalUnit_ipad *_clientcell = [self.clientTotalList objectAtIndex:indexPath.row];
        
        NSString *clientName = [_clientcell.all objectAtIndex:0];
        mychartCells.nameLbel.text = clientName;
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (self.tableShowStly == 0)
        {
            mychartCells.midLbel.hidden = NO;
            mychartCells.amountView.hidden = YES;
            mychartCells.midLbel.text = [_clientcell.all objectAtIndex:2];
            mychartCells.percentageLbel.text = [NSString stringWithFormat:@"%@%%",[_clientcell.all objectAtIndex:3]];
        }
        else
        {
            
            mychartCells.midLbel.hidden = YES;
            mychartCells.amountView.hidden = NO;

            [mychartCells.amountView setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[_clientcell.all objectAtIndex:4] color:[HMJNomalClass creatAmountColor]];
            [mychartCells.amountView setNeedsDisplay];
            
            mychartCells.percentageLbel.text = [NSString stringWithFormat:@"%@%%",[_clientcell.all objectAtIndex:5]];
        }
        
        
        int celli = indexPath.row%11;
        UIImage *acrImage = [UIImage imageNamed:[NSString stringWithFormat:@"color%d",celli]];
        [mychartCells.colorImageV setImage:acrImage];
        mychartCells.backgroundColor = [UIColor clearColor];
        
        
        
        return mychartCells;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.clientTotalList.count)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ChartCell_ipad *mycell = (ChartCell_ipad *)[self.tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:indexPath.row inSection:0]];
        
        projectToTaskViewController_ipad *projectToTaskView = [[projectToTaskViewController_ipad alloc] initWithNibName:@"projectToTaskViewController_ipad" bundle:nil];
        
        dataTotalUnit_ipad *_projectcell = [self.clientTotalList objectAtIndex:indexPath.row];
        
        projectToTaskView.preferredContentSize = CGSizeMake(320, 409);
        NSString *_project = [_projectcell.all objectAtIndex:0];
        projectToTaskView.navi_tittle = _project;
        [projectToTaskView.allLogsList addObjectsFromArray:[_projectcell.all objectAtIndex:1]];
        projectToTaskView.overTimeStly = 2;
        projectToTaskView.startDate = self.firstDate;
        projectToTaskView.endDate = self.lastDate;
        
        
        UINavigationController *projectsShowNaiv = [[UINavigationController alloc] initWithRootViewController:projectToTaskView];
        
        if (self.popoverController != nil)
        {
//            self.popoverController;
            self.popoverController = nil;
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:projectsShowNaiv];
        
        
        [self.popoverController presentPopoverFromRect:mycell.midLbel.frame inView:mycell.midLbel.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        
    }
}



@end
