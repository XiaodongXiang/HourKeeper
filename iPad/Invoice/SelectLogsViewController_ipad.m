//
//  SelectLogsViewController_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectLogsViewController_ipad.h"

#import "Jobs_Cell_ipad.h"

#import "AppDelegate_Shared.h"
#import "Logs.h"




@implementation SelectLogsViewController_ipad

#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _logsList = [[NSMutableArray alloc] init];
        _mylogs = [[NSMutableArray alloc] init];
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
    
    [backButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Select Entries"];
    

    
    [self.logsList addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.selectClient.logs allObjects]]];

    for (int i=0; i<[self.logsList count]; i++)
    {
        Logs *sel_log = [self.logsList objectAtIndex:i];
        if ([sel_log.isInvoice boolValue] == YES || [sel_log.isPaid intValue] == 1)
        {
            [self.logsList removeObject:sel_log];
            i--;
        }
    }
    
    if (self.selectInvoice != nil && self.selectInvoice.client == self.selectClient)
    {
        [self.logsList addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.selectInvoice.logs allObjects]]];
    }
    
    NSSortDescriptor * sortDescript = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:NO];
    NSArray * sortArray = [[NSArray alloc] initWithObjects:sortDescript, nil];
    [self.logsList sortUsingDescriptors:sortArray];
    
    [self.tableView reloadData];
    
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




-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)saveBack
{
    [self.delegate saveLogsForClient:self.mylogs];
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
    return [self.logsList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"JobsCell_ipad-Identifier";
	Jobs_Cell_ipad *myjobcell = (Jobs_Cell_ipad*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
	if (myjobcell == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"Jobs_Cell_ipad" owner:self options:nil];
		
		for (id oneObject in nibs) 
		{
			if ([oneObject isKindOfClass:[Jobs_Cell_ipad class]]) 
			{
				myjobcell = (Jobs_Cell_ipad*)oneObject;
			}
		}
    }
    
    
    
    if (indexPath.row > 0)
    {
		Logs *sel_log = [self.logsList objectAtIndex:indexPath.row-1];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        myjobcell.alllabel.text = [dateFormatter stringFromDate:sel_log.starttime];
        
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

        myjobcell.workedLabel.text = [appDelegate conevrtTime:sel_log.worked];
        myjobcell.moneyLabel.text = [appDelegate appMoneyShowStly:sel_log.totalmoney];
        
        [myjobcell.moneyLabel setHidden:NO];
        [myjobcell.workedLabel setHidden:NO];
    }
    else
    {
        myjobcell.alllabel.text =  @"All Entries";
        
        [myjobcell.moneyLabel setHidden:YES];
        [myjobcell.workedLabel setHidden:YES];
    }
    
    
    
	if ([self.mylogs count] == [self.logsList count] )
    {
        myjobcell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
        myjobcell.accessoryView = accImageView;
	}
    else
    {
        myjobcell.accessoryView = nil;
        myjobcell.accessoryType = UITableViewCellAccessoryNone;
        
		if (indexPath.row != 0)
        {
		    if ([self.mylogs indexOfObject:[self.logsList objectAtIndex:indexPath.row-1]] != NSNotFound)
            {
                
                myjobcell.accessoryType = UITableViewCellAccessoryCheckmark;
				UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
                myjobcell.accessoryView = accImageView;
			}
            else
            {
                myjobcell.accessoryView = nil;
                myjobcell.accessoryType = UITableViewCellAccessoryNone;
            }
		}
	}
    

    
//    UIImage *bv = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
//    UIImageView *backV = [[UIImageView alloc] initWithImage:bv];
//    [myjobcell setBackgroundView:backV];
    
    
    return myjobcell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row>0)
    {
		Jobs_Cell_ipad *firstcell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
		if (firstcell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
			firstcell.accessoryView = nil;
            firstcell.accessoryType = UITableViewCellAccessoryNone;
		}
        
		Logs *log = [self.logsList objectAtIndex:indexPath.row-1];
		if ([self.mylogs indexOfObject:log] == NSNotFound)
        {
			[self.mylogs addObject:log];
			Jobs_Cell_ipad *cell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:indexPath];
            
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
            
		}
        else
        {
			[self.mylogs removeObject:log];
			Jobs_Cell_ipad *cell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:indexPath];
            
			cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    else
    {
		Jobs_Cell_ipad *cell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:indexPath];
        
		if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            for (int i=1; i<[self.mylogs count]+1; i++)
            {
                Jobs_Cell_ipad *mycell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                mycell.accessoryView = nil;
                mycell.accessoryType = UITableViewCellAccessoryNone;
            }
            
			[self.mylogs removeAllObjects];
			cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
		}
        else
        {
            [self.mylogs removeAllObjects];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
            
            
            [self.mylogs addObjectsFromArray:self.logsList];
            
            for (int i=1; i<[self.mylogs count]+1; i++)
            {
                Jobs_Cell_ipad *mycell = (Jobs_Cell_ipad*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                
                mycell.accessoryType = UITableViewCellAccessoryCheckmark;
                UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
                mycell.accessoryView = accImageView;
            }
        }
	}
}



@end
