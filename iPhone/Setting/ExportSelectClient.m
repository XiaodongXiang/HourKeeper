//
//  ExportSelectClient.m
//  HoursKeeper
//
//  Created by xy_dev on 5/15/13.
//
//

#import "ExportSelectClient.h"

#import "AppDelegate_Shared.h"
#import "Clients.h"



@implementation ExportSelectClient



@synthesize myTableView;

@synthesize clientList;
@synthesize myclients;
@synthesize isAll;

@synthesize delegate;







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        clientList = [[NSMutableArray alloc] init];
        myclients = [[NSMutableArray alloc] init];
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
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Export Client"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)initClientData:(NSMutableArray *)_clientArray SelectStly:(BOOL)_isAll;
{
	AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [self.clientList addObjectsFromArray:[appDelegate getAllClient]];
    
    self.isAll = _isAll;
    if (_isAll == NO)
    {
        [self.myclients addObjectsFromArray:_clientArray];
    }
    else
    {
        [self.myclients addObjectsFromArray:self.clientList];
    }
    
    [self.myTableView reloadData];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveBack
{
    if ([self.myclients count] == [self.clientList count])
    {
        self.isAll = YES;
    }
    
    [self.delegate saveExportClient:self.myclients SelectStly:self.isAll];
    
    [self back];
}







#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.clientList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *myClient_cell = [tableView cellForRowAtIndexPath:indexPath];
    if (myClient_cell == nil)
    {
        myClient_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    [myClient_cell.textLabel setTextColor:[UIColor colorWithRed:61.0/255.0 green:63.0/255.0 blue:64.0/255.0 alpha:1]];
    [myClient_cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    
    
    
    myClient_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        myClient_cell.textLabel.text = @"All";
        
        if (self.isAll == YES)
        {
            myClient_cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            myClient_cell.accessoryView = accImageView;
        }
        else
        {
            
            myClient_cell.accessoryView = nil;
            myClient_cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        Clients *client = [self.clientList objectAtIndex:indexPath.row-1];
        myClient_cell.textLabel.text = client.clientName;
        
        if (self.isAll == NO)
        {
            if ([self.myclients indexOfObject:client] == NSNotFound)
            {
                
                myClient_cell.accessoryView = nil;
                myClient_cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                
                myClient_cell.accessoryType = UITableViewCellAccessoryCheckmark;
                UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
                myClient_cell.accessoryView = accImageView;
            }
        }
        else
        {
            
            myClient_cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            myClient_cell.accessoryView = accImageView;
        }
    }

    
    myClient_cell.backgroundColor = [UIColor whiteColor];

    return myClient_cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
    {
		UITableViewCell *firstcell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        self.isAll = NO;
		if (firstcell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            firstcell.accessoryView = nil;
			firstcell.accessoryType = UITableViewCellAccessoryNone;
		}
        
		Clients *client = [self.clientList objectAtIndex:indexPath.row-1];
		if ([self.myclients indexOfObject:client] == NSNotFound)
        {
			[self.myclients addObject:client];
			UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
		}
        else
        {
			[self.myclients removeObject:client];
			UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            
            cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else
    {
		UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            self.isAll = NO;
            cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryNone;
            
            for (int i=1; i<[self.myclients count]+1; i++)
            {
                UITableViewCell *mycell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                mycell.accessoryView = nil;
                mycell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            [self.myclients removeAllObjects];
		}
        else
        {
            self.isAll = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
            cell.accessoryView = accImageView;
            
            [self.myclients removeAllObjects];
            
            [self.myclients addObjectsFromArray:self.clientList];
            
            for (int i=1; i<[self.myclients count]+1; i++)
            {
                UITableViewCell *mycell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                mycell.accessoryType = UITableViewCellAccessoryCheckmark;
                UIImageView *accImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_16_14.png"]];
                mycell.accessoryView = accImageView;
            }
        }
	}

}










@end
