//
//  SelectClientViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectClientViewController_ipad.h"
#import "AppDelegate_iPad.h"
#import "Invoice.h"
#import "NewClientViewController_ipad.h"




@implementation SelectClientViewController_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _clientList = [[NSMutableArray alloc] init];
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
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Select Client"];
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



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initSelectClientView];
}


-(void)initSelectClientView
{
    [self.clientList removeAllObjects];
	AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSArray *requests = [appDelegate getAllClient];
	for (int i=0; i<[requests count]; i++) 
    {
		Clients *client = [requests objectAtIndex:i];
		[self.clientList addObject:client];
	}
    
    [self.tableView reloadData];
}



-(void)back
{
    [self.delegate saveSelectClient:nil];
    [self.navigationController popViewControllerAnimated:YES];
}






#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.clientList count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:61/255.0 green:63/255.0 blue:64/255.0 alpha:1]];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    
    Clients *client = [self.clientList objectAtIndex:indexPath.row];
    cell.textLabel.text = client.clientName;
    
    
    if ([self.clientList indexOfObject:self.selectClient] != NSNotFound)
    {
        if (indexPath.row == [self.clientList indexOfObject:self.selectClient])
        {
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
        }
        else
        {
            cell.accessoryView = nil;
        }
    }
    
    
//    UIImage *bv = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
//    UIImageView *backImage = [[UIImageView alloc] initWithImage:bv];
//    [cell setBackgroundView:backImage];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectClient = [self.clientList objectAtIndex:indexPath.row];
    [self.delegate saveSelectClient:self.selectClient];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}





@end
