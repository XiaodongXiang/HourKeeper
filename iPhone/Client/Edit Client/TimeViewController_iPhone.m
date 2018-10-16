//
//  CurrencyViewController_iPhone.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-30.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "TimeViewController_iPhone.h"
#import "AppDelegate_Shared.h"

@interface TimeViewController_iPhone()
{	
	int rownum;
}
@end

@implementation TimeViewController_iPhone


@synthesize timeArray,selectRowName,delegate;
@synthesize myTableView;





#pragma mark -
#pragma mark View lifecycle

-(void)back
{
    [self.delegate saveTimeRound:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Time Round"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    
    
	timeArray = [[NSMutableArray alloc] initWithObjects:
                 @"1 minute up",@"1 minute down",
				 @"5 minutes up",@"5 minutes down",
				 @"10 minutes up",@"10 minutes down",
				 @"15 minutes up",@"15 minutes down",
				 @"30 minutes up",@"30 minutes down",
				 @"1 hour up",@"1 hour down",
				 nil];
	
	rownum = (int)[timeArray indexOfObject:selectRowName];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
    
    
    NSIndexPath *sel_indexPath = [NSIndexPath indexPathForRow:rownum inSection:0];
    [self.myTableView scrollToRowAtIndexPath:sel_indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [timeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *timeStr = [timeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [timeStr capitalizedString];
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
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
	NSIndexPath *beforePath = [NSIndexPath indexPathForRow:rownum inSection:0];
	UITableViewCell *beforecell = [tableView cellForRowAtIndexPath:beforePath];
	beforecell.accessoryType = UITableViewCellAccessoryNone;
	UITableViewCell *timecell = [tableView cellForRowAtIndexPath:indexPath];
	timecell.accessoryType = UITableViewCellAccessoryCheckmark;
	rownum = (int)indexPath.row;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    
    NSString *timeStr = [timeArray objectAtIndex:indexPath.row];
    [self.delegate saveTimeRound:[timeStr lowercaseString]];
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



@end

