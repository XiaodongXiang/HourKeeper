//
//  LogInViewController.m
//  HoursKeeper
//
//  Created by humingjing on 15/5/25.
//
//

#import "LogInViewController.h"
#import "AppDelegate_iPhone.h"
#import "ProfileDetailViewController_iPhone.h"



#define LOGS_ENABLED NO
#define ANIMATION_DURATION   0.25

@interface LogInViewController ()
{
    BOOL isSignIn;
    float littleIconLeft;
    float littleIconTop;
    float littleIconWith;
    float hourKeeperTextLeft;
    float hoursKeeperTextTop;
	
	NSString *emailMissing;
	NSString *passwordMissing;
	NSString *emialorPasscodeError;
	NSString *signupwithErrorEmailFormatter;
	NSString *signuowithErrorEmailUsed;
	NSString *offline;
	
	NSString *findpassworwithErrorNoEmail;
	NSString *findpasswordAlert;
	NSString *findpasswordwithEmail;//间接使用
}
@end

@implementation LogInViewController
//@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPoint];
    [self setSubViewFrame];
    [self resetUIObjectTop];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    
    self.view.userInteractionEnabled = YES;
}


#pragma mark Action
-(void)initPoint
{
    [self resetUIObjectTop];
    ///////设置icon和Hours Keeper文字在屏幕左上角的位置
    littleIconLeft = 31;
    littleIconTop = 45;
    littleIconWith = 27;
    hourKeeperTextLeft = 63;
    hoursKeeperTextTop = 54;
    if (IS_IPHONE_4)
    {
        littleIconTop = 35;
        hoursKeeperTextTop = 45;
    }
    else if (IS_IPHONE_5)
        ;
    else if (IS_IPHONE_6)
    {
        littleIconLeft = 45;
        littleIconTop = 60;
        littleIconWith = 30;
        hourKeeperTextLeft = 84;
        hoursKeeperTextTop = 70;
    }
    else
    {
        littleIconLeft = 45;
        littleIconTop = 70;
        littleIconWith = 34;
        hourKeeperTextLeft = 89;
        hoursKeeperTextTop = 82;
    }
    
    if (IS_IPHONE_6PLUS)
    {
        self.reminderLabel.left = 20;
        self.reminderLabel.width = SCREEN_WITH - 20*2;
    }
    else
    {
        self.reminderLabel.left =15;
        self.reminderLabel.width = SCREEN_WITH - 15*2;
    }
    //////////
    
    isKeyboardUp = NO;
    isNextTextFieldTouch = NO;
    isSignIn=YES;
    
    self.slideShow = [[DRDynamicSlideShow alloc]init];
    self.viewsForPages = [[NSArray alloc]init];
    self.slideShow.logInViewController = self;
    //创建动画视图
    [self.slideShow setFrame:CGRectMake(0, 0, SCREEN_WITH, 360)];
    [self.slideShow setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.slideShow setAlpha:1];
    self.slideShow.bounces = NO;
    [self.slideShow setDidReachPageBlock:^(NSInteger reachedPage) {
        if (LOGS_ENABLED) NSLog(@"Current Page: %li", (long)reachedPage);
    }];
    self.slideShow.backgroundColor = [UIColor clearColor];
    
    [self.view insertSubview:self.slideShow belowSubview:_bgButton];
    //创建要显示的几个view数组
    self.viewsForPages = [[NSBundle mainBundle] loadNibNamed:@"DRDynamicSlideShowSubviews" owner:self options:nil];
    [self setupSlideShowSubviewsAndAnimations];
    

    //sign in
    float left = 15;
    float signHeight = 40;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
        signHeight = 44;
    }
    
    _signInBtn.height = signHeight;
    float top = 430;
    CGRect signInViewFrame = CGRectMake(left, top, SCREEN_WITH - left * 2, signHeight);
    
    _signInBtn = [[HMJCustomAnimationButton alloc]initWithFrame:signInViewFrame title:@"SIGN IN" backgroundColor:[HMJNomalClass creatNavigationBarColor_69_153_242]];
    [self.view addSubview:_signInBtn];
    _forgetPasswordBtn.left = _forgetPasswordBtn.left - left;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signInBtnPressed:)];
    [_signInBtn addGestureRecognizer:tap];
    
    [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_forgetPasswordBtn addTarget:self action:@selector(forgetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn setBackgroundImage:[UIImage imageNamed:[NSString customImageName:@"arrow"]] forState:UIControlStateNormal];
    _backBtn.top = 0.48*SCREEN_HEIGHT;
    _backBtn.alpha=0;
    [_backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn.backgroundColor = [HMJNomalClass creatNavigationBarColor_69_153_242];
    _nextBtn.layer.cornerRadius = 3.5;
    _nextBtn.layer.masksToBounds = YES;
    if (IS_IPHONE_4)
    {
        _nextBtn.frame=CGRectMake(SCREEN_WITH-100-left, 200, 100, 40);
        _backBtn.top = 200;
    }
    else if (IS_IPHONE_5)
        _nextBtn.frame=CGRectMake(SCREEN_WITH-100-left, 275, 100, 40);
    else if (IS_IPHONE_6)
    {
        _nextBtn.frame=CGRectMake(SCREEN_WITH-100-left, 338, 100, 40);
        _backBtn.top = 338;

    }
    else
    {
        _backBtn.top = 376;
        _nextBtn.frame=CGRectMake(SCREEN_WITH-100-left, 376, 100, 40);

    }
//    _nextBtn.top = 0.48*SCREEN_HEIGHT;
    _nextBtn.titleLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:17];
    [_nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.alpha=0;
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _emailAddressFiled.delegate = self;
    _passwordtextFiled.delegate = self;
    UIFont *font_Light = [UIFont fontWithName:@"Helvetica Light" size:15];
    UIColor *black1 = [UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:font_Light,NSFontAttributeName,black1,NSForegroundColorAttributeName, nil];
    self.emailAddressFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:dic];
    self.passwordtextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:dic];
    
    
    
    emailMissing = @"Email is missing.";
    passwordMissing = @"Passcode is missing.";
    emialorPasscodeError = @"Email and password do not match.";
    signupwithErrorEmailFormatter = @"Please use email address as your account.";
    signuowithErrorEmailUsed = @"The email address has been used by someone else.";
    offline = @"Network Error. Can not connect to network, please check.";
    findpassworwithErrorNoEmail = @"Email address is missing";
    findpasswordAlert = @"An email for password reset will be sent to your address.";
    findpasswordwithEmail = @"We have sent an email to <email address>. Please follow the directions in the email to reset password";
    
    
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

-(void)setSubViewFrame
{
    _bgButton.hidden = YES;
    _signUpLine.height = SCREEN_SCALE;
    
    _topBgLine.height = SCREEN_SCALE;
    _bottomBgLine.top = self.contentView.height-SCREEN_SCALE;
    _bottomBgLine.height = SCREEN_SCALE;
    _leftBgLine.width = SCREEN_SCALE;
    _rightBgLine.left = _contentView.width-SCREEN_SCALE;
    _rightBgLine.width = SCREEN_SCALE;
    _middleBgLine.height = SCREEN_SCALE;

    //sign up
    _signUpView.left = (SCREEN_WITH-_signUpView.width)/2;

}



-(void)resetUIObjectTop
{
    _myPageControl.alpha = 1;
    
    
    [_backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];

    float left = 15;
    if (IS_IPHONE_4)
    {
        _myPageControl.top = 230;
        _signInBtn.top = 370;
        _signUpView.top = 420;
        _contentView.top = 270;
        _contentView.height = 35*2;
    }
    else if(IS_IPHONE_5)
    {
        _myPageControl.top = 262;
        _contentView.top = 318;
        _signInBtn.top = 442;
        _signUpView.top = 506;
    }
    else if (IS_IPHONE_6)
    {
        _myPageControl.top = 333;
        _contentView.top = 382;
        _signInBtn.top = 518;
        _signUpView.top = 584;
    }
    else
    {
        left = 20;
        
        _myPageControl.top = 385-10;
        _contentView.top = 434;
        _signInBtn.top = 572;
        _signUpView.top = 640;
        _contentView.height = 108;
        
    }
    self.forgetPasswordBtn.top = self.contentView.height/2.0 + (self.contentView.height/2.0 - self.forgetPasswordBtn.height)/2.0;

    self.reminderLabel.top = self.contentView.height + self.contentView.top;
    
    _contentView.left = left;
    _contentView.width = SCREEN_WITH - _contentView.left*2;
    _emailAddressFiled.left = left;
    _emailAddressFiled.width = _contentView.width - _emailAddressFiled.left*2+4;
    
    _passwordtextFiled.left = left;
    _passwordtextFiled.width = _contentView.width - _passwordtextFiled.left*2;

}


-(void)setIconImageinPage0:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"logo_page1"]];
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    imageView.left = (SCREEN_WITH - image.size.width)/2;
    
    float top = 73;
    if(IS_IPHONE_4)
        ;
    else if (IS_IPHONE_5)
        ;
    else if (IS_IPHONE_6)
        top = 93;
    else
        top = 110;
    imageView.top = top;
    
    imageView.image = image;

}

-(void)setDescriptionImageinPage0:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"Hours_Keeper"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    imageView.left = (SCREEN_WITH - image.size.width)/2;
    
    float top = 190;
    if(IS_IPHONE_4)
        ;
    else if (IS_IPHONE_5)
        ;
    else if (IS_IPHONE_6)
        top = 225;
    else
        top = 254;
    imageView.top = top;
}
-(void)setWelcomImageinPage0:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"Welcome_to"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    imageView.left = (SCREEN_WITH - image.size.width)/2;
    imageView.hidden = NO;
    float top = 173;
    if(IS_IPHONE_4)
        ;
    else if (IS_IPHONE_5)
        ;
    else if (IS_IPHONE_6)
        top = 203;
    else
        top = 232;
    imageView.top = top;
}

-(void)setiPhoneImageinPage1:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"page2_phone"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    
    float left = 50;
    float top = 106;
    if (IS_IPHONE_4)
    {
        top = 76;
    }
    else if (IS_IPHONE_5)
    {
        ;
    }
    else if (IS_IPHONE_6)
    {
        left = 59;
        top = 130;
    }
    else
    {
        left = 65;
        top = 150;
    }
    imageView.left = left;
    imageView.top = top;


}

-(void)setSyncImageinPage1:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"sync"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    
    float left = 106;
    float top = 136;
    if (IS_IPHONE_4)
    {
        top = 106;
    }
    else if (IS_IPHONE_5)
    {
        ;
    }
    else if (IS_IPHONE_6)
    {
        left = 126;
        top = 171;
    }
    else
    {
        left = 140;
        top = 189;
    }
    imageView.left = left;
    imageView.top = top;

}

-(void)setiPadImageinPage1:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"page2_pad"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    
    float left = 150;
    float top = 106;
    if (IS_IPHONE_4)
    {
        top = 76;
    }
    else if (IS_IPHONE_5)
    {
        ;
    }
    else if (IS_IPHONE_6)
    {
        left = 175;
        top = 130;
    }
    else
    {
        left = 195;
        top = 149;
    }
    imageView.left = left;
    imageView.top = top;
}

-(void)setTextinPage1:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"text1"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    imageView.left = (SCREEN_WITH - image.size.width)/2;
    
    float top = 230;
    if (IS_IPHONE_4)
    {
        top = 200;
    }
    else if (IS_IPHONE_5)
    {

    }
    else if (IS_IPHONE_6)
    {
        top = 282;
    }
    else
    {
        top = 315;
    }
    imageView.top = top;

}

-(void)setDocumentImageinPage2:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"document"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    
    float left = 63;
    float top = 91;
    if (IS_IPHONE_4)
    {
        left =63;
        top = 71;
    }
    else if (IS_IPHONE_5)
    {
        left =63;
        top = 91;
    }
    else if (IS_IPHONE_6)
    {
        left = 73;
        top = 117;
    }
    else
    {
        left = 81;
        top = 130;
    }
    imageView.left = left;
    imageView.top = top;

}

-(void)setChartImageinPage2:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"pie_chart"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    float left = 144;
    float top = 141;
    if (IS_IPHONE_4)
    {
        left =144;
        top = 121;
    }
    else if (IS_IPHONE_5)
    {
        left =144;
        top = 141;
    }
    else if (IS_IPHONE_6)
    {
        left = 168;
        top = 175;
    }
    else
    {
        left = 186;
        top = 194;
    }
    imageView.left = left;
    imageView.top = top;

}

-(void)setHistoryImageinPage2:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"histogram"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    float left = 204;
    float top = 116;
    if (IS_IPHONE_4)
    {
        left =204;
        top = 106;
    }
    else if (IS_IPHONE_5)
    {
        left =204;
        top = 116;
    }
    else if (IS_IPHONE_6)
    {
        left = 239;
        top = 146;
    }
    else
    {
        left = 264;
        top = 162;
    }
    imageView.left = left;
    imageView.top = top;
}
-(void)setTextImageinPage2:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"text2"]];
    imageView.image = image;
    imageView.width = image.size.width;
    imageView.height = image.size.height;
    imageView.left = (SCREEN_WITH - image.size.width)/2;
    
    float top = 229;
    if (IS_IPHONE_4)
    {
        top = 199;
    }
    else if (IS_IPHONE_5)
    {
        top = 229;
    }
    else if (IS_IPHONE_6)
    {
        top = 282;
    }
    else
    {
        top = 314;
    }
    imageView.top = top;
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
    if ([_emailAddressFiled isFirstResponder])
    {
        [_emailAddressFiled resignFirstResponder];
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
//    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    if (isSignIn)
    {
        if([_emailAddressFiled.text length]==0 || [_passwordtextFiled.text length]==0)
        {
            if ([_emailAddressFiled.text length]==0)
            {
                self.reminderLabel.text = emailMissing;
            }
            else
                self.reminderLabel.text = passwordMissing;
            return;
        }
        
        //开始动画 总时间0.4s
        [_signInBtn  begainAnimation];
        NSDate *startDate=[NSDate date];
        self.view.userInteractionEnabled = NO;
        [PFUser logInWithUsernameInBackground:_emailAddressFiled.text password:_passwordtextFiled.text block:^(PFUser *user, NSError *error)
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
                 
                 //邮箱没注册或者密码错误parse统一反馈是 invalid login parameters
                 if (alertTitle)
                 {
                     if([alertTitle isEqualToString:@"invalid login parameters"])
                         alertTitle = emialorPasscodeError;
                     else if ([alertTitle isEqualToString:@"The Internet connection appears to be offline."])
                         alertTitle = offline;
                 }
                 else
                 {
                     alertTitle = emialorPasscodeError;
                 }
                 
                 self.reminderLabel.text = alertTitle;
                 
             }
             [self.reminderLabel setNeedsDisplay];
             
         }];

    }

}
-(void)signUpBtnPressed:(UIButton *)sender
{
    isSignIn=NO;
    [self keyboardUpAnimation];
    _signInBtn.alpha=0;
    _signUpView.alpha=0;
    _forgetPasswordBtn.alpha=0;
    [_emailAddressFiled becomeFirstResponder];
    
//    RegisterViewController_iPhone *registerViewController = [[RegisterViewController_iPhone alloc]initWithNibName:@"RegisterViewController_iPhone" bundle:nil];
//    registerViewController.logInViewController = self;
//    UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:registerViewController];
//    [self presentViewController:navi animated:YES completion:nil];
}

-(void)forgetBtnPressed:(UIButton *)sender
{
    if([self.emailAddressFiled.text length]==0)
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
    
    
    UIImageView *textinPage1 = (UIImageView *)[self.slideShow viewWithTag:9];
    UIImageView *textinPage2 = (UIImageView *)[self.slideShow viewWithTag:10];


    
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
        textinPage1.alpha = 0;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            [self keyboardUpUIObjectFrame:1];
            phoneImageView.alpha = 0;
            syncImageView.alpha = 0;
            padImageView.alpha = 0;
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
    else
    {
        textinPage2.alpha = 0;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            [self keyboardUpUIObjectFrame:2];
            documentImageView.alpha = 0;
            reportImageView.alpha = 0;
            historyImageView.alpha = 0;
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
    _slideShow.scrollEnabled = NO;
    _bgButton.hidden = NO;
    isKeyboardUp = YES;
}

-(void)keyboardUpUIObjectFrame:(int)page
{
    [_signInBtn endAnimation];
    
    UIImageView *iconImageView = (UIImageView *)[self.slideShow viewWithTag:1];
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    UIImageView *welcomImageView = (UIImageView *)[self.slideShow viewWithTag:11];

//    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
//    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
//    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
//    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
//    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
//    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    
    UIImage *iconImage = [UIImage imageNamed:[NSString customImageName:@"logo_a3"]];
    iconImageView.image = iconImage;
    iconImageView.width = iconImage.size.width;
    iconImageView.height = iconImage.size.height;
    iconImageView.left = (SCREEN_WITH-iconImage.size.width)/2 + SCREEN_WITH*page;
    
    UIImage *image = [UIImage imageNamed:[NSString customImageName:@"Hours_Keeper_a3"]];
    descriptionImageView.width = image.size.width;
    descriptionImageView.height = image.size.height;
    descriptionImageView.left = (SCREEN_WITH-image.size.width)/2 + SCREEN_WITH*page;
    _myPageControl.alpha = 0;
    welcomImageView.hidden = YES;
    
    if (IS_IPHONE_4)
    {
        iconImageView.top = 29;
        descriptionImageView.top = 90;
        _contentView.top = 112;
        _signInBtn.top = 210;

        _signUpView.top = 268;
    }
    else if (IS_IPHONE_5)
    {
        iconImageView.top = 49;
        descriptionImageView.top = 121;
        _contentView.top = 158;
        _signInBtn.top = 276;

        _signUpView.top = 330;
    }
    else if (IS_IPHONE_6)
    {
        iconImageView.top = 69;
        descriptionImageView.top = 155;
        _contentView.top = 208;
        _signInBtn.top = 328;
        

        _signUpView.top = 379;
    }
    else
    {
        iconImageView.top = 80;
        descriptionImageView.top = 175;
        _contentView.top = 246;
        _signInBtn.top = 374;

        _signUpView.top = 433;
    }
    
    self.reminderLabel.top = self.contentView.top +self.contentView.height;

}
-(void)keyboardDownAnimation
{
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    UIImageView * descriptionImageView = (UIImageView *)[self.slideShow viewWithTag:2];
    UIImageView *welcomImageView = (UIImageView *)[self.slideShow viewWithTag:11];

    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    UIImageView *textinPage1 = (UIImageView *)[self.slideShow viewWithTag:9];
    UIImageView *textinPage2 = (UIImageView *)[self.slideShow viewWithTag:10];

    self.reminderLabel.top = self.contentView.top+self.contentView.height;

    if (_myPageControl.currentPage==0)
    {
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            [self resetUIObjectTop];
            
            [self setIconImageinPage0:iconImage];
            [self setWelcomImageinPage0:welcomImageView];
            [self setDescriptionImageinPage0:descriptionImageView];
            

        } completion:^(BOOL finished) {
            ;
        }];
    }
    else if (_myPageControl.currentPage==1)
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            
            iconImage.left = littleIconLeft + SCREEN_WITH;
            iconImage.top = littleIconTop;
            iconImage.width = littleIconWith;
            iconImage.height = littleIconWith;
            
            descriptionImageView.left = hourKeeperTextLeft + SCREEN_WITH;
            descriptionImageView.top = hoursKeeperTextTop;
            descriptionImageView.width = 87;
            descriptionImageView.height = 9;
            
            _myPageControl.alpha = 1;
            phoneImageView.alpha = 1;
            syncImageView.alpha = 1;
            padImageView.alpha = 1;
            textinPage1.alpha = 1;

            [self resetUIObjectTop];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        _slideShow.scrollEnabled = NO;
        [UIView  animateWithDuration:ANIMATION_DURATION animations:^{
            iconImage.left = littleIconLeft + SCREEN_WITH*2;
            iconImage.top = littleIconTop;
            iconImage.width = littleIconWith;
            iconImage.height = littleIconWith;
            
            descriptionImageView.left = hourKeeperTextLeft+SCREEN_WITH*2;
            descriptionImageView.top = hoursKeeperTextTop;
            descriptionImageView.width = 87;
            descriptionImageView.height = 9;
            _myPageControl.alpha = 1;
            documentImageView.alpha = 1;
            reportImageView.alpha = 1;
            historyImageView.alpha = 1;
            textinPage2.alpha  =1;

            [self resetUIObjectTop];
        } completion:^(BOOL finished) {
        }];
    }

    isKeyboardUp = NO;
    _slideShow.scrollEnabled = YES;
    _bgButton.hidden = YES;

}


- (void)setupSlideShowSubviewsAndAnimations
{
    
    for (UIView * pageView in self.viewsForPages) {
        
        //将每一个view下面的子控件添加到scrollview的对应页面上，设置scrollview的contentsize
        for (UIView * subview in pageView.subviews)
        {
            switch (subview.tag)
            {
                case 1:
                {
                    [self setIconImageinPage0:((UIImageView *)subview)];
                }
                    break;
                case 2:
                {
                    
                    [self setDescriptionImageinPage0:((UIImageView *)subview)];
                    
                }
                    break;
                case 3:
                {
                    [self setiPhoneImageinPage1:((UIImageView *)subview)];
                }
                    break;
                case 4:
                {
                    [self setSyncImageinPage1:((UIImageView *)subview)];
                    
                    
                }
                    break;
                case 5:
                {
                    [self setiPadImageinPage1:((UIImageView *)subview)];
                    
                    
                }
                    break;
                case 6:
                {
                    [self setDocumentImageinPage2:((UIImageView *)subview)];
                }
                    break;
                case 7:
                {
                    [self setChartImageinPage2:((UIImageView *)subview)];
                }
                    break;
                case 8:
                {
                    [self setHistoryImageinPage2:((UIImageView *)subview)];
                    
                    
                }
                    break;
                case 9:
                {
                    [self setTextinPage1:((UIImageView *)subview)];
                    
                    
                }
                    break;
                case 10:
                {
                    [self setTextImageinPage2:((UIImageView *)subview)];
                    
                    
                }
                    break;
                 case 11:
                {
                    
                    [self setWelcomImageinPage0:((UIImageView *)subview)];
                }
                    break;
                default:
                    break;
            }

            
            //设置每一个页面在scrollview中的位置
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height)];
            [self.slideShow addSubview:subview onPage:pageView.tag];
            
        }
    }
    
    
    
    UIImageView *iconImage = (UIImageView *)[self.slideShow viewWithTag:1];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:iconImage page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SCREEN_WITH, littleIconTop, littleIconWith, littleIconWith)] delay:0]];
    
    UITextView * descriptionImageView = (UITextView *)[self.slideShow viewWithTag:2];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:descriptionImageView page:0 keyPath:@"frame" toValue:[NSValue valueWithCGRect:CGRectMake(hourKeeperTextLeft+SCREEN_WITH, hoursKeeperTextTop, 87, 9)] delay:0]];

    UIImageView *phoneImageView = (UIImageView *)[self.slideShow viewWithTag:3];
    [phoneImageView setCenter:CGPointMake(phoneImageView.center.x+SCREEN_WITH/2, phoneImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:phoneImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(phoneImageView.center.x-SCREEN_WITH/2, phoneImageView.center.y)] delay:0]];
    
    UIImageView *syncImageView  = (UIImageView *)[self.slideShow viewWithTag:4];
    [syncImageView setCenter:CGPointMake(syncImageView.center.x+SCREEN_WITH*2, syncImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:syncImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(syncImageView.center.x-SCREEN_WITH*2, syncImageView.center.y)] delay:0]];

    
    UIImageView *padImageView = (UIImageView *)[self.slideShow viewWithTag:5];
    [padImageView setCenter:CGPointMake(padImageView.center.x+SCREEN_WITH*3, padImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:padImageView page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(padImageView.center.x-SCREEN_WITH*3, padImageView.center.y)] delay:0]];
    
    
    UIImageView *page2Label = (UIImageView *)[self.view viewWithTag:9];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:page2Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];

    //page1 animation
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:iconImage page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SCREEN_WITH, littleIconTop, littleIconWith, littleIconWith)] toValue:[NSValue valueWithCGRect:CGRectMake(littleIconLeft+SCREEN_WITH*2, littleIconTop, littleIconWith, littleIconWith)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:descriptionImageView page:1 keyPath:@"frame" fromValue:[NSValue valueWithCGRect:CGRectMake(hourKeeperTextLeft+SCREEN_WITH, hoursKeeperTextTop, 87, 9)] toValue:[NSValue valueWithCGRect:CGRectMake(hourKeeperTextLeft+SCREEN_WITH*2, hoursKeeperTextTop, 87, 9)] delay:0]];

    
    UIImageView  * documentImageView = (UIImageView *)[self.slideShow viewWithTag:6];
    [documentImageView setCenter:CGPointMake(documentImageView.center.x+SCREEN_WITH/2, documentImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:documentImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(documentImageView.center.x-SCREEN_WITH/2, documentImageView.center.y)] delay:0]];

    
    UIImageView *reportImageView = (UIImageView *)[self.slideShow viewWithTag:7];
    [reportImageView setCenter:CGPointMake(reportImageView.center.x+SCREEN_WITH*2, reportImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:reportImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(reportImageView.center.x-SCREEN_WITH*2, reportImageView.center.y)] delay:0]];
    
    UIImageView *historyImageView = (UIImageView *)[self.slideShow viewWithTag:8];
    [historyImageView setCenter:CGPointMake(historyImageView.center.x+SCREEN_WITH*3, historyImageView.center.y)];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:historyImageView page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(historyImageView.center.x-SCREEN_WITH*3, historyImageView.center.y)] delay:0]];
    
    
    UIImageView *page3Label = (UIImageView *)[self.view viewWithTag:10];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:page3Label page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];

    
    
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
    [_emailAddressFiled resignFirstResponder];
    [_passwordtextFiled resignFirstResponder];
}

-(void)nextBtnPressed:(UIButton *)sender
{
    
    if ([_emailAddressFiled.text length]==0 || [_passwordtextFiled.text length]==0)
    {
        
        if ([_emailAddressFiled.text length]==0)
        {
            self.reminderLabel.text = emailMissing;
        }
        else
            self.reminderLabel.text = passwordMissing;
        return;
    }
    else
    {
        self.view.userInteractionEnabled = NO;

        //检查邮箱是否被注册
        BOOL emailCanUse = [ParseSyncHelper validateEmail:_emailAddressFiled.text];
        if (emailCanUse)
        {
            
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:_emailAddressFiled.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                self.view.userInteractionEnabled = YES;

                if (!error) {
                    // The find succeeded. The first 100 objects are available in objects
                    NSLog(@"%@", objects);
                    if ([objects count]>0)
                        [self emailExisted:YES];
                    else
                        [self emailExisted:NO];
                }
                else
                {
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
            return;
        }

        
        
    }
    

}

-(void)emailExisted:(BOOL)isExisted
{
    if ([_emailAddressFiled isFirstResponder])
    {
        [_emailAddressFiled resignFirstResponder];
    }
    if ([_passwordtextFiled isFirstResponder])
    {
        [_passwordtextFiled resignFirstResponder];
    }
    //next
    if (!isExisted)
    {
        ProfileDetailViewController_iPhone  *profileDetailVC =  [[ProfileDetailViewController_iPhone alloc]initWithNibName:@"ProfileDetailViewController_iPhone" bundle:nil];
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
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

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
    if (scrollView.contentOffset.x>=SCREEN_WITH*2)
    {
        _myPageControl.currentPage = 2;
    }
    else if (scrollView.contentOffset.x >= SCREEN_WITH)
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
    if (textField == _emailAddressFiled)
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

#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==101)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
//            [PFUser requestPasswordResetForEmailInBackground:_emailAddressFiled.text];
            
            NSError *error = nil;
            BOOL result = [PFUser requestPasswordResetForEmail:_emailAddressFiled.text error:&error];
            if (result)
            {
                NSRange range = [findpasswordwithEmail rangeOfString:@"<email address>"];
                NSString *textnew = [findpasswordwithEmail stringByReplacingCharactersInRange:range withString:self.emailAddressFiled.text];
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
