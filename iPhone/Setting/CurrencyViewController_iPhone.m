//
//  CurrencyViewController_iPhone.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-30.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "CurrencyViewController_iPhone.h"
#import "AppDelegate_Shared.h"

@interface CurrencyViewController_iPhone()
{
	int rownum;
}

@end

@implementation CurrencyViewController_iPhone


#pragma mark -
#pragma mark View lifecycle


@synthesize selectRowName;
@synthesize myTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Currency"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    

	selectRowName = appDelegate.appSetting.currency;
	rownum = (int)[appDelegate.m_currencyArray indexOfObject:selectRowName];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:rownum inSection:0];
    [self.myTableView scrollToRowAtIndexPath:sel_indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
}










#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    return appDelegate.m_currencyArray.count;
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





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	appDelegate.appSetting.currency = [appDelegate.m_currencyArray objectAtIndex:indexPath.row];
    appDelegate.currencyStr = [[appDelegate.appSetting.currency componentsSeparatedByString:@" - "] objectAtIndex:0];
	[context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc
{
//    self.myTableView;
}


@end

