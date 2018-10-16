//
//  OtherChangeController.m
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-22.
//
//

#import "OtherChangeController.h"
#import "AppDelegate_Shared.h"
#import "EditInvoiceNewViewController.h"
#import "EditInvoiceNewViewController_ipad.h"

@implementation OtherChangeController

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myInvoiceProperty = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //cancel btn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = appDelegate.naviFont;
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    //save btn
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.titleLabel.font = appDelegate.naviFont2;
    saveButton.frame = CGRectMake(0, 0, 48, 30);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    
    [appDelegate setNaviGationTittle:self with:150 high:44 tittle:@"Other Charges"];

    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    
    [self initData];
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

#pragma mark  Method
-(void)initData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (self.myInvoiceProperty != nil)
    {
        self.nameField.text = self.myInvoiceProperty.name;
        self.quantityField.text = [NSString stringWithFormat:@"%d",self.myInvoiceProperty.quantity.intValue];
        
        self.priceStr = [appDelegate appMoneyShowStly2:self.myInvoiceProperty.price];
        self.priceField.text = [appDelegate appMoneyShowStly:self.myInvoiceProperty.price];
        
        self.taxSwitch.on = self.myInvoiceProperty.tax.boolValue;
    }
    else
    {
        self.nameField.text = @"";
        self.quantityField.text = @"";
        self.priceStr = ZERO_NUM;
        self.priceField.text = [NSString stringWithFormat:@"%@%@",appDelegate.currencyStr,self.priceStr];
        self.taxSwitch.on = YES;
    }
    
    [self.myTableView reloadData];
    
    if(IS_IPHONE_6PLUS)
    {
        self.namelabel1.left = 20;
        self.qualitylabel1.left = 20;
        self.pricelabel1.left = 20;
        self.taxlabel1.left = 20;
        
        self.nameField.left = self.nameField.left - 5;
        self.quantityField.left = self.quantityField.left - 5;
        self.priceField.left = self.priceField.left - 5;
        self.taxSwitch.left = self.taxSwitch.left - 5;
    }
}

-(void)save
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (self.nameField.text == nil || [self.nameField.text isEqualToString:@""] || self.quantityField.text == nil || [self.quantityField.text isEqualToString:@""] || [self.priceStr isEqualToString:ZERO_NUM])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"'Name','Quantity' and 'Price' are needed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        appDelegate.close_PopView = alertView;
        
        return;
    }

    if (self.myInvoiceProperty == nil)
    {
        if (self.taxSwitch.on == NO)
        {
            [Flurry logEvent:@"3_INV_ADDCHARTAX"];
        }
        
        self.myInvoiceProperty = [[HMJInviocePropertyObject alloc]init];
        self.myInvoiceProperty.uuid = [appDelegate getUuid];
    }
    else
    {
        if (self.taxSwitch.on != self.myInvoiceProperty.tax.boolValue)
        {
            [Flurry logEvent:@"3_INV_ADDCHARTAX"];
        }
    }
    
    self.myInvoiceProperty.name = self.nameField.text;
    self.myInvoiceProperty.quantity = [NSNumber numberWithInt:self.quantityField.text.intValue];
    
    NSString *amountString = [appDelegate.nomalClass changeStringtoDoubleString:self.priceStr];
    self.myInvoiceProperty.price = amountString;
    self.myInvoiceProperty.tax = [NSNumber numberWithBool:self.taxSwitch.on];
    
    if (ISPAD)
    {
        if(![self.editInvoiceVC_iPad.propertyMutableArray containsObject:self.myInvoiceProperty])
        {
            [self.editInvoiceVC_iPad.propertyMutableArray addObject:self.myInvoiceProperty];
        }
        [self.editInvoiceVC_iPad saveOtherChange];

    }
    else
    {
        if(![self.editInvocieVC.propertyMutableArray containsObject:self.myInvoiceProperty])
        {
            [self.editInvocieVC.propertyMutableArray addObject:self.myInvoiceProperty];
        }
        [self.editInvocieVC saveOtherChange];
    }
    
    
    [self back];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark  TextField Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceField)
    {
        self.priceField.text = self.priceStr;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.priceField)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
        self.priceField.text = [appDelegate appMoneyShowStly:self.priceStr];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.quantityField || textField == self.priceField)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Tip"message:@"Please input number！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            appDelegate.close_PopView = alert;
            
            return NO;
        }
        
        if (textField == self.quantityField)
        {
            return YES;
        }
        else
        {
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
                self.priceStr = newString;
                
                return NO;
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
                self.priceStr = newString1;
                
                return NO;
            }
            else
            {
                return NO;
            }
        }
    }
    else
    {
        return YES;
    }
}



#pragma mark -
#pragma mark  TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 35;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myInvoiceProperty == nil)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else
    {
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return self.nameCell;
        }
        else if (indexPath.row == 1)
        {
            return self.quantityCell;
        }
        else if (indexPath.row == 2)
        {
            return self.priceCell;
        }
        else
        {
            return self.taxCell;
        }
    }
    else
    {
        return self.deleteCell;
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.nameField becomeFirstResponder];
        }
        else if (indexPath.row == 1)
        {
            [self.quantityField becomeFirstResponder];
        }
        else if (indexPath.row == 2)
        {
            [self.priceField becomeFirstResponder];
        }
    }
    else
    {
        //删除
        if (self.myInvoiceProperty != nil)
        {
            if (ISPAD)
            {
                if ([self.editInvoiceVC_iPad.propertyMutableArray containsObject:self.myInvoiceProperty])
                {
                    [self.editInvoiceVC_iPad.propertyMutableArray removeObject:self.myInvoiceProperty];
                }
                [self.editInvoiceVC_iPad  saveOtherChange];
                
                
            }
            else
            {
                if ([self.editInvocieVC.propertyMutableArray containsObject:self.myInvoiceProperty])
                {
                    [self.editInvocieVC.propertyMutableArray removeObject:self.myInvoiceProperty];
                }
                [self.editInvocieVC saveOtherChange];
            }
            [self back];
        }
    }
}



@end
