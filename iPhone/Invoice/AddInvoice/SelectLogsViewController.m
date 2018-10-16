//
//  SelectLogsViewController.m
//  HoursKeeper
//
//  Created by xy_dev on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectLogsViewController.h"
#import "EditInvoiceNewViewController.h"
#import "AppDelegate_iPhone.h"
#import "Jobs_Cell.h"
#import "Logs.h"



@implementation SelectLogsViewController
@synthesize tableView;
@synthesize selectInvoice,selectClient,logsList,mylogs;
@synthesize delegate,isLogFirst;


#pragma mark
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        logsList = [[NSMutableArray alloc] init];
        mylogs = [[NSMutableArray alloc] init];
        isLogFirst = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if (self.isLogFirst == YES)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.titleLabel.font = appDelegate.naviFont;
        backButton.frame = CGRectMake(0, 0, 60, 30);
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.titleLabel.font = appDelegate.naviFont;
        saveButton.frame = CGRectMake(0, 0, 48, 30);
        [saveButton setTitle:@"Next" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    }
    else
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 56, 30);
        [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//        backButton.titleLabel.font = appDelegate.naviFont;
//        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(saveBack) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    }
    
    [appDelegate setNaviGationTittle:self with:150 high:44 tittle:@"Select Entries"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    //当前选中的client下 存在的log数组
    [self.logsList addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[self.selectClient.logs allObjects]]];
    
    
    for (int i=0; i<[self.logsList count]; i++)
    {
        Logs *sel_log = [self.logsList objectAtIndex:i];
        //如果这个log 已经支付过了，或者该log不是invoice就移除
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
//    self.tableView;
//    self.logsList;
//    self.mylogs;
    
}



#pragma mark Btn Action
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)saveBack
{
    //从 client info页面进来的
    if (self.isLogFirst == YES)
    {
        EditInvoiceNewViewController *controller =  [[EditInvoiceNewViewController alloc] initWithNibName:@"EditInvoiceNewViewController" bundle:nil];

        controller.navi_tittle = @"New Invoice";
        controller.myinvoce = nil;
        
        controller.selectClient = self.selectClient;
        [controller.jobsList addObjectsFromArray:self.mylogs];
        
        [self.navigationController pushViewController:controller animated:YES];

    }
    else
    {
        [self.delegate saveLogsForClient:self.mylogs];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    NSString* identifier = @"JobsCell-Identifier";
	Jobs_Cell *myjobcell = (Jobs_Cell*)[self.tableView dequeueReusableCellWithIdentifier:identifier];
	if (myjobcell == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"Jobs_Cell" owner:self options:nil];
		
		for (id oneObject in nibs)
		{
			if ([oneObject isKindOfClass:[Jobs_Cell class]])
			{
				myjobcell = (Jobs_Cell*)oneObject;
			}
		}
    }
    
	if (indexPath.row > 0)
    {
		Logs *sel_log = [self.logsList objectAtIndex:indexPath.row-1];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMdyyyy" options:0 locale:[NSLocale currentLocale]]];
        myjobcell.dateLbel.text = [dateFormatter stringFromDate:sel_log.starttime];
        
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
        myjobcell.totalTimerLbel.text = [appDelegate conevrtTime:sel_log.worked];
        myjobcell.totalMoneyLbel.text = [appDelegate appMoneyShowStly:sel_log.totalmoney];
        
        [myjobcell.totalMoneyLbel setHidden:NO];
        [myjobcell.totalTimerLbel setHidden:NO];
    }
    else
    {
        myjobcell.dateLbel.text =  @"All Entries";
        
        [myjobcell.totalMoneyLbel setHidden:YES];
        [myjobcell.totalTimerLbel setHidden:YES];
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
    
    if(IS_IPHONE_6PLUS)
    {
        myjobcell.dateLbel.left = 20;
    }
    myjobcell.totalTimerLbel.textColor = [HMJNomalClass creatAmountColor];
    
//    UIImageView *backV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell1_bottom_44.png"]];
//    [myjobcell setBackgroundView:backV];
    
    
    return myjobcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不是第一个，将第一个cell的选中状态关闭
    if (indexPath.row>0)
    {
        Jobs_Cell *firstcell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (firstcell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            firstcell.accessoryView = nil;
            firstcell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        Logs *log = [self.logsList objectAtIndex:indexPath.row-1];
        //如果在mylog中没有这个选中的log说明需要加上这个log,设置为选中状态
        if ([self.mylogs indexOfObject:log] == NSNotFound)
        {
            [self.mylogs addObject:log];
            Jobs_Cell *cell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
        }
        else
        {
            [self.mylogs removeObject:log];
            Jobs_Cell *cell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    //点击了第一个，选择全部的log,或者取消选择全部的log
    else
    {
        Jobs_Cell *cell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            for (int i=1; i<[self.mylogs count]+1; i++)
            {
                Jobs_Cell *mycell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
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
                Jobs_Cell *mycell = (Jobs_Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                
                mycell.accessoryType = UITableViewCellAccessoryCheckmark;
                UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
                mycell.accessoryView = accImageView;
            }
        }
    }
    
}








@end
