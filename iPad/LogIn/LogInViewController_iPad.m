//
//  LogInViewController_iPad.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/28.
//
//

#import "LogInViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_Shared.h"
#import "ProfileDetailViewController_iPad.h"
#define degreesToRadians(x) (M_PI  * (x) / 180.0)

#define LOGS_ENABLED NO
#define ANIMATION_DURATION   0.25
#define SLIDESHOW_WIDTH 400


NSString *emailMissing;
NSString *passwordMissing;
NSString *emialorPasscodeError;
NSString *signupwithErrorEmailFormatter;
NSString *signuowithErrorEmailUsed;
NSString *offline;

NSString *findpassworwithErrorNoEmail;
NSString *findpasswordAlert;
NSString *findpasswordwithEmail;//间接使用


@interface LogInViewController_iPad ()
{
    BOOL isSignIn;
    float littleIconLeft;
    float littleIconTop;
    float littleIconWith;
    
    float littleDesCriptionImageLeft;
    float littleDesCriptionImageTop;
    float littleDesCriptionImageWith;
    float littleDescriptionImageHeight;
}
@end

@implementation LogInViewController_iPad
/*
- (void)rotateViewAccordingToStatusBarOrientation:(NSNotification *)notification
{
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
        
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGFloat angle = 0.0;
        CGRect newFrame = self.view.window.bounds;
        //        CGSize statusBarSize = CGSizeZero;// [[UIApplication sharedApplication] statusBarFrame].size;
        
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = -M_PI/2;
                //                newFrame.size.height -= statusBarSize.height;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                //                angle = M_PI / 2.0f;
                
                //                newFrame.origin.x += statusBarSize.width;
                //                newFrame.size.width -= statusBarSize.width;
                break;
            case UIInterfaceOrientationLandscapeRight:
                //                angle = M_PI / 2.0f;
                //
                //                newFrame.size.width -= statusBarSize.width;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = -M_PI / 2.0f;
                //                newFrame.origin.y += statusBarSize.height;
                //                newFrame.size.height -= statusBarSize.height;
                break;
        }
        self.view.transform = CGAffineTransformMakeRotation(angle);
        self.view.frame = newFrame;
    }
    else
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGFloat angle = 0.0;
        CGRect newFrame = self.view.window.bounds;
        CGSize statusBarSize = CGSizeZero;// [[UIApplication sharedApplication] statusBarFrame].size;
        
        switch (orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                newFrame.size.height -= statusBarSize.height;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = - M_PI / 2.0f;
                
                newFrame.origin.x += statusBarSize.width;
                newFrame.size.width -= statusBarSize.width;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI / 2.0f;
                
                newFrame.size.width -= statusBarSize.width;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = 0.0;
                newFrame.origin.y += statusBarSize.height;
                newFrame.size.height -= statusBarSize.height;
                break;
        }
        self.view.transform = CGAffineTransformMakeRotation(angle);
        self.view.frame = newFrame;
    }
    
    //    if(!ISPAD)
    //    {
    //        self.view.transform = CGAffineTransformMakeRotation(angle);
    //        self.view.frame = newFrame;
    //    }
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    littleIconLeft = 20;
    littleIconTop = 86;
    littleIconWith = 34;
    
    littleDesCriptionImageLeft = 62;
    littleDesCriptionImageTop = 97;
    littleDesCriptionImageWith = 110;
    littleDescriptionImageHeight = 12;
    
    isKeyboardUp = NO;
    isNextTextFieldTouch = NO;
    isSignIn=YES;
    
    self.slideShow = [[DRDynamicSlideShow_ipad alloc]init];
    self.viewsForPages = [[NSArray alloc]init];
    self.slideShow.logInViewController_ipad = self;
    //创建动画视图
    [self.slideShow setFrame:CGRectMake((1024-SLIDESHOW_WIDTH)/2, 0, SLIDESHOW_WIDTH, 400)];
    _slideShow.backgroundColor = [UIColor clearColor];
    [self.slideShow setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.slideShow setAlpha:1];
    self.slideShow.bounces = NO;
    [self.slideShow setDidReachPageBlock:^(NSInteger reachedPage) {
        if (LOGS_ENABLED) NSLog(@"Current Page: %li", (long)reachedPage);
    }];
    [self.view insertSubview:self.slideShow belowSubview:_bgButton];
    //创建要显示的几个view数组
    self.viewsForPages = [[NSBundle mainBundle] loadNibNamed:@"DRDynamicSlideShowSubviews" owner:self options:nil];
    [self setupSlideShowSubviewsAndAnimations];
    
    
    //设置登陆框的背景
    _signInBtn = [[HMJCustomAnimationButton alloc]initWithFrame:CGRectMake(332, 567, 360, 46) title:@"SIGN IN" backgroundColor:[HMJNomalClass creatNavigationBarColor_69_153_242]];
    _signInBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_signInBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signInBtnPressed:)];
    [_signInBtn addGestureRecognizer:tap];
    
    
    [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_forgetPasswordBtn addTarget:self action:@selector(forgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _backBtn.alpha=0;
    [_backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn.backgroundColor = [HMJNomalClass creatNavigationBarColor_69_153_242];
    _nextBtn.layer.cornerRadius = 3.5;
    _nextBtn.layer.masksToBounds = YES;
    
    [_nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.alpha=0;
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _emailAddressTextFiled.delegate = self;
    _passwordtextFiled.delegate = self;
    UIFont *font_Light = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    UIColor *black1 = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:font_Light,NSFontAttributeName,black1,NSForegroundColorAttributeName, nil];
    self.emailAddressTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:dic];
    self.passwordtextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:dic];
    
    
    self.reminderLabel.top = self.contentView.top+self.contentView.height;
    emailMissing = @"Email is missing.";
    passwordMissing = @"Passcode is missing.";
    emialorPasscodeError = @"Email and password do not match.";
    signupwithErrorEmailFormatter = @"Please use email address as your account.";
    signuowithErrorEmailUsed = @"The email address has been used by someone else.";
    offline = @"Network Error. Can not connect to network, please check.";
    findpassworwithErrorNoEmail = @"Email address is missing";
    findpasswordAlert = @"An email for password reset will be sent to your address.";
    findpasswordwithEmail = @"We have sent an email to <email address>. Please follow the directions in the email to reset password";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateViewAccordingToStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [self viewLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    if([self.loadStyle isEqualToString:@"Present"])
    {
        self.cancelBtn.hidden = NO;
        [self.cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.cancelBtn];
    }
    else
    {
        self.cancelBtn.hidden = YES;
    }
    
}

//转屏
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.passViewController != nil)
    {
        [appDelegate.passViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    if(appDelegate.rateControl != nil)
    {
        [appDelegate.rateControl willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark Frame

#pragma makr Button Action
-(void)viewLayout
{
    _bgButton.hidden = YES;
    
    _topBgLine.height = SCREEN_SCALE;
    _bottomBgLine.top = 100-SCREEN_SCALE;
    _bottomBgLine.height = SCREEN_SCALE;
    _leftBgLine.width = SCREEN_SCALE;
    _rightBgLine.left = _contentView.width-SCREEN_SCALE;
    _rightBgLine.width = SCREEN_SCALE;
    _middleBgLine.height = SCREEN_SCALE;

//    _signInBtn.frame = CGRectMake(332, 567, 360, 46);
//    
    _myPageControl.top=396-15;
    _contentView.top=440;
    _signInBtn.top=567;
    _signUpView.top=630;
    
}


#pragma mark Action
-(void)cancelBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)touchViewBg
{
    if (!isSignIn)
    {
        return;
    }
    if ([_emailAddressTextFiled isFirstResponder])
    {
        [_emailAddressTextFiled resignFirstResponder];
    }
    else if ([_passwordtextFiled isFirstResponder])
    {
        [_passwordtextFiled resignFirstResponder];
    }
    
    if (isKeyboardUp)
        [self keyboardDownAnimation];
}

-(void)signInBtnPressed:(id)sender
{
    
    if (isSignIn)
    {
        if([_emailAddressTextFiled.text length]==0 || [_passwordtextFiled.text length]==0)
        {
            if ([_emailAddressTextFiled.text length]==0)
            {
                self.reminderLabel.text = emailMissing;
            }
            else
                self.reminderLabel.text = passwordMissing;
            return;
        }
        
        [_signInBtn begainAnimation];
        NSDate *startDate=[NSDate date];
        self.view.userInteractionEnabled = NO;
        
        [PFUser logInWithUsernameInBackground:_emailAddressTextFiled.text password:_passwordtextFiled.text block:^(PFUser *user, NSError *error)
         {
             NSTimeInterval late=[startDate timeIntervalSince1970];
             NSDate *endDate=[NSDate date];
             NSTimeInterval now=[endDate timeIntervalSince1970];
             float timeInterval=now -late;
             self.view.userInteractionEnabled = YES;
             
             if (user)
             {
                 if (timeInterval<1.5)
                 {
                     [self performSelector:@selector(succededAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
                 }
                 else
                     [self succededAfterParseLogin];
                 
                 
             }
             else
             {
                 if (timeInterval<1.5)
                 {
                     [self performSelector:@selector(failedAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
                 }
                 else
                 {
                     [self failedAfterParseLogin];
                 }
                 NSString *alertTitle = nil;
                 if(error)
                 {
                     alertTitle = [error userInfo][@"error"];;
                 }
                 if (alertTitle)
                 {
                     if([alertTitle isEqualToString:@"invalid login parameters"])
                         alertTitle = emialorPasscodeError;
                     else if ([alertTitle isEqualToString:@"The Internet connection appears to be offline."])
                         alertTitle = offline;
                 }
                 
                 
                 self.reminderLabel.text = alertTitle;
                 
             }
             
             self.view.userInteractionEnabled = YES;
         }];
        
    }
    
}
-(void)signUpBtnPressed:(UIButton *)sender
{
    isSignIn=NO;
    
    _signInBtn.alpha=0;
    _signUpView.alpha=0;
    _forgetPasswordBtn.alpha=0;
    [self keyboardUpAnimation];
    [_emailAddressTextFiled becomeFirstResponder];
    
    //    RegisterViewController_iPhone *registerViewController = [[RegisterViewController_iPhone alloc]initWithNibName:@"RegisterViewController_iPhone" bundle:nil];
    //    registerViewController.logInViewController = self;
    //    UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:registerViewController];
    //    [self presentViewController:navi animated:YES completion:nil];
}

-(void)forgetBtnPressed:(UIButton *)sender
{
    if([self.emailAddressTextFiled.text length]==0)
    {
        self.reminderLabel.text = findpassworwithErrorNoEmail;
        return;
    }
    else
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
        if(appDelegate.parseSync.isConnecttoNetwork)
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:findpasswordAlert delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            appDelegate.close_PopView = alertview;
            alertview.tag=101;
            [alertview show];
            
        }
        else
        {
            self.reminderLabel.text = offline;
        }
        
    }
}


-(void)keyboardUpAnimation
{
    
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    
    if (_myPageControl.currentPage==0)
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            [self keyboardUpUIObjectFrame:0];
            _myPageControl.alpha = 0;
        } completion:^(BOOL finished)
         {
             if (!isSignIn)
             {
                 [UIView animateWithDuration:0.5 animations:^{
                     _nextBtn.alpha=1;
                     _backBtn.alpha=1;
                 }];
             }
             
         }];
    }
    else if (_myPageControl.currentPage == 1)
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            [self keyboardUpUIObjectFrame:1];
            phoneImageView.alpha = 0;
            syncImageView.alpha = 0;
            padImageView.alpha = 0;
            _myPageControl.alpha = 0;
            UIImageView *text1ImageView = (UIImageView *)[self.slideShow viewWithTag:9];
            text1ImageView.alpha = 0;
        } completion:^(BOOL finished)
         {
             if (!isSignIn)
             {
                 [UIView animateWithDuration:0.5 animations:^{
                     _nextBtn.alpha=1;
                     _backBtn.alpha=1;
                 }];
             }
             
         }];
    }
    else
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            [self keyboardUpUIObjectFrame:2];
            documentImageView.alpha = 0;
            reportImageView.alpha = 0;
            historyImageView.alpha = 0;
            _myPageControl.alpha = 0;
            UIImageView *text2ImageView = (UIImageView *)[self.slideShow viewWithTag:10];
            text2ImageView.alpha = 0;
        } completion:^(BOOL finished)
         {
             if (!isSignIn)
             {
                 [UIView animateWithDuration:0.5 animations:^{
                     _nextBtn.alpha=1;
                     _backBtn.alpha=1;
                 }];
             }
             
         }];
    }
    
    _slideShow.scrollEnabled = NO;
    _bgButton.hidden = NO;
    isKeyboardUp = YES;
}

-(void)keyboardUpUIObjectFrame:(int)page
{
    UIImageView *iconImageView = (UIImageView *)[self.slideShow viewWithTag:1];
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    //    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    //    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    //    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    //    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    //    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    //    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    
    UIImage *iconImage = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a3"]];
    iconImageView.image = iconImage;
    iconImageView.width = iconImage.size.width;
    iconImageView.height = iconImage.size.height;
    iconImageView.left = (SLIDESHOW_WIDTH-iconImage.size.width)/2 + SLIDESHOW_WIDTH*page;
    iconImageView.top = 56;
    
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_Hours_Keeper_a3"]];
    descriptionImageView.width = image.size.width;
    descriptionImageView.height = image.size.height;
    descriptionImageView.left = (SLIDESHOW_WIDTH-image.size.width)/2 + SLIDESHOW_WIDTH*page;
    _myPageControl.alpha = 0;
    
    
    descriptionImageView.top = 163;
    _contentView.top = 205;
    _signInBtn.top = 332;
    _signUpView.top = 395;
    self.reminderLabel.top = self.contentView.top+self.contentView.height;
}
-(void)keyboardDownAnimation
{
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    
    self.forgetPasswordBtn.alpha = 1;
    if (_myPageControl.currentPage==0)
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            //            _myPageControl.top=396;
            _contentView.top=440;
            _signInBtn.top=567;
            _signUpView.top=630;
            
            UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a1"]];
            iconImage.width = image.size.width;
            iconImage.height = image.size.height;
            iconImage.left = (SLIDESHOW_WIDTH - image.size.width)/2;
            iconImage.top = 120;
            iconImage.image = image;
            
            UIImage *image2 = [UIImage imageNamed:[NSString customImageName:@"ipad_Hours_Keeper_a1"]];
            descriptionImageView.width = image2.size.width;
            descriptionImageView.height = image2.size.height;
            descriptionImageView.left = (SLIDESHOW_WIDTH - image2.size.width)/2;
            descriptionImageView.top = 274;
            _myPageControl.alpha = 1;
            
            
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else if (_myPageControl.currentPage==1)
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            iconImage.top = littleIconTop;
            iconImage.left = littleIconLeft + SLIDESHOW_WIDTH;
            iconImage.width = littleIconWith;
            iconImage.height = littleIconWith;
            
            descriptionImageView.left = littleDesCriptionImageLeft+SLIDESHOW_WIDTH;
            descriptionImageView.top = littleDesCriptionImageTop;
            descriptionImageView.width = littleDesCriptionImageWith;
            descriptionImageView.height = littleDescriptionImageHeight;
            
            _myPageControl.alpha = 1;
            phoneImageView.alpha = 1;
            syncImageView.alpha = 1;
            padImageView.alpha = 1;
            UIImageView *text1ImageView = (UIImageView *)[self.slideShow viewWithTag:9];
            text1ImageView.alpha = 1;
            
            //            _myPageControl.top=396;
            _contentView.top=440;
            _signInBtn.top=567;
            _signUpView.top=630;
            
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            iconImage.top = littleIconTop;
            iconImage.left = littleIconLeft + SLIDESHOW_WIDTH*2;
            iconImage.width = littleIconWith;
            iconImage.height = littleIconWith;
            
            descriptionImageView.left = littleDesCriptionImageLeft+SLIDESHOW_WIDTH*2;
            descriptionImageView.top = littleDesCriptionImageTop;
            descriptionImageView.width = littleDesCriptionImageWith;
            descriptionImageView.height = littleDescriptionImageHeight;
            _myPageControl.alpha = 1;
            documentImageView.alpha = 1;
            reportImageView.alpha = 1;
            historyImageView.alpha = 1;
            UIImageView *text2ImageView = (UIImageView *)[self.slideShow viewWithTag:10];
            text2ImageView.alpha = 1;
            
            //            _myPageControl.top=396;
            _contentView.top=440;
            _signInBtn.top=567;
            _signUpView.top=630;
            
        } completion:^(BOOL finished) {
            ;
        }];
    }
    isKeyboardUp = NO;
    _slideShow.scrollEnabled = YES;
    _bgButton.hidden = YES;
    
    self.reminderLabel.top = self.contentView.top+self.contentView.height;
    
    
}


- (void)setupSlideShowSubviewsAndAnimations
{
    
    for (UIView * pageView in self.viewsForPages) {
        CGFloat verticalOrigin = 0;
        
        //将每一个view下面的子控件添加到scrollview的对应页面上，设置scrollview的contentsize
        for (UIView * subview in pageView.subviews)
        {
            switch (subview.tag)
            {
                case 1:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_logo_a1"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top = 120;
                }
                    break;
                case 2:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_Hours_Keeper_a1"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top = 274;
                }
                    break;
                case 3:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_phone"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left= (SLIDESHOW_WIDTH - 284)/2.0;
                    subview.top=162;
                }
                    break;
                case 4:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_sync"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=(SLIDESHOW_WIDTH - 284)/2.0+74;
                    subview.top=202;
                }
                    break;
                case 5:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_pad"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=(SLIDESHOW_WIDTH - 284)/2.0 + 128;
                    subview.top=162;
                }
                    break;
                case 6:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_document"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=(SLIDESHOW_WIDTH - 252)/2.0;
                    subview.top=146;
                }
                    break;
                case 7:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_pie_chart"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left=(SLIDESHOW_WIDTH - 252)/2.0+104;
                    subview.top=212;
                }
                    break;
                case 8:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_histogram"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - 252)/2.0+182;
                    subview.top=178;
                }
                    break;
                case 9:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_text1"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top=326;
                }
                    break;
                case 10:
                {
                    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"ipad_text2"]];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.top=326;
                }
                    break;
                    
                case 11:
                {
                    
                    UIImage *image = [UIImage imageNamed:@"ipad_Welcome_to"];
                    ((UIImageView *)subview).image = image;
                    subview.width = image.size.width;
                    subview.height = image.size.height;
                    subview.left = (SLIDESHOW_WIDTH - image.size.width)/2;
                    subview.alpha = 1;
                    subview.top = 251;
                }
                    break;
                default:
                    break;
            }
            
            
            //设置每一个页面在scrollview中的位置
            [subview setFrame:CGRectMake(subview.frame.origin.x, verticalOrigin+subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height)];
            [self.slideShow addSubview:subview onPage:pageView.tag];
        }
    }
    
    
    //page0 animation
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:iconImage page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SLIDESHOW_WIDTH, littleIconTop, littleIconWith, littleIconWith)] delay:0]];
    
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:descriptionImageView page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(littleDesCriptionImageLeft+SLIDESHOW_WIDTH, littleDesCriptionImageTop, littleDesCriptionImageWith, littleDescriptionImageHeight)] delay:0]];
    
    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    [phoneImageView setCenter:CGPointMake(phoneImageView.center.x+SLIDESHOW_WIDTH/2, phoneImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:phoneImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(phoneImageView.center.x-SLIDESHOW_WIDTH/2, phoneImageView.center.y)] delay:0]];
    phoneImageView.alpha = 1;
    
    
    
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    [syncImageView setCenter:CGPointMake(syncImageView.center.x+SLIDESHOW_WIDTH*2, syncImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:syncImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(syncImageView.center.x-SLIDESHOW_WIDTH*2, syncImageView.center.y)] delay:0]];
    
    
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    [padImageView setCenter:CGPointMake(padImageView.center.x+SLIDESHOW_WIDTH*3, padImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:padImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(padImageView.center.x-SLIDESHOW_WIDTH*3, padImageView.center.y)] delay:0]];
    
    
    UIImageView *page2Label = (UIImageView *)[self.view viewWithTag:9];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:page2Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    
    //page1 animation
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:iconImage page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SLIDESHOW_WIDTH, littleIconTop, littleIconWith, littleIconWith)] toValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SLIDESHOW_WIDTH*2, littleIconTop, littleIconWith, littleIconWith)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:descriptionImageView page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(littleDesCriptionImageLeft+SLIDESHOW_WIDTH, littleDesCriptionImageTop, littleDesCriptionImageWith, littleDescriptionImageHeight)] toValue:[NSValue valueWithCGRect:CGRectMake(littleDesCriptionImageLeft+SLIDESHOW_WIDTH*2, littleDesCriptionImageTop, littleDesCriptionImageWith, littleDescriptionImageHeight)] delay:0]];
    
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    [documentImageView setCenter:CGPointMake(documentImageView.center.x+SLIDESHOW_WIDTH/2, documentImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:documentImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(documentImageView.center.x-SLIDESHOW_WIDTH/2, documentImageView.center.y)] delay:0]];
    
    
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    [reportImageView setCenter:CGPointMake(reportImageView.center.x+SLIDESHOW_WIDTH*2, reportImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:reportImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(reportImageView.center.x-SLIDESHOW_WIDTH*2, reportImageView.center.y)] delay:0]];
    
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    [historyImageView setCenter:CGPointMake(historyImageView.center.x+SLIDESHOW_WIDTH*3, historyImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:historyImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(historyImageView.center.x-SLIDESHOW_WIDTH*3, historyImageView.center.y)] delay:0]];
    
    
    UIImageView *page3Label = (UIImageView *)[self.view viewWithTag:10];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation_ipad animationForSubview:page3Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    
    
}

-(void)backBtnPressed:(UIButton *)sender
{
    isSignIn=YES;
    [self keyboardDownAnimation];
    _signInBtn.alpha=1;
    _signUpView.alpha=1;
    _backBtn.alpha=0;
    _nextBtn.alpha=0;
    _forgetPasswordBtn.alpha=1;
    [_emailAddressTextFiled resignFirstResponder];
    [_passwordtextFiled resignFirstResponder];
}

-(void)nextBtnPressed:(UIButton *)sender
{
    if ([_emailAddressTextFiled.text length]==0 || [_passwordtextFiled.text length]==0)
    {
        
        if ([_emailAddressTextFiled.text length]==0)
        {
            self.reminderLabel.text = emailMissing;
        }
        else
            self.reminderLabel.text = passwordMissing;
        
        return;
    }
    else
    {
        
        BOOL emailCanUse = [ParseSyncHelper validateEmail:_emailAddressTextFiled.text];
        if (emailCanUse)
        {
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:_emailAddressTextFiled.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             {
                 self.view.userInteractionEnabled = YES;
                 
                 if (!error) {
                     // The find succeeded. The first 100 objects are available in objects
                     NSLog(@"%@", objects);
                     if ([objects count]>0)
                         [self emailExisted:YES];
                     else
                         [self emailExisted:NO];
                 } else {
                     NSString *alertTitle = nil;
                     if(error)
                     {
                         alertTitle = [error userInfo][@"error"];;
                     }
                     if ([alertTitle isEqualToString:@"The Internet connection appears to be offline."])
                         alertTitle = offline;
                     self.reminderLabel.text = alertTitle;
                     
                 }
             }];
            
        }
        else
        {
            self.view.userInteractionEnabled = YES;
            
            self.reminderLabel.text = signupwithErrorEmailFormatter;
            return;        }
        
        
    }
    
    
}

-(void)emailExisted:(BOOL)isExisted
{
    
    //next
    if (!isExisted)
    {
        ProfileDetailViewController_iPad   *profileDetailVC =  [[ProfileDetailViewController_iPad alloc]initWithNibName:@"ProfileDetailViewController_iPad" bundle:nil];
        profileDetailVC.logInViewController = self;
        profileDetailVC.isSetupProfile = YES;
        [self.navigationController pushViewController:profileDetailVC animated:YES];
        
    }
    else
    {
        self.reminderLabel.text = signuowithErrorEmailUsed;
    }
}

-(void)succededAfterParseLogin
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    
    [appDelegate setCurrentUser];
    [appDelegate launchAfterSignIn];
    [appDelegate.parseSync syncAllWithTip:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    [_signInBtn endAnimation];
    
}

-(void)failedAfterParseLogin
{
    [_signInBtn endAnimation];
}
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>=SLIDESHOW_WIDTH*2)
    {
        _myPageControl.currentPage = 2;
    }
    else if (scrollView.contentOffset.x >= SLIDESHOW_WIDTH)
        _myPageControl.currentPage = 1;
    else
        _myPageControl.currentPage = 0;
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.reminderLabel.text = @"";
    if (!isKeyboardUp)
    {
        [self keyboardUpAnimation];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.reminderLabel.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailAddressTextFiled)
    {
        [_passwordtextFiled becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self touchViewBg];
    }
    return YES;
}

#pragma mark AlerView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==101)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
//            [PFUser requestPasswordResetForEmailInBackground:self.emailAddressTextFiled.text];
            
            NSError *error = nil;
            BOOL result = [PFUser requestPasswordResetForEmail:self.emailAddressTextFiled.text error:&error];
            if (result)
            {
                NSRange range = [findpasswordwithEmail rangeOfString:@"<email address>"];
                NSString *textnew = [findpasswordwithEmail stringByReplacingCharactersInRange:range withString:self.emailAddressTextFiled.text];
                UIAlertView *alertview1 = [[UIAlertView alloc]initWithTitle:nil message:textnew delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
                appDelegate.close_PopView = alertview1;
                [alertview1 show];
                return;
            }
            else
            {
                NSString *alertTitle = nil;
                if(error)
                {
                    alertTitle = [error userInfo][@"error"];
                    if([alertTitle length]>0)
                    {
                        //字母的顺序从0开始，toIndex表示到某一个序列号之前一位
                        NSString *firstLabel = [alertTitle substringToIndex:1];
                        NSString *secondString = [alertTitle substringWithRange:NSMakeRange(1, [alertTitle length]-1)];
                        alertTitle = [NSString stringWithFormat:@"%@%@.",[firstLabel uppercaseString],secondString];
                    }
                }
                self.reminderLabel.text = alertTitle;
            }
           
        }
        
    }
    
}

@end
