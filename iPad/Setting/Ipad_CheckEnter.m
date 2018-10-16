//
//  Ipad_CheckEnter.m
//  HoursKeeper
//
//  Created by xy_dev on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ipad_CheckEnter.h"
#import "Settings.h"
#import "AppDelegate_iPad.h"


#define degreesToRadians(x) (M_PI  * (x) / 180.0)

@implementation Ipad_CheckEnter  

#pragma mark Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    #ifdef FULL
        [self.logoImageV setImage:[UIImage imageNamed:@"passcode_logo_296_74.png"]];
    #else
        [self.logoImageV setImage:[UIImage imageNamed:@"passcode_logo_296_74_L.png"]];
    #endif
    

	[self showImageV:0];
	self.myPass = @"";
	self.tryLabel.hidden = YES;
	self.ownField.text = @"";
	self.ownField.hidden = YES;
    
    self.ownField.delegate = self;
    self.ownField.keyboardType = UIKeyboardTypeNumberPad;
    [self.ownField addTarget:self action:@selector(enterChar) forControlEvents:UIControlEventEditingChanged];
    
    self.ownField.text = @"";
    [self showImageV:0];
    
    
    UITapGestureRecognizer* Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesDo:)];
    [self.view addGestureRecognizer:Tap];
    [Tap setCancelsTouchesInView:NO];
    [self setupforeTouchCheckViewContor];
}
-(void)setupforeTouchCheckViewContor
{
    AppDelegate_Shared *appdelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.appSetting.istouchid.intValue == TouchNotEn && [appdelegate canTouchId] == TouchYes)
    {
        appdelegate.foreTouchCheckViewContor = self;
        [self.ownField resignFirstResponder];
        [self.inputView setHidden:YES];
        if (appdelegate.isLock == NO)
        {
            appdelegate.isLock = YES;
            [appdelegate addTouchIdPassword_target:self];
        }
    }
    else
    {
        appdelegate.foreTouchCheckViewContor = self;
        [appdelegate setTouchIdPassword:NO];
        [self.ownField becomeFirstResponder];
    }
}


- (void)enterChar
{
	NSString *text = self.ownField.text;
	self.tryLabel.hidden = YES;
    
	[self showImageV:[text length]];
    
	if ([text length]==4)
    {
		self.myPass = text;
		AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
		if ([self.myPass isEqualToString:appDelegate.appSetting.passcode])
        {
            [self startAnimation];
		}
		else
        {
			[self showImageV:0];
			self.ownField.text = @"";
			self.tryLabel.hidden = NO;
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
    if (![self.ownField isFirstResponder])
    {
        [self.ownField becomeFirstResponder];
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (UIGestureRecognizer *gesture in [self.view gestureRecognizers])
    {
        [self.view removeGestureRecognizer:gesture];
    }
    
    [self.ownField resignFirstResponder];
    self.ownField.text = @"";
}




-(void)doBack_TouchIdAction:(NSNumber *)state
{    
    if (state.intValue == TouchYes)
    {
        float time = 0.3;
        float time1 = 0.1;
        [self performSelector:@selector(aa) withObject:nil afterDelay:time];
        time += time1;
        [self performSelector:@selector(bb) withObject:nil afterDelay:time];
        time += time1;
        [self performSelector:@selector(cc) withObject:nil afterDelay:time];
        time += time1;
        [self performSelector:@selector(dd) withObject:nil afterDelay:time];
        time += time1*3;
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:time];
    }
    else
    {
        [self.ownField becomeFirstResponder];
    }
}

-(void)aa
{
    [self showImageV:1];
}
-(void)bb
{
    [self showImageV:2];
}
-(void)cc
{
    [self showImageV:3];
}
-(void)dd
{
    [self showImageV:4];
}


-(void)startAnimation
{
    AppDelegate_iPad * appdelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    CGRect orgin = self.bv.frame;
    CGRect orgin2 = self.bv2.frame;
    
    [self.ownField resignFirstResponder];
    [UIView animateWithDuration:0.5
                     animations:^
     {
         self.bv.frame = CGRectMake(-320+orgin.origin.x, -orgin.size.width, orgin.size.width+320*2, orgin.size.width*3);
         self.bv2.frame = CGRectMake(-100+orgin2.origin.x, -orgin.size.width, orgin2.size.width+100*2, orgin.size.width*3);
         [self.bvImageV setAlpha:0];
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         
         self.bv.frame = orgin;
         self.bv2.frame = orgin2;
         [self.bvImageV setAlpha:1];
         [self showImageV:0];
         
         if (appdelegate.isWidgetAlert == YES)
         {
             [appdelegate doSetWidgetPurchaseAlert];
             appdelegate.isWidgetAlert = NO;
         }
         else if (appdelegate.isWidgetPrsent == YES)
         {
             [appdelegate enterWidgetDo];
             appdelegate.isWidgetPrsent = NO;
         }
         else
         {
             [appdelegate doRateApp];
         }
     }
     ];
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




-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return;
    }
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    { 
        self.view.transform = CGAffineTransformIdentity; 
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
        self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0); 

    } 
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) 
    { 
        self.view.transform = CGAffineTransformIdentity; 
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
        self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    }
    else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) 
    { 
        self.view.transform = CGAffineTransformIdentity; 
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180)); 
        self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0); 
    } 
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) 
    { 
        self.view.transform = CGAffineTransformIdentity; 
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90)); 
        self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}



@end
