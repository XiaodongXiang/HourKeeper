//
//  PayEndFlagViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//

#import "PayEndFlagViewController.h"
#import "AppDelegate_Shared.h"
#import "NewClientViewController_iphone.h"
#import "NewClientViewController_ipad.h"




@interface PayEndFlagViewController()
{
    //正在编辑的这个clientvc对应的支付时间模式
    int clientDelegate_payPeriodStly;
    int clientDelegate_payPeriodNum1;
    int clientDelegate_payPeriodNum2;
}

@end






@implementation PayEndFlagViewController



@synthesize pickView;

@synthesize firstArray;
@synthesize secondArray;

@synthesize firstLbel;
@synthesize secondLbel;


@synthesize tipLbel;

@synthesize clientDelegate;
@synthesize clientDelegate_ipad;
@synthesize payStly;
@synthesize payPeriodNum1;
@synthesize payPeriodNum2;


#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        firstArray = [[NSMutableArray alloc] init];
        secondArray = [[NSMutableArray alloc] init];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 51, 30);
    [saveButton setTitle:@"Done" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(backAndSave) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Select Day"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    
    
    float m_with;
    if ([UIScreen mainScreen].bounds.size.width > 400)
    {
        m_with = 40;
    }
    else if ([UIScreen mainScreen].bounds.size.width >350)
    {
        m_with = 30;
    }
    else
    {
        m_with = 20;
    }
    self.firstLbel.frame = CGRectMake(m_with, self.firstLbel.frame.origin.y, self.firstLbel.frame.size.width, self.firstLbel.frame.size.height);
     self.secondLbel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-m_with-secondLbel.frame.size.width, self.secondLbel.frame.origin.y, self.secondLbel.frame.size.width, self.secondLbel.frame.size.height);
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        clientDelegate_payPeriodStly = self.clientDelegate_ipad.payPeriodStly;
        clientDelegate_payPeriodNum1 = self.clientDelegate_ipad.payPeriodNum1;
        clientDelegate_payPeriodNum2 = self.clientDelegate_ipad.payPeriodNum2;
    }
    else
    {
        clientDelegate_payPeriodStly = self.clientDelegate.payPeriodStly;
        clientDelegate_payPeriodNum1 = self.clientDelegate.payPeriodNum1;
        clientDelegate_payPeriodNum2 = self.clientDelegate.payPeriodNum2;
    }
    
    
    if (self.payStly == 1)
    {
        
        [self.firstArray addObjectsFromArray:[NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"wednesday",@"Thursday",@"Friday",@"Saturday", nil]];
        
        //如果从其他类型跳过来的，默认选择第一个
        if (clientDelegate_payPeriodStly != 1)
        {
            [self.pickView selectRow:0 inComponent:0 animated:NO];
            self.payPeriodNum1 = 1;
        }
        //选择用户已经选择的星期几
        else
        {
            [self.pickView selectRow:clientDelegate_payPeriodNum1-1 inComponent:0 animated:NO];
            self.payPeriodNum1 = clientDelegate_payPeriodNum1;
        }
        self.payPeriodNum2 = 31;
    }
    //Semi-Monthly 半月
    else if (self.payStly == 3)
    {
        [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Select Days"];

        self.tipLbel.text = @"Choose the period ending days for your semi-monthy pay schedule.";
        
        [self.firstLbel setHidden:NO];
        [self.secondLbel setHidden:NO];
        
        
        for (int i=1 ; i<=30; i++)
        {
            [self.firstArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        if (clientDelegate_payPeriodStly != 3)
        {
            for (int i=16; i<=31; i++)
            {
                [self.secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self.pickView selectRow:14 inComponent:0 animated:NO];
            [self.pickView selectRow:15 inComponent:1 animated:NO];
            self.payPeriodNum1 = 15;
            self.payPeriodNum2 = 31;
        }
        else
        {
            for (int i=clientDelegate_payPeriodNum1+1; i<=31; i++)
            {
                [self.secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self.pickView selectRow:clientDelegate_payPeriodNum1-1 inComponent:0 animated:NO];
            [self.pickView selectRow:clientDelegate_payPeriodNum2-clientDelegate_payPeriodNum1-1 inComponent:1 animated:NO];
            self.payPeriodNum1 = clientDelegate_payPeriodNum1;
            self.payPeriodNum2 = clientDelegate_payPeriodNum2;
        }
    }
    //Monthly
    else if (self.payStly == 4)
    {
        for (int i=1 ; i<=31; i++)
        {
            [self.firstArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        //默认设置最后一天
        if (clientDelegate_payPeriodStly != 4)
        {
            [self.pickView selectRow:30 inComponent:0 animated:NO];
            self.payPeriodNum1 = 31;
        }
        else
        {
            [self.pickView selectRow:clientDelegate_payPeriodNum1-1 inComponent:0 animated:NO];
            self.payPeriodNum1 = clientDelegate_payPeriodNum1;
        }
        self.payPeriodNum2 = 31;
    }
    

    [self.pickView reloadAllComponents];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}

#pragma mark Action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAndSave
{
    
    if (self.payPeriodNum1 == 0)
    {
        self.payPeriodNum1 = 1;
    }
    if (self.payPeriodNum2 == 0 || self.payPeriodNum2 > 31)
    {
        self.payPeriodNum2 = 31;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.clientDelegate_ipad savePayStly:self.payStly EndFlag1:self.payPeriodNum1 endFlag2:self.payPeriodNum2 endDate:nil];
        [self.navigationController popToViewController:self.clientDelegate_ipad animated:YES];
    }
    else
    {
        [self.clientDelegate savePayStly:self.payStly EndFlag1:self.payPeriodNum1 endFlag2:self.payPeriodNum2 endDate:nil];
        [self.navigationController popToViewController:self.clientDelegate animated:YES];
    }
    
}






-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.payStly == 3)
    {
        return 2;
    }
	return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0)
    {
		return [self.firstArray count];
	}
	else
    {
        return [self.secondArray count];
	}
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.payStly == 3)
    {
        if (component == 0 && self.payPeriodNum1 != row+1)
        {
            int oldSecondcount = (int)[self.secondArray count]-(int)[self.pickView selectedRowInComponent:1];
            
            [self.secondArray removeAllObjects];
            for (int i=(int)(row+2); i<=31; i++)
            {
                [self.secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self.pickView reloadAllComponents];
            
            
            if ([self.secondArray count] < oldSecondcount)
            {
                [self.pickView selectRow:[self.secondArray count]-1 inComponent:1 animated:NO];
            }
            else
            {
                [self.pickView selectRow:[self.secondArray count]-oldSecondcount inComponent:1 animated:NO];
            }
        }
        
        self.payPeriodNum1 = (int)[self.pickView selectedRowInComponent:0]+1;
        self.payPeriodNum2 = (int)[self.pickView selectedRowInComponent:1]+1+self.payPeriodNum1;
        
        if ([self.secondArray count] != (31-self.payPeriodNum1))
        {
            [self.secondArray removeAllObjects];
            for (int i=(int)[self.pickView selectedRowInComponent:0]+2; i<=31; i++)
            {
                [self.secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            [self.pickView reloadAllComponents];
            
            [self.pickView selectRow:[self.secondArray count]-1 inComponent:1 animated:NO];
            self.payPeriodNum2 = (int)[self.pickView selectedRowInComponent:1]+1+self.payPeriodNum1;
        }
    }
    else
    {
        self.payPeriodNum1 = (int)(row+1);
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
	if (component == 0)
    {
		return [self.firstArray objectAtIndex:row];
	}
    else
    {
		return [self.secondArray objectAtIndex:row];
	}
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc
//{
//	self.pickView;
//	self.firstArray;
//	self.secondArray;
//    
//    self.firstLbel;
//    self.secondLbel;
//    
//    self.tipLbel;
//    
//}



@end
