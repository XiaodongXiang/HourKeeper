//
//  DropboxSyncHelper.h
//  HoursKeeper
//
//  Created by xy_dev on 10/11/13.
//
//

#import <Foundation/Foundation.h>


#import <Dropbox/Dropbox.h>
#import "DataBaseManger.h"

#import "Logs.h"
#import "Clients.h"
#import "Invoice.h"
#import "Invoiceproperty.h"


@interface DropboxSyncHelper : NSObject


@property (nonatomic, retain) id syncViewController_delegate;
@property (nonatomic, retain) DBAccountManager *dropbox_accountManager;
@property (nonatomic, retain) DBAccount *dropbox_account;
@property (nonatomic, retain) DBDatastore *dropbox_store;
@property (nonatomic, retain) DataBaseManger *dataManger;

@property (nonatomic, assign) BOOL isNeedFlashAll;
//限制一次同步的个数
@property (nonatomic, assign) BOOL needMax;
@property (nonatomic, assign) int countMax;


-(id)init;
-(void)dropbox_handleOpenURL:(NSURL *)url;
-(void)linkDropbox:(BOOL)isLink Observer:(id) syncViewController;

-(void)setup_autoSyncDropbox;
//刷新
-(void)flashDropboxState;

-(BOOL)isFlash_ServerToLocal:(NSDictionary *)changedDict;
-(BOOL)isFlash_LocalToServer:(NSArray *)m_array;
-(NSMutableArray *)getDataSelect:(NSArray *)m_array;

//server -> local
-(void)serToLal_Log:(Logs *)sel_log serData:(DBRecord *)sel_record;
-(void)serToLal_Inv:(Invoice *)sel_inv serData:(DBRecord *)sel_record;
-(void)serToLal_Clt:(Clients *)sel_clt serData:(DBRecord *)sel_record;
-(void)serToLal_InvProty:(Invoiceproperty *)sel_invpty serData:(DBRecord *)sel_record;             //1

//local -> server
-(void)lalToSer_Rec:(DBRecord *)sel_record log_lalData:(Logs *)sel_log;
-(void)lalToSer_Rec:(DBRecord *)sel_record inv_lalData:(Invoice *)sel_inv;
-(void)lalToSer_Rec:(DBRecord *)sel_record clt_lalData:(Clients *)sel_clt;
-(void)lalToSer_Rec:(DBRecord *)sel_record invproty_lalData:(Invoiceproperty *)sel_invpty;         //1

//sync compare
-(BOOL)syncCompare_LalClt:(Clients *)sel_clt serData:(DBRecord *)sel_record;
-(BOOL)syncCompare_LalInv:(Invoice *)sel_inv serData:(DBRecord *)sel_record;
-(BOOL)syncCompare_LalLog:(Logs *)sel_log serData:(DBRecord *)sel_record;
-(BOOL)syncCompare_LalInvpty:(Invoiceproperty *)sel_invpty serData:(DBRecord *)sel_record;         //1

//检查server的数据，检查local的数据，获取server/local中唯一的数据
-(id)todropbox_check_data:(id)data;
-(id)tolocal_check_data:(id)data;
-(id)getLocalOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name;
-(DBRecord *)getServerOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name;

-(void)dropnUnlink;
//将本地数据上传到Dropbox上
-(void)detcetAllLocaltoServer;
-(void)detcetAllServertoLocal;
@end
