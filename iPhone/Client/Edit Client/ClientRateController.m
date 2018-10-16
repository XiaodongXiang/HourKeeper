//
//  ClientRateController.m
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-26.
//
//

#import "ClientRateController.h"
#import "AppDelegate_Shared.h"



@interface ClientRateController ()
{
    float keyHigh;
}
@end


@implementation ClientRateController


@synthesize myTableView;
@synthesize regularCell;
@synthesize regularField;
@synthesize regularStr;
@synthesize dailyCell;
@synthesize dailySwitch;
@synthesize isDaily;
@synthesize monCell;
@synthesize monField;
@synthesize monStr;
@synthesize tueCell;
@synthesize tueField;
@synthesize tueStr;
@synthesize wedCell;
@synthesize wedField;
@synthesize wedStr;
@synthesize thuCell;
@synthesize thuField;
@synthesize thuStr;
@synthesize friCell;
@synthesize friField;
@synthesize friStr;
@synthesize satCell;
@synthesize satField;
@synthesize satStr;
@synthesize sunCell;
@synthesize sunField;
@synthesize sunStr;
@synthesize weeklyCell;
@synthesize weeklyField;
@synthesize weekStr;
@synthesize weekHeadView;



#pragma mark Life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            keyHigh = 286;
        }
        else
        {
            keyHigh = 220;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 56, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:@"Rate"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    

    [self setSubViewFrame];
    [self initData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.delegate saveClientRate:self.isDaily regular:self.regularStr mon:self.monStr tue:self.tueStr wed:self.wedStr thu:self.thuStr fri:self.friStr sat:self.satStr sun:self.sunStr week:self.weekStr];
}

#pragma mark Action
-(void)setSubViewFrame
{
    if (IS_IPHONE_6PLUS)
    {
        float left = 20;
        self.regularRateLabel1.left = left;
        self.dailyRateLabel1.left = left;
        self.mondayLabel1.left = left;
        self.tuesdayLabel1.left = left;
        self.wednesdayLabel1.left = left;
        self.thursdayLabel1.left = left;
        self.fridayLabel1.left = left;
        self.saturdayLabel1.left = left;
        self.sundayLabel1.left = left;
        self.weekLabel1.left = left;
        self.headTextLabel1.left = left;
        
        self.regularField.left = self.regularField.left - 5;
        self.dailySwitch.left = self.dailySwitch.left - 5;
        self.monField.left = self.monField.left - 5;
        self.tueField.left = self.tueField.left - 5;
        self.wedField.left = self.wedField.left - 5;
        self.thuField.left = self.thuField.left - 5;
        self.friField.left = self.friField.left - 5;
        self.satField.left = self.satField.left - 5;
        self.sunField.left = self.sunField.left - 5;
        
        self.weeklyField.left = self.wedField.left - 5;
    }
}

-(void)initData
{
    [self.regularField resignFirstResponder];
    [self.monField resignFirstResponder];
    [self.tueField resignFirstResponder];
    [self.wedField resignFirstResponder];
    [self.thuField resignFirstResponder];
    [self.friField resignFirstResponder];
    [self.satField resignFirstResponder];
    [self.sunField resignFirstResponder];
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    self.regularField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.regularStr];
    self.dailySwitch.on = self.isDaily;
    self.monField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.monStr];
    self.tueField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.tueStr];
    self.wedField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.wedStr];
    self.thuField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.thuStr];
    self.friField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.friStr];
    self.satField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.satStr];
    self.sunField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.sunStr];
    self.weeklyField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.weekStr];
    
    UIColor *useColor = [HMJNomalClass creatAmountColor];
    UIColor *nouseColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1];
    if (self.isDaily == YES)
    {
        [self.regularField setUserInteractionEnabled:NO];
        self.regularField.textColor = nouseColor;
        
        [self.monField setUserInteractionEnabled:YES];
        self.monField.textColor = useColor;
        [self.tueField setUserInteractionEnabled:YES];
        self.tueField.textColor = useColor;
        [self.wedField setUserInteractionEnabled:YES];
        self.wedField.textColor = useColor;
        [self.thuField setUserInteractionEnabled:YES];
        self.thuField.textColor = useColor;
        [self.friField setUserInteractionEnabled:YES];
        self.friField.textColor = useColor;
        [self.satField setUserInteractionEnabled:YES];
        self.satField.textColor = useColor;
        [self.sunField setUserInteractionEnabled:YES];
        self.sunField.textColor = useColor;
        
    }
    else
    {
        [self.regularField setUserInteractionEnabled:YES];
        self.regularField.textColor = useColor;
        
        [self.monField setUserInteractionEnabled:NO];
        self.monField.textColor = nouseColor;
        [self.tueField setUserInteractionEnabled:NO];
        self.tueField.textColor = nouseColor;
        [self.wedField setUserInteractionEnabled:NO];
        self.wedField.textColor = nouseColor;
        [self.thuField setUserInteractionEnabled:NO];
        self.thuField.textColor = nouseColor;
        [self.friField setUserInteractionEnabled:NO];
        self.friField.textColor = nouseColor;
        [self.satField setUserInteractionEnabled:NO];
        self.satField.textColor = nouseColor;
        [self.sunField setUserInteractionEnabled:NO];
        self.sunField.textColor = nouseColor;
    }
    
    self.weeklyField.textColor = useColor;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doSwitch:(UISwitch *)sender
{
    [Flurry logEvent:@"1_CLI_NEWDAILY"];
    
    self.isDaily = sender.on;
    [self initData];
}



- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UIEdgeInsets size = {0,0,keyHigh,0};
    [self.myTableView setContentInset:size];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
    
    NSIndexPath *sel_indexPath;
    if (textField == self.regularField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        textField.text = self.regularStr;
    }
    else if (textField == self.monField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        textField.text = self.monStr;
    }
    else if (textField == self.tueField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        textField.text = self.tueStr;
    }
    else if (textField == self.wedField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        textField.text = self.wedStr;
    }
    else if (textField == self.thuField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
        textField.text = self.thuStr;
    }
    else if (textField == self.friField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
        textField.text = self.friStr;
    }
    else if (textField == self.satField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:6 inSection:1];
        textField.text = self.satStr;
    }
    else if (textField == self.sunField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:7 inSection:1];
        textField.text = self.sunStr;
    }
    else if (textField == self.weeklyField)
    {
        sel_indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        textField.text = self.weekStr;
    }
    
    [self.myTableView selectRowAtIndexPath:sel_indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.myTableView deselectRowAtIndexPath:sel_indexPath animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    UIEdgeInsets size = {0,0,0,0};
    [self.myTableView setContentInset:size];
    
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSString *showMoney;
    if (textField == self.regularField)
    {
        showMoney = self.regularStr;
    }
    else if (textField == self.monField)
    {
        showMoney = self.monStr;
    }
    else if (textField == self.tueField)
    {
        showMoney = self.tueStr;
    }
    else if (textField == self.wedField)
    {
        showMoney = self.wedStr;
    }
    else if (textField == self.thuField)
    {
        showMoney = self.thuStr;
    }
    else if (textField == self.friField)
    {
        showMoney = self.friStr;
    }
    else if (textField == self.satField)
    {
        showMoney = self.satStr;
    }
    else if (textField == self.sunField)
    {
        showMoney = self.sunStr;
    }
    else if (textField == self.weeklyField)
    {
        showMoney = self.weekStr;
    }
    textField.text = [appDelegate appMoneyShowStly:showMoney];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Tip"message:@"Please input number！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        appDelegate.close_PopView = alert;
        
        return NO;
    }
    
    if (range.location == [textField.text length])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i<[textField.text length]; i++)
        {
            NSString *myStr = [textField.text substringWithRange:NSMakeRange(i, 1)];
            if (![myStr isEqualToString:@"."])
            {
                [array addObject:[textField.text substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        
        if ([[array objectAtIndex:0] isEqualToString:@"0"])
        {
            [array addObject:string];
            [array removeObjectAtIndex:0];
            [array insertObject:@"." atIndex:[array count]-2];
        }
        else
        {
            [array addObject:string];
            [array insertObject:@"." atIndex:[array count]-2];
        }
        
        NSMutableString *newString = [[NSMutableString alloc] init];
        for (int j=0; j<[array count]; j++)
        {
            [newString appendString:[array objectAtIndex:j]];
        }
        
        textField.text = newString;
        if (textField == self.regularField)
        {
            self.regularStr = newString;
        }
        else if (textField == self.monField)
        {
            self.monStr = newString;
        }
        else if (textField == self.tueField)
        {
            self.tueStr = newString;
        }
        else if (textField == self.wedField)
        {
            self.wedStr = newString;
        }
        else if (textField == self.thuField)
        {
            self.thuStr = newString;
        }
        else if (textField == self.friField)
        {
            self.friStr = newString;
        }
        else if (textField == self.satField)
        {
            self.satStr = newString;
        }
        else if (textField == self.sunField)
        {
            self.sunStr = newString;
        }
        else if (textField == self.weeklyField)
        {
            self.weekStr = newString;
        }
    }
    else if (range.location == [textField.text length]-1 && [string isEqualToString:@""])
    {
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (int k = 0; k<[textField.text length]; k++)
        {
            NSString *myStr1 = [textField.text substringWithRange:NSMakeRange(k, 1)];
            if (![myStr1 isEqualToString:@"."])
            {
                [array1 addObject:[textField.text substringWithRange:NSMakeRange(k, 1)]];
            }
        }
        if ([array1 count]>3)
        {
            [array1 removeLastObject];
            [array1 insertObject:@"." atIndex:[array1 count]-2];
        }
        else
        {
            [array1 removeLastObject];
            [array1 insertObject:@"0" atIndex:0];
            [array1 insertObject:@"." atIndex:[array1 count]-2];
        }
        NSMutableString *newString1 = [[NSMutableString alloc] init];
        for (int m=0; m<[array1 count]; m++)
        {
            [newString1 appendString:[array1 objectAtIndex:m]];
        }
        
        textField.text = newString1;
        if (textField == self.regularField)
        {
            self.regularStr = newString1;
        }
        else if (textField == self.monField)
        {
            self.monStr = newString1;
        }
        else if (textField == self.tueField)
        {
            self.tueStr = newString1;
        }
        else if (textField == self.wedField)
        {
            self.wedStr = newString1;
        }
        else if (textField == self.thuField)
        {
            self.thuStr = newString1;
        }
        else if (textField == self.friField)
        {
            self.friStr = newString1;
        }
        else if (textField == self.satField)
        {
            self.satStr = newString1;
        }
        else if (textField == self.sunField)
        {
            self.sunStr = newString1;
        }
        else if (textField == self.weeklyField)
        {
            self.weekStr = newString1;
        }
    }

    if (textField != self.weeklyField)
    {
        if (textField == self.regularField)
        {
            self.weekStr = self.regularStr;
        }
        else
        {
            self.weekStr = [appDelegate appMoneyShowStly4:(self.monStr.doubleValue+self.tueStr.doubleValue+self.wedStr.doubleValue+self.thuStr.doubleValue+self.friStr.doubleValue+self.satStr.doubleValue+self.sunStr.doubleValue)/7];
        }
        self.weeklyField.text = [appDelegate appMoneyShowStly:self.weekStr];
    }
    
    
    return NO;
}






#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return self.weekHeadView.frame.size.height;
    }
    else
        return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 35;
    }
    else
        return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else if (section == 2)
    {
        return self.weekHeadView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
    {
        return 1;
    }
    else
    {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.regularCell;
    }
    else if (indexPath.section == 2)
    {
        return self.weeklyCell;
    }
    else
    {
        if(indexPath.row == 0)
        {
            return self.dailyCell;
        }
        else if(indexPath.row == 1)
        {
            return self.monCell;
        }
        else if(indexPath.row == 2)
        {
            return self.tueCell;
        }
        else if(indexPath.row == 3)
        {
            return self.wedCell;
        }
        else if(indexPath.row == 4)
        {
            return self.thuCell;
        }
        else if(indexPath.row == 5)
        {
            return self.friCell;
        }
        else if(indexPath.row == 6)
        {
            return self.satCell;
        }
        else
        {
            return self.sunCell;
        }
    }
}



@end

