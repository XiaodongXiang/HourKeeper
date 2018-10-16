//
//  TimeViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeViewController_ipad.h"
#import "AppDelegate_Shared.h"


@interface TimeViewController_ipad()
{

#pragma mark Init
	int rownum;
}
@end

@implementation TimeViewController_ipad


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
//    backButton.titleLabel.font = appDelegate.naviFont;
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Time Round"];

    
    
	self.timeArray = [[NSMutableArray alloc] initWithObjects:
                 @"1 minute up",@"1 minute down",
				 @"5 minutes up",@"5 minutes down",
				 @"10 minutes up",@"10 minutes down",
				 @"15 minutes up",@"15 minutes down",
				 @"30 minutes up",@"30 minutes down",
				 @"1 hour up",@"1 hour down",
				 nil];
	
	rownum = (int)[self.timeArray indexOfObject:self.selectRowName];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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




#pragma mark Action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	int sections = 1;
    return sections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.timeArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString *timeStr = [self.timeArray objectAtIndex:indexPath.row];
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
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
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
	
    
    NSString *timeStr = [self.timeArray objectAtIndex:indexPath.row];
    [self.delegate saveTimeRound:[timeStr lowercaseString]];

	[self.navigationController popViewControllerAnimated:YES];
    
}

@end
