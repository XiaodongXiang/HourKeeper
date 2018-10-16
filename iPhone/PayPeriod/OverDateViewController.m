//
//  OverDateViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 11/27/13.
//
//

#import "OverDateViewController.h"

#import "AppDelegate_Shared.h"



@implementation OverDateViewController


@synthesize segmentControl;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize firstBtn;
@synthesize isFirstStly;
@synthesize secondView;
@synthesize secondBtn;
@synthesize dateStly;

@synthesize startLbel;

@synthesize sel_datePicker;
@synthesize datePickerBvView;

@synthesize sel_client;
@synthesize startDate;
@synthesize endDate;
@synthesize delegate;

@synthesize segmentImagV;


#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.startDate = [NSDate date];
        self.endDate = nil;
        self.isFirstStly = 0;
        self.dateStly = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(backAndSave) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Select Date"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    
    [self.segmentControl setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorWithRed:20/255.0 green:75/255.0 blue:95/255.0 alpha:1],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]
                                                } forState:UIControlStateSelected];
    
    [self.segmentControl setSelectedSegmentIndex:self.dateStly];
    [self doSegment:self.segmentControl];
    [self showSegmentImage];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    [self.delegate saveSelectDate:self.startDate second:self.endDate dateStly:self.dateStly];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
-(void)backAndSave
{
    [self.delegate saveSelectDate:self.startDate second:self.endDate dateStly:self.dateStly];
	[self.navigationController popViewControllerAnimated:YES];
}


/**
    Segment某一部分选中
 */
-(IBAction)doSegment:(UISegmentedControl *)sender
{
    self.dateStly = sender.selectedSegmentIndex;
    [self showSegmentImage];
    //Date
    if (sender.selectedSegmentIndex == 0)
    {
        [Flurry logEvent:@"2_PPD_OTCALRDATE"];
        
        [self.startLbel setHidden:YES];
        self.isFirstStly = 0;
        [self.secondView setHidden:YES];
        [self.secondBtn setUserInteractionEnabled:NO];
        [self.leftBtn setHidden:YES];
        [self.leftBtn setUserInteractionEnabled:NO];
        [self.rightBtn setHidden:YES];
        [self.rightBtn setUserInteractionEnabled:NO];
        [self.firstBtn setUserInteractionEnabled:NO];
        [self.datePickerBvView setHidden:NO];
        self.sel_datePicker.date = self.startDate;
        self.sel_datePicker.maximumDate = nil;
        self.sel_datePicker.minimumDate = nil;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateNormal];
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateHighlighted];
    }
    //Period
    else if (sender.selectedSegmentIndex == 1)
    {
        [Flurry logEvent:@"2_PPD_OTCALRPPD"];
        
        [self.startLbel setHidden:YES];
        [self.secondView setHidden:YES];
        [self.secondBtn setUserInteractionEnabled:NO];
        [self.leftBtn setHidden:NO];
        [self.leftBtn setUserInteractionEnabled:YES];
        [self.rightBtn setHidden:NO];
        [self.rightBtn setUserInteractionEnabled:YES];
        [self.firstBtn setUserInteractionEnabled:NO];
        [self.datePickerBvView setHidden:YES];

        [self showSecondDateStly:[NSDate date]];
    }
    //Custom
    else
    {
        [Flurry logEvent:@"2_PPD_OTCALRCUS"];
        
        [self.startLbel setHidden:NO];
        self.isFirstStly = 0;
        [self.secondView setHidden:NO];
        [self.secondBtn setUserInteractionEnabled:YES];
        [self.leftBtn setHidden:YES];
        [self.leftBtn setUserInteractionEnabled:NO];
        [self.rightBtn setHidden:YES];
        [self.rightBtn setUserInteractionEnabled:NO];
        [self.firstBtn setUserInteractionEnabled:YES];
        [self.datePickerBvView setHidden:NO];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateNormal];
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateHighlighted];
        
        if (self.endDate == nil)
        {
            self.endDate = [self.startDate dateByAddingTimeInterval:(NSTimeInterval)24*3600];;
        }
        [self.secondBtn setTitle:[dateFormatter stringFromDate:self.endDate] forState:UIControlStateNormal];
        [self.secondBtn setTitle:[dateFormatter stringFromDate:self.endDate] forState:UIControlStateHighlighted];
        
        self.sel_datePicker.date = self.startDate;
        self.sel_datePicker.maximumDate = self.endDate;
        self.sel_datePicker.minimumDate = nil;
    }
}

-(void)showSegmentImage
{
    NSString *imageStr = nil;
    if (self.dateStly == 0)
    {
        imageStr = @"btn_date_280_29.png";
    }
    else if (self.dateStly == 1)
    {
        imageStr = @"btn_pay_period1_280_29.png";
    }
    else
    {
        imageStr = @"btn_custom_280_29.png";
    }
    [self.segmentImagV setImage:[UIImage imageNamed:imageStr]];
}

-(IBAction)doLeftOrRightBtn:(UIButton *)sender
{
    NSDate *duDate;
    if (sender.tag == 0)
    {
        duDate = [self.startDate dateByAddingTimeInterval:-(NSTimeInterval)24*3600];
    }
    else
    {
        duDate = [self.endDate dateByAddingTimeInterval:(NSTimeInterval)24*3600];
    }
    
    [self showSecondDateStly:duDate];
}

/**
    获取上一个或者下一个时间段，显示时间文本
 */
-(void)showSecondDateStly:(NSDate *)duDate
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSDate *sel_firstDate = nil;
    NSDate *sel_endDate = nil;
    
    [appDelegate getPayPeroid_selClient:sel_client payPeroidDate:duDate backStartDate:&sel_firstDate backEndDate:&sel_endDate];
    
    self.startDate = sel_firstDate;
    self.endDate = sel_endDate;
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    NSString *key1 = [dateFormatter2 stringFromDate:self.startDate];
    NSString *key2 = [dateFormatter stringFromDate:self.endDate];
    NSString *key = [NSString stringWithFormat:@"%@ - %@",key1,key2];
    [self.firstBtn setTitle:key forState:UIControlStateNormal];
    [self.firstBtn setTitle:key forState:UIControlStateHighlighted];
}

-(IBAction)doFirOrSecBtn:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        self.isFirstStly = 0;
        self.sel_datePicker.date = self.startDate;
        self.sel_datePicker.maximumDate = self.endDate;
        self.sel_datePicker.minimumDate = nil;
    }
    else
    {
        self.isFirstStly = 1;
        self.sel_datePicker.date = self.endDate;
        self.sel_datePicker.minimumDate = self.startDate;
        self.sel_datePicker.maximumDate = nil;
    }
}

-(IBAction)doPickerDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
    
    if (self.isFirstStly == 0)
    {
        self.startDate = self.sel_datePicker.date;
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateNormal];
        [self.firstBtn setTitle:[dateFormatter stringFromDate:self.startDate] forState:UIControlStateHighlighted];
    }
    else
    {
        self.endDate = self.sel_datePicker.date;
        [self.secondBtn setTitle:[dateFormatter stringFromDate:self.endDate] forState:UIControlStateNormal];
        [self.secondBtn setTitle:[dateFormatter stringFromDate:self.endDate] forState:UIControlStateHighlighted];
    }
}





@end
