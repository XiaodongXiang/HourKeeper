//
//  PasscodeSettingViewController_iPhone.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-30.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "PasscodeSettingViewController_iPhone.h"
#import "PasscodeViewController_iPhone2.h"
#import "PasscodeViewController_iPhone3.h"
#import "AppDelegate_Shared.h"

@implementation PasscodeSettingViewController_iPhone


@synthesize offButton;
@synthesize changeButton;



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
    
    [appDelegate setNaviGationTittle:self with:150 high:44 tittle:@"Passcode Setting"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
	[changeButton addTarget:self action:@selector(changePasscode) forControlEvents:UIControlEventTouchUpInside];
	[offButton addTarget:self action:@selector(turnOffPasscode) forControlEvents:UIControlEventTouchUpInside];
    
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








- (void)changePasscode
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	PasscodeViewController_iPhone3 *passcodeView = [[PasscodeViewController_iPhone3 alloc] initWithNibName:@"PasscodeViewController_iPhone3" bundle:nil];
    passcodeView.naiv_tittle = @"Old Passcode";
    
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
    
    passcodeView.navigationItem.rightBarButtonItems = @[flexible,cancleBtnItem];
    
    

	[self.navigationController pushViewController:passcodeView animated:YES];
}
- (void)turnOffPasscode
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	PasscodeViewController_iPhone2 *passcodeView = [[PasscodeViewController_iPhone2 alloc] initWithNibName:@"PasscodeViewController_iPhone2" bundle:nil];
    passcodeView.navi_tittle = @"Turn Off Passcode";
    
	[passcodeView.navigationItem setHidesBackButton:YES animated:YES];
    
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
    
    passcodeView.navigationItem.rightBarButtonItems = @[flexible,cancleBtnItem];
    
    
    
	[self.navigationController pushViewController:passcodeView animated:YES];
}

- (void)cancel
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


@end
