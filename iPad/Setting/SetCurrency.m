//
//  SetCurrency.m
//  HoursKeeper
//
//  Created by xy_dev on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetCurrency.h"
#import "Settings.h"
#import "AppDelegate_iPad.h"



@implementation SetCurrency

int rownum;

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backBtn.titleLabel.font = appDelegate.naviFont;
//    [backBtn setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Currency"];
    

	self.selectRowName = appDelegate.appSetting.currency;
	rownum = (int)[appDelegate.m_currencyArray indexOfObject:self.selectRowName];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:rownum inSection:0];
    [self.myTableView scrollToRowAtIndexPath:sel_indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}



-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.m_currencyArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [appDelegate.m_currencyArray objectAtIndex:indexPath.row];
	
    [cell.textLabel setTextColor:[UIColor colorWithRed:61.0/255.0 green:63.0/255.0 blue:64.0/255.0 alpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    
    
    if (indexPath.row == rownum)
    {
		UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
        cell.accessoryView = accImageView;
	}
    else
    {
        cell.accessoryView = nil;
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	appDelegate.appSetting.currency = [appDelegate.m_currencyArray objectAtIndex:indexPath.row];
    appDelegate.currencyStr = [[appDelegate.appSetting.currency componentsSeparatedByString:@" - "] objectAtIndex:0];
	[context save:nil];
    
    [appDelegate.mainView reflashTimerMainView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView reloadData];
}




@end
