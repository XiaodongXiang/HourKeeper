//
//  AppDelegate_Shared.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "AppDelegate_Shared.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"

#import "UINavigationBar+CustomImage.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#import "Logs.h"
#import "Clients.h"
#import "Invoice.h"

#import "CaculateMoney.h"
#import "GTMBase64.h"
#import "Appirater.h"

#import <StoreKit/StoreKit.h>

#import "Ipad_CheckEnter.h"
#import "CheckPasscodeViewController_iPhone.h"
#import "SettingsViewController_New.h"
#import "SettingViewController_ipad.h"
#import "TimerStartViewController_ipad.h"


//联网头文件
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>


@interface AppDelegate_Shared()
{
   int isCanBreak;
}
@end



@implementation AppDelegate_Shared

@synthesize close_PopView;
@synthesize touchIdContext;

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
    //设置parse
//    [Parse enableLocalDatastore];
//    [Parse setApplicationId:@"uhkhy4RF49uyPnNpqZWVMUThLNiDJFCYOD4J2QB6" clientKey:@"llLEic3dqt4h9kosMNlWqkcPOSKBIO6KpiVBfSe1"];

	[Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
		configuration.applicationId = @"uhkhy4RF49uyPnNpqZWVMUThLNiDJFCYOD4J2QB6";
		configuration.clientKey =@"llLEic3dqt4h9kosMNlWqkcPOSKBIO6KpiVBfSe1";
		configuration.server = @"http://hourskeeper-master.us-east-1.elasticbeanstalk.com/parse";
	}]];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *mainPath = [paths objectAtIndex:0];
//    Log(@"mainPath:%@",mainPath);
    
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //初次登陆 widget 数据转移
        if (![defaults2 stringForKey:WIDGET_FIRST])
        {
            [self copyDatabase_location_to_widget];
            
            [defaults2 setValue:@"YES" forKey:WIDGET_FIRST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if ([defaults2 integerForKey:LITE_UNLOCK_FLAG])
            {
                NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_Group];
                [sharedUserDefaults setInteger:1 forKey:LITE_UNLOCK_FLAG];
                [sharedUserDefaults synchronize];
            }
        }
    }
    
    
    
    //版本划分
    self.parseSync = [[ParseSyncHelper alloc]init];
    
    self.lite_Purchase = nil;
    self.naviBarWitd = 0;
    self.naviFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    self.naviFont2 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    self.m_pickerController = nil;
    _m_overTimeArray = nil;
    _m_weekDateArray = nil;
    self.isBackgroundIn = 0;
    touchIdContext = nil;
    self.foreTouchCheckViewContor = nil;
    self.passSetTouchCheckViewContor = nil;
    self.isLock = NO;
    
    self.isWidgetAlert = NO;
    self.isWidgetPrsent = NO;
    self.isWidgetFirst = YES;
    self.m_widgetController = nil;
    
    self.severTipStly = 0;
    
    NSArray *results = [self getAllSetting];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    //新用户
    if ([results count] == 0)
    {
        if (![userDefault boolForKey:kAppUseAppNeedParse]) {
            //新用户，需要登录parse才可使用app
            [userDefault setBool:YES forKey:kAppUseAppNeedParse];
            [userDefault synchronize];
        }
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *err;
        Settings *setting = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
        setting.currency = @"$ - US Dollar";
        setting.isPasscodeOn = [NSNumber numberWithBool:NO];
        setting.isBadgeOn = [NSNumber numberWithBool:YES];
        setting.istouchid = [NSNumber numberWithInteger:0];
        _currencyStr = @"$";
        setting.autoSync = @"YES";
        [context save:&err];
        self.appSetting = setting;
    }
    else
    {
        Settings *mySet = [results objectAtIndex:0];
        _currencyStr = [[mySet.currency componentsSeparatedByString:@" - "] objectAtIndex:0];
        self.appSetting = mySet;
        
        if ([self.appSetting.autoSync length]<=0 || self.appSetting.autoSync==nil)
        {
            self.appSetting.autoSync = @"YES";
            [self.managedObjectContext save:nil];
        }
    }
    
    if ([userDefault boolForKey:kAppUseAppNeedParse]) {
        self.needLoginParse = YES;
    }
    else
        self.needLoginParse = NO;
    
    
//    [Crashlytics startWithAPIKey:@"5396d094a6603764683087a0e2248c3bf6260141"];
    [Fabric with:@[[Crashlytics class]]];

#ifdef FULL
    self.isPurchased = YES;
    [Flurry startSession:@"NKW7V5QVQ8R7R5Y3JMVW"];
#else
    self.isPurchased = NO;
    [Flurry startSession:@"XZ7D6PM5JTZ6WXDYDSHK"];
#endif
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [Flurry setAppVersion:version];
    
    
    if (self.isPurchased == NO)
    {
        [self doInit_Lite];
        _purchasingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.purchasingView.backgroundColor = [UIColor blackColor];
        self.purchasingView.alpha = 0.5;
        UIActivityIndicatorView *activitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activitView.frame = CGRectMake((self.purchasingView.frame.size.width-activitView.frame.size.width)/2, (self.purchasingView.frame.size.height-activitView.frame.size.height)/2, activitView.frame.size.width, activitView.frame.size.height);
        [activitView startAnimating];
        [self.purchasingView addSubview:activitView];
    }
    else
    {
        self.purchasingView = nil;
    }
    
    
    //hmj delete more
    //数据矫正
    //    [self removeRubinshData];
    
    
    
    //初始week first day第一次登陆会设置
    if (![defaults2 integerForKey:@"CalendarDateStly"])
    {
        [defaults2 setInteger:1 forKey:@"CalendarDateStly"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //lite client 随机数量
        if (![defaults2 stringForKey:LITE_CLIENT_UNLIMITCONUT])
        {
            int randomNumber = arc4random()%10;
            if (randomNumber == 0)
            {
                [defaults2 setValue:@"YES" forKey:LITE_CLIENT_UNLIMITCONUT];
            }
            else
            {
                [defaults2 setValue:@"NO" forKey:LITE_CLIENT_UNLIMITCONUT];
            }
            [defaults2 synchronize];
        }
    }
    
    //升级适配
    if ([defaults2 integerForKey:@"IsRestore"] == 1)
    {
        [self upgradeDatabase_isMust:YES];
        
        [defaults2 setInteger:0 forKey:@"IsRestore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [self upgradeDatabase_isMust:NO];
    }
    
    //初始dropbox同步
    self.dropboxHelper = [[DropboxSyncHelper alloc] init];
    
    
    //去 UINavigationBar 投影
    UIImage *shadowImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)];
    [[UINavigationBar appearance] setShadowImage:shadowImage];
    
    
    if ([defaults2 stringForKey:LITE_CLIENT_UNLIMITCONUT])
    {
        if ([[defaults2 stringForKey:LITE_CLIENT_UNLIMITCONUT] isEqualToString:@"NO"])
        {
            [Flurry logEvent:@"8_SESSION_LIMITEDB"];
        }
        else
        {
            [Flurry logEvent:@"8_SESSION_UNLIMITEDA"];
        }
    }
    
    
    self.nomalClass  = [[HMJNomalClass alloc]init];
    [self loadHMJIndicator];
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    
//    NSFetchRequest  *fetchRequest = [[NSFetchRequest alloc]init];
//    NSEntityDescription *InvoiceEntity = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:appDelegate.managedObjectContext];
//    [fetchRequest setEntity:InvoiceEntity];
//    NSArray *requests = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    Invoice *invocie = [requests firstObject];
//    NSLog(@"invoice log 个数:%lu",(unsigned long)[invocie.logs count]);
    
    //hmj delete more
    //    [self saveContext];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //Badge
    if ([self.appSetting.isBadgeOn boolValue])
    {
        NSEntityDescription *clientsEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Clients"];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:clientsEntity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(beginTime != nil) AND (sync_status == 0)"];
        [fetchRequest setPredicate:predicate];
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        if ([[PFUser currentUser] objectForKey:@"username"]!=nil)
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = [results count];
        }
        else
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        
    }
    else
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    [self saveContext];
    
    //关闭alertview actionsheet
    if ([self.appSetting.isPasscodeOn boolValue])
    {
        [self closeModalView];
    }
    
    
    self.isBackgroundIn = 1;
    self.isWidgetFirst = NO;
    
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    self.isBackgroundIn = 0;
    
    if ([self.appSetting.passcode length]>0)
    {
        if ([self.foreTouchCheckViewContor isKindOfClass:[CheckPasscodeViewController_iPhone class]])
        {
            CheckPasscodeViewController_iPhone *enter = (CheckPasscodeViewController_iPhone *)self.foreTouchCheckViewContor;
            //            [enter.ownField resignFirstResponder];
            //            if (self.isLock == NO)
            //            {
            //                self.isLock = YES;
            //                [self addTouchIdPassword_target:enter];
            //            }
            [enter setupforeTouchCheckViewContor];
            
        }
        else if ([self.foreTouchCheckViewContor isKindOfClass:[Ipad_CheckEnter class]])
        {
            Ipad_CheckEnter *enter = (Ipad_CheckEnter *)self.foreTouchCheckViewContor;
            //            [enter.ownField resignFirstResponder];
            //            if (self.isLock == NO)
            //            {
            //                self.isLock = YES;
            //                [self addTouchIdPassword_target:enter];
            //            }
            [enter setupforeTouchCheckViewContor];
        }
        
        //        self.foreTouchCheckViewContor = nil;
    }
    
    if (self.passSetTouchCheckViewContor != nil)
    {
        if ([self.passSetTouchCheckViewContor isKindOfClass:[SettingsViewController_New class]])
        {
            SettingsViewController_New *passSet = (SettingsViewController_New *)self.passSetTouchCheckViewContor;
            [passSet checkTouchId];
        }
        else if ([self.passSetTouchCheckViewContor isKindOfClass:[SettingViewController_ipad class]])
        {
            SettingViewController_ipad *passSet = (SettingViewController_ipad *)self.passSetTouchCheckViewContor;
            [passSet checkTouchId];
        }
    }
    
}


//当应用在后台的时候，被以URL的方式打开，当应用没有运行的时候,先didfiniashlaunch，后本方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    [self do_openURL:url];
    
    return YES;
}

/**
 widget功能点击会通过URL打开该应用
 当应用在后台的时候，被以URL的方式打开，当应用没有运行的时候,先didfiniashlaunch，后本方法
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    

    NSLog(@"url-------------");
    [self do_openURL:url];
    
    return YES;
}


- (void)dealloc
{
    if (self.lite_Purchase != nil)
    {
        self.lite_Purchase.delegate = nil;
    }
    
}


#pragma mark -
#pragma mark   TouchId

-(int)canTouchId
{
    NSError *m_error = nil;
    //判断是否支持touchid
    if([self.touchIdContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&m_error])
    {
        return TouchYes;
    }
    else
    {
        int error_stly = TouchNotAvOrTH;
        if (m_error != nil)
        {
            switch (m_error.code)
            {
                case LAErrorTouchIDNotEnrolled:
                    error_stly = TouchNotEn;
                    break;
                    
                case LAErrorPasscodeNotSet:
                    error_stly = TouchNotSet;
                    break;
                    
                case LAErrorTouchIDNotAvailable:
                    error_stly = TouchNotAvOrTH;
                    break;
                    
                case LAErrorSystemCancel:
                    error_stly = TouchCancel;
                    break;
                    
                default:
                    error_stly = TouchNotAvOrTH;
                    break;
            }
        }
        
        return error_stly;
    }
}

//添加密码或者touchid
-(void)addTouchIdPassword_target:(id)m_self
{
    //不支持touchid添加密码界面
    if ([self canTouchId] != TouchYes)
    {
        [self setTouchIdPassword:NO];
        [self performSelector:@selector(do_addTouchIdPassword_parameter:) onThread:[NSThread mainThread] withObject:[[NSArray alloc] initWithObjects:m_self,[NSNumber numberWithInt:TouchCancel], nil] waitUntilDone:YES];
        return;
    }
    
    touchIdContext = nil;
    
    NSString *reasonString = @"Hours Keeper need your Touch ID.";
    //判断用户touchid功能能不能用
    [self.touchIdContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonString reply:^(BOOL succes, NSError *error)
     {
         if(succes)
         {
             [self performSelector:@selector(do_addTouchIdPassword_parameter:) onThread:[NSThread mainThread] withObject:[[NSArray alloc] initWithObjects:m_self,[NSNumber numberWithInt:TouchYes], nil] waitUntilDone:YES];
         }
         else
         {
             switch (error.code)
             {
                 case LAErrorAuthenticationFailed:
                     break;
                     
                 case LAErrorUserCancel:
                     break;
                     
                 case LAErrorUserFallback:
                     break;
                     
                 default:
                     break;
             }
             [self performSelector:@selector(do_addTouchIdPassword_parameter:) onThread:[NSThread mainThread] withObject:[[NSArray alloc] initWithObjects:m_self,[NSNumber numberWithInt:TouchCancel], nil] waitUntilDone:YES];
         }
     }
     ];
}

//添加密码界面
-(void)do_addTouchIdPassword_parameter:(NSArray *)m_array
{
    if (self.isBackgroundIn == 0)
    {
        id m_self = [m_array objectAtIndex:0];
        NSNumber *num = [m_array objectAtIndex:1];
        if ([m_self isKindOfClass:[CheckPasscodeViewController_iPhone class]])
        {
            
            CheckPasscodeViewController_iPhone *enter = (CheckPasscodeViewController_iPhone *)m_self;
            self.foreTouchCheckViewContor = enter;
            [enter doBack_TouchIdAction:num];
        }
        else if ([m_self isKindOfClass:[Ipad_CheckEnter class]])
        {
            Ipad_CheckEnter *enter = (Ipad_CheckEnter *)m_self;
            self.foreTouchCheckViewContor = enter;
            [enter doBack_TouchIdAction:num];
        }
    }
    
    self.isLock = NO;
}

-(LAContext *)touchIdContext
{
    if (touchIdContext == nil)
    {
        touchIdContext = [[LAContext alloc] init];
    }
    return touchIdContext;
}

-(void)setTouchIdPassword:(BOOL)isOpen
{
    NSManagedObjectContext* context = self.managedObjectContext;
    NSError* errors = nil;
    NSInteger open;
    if (isOpen == YES)
    {
        open = 2;
    }
    else
    {
        open = 0;
    }
    self.appSetting.istouchid = [NSNumber numberWithInteger:open];
    [context save:&errors];
}


-(void)showTouchIdFaildTip_havePass:(BOOL)havePass
{
    NSString *tip;
    if (havePass == YES)
    {
        tip = @"Check your system touch id to ensure correct Settings.";
    }
    else
    {
        tip = @"Touch ID need your password to ensure security.";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tip
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    self.close_PopView = alertView;
}





#pragma mark -
#pragma mark navigation bar

-(void)setNaviGationItem:(UIViewController *)_controller isLeft:(BOOL)_isLeft button:(UIButton *)_button
{
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:117.0/255 green:175.0/255 blue:229.0/255 alpha:1] forState:UIControlStateHighlighted];
    if (_isLeft == YES)
    {
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    else
    {
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [_button setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,10)];
    }
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_button];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (self.naviBarWitd != 0)
    {
        flexible.width = self.naviBarWitd;
        self.naviBarWitd = 0;
    }
    else
    {
        flexible.width = -8.f;
    }
    
    if (_isLeft == YES)
    {
        _controller.navigationItem.leftBarButtonItems = @[flexible,barButton];
    }
    else
    {
        _controller.navigationItem.rightBarButtonItems = @[flexible,barButton];
    }
}

/*
    设置Nav titile+backgroundImage
 */
-(void)setNaviGationTittle:(UIViewController *)_controller with:(float)_with high:(float)_high tittle:(NSString *)str
{
    _controller.edgesForExtendedLayout = UIRectEdgeNone;
    [_controller.navigationController.navigationBar drawNavigationBarForOS5];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _with, _high)];
    title.text = str;
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    _controller.navigationItem.titleView = title;
}


#pragma mark Set 方法
-(UIImagePickerController *)m_pickerController
{
    if (_m_pickerController == nil)
    {
        _m_pickerController = [[UIImagePickerController alloc] init];
    }
    return _m_pickerController;
}

-(NSArray *)m_overTimeArray
{
    if (_m_overTimeArray == nil)
    {
        _m_overTimeArray = [[NSArray alloc] initWithObjects:OVER_NONE,@"1.25",@"1.50",@"1.75",@"2.00",@"2.50",@"3.00",@"4.00",nil];
    }
    
    return _m_overTimeArray;
}

-(NSArray *)m_weekDateArray
{
    if (_m_weekDateArray == nil)
    {
        _m_weekDateArray = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    }
    
    return _m_weekDateArray;
}

-(NSArray *)m_currencyArray
{
    if (_m_currencyArray == nil)
    {
        _m_currencyArray = [[NSArray alloc] initWithObjects: @"Lek - Albanian Lek", @"Kz - Angolan Kwanza", @"$ - Argentine Peso",
                         @"դր. - Armenian Dram", @"Afl. - Aruban Florin", @"$ - Australian Dollar",
                         @"AZN - Azerbaijanian Manat",@"د.ج - Algerian Dinar",@"؋ - Afghan Afghani",
                         //B
                         @"B$ - Bahamian Dollar", @"৳ - Bangladeshi Taka",
                         @"Bds$ - Barbadian Dollar", @"BYR - Belarusian Ruble", @"$ - Belize Dollar",
                         @"BD$ - Bermudan Dollar", @"Nu. - Bhutanese Ngultrum", @"Bs - Bolivian Boliviano",
                         @"KM - Bosnia-Herzegovina", @"P - Botswanan Pula", @"R$ - Brazilian Real",
                         @"£ - British Pound Sterling", @"$ - Brunei Dollar", @"лв. - Bulgarian Lev",
                         @"FBu - Burundian Franc",@".د.ب - Bahraini Dinar",
                         //C
                         @"$ - Canadian Dollar", @"$ - Cape Verde Escudo", @"$ - Cayman Islands Dollars",
                         @"CFA - CFA Franc BCEAO", @"FCFA - CFA Franc BEAC", @"F - CFP Franc",
                         @"$ - Chilean Peso", @"￥ - Chinese Yuan Renminbi", @"$ - Colombian Peso",
                         @"CF - Comorian Franc", @"F - Congolese Franc", @"₡ - Costa Rican colón", @"Kn - Croatian Kuna",
                         @"$MN - Cuban Peso", @"Kč - Czech Republic Koruna",@"؋ - Cambodian Riel",
                         //D
                         @"kr - Danish Krone", @"$ - Djiboutian Franc", @"RD$ - Dominican Peso",
                         //E
                         @"$ - East Caribbean Dollar", @"$ - Eritrean Nakfa", @"kr - Estonian Kroon",
                         @"$ - Ethiopian Birr", @"€ - Euro",@"ج.م - Egyptian Pound",
                         //F
                         @"£ - Falkland Islands Pound", @"FJ$ - Fijian Dollar",
                         //G
                         @"D - Gambia Dalasi", @"GEL - Georgian Lari", @"GH¢ - Ghanaian Cedi",
                         @"£ - Gibraltar Pound", @"Q - Guatemalan Quetzal", @"FG - Guinean Franc", @"F$ - Guyanaese Dollar",
                         //H
                         @"G - Haitian Gourde", @"L - Honduran Lempira", @"$ - Hong Kong Dollar", @"Ft - Hungarian Forint",
                         //I
                         @"kr. - Icelandic króna", @"Rs. - Indian Rupee", @"Rp - Indonesian Rupiah", @"₪ - Israeli New Sheqel",
                         @"ع.د - Iraqi Dinar",@"﷼ - Iranian Rial",
                         //J
                         @"J$ - Jamaican Dollar", @"￥ - Japanese Yen",@"د.ا - Jordanian Dinar",
                         //K
                         @"〒 - Kazakhstani Tenge", @"KSh - Kenyan Shilling", @"KGS - Kyrgystani Som",@"د.ك - Kuwaiti Dinar",
                         //L
                         @"₭ - Laotian Kip", @"Ls - Latvian Lats", @"L - Lesotho Loti", @"L$ - Liberian Dollar",
                         @"Lt - Lithuanian Litas",@"ل.ل - Lebanese Pound",@"ل.د - Libyan Dinar",
                         //M
                         @"MOP - Macanese Pataca", @"MDen - Macedonian Denar", @"MGA - Madagascar Ariary",
                         @"MK - Malawian Kwacha", @"RM - Malaysian Ringgit", @"MRf - Maldive Islands Rufiyaa",
                         @"R - Mauritian Rupee", @"UM - Mauritanian Ouguiya", @"$ - Mexican Peso", @"MDL - Moldovan Leu",
                         @"₮ - Mongolian Tugrik", @"MTn - Mozambican Metical", @"K - Myanma Kyat",@"د.م. - Moroccan Dirham",
                         //N
                         @"N$ - Namibian Dollar", @"रू. - Nepalese Rupee", @"ƒ - Netherlands Antillean Guilder",
                         @"NT$ - New Taiwan Dollar", @"$ - New Zealand Dollar", @"₦ - Nigerian Naira", @"C$ - Nicaraguan Cordoba Oro",
                         @"₩ - North Korean Won", @"kr - Norwegian Krone",
                         //O
                         @"ر.ع. - Omani Rial",
                         //P
                         @"PKR - Pakistani Rupee", @"PAB - Panamanian Balboa", @"K - Papua New Guinea Kina", @"PYG - Paraguayan Guarani",
                         @"PEN - Peruvian Nuevo Sol", @"₱ - Philippine Peso", @"zł - Polish Zloty", @"£ - Pound",
                         //Q
                         @"ر.ق - Qatari Rial",
                         //R
                         @"lei - Romanian Leu", @"руб. - Russian Ruble", @"RF - Rwandan Franc",
                         //S
                         @"£ - Saint Helena Pound", @"Db - São Tomé and Príncipe", @"RSD - Serbian Dinar", @"SR - Seychelles Rupee",
                         @"Le - Sierra Leonean Leone", @"$ - Singapore Dollar", @"SI$ - Solomon Islands Dollar", @"$ - Somali Shilling", 
                         @"₩ - Sorth Korean Won", @"R - South African Rand", @"SLR - Sri Lanka Rupee", @"SDG - Sudanese Pound",
                         @"$ - Surinamese Dollar", @"L - Swazi Lilangeni", @"kr - Swedish Krona", @"SFr. - Swiss Franc",
                         @"ر.س - Saudi Riyal",@"ل.س - Syrian Pound",
                         //T
                         @"TJS - Tajikistani Somoni", @"TSh - Tanzanian Shilling", @"฿ - Thai Baht", @"T$ - Tonga Pa‘anga",
                         @"TT$ - Trinidad and Tobago", @"TRY - Turkish Lira",@"د.ت - Tunisian Dinar",
                         //U
                         @"USh - Ugandan Shilling", @"rpH. - Ukrainian Hryvnia", @"COU - Unidad de Valor Real", @"$U - Uruguay Peso",
                         @"$ - US Dollar", @"so‘m - Uzbekistan Som",@"د.إ - United Arab Emirates",
                         //V
                         @"Vt - Vanuatu Vatu", @"BsF - Venezuelan Bolivar Fuerte", @"₫ - Vietnamese Dong",
                         //W
                         @"WS$ - Samoabn Tala",
                         //Y
                         @"﷼ - Yemeni Rial",
                         //Z
                         @"ZK - Zambian Kwacha",nil];
    }
    
    return _m_currencyArray;
}



#pragma mark -
#pragma mark custom
//计算评论弹出是否满足条件
-(void)doRateApp
{
    self.popAlertFlag = 0;
    [Appirater appLaunched];
}

- (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}


-(void)showActiviIndort
{
    [self hideActiviIndort];
    [self.window addSubview:self.purchasingView];
}

-(void)hideActiviIndort;
{
    [self.purchasingView removeFromSuperview];
}

- (double)getMultipleNumber:(NSString *)myString
{
	double num = 1;
	if ([myString isEqualToString:OVER_NONE])
    {
		num = 1;
	}
    else
    {
        myString = [myString uppercaseString];
        myString = [myString stringByReplacingOccurrencesOfString:@"X" withString:@""];
        num = [myString doubleValue];
    }
    
	return num;
}

-(NSString *)getMultipleNumber2:(NSString *)myString isAllNumber:(BOOL)isNum
{
    if ([myString isEqualToString:OVER_NONE])
    {
        if (isNum == YES)
        {
            myString = ZERO_NUM;
        }
    }
    else
    {
        myString = [myString uppercaseString];
        myString = [myString stringByReplacingOccurrencesOfString:@"X" withString:@""];
        if (myString.doubleValue <= 1)
        {
            myString = ZERO_NUM;
        }
    }
    
    return myString;
}

-(NSString *)getMultipleNumber3:(NSString *)numStr needX:(BOOL)isNeed
{
    if ([numStr isEqualToString:OVER_NONE] || numStr.doubleValue <= 1)
    {
        numStr = OVER_NONE;
    }
    else
    {
        if (isNeed == YES)
        {
            numStr = [numStr stringByAppendingString:@"X"];
        }
    }
    
    return numStr;
}

-(NSString *)conevrtTime:(NSString *)worked
{
    NSArray *array = [worked componentsSeparatedByString:@":"];
    NSString *str1 = [array objectAtIndex:0];
    NSString *str2 = [array objectAtIndex:1];
    return [NSString stringWithFormat:@"%01dh %02dm",[str1 intValue],[str2 intValue]];
}

-(NSString *)conevrtTime2:(int)totalSeconds
{
	int minutes = (totalSeconds/60)%60;
	int hours = totalSeconds/3600;

    NSString *time = [NSString stringWithFormat:@"%01dh %02dm",hours,minutes];
    
    return time;
}

-(NSString *)conevrtTime3:(int)totalSeconds
{
    int seconds = totalSeconds%60;
    int minutes = (totalSeconds/60)%60;
    int hours = totalSeconds/3600;
    
    NSString *time = [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minutes,seconds];
    
    return time;
}

/**
    将秒数转换成 小时与分钟的string, 方便显示文本
 */
-(NSString *)conevrtTime4:(int)totalSeconds
{
    int minutes = (totalSeconds/60)%60;
    int hours = totalSeconds/3600;
    
    NSString *time = [NSString stringWithFormat:@"%01d:%02d",hours,minutes];
    
    return time;
}

-(NSString *)conevrtTime5:(int)totalSeconds
{
    int seconds = totalSeconds%60;
    int minutes = (totalSeconds/60)%60;
    int hours = totalSeconds/3600;
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    
    return time;
}

-(int)getLogsWorkedTimeSecond:(NSString *)workedtimeStr
{
    NSArray *array = [workedtimeStr componentsSeparatedByString:@":"];
    NSString *str1 = [array objectAtIndex:0];
    NSString *str2 = [array objectAtIndex:1];
    int firstRow = [str1 intValue];
    int secondRow = [str2 intValue];
    
    return firstRow*3600+secondRow*60;
}

/**
    将工作的时间string与报酬的金额string放在array中。不算加班的额外工资
 */
-(NSArray *)getRoundWorkAndMoney_ByClient:(Clients *)caculateClient rate:(NSString *)rateStr totalTime:(NSString *)timeWorked totalTimeInt:(int)totalSeconds
{
    // totalSeconds = timeWorked?: nil(String)  or  (int)
    
    //获取工作的时间 秒数
    if (timeWorked != nil)
    {
        totalSeconds= [self getLogsWorkedTimeSecond:timeWorked];
    }
    
    //根据设置（不足一个小时的时间是怎么计算的），获取实际工作多少秒，
    if ([caculateClient.timeRoundTo isEqualToString:@"1 minute up"])
    {
        if (totalSeconds%60>0)
        {
            totalSeconds=totalSeconds-totalSeconds%60+60;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"1 minute down"])
    {
        if (totalSeconds%60>0)
        {
            totalSeconds=totalSeconds-totalSeconds%60;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"5 minutes up"])
    {
        if (totalSeconds%300>0)
        {
            totalSeconds=totalSeconds-totalSeconds%300+300;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"5 minutes down"])
    {
        if (totalSeconds%300>0)
        {
            totalSeconds=totalSeconds-totalSeconds%300;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"10 minutes up"])
    {
        if (totalSeconds%600>0)
        {
            totalSeconds=totalSeconds-totalSeconds%600+600;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"10 minutes down"])
    {
        if (totalSeconds%600>0)
        {
            totalSeconds=totalSeconds-totalSeconds%600;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"15 minutes up"])
    {
        if (totalSeconds%900>0)
        {
            totalSeconds=totalSeconds-totalSeconds%900+900;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"15 minutes down"])
    {
        if (totalSeconds%900>0)
        {
            totalSeconds=totalSeconds-totalSeconds%900;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"30 minutes up"])
    {
        if (totalSeconds%1800>0)
        {
            totalSeconds=totalSeconds-totalSeconds%1800+1800;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"30 minutes down"])
    {
        if (totalSeconds%1800>0)
        {
            totalSeconds=totalSeconds-totalSeconds%1800;
        }
    }
    else if ([caculateClient.timeRoundTo isEqualToString:@"1 hour up"])
    {
        if (totalSeconds%3600>0)
        {
            totalSeconds=totalSeconds-totalSeconds%3600+3600;
        }
    }
    else
    {
        if (totalSeconds%3600>0)
        {
            totalSeconds=totalSeconds-totalSeconds%3600;
        }
    }
    double rate = [rateStr doubleValue];
    double time = (double)totalSeconds/3600;
    
    
    //时间文本，小时分钟
    NSString *roundtime = [self conevrtTime4:totalSeconds];
    
    //计算金额文本
    NSString *money = [self appMoneyShowStly4:[CaculateMoney allFormularForTime:time AtRate:rate AtTax:0]];
    
    NSArray *backAarry = [[NSArray alloc] initWithObjects:money,roundtime, nil];
    
    return backAarry;
}

-(NSArray *)getAllLog
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *logsEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Logs"];
    [fetchRequest setEntity:logsEntity];
    NSArray *allresults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allresults;
}

/**
    获取所有的Client信息
 */
-(NSArray *)getAllClient
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Clients"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //搜索出来的ClientName不能包含这个字段，那这个关键字什么时候会包含？
    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientName != %@ AND (sync_status == 0)",defaultClientName];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accessDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}

-(NSArray *)getDashBoardClient
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Clients"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //搜索出来的ClientName不能包含这个字段，那这个关键字什么时候会包含？
    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientName != %@ AND (sync_status == 0 AND beginTime!=nil)",defaultClientName];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}
-(NSArray *)getAllSetting
{
    NSManagedObjectModel *model = [self managedObjectModel];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *settingsEntity = [[model entitiesByName] valueForKey:@"Settings"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:settingsEntity];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

-(NSString *)getRateByClient:(Clients *)sel_client date:(NSDate *)sel_date
{
    NSString *rate;
    if (sel_client.r_isDaily.intValue == 1)
    {
        if (sel_date == nil)
        {
            sel_date = [NSDate date];
        }
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitWeekday;
        comps = [calendar components:unitFlags fromDate:sel_date];
        int week = (int)[comps weekday];
        if (week == 1)
        {
            rate = sel_client.r_sunRate;
        }
        else if (week == 2)
        {
            rate = sel_client.r_monRate;
        }
        else if (week == 3)
        {
            rate = sel_client.r_tueRate;
        }
        else if (week == 4)
        {
            rate = sel_client.r_wedRate;
        }
        else if (week == 5)
        {
            rate = sel_client.r_thuRate;
        }
        else if (week == 6)
        {
            rate = sel_client.r_friRate;
        }
        else
        {
            rate = sel_client.r_satRate;
        }
    }
    else
    {
        rate = sel_client.ratePerHour;
    }
    
    return rate;
}

-(NSString *)appMoneyShowStly:(NSString *)_moneyStr
{
    NSString *str;
    NSString *showMoney = [self appMoneyShowStly2:_moneyStr];
    str = [NSString stringWithFormat:@"%@%@",_currencyStr,showMoney];
    
    return str;
}

-(NSString *)appMoneyShowStly2:(NSString *)_moneyStr
{
    NSNumberFormatter *moneyStly = [[NSNumberFormatter alloc] init];
    [moneyStly setNumberStyle:kCFNumberFormatterDecimalStyle];
    [moneyStly setMinimumFractionDigits:2];
    NSString *showMoney = [moneyStly stringFromNumber:[NSNumber numberWithDouble:[_moneyStr doubleValue]]];
    
    return showMoney;
}

-(NSString *)appMoneyShowStly3:(double)_moneyFloat
{
    NSString *str = [NSString stringWithFormat:@"%@%.2f",_currencyStr,_moneyFloat];
    return str;
}

-(NSString *)appMoneyShowStly4:(double)_moneyFloat
{
    NSString *str = [NSString stringWithFormat:@"%.2f",_moneyFloat];
    return str;
}

/**
    获取某个时间段内的某个client下的log数组
 */
-(NSArray *)getOverTime_Log:(Clients *)sel_client startTime:(NSDate *)start endTime:(NSDate *)end isAscendingOrder:(BOOL)_order
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *logsEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Logs"];
    [fetchRequest setEntity:logsEntity];
    
    NSPredicate *predicate;
    if (sel_client != nil && start != nil && end != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(sync_status == 0) AND (client == %@) AND (starttime >= %@) AND (starttime < %@)",sel_client,start,end];
    }
    else if (sel_client == nil && start != nil && end != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(sync_status == 0) AND (starttime >= %@) AND (starttime < %@)",start,end];
    }
    else if (sel_client !=nil && start == nil && end == nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(sync_status == 0) AND (client == %@)",sel_client];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"(sync_status == 0)"];
    }
    
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"starttime" ascending:_order];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *allresults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allresults;
    
}

/*
    获取一个数据的天加班工资与周加班工资
 */
-(NSArray *)overTimeMoney_logs:(NSArray *)logsArray
{
    double overAllMoney = 0;
    double overAllTime = 0;
    NSMutableArray *allAarry = [[NSMutableArray alloc] initWithArray:logsArray];
    
    //将数据按照log开始时间排序
    NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
    [allAarry sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    
    //移除加班免费的log
    for (int i=0; i<[allAarry count]; i++)
    {
        Logs *sel_log = [allAarry objectAtIndex:i];
        if (sel_log.overtimeFree.intValue == 1)
        {
            [allAarry removeObject:sel_log];
            i--;
        }
    }

    //day overtime
    NSMutableArray *logsArray2 = [[NSMutableArray alloc] initWithArray:allAarry];
    double overDayMoney = 0;
    double overDayTime = 0;
    
    //week overtime
    NSMutableArray *logsArray3 = [[NSMutableArray alloc] initWithArray:allAarry];
    double overWeekMoney = 0;
    double overWeekTime = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    
    //day overtime 天加班log数组 将log数组按照天分成二维数组
    {
        NSMutableArray *dayMutalArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[logsArray2 count]; i++)
        {
            NSMutableArray *dayUnitArray = [[NSMutableArray alloc] init];
            Logs *sel_log = [logsArray2 objectAtIndex:i];
            [dayUnitArray addObject:sel_log];
            
            //获取今天的最早时间与最迟时间
            NSDate *_start = nil;
            NSDate *_end = nil;
            [calendar rangeOfUnit:NSDayCalendarUnit startDate:&_start interval:NULL forDate:sel_log.starttime];
            _end = [_start dateByAddingTimeInterval:(NSTimeInterval)24*3600];
            
            //将同一天时间的数据放在dayUnitArray数组，再将dayUnitArray数组放到dayMutalArray数组中，形成二维数组
            int j;
            for (j=i+1; j<[logsArray2 count]; j++)
            {
                Logs *_log = [logsArray2 objectAtIndex:j];
                
                if ([_log.starttime compare:_start] != NSOrderedAscending && [_log.starttime compare:_end] == NSOrderedAscending)
                {
                    [dayUnitArray addObject:_log];
                }
                else
                {
                    break;
                }
            }
            i = j-1;
            
            [dayMutalArray addObject:dayUnitArray];
        }
        
        //将获取的数据 按照天分开
        for (NSMutableArray *_dayArray in dayMutalArray)
        {
            //将dayMutalArray 中的数组中的数据按照client排序 有用吗？
            NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"client.clientName" ascending:NO];
            [_dayArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
            
            for (int i=0; i<_dayArray.count; i++)
            {
                //将同一天内的log数组按照client分开
                Logs *sel_log = [_dayArray objectAtIndex:i];
                NSMutableArray *m_clientArray = [[NSMutableArray alloc] init];
                [m_clientArray addObject:sel_log];
                int j;
                for (j=i+1; j<_dayArray.count; j++)
                {
                    Logs *sel_log2 = [_dayArray objectAtIndex:j];
                    if ([sel_log.client isEqual:sel_log2.client])
                    {
                        [m_clientArray addObject:sel_log2];
                    }
                    else
                    {
                        break;
                    }
                }
                i = j-1;
                
                //计算这一天，这一个client下log的加班工资
                double dayTax1 = [self getMultipleNumber:sel_log.client.dailyOverFirstTax];
                double dayTax2 = [self getMultipleNumber:sel_log.client.dailyOverSecondTax];
                if (dayTax1 > 1 || dayTax2 > 1)
                {
                    double time = 0;
                    double rate = 0;
                    double overDayTime2 = 0;
                    double overDayMoney2 = 0;
                    
                    long all_time = 0;
                    for (Logs *sel_log in m_clientArray)
                    {
                        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
                        NSString *str1 = [array objectAtIndex:0];
                        NSString *str2 = [array objectAtIndex:1];
                        int firstRow = [str1 intValue];
                        int secondRow = [str2 intValue];
                        all_time = all_time + firstRow*3600+secondRow*60;
                    }
                    time = (double)all_time/3600;
                    
                    //获取该天的时薪
                    rate = [self getRateByClient:sel_log.client date:sel_log.starttime].doubleValue;
                    Clients *sel_client = sel_log.client;
                    int dayTime1 = sel_client.dailyOverFirstHour.intValue;
                    int dayTime2 = sel_client.dailyOverSecondHour.intValue;
                    
                    if (dayTax1 > 1)
                    {
                        if (time > dayTime1)
                        {
                            overDayMoney2 = [CaculateMoney firstFormularForTime:time ForTimeLength:dayTime1 ForMultiple:dayTax1 AtRate:rate AtTax:0];
                            overDayTime2 = time - dayTime1;
                        }
                    }
                    if (dayTax2 > 1)
                    {
                        if (time > dayTime2)
                        {
                            overDayMoney2 = overDayMoney2 + [CaculateMoney secondFormularForTime:time ForFirstTime:dayTime1 ForSecondTime:dayTime2 ForMultiple1:dayTax1 ForMultiple2:dayTax2 AtRate:rate AtTax:0];
                            overDayTime2 = overDayTime2>(time-dayTime2)?overDayTime2:(time-dayTime2);
                        }
                    }
                    overDayTime = overDayTime + overDayTime2;
                    overDayMoney = overDayMoney + overDayMoney2;
                }
                
            }
        }
        
        overDayMoney = overDayMoney<0?0:overDayMoney;
        overDayTime = overDayTime<0?0:overDayTime;
        
        long data1 = overDayTime*1000;
        data1 = data1 + 1;
        overDayTime = (double)data1;
        overDayTime = overDayTime/1000;
    }
    
    
    //week overtime
    {
        [calendar setFirstWeekday:[self getFirstDayForWeek]];
        NSMutableArray *weekMutalArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[logsArray3 count]; i++)
        {
            NSMutableArray *weekUnitArray = [[NSMutableArray alloc] init];
            Logs *sel_log = [logsArray3 objectAtIndex:i];
            [weekUnitArray addObject:sel_log];
            
            NSDate *_start = nil;
            NSDate *_end = nil;
            [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&_start interval:NULL forDate:sel_log.starttime];
            _end = [_start dateByAddingTimeInterval:(NSTimeInterval)24*3600*7];
            int j;
            for (j=i+1; j<[logsArray3 count]; j++)
            {
                Logs *_log = [logsArray3 objectAtIndex:j];
                
                if ([_log.starttime compare:_start] != NSOrderedAscending && [_log.starttime compare:_end] == NSOrderedAscending)
                {
                    [weekUnitArray addObject:_log];
                }
                else
                {
                    break;
                }
            }
            i = j-1;
            
            [weekMutalArray addObject:weekUnitArray];
        }
        
        for (NSMutableArray *_weekArray in weekMutalArray)
        {
            NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"client.clientName" ascending:NO];
            [_weekArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
            for (int i=0; i<_weekArray.count; i++)
            {
                Logs *sel_log = [_weekArray objectAtIndex:i];
                NSMutableArray *m_clientArray = [[NSMutableArray alloc] init];
                [m_clientArray addObject:sel_log];
                int j;
                for (j=i+1; j<_weekArray.count; j++)
                {
                    Logs *sel_log2 = [_weekArray objectAtIndex:j];
                    if ([sel_log.client isEqual:sel_log2.client])
                    {
                        [m_clientArray addObject:sel_log2];
                    }
                    else
                    {
                        break;
                    }
                }
                i = j-1;
                
                double weekTax1 = [self getMultipleNumber:sel_log.client.weeklyOverFirstTax];
                double weekTax2 = [self getMultipleNumber:sel_log.client.weeklyOverSecondTax];
                if (weekTax1 > 1 || weekTax2 > 1)
                {
                    double time = 0;
                    double rate = 0;
                    double overWeekTime2 = 0;
                    double overWeekMoney2 = 0;
                    
                    long all_time = 0;
                    for (Logs *sel_log in m_clientArray)
                    {
                        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
                        NSString *str1 = [array objectAtIndex:0];
                        NSString *str2 = [array objectAtIndex:1];
                        int firstRow = [str1 intValue];
                        int secondRow = [str2 intValue];
                        all_time = all_time + firstRow*3600+secondRow*60;
                    }
                    time = (double)all_time/3600;
                    
                    Clients *sel_client = sel_log.client;
                    rate = sel_client.r_weekRate.doubleValue;
                    int weekTime1 = sel_client.weeklyOverFirstHour.intValue;
                    int weekTime2 = sel_client.weeklyOverSecondHour.intValue;
                    
                    if (weekTax1 > 1)
                    {
                        if (time > weekTime1)
                        {
                            overWeekMoney2 = [CaculateMoney firstFormularForTime:time ForTimeLength:weekTime1 ForMultiple:weekTax1 AtRate:rate AtTax:0];
                            overWeekTime2 = time - weekTime1;
                        }
                    }
                    if (weekTax2 > 1)
                    {
                        if (time > weekTime2)
                        {
                            overWeekMoney2 = overWeekMoney2 + [CaculateMoney secondFormularForTime:time ForFirstTime:weekTime1 ForSecondTime:weekTime2 ForMultiple1:weekTax1 ForMultiple2:weekTax2 AtRate:rate AtTax:0];
                            overWeekTime2 = overWeekTime2>(time-weekTime2)?overWeekTime2:(time-weekTime2);
                        }
                    }
                    overWeekTime = overWeekTime + overWeekTime2;
                    overWeekMoney = overWeekMoney + overWeekMoney2;
                }
                
            }
        }
        
        overWeekMoney = overWeekMoney<0?0:overWeekMoney;
        overWeekTime = overWeekTime<0?0:overWeekTime;
        
        long data1 = overWeekTime*1000;
        data1 = data1 + 1;
        overWeekTime = (double)data1;
        overWeekTime = overWeekTime/1000;
    }
    
    
    overAllTime = overDayTime + overWeekTime;
    overAllMoney = overDayMoney + overWeekMoney;
    
    NSNumber *back_money = [NSNumber numberWithDouble:overAllMoney];
    NSNumber *back_time = [NSNumber numberWithDouble:overAllTime];
    NSArray *backAarry = [[NSArray alloc] initWithObjects:back_money,back_time, nil];
    
    return backAarry;
}

-(NSArray *)overTimeMoney_Clients:(Clients *)client totalTime:(int)totalTime rate:(NSString *)rateStr
{
    double overAllTime = 0;
    double overAllMoney = 0;
    double overDayTime = 0;
    double overDayMoney = 0;
    
    //获取加班工资的倍数
    float dayTax1 = [self getMultipleNumber:client.dailyOverFirstTax];
    float dayTax2 = [self getMultipleNumber:client.dailyOverSecondTax];
    
    if (dayTax1 > 1 || dayTax2 > 1)
    {
        double time = 0;
        double rate = 0;
        double overDayTime2 = 0;
        double overDayMoney2 = 0;

        //总共工作的时间
        time = totalTime/3600;
        //每小时的报酬
        rate = [rateStr doubleValue];
        
        //工作多长时间算加班
        int dayTime1 = client.dailyOverFirstHour.intValue;
        int dayTime2 = client.dailyOverSecondHour.intValue;
        
        //加班1
        if (dayTax1 > 1)
        {
            if (time > dayTime1)
            {
                overDayMoney2 = [CaculateMoney firstFormularForTime:time ForTimeLength:dayTime1 ForMultiple:dayTax1 AtRate:rate AtTax:0];
                overDayTime2 = time - dayTime1;
            }
        }
        if (dayTax2 > 1)
        {
            if (time > dayTime2)
            {
                overDayMoney2 = overDayMoney2 + [CaculateMoney secondFormularForTime:time ForFirstTime:dayTime1 ForSecondTime:dayTime2 ForMultiple1:dayTax1 ForMultiple2:dayTax2 AtRate:rate AtTax:0];
                overDayTime2 = overDayTime2>(time-dayTime2)?overDayTime2:(time-dayTime2);
            }
        }
        overDayTime = overDayTime + overDayTime2;
        overDayMoney = overDayMoney + overDayMoney2;
    }
    overDayMoney = overDayMoney<0?0:overDayMoney;
    overDayTime = overDayTime<0?0:overDayTime;

    
    //week overtime
    double overWeekMoney = 0;
    double overWeekTime = 0;
    
    double weekTax1 = [self getMultipleNumber:client.weeklyOverFirstTax];
    double weekTax2 = [self getMultipleNumber:client.weeklyOverSecondTax];
    if (weekTax1 > 1 || weekTax2 > 1)
    {
        double time = 0;
        double rate = 0;
        double overWeekTime2 = 0;
        double overWeekMoney2 = 0;
        
        
        time = totalTime/3600;
        rate = client.r_weekRate.doubleValue;
        int weekTime1 = client.weeklyOverFirstHour.intValue;
        int weekTime2 = client.weeklyOverSecondHour.intValue;
        
        if (weekTax1 > 1)
        {
            if (time > weekTime1)
            {
                overWeekMoney2 = [CaculateMoney firstFormularForTime:time ForTimeLength:weekTime1 ForMultiple:weekTax1 AtRate:rate AtTax:0];
                overWeekTime2 = time - weekTime1;
            }
        }
        if (weekTax2 > 1)
        {
            if (time > weekTime2)
            {
                overWeekMoney2 = overWeekMoney2 + [CaculateMoney secondFormularForTime:time ForFirstTime:weekTime1 ForSecondTime:weekTime2 ForMultiple1:weekTax1 ForMultiple2:weekTax2 AtRate:rate AtTax:0];
                overWeekTime2 = overWeekTime2>(time-weekTime2)?overWeekTime2:(time-weekTime2);
            }
        }
        overWeekTime = overWeekTime + overWeekTime2;
        overWeekMoney = overWeekMoney + overWeekMoney2;
    }
    overWeekMoney = overWeekMoney<0?0:overWeekMoney;
    overWeekTime = overWeekTime<0?0:overWeekTime;
    
    overAllTime = overDayTime + overWeekTime;
    overAllMoney = overDayMoney + overWeekMoney;
    
    NSNumber *back_money = [NSNumber numberWithDouble:overAllMoney];
    NSNumber *back_time = [NSNumber numberWithDouble:overAllTime];
    NSArray *backAarry = [[NSArray alloc] initWithObjects:back_money,back_time, nil];
    return backAarry;
}

-(void)customFingerMove:(UIViewController *)_contor canMove:(BOOL)_isMove isBottom:(BOOL)_isBottom
{
    //只有phone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        //支不支持手势
        if ([_contor.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            _contor.navigationController.interactivePopGestureRecognizer.enabled = _isMove;
            if (_isBottom == YES)
            {
                _contor.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)_contor;
            }
        }
    }
}

-(UIImage*)m_imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





/*
-(void)databaseRollback
{
    NSManagedObjectContext* nowcontext = self.managedObjectContext;
    [nowcontext rollback];
}
*/

//纠正错误数据
-(void)overTimeInitData
{
    NSMutableArray *allLogs = [[NSMutableArray alloc] init];
    [allLogs addObjectsFromArray:[self getOverTime_Log:nil startTime:nil endTime:nil isAscendingOrder:NO]];
    
    for (Logs *sel_log in allLogs)
    {
        NSArray *array = [sel_log.worked componentsSeparatedByString:@":"];
        NSString *str1 = [array objectAtIndex:0];
        NSString *str2 = [array objectAtIndex:1];
        int firstRow = [str1 intValue];
        int secondRow = [str2 intValue];
        double time = (double)(firstRow*3600+secondRow*60)/3600;
        double rate = [sel_log.ratePerHour doubleValue];
        NSString *money = [self appMoneyShowStly4:time*rate];
        
        if (![money isEqualToString:sel_log.totalmoney])
        {
            sel_log.totalmoney = money;
            sel_log.accessDate = [NSDate date];
        }
    }
}

/*
-(void)removeRubinshData
{
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
    NSEntityDescription *logsEntity3 = [[self.managedObjectModel entitiesByName] valueForKey:@"Invoice"];
    [fetchRequest3 setEntity:logsEntity3];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"client == %@",nil];
    [fetchRequest3 setPredicate:predicate3];
    NSArray *allresults3 = [self.managedObjectContext executeFetchRequest:fetchRequest3 error:nil];
    
    for (Invoice *sel_inv in allresults3)
    {
        for (Logs *sel_log in [sel_inv.logs allObjects])
        {
            if (sel_log.starttime != nil)
            {
                sel_log.isInvoice = [NSNumber numberWithBool:NO];
                [sel_log removeInvoiceObject:sel_inv];
                sel_log.accessDate = [NSDate date];
                sel_log.invoice_uuid = nil;
            }
            else
            {
                [self.managedObjectContext deleteObject:sel_log];
            }
        }
        
        [self.managedObjectContext deleteObject:sel_inv];
    }
    
    
    NSFetchRequest *fetchRequest4 = [[NSFetchRequest alloc] init];
    NSEntityDescription *logsEntity4 = [[self.managedObjectModel entitiesByName] valueForKey:@"Invoiceproperty"];
    [fetchRequest4 setEntity:logsEntity4];
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"invoice == %@",nil];
    [fetchRequest4 setPredicate:predicate4];
    NSArray *allresults4 = [self.managedObjectContext executeFetchRequest:fetchRequest4 error:nil];
    
    for (Invoiceproperty *sel_invPerty in allresults4)
    {
        [self.managedObjectContext deleteObject:sel_invPerty];
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *logsEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Logs"];
    [fetchRequest setEntity:logsEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"client == %@",nil];
    [fetchRequest setPredicate:predicate];
    NSArray *allresults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (Logs *sel_log in allresults)
    {
        [self.managedObjectContext deleteObject:sel_log];
    }
    
    
    [self saveContext];
}
*/

/**
    获取该Client下state为0的log
 */
-(NSMutableArray *)removeAlready_DeleteLog:(NSArray *)logArray;
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (Logs *sel_log in logArray)
    {
        if (sel_log.sync_status != nil && sel_log.sync_status.integerValue == 0)
        {
            [returnArray addObject:sel_log];
        }
    }
    
    return returnArray;
}


-(NSMutableArray *)removeAlready_DeleteInv:(NSArray *)invArray
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (Invoice *sel_inv in invArray)
    {
        if (sel_inv.sync_status != nil && sel_inv.sync_status.integerValue == 0)
        {
            [returnArray addObject:sel_inv];
        }
    }
    
    return returnArray;
}

/*
    保留数组中没有被删除的invoiceproperty
 */
-(NSMutableArray *)removeAlready_DeleteInvpty:(NSArray *)invptyArray
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (Invoiceproperty *sel_invpty in invptyArray)
    {
        if (sel_invpty.sync_status != nil && sel_invpty.sync_status.integerValue == 0)
        {
            [returnArray addObject:sel_invpty];
        }
    }
    
    return returnArray;
}

-(NSString *)getUuid
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    return (__bridge NSString *)string;
}

- (void)initData_forSyncDropbox
{
    
    // sync_status   0: update||add;  1: delete;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *tableEntity;
    
    
    tableEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Clients"];
    [fetchRequest setEntity:tableEntity];
    NSArray *client_results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (Clients *sel_client in client_results)
    {
        if (sel_client.uuid == nil)
        {
            sel_client.uuid = [self getUuid];
        }
        if (sel_client.sync_status == nil)
        {
            sel_client.sync_status = [NSNumber numberWithInt:0];
        }
        if (sel_client.accessDate == nil)
        {
            sel_client.accessDate = [NSDate date];
        }
    }
    
    
    
    
    tableEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Invoice"];
    [fetchRequest setEntity:tableEntity];
    NSArray *invoice_results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (Invoice *sel_invoice in invoice_results)
    {
        if (sel_invoice.uuid == nil)
        {
            sel_invoice.uuid = [self getUuid];
        }
        if (sel_invoice.sync_status == nil)
        {
            sel_invoice.sync_status = [NSNumber numberWithInt:0];
        }
        if (sel_invoice.accessDate == nil)
        {
            sel_invoice.accessDate = [NSDate date];
        }
        if (sel_invoice.client != nil)
        {
            sel_invoice.parentUuid = sel_invoice.client.uuid;
        }
    }
    
    
    
    
    tableEntity = [[self.managedObjectModel entitiesByName] valueForKey:@"Logs"];
    [fetchRequest setEntity:tableEntity];
    NSArray *log_results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (Logs *sel_log in log_results)
    {
        if (sel_log.uuid == nil)
        {
            sel_log.uuid = [self getUuid];
        }
        if (sel_log.sync_status == nil)
        {
            sel_log.sync_status = [NSNumber numberWithInt:0];
        }
        if (sel_log.accessDate == nil)
        {
            sel_log.accessDate = [NSDate date];
        }
        if (sel_log.client != nil)
        {
            sel_log.client_Uuid = sel_log.client.uuid;
        }
        if ([[sel_log.invoice allObjects] count] > 0)
        {
            Invoice *sel_invoice = [[sel_log.invoice allObjects] objectAtIndex:0];
            if (sel_invoice != nil)
            {
                sel_log.invoice_uuid = sel_invoice.uuid;
            }
        }
    }
}


- (void)upgradeDatabase_isMust:(BOOL)flag
{
    //版本升级内容 ----------------------------------------------------
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    
    NSString *versionFlag = [NSString stringWithFormat:@"UpdateApplicationComplete2%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    //是不是还原过来的。UpdateApplicationComplete2 带这个标记的都是后期更新的dropbox的
    if (![defaults2 valueForKey:versionFlag] || flag == YES)
    {

        //2.6
        if (self.appSetting.istouchid == nil || self.appSetting.istouchid.intValue != 2)
        {
            self.appSetting.istouchid = [NSNumber numberWithInteger:0];
        }
        
        //log
        NSMutableArray *allLogs = [[NSMutableArray alloc] init];
        [allLogs addObjectsFromArray:[self getAllLog]];
        for (Logs *log_sel in allLogs)
        {
            if (log_sel.invoice != nil && [[log_sel.invoice allObjects] count] >0)
            {
                Invoice *sel_invoice = [[log_sel.invoice allObjects] objectAtIndex:0];
                if (sel_invoice != nil)
                {
                    if ([sel_invoice.balanceDue doubleValue] <= 0)
                    {
                        if (log_sel.isPaid == nil)
                        {
                            log_sel.isPaid = [NSNumber numberWithInt:1];
                        }
                    }
                    else
                    {
                        if (log_sel.isPaid == nil)
                        {
                            log_sel.isPaid = [NSNumber numberWithInt:0];
                        }
                    }
                }
            }
            else
            {
                if (log_sel.isPaid == nil)
                {
                    log_sel.isPaid = [NSNumber numberWithInt:0];     // 0:unpaid; 1:paid;
                }
            }
        }
        
        //client
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
        NSEntityDescription *logsEntity2 = [[self.managedObjectModel entitiesByName] valueForKey:@"Clients"];
        [fetchRequest2 setEntity:logsEntity2];
        NSArray *allresults2 = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:nil];
        NSMutableArray *allClients = [[NSMutableArray alloc] init];
        [allClients addObjectsFromArray:allresults2];
        for (Clients *client_sel  in allClients)
        {
            if (client_sel.payPeriodStly == nil || [client_sel.payPeriodStly intValue] < 1 || [client_sel.payPeriodStly intValue] > 6)
            {
                client_sel.payPeriodStly = [NSNumber numberWithInt:1];     // 1:weekly; 2:bi-weekly; 3:semi-monthly; 4:monthly; 5:every four weeks;6:quarterly;
            }
            
            if (client_sel.payPeriodNum1 == nil || [client_sel.payPeriodNum1 intValue] < 1 || [client_sel.payPeriodNum1 intValue] > 30)
            {
                client_sel.payPeriodNum1 = [NSNumber numberWithInt:1];     // 1~30;
            }
            
            if (client_sel.payPeriodNum2 == nil || [client_sel.payPeriodNum2 intValue] < 2 || [client_sel.payPeriodNum2 intValue] > 31)
            {
                client_sel.payPeriodNum2 = [NSNumber numberWithInt:31];     // 2~31;
            }
            
            //2.6 updata
            if (client_sel.r_weekRate == nil)
            {
                if (client_sel.r_isDaily.intValue == 1 || client_sel.r_monRate != nil)
                {
                    double all = 0;
                    all = client_sel.r_monRate.doubleValue + client_sel.r_tueRate.doubleValue + client_sel.r_wedRate.doubleValue + client_sel.r_thuRate.doubleValue + client_sel.r_friRate.doubleValue + client_sel.r_satRate.doubleValue + client_sel.r_sunRate.doubleValue;
                    all = all/7;
                    client_sel.r_weekRate = [self appMoneyShowStly4:all];
                }
                else
                {
                    client_sel.r_weekRate = client_sel.ratePerHour;
                }
            }
            
            if (client_sel.dailyOverFirstTax == nil || [client_sel.dailyOverFirstTax isEqualToString:@"1.00"] || client_sel.dailyOverFirstTax.doubleValue < 1)
            {
                client_sel.dailyOverFirstTax = OVER_NONE;
            }
            if (client_sel.dailyOverSecondTax == nil || [client_sel.dailyOverSecondTax isEqualToString:@"1.00"] || client_sel.dailyOverSecondTax.doubleValue < 1)
            {
                client_sel.dailyOverSecondTax = OVER_NONE;
            }
            if (client_sel.weeklyOverFirstTax == nil || [client_sel.weeklyOverFirstTax isEqualToString:@"1.00"] || client_sel.weeklyOverFirstTax.doubleValue < 1)
            {
                client_sel.weeklyOverFirstTax = OVER_NONE;
            }
            if (client_sel.weeklyOverSecondTax == nil || [client_sel.weeklyOverSecondTax isEqualToString:@"1.00"] || client_sel.weeklyOverSecondTax.doubleValue < 1)
            {
                client_sel.weeklyOverSecondTax = OVER_NONE;
            }
        }
        
        //invoice
        NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
        NSEntityDescription *logsEntity3 = [[self.managedObjectModel entitiesByName] valueForKey:@"Invoice"];
        [fetchRequest3 setEntity:logsEntity3];
        NSArray *allresults3 = [self.managedObjectContext executeFetchRequest:fetchRequest3 error:nil];
        NSMutableArray *allInvoice = [[NSMutableArray alloc] init];
        [allInvoice addObjectsFromArray:allresults3];
        for (Invoice *invoice_sel  in allInvoice)
        {
            if ([invoice_sel.totalDue doubleValue] < 0)
            {
                invoice_sel.totalDue = ZERO_NUM;
            }
        }

        //设置uuid state
        [self initData_forSyncDropbox];
        [self overTimeInitData];
        
        if ([self.appSetting.currency isEqualToString:@"SL Re - Sri Lanka Rupee"])
        {
            self.appSetting.currency = @"SLR - Sri Lanka Rupee";
        }
        
        [self saveContext];
        
        [defaults2 setValue:@"YES" forKey:versionFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //放在这里写打开应用的时候会反映很慢
        //是还原，强制把本地数据同步到云端。当用户还原的时候，再次打开应用但是没有登陆parse账号的时候，就不执行还原操作。
        PFUser *currentUset = [PFUser currentUser];
        if(flag && currentUset!=nil && [currentUset.username length]>0 && currentUset.username != nil)
        {
            //将服务器端所有数据删除
//            [self.parseSync deleteAllDataonParse];
            
            //还原的时候 默认是有网络的
            //new version -> parse
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
            PFObject *profile = [appDelegate.parseSync fetchServerProfile];
            if (profile != nil)
            {
                NSString *newDatabaseVersion = [appDelegate getUuid];
                [profile setObject:newDatabaseVersion forKey:DATABASE_VERSION];
                [profile save];
                
                //new version - >local
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:newDatabaseVersion forKey: DATABASE_VERSION];
                [userDefault synchronize];
            }
            
            appDelegate.appSetting.lastUser = nil;
            [self.parseSync saveAllLocalDatatoParse];
        }

    }
    
    
    //-------------------------------------------------------------------
}


- (void)closeModalView
{
    if (self.close_PopView != nil)
    {
        if ([self.close_PopView isKindOfClass:[UIActionSheet class]])
        {
            UIActionSheet *actionView = (UIActionSheet *)self.close_PopView;
            [actionView dismissWithClickedButtonIndex:actionView.cancelButtonIndex animated:NO];
            
            if (self.appMailController != nil)
            {
                [self.appMailController dismissViewControllerAnimated:NO completion:nil];
                self.appMailController = nil;
            }
            
            isCanBreak = 1;
        }
        else if ([self.close_PopView isKindOfClass:[UIAlertView class]])
        {
            UIAlertView *alertView = (UIAlertView *)self.close_PopView;
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
            
            isCanBreak = 1;
        }
        
        self.close_PopView = nil;
    }
}


/**
    获取log支付的最早时间以及最迟时间
 */
-(void)getPayPeroid_selClient:(Clients *)sel_client payPeroidDate:(NSDate *)sel_dueDate backStartDate:(NSDate **)startDate backEndDate:(NSDate **)endDate
{
    // payPeriodStly -------  1:weekly(sunday:1--saturday:7); 2:bi-weekly; 3:semi-monthly; 4:monthly; 5:every four weeks; 6:quarterly;
    // payPeriodNum1 -------  1~30;
    // payPeriodNum2 -------  2~31;
    // payPeriodDate ------- 选择的结束日期；
    
    
    int payPeriodStly = [sel_client.payPeriodStly intValue];
    int payPeriodNum1 = [sel_client.payPeriodNum1 intValue];
    int payPeriodNum2 = [sel_client.payPeriodNum2 intValue];
    NSDate *payPeriodDate = sel_client.payPeriodDate;
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //Weekly
    if (payPeriodStly == 1)
    {
        payPeriodNum1 = payPeriodNum1%7+1;
        [calendar setFirstWeekday:payPeriodNum1];
        //获取编辑log时间的这一周的第一天
        [calendar rangeOfUnit:NSWeekCalendarUnit startDate:startDate interval:nil forDate:sel_dueDate];
        NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        //获取这周的最后一天
        [componentsToSub setDay:6];
        *endDate = [calendar dateByAddingComponents:componentsToSub toDate:*startDate options:0];
        
        return;
    }
    //Bi-Weekly 双周
    else if (payPeriodStly == 2)
    {
        NSDate *compareDate1;
        //获取该client开始支付时间
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate1 interval:NULL forDate:payPeriodDate];
		NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:-13];
        NSDate *payPeriodStartDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        
        //编辑log当天最早时间
        NSDate *compareDate2;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate2 interval:NULL forDate:sel_dueDate];
        
        NSTimeInterval interval_compare = [compareDate2 timeIntervalSinceDate:payPeriodStartDate];
        //如果log编辑时间比client开始支付时间迟两个星期的多少倍
        int baseNum = (int)interval_compare/(14*24*3600);
        if (interval_compare < 0)
        {
            baseNum--;
        }
        //在两个星期之内
        if (baseNum == 0)
        {
            *startDate = payPeriodStartDate;
            *endDate = compareDate1;
        }
        else
        {
            //如果不在两个星期之内，将开始时间往前挪或者往后挪
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:14*baseNum];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:payPeriodStartDate options:0];
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:13];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:*startDate options:0];;
        }
        
        return;
    }
    //一个月两次
    else if (payPeriodStly == 3)
    {
        int payPeriodNum11;
        int payPeriodNum22;
        NSDate *oneDate;
        NSDate *secondeDate;
        int monthDayNum;
        //第一个时间段有多少天
        NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        
        //月开始
        NSDate *compareDate1;
        [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&compareDate1 interval:NULL forDate:sel_dueDate];
        //该月总天数
        monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
        payPeriodNum22 = monthDayNum<payPeriodNum2?monthDayNum:payPeriodNum2;
        payPeriodNum11 = payPeriodNum22<=payPeriodNum1?payPeriodNum22-1:payPeriodNum1;
        
        
        componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:payPeriodNum11-1];
        //tmp第一个截止时间
        oneDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        //第二个时间段有多少天
        componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:payPeriodNum22-1];
        //tmp第二个截止时间
        secondeDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        //log当天开始
        NSDate *compareDate2;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate2 interval:NULL forDate:sel_dueDate];
        
        //属于月第一个时间段
        if ([oneDate compare:compareDate2] != NSOrderedAscending)
        {
            *endDate = oneDate;
            
            //compareDate1上一个月初开始
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setMonth:-1];
            compareDate1 = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
            monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
            payPeriodNum22 = monthDayNum<payPeriodNum2?monthDayNum:payPeriodNum2;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:payPeriodNum22];
            
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        }
        //属于月第二个结束时间段
        else if ([secondeDate compare:compareDate2] != NSOrderedAscending)
        {
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:1];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:oneDate options:0];
            *endDate = secondeDate;
        }
        else
        {
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:1];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:secondeDate options:0];
            
            //compareDate1下一个月初
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setMonth:1];
            compareDate1 = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
            //下个月天数
            monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
            payPeriodNum22 = monthDayNum<payPeriodNum2?monthDayNum:payPeriodNum2;
            payPeriodNum11 = payPeriodNum22<=payPeriodNum1?payPeriodNum22-1:payPeriodNum1;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:payPeriodNum11-1];
            
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        }
        
        
        return;
    }
    //monthly
    else if (payPeriodStly == 4)
    {
        //月初
        NSDate *compareDate1;
        [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&compareDate1 interval:NULL forDate:sel_dueDate];
        
        int monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
        monthDayNum = monthDayNum<payPeriodNum1?monthDayNum:payPeriodNum1;
        
        //月尾
        NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:monthDayNum-1];
        *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        
        //当天开始时间
        NSDate *compareDate3;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate3 interval:NULL forDate:sel_dueDate];
        if ([*endDate compare:compareDate3] == NSOrderedAscending)
        {
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:1];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:*endDate options:0];
            
            
            NSDate *compareDate2;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setMonth:1];
            compareDate2 = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
            monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate2].length;
            monthDayNum = monthDayNum<payPeriodNum1?monthDayNum:payPeriodNum1;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:monthDayNum-1];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate2 options:0];
        }
        else
        {
            NSDate *compareDate2;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setMonth:-1];
            compareDate2 = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
            monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate2].length;
            monthDayNum = monthDayNum<payPeriodNum1?monthDayNum:payPeriodNum1;
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:monthDayNum];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate2 options:0];
        }
        
        return;
    }
    else if (payPeriodStly == 5)
    {
        NSDate *compareDate1;      //当天开始时间
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate1 interval:NULL forDate:payPeriodDate];
        NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:-27];
        NSDate *payPeriodStartDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        
        NSDate *compareDate2;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate2 interval:NULL forDate:sel_dueDate];
        
        NSTimeInterval interval_compare = [compareDate2 timeIntervalSinceDate:payPeriodStartDate];
        int baseNum = (int)interval_compare/(28*24*3600);
        if (interval_compare < 0)
        {
            baseNum--;
        }
        if (baseNum == 0)
        {
            *startDate = payPeriodStartDate;
            *endDate = compareDate1;
        }
        else
        {
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:28*baseNum];
            *startDate = [calendar dateByAddingComponents:componentsToSub toDate:payPeriodStartDate options:0];
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:27];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:*startDate options:0];;
        }
        
        return;
    }
    else if (payPeriodStly == 6)
    {
        int month = 3;
        
        NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:payPeriodDate];
        int payPeriodNum3 = (int)[components day];
        
        NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
        NSDate *tempPeriodDate;
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&tempPeriodDate interval:NULL forDate:payPeriodDate];
        
        NSDate *compareDate3;    //当天开始时间
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&compareDate3 interval:NULL forDate:sel_dueDate];
        
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:compareDate3 toDate:tempPeriodDate options:0];
        
        int conut1 = comps.month%month;
        if ([compareDate3 compare:tempPeriodDate] == NSOrderedDescending)
        {
            conut1 = month - 1 + conut1;
        }
        
        {
            //得到当月差距的那天
            NSDate *compareDate1;       //月初
            [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&compareDate1 interval:NULL forDate:sel_dueDate];
            
            int monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
            monthDayNum = monthDayNum<payPeriodNum3?monthDayNum:payPeriodNum3;
            
            NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:monthDayNum-1];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        }
        
        if ([*endDate compare:compareDate3] == NSOrderedAscending)
        {
            componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setMonth:1];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:*endDate options:0];
            
            //得到当月差距的那天
            NSDate *compareDate1;       //月初
            [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&compareDate1 interval:NULL forDate:*endDate];
            
            int monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
            monthDayNum = monthDayNum<payPeriodNum3?monthDayNum:payPeriodNum3;
            
            NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:monthDayNum-1];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
        }
        else if ([*endDate compare:compareDate3] == NSOrderedSame)
        {
            conut1 = 0;
        }
        
        componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setMonth:conut1];
        *endDate = [calendar dateByAddingComponents:componentsToSub toDate:*endDate options:0];
        {
            //得到当月差距的那天
            NSDate *compareDate1;       //月初
            [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&compareDate1 interval:NULL forDate:*endDate];
            
            int monthDayNum = (int)[calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:compareDate1].length;
            monthDayNum = monthDayNum<payPeriodNum3?monthDayNum:payPeriodNum3;
            
            NSDateComponents *componentsToSub = [[NSDateComponents alloc] init];
            [componentsToSub setDay:monthDayNum-1];
            *endDate = [calendar dateByAddingComponents:componentsToSub toDate:compareDate1 options:0];
            
            [calendar rangeOfUnit:NSCalendarUnitDay startDate:endDate interval:NULL forDate:*endDate];
        }
        
        
        componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setMonth:-month];
        *startDate = [calendar dateByAddingComponents:componentsToSub toDate:*endDate options:0];
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:startDate interval:NULL forDate:*startDate];
        componentsToSub = [[NSDateComponents alloc] init];
        [componentsToSub setDay:1];
        *startDate = [calendar dateByAddingComponents:componentsToSub toDate:*startDate options:0];
        
        
        return;
    }
}


-(int)getFirstDayForWeek
{
    int firstWeekday = 1;
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    if ([defaults2 integerForKey:@"CalendarDateStly"])
    {
        firstWeekday = (int)[defaults2 integerForKey:@"CalendarDateStly"];
    }
    return firstWeekday;
}

-(UIColor *)getOverTimeText_Color:(NSString *)str
{
    if (![str isEqualToString:OVER_NONE] && str.doubleValue < 1)
    {
        return over_noUseColor;
    }
    else
    {
        return over_UseColor;
    }
}

-(void)loadHMJIndicator
{
    _hmjIndicator = [[HMJActivityIndicator alloc]initWithFrame:CGRectMake((self.window.frame.size.width-100)/2, (self.window.frame.size.height-100)/2, 100, 100)];
    [self.window addSubview:self.hmjIndicator];
    self.hmjIndicator.hidden = YES;
}

-(void)showIndicator
{
    self.hmjIndicator.hidden = NO;
    [self.window bringSubviewToFront:self.hmjIndicator];
    self.window.userInteractionEnabled = NO;
    [self.hmjIndicator.indicator startAnimating];
}

-(void)hideIndicator
{
    self.hmjIndicator.hidden = YES;
    self.window.userInteractionEnabled = YES;
    [self.hmjIndicator.indicator stopAnimating];
}




#pragma mark -
#pragma mark 免费版代码

-(void)doInit_Lite
{
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    
    if ([defaults2 integerForKey:LITE_UNLOCK_FLAG])
    {
        self.isPurchased = YES;
    }
    else
    {
        self.lite_Purchase = [[EBPurchase alloc] init];
        self.lite_Purchase.delegate = self;
        self.isPurchased = NO;
    }
    
    
    if (self.isPurchased == NO)
    {
        if (![defaults2 integerForKey:NEED_SHOW_LITE_ADV_FLAG])
        {
            NSArray *allresults2 = [self getAllLog];
            
            if ([allresults2 count] > 0)
            {
                [defaults2 setInteger:1 forKey:NEED_SHOW_LITE_ADV_FLAG];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.lite_adv = YES;
            }
            else
            {
                self.lite_adv = NO;
            }
        }
        else
        {
            self.lite_adv = YES;
        }
    }
}

/**
    内购事件
 */
-(void)doPurchase_Lite
{
    [self showActiviIndort];
    
    //有商品，去购买
    if (self.lite_Purchase.validProduct != nil)
    {
        if (![self.lite_Purchase purchaseProduct:self.lite_Purchase.validProduct])
        {
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
            
            self.close_PopView = settingsAlert;
            
        }
    }
    //如果没有有效的商品就重新去获取商品
    else
    {
        [self.lite_Purchase requestProduct:SUB_PRODUCT_ID];
    }
}

-(void)doRePurchase_Lite
{
    [self showActiviIndort];
    
    if (![self.lite_Purchase restorePurchase])
    {
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
        
        self.close_PopView = settingsAlert;
        
    }
}


-(void)popUnLock_Notificat
{
    [self hideActiviIndort];
}



////////  EBPurchaseDelegate Methods

//显示商品信息回调
-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    if (productPrice != nil)
    {
        if (self.lite_Purchase.validProduct != nil)
        {
            //如果购买商品失败
            if (![self.lite_Purchase purchaseProduct:self.lite_Purchase.validProduct])
            {
                UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [settingsAlert show];
                
                self.close_PopView = settingsAlert;
                
                
                [self hideActiviIndort];
            }
        }
        
        NSLog(@"%@",productPrice);
    }
    else
    {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"Network error, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
        
        self.close_PopView = unavailAlert;
        
        
        [self hideActiviIndort];
    }
}



-(void) successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");
    
    if (self.isPurchased == NO)
    {
        self.isPurchased = YES;
        
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        [defaults2 setInteger:1 forKey:LITE_UNLOCK_FLAG];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_Group];
            [sharedUserDefaults setInteger:1 forKey:LITE_UNLOCK_FLAG];
            [sharedUserDefaults synchronize];
        }

        
        [self hideActiviIndort];
        
        if (!ISPAD)
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            [appDelegate.mainViewController.settingVC pop_system_UnlockLite];
            [appDelegate.mainViewController.dashBoardVC pop_system_UnlockLite];
//            [appDelegate.mainViewController.clientsVC pop_system_UnlockLite];
            [appDelegate.mainViewController.invoiceVC pop_system_UnlockLite];
            [appDelegate.mainViewController.payPeriodVC pop_system_UnlockLite];
            [appDelegate.mainViewController.reportVC pop_system_UnlockLite];
            
        }
        else
        {
            AppDelegate_iPad *appDelegate_Pad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            if(appDelegate_Pad.mainView.leftViewController != nil)
            {
                [appDelegate_Pad.mainView.leftViewController pop_system_UnlockLite];
                if (appDelegate_Pad.mainView.leftViewController.startTimeController !=nil)
                {
                    [appDelegate_Pad.mainView.leftViewController.startTimeController pop_system_UnlockLite];
                }
            }
        
            if (appDelegate_Pad.mainView.settingView != nil)
            {
                [appDelegate_Pad.mainView.settingView pop_system_UnlockLite];
            }
        }
        
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Your purhase was successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
        
        self.close_PopView = updatedAlert;
        
    }
    
    [self hideActiviIndort];
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedPurchase");
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    self.close_PopView = failedAlert;
    
    
    [self hideActiviIndort];
}

-(void) incompleteRestore:(EBPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    
    self.close_PopView = restoreAlert;
    
    
    [self hideActiviIndort];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    self.close_PopView = failedAlert;
    
    
    [self hideActiviIndort];
}



#pragma mark -
#pragma mark widget
//将数据库从本地搬到shared区域
-(void)copyDatabase_location_to_widget
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory =[self applicationDocumentsDirectory_location].relativePath;
    NSString *resourcePath =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
    NSString *resourcePath2 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
    NSString *resourcePath3 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
    
    NSString *targetStr = self.applicationDocumentsDirectory_widget.relativePath;
    NSString *dataPath =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
    NSString *dataPath2 =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
    NSString *dataPath3 =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];

    
    if (dataPath) {
        [fileManager removeItemAtPath:dataPath error:&error];
    }
    if (dataPath2) {
        [fileManager removeItemAtPath:dataPath2 error:&error];
    }
    if (dataPath3) {
        [fileManager removeItemAtPath:dataPath3 error:&error];
    }
    if (resourcePath && dataPath) {
        [fileManager copyItemAtPath:resourcePath toPath:dataPath error:&error];
    }
    if (resourcePath2 && dataPath2) {
        [fileManager copyItemAtPath:resourcePath2 toPath:dataPath2 error:&error];
    }
    if (resourcePath3 && dataPath3) {
        [fileManager copyItemAtPath:resourcePath3 toPath:dataPath3 error:&error];
    }
    if (resourcePath) {
        [fileManager removeItemAtPath:resourcePath error:&error];
    }
    if (resourcePath2) {
        [fileManager removeItemAtPath:resourcePath2 error:&error];
    }
    if (resourcePath3) {
        [fileManager removeItemAtPath:resourcePath3 error:&error];
    }
}

-(void)copyDatabase_widget_to_location;
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory =[self applicationDocumentsDirectory_location].relativePath;
    NSString *resourcePath =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
    NSString *resourcePath2 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
    NSString *resourcePath3 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
    
    NSString *targetStr = self.applicationDocumentsDirectory_widget.relativePath;
    NSString *dataPath =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
    NSString *dataPath2 =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
    NSString *dataPath3 =[targetStr stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
    
    [fileManager removeItemAtPath:resourcePath error:&error];
    [fileManager removeItemAtPath:resourcePath2 error:&error];
    [fileManager removeItemAtPath:resourcePath3 error:&error];
    [fileManager copyItemAtPath:dataPath toPath:resourcePath error:&error];
    [fileManager copyItemAtPath:dataPath2 toPath:resourcePath2 error:&error];
    [fileManager copyItemAtPath:dataPath3 toPath:resourcePath3 error:&error];
}

-(void)deleteDatabase_location
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSString *documentsDirectory =[self applicationDocumentsDirectory_location].relativePath;
    NSString *resourcePath =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
    NSString *resourcePath2 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
    NSString *resourcePath3 =[documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
    
    [fileManager removeItemAtPath:resourcePath error:&error];
    [fileManager removeItemAtPath:resourcePath2 error:&error];
    [fileManager removeItemAtPath:resourcePath3 error:&error];
}

/**
    Widget触发的事件
 */
-(void)doWidgetActionUrl
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate m_doWidgetAction];
    }
    else
    {
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        [appDelegate m_doWidgetAction];
    }
}

-(void)doSetWidgetPurchaseAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time to Upgrade?" message:@"Upgrade to Full version to use completed widget function." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade",nil];
    alertView.tag = 2;
    [alertView show];
    
    self.close_PopView = alertView;
    
}








#pragma mark -
#pragma mark 正式版代码

-(void) do_openURL:(NSURL *)url
{
    self.use_url = url;
    
//    if ([url.relativeString containsString:WIDGET_URL0] || [url.relativeString containsString:WIDGET_URL1]) 8.0
    NSRange range = [url.relativeString rangeOfString:WIDGET_URL0];
    NSRange range2 = [url.relativeString rangeOfString:WIDGET_URL1];
    if (range.length > 0 || range2.length > 0)
    {
        [self doWidgetActionUrl];
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
            [appDelegate.passViewController.view removeFromSuperview];
        }
        else
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            [appDelegate.passViewController.view removeFromSuperview];
        }
        
        if (url!=nil)
        {
            //数据转移 免费版->正式版
            if([@"/importDatabase" isEqualToString:[url path]])
            {
                [self DisposeData:nil];
            }
            
            //注册或者登陆Dropbox的时候 取消
            if (_dropboxHelper)
            {
                [_dropboxHelper dropbox_handleOpenURL:url];
                
            }
        }
    }

    self.isWidgetFirst = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
        exit(1);
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self doPurchase_Lite];
        }
    }
}

-(void)DisposeData:(id)sender
{
    if([@"/importDatabase" isEqual:[self.use_url path]])
    {
        NSString *query = [self.use_url query];
        NSString *documentsDirectory = [self applicationDocumentsDirectory_location].relativePath;
        NSString *curPath = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
        
        [[GTMBase64 webSafeDecodeString:query] writeToFile: curPath atomically:YES];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self copyDatabase_location_to_widget];
        }
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hours Keeper data transfer success"
                                                            message:@"Thanks for using our Full Version! Please restart the Full Version to complete the transfer." 
                                                           delegate:self 
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK",nil];
        alertView.tag = 10;
        [alertView show];
        
        self.close_PopView = alertView;
        
    }		
}



-(void)dropbox_ServToLacl_FlashDate_UI_WithTip:(BOOL)withTip
{
    [self closeModalView];
    
    //刷新UI
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainView reflashTimerMainView];
    }
    
    else
    {
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
        [appDelegate iphone_reflash_UI];
    }
    
    if (withTip)
    {
        [self SyncTip];

    }
}

-(void)SyncTip
{
    NSString *tipStr;
    if (self.severTipStly == 2)
    {
        tipStr = @"Data time on dropbox server is later than this device, please check device time, or close sync feature to use.";
    }
    else
    {
        tipStr = @"Sync succeeded.";
    }
    self.severTipStly = 0;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tipStr
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

    self.close_PopView = alertView;
    
    
    [self performSelector:@selector(closeModalView) withObject:self afterDelay:3];
}

/*
-(void)dosyncThread:(NSArray *)dataArray
{
    [_dropboxHelper isFlash_LocalToServer:dataArray];
}
*/


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    处理数据的上下文，上下文就相当于一个工具，必须要使用这个工具才可以处理数据的保存，删除等操作。
 */
- (NSManagedObjectContext *)managedObjectContext 
{
    if (managedObjectContext_ != nil) 
    {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model. 创建应用程序中的数据模型
 */
- (NSManagedObjectModel *)managedObjectModel 
{
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HoursKeeper" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
    协调器，相当于我们用context来处理数据，怎么把这些数据存到底层中，就通过这个协调起来。
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
    if (persistentStoreCoordinator_ != nil)
    {
        return persistentStoreCoordinator_;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    NSURL *storeURL2 = [self applicationDocumentsDirectory];
    NSURL *storeURL = [storeURL2 URLByAppendingPathComponent:@"HoursKeeper.sqlite"];
//    Log(@"数据库存放地址：%@",storeURL);
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator_;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return [self applicationDocumentsDirectory_widget];
    }
    else
    {
        return [self applicationDocumentsDirectory_location];
    }
}

- (NSURL *)applicationDocumentsDirectory_widget;
{
    NSLog(@"%@",WIDGET_Group);
    
    return [[NSFileManager defaultManager]
                        containerURLForSecurityApplicationGroupIdentifier:WIDGET_Group];
}

- (NSURL *)applicationDocumentsDirectory_location;
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end

