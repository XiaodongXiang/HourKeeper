
#import <Foundation/Foundation.h>

extern NSString *const kAppiraterFirstUseDate;
extern NSString *const kAppiraterUseCount;
extern NSString *const kAppiraterSignificantEventCount;
extern NSString *const kAppiraterCurrentVersion;
extern NSString *const kAppiraterRatedCurrentVersion;
extern NSString *const kAppiraterDeclinedToRate;
extern NSString *const kAppUseAppNeedParse;



#ifdef LITE
    #define APPIRATER_APP_ID				563155321
#else
    #define APPIRATER_APP_ID				559701364
#endif



#define APPIRATER_APP_NAME				@"Hours Keeper"

#define APPIRATER_MESSAGE				[NSString stringWithFormat:@"If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", APPIRATER_APP_NAME]

#define APPIRATER_MESSAGE_TITLE			[NSString stringWithFormat:@"Rate %@", APPIRATER_APP_NAME]

#define APPIRATER_CANCEL_BUTTON			@"No, Thanks"

#define APPIRATER_RATE_BUTTON			[NSString stringWithFormat:@"Rate %@", APPIRATER_APP_NAME]

#define APPIRATER_RATE_LATER			@"Remind me later"

//没有天数限制
#define APPIRATER_DAYS_UNTIL_PROMPT		10

//只要满5次就弹出评论
#define APPIRATER_USES_UNTIL_PROMPT		5

#define APPIRATER_SIG_EVENTS_UNTIL_PROMPT	-1

#define APPIRATER_TIME_BEFORE_REMINDING		0

#define APPIRATER_USEDAYS_UNTIL_PROMPT		5



#define APPIRATER_DEBUG                 NO

@interface Appirater : NSObject <UIAlertViewDelegate>
{
	UIAlertView		*ratingAlert;
}

@property(nonatomic, strong) UIAlertView *ratingAlert;


+ (void)rateFinish:(NSInteger)Stly;
+ (void)whatNawFinish:(NSInteger)Stly;

+ (Appirater*)sharedInstance;
+ (void)appLaunched;
+ (void)appLaunched:(BOOL)canPromptForRating;
+ (void)appEnteredForeground:(BOOL)canPromptForRating;
+ (void)userDidSignificantEvent:(BOOL)canPromptForRating;
+ (void)rateApp;

@end
