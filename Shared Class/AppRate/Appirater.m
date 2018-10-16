
#import "Appirater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"



NSString *const kAppiraterUseDates					= @"kAppiraterUseDates";
NSString *const kAppiraterFirstUseDate				= @"kAppiraterFirstUseDate";
NSString *const kAppiraterUseCount					= @"kAppiraterUseCount";
NSString *const kAppiraterCurrentVersion			= @"kAppiraterCurrentVersion";
NSString *const kAppiraterRatedCurrentVersion		= @"kAppiraterRatedCurrentVersion";
NSString *const kAppiraterDeclinedToRate			= @"kAppiraterDeclinedToRate";
NSString *const kAppiraterReminderRequestDate		= @"kAppiraterReminderRequestDate";
NSString *const whatNewRead		                    = @"whatNewRead";
NSString *const kAppUseAppNeedParse                    = @"kAppUseAppNeedParse";

NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";





@interface Appirater (hidden)
- (BOOL)connectedToNetwork;
- (void)showRatingAlert;
- (BOOL)ratingConditionsHaveBeenMet;
- (void)incrementUseCount;
- (void)incrementUseDayCount;
@end


@implementation Appirater (hidden)




#pragma mark -
#pragma mark   No Use


- (void)incrementUseDayCount
{
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
        
		NSMutableArray *dates = [[NSMutableArray alloc] init];
        [dates addObjectsFromArray:[userDefaults objectForKey:kAppiraterUseDates]];
        
		if(dates == nil)
		{
			dates = [[NSMutableArray alloc] init];
		}
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyyMMdd"];
		NSString *dateStr = [df stringFromDate:[NSDate date]];
		if(![dates containsObject:dateStr])
		{
			[dates addObject:dateStr];
		}
		[userDefaults setObject:dates forKey:kAppiraterUseDates];
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
		[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterFirstUseDate];
		[userDefaults setInteger:1 forKey:kAppiraterUseCount];
		[userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kAppiraterReminderRequestDate];
		[userDefaults setObject:nil forKey:kAppiraterUseDates];
	}
	
	[userDefaults synchronize];
	
}
- (void)incrementSignificantEventCount {
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kAppiraterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kAppiraterFirstUseDate];
		}
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
		[userDefaults setDouble:0 forKey:kAppiraterFirstUseDate];
		[userDefaults setInteger:0 forKey:kAppiraterUseCount];
		[userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kAppiraterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}








#pragma mark -
#pragma mark   Use

- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

//  step 4
- (void)incrementUseCount
{
    //plist version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
    //新应用
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
    
    int HaveWhatNew = (int)[userDefaults integerForKey:whatNewRead];
    
    //不是升级上来，要满足条件才显示app rate
	if ([trackingVersion isEqualToString:version] && HaveWhatNew != 3)
	{
		int useCount = (int)[userDefaults integerForKey:kAppiraterUseCount];
		useCount++;
		[userDefaults setInteger:useCount forKey:kAppiraterUseCount];
        [userDefaults synchronize];
	}
    //升级上来，立马显示what's new
	else
	{
        [userDefaults setObject:version forKey:kAppiraterCurrentVersion];
        
        [userDefaults setInteger:3 forKey:whatNewRead];
		[userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];
        [userDefaults synchronize];
        
        
        //图片what's new
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        {
//            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
//            appDelegate.popAlertFlag = 2;
//            [appDelegate showRateOrWhatNew];
//        }
//        else
//        {
//            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
//            appDelegate.popAlertFlag = 2;
//            [appDelegate showRateOrWhatNew];
//        }
        
        
        //文字what's new
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        appDelegate.popAlertFlag = 2;
        [self showNewRate];
        
	}
}

//  step 5 ------ what's new
-(void)showNewRate
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"What's New in %@",version]
                                                        message:[NSString stringWithFormat:@"Minor bugs fixed."]
                                                       delegate:self
                                              cancelButtonTitle:APPIRATER_CANCEL_BUTTON
                                              otherButtonTitles:@"Rate", nil];
    alertView.tag = 2;
    [alertView show];
}

//  step 6 ------ rate alert
- (void)showRatingAlert
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPIRATER_MESSAGE_TITLE
														 message:APPIRATER_MESSAGE
														delegate:self
											   cancelButtonTitle:APPIRATER_CANCEL_BUTTON
											   otherButtonTitles:APPIRATER_RATE_BUTTON, APPIRATER_RATE_LATER, nil];
    
    alertView.tag = 1;
	self.ratingAlert = alertView;
	[alertView show];
}

//判断是否到rate
- (BOOL)ratingConditionsHaveBeenMet
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    int useCount = (int)[userDefaults integerForKey:kAppiraterUseCount];
	if (useCount <= APPIRATER_USES_UNTIL_PROMPT)
		return NO;

	if ([userDefaults boolForKey:kAppiraterDeclinedToRate] == YES)
		return NO;
	
	if ([userDefaults boolForKey:kAppiraterRatedCurrentVersion] == YES)
		return NO;
    
	return YES;
}



@end














@interface Appirater ()
- (void)hideRatingAlert;
@end


@implementation Appirater

@synthesize ratingAlert;




#pragma mark -
#pragma mark   Use

+ (Appirater*)sharedInstance
{
	static Appirater *appirater = nil;
	if (appirater == nil)
	{
		@synchronized(self)
        {
			if (appirater == nil)
            {
				appirater = [[Appirater alloc] init];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:@"UIApplicationWillResignActiveNotification" object:nil];
            }
        }
	}
	
	return appirater;
}

+ (void)rateFinish:(NSInteger)Stly
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (Stly)
    {
        case 0:
        {
            [userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
            [userDefaults synchronize];
            break;
        }
        case 1:
        {
            [Appirater rateApp];
            [userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
            [userDefaults synchronize];
            break;
        }
        case 2:
        {
            
            NSString *newRate = [userDefaults stringForKey:@"newRate2.0"];
            if (newRate == nil)
            {
                [userDefaults setObject:@"yesNewRate2.0" forKey:@"newRate2.0"];
                
                [userDefaults setInteger:1 forKey:kAppiraterUseCount];
                [userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
            }
            else
            {
                [userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
            }
            [userDefaults synchronize];
            break;
        }
        default:
            break;
    }
}

+ (void)whatNawFinish:(NSInteger)Stly
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:2 forKey:whatNewRead];
    [userDefaults synchronize];
    
    if (Stly == 1)
    {
        #ifdef LITE
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8"]];
        #else
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hours-keeper/id559701364?mt=8"]];
        #endif
    }
}


+ (void)rateApp
{
    #ifdef LITE
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hours-keeper/id563155321?mt=8"]];
    #else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hours-keeper/id559701364?mt=8"]];
    #endif
}


//  step 3
- (void)incrementAndRate:(NSNumber*)_canPromptForRating
{
	[self incrementUseCount];

    //满足弹出评论的条件，弹出评论的界面
	if ([_canPromptForRating boolValue] == YES &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.popAlertFlag = 1;
            [appDelegate showRateOrWhatNew];
        }
        else
        {
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
            appDelegate.popAlertFlag = 1;
            [appDelegate showRateOrWhatNew];
        }
	}
}

//  step 1
+ (void)appLaunched
{
	[Appirater appLaunched:YES];
}

//  step 2
+ (void)appLaunched:(BOOL)canPromptForRating
{
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        
    }
    
    if (alertView.tag == 2)
    {
        [Appirater whatNawFinish:buttonIndex];
    }
	
}







#pragma mark -
#pragma mark   No Use

- (void)incrementSignificantEventAndRate:(NSNumber*)_canPromptForRating
{
	@autoreleasepool {
	
		[self incrementSignificantEventCount];
		
		if ([_canPromptForRating boolValue] == YES &&
			[self ratingConditionsHaveBeenMet] &&
			[self connectedToNetwork])
		{
			[self performSelectorOnMainThread:@selector(showRatingAlert) withObject:nil waitUntilDone:NO];
		}
	
	}
}

- (void)hideRatingAlert
{
	if (self.ratingAlert.visible)
    {
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Hiding Alert");
		[self.ratingAlert dismissWithClickedButtonIndex:-1 animated:NO];
	}
}

+ (void)appWillResignActive
{
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER appWillResignActive");
	[[Appirater sharedInstance] hideRatingAlert];
}

+ (void)appEnteredForeground:(BOOL)canPromptForRating
{
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
}

+ (void)userDidSignificantEvent:(BOOL)canPromptForRating
{
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementSignificantEventAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
}




@end
