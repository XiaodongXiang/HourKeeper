//
//  PasscodeViewController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import "CheckPasscodeViewController_iPhone.h"
#import "Settings.h"
#import "AppDelegate_iPhone.h"



@implementation CheckPasscodeViewController_iPhone  


@synthesize logoImageV;
@synthesize imageV1,imageV2,imageV3,imageV4;
@synthesize ownField;
@synthesize firstPass,myPass;
@synthesize tryLabel;
@synthesize bv;
@synthesize bv2;
@synthesize m_bv;
@synthesize bvImageV;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];

    
    #ifdef FULL
        [self.logoImageV setImage:[UIImage imageNamed:@"passcode_logo_198_49.png"]];
    #else
        [self.logoImageV setImage:[UIImage imageNamed:@"passcode_logo_198_49_L.png"]];
    #endif
    
    
	[self showImageV:0];
	self.myPass = @"";
	tryLabel.hidden = YES;
	ownField.text = @"";
	ownField.hidden = YES;
    
    
    
    float y;
    NSString *bvImageStr;
    if ([UIScreen mainScreen].bounds.size.width > 400)
    {
        y = 110;
        bvImageStr = @"passcode_1242_2208.png";
    }
    else if ([UIScreen mainScreen].bounds.size.width >350)
    {
        y = 80;
        bvImageStr = @"passcode_750_1334.png";
    }
    else
    {
        y = 0;
        bvImageStr = @"passcode_320_568.png";
    }
    self.m_bv.frame = CGRectMake(self.m_bv.frame.origin.x, y, self.m_bv.frame.size.width,self.m_bv.frame.size.height);
    self.bvImageV.image = [UIImage imageNamed:bvImageStr];
    
    ///
    //设置输入textfield关联的事件
    ownField.delegate = self;
    ownField.keyboardType = UIKeyboardTypeNumberPad;
    [ownField addTarget:self action:@selector(enterChar) forControlEvents:UIControlEventEditingChanged];
    
    ownField.text = @"";
    [self showImageV:0];
    
    //设置点击事件
    UITapGestureRecognizer* Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesDo:)];
    [self.view addGestureRecognizer:Tap];
    [Tap setCancelsTouchesInView:NO];
    [self setupforeTouchCheckViewContor];
}

-(void)setupforeTouchCheckViewContor
{

    
    
    //设置appdelefate 的 输入密码界面为当前页面，添加touch id事件
    AppDelegate_Shared *appdelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.appSetting.istouchid.intValue == TouchNotEn && [appdelegate canTouchId] == TouchYes)
    {
        appdelegate.foreTouchCheckViewContor = self;
        [ownField resignFirstResponder];
        if (appdelegate.isLock == NO)
        {
            appdelegate.isLock = YES;
            //添加验证手势
            [appdelegate addTouchIdPassword_target:self];
        }
    }
    else
    {
        appdelegate.foreTouchCheckViewContor = self;
        [appdelegate setTouchIdPassword:NO];
        [ownField becomeFirstResponder];
    }

}

- (void)enterChar
{
	NSString *text = ownField.text;
    tryLabel.hidden = YES;
    
	[self showImageV:[text length]];
	
	if ([text length]==4)
    {
		self.myPass = text;
		AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
		if ([self.myPass isEqualToString:appDelegate.appSetting.passcode])
        {
            [self startAnimation];
		}
		else
        {
			[self showImageV:0];
			ownField.text = @"";
			tryLabel.hidden = NO;
		}
	}
}


//限制输入文本的长度，代理
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

    /*
	ownField.delegate = self;
	ownField.keyboardType = UIKeyboardTypeNumberPad;
	[ownField addTarget:self action:@selector(enterChar) forControlEvents:UIControlEventEditingChanged];
    
	ownField.text = @"";
    [self showImageV:0];
    
    UITapGestureRecognizer* Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesDo:)];
    [self.view addGestureRecognizer:Tap];
    [Tap setCancelsTouchesInView:NO];
    
    
    
    AppDelegate_Shared *appdelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.appSetting.istouchid.intValue == TouchNotEn && [appdelegate canTouchId] == TouchYes)
    {
        appdelegate.foreTouchCheckViewContor = self;
        [ownField resignFirstResponder];
        if (appdelegate.isLock == NO)
        {
            appdelegate.isLock = YES;
            //添加验证手势
            [appdelegate addTouchIdPassword_target:self];
        }
    }
    else
    {
        [appdelegate setTouchIdPassword:NO];
        [ownField becomeFirstResponder];
    }
    */
    
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





//添加密码时候的动画
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
        [ownField becomeFirstResponder];
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
    AppDelegate_iPhone *appdelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    CGRect orgin = self.bv.frame;
    CGRect orgin2 = self.bv2.frame;
    
    [ownField resignFirstResponder];
    [UIView animateWithDuration:0.5
                     animations:^
     {
         self.bv.frame = CGRectMake(-180+orgin.origin.x, -orgin.size.width, orgin.size.width+180*2, orgin.size.width*3);
         self.bv2.frame = CGRectMake(-60+orgin2.origin.x, -orgin.size.width, orgin2.size.width+60*2, orgin.size.width*3);
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


- (void)dealloc
{
//    self.logoImageV;
//	self.imageV1;
//    self.imageV2;
//    self.imageV3;
//    self.imageV4;
//    
//    
//    self.bv;
//    self.bv2;
//    self.bvImageV;
//    self.m_bv;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



@end
