//
//  PasscodeSettingViewController_iPd.m
//  HoursKeeper
//
//  Created by xy_dev on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PasscodeSettingViewController_iPd.h"
#import "PasscodeViewController_iPd2.h"
#import "PasscodeViewController_iPd3.h"
#import "AppDelegate_Shared.h"

@implementation PasscodeSettingViewController_iPd

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
    
    [backBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Passcode Setting"];
    
    
	[changeButton addTarget:self action:@selector(changePasscode) forControlEvents:UIControlEventTouchUpInside];
	[offButton addTarget:self action:@selector(turnOffPasscode) forControlEvents:UIControlEventTouchUpInside];
}



- (void)changePasscode
{
	PasscodeViewController_iPd3 *passcodeView = [[PasscodeViewController_iPd3 alloc] initWithNibName:@"PasscodeViewController_iPd3" bundle:nil];
    
	[self.navigationController pushViewController:passcodeView animated:YES];
}

- (void)turnOffPasscode
{
	PasscodeViewController_iPd2 *passcodeView = [[PasscodeViewController_iPd2 alloc] initWithNibName:@"PasscodeViewController_iPd2" bundle:nil];

	[self.navigationController pushViewController:passcodeView animated:YES];
}


-(void)quit
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}


@end
