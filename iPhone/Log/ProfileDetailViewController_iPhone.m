//
//  ProfileDetailViewController_iPhone.m
//  HoursKeeper
//
//  Created by humingjing on 15/4/27.
//
//

#import "ProfileDetailViewController_iPhone.h"
#import "AppDelegate_Shared.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "FileController.h"
#import "Profile.h"
#import "AppDelegate_iPhone.h"
#import "LogInViewController.h"
#import "Appirater.h"

#import "UIImage (CS_Extensions).h"
#import "UIImage+Blur.h"
#import "UINavigationBar+CustomImage.h"

extern NSString *offline;


@interface ProfileDetailViewController_iPhone ()
{
    NSString *reminderTitle;
}
@end

@implementation ProfileDetailViewController_iPhone

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initPoint];
    [self setContentView];
    
    [self setSubViewFont];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    [self setSubViewFram];
}



#pragma mark Init
-(void)initPoint
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    //nav
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar drawNavigationBarForOS5];
    
    NSString *title1 = @"Profile";
    NSString *title2 = @"(Optional)";
    NSString *title = [NSString stringWithFormat:@"%@%@",title1,title2];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range1 = NSMakeRange(0, [title1 length]-1);
    NSRange range2 = NSMakeRange(range1.length, [title2 length]-1);
    UIFont *font1 = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:17];
    UIFont *font2 = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:17];
    [mutableString addAttribute:NSFontAttributeName value:font1 range:range1];
    [mutableString addAttribute:NSFontAttributeName value:font2 range:range2];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.attributedText = mutableString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    

    
    //back btn
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    [backButton setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = appDelegate.naviFont;
    
    [backButton addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backButton];
    
    if (!_isSetupProfile)
    {
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.titleLabel.font = appDelegate.naviFont2;
        saveButton.frame = CGRectMake(0, 0, 48, 30);
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [appDelegate setNaviGationItem:self isLeft:NO button:saveButton];
    }
    
    
    
    _headIconBtn.backgroundColor = [UIColor whiteColor];
    _headIconBtn.layer.borderWidth = 1;
    _headIconBtn.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
    _headIconBtn.layer.cornerRadius = _headIconBtn.width/2;
    _headIconBtn.layer.masksToBounds = YES;

    
    _contentScrollVIew.contentSize = CGSizeMake(_contentScrollVIew.width, self.view.height);

    
    /////
    [_headIconBtn addTarget:self action:@selector(headImageIconBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_femaleBtn addTarget:self action:@selector(femalBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_manBtn addTarget:self action:@selector(manBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
    }
    _doneBtn = [[HMJCustomAnimationButton alloc]initWithFrame:CGRectMake(left, 434, SCREEN_WITH - left*2, 40) title:@"START" backgroundColor:[HMJNomalClass creatNavigationBarColor_69_153_242]];
//    _doneBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [_contentScrollVIew addSubview:_doneBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doneBtnPressed:)];
    [_doneBtn addGestureRecognizer:tap];
    
    
    _firstNameFiled.delegate = self;
    _streetTextField.delegate = self;
    _emailTextField.delegate  = self;
    _phoneTextField.delegate = self;
    _companyTextField.delegate = self;
    _streetTextField.delegate = self;
    _stateTextField.delegate = self;
    _cityTextField.delegate = self;


}

-(void)setContentView
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    Profile *myProfile;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectModel *model = [appDelegate managedObjectModel];
    NSEntityDescription *profile = [[model entitiesByName] valueForKey:@"Profile"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:profile];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    if([results count]>0)
    {
        myProfile = [appDelegate.parseSync getLocalOnly_Data:results tableName:PF_TABLE_PROFILE];

    }

    //注册时，如果以前没注册过用profile内容，注册过就新开一个
    if (_isSetupProfile)
    {
        
        if(appDelegate.appSetting.lastUser==nil)
        {
            [self useOldProfile:myProfile];
        }
        else
        {
            [self useNewProfile];
        }
    }
    else
    {
        [self useOldProfile:myProfile];
    }

    
    /*
    if (_isSetupProfile)
    {
        _emailTextField.text = _logInViewController.emailAddressFiled.text;
        self.manBtn.selected = YES;
        self.femaleBtn.selected = NO;
        
    }
    else
    {
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObjectModel *model = [appDelegate managedObjectModel];
        NSEntityDescription *profile = [[model entitiesByName] valueForKey:@"Profile"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:profile];
        NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
        
        
        if ([results count] > 0)
        {
            myProfile = [appDelegate.parseSync getLocalOnly_Data:results tableName:PF_TABLE_PROFILE];
            _firstNameFiled.text = myProfile.firstName;
            _lastNameFiled.text = myProfile.lastName;
            _emailTextField.text = myProfile.email;
            
            _phoneTextField.text = myProfile.phone;
            _companyTextField.text = myProfile.company;
            _streetTextField.text = myProfile.street;
            _cityTextField.text = myProfile.city;
            _stateTextField.text = myProfile.state;
            _zipTextField.text = myProfile.zip;
            _faxTextField.text = myProfile.fax;
            
            if ([myProfile.sex isEqualToString:@"man"])
            {
                self.manBtn.selected = YES;
                self.femaleBtn.selected = NO;
            }
            else
            {
                self.manBtn.selected = NO;
                self.femaleBtn.selected = YES;
            }
        }
        
    }
    */
    
    
}

-(void)useOldProfile:(Profile *)myProfile
{
    _firstNameFiled.text = myProfile.firstName;
    _lastNameFiled.text = myProfile.lastName;
    _emailTextField.text = myProfile.email;
    if ([_emailTextField.text length]==0)
    {
        _emailTextField.text = _logInViewController.emailAddressFiled.text;
    }
    _phoneTextField.text = myProfile.phone;
    _companyTextField.text = myProfile.company;
    _streetTextField.text = myProfile.street;
    _cityTextField.text = myProfile.city;
    _stateTextField.text = myProfile.state;
    _zipTextField.text = myProfile.zip;
    _faxTextField.text = myProfile.fax;
    
    if ([myProfile.sex isEqualToString:@"man"])
    {
        self.manBtn.selected = YES;
        self.femaleBtn.selected = NO;
    }
    else
    {
        self.manBtn.selected = NO;
        self.femaleBtn.selected = YES;
    }
    
    if (myProfile.headImage != nil)
    {
        [_headIconBtn setImage:myProfile.headImage forState:UIControlStateNormal];
    }
    else
    {
        [_headIconBtn setImage:[UIImage imageNamed:@"defaulthead_portrait"] forState:UIControlStateNormal];
    }
    [_headIconBtn layoutIfNeeded];

}
-(void)useNewProfile
{
    _emailTextField.text = _logInViewController.emailAddressFiled.text;
    self.manBtn.selected = YES;
    self.femaleBtn.selected = NO;
    [_headIconBtn setImage:[UIImage imageNamed:@"defaulthead_portrait"] forState:UIControlStateNormal];

}

-(void)setSubViewFram
{
    float lineLeft = 15;
    float top1 = 0;
    float top2 = 0;
    //frame
    if (IS_IPHONE_6PLUS)
    {
        lineLeft = 20;
        top1 = 20;
        top2 = 230;
        
        _headIconBtn.left = 44;
        _headIconBtn.top = 35;
        
        _manBtn.left = 35;
        _manBtn.top = 110;
        
        _femaleBtn.left = 71;
        _femaleBtn.top = _manBtn.top;
        
        
        float left = 144;
        
        _firstNameFiled.left = left;
        _lastNameFiled.left = left;
        _emailTextField.left = left;
        
        float left2 = 49;
        _phoneTextField.left = left2;
        _companyTextField.left = left2;
        _streetTextField.left = left2;
        _streetTextField.width = 90;
        _cityTextField.left = 160;
        _cityTextField.width = _streetTextField.width;
        _stateTextField.left = 282;
        _stateTextField.width = _streetTextField.width;
        
        _zipTextField.left = left2;
        _faxTextField.left = left2;
        
        _doneBtn.top = 484;
//        [_doneBtn setSelfFrame:CGRectMake(_doneBtn.left, 484, _doneBtn.width, 44)];
        
    }
    else if (IS_IPHONE_6)
    {
        lineLeft = 15;
        top1 = 20;
        top2 = 220;
        
        _headIconBtn.left = 35;
        _headIconBtn.top = 35;
        
        _manBtn.left = 33;
        _manBtn.top = 110;
        
        _femaleBtn.left = 74;
        _femaleBtn.top = _manBtn.top;
        
        
        float left = 130;
        
        _firstNameFiled.left = left;
        _lastNameFiled.left = left;
        _emailTextField.left = left;
        
        float left2 = 45;
        _phoneTextField.left = left2;
        _companyTextField.left = left2;
        _streetTextField.left = left2;
        _streetTextField.width = 80;
        _cityTextField.left = 145;
        _cityTextField.width = _streetTextField.width;
        _stateTextField.left = 260;
        _stateTextField.width = _streetTextField.width;
        
        _zipTextField.left = left2;
        _faxTextField.left = left2;
        
        _doneBtn.top = 475;


        
    }
    else
    {
        lineLeft = 15;
        top1 = 10;
        top2 = 190;
        
        _headIconBtn.left = 30;
        _headIconBtn.top = 25;
        
        _manBtn.left = 20;
        _manBtn.top = 92;
        
        _femaleBtn.left = 61;
        _femaleBtn.top = _manBtn.top;
        
        
        float left = 120;
        
        _firstNameFiled.left = left;
        _lastNameFiled.left = left;
        _emailTextField.left = left;
        
        float left2 = 45;
        _phoneTextField.left = left2;
        _companyTextField.left = left2;
        _streetTextField.left = left2;
        _streetTextField.width = 70;
        _cityTextField.left = 135;
        _cityTextField.width = _streetTextField.width;
        _stateTextField.left = 228;
        _stateTextField.width = _streetTextField.width;
        
        _zipTextField.left = left2;
        _faxTextField.left = left2;
        
        _doneBtn.top = 435;
//        [_doneBtn setSelfFrame:CGRectMake(_doneBtn.left, 435, _doneBtn.width, 40)];

    }
    
    //top && height
    top2 = top2 +1;
    
    float height = 44;
    _firstNameFiled.top = top1;
    _lastNameFiled.top = top1+height;
    _emailTextField.top = top1+height*2;
    _firstNameFiled.height = _lastNameFiled.height = _emailTextField.height = height;
    
    
    _phoneTextField.top = top2;
    _companyTextField.top = top2 + height;
    _streetTextField.top = top2 + height*2;
    _stateTextField.top = top2 + height*2;
    _cityTextField.top = top2 + height*2;
    _stateTextField.top = top2 + height*2;
    _zipTextField.top = top2 + height*3;
    _faxTextField.top = top2 + height*4;
    _phoneTextField.height = _companyTextField.height =_streetTextField.height= _stateTextField.height = _cityTextField.height = _stateTextField.height = _zipTextField.height = _faxTextField.height = height;
    
    //with
    float with1 = SCREEN_WITH - _firstNameFiled.left - lineLeft;
    float with2 = SCREEN_WITH - _phoneTextField.left - lineLeft;
    _firstNameFiled.width = with1;
    _lastNameFiled.width = with1;
    _emailTextField.width = with1;
    _phoneTextField.width = with2;
    _companyTextField.width = with2;
    _zipTextField.width = with2;
    _faxTextField.width = with2;

    
//    [_doneBtn setSelfFrame:CGRectMake(lineLeft, _doneBtn.top, SCREEN_WITH - lineLeft*2, _doneBtn.height)];

    
    _backImage.image =  [UIImage imageNamed:[NSString customImageName:@"profile_setting"]];

    if (_isSetupProfile)
    {
        
//        _faxTextField.top = _zipTextField.top;
//        _zipTextField.hidden = YES;
        
//        _doneBtn.top = _doneBtn.top - height;
        
        
//        if (IS_IPHONE_4)
//        {
//            
//            _doneBtn.top = _doneBtn.top - 20;
//            
//
//        }
        
    }
    else
    {
        
        _doneBtn.hidden = YES;
        _zipTextField.hidden = NO;
        
    }

}

-(void)setSubViewFont
{
    
    //[UIFont familyNames] 所有的字体
        for(NSString *fontfamilyname in [UIFont familyNames])
        {
            NSLog(@"family:'%@'",fontfamilyname);
    
            //所有该字体的子字体
            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
            {
                NSLog(@"\tfont:'%@'",fontName);
            }
            NSLog(@"-------------");
        }
    UIFont *font_Light = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    UIFont *font_Regular = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:15];
    
    UIColor *black1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIColor *black2 = [UIColor blackColor];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:font_Light,NSFontAttributeName,black1,NSForegroundColorAttributeName, nil];
    
    _firstNameFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"First Name" attributes:dic];
    _lastNameFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Last Name" attributes:dic];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email" attributes:dic];
    _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Phone" attributes:dic];
    _companyTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Company" attributes:dic];
    _streetTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Street" attributes:dic];
    _cityTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"City" attributes:dic];
    _stateTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"State" attributes:dic];
    _zipTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Zip" attributes:dic];
    _faxTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Fax" attributes:dic];
    
    _firstNameFiled.font = _lastNameFiled.font = _emailTextField.font = _phoneTextField.font = _companyTextField.font = _streetTextField.font = _cityTextField.font = _stateTextField.font = _zipTextField.font = _faxTextField.font = font_Regular;
    
    _firstNameFiled.textColor = _lastNameFiled.textColor = _emailTextField.textColor = _phoneTextField.textColor = _companyTextField.textColor = _streetTextField.textColor = _cityTextField.textColor = _stateTextField.textColor = _zipTextField.textColor = _faxTextField.textColor = black2;
    
    
}
#pragma mark Btn Action
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.currentTextField != nil && [self.currentTextField isFirstResponder])
    {
        [self.currentTextField resignFirstResponder];
    }
}
- (void)headImageIconBtnPressed:(id)sender
{
    [self.currentTextField resignFirstResponder];
    
    [_contentScrollVIew setContentOffset:CGPointMake(0, 0) animated:YES];
    UIActionSheet *actionSheet;
    
    //可以拍照
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]||
       [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        actionSheet = [UIActionSheet alloc];
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Choose Existing Photo" otherButtonTitles:@"Take Photo",nil];
        actionSheet.tag = 1;
    }
    else
    {
        actionSheet = [UIActionSheet alloc];
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Choose Existing Photo" otherButtonTitles:nil];
        actionSheet.tag = 2;
    }

    
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = actionSheet;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = [[NSArray alloc] initWithObjects:actionSheet, [NSNumber numberWithInteger:buttonIndex],nil];
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    [self performSelector:@selector(doActionSheet:) withObject:array afterDelay:0];
}

/*
    响应
 */
-(void)doActionSheet:(NSArray *)array
{
    UIActionSheet *actionSheet = (UIActionSheet *)[array objectAtIndex:0];
    
    NSNumber *num = [array objectAtIndex:1];
    NSInteger buttonIndex = num.integerValue;
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //有摄像头
    if (actionSheet.tag==1)
    {
        
        //从相册选择
        if (buttonIndex==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                appDelegate.m_pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                appDelegate.m_pickerController.delegate = self;
                appDelegate.m_pickerController.allowsEditing = YES;
                [self presentViewController:appDelegate.m_pickerController animated:YES completion:^{
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                }];
                appDelegate.m_widgetController = self;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Library Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show];
                
                appDelegate.close_PopView = alertView;
            }
            
        }
        //让用户拍照
        else if(buttonIndex == 1)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                appDelegate.m_pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                appDelegate.m_pickerController.delegate = self;
                appDelegate.m_pickerController.allowsEditing = YES;
                [self presentViewController:appDelegate.m_pickerController animated:YES completion:nil];
                appDelegate.m_widgetController = self;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Camera Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show];
                
                appDelegate.close_PopView = alertView;
            }
            
        }
        else
            return;
    }
    //无摄像头
    else
    {
        if(buttonIndex==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                appDelegate.m_pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                appDelegate.m_pickerController.delegate = self;
                appDelegate.m_pickerController.allowsEditing = YES;
                [self presentViewController:appDelegate.m_pickerController animated:YES completion:^{
                    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

                }];
                appDelegate.m_widgetController = self;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Library Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show];
                
                appDelegate.close_PopView = alertView;
            }

        }
        else
            return;
    }

}

/*
    选择了某一张照片作为头像
 */
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqual:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [_headIconBtn setImage:image forState:UIControlStateNormal];
        [_headIconBtn layoutIfNeeded];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)femalBtnPressed:(UIButton *)sender
{
    _femaleBtn.selected = YES;
    _manBtn.selected = NO;
}

-(void)manBtnPressed:(UIButton  *)sender
{
    _femaleBtn.selected = NO;
    _manBtn.selected = YES;
}

-(void)backBtnPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnPressed:(UIButton *)sender
{

    
    if (_isSetupProfile)
    {
        [_doneBtn begainAnimation];
        PFUser *user = [PFUser user];
        user.username = _logInViewController.emailAddressFiled.text;
        user.password = _logInViewController.passwordtextFiled.text;
        user.email = _logInViewController.emailAddressFiled.text;
        
        NSDate *startDate=[NSDate date];
        self.view.userInteractionEnabled = NO;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            NSTimeInterval late=[startDate timeIntervalSince1970];
            NSDate *endDate=[NSDate date];
            NSTimeInterval now=[endDate timeIntervalSince1970];
            float timeInterval=now -late;
            
            if (!error)
            {
                //注册成功
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if (![userDefault boolForKey:kAppUseAppNeedParse]) {
                    [userDefault setBool:YES forKey:kAppUseAppNeedParse];
                    [userDefault synchronize];
                }
                
                if (timeInterval<1.5)
                {
                    [self performSelector:@selector(succededAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
                }
                else
                    [self succededAfterParseLogin];
                
            }
            else
            {
                self.view.userInteractionEnabled = YES;

                if (timeInterval<1.5)
                {
                    [self performSelector:@selector(failedAfterParseLogin) withObject:nil afterDelay:(1.5-timeInterval)];
                }
                else
                {
                    

                    
                    [self failedAfterParseLogin];
                    
                    
                }
                
                reminderTitle = nil;
                if(error)
                {
                    reminderTitle = [error userInfo][@"error"];;
                }
                
                if ([reminderTitle isEqualToString:@"The Internet connection appears to be offline."])
                    reminderTitle = offline;


                
                UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:reminderTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
                appDelegate.close_PopView = alertview;
                [alertview show];
            }
            
            
            
        }];

    }
    else
    {
        [self saveProfileObject];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)saveProfileObject
{
    AppDelegate_iPhone*appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectModel *model = [appDelegate managedObjectModel];
    NSEntityDescription *profile = [[model entitiesByName] valueForKey:@"Profile"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:profile];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    Profile *myProfile = nil;
    if ([results count] > 0)
    {
        
        myProfile = [appDelegate.parseSync getLocalOnly_Data:results tableName:PF_TABLE_PROFILE];
        myProfile.firstName = _firstNameFiled.text;
        myProfile.lastName  = _lastNameFiled.text;
        myProfile.company = _companyTextField.text;
        myProfile.phone = _phoneTextField.text;
        myProfile.fax = _faxTextField.text;
        myProfile.email = _emailTextField.text;
        myProfile.street = _streetTextField.text;
        myProfile.city = _cityTextField.text;
        myProfile.state = _stateTextField.text;
        myProfile.zip = _zipTextField.text;
        
        
        
        if(self.manBtn.selected)
            myProfile.sex = @"man";
        else
            myProfile.sex = @"female";
        myProfile.headImage = self.headIconBtn.imageView.image;

        //parse
        //这个是特例，用的是user的objectId
        myProfile.uuid = appDelegate.appUser.objectId;
        myProfile.accessDate = [NSDate date];
        myProfile.sync_status = [NSNumber numberWithInteger:0];;
        
        
    }
    else
    {
        myProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context];
        myProfile.firstName = _firstNameFiled.text;
        myProfile.lastName  = _lastNameFiled.text;
        myProfile.company = _companyTextField.text;
        myProfile.phone = _phoneTextField.text;
        myProfile.fax = _faxTextField.text;
        myProfile.email = _emailTextField.text;
        myProfile.street = _streetTextField.text;
        myProfile.city = _cityTextField.text;
        myProfile.state = _stateTextField.text;
        myProfile.zip = _zipTextField.text;
        
        if(self.manBtn.selected)
            myProfile.sex = @"man";
        else
            myProfile.sex = @"female";
        myProfile.headImage = self.headIconBtn.imageView.image;
        
        //parse
        //这个是特例，用的是user的objectId
        myProfile.uuid = appDelegate.appUser.objectId;
        myProfile.accessDate = [NSDate date];
        myProfile.sync_status = [NSNumber numberWithInteger:0];;

    }
    
    [context save:nil];
    
    [appDelegate.parseSync updateProfileFromLocal:myProfile];

}

-(void)succededAfterParseLogin
{
    AppDelegate_iPhone*appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];

    [appDelegate setCurrentUser];
    
    
    //保存本地信息
    [self saveProfileObject];
    
    [self.navigationController popViewControllerAnimated:NO];
    [appDelegate launchAfterSignIn];
    [_doneBtn endAnimation];
    [appDelegate.parseSync syncAllWithTip:NO];

    
}

-(void)failedAfterParseLogin
{
    [_doneBtn endAnimation];
}

#pragma mark UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    float hight = _contentScrollVIew.height - textField.top - textField.height;
    
    if (hight < 260)
    {
        double keyBoardHigh = 260-hight;
        [_contentScrollVIew setContentOffset:CGPointMake(0, keyBoardHigh) animated:YES];
//        [_contentScrollVIew setContentInset:UIEdgeInsetsMake(-keyBoardHigh, 0, keyBoardHigh, 0)];
    }
    
    self.currentTextField = textField;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)touchViewBg:(UITextField *)textField
{
    if (self.currentTextField != nil && [self.currentTextField isFirstResponder])
    {
        [self.currentTextField resignFirstResponder];
        
        [self.contentScrollVIew  setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    
}

#pragma mark ScrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.currentTextField != nil)
    {
        [self.currentTextField resignFirstResponder];
        
        [self.contentScrollVIew setContentOffset:CGPointMake(0, 0)];

        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
