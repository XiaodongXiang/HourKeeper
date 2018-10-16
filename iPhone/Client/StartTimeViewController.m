//
//  StartTimeViewController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-17.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "StartTimeViewController.h"
#import "AppDelegate_Shared.h"


@implementation StartTimeViewController



@synthesize datePicker;
@synthesize delegate;
@synthesize dateTipLbel;
@synthesize ipadView;

@synthesize inputDate;
@synthesize minDate;
@synthesize maxDate;
@synthesize naiv_tittle;


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
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 56, 30);
        [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//        backButton.titleLabel.font = appDelegate.naviFont;
//        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
        
        
        [appDelegate setNaviGationTittle:self with:100 high:44 tittle:self.naiv_tittle];
        
        [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    }
    else
    {
        self.navigationItem.title = self.naiv_tittle;
        [saveButton setTitleColor:[UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1] forState:UIControlStateNormal];
        self.ipadView.frame = CGRectMake(0, 79, self.ipadView.frame.size.width,self.ipadView.frame.size.height);
    }
    
    
    self.datePicker.date = self.inputDate;
    self.datePicker.maximumDate = self.maxDate;
    self.datePicker.minimumDate = self.minDate;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdhmm" options:0 locale:[NSLocale currentLocale]]];
    
    self.dateTipLbel.text = [dateFormatter stringFromDate:self.datePicker.date];
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












-(IBAction)dateChange
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.datePicker.datePickerMode != UIDatePickerModeDate)
    {
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEMMMdhmm" options:0 locale:[NSLocale currentLocale]]];
    }
    else
    {
        [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    }

    self.dateTipLbel.text = [dateFormatter stringFromDate:self.datePicker.date];
}



-(void)back
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
    else 
    {
        [delegate saveStartTimeDate:nil];
    }
}


- (void)done
{
    [delegate saveStartTimeDate:datePicker.date];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
    {
        [self.navigationController popViewControllerAnimated:YES];
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




@end
