//
//  ParseSyncHelper.h
//  HoursKeeper
//
//  Created by humingjing on 15/4/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Clients,Logs,Invoice,Invoiceproperty,Profile;
@class Reachability;

@interface ParseSyncHelper : NSObject<UIAlertViewDelegate>
{
    BOOL isNeedFlesh;
   
    NSDate *lastSyncTime;
}

@property (nonatomic,strong)NSManagedObjectContext  *childCtx;

@property (nonatomic,assign)BOOL isConnecttoNetwork;
@property (nonatomic,strong)Reachability *hostReachability;
;

//数据增删改操作
-(void)updateClientFromLocal:(Clients *)oneClient;
-(void)updateLogFromLocal:(Logs *)oneLog;
-(void)updateInvoiceFromLocal:(Invoice *)oneInvoice;
-(void)updateInvoicePropertyFromLocal:(Invoiceproperty *)oneInvoiceProperty;
-(void)updateProfileFromLocal:(Profile *)oneProfile;


-(void)syncProfile;
-(void)saveServerProfile:(PFObject *)object withLocaldata:(Profile *)localProfile isChildContext:(BOOL)isChildContext;
//开启同步
-(void)syncAllWithTip:(BOOL)isTip;
//是不是有数据没有被同步
-(BOOL)isAnyDataWerenotSync;

//检验邮箱格式是否正确
+ (BOOL)validateEmail: (NSString *) email;

//restore
-(void)deleteAllLocalDataBase;
-(void)deleteAllDataonParse;
-(void)saveAllLocalDatatoParse;
-(id)fetchServerProfile;
-(id)getLocalOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name;

//登出时将本地所有数据上传到云端
-(void)updateAllLocalDatatoServerBeforeLogout;
//-(void)updateAllLocalDatatoServerAfterDropboxLinked;
@end
