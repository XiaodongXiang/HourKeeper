//
//  PayEndTimeViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 8/13/13.
//
//


#import "PayEndTimeViewController.h"
#import "NewClientViewController_iphone.h"
#import "NewClientViewController_ipad.h"
#import "AppDelegate_Shared.h"


@implementation PayEndTimeViewController



@synthesize datePicker;

@synthesize clientDelegate;
@synthesize clientDelegate_ipad;
@synthesize payStly;

#pragma mark Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 51, 30);
    [saveButton setTitle:@"Done" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:@"Select Date"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (self.clientDelegate_ipad.payPeriodDate == nil)
        {
            self.datePicker.date = [NSDate date];
        }
        else
        {
            self.datePicker.date = self.clientDelegate_ipad.payPeriodDate;
        }
    }
    else
    {
        if (self.clientDelegate.payPeriodDate == nil)
        {
            self.datePicker.date = [NSDate date];
        }
        else
        {
            self.datePicker.date = self.clientDelegate.payPeriodDate;
        }
    }

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


- (void)done
{
    if (self.datePicker.date == nil)
    {
        self.datePicker.date = [NSDate date];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.clientDelegate_ipad savePayStly:self.payStly EndFlag1:1 endFlag2:31 endDate:self.datePicker.date];
        [self.navigationController popToViewController:self.clientDelegate_ipad animated:YES];
    }
    else
    {
        [self.clientDelegate savePayStly:self.payStly EndFlag1:1 endFlag2:31 endDate:self.datePicker.date];
        [self.navigationController popToViewController:self.clientDelegate animated:YES];
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
//	self.datePicker;
//    
//}





@end
