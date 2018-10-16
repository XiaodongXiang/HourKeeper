//
//  ChartViewController_new.m
//  HoursKeeper
//
//  Created by xy_dev on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartViewController_new.h"

#import "UINavigationBar+CustomImage.h"

#import "AppDelegate_iPhone.h"
#import "Logs.h"
#import "Clients.h"

#import "ChartCell_iphone.h"




@interface dataTotalUnit : NSObject
{
    double moneyOrder;
    int timeOrder;
    NSMutableArray *all;
}
@property (nonatomic,assign) double moneyOrder;
@property (nonatomic,assign) int timeOrder;
@property (nonatomic,strong) NSMutableArray *all;

@end


@implementation dataTotalUnit

@synthesize moneyOrder;
@synthesize timeOrder;
@synthesize all;

-(id)init
{
    if (!(self = [super init])) return nil;
    
    all = [[NSMutableArray alloc] init];
    
    return self;
}


//-(void)dealloc
//{
//    self.all;
//    
//}


@end




@implementation ChartViewController_new




@synthesize tableView;
@synthesize naviTitelView;

@synthesize allLogsList;
@synthesize firstDate;
@synthesize lastDate;
@synthesize dateStly;
@synthesize clientTotalList;
@synthesize clientMPercentageList;
@synthesize clientTPercentageList;
@synthesize tableShowStly;

@synthesize pieView;
@synthesize sel_weekDay;
@synthesize titleLbel;
@synthesize dropboxChartContor;
@synthesize lite_Btn;

@synthesize weekBtn;
@synthesize monthBtn;
@synthesize quarterBtn;
@synthesize yearBtn;

@synthesize showTimeStr;

@synthesize totalCell;
@synthesize totalLbel;
@synthesize segmentCtrol;
@synthesize segmentImagV;


//int redList1[20] =   {2,14,253,202,175,202,148,118,83,19,0};
//int greenList1[20] = {158,142,232,213,205,234,215,208,198,196,183};
//int blueList1[20] = {223,192,220,217,216,231,227,225,222,234,241};
int redList1[11] =   {14,2,0,19,83,118,148,202,175,202,253};
int greenList1[11] = {142,158,183,196,198,208,215,234,205,213,232};
int blueList1[11] = {192,223,241,234,222,225,227,231,216,217,220};




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
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar drawNavigationBarForOS5];
    self.navigationItem.titleView = self.naviTitelView;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:YES];
    
    
    
    clientTotalList = [[NSMutableArray alloc] init];
    clientTPercentageList = [[NSMutableArray alloc] init];
    clientMPercentageList = [[NSMutableArray alloc] init];
    allLogsList = [[NSMutableArray alloc] init];
    
    _line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    _line.top = self.tableView.top - SCREEN_SCALE;
    _line.height = SCREEN_SCALE;
    
    float m_with = ceilf([UIScreen mainScreen].bounds.size.width/4);
    float m_high = self.weekBtn.frame.size.height;
    self.weekBtn.frame = CGRectMake(0, 0, m_with, m_high);
    self.monthBtn.frame = CGRectMake(m_with, 0, m_with, m_high);
    self.quarterBtn.frame = CGRectMake(2*m_with, 0, m_with, m_high);
    self.yearBtn.frame = CGRectMake(3*m_with, 0, m_with, m_high);
    
    
    //初始化数据
    self.tableShowStly = 1;
    self.dateStly = 0;
    self.sel_weekDay = [NSDate date];
    self.titleLbel.text = [self getNowWeek];
    
//    pieView = [[PieView alloc]init];
    [pieView initPoint];
    
    
    if (appDelegate.isPurchased == NO)
    {
        float higt;
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height-self.tableView.frame.origin.y;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
        
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

    
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentCtrol setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    [self showSegmentImage];
    
    [_totalAmountLabel creatSubViewsisLeftAlignment:NO];
    
    if (IS_IPHONE_6PLUS)
    {
        self.totallabel1.left = 50;
        self.totalAmountLabel.left = self.totalAmountLabel.left - 5;
        self.totalLbel.left = self.totalLbel.left - 5;
    }
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    self.totalCell.frame = CGRectMake(self.totalCell.frame.origin.x, self.totalCell.frame.origin.y, self.view.frame.size.width, self.totalCell.frame.size.height);
//    self.totalLbel.frame = CGRectMake(self.totalCell.frame.size.width-15-self.totalLbel.frame.size.width, self.totalLbel.frame.origin.y, self.totalLbel.frame.size.width, self.totalLbel.frame.size.height);
//    _totalAmountLabel.frame = self.totalLbel.frame;
    
    float with = SCREEN_WITH/4;
    weekBtn.left = 0;
    weekBtn.width = with;
    monthBtn.left = with;
    monthBtn.width = with;
    quarterBtn.left = with*2;
    quarterBtn.width = with;
    yearBtn.left = with*3;
    yearBtn.width = with;
    
    
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
        higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.lite_Btn.frame.size.height-self.tableView.frame.origin.y;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
    }
    else
    {
        [self.lite_Btn setHidden:YES];
    }
    
    
    if (self.dateStly == 0)
    {
        self.titleLbel.text = [self getNowWeek];
    }
    self.dropboxChartContor = nil;
    [self initChartView];
}









-(void)initChartView
{
    [self getAllLogsList];
    [self getclientList];
    
    [self reflashTable];
    [self reflashPercentChart];
    
    [self setDateStlyImage:(int)self.dateStly];
    
    if (self.dropboxChartContor != nil)
    {
        [self.dropboxChartContor reflashView];
    }
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
        
        self.totalLbel.text = self.showTimeStr;
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"timeOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    else
    {
        [Flurry logEvent:@"5_REPO_AMO"];
        
        [_totalAmountLabel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",_totalAmount] color:[HMJNomalClass creatAmountColor]];
        [_totalAmountLabel setNeedsDisplay];
        
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"moneyOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    for (dataTotalUnit *unit in self.clientTotalList)
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


-(IBAction)dateStlyBtn:(UIButton *)sender
{
    if (sender.tag != self.dateStly)
    {
        self.dateStly = sender.tag;
        [sender setTag:self.dateStly];
        
        if (self.dateStly == 0)
        {
            [Flurry logEvent:@"5_REPO_WEEK"];
            
            self.titleLbel.text = [self getNowWeek];
        }
        else if (self.dateStly == 1)
        {
            [Flurry logEvent:@"5_REPO_MON"];
            
            self.titleLbel.text = [self getNowMonth];
        }
        else if (self.dateStly == 2)
        {
            [Flurry logEvent:@"5_REPO_QUA"];
            
            self.titleLbel.text = [self getNowQuarter];
        }
        else
        {
            [Flurry logEvent:@"5_REPO_YEAR"];
            
            self.titleLbel.text = [self getNowYear];
        }
        
        [self getAllLogsList];
        [self getclientList];
        
        [self reflashTable];
        [self reflashPercentChart];
        
        
        [self setDateStlyImage:(int)self.dateStly];
    }
}

-(void)setDateStlyImage:(int)flag
{
    if (flag == 0)
    {
        [self.weekBtn setSelected:YES];
        [self.monthBtn setSelected:NO];
        [self.quarterBtn setSelected:NO];
        [self.yearBtn setSelected:NO];
    }
    else if (flag == 1)
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:YES];
        [self.quarterBtn setSelected:NO];
        [self.yearBtn setSelected:NO];
    }
    else if (flag == 2)
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:NO];
        [self.quarterBtn setSelected:YES];
        [self.yearBtn setSelected:NO];
    }
    else
    {
        [self.weekBtn setSelected:NO];
        [self.monthBtn setSelected:NO];
        [self.quarterBtn setSelected:NO];
        [self.yearBtn setSelected:YES];
    }
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
    double money_sub = 0.0;
    for (int k=0; k<[self.allLogsList count]; k++)
    {
        Logs *mylog = [self.allLogsList objectAtIndex:k];
        NSString *timelength = (mylog.worked == nil) ? @"0:00":mylog.worked;
        NSArray *timeArray = [timelength componentsSeparatedByString:@":"];
        int hours = [[timeArray objectAtIndex:0] intValue];
        int minutes = [[timeArray objectAtIndex:1] intValue];
        time_sub = time_sub +hours*3600+minutes*60;
        money_sub = money_sub + [mylog.totalmoney doubleValue];
    }
    NSArray *backArray = [appDelegate overTimeMoney_logs:self.allLogsList];
    double weekAddMoney = [[backArray objectAtIndex:0]doubleValue];
    money_sub = money_sub + weekAddMoney;
    
    
    [self.clientTotalList removeAllObjects];
    
	NSMutableArray *results = [[NSMutableArray alloc] init];
    [results addObjectsFromArray:self.allLogsList];
    
	for (int i=0; i<[results count]; i++)
    {
        dataTotalUnit *totalClientcell = [[dataTotalUnit alloc] init];
        
		NSMutableArray *myArray = [[NSMutableArray alloc] init];
		Logs *log1 = [results objectAtIndex:i];
        Clients *client1 = log1.client;
//        if(client1==nil)
//            return;
        
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
//        NSString *totalMoney = [appDelegate appMoneyShowStly4:allmoney];
        
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
        if (money_sub == 0)
        {
            moneyPercent = ZERO_NUM;
        }
        else
        {
            moneyPercent = [appDelegate appMoneyShowStly4:allmoney/money_sub*100];
        }
        
        [totalClientcell.all addObject:client1.clientName];
        [totalClientcell.all addObject:myArray];
        [totalClientcell.all addObject:totalTime];
        [totalClientcell.all addObject:timePercent];
        [totalClientcell.all addObject:[NSNumber numberWithDouble:allmoney]];
        [totalClientcell.all addObject:moneyPercent];
        [totalClientcell.all addObject:client1];
        
        totalClientcell.timeOrder = (int)allseconds;
        totalClientcell.moneyOrder = allmoney;
        
        [self.clientTotalList addObject:totalClientcell];
        
	}
    
    
    
    self.showTimeStr = [appDelegate conevrtTime2:(int)time_sub];
//    self.showMoneyStr = [appDelegate appMoneyShowStly3:money_sub];
    _totalAmount = money_sub;
    
    [self.clientTPercentageList removeAllObjects];
    [self.clientMPercentageList removeAllObjects];
    if (self.tableShowStly == 0)
    {
        self.totalLbel.text = self.showTimeStr;
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"timeOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    else
    {
        [_totalAmountLabel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",_totalAmount] color:[HMJNomalClass creatAmountColor]];
        [_totalAmountLabel setNeedsDisplay];
        
        NSSortDescriptor* clientsort = [NSSortDescriptor sortDescriptorWithKey:@"moneyOrder" ascending:NO];
        [self.clientTotalList sortUsingDescriptors:[NSArray arrayWithObject:clientsort]];
    }
    for (dataTotalUnit *unit in self.clientTotalList)
    {
        [self.clientTPercentageList addObject:[unit.all objectAtIndex:3]];
        [self.clientMPercentageList addObject:[unit.all objectAtIndex:5]];
    }
    
    if (self.clientTotalList.count == 0)
    {
        [self.segmentCtrol setHidden:YES];
        [self.segmentImagV setHidden:YES];
        _pieBgImageView.hidden = YES;
        _line.hidden = YES;
    }
    else
    {
        [self.segmentCtrol setHidden:NO];
        [self.segmentImagV setHidden:NO];
        _pieBgImageView.hidden = NO;
        _line.hidden = NO;
    }
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
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
	int firstWeekday = [appDelegate getFirstDayForWeek];
	[calendar setFirstWeekday:firstWeekday];
    NSDate *weekFirstDate = nil;
	[calendar rangeOfUnit:NSWeekCalendarUnit startDate:&weekFirstDate interval:NULL forDate:self.sel_weekDay];
    
    self.firstDate = weekFirstDate;
    self.lastDate = [self getAfterMathDate:self.firstDate delayDays:6];
    
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
    
    self.titleLbel.text = [self changeDate:num];
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
    
    self.titleLbel.text = [self changeDate:num];
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












#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

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
        if (self.tableShowStly == 0)
        {
            self.totalLbel.hidden = NO;
            _totalAmountLabel.hidden = YES;
        }
        else
        {
            self.totalLbel.hidden = YES;
            _totalAmountLabel.hidden = NO;
        }
        return self.totalCell;
    }
    else
    {
        NSString* identifier = @"chartiphoneCell-Identifier";
        ChartCell_iphone *mychartCells = (ChartCell_iphone*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (mychartCells == nil)
        {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ChartCell_iphone" owner:self options:nil];
            
            for (id oneObject in nibs)
            {
                if ([oneObject isKindOfClass:[ChartCell_iphone class]])
                {
                    mychartCells = (ChartCell_iphone*)oneObject;
                    [mychartCells.amountLabel creatSubViewsisLeftAlignment:NO];
                }
            }
        }
        
        
        dataTotalUnit *_clientcell = [self.clientTotalList objectAtIndex:indexPath.row];
        
        NSString *clientName = [_clientcell.all objectAtIndex:0];
        mychartCells.nameLbel.text = clientName;
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (self.tableShowStly == 0)
        {
            mychartCells.percentageLbel.text = [NSString stringWithFormat:@"%@%%",[_clientcell.all objectAtIndex:3]];
            mychartCells.amountLabel.hidden = YES;
            mychartCells.midLbel.hidden = NO;
            mychartCells.midLbel.text = [_clientcell.all objectAtIndex:2];
            mychartCells.line.hidden = YES;

            
        }
        else
        {
            mychartCells.amountLabel.hidden = NO;
            [mychartCells.amountLabel setAmountSize:25 pointSize:20 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",[[_clientcell.all objectAtIndex:4] doubleValue]] color:[HMJNomalClass creatAmountColor]];
            [mychartCells.amountLabel setNeedsDisplay];
            mychartCells.percentageLbel.text = [NSString stringWithFormat:@"%@%%",[_clientcell.all objectAtIndex:5]];
            mychartCells.midLbel.hidden = YES;
            mychartCells.line.hidden = NO;

        }
        
        mychartCells.line.width = SCREEN_SCALE;
        int celli = indexPath.row%11;
        UIImage *acrImage = [UIImage imageNamed:[NSString stringWithFormat:@"color%d",celli]];
        [mychartCells.colorImageV setImage:acrImage];
        
        mychartCells.bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        mychartCells.bottomLine.top = mychartCells.height - SCREEN_SCALE;
        mychartCells.bottomLine.height = SCREEN_SCALE;
//        if(indexPath.row == [self.clientTotalList count]-1)
//        {
//            mychartCells.bottomLine.left = 0;
//        }
//        else
//        {
//            float left = 15;
//            if (IS_IPHONE_6PLUS)
//            {
//                left = 20;
//            }
//            mychartCells.bottomLine.left = left;
//        }
        return mychartCells;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.clientTotalList.count)
    {
        ProjectChartViewController *projectChartView = [[ProjectChartViewController alloc] initWithNibName:@"ProjectChartViewController" bundle:nil];
        
        self.dropboxChartContor = projectChartView;
        
        [projectChartView setHidesBottomBarWhenPushed:YES];
        
        dataTotalUnit *_projectkcell = [self.clientTotalList objectAtIndex:indexPath.row];
        projectChartView.sel_startDate = self.firstDate;
        projectChartView.sel_endDate = self.lastDate;
        projectChartView.clientName = [_projectkcell.all objectAtIndex:0];
        projectChartView.dateStr = self.titleLbel.text;
        projectChartView.sel_client = [_projectkcell.all objectAtIndex:6];
        
        [self.navigationController pushViewController:projectChartView animated:YES];
        
    }
}





-(IBAction)doLiteBtn
{
    [Flurry logEvent:@"7_ADS_TAP"];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate doPurchase_Lite];
}

-(void)pop_system_UnlockLite
{
    float higt;
    higt = [[UIScreen mainScreen] bounds].size.height-44-20-self.tableView.frame.origin.y;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, higt);
    
    [self.lite_Btn setHidden:YES];

}






@end


