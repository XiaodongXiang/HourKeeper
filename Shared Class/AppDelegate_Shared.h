//
//  AppDelegate_Shared.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-29.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <LocalAuthentication/LocalAuthentication.h>

#import "DropboxSyncHelper.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "EBPurchase.h"
#import "Settings.h"
#import "Flurry.h"

#import "HMJNomalClass.h"
#import "HMJActivityIndicator.h"



//#!/bin/bash   build
//buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
//buildNumber=$(($buildNumber + 1))
///usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"


//数字
#define NUMBERS @"0123456789\n"

//-------------------------LITE用到的---------------------------
#define SUB_PRODUCT_ID              @"BTGS_029IAP"
//免费版是否内购的标志：1:已购，0:未够
#define LITE_UNLOCK_FLAG            @"UnLock_Lite_limit"
//是否需要显示免费版广告的标志
#define NEED_SHOW_LITE_ADV_FLAG     @"Hourskeeper_lite_adv"
//要不要限制免费版Client的数目（10%的用户限制）
#define LITE_CLIENT_UNLIMITCONUT    @"Lite_Client_UnLimitCount"


//-------------------------------overtime--------------------------------
#define OVER_NONE                   @"None"
#define ZERO_NUM                    @"0.00"
#define over_UseColor               [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1]
#define over_noUseColor             [UIColor redColor]


//--------------------------------touch ID statu---------------------------
#define     TouchCancel             0
#define     TouchYes                1
#define     TouchNotEn              2
#define     TouchNotSet             3
#define     TouchNotAvOrTH          4

//-----------------widget copy data 第一次登陆要把数据库挪到share区域------------
#define     WIDGET_FIRST            @"WIDGET_FIRST_DATABASE"


//正式版 widget链接，WIDGET_Group是应用在公共区域的地址，每一个应用都不一样
#ifdef FULL
    //group id
    #define     WIDGET_Group            @"group.hourkeeper.widget.Data"
    //timesvc clock in
    #define     WIDGET_URL0             @"hourskeeper-widget://tag0"
    //add entry
    #define     WIDGET_URL1             @"hourskeeper-widget://tag1"
//免费版 widget链接
#else
//
    #define     WIDGET_Group            @"group.hourkeeper.widget.Data.Lite"
    #define     WIDGET_URL0             @"hourskeeper-widget-Lite://tag0"
    #define     WIDGET_URL1             @"hourskeeper-widget-Lite://tag1"
#endif




@class ParseSyncHelper;
@interface AppDelegate_Shared : NSObject <UIApplicationDelegate,EBPurchaseDelegate>
{
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, strong) IBOutlet UIWindow                     *window;
@property (nonatomic, strong) NSURL                                 *use_url;

@property (nonatomic, strong, readonly) NSManagedObjectContext      *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel        *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator*persistentStoreCoordinator;

@property (nonatomic, strong) MFMailComposeViewController           *appMailController;
@property (nonatomic, strong) UIImagePickerController               *m_pickerController;
//内购蒙版
@property (nonatomic, strong) UIView                                *purchasingView;
//alert/actionsheet：当进入后台的时候 alertview要取消，因为会和密码页面冲突
@property (nonatomic, strong) id                                    close_PopView;

@property (nonatomic, strong) Settings            *appSetting;
@property (nonatomic, strong) NSString            *currencyStr;
//全局数组：dailyovertime默认的数组，weeklyovertime默认数组
@property (nonatomic, strong) NSArray             *m_overTimeArray;
@property (nonatomic, strong) NSArray             *m_weekDateArray;
@property (nonatomic, strong) NSArray             *m_currencyArray;
@property (nonatomic,assign) BOOL                 isPurchased;
//是否显示广告
@property (nonatomic,assign) BOOL                 lite_adv;
@property (nonatomic,strong) EBPurchase           *lite_Purchase;
@property (nonatomic,strong) DropboxSyncHelper    *dropboxHelper;
@property (nonatomic,strong) ParseSyncHelper      *parseSync;
@property (nonatomic,strong) HMJNomalClass        *nomalClass;
@property (nonatomic,strong) HMJActivityIndicator *hmjIndicator;
@property (nonatomic,assign) BOOL                   needLoginParse;
//是否正在backup&restore,是否正在同步
@property (nonatomic,assign) BOOL                 isBackup;
@property (nonatomic,assign) BOOL                 isSyncing;
//当sever端修改超前时，操作本地记录 日期时间对比 不一致时 会导致本地提示错乱  提示：0 不需要提示，1 需要对比， 2 需要提示。Parse没用到???
@property(nonatomic,assign) int severTipStly;
//弹alertview的情况 0:无； 1:rate;  2:what's new
@property (nonatomic,assign) NSInteger            popAlertFlag;

//navigationbar的边距以及字体
@property (nonatomic, assign) float               naviBarWitd;
@property (nonatomic, strong) UIFont              *naviFont;
@property (nonatomic, strong) UIFont              *naviFont2;

//touch ID
@property (nonatomic,strong) LAContext            *touchIdContext;
@property (nonatomic,strong) id                   foreTouchCheckViewContor;
@property (nonatomic,strong) id                   passSetTouchCheckViewContor;
@property (atomic,assign) BOOL                    isLock;
@property (nonatomic,assign) NSInteger            isBackgroundIn;


//widget???
@property(nonatomic, assign) BOOL                 isWidgetAlert;
@property(nonatomic,assign) BOOL                  isWidgetPrsent;
//应用的第一个界面准备好了没，准备好了是NO,没准备好是YES，要等待页面准备好了才能push第二层页面
@property(nonatomic,assign) BOOL                  isWidgetFirst;
//mainvcpush的第二层vc startviewcontroller,要将当前页面置于mainvc
@property(nonatomic, strong) UIViewController     *m_widgetController;



//////////////////////////////////////////////////
//获取数据库需要在的位置：IOS8以下只能在本地，IOS8以后在shared区域
- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationDocumentsDirectory_widget;
- (NSURL *)applicationDocumentsDirectory_location;
- (void)saveContext;
//添加内购蒙版(转动的菊花)，隐藏内购蒙版
-(void)showActiviIndort;
-(void)hideActiviIndort;
//rate app
-(void)doRateApp;
-(void)do_openURL:(NSURL *)url;
//设置navigationbar文字是左对齐还是右对齐
-(void)setNaviGationItem:(UIViewController *)_controller isLeft:(BOOL)_isLeft button:(UIButton *)_button;
-(void)setNaviGationTittle:(UIViewController *)_controller with:(float)_with high:(float)_high tittle:(NSString *)str;


//widget
-(void)copyDatabase_location_to_widget;
//在backup&restore的时候：将数据库从shared->local压缩
-(void)copyDatabase_widget_to_location;
//back&restore完移除数据库
-(void)deleteDatabase_location;
//widget事件
-(void)doWidgetActionUrl;
//???
-(void)doSetWidgetPurchaseAlert;


//touch ID
-(void)setTouchIdPassword:(BOOL)isOpen;
-(void)addTouchIdPassword_target:(id)m_self;
-(void)do_addTouchIdPassword_parameter:(NSArray *)m_array;
-(int)canTouchId;
-(void)showTouchIdFaildTip_havePass:(BOOL)havePass;




//date updata
- (void)upgradeDatabase_isMust:(BOOL)flag;
-(NSString *)getUuid;
//升级数据时，给没有uuid数据添加uuid
-(void)initData_forSyncDropbox;
//关闭弹出的alertview/actionsheet
-(void)closeModalView;


//data get right
-(NSMutableArray *)removeAlready_DeleteLog:(NSArray *)logArray;
-(NSMutableArray *)removeAlready_DeleteInv:(NSArray *)invArray;
-(NSMutableArray *)removeAlready_DeleteInvpty:(NSArray *)invptyArray;

// PayPeroid time 获取client应该支付的起始日期以及截止日期
-(void)getPayPeroid_selClient:(Clients *)sel_client payPeroidDate:(NSDate *)sel_dueDate backStartDate:(NSDate **)startDate backEndDate:(NSDate **)endDate;

//public 1.获取加班工资倍数的文本信息颜色 2.每周的第一天
-(UIColor *)getOverTimeText_Color:(NSString *)str;
-(int)getFirstDayForWeek;
//???
-(double)getMultipleNumber:(NSString *)myString;
-(NSString *)getMultipleNumber2:(NSString *)myString isAllNumber:(BOOL)isNum;
-(NSString *)getMultipleNumber3:(NSString *)numStr needX:(BOOL)isNeed;
//1.将6:12转换成6h 12min字符串类型 2.将描述转成6h 12m 3.将描述转成6h 12m 30s 4.6:12 5. 6:12:30 6.将6:12转换成总描述
-(NSString *)conevrtTime:(NSString *)worked;
-(NSString *)conevrtTime2:(int)totalSeconds;
-(NSString *)conevrtTime3:(int)totalSeconds;
-(NSString *)conevrtTime4:(int)totalSeconds;
-(NSString *)conevrtTime5:(int)totalSeconds;
-(int)getLogsWorkedTimeSecond:(NSString *)workedtimeStr;
//获取log的工作时间以及金钱（不算加班费）
-(NSArray *)getRoundWorkAndMoney_ByClient:(Clients *)caculateClient rate:(NSString *)rateStr totalTime:(NSString *)timeWorked totalTimeInt:(int)totalSeconds;
-(NSArray *)getAllSetting;
-(NSArray *)getAllClient;
-(NSArray *)getAllLog;
//某client某天工作工资
-(NSString *)getRateByClient:(Clients *)sel_client date:(NSDate *)sel_date;
//1.??? 2.??? 3.$4.20 4.4.2
-(NSString *)appMoneyShowStly:(NSString *)_moneyStr;
-(NSString *)appMoneyShowStly2:(NSString *)_moneyStr;
-(NSString *)appMoneyShowStly3:(double)_moneyFloat;
-(NSString *)appMoneyShowStly4:(double)_moneyFloat;
//???
-(void)customFingerMove:(UIViewController *)_contor canMove:(BOOL)_isMove isBottom:(BOOL)_isBottom;
//用color创建image
-(UIImage*)m_imageWithColor:(UIColor *)color size:(CGSize)size;


//1.获取某段时间logs 2.计算logs数组总共工资（算加班）
-(NSArray *)getOverTime_Log:(Clients *)sel_client startTime:(NSDate *)start endTime:(NSDate *)end isAscendingOrder:(BOOL)_order;
-(NSArray *)overTimeMoney_logs:(NSArray *)logsArray;
//某个client 工作某段时间的总工资
-(NSArray *)overTimeMoney_Clients:(Clients *)client totalTime:(int)totalTime rate:(NSString *)rateStr;

//data init
//清掉多余错误的数据2.7.1之前
//-(void)removeRubinshData;
//纠正错误数据log工资
-(void)overTimeInitData;
//2.7.1之前有
//-(void)databaseRollback;

//FULL
//同步刷新UI
-(void)dropbox_ServToLacl_FlashDate_UI_WithTip:(BOOL)withTip;
//同步提醒
-(void)SyncTip;
//2.7.1之前有
//-(void)dosyncThread:(NSArray *)dataArray;


//LITE
//判断当前app是不是正式版或者内购版
-(void)doInit_Lite;
-(void)doPurchase_Lite;
-(void)doRePurchase_Lite;

//-(void)getInvocieEntityCount;
-(NSArray *)getDashBoardClient;

//同步转圈圈
-(void)showIndicator;
-(void)hideIndicator;

@end

