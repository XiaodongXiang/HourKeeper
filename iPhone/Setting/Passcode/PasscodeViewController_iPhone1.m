//
//  PasscodeViewController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "PasscodeViewController_iPhone1.h"
#import "Settings.h"
#import "AppDelegate_Shared.h"

@implementation PasscodeViewController_iPhone1


@synthesize firstPass,myPass,ownField;
@synthesize firstviewController;
@synthesize imageV1,imageV2,imageV3,imageV4;
@synthesize navi_tittle;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];

    [appDelegate setNaviGationTittle:self with:150 high:44 tittle:self.navi_tittle];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    

    
	self.myPass = @"";
	ownField.text = @"";
	ownField.hidden = YES;
    [self showImageV:0];
    
}


- (void)enterChar
{
	NSString *text = ownField.text;
    
	[self showImageV:[text length]];
    
	if ([text length]==4)
    {
		self.myPass = text;                                
		if ([self.myPass isEqualToString:self.firstPass])
        {
			AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
			NSManagedObjectContext *context = [appDelegate managedObjectContext];
			appDelegate.appSetting.isPasscodeOn = [NSNumber numberWithBool:YES];
			appDelegate.appSetting.passcode = self.myPass;
			[context save:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
		}
        else
		{
			[[self.firstviewController tryLabel] setHidden:NO];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL ret = YES;
	if ([textField.text length]>=4)
    {
		if ([string isEqualToString:@""])
        {
			ret = YES;
		}
        else
		{
			ret = NO;
		}
	}
	return ret;
}






-(void)touchesDo:(UITapGestureRecognizer*)gestureRecognizer
{
    if (![ownField isFirstResponder])
    {
        [ownField becomeFirstResponder];
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[ownField becomeFirstResponder];
	ownField.delegate = self;
	ownField.keyboardType = UIKeyboardTypeNumberPad;
	[ownField addTarget:self action:@selector(enterChar) forControlEvents:UIControlEventEditingChanged];
    
	ownField.text = @"";
    [self showImageV:0];
    
    
    UITapGestureRecognizer* Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesDo:)];
    [self.view addGestureRecognizer:Tap];
    [Tap setCancelsTouchesInView:NO];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (UIGestureRecognizer *gesture in [self.view gestureRecognizers])
    {
        [self.view removeGestureRecognizer:gesture];
    }
    
    [ownField resignFirstResponder];
    ownField.text = @"";
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








-(void)showImageV:(NSInteger)stly
{
    if (stly == 0)
    {
        [self.imageV1 setHighlighted:NO];
        [self.imageV2 setHighlighted:NO];
        [self.imageV3 setHighlighted:NO];
        [self.imageV4 setHighlighted:NO];
    }
    else if (stly == 1)
    {
        [self.imageV1 setHighlighted:YES];
        [self.imageV2 setHighlighted:NO];
        [self.imageV3 setHighlighted:NO];
        [self.imageV4 setHighlighted:NO];
    }
    else if (stly == 2)
    {
        [self.imageV1 setHighlighted:YES];
        [self.imageV2 setHighlighted:YES];
        [self.imageV3 setHighlighted:NO];
        [self.imageV4 setHighlighted:NO];
    }
    else if (stly == 3)
    {
        [self.imageV1 setHighlighted:YES];
        [self.imageV2 setHighlighted:YES];
        [self.imageV3 setHighlighted:YES];
        [self.imageV4 setHighlighted:NO];
    }
    else
    {
        [self.imageV1 setHighlighted:YES];
        [self.imageV2 setHighlighted:YES];
        [self.imageV3 setHighlighted:YES];
        [self.imageV4 setHighlighted:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
//	self.imageV1;
//    self.imageV2;
//    self.imageV3;
//    self.imageV4;
    
    
}


@end
