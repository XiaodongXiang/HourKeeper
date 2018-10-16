//
//  DailyOverTime_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DailyOverTime_ipad.h"
#import "AppDelegate_Shared.h"



@interface DailyOverTime_ipad()
{
    int selectStly;         // 0   1;
}

@end



@implementation DailyOverTime_ipad

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.taskController = nil;
        self.isDaily = YES;
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
    
    [backButton addTarget:self action:@selector(doneAndBack) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    NSString *title;
    if (self.isDaily == YES)
    {
        title = @"Daily Overtime";
    }
    else
    {
        title = @"Weekly Overtime";
    }
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:title];
    
    [self initData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}




#pragma mark Action
-(void)initData
{
    if (self.taskController != nil)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (self.isDaily == YES)
        {
            self.afterField11.text = [appDelegate getMultipleNumber2:self.taskController.dayOverFirstTax isAllNumber:NO];
            self.afterField1.text = self.taskController.dayOverFirstHour;
            
            self.afterField22.text = [appDelegate getMultipleNumber2:self.taskController.dayOverSecondTax isAllNumber:NO];
            self.afterField2.text = self.taskController.dayOverSecondHour;
        }
        else
        {
            self.afterField11.text = [appDelegate getMultipleNumber2:self.taskController.weekOverFirstTax isAllNumber:NO];
            self.afterField1.text = self.taskController.weekOverFirstHour;
            
            self.afterField22.text = [appDelegate getMultipleNumber2:self.taskController.weekOverSecondTax isAllNumber:NO];
            self.afterField2.text = self.taskController.weekOverSecondHour;
        }
    }
    
    self.pickView.frame = CGRectMake(0, 456, self.view.frame.size.width, self.pickView.frame.size.height);
}



- (void) doneAndBack
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSString *dailyFirstTax = [appDelegate getMultipleNumber3:self.afterField11.text needX:YES];
    NSString *dailySecondTax = [appDelegate getMultipleNumber3:self.afterField22.text needX:YES];
    if ([self.afterField1.text isEqualToString:@""])
    {
        self.afterField1.text = @"0";
    }
    if ([self.afterField2.text isEqualToString:@""])
    {
        self.afterField2.text = @"0";
    }
	NSString *dailyFirstHour = self.afterField1.text;
	NSString *dailySecondHour = self.afterField2.text;
	NSMutableString *firstText = [[NSMutableString alloc] initWithString:dailyFirstTax];
	NSMutableString *secondText = [[NSMutableString alloc] initWithString:dailySecondTax];
    if (![dailyFirstTax isEqualToString:OVER_NONE])
    {
        [firstText appendString:@" after "];
        [firstText appendString:dailyFirstHour];
        [firstText appendString:@"h"];
        firstText = (NSMutableString *)[firstText lowercaseString];
    }
	if (![dailySecondTax isEqualToString:OVER_NONE])
    {
        [secondText appendString:@" after "];
        [secondText appendString:dailySecondHour];
        [secondText appendString:@"h"];
        secondText = (NSMutableString *)[secondText lowercaseString];
    }
    
    if (self.taskController != nil)
    {
        if (self.isDaily == YES)
        {
            self.taskController.dayOverFirstTax = dailyFirstTax;
            self.taskController.dayOverSecondTax= dailySecondTax;
            self.taskController.dayOverFirstHour = dailyFirstHour;
            self.taskController.dayOverSecondHour = dailySecondHour;
            if (![dailySecondTax isEqualToString:OVER_NONE])
            {
                self.taskController.dailyOvertimeLbel.hidden = YES;
                self.taskController.dailyOvertimeLbel1.hidden = NO;
                self.taskController.dailyOvertimeLbel2.hidden = NO;
                self.taskController.dailyOvertimeLbel1.text = firstText;
                self.taskController.dailyOvertimeLbel2.text = secondText;
            }
            else
            {
                self.taskController.dailyOvertimeLbel.hidden = NO;
                self.taskController.dailyOvertimeLbel1.hidden = YES;
                self.taskController.dailyOvertimeLbel2.hidden = YES;
                self.taskController.dailyOvertimeLbel.text = firstText;
            }
        }
        else
        {
            self.taskController.weekOverFirstTax = dailyFirstTax;
            self.taskController.weekOverSecondTax= dailySecondTax;
            self.taskController.weekOverFirstHour = dailyFirstHour;
            self.taskController.weekOverSecondHour = dailySecondHour;
            if (![dailySecondTax isEqualToString:OVER_NONE])
            {
                self.taskController.weeklyOvertimeLbel.hidden = YES;
                self.taskController.weeklyOvertimeLbel1.hidden = NO;
                self.taskController.weeklyOvertimeLbel2.hidden = NO;
                self.taskController.weeklyOvertimeLbel1.text = firstText;
                self.taskController.weeklyOvertimeLbel2.text = secondText;
            }
            else
            {
                self.taskController.weeklyOvertimeLbel.hidden = NO;
                self.taskController.weeklyOvertimeLbel1.hidden = YES;
                self.taskController.weeklyOvertimeLbel2.hidden = YES;
                self.taskController.weeklyOvertimeLbel.text = firstText;
            }
        }
    }
    
	[self.navigationController popViewControllerAnimated:YES];
}





#pragma mark -
#pragma mark Table view data source

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        v.backgroundColor = [UIColor clearColor];
        
        return v;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) 
    {
		if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.cell1 setBackgroundView:bv];
            
			return self.cell1;
		}
		else 
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.cell2 setBackgroundView:bv];
            
			return self.cell2;
		}
	}
    else 
    {
        if (indexPath.row == 0)
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_top_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.cell3 setBackgroundView:bv];
            
			return self.cell3;
		}
		else 
        {
            UIImage *image = [[UIImage imageNamed:@"cell1_bottom_44.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *bv = [[UIImageView alloc] initWithImage:image];
            [self.cell4 setBackgroundView:bv];
            
			return self.cell4;
		}
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.afterField1 resignFirstResponder];
        [self.afterField2 resignFirstResponder];
        [self.afterField11 resignFirstResponder];
        [self.afterField22 resignFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^
         {
             self.pickView.frame = CGRectMake(0, 456-self.pickView.frame.size.height, self.view.frame.size.width, self.pickView.frame.size.height);
         }
                         completion:^(BOOL finished)
         {
         }
         ];
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [Flurry logEvent:@"1_CLI_NEWOT1"];
        
        
        selectStly = 0;
        NSInteger index1;
        index1 = [appDelegate.m_overTimeArray indexOfObject:self.afterField11.text];
        if (index1 == NSNotFound)
        {
            index1 = 0;
            self.afterField11.text = [appDelegate.m_overTimeArray objectAtIndex:0];
        }
        [self.picker selectRow:(int)index1 inComponent:0 animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        [Flurry logEvent:@"1_CLI_NEWOT2"];
        
        
        selectStly = 1;
        NSInteger index2;
        index2 = [appDelegate.m_overTimeArray indexOfObject:self.afterField22.text];
        if (index2 == NSNotFound)
        {
            index2 = 0;
            self.afterField22.text = [appDelegate.m_overTimeArray objectAtIndex:0];
        }
        [self.picker selectRow:(int)index2 inComponent:0 animated:YES];
    }
    
}





- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.pickView.frame = CGRectMake(0, 456, self.view.frame.size.width, self.pickView.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
     }
     ];
    
    if (textField == self.afterField1 || textField == self.afterField2)
    {
        if ([textField.text isEqualToString:@"0"])
        {
            textField.text = @"";
        }
    }
    else
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        textField.text = [appDelegate getMultipleNumber2:textField.text isAllNumber:YES];
        textField.textColor = [appDelegate getOverTimeText_Color:textField.text];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.afterField1 || textField == self.afterField2)
    {
        if ([textField.text isEqualToString:@""])
        {
            textField.text = @"0";
        }
    }
    else
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        textField.text = [appDelegate getMultipleNumber3:textField.text needX:NO];
        textField.textColor = [appDelegate getOverTimeText_Color:textField.text];
    }
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
    else
    {
        if (textField == self.afterField1 || textField == self.afterField2)
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
                if (textField == self.afterField11)
                {
                    self.afterField11.text = newString;
                }
                else if (textField == self.afterField22)
                {
                    self.afterField22.text = newString;
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
                if (textField == self.afterField11)
                {
                    self.afterField11.text = newString1;
                }
                else if (textField == self.afterField22)
                {
                    self.afterField22.text = newString1;
                }
            }
            textField.textColor = [appDelegate getOverTimeText_Color:textField.text];
            
            return NO;
        }
    }
    
}


#pragma mark -
#pragma mark  PickerView Delegate

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    return appDelegate.m_overTimeArray.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.m_overTimeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSString *str = [appDelegate.m_overTimeArray objectAtIndex:row];
    if (selectStly == 0)
    {
        self.afterField11.text = str;
    }
    else if (selectStly == 1)
    {
        self.afterField22.text = str;
    }
}


@end
