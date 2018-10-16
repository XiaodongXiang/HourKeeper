//
//  PasscodeViewController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "PasscodeViewController_iPhone.h"
#import "PasscodeViewController_iPhone1.h"
#import "AppDelegate_Shared.h"


@implementation PasscodeViewController_iPhone

@synthesize ownField;
@synthesize tryLabel;
@synthesize navi_tittle;
@synthesize imageV1,imageV2,imageV3,imageV4;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backBtn.titleLabel.font = appDelegate.naviFont;
//    [backBtn setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:120 high:44 tittle:self.navi_tittle];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    
    
    ownField.text = @"";
	ownField.delegate = self;
	ownField.keyboardType = UIKeyboardTypeNumberPad;
	[ownField addTarget:self action:@selector(enterChar) forControlEvents:UIControlEventEditingChanged];
	tryLabel.hidden = YES;
	ownField.hidden = YES;
    
    [self showImageV:0];
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








-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)enterChar
{
	NSString *text = ownField.text;
	tryLabel.hidden = YES;
    
    [self showImageV:[text length]];
    
	if ([text length] == 4)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        
		PasscodeViewController_iPhone1 *passcodeViewController1 = [[PasscodeViewController_iPhone1 alloc] init];
		passcodeViewController1.navi_tittle = @"Re-enter Passcode";
        
        [passcodeViewController1.navigationItem setHidesBackButton:YES animated:YES];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.titleLabel.font = appDelegate.naviFont;
        [cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithRed:117.0/255 green:175.0/255 blue:229.0/255 alpha:1] forState:UIControlStateHighlighted];
        [cancleBtn setFrame:CGRectMake(0, 0, 60.0, 30.0)];
        [cancleBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * cancleBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexible.width = -8.f;
        
        passcodeViewController1.navigationItem.rightBarButtonItems = @[flexible,cancleBtnItem];
        

        
        passcodeViewController1.firstPass = text;
		passcodeViewController1.firstviewController = self;
		[self.navigationController pushViewController:passcodeViewController1 animated:YES];
	}
}

- (void)cancel
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
//    self.imageV1;
//    self.imageV2;
//    self.imageV3;
//    self.imageV4;

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



@end
