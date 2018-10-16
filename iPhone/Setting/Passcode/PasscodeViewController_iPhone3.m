//
//  PasscodeViewController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "PasscodeViewController_iPhone3.h"
#import "Settings.h"
#import "AppDelegate_iPhone.h"
#import "PasscodeViewController_iPhone.h"


@implementation PasscodeViewController_iPhone3

@synthesize imageV1,imageV2,imageV3,imageV4;
@synthesize ownField;
@synthesize firstPass,myPass;
@synthesize tryLabel;
@synthesize naiv_tittle;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 56, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backBtn.titleLabel.font = appDelegate.naviFont;
//    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:100 high:44 tittle:self.naiv_tittle];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    
	[self showImageV:0];
	self.myPass = @"";
	tryLabel.hidden = YES;
	ownField.text = @"";
	ownField.hidden = YES;
}



-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)enterChar
{
	NSString *text = ownField.text;
    tryLabel.hidden = YES;
    
	[self showImageV:[text length]];
	
	if ([text length]==4)
    {
		self.myPass = text;
		AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		if ([self.myPass isEqualToString:appDelegate.appSetting.passcode])
        {
			PasscodeViewController_iPhone *passcodeViewController =  [[PasscodeViewController_iPhone alloc] init];
			passcodeViewController.navi_tittle = @"Set Passcode";
            
			[passcodeViewController setHidesBottomBarWhenPushed:YES];
			[self.navigationController pushViewController:passcodeViewController animated:YES];
		}
		else
        {
			[self showImageV:0];
			ownField.text = @"";
			tryLabel.hidden = NO;
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


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
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
