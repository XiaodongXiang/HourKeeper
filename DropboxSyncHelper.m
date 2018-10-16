//
//  DropboxSyncHelper.m
//  HoursKeeper
//
//  Created by xy_dev on 10/11/13.
//
//

#import "DropboxSyncHelper.h"

#import <CoreData/CoreData.h>

#import "DropboxSyncDefine.h"
#import "SyncViewController_ipad.h"
#import "SyncViewController_iphone.h"
#import "AppDelegate_Shared.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"



#define DROPBOX_KEY           @"b43ep996igwezzh"
#define DROPBOX_SECRET        @"nkdpu6h560tay63"

@interface DropboxSyncHelper ()
{
    BOOL _isFresh;
}
@end

@implementation DropboxSyncHelper



@synthesize syncViewController_delegate;
@synthesize dropbox_accountManager;
@synthesize dropbox_account;
@synthesize dataManger;

@synthesize isNeedFlashAll;
@synthesize needMax;
@synthesize countMax;





#pragma mark - value
- (DBAccount *)dropbox_account
{
	return [DBAccountManager sharedManager].linkedAccount;
}

- (DBAccountManager *)dropbox_accountManager
{
	return [DBAccountManager sharedManager];
}

- (DBDatastore *)dropbox_store
{
	if (!_dropbox_store)
	{
		_dropbox_store = [DBDatastore openDefaultStoreForAccount:self.dropbox_account error:nil];
	}
	return _dropbox_store;
}



#pragma mark - init
-(id)init
{
	self = [super init];
	if(self)
	{
        DBAccountManager *mgr =
        [[DBAccountManager alloc] initWithAppKey:DROPBOX_KEY secret:DROPBOX_SECRET];
        [DBAccountManager setSharedManager:mgr];
        self.dataManger = [DataBaseManger getBaseManger];
       

        self.isNeedFlashAll = YES;

        [self addStoreObserver];

	}
	return self;
}

-(void)addStoreObserver
{
    __weak DropboxSyncHelper *slf = self;

    [
     self.dropbox_accountManager addObserver:self block:^(DBAccount *account)
     {
         [slf setup_autoSyncDropbox];
     }
     ];
    [self setup_autoSyncDropbox];
}

-(void)dropnUnlink
{
    [self.dropbox_account unlink];
    self.syncViewController_delegate = nil;
    self.dropbox_store = nil;
//    [self.dropbox_store removeObserver:self];
//    [self.dropbox_account removeObserver:self];
//    self.dropbox_account = nil;
}

-(void)linkDropbox:(BOOL)isLink Observer:(id) syncViewController;
{
    if (isLink == NO)
    {
        if ([self.dropbox_account isLinked])
        {
            [self dropnUnlink];
        }
    }
    else
    {
        if (![self.dropbox_account isLinked])
        {
            [self.dropbox_accountManager linkFromController:(UIViewController *)syncViewController];
            self.syncViewController_delegate = syncViewController;
        }
    }
}

-(void)dropbox_handleOpenURL:(NSURL *)url
{

    
    if ([self.dropbox_accountManager handleOpenURL:url])
    {
//        AppDelegate_iPhone *appDelegate =(AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//        [self flashDropboxState];
    }
    
}
#pragma mark Begin Sync
/*
 1.注册成功之后
	（1）以前登陆过，先清掉local
	（2）dropbox链接：同步Dropbox -> 打开Parse同步
	（3）没链接：提示链接 -> 同步Dropbox -> 打开Parse
 2.登陆成功
 （1）以前登陆过，如果user不一样，清掉local
 （2）直接打开Parse
 */
-(void)setup_autoSyncDropbox
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    //Dropbox连接上，Dropbox Sync.否则将永远不sync
    
    _isFresh = YES;
    if (appDelegate.dropboxHelper.dropbox_account.linked)
    {
        __weak DropboxSyncHelper *slf = self;
        
        //datastore发生状态改变的时候
        [
         self.dropbox_store addObserver:self block:^
         {
             DBDatastoreStatus *status = slf.dropbox_store.status;
             
             //连接上dropbox
             if (status.connected)
             {
                 if (slf.dropbox_store.status.incoming == YES || slf.dropbox_store.status.outgoing==YES)
                 {
                     NSDictionary *changed = [slf.dropbox_store sync:nil];
                     _isFresh = [slf isFlash_ServerToLocal:changed];
                     return ;
                 }
                 
                 //打开应用，下载完成 dropbox sync
                 if (!slf.dropbox_store.status.downloading)
                 {
                     [slf detcetAllServertoLocal];
                     appDelegate.appSetting.lastSyncDate = nil;
                     [appDelegate.managedObjectContext save:nil];
                     NSLog(@"下载完成两遍");
                 }
             }
         }
         ];
    }
    else
    {
        self.dropbox_store = nil;
//        self.isNeedFlashAll = YES;
//        
//        AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
//
//        if (!isUnlinkFromSetting)
//        {
//            //登陆页面
//            if (ISPAD)
//            {
//                [self.dropbox_accountManager linkFromController:appDelegate.mainView];
//            }
//            else
//            {
//                [self.dropbox_accountManager linkFromController:appDelegate_iPhone.window.rootViewController];
//            }
//        }
    }
}


#pragma mark Server -> Local
-(void)detcetAllServertoLocal
{
    
    DBError *dberror = nil;
    DBTable *clientTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
    DBTable *invoiceTabel = [self.dropbox_store getTable:DB_INVOICE_TABLE];
    DBTable *invoicePropertyTable = [self.dropbox_store getTable:DB_INVOICEPERTY_TABLE];
    DBTable *logsTable = [self.dropbox_store getTable:DB_LOG_TABLE];
    
    
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[clientTable query:nil error:&dberror]] ;
    NSMutableArray *array2 = [[NSMutableArray alloc]initWithArray:[invoiceTabel query:nil error:&dberror]];
    NSMutableArray *array3 = [[NSMutableArray alloc]initWithArray:[invoicePropertyTable query:nil error:&dberror]];
    NSMutableArray *array4 = [[NSMutableArray alloc]initWithArray:[logsTable query:nil error:&dberror]];
    
    
    for (int i = (int)([array1 count]-1); i >=0; i--)
    {
        DBRecord *record = array1[i];
        if (record[CLT_UUID] == nil || [self tolocal_check_data:record[CLT_UUID]] == nil)
        {
            [record deleteRecord];
            continue;
        }
        
        DBTable *clientTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
        NSArray *arr = [clientTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[CLT_UUID]] forKey:CLT_UUID] error:nil];
        if([arr count] > 1)
        {
            [array1 removeObjectsInArray:arr];
            i = i - (int)[arr count] + 1;
            record = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
        }
        
        if (record[CLT_UUID] == nil || [self tolocal_check_data:record[CLT_UUID]] == nil)
        {
            [record deleteRecord];
        }
        else
        {
            NSMutableDictionary* subs = [NSMutableDictionary dictionary];
            [subs setObject:record[CLT_UUID] forKey:@"uuid"];
            //获取本地的client
            NSArray* cltArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_CLIENT_TABLE searchSubPre:subs];
            NSNumber *drop_status = record[CLT_SYNCSTATUS];
            if([cltArray count] == 0)
            {
                if ([drop_status integerValue] == 0)
                {
                    [self serToLal_Clt:nil serData:record];
                    
                    _isFresh = YES;
                }
            }
            else
            {
                Clients *sel_clt = (Clients *)[self getLocalOnly_Data:cltArray tableName:DB_CLIENT_TABLE];
                if ([self syncCompare_LalClt:sel_clt serData:record] == YES)
                {
                    _isFresh = YES;
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    for (int i = (int)([array2 count] - 1); i >=0; i--)
    {
        DBRecord *record = array2[i];
        if (record[INV_UUID] == nil || record[INV_PARENTUUID] == nil || [self tolocal_check_data:record[INV_PARENTUUID]] == nil || [self tolocal_check_data:record[INV_UUID]] == nil)
        {
            [record deleteRecord];
            continue;
        }
        
        DBTable *invoiceTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
        NSArray *arr = [invoiceTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INV_UUID]] forKey:INV_UUID] error:nil];
        if([arr count] > 1)
        {
            [array2 removeObjectsInArray:arr];
            i = i - (int)[arr count] + 1;
            record = [self getServerOnly_Data:arr tableName:DB_INVOICE_TABLE];
        }
        
        if (record[INV_UUID] == nil || record[INV_PARENTUUID] == nil || [self tolocal_check_data:record[INV_PARENTUUID]] == nil || [self tolocal_check_data:record[INV_UUID]] == nil)
        {
            [record deleteRecord];
        }
        else
        {
            NSMutableDictionary* subs = [NSMutableDictionary dictionary];
            [subs setObject:record[INV_UUID] forKey:@"uuid"];
            NSArray* invArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICE_TABLE searchSubPre:subs];
            NSNumber *drop_status = record[INV_SYNCSTATUS];
            if([invArray count] == 0)
            {
                if ([drop_status integerValue] == 0)
                {
                    DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
                    NSArray *arr = [cltTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INV_PARENTUUID]] forKey:CLT_UUID] error:nil];
                    if ([arr count] == 0)
                    {
                        [record deleteRecord];
                    }
                    else
                    {
                        DBRecord *client_R = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
                        NSNumber *drop_status2 = client_R[CLT_SYNCSTATUS];
                        if ([drop_status2 integerValue] == 1)
                        {
                            record[INV_SYNCSTATUS] = drop_status2;
                        }
                        else
                        {
                            [self serToLal_Inv:nil serData:record];
                            _isFresh = YES;
                        }
                    }
                }
            }
            else
            {
                Invoice *sel_inv = (Invoice *)[self getLocalOnly_Data:invArray tableName:DB_INVOICE_TABLE];
                if ([self syncCompare_LalInv:sel_inv serData:record] == YES)
                {
                    _isFresh = YES;
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    for (int i = (int)([array3 count] - 1); i >=0; i--)
    {
        DBRecord *record = array3[i];
        if (record[INVPTY_UUID] == nil || record[INVPTY_PARENTUUID] == nil || [self tolocal_check_data:record[INVPTY_PARENTUUID]] == nil || [self tolocal_check_data:record[INVPTY_UUID]] == nil)
        {
            [record deleteRecord];
            continue;
        }
        
        DBTable *invptyTable = [self.dropbox_store getTable:DB_INVOICEPERTY_TABLE];
        NSArray *arr = [invptyTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INVPTY_UUID]] forKey:INVPTY_UUID] error:nil];
        if([arr count] > 1)
        {
            [array3 removeObjectsInArray:arr];
            i = i - (int)[arr count] + 1;
            record = [self getServerOnly_Data:arr tableName:DB_INVOICEPERTY_TABLE];
        }
        
        if (record[INVPTY_UUID] == nil || record[INVPTY_PARENTUUID] == nil || [self tolocal_check_data:record[INVPTY_PARENTUUID]] == nil || [self tolocal_check_data:record[INVPTY_UUID]] == nil)
        {
            [record deleteRecord];
        }
        else
        {
            NSMutableDictionary* subs = [NSMutableDictionary dictionary];
            [subs setObject:record[INVPTY_UUID] forKey:@"uuid"];
            NSArray* invptysArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICEPTY_TABLE searchSubPre:subs];
            NSNumber *drop_status = record[INVPTY_SYNCSTATUS];
            if([invptysArray count] == 0)
            {
                if ([drop_status integerValue] == 0)
                {
                    DBTable *invTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
                    NSArray *arr = [invTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INVPTY_PARENTUUID]] forKey:INV_UUID] error:nil];
                    if ([arr count] == 0)
                    {
                        [record deleteRecord];
                    }
                    else
                    {
                        DBRecord *inv_R = [self getServerOnly_Data:arr tableName:DB_INVOICE_TABLE];
                        NSNumber *drop_status2 = inv_R[INV_SYNCSTATUS];
                        if ([drop_status2 integerValue] == 1)
                        {
                            record[INVPTY_SYNCSTATUS] = drop_status2;
                        }
                        else
                        {
                            [self serToLal_InvProty:nil serData:record];
                            _isFresh = YES;
                        }
                    }
                }
            }
            else
            {
                Invoiceproperty *sel_invpty = (Invoiceproperty *)[self getLocalOnly_Data:invptysArray tableName:DB_INVOICEPERTY_TABLE];
                if ([self syncCompare_LalInvpty:sel_invpty serData:record] == YES)
                {
                    _isFresh = YES;
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    for (int i = (int)([array4 count] - 1); i >=0; i--)
    {
        DBRecord *record = array4[i];
        if (record[LOG_UUID] == nil || record[LOG_CLIENTUUID] == nil || [self tolocal_check_data:record[LOG_CLIENTUUID]] == nil || [self tolocal_check_data:record[LOG_UUID]] == nil)
        {
            [record deleteRecord];
            continue;
        }
        
        DBTable *logTable = [self.dropbox_store getTable:DB_LOG_TABLE];
        NSArray *arr = [logTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[LOG_UUID]] forKey:LOG_UUID] error:nil];
        if([arr count] > 1)
        {
            [array4 removeObjectsInArray:arr];
            i = i - (int)[arr count] + 1;
            record = [self getServerOnly_Data:arr tableName:DB_LOG_TABLE];
        }
        
        if (record[LOG_UUID] == nil || record[LOG_CLIENTUUID] == nil || [self tolocal_check_data:record[LOG_CLIENTUUID]] == nil || [self tolocal_check_data:record[LOG_UUID]] == nil)
        {
            [record deleteRecord];
        }
        else
        {
            NSMutableDictionary* subs = [NSMutableDictionary dictionary];
            [subs setObject:record[LOG_UUID] forKey:@"uuid"];
            NSArray* logsArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_LOG_TABLE searchSubPre:subs];
            NSNumber *drop_status = record[LOG_SYNCSTATUS];
            if([logsArray count] == 0)
            {
                if ([drop_status integerValue] == 0)
                {
                    DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
                    NSArray *arr = [cltTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[LOG_CLIENTUUID]] forKey:CLT_UUID] error:nil];
                    if ([arr count] == 0)
                    {
                        [record deleteRecord];
                    }
                    else
                    {
                        DBRecord *client_R = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
                        NSNumber *drop_status2 = client_R[CLT_SYNCSTATUS];
                        if ([drop_status2 integerValue] == 1)
                        {
                            record[LOG_SYNCSTATUS] = drop_status2;
                        }
                        else
                        {
                            [self serToLal_Log:nil serData:record];
                            _isFresh = YES;
                        }
                    }
                }
            }
            else
            {
                Logs *sel_log = (Logs *)[self getLocalOnly_Data:logsArray tableName:DB_LOG_TABLE];
                if ([self syncCompare_LalLog:sel_log serData:record] == YES)
                {
                    _isFresh = YES;
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    
    if(_isFresh == YES)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [appDelegate dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
    }
    
}


-(void)detcetAllLocaltoServer
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//    NSError *error = nil;
//    
//    NSFetchRequest *fetchClient = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_CLIENT];
//    NSFetchRequest  *fetchLog = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_LOGS];
//    NSFetchRequest  *fetchInvoice = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICE];
//    NSFetchRequest  *fetchProperty = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICEPROPERTY];
//    
//    NSArray *clientArray = [appDelegate.managedObjectContext executeFetchRequest:fetchClient error:&error];
//    
//    NSArray *logdArray = [appDelegate.managedObjectContext executeFetchRequest:fetchLog error:&error];
//    
//    NSArray *invoiceArray = [appDelegate.managedObjectContext executeFetchRequest:fetchInvoice error:&error];
//    NSArray *propertyArray = [appDelegate.managedObjectContext executeFetchRequest:fetchProperty error:&error];
//    
//    NSMutableArray *totalArray = [[NSMutableArray alloc]init];
//    [totalArray addObjectsFromArray:clientArray];
//    [totalArray addObjectsFromArray:logdArray];
//    [totalArray addObjectsFromArray:invoiceArray];
//    [totalArray addObjectsFromArray:propertyArray];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
    [self isFlash_LocalToServer:nil];
    [appDelegate hideActiviIndort];
    
    
}





#pragma mark - link


//-(void)setup_autoSyncDropbox
//{
//    if (self.dropbox_account)
//    {
//        __weak DropboxSyncHelper *slf = self;
//        
//        //datastore发生状态改变的时候
//        [
//         self.dropbox_store addObserver:self block:^
//         {
//             DBDatastoreStatus *status = slf.dropbox_store.status;
//             
//             //如果连接上dropbox了
//             if (status.connected)
//             {
//                 //如果是第一次打开应用，先刷新同步页面的UI，然后等待下载数据完成之后，
//                 if (slf.isNeedFlashAll == YES)
//                 {
//                     [slf flashDropboxState];
//                     if (status.downloading == NO)
//                     {
//                         slf.isNeedFlashAll = NO;
//                         [slf isFlash_LocalToServer:nil];
//                     }
//                 }
//                 
//                 if (slf.dropbox_store.status.incoming == YES || slf.dropbox_store.status.outgoing == YES)
//                 {
//                     NSDictionary *changed = [slf.dropbox_store sync:nil];
//                     [slf isFlash_ServerToLocal:changed];
//                 }
//             }
//             
//             
//             NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
//             [defaultUser setValue:@"1" forKey:UPGRADE_3];
//             AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
//             [appDelegate initTimer];
//         }
//         ];
//    }
//    else
//    {
//        self.dropbox_store = nil;
//        self.isNeedFlashAll = YES;
//    }
//}

/**
    刷新dropbox同步页面的UI
 */
-(void)flashDropboxState
{
    if (self.syncViewController_delegate != nil)
    {
        if ([self.syncViewController_delegate isKindOfClass:[SyncViewController_ipad class]])
        {
            SyncViewController_ipad *sync_ipad = (SyncViewController_ipad *)self.syncViewController_delegate;
            [sync_ipad flashView2];
        }
        else if ([self.syncViewController_delegate isKindOfClass:[SyncViewController_iphone class]])
        {
            SyncViewController_iphone *sync_ipad = (SyncViewController_iphone *)self.syncViewController_delegate;
            [sync_ipad flashView2];
        }
    }
}



-(BOOL)isFlash_ServerToLocal:(NSDictionary *)changedDict
{
    BOOL isRefresh = NO;
    
    //client
    {
        NSMutableArray *cltChange = [NSMutableArray arrayWithArray:[changedDict[DB_CLIENT_TABLE] allObjects]];
        for (int i = (int)([cltChange count] - 1); i >=0; i--)
        {
            DBRecord *record = cltChange[i];
            if (record[CLT_UUID] == nil || [self tolocal_check_data:record[CLT_UUID]] == nil)
            {
                [record deleteRecord];
                continue;
            }
            
            DBTable *clientTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
            NSArray *arr = [clientTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[CLT_UUID]] forKey:CLT_UUID] error:nil];
            if([arr count] > 1)
            {
                [cltChange removeObjectsInArray:arr];
                i = i - (int)[arr count] + 1;
                record = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
            }
            
            if (record[CLT_UUID] == nil || [self tolocal_check_data:record[CLT_UUID]] == nil)
            {
                [record deleteRecord];
            }
            else
            {
                NSMutableDictionary* subs = [NSMutableDictionary dictionary];
                [subs setObject:record[CLT_UUID] forKey:@"uuid"];
                //获取本地的client
                NSArray* cltArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_CLIENT_TABLE searchSubPre:subs];
                NSNumber *drop_status = record[CLT_SYNCSTATUS];
                if([cltArray count] == 0)
                {
                    if ([drop_status integerValue] == 0)
                    {
                        [self serToLal_Clt:nil serData:record];
                        isRefresh = YES;
                    }
                }
                else
                {
                    Clients *sel_clt = (Clients *)[self getLocalOnly_Data:cltArray tableName:DB_CLIENT_TABLE];
                    if ([self syncCompare_LalClt:sel_clt serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    //invoice
    {
        NSMutableArray *invChange = [NSMutableArray arrayWithArray:[changedDict[DB_INVOICE_TABLE] allObjects]];
        for (int i = (int)([invChange count] - 1); i >=0; i--)
        {
            DBRecord *record = invChange[i];
            if (record[INV_UUID] == nil || record[INV_PARENTUUID] == nil || [self tolocal_check_data:record[INV_PARENTUUID]] == nil || [self tolocal_check_data:record[INV_UUID]] == nil)
            {
                [record deleteRecord];
                continue;
            }
            
            DBTable *invoiceTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
            NSArray *arr = [invoiceTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INV_UUID]] forKey:INV_UUID] error:nil];
            if([arr count] > 1)
            {
                [invChange removeObjectsInArray:arr];
                i = i - (int)[arr count] + 1;
                record = [self getServerOnly_Data:arr tableName:DB_INVOICE_TABLE];
            }
            
            if (record[INV_UUID] == nil || record[INV_PARENTUUID] == nil || [self tolocal_check_data:record[INV_PARENTUUID]] == nil || [self tolocal_check_data:record[INV_UUID]] == nil)
            {
                [record deleteRecord];
            }
            else
            {
                NSMutableDictionary* subs = [NSMutableDictionary dictionary];
                [subs setObject:record[INV_UUID] forKey:@"uuid"];
                NSArray* invArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICE_TABLE searchSubPre:subs];
                NSNumber *drop_status = record[INV_SYNCSTATUS];
                if([invArray count] == 0)
                {
                    if ([drop_status integerValue] == 0)
                    {
                        DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
                        NSArray *arr = [cltTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INV_PARENTUUID]] forKey:CLT_UUID] error:nil];
                        if ([arr count] == 0)
                        {
                            [record deleteRecord];
                        }
                        else
                        {
                            DBRecord *client_R = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
                            NSNumber *drop_status2 = client_R[CLT_SYNCSTATUS];
                            if ([drop_status2 integerValue] == 1)
                            {
                                record[INV_SYNCSTATUS] = drop_status2;
                            }
                            else
                            {
                                [self serToLal_Inv:nil serData:record];
                                isRefresh = YES;
                            }
                        }
                    }
                }
                else
                {
                    Invoice *sel_inv = (Invoice *)[self getLocalOnly_Data:invArray tableName:DB_INVOICE_TABLE];
                    if ([self syncCompare_LalInv:sel_inv serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    //log
    {
        NSMutableArray *logChange = [NSMutableArray arrayWithArray:[changedDict[DB_LOG_TABLE] allObjects]];
        for (int i = (int)([logChange count] - 1); i >=0; i--)
        {
            DBRecord *record = logChange[i];
            if (record[LOG_UUID] == nil || record[LOG_CLIENTUUID] == nil || [self tolocal_check_data:record[LOG_CLIENTUUID]] == nil || [self tolocal_check_data:record[LOG_UUID]] == nil)
            {
                [record deleteRecord];
                continue;
            }
            
            DBTable *logTable = [self.dropbox_store getTable:DB_LOG_TABLE];
            NSArray *arr = [logTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[LOG_UUID]] forKey:LOG_UUID] error:nil];
            if([arr count] > 1)
            {
                [logChange removeObjectsInArray:arr];
                i = i - (int)[arr count] + 1;
                record = [self getServerOnly_Data:arr tableName:DB_LOG_TABLE];
            }
            
            if (record[LOG_UUID] == nil || record[LOG_CLIENTUUID] == nil || [self tolocal_check_data:record[LOG_CLIENTUUID]] == nil || [self tolocal_check_data:record[LOG_UUID]] == nil)
            {
                [record deleteRecord];
            }
            else
            {
                NSMutableDictionary* subs = [NSMutableDictionary dictionary];
                [subs setObject:record[LOG_UUID] forKey:@"uuid"];
                NSArray* logsArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_LOG_TABLE searchSubPre:subs];
                NSNumber *drop_status = record[LOG_SYNCSTATUS];
                if([logsArray count] == 0)
                {
                    if ([drop_status integerValue] == 0)
                    {
                        DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
                        NSArray *arr = [cltTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[LOG_CLIENTUUID]] forKey:CLT_UUID] error:nil];
                        if ([arr count] == 0)
                        {
                            [record deleteRecord];
                        }
                        else
                        {
                            DBRecord *client_R = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
                            NSNumber *drop_status2 = client_R[CLT_SYNCSTATUS];
                            if ([drop_status2 integerValue] == 1)
                            {
                                record[LOG_SYNCSTATUS] = drop_status2;
                            }
                            else
                            {
                                [self serToLal_Log:nil serData:record];
                                isRefresh = YES;
                            }
                        }
                    }
                }
                else
                {
                    Logs *sel_log = (Logs *)[self getLocalOnly_Data:logsArray tableName:DB_LOG_TABLE];
                    if ([self syncCompare_LalLog:sel_log serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    //invoiceproperty
    {
        NSMutableArray *invptyChange = [NSMutableArray arrayWithArray:[changedDict[DB_INVOICEPERTY_TABLE] allObjects]];
        for (int i = (int)([invptyChange count] - 1); i >=0; i--)
        {
            DBRecord *record = invptyChange[i];
            if (record[INVPTY_UUID] == nil || record[INVPTY_PARENTUUID] == nil || [self tolocal_check_data:record[INVPTY_PARENTUUID]] == nil || [self tolocal_check_data:record[INVPTY_UUID]] == nil)
            {
                [record deleteRecord];
                continue;
            }
            
            DBTable *invptyTable = [self.dropbox_store getTable:DB_INVOICEPERTY_TABLE];
            NSArray *arr = [invptyTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INVPTY_UUID]] forKey:INVPTY_UUID] error:nil];
            if([arr count] > 1)
            {
                [invptyChange removeObjectsInArray:arr];
                i = i - (int)[arr count] + 1;
                record = [self getServerOnly_Data:arr tableName:DB_INVOICEPERTY_TABLE];
            }
            
            if (record[INVPTY_UUID] == nil || record[INVPTY_PARENTUUID] == nil || [self tolocal_check_data:record[INVPTY_PARENTUUID]] == nil || [self tolocal_check_data:record[INVPTY_UUID]] == nil)
            {
                [record deleteRecord];
            }
            else
            {
                NSMutableDictionary* subs = [NSMutableDictionary dictionary];
                [subs setObject:record[INVPTY_UUID] forKey:@"uuid"];
                NSArray* invptysArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICEPTY_TABLE searchSubPre:subs];
                NSNumber *drop_status = record[INVPTY_SYNCSTATUS];
                if([invptysArray count] == 0)
                {
                    if ([drop_status integerValue] == 0)
                    {
                        DBTable *invTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
                        NSArray *arr = [invTable query:[NSDictionary dictionaryWithObject:[self tolocal_check_data:record[INVPTY_PARENTUUID]] forKey:INV_UUID] error:nil];
                        if ([arr count] == 0)
                        {
                            [record deleteRecord];
                        }
                        else
                        {
                            DBRecord *inv_R = [self getServerOnly_Data:arr tableName:DB_INVOICE_TABLE];
                            NSNumber *drop_status2 = inv_R[INV_SYNCSTATUS];
                            if ([drop_status2 integerValue] == 1)
                            {
                                record[INVPTY_SYNCSTATUS] = drop_status2;
                            }
                            else
                            {
                                [self serToLal_InvProty:nil serData:record];
                                isRefresh = YES;
                            }
                        }
                    }
                }
                else
                {
                    Invoiceproperty *sel_invpty = (Invoiceproperty *)[self getLocalOnly_Data:invptysArray tableName:DB_INVOICEPERTY_TABLE];
                    if ([self syncCompare_LalInvpty:sel_invpty serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
            }
        }
    }
    [[DataBaseManger getBaseManger] saveDataBase];
    
    
    

    
    return isRefresh;
}




-(BOOL)isFlash_LocalToServer:(NSArray *)m_array
{
    if (self.dropbox_account)
    {
        BOOL isRefresh = NO;
        
        //获取所有本地数据
        NSMutableArray *changeList = [[NSMutableArray alloc] init];
        [changeList addObjectsFromArray:[self getDataSelect:m_array]];
        
        needMax = YES;
        countMax = 0;
        for(NSManagedObject *updateObj in changeList)
        {
            //client
            if([updateObj isKindOfClass:[Clients class]])
            {
                Clients *sel_clt = (Clients *)updateObj;
                if (sel_clt == nil || sel_clt.clientName == nil)
                {
                    continue;
                }
                
                DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
                //查找server中有无相同uuid的数据
                NSArray *arr = [cltTable query:[NSDictionary dictionaryWithObject:sel_clt.uuid forKey:CLT_UUID] error:nil];
                if([arr count] != 0)
                {
                    DBRecord *record = [self getServerOnly_Data:arr tableName:DB_CLIENT_TABLE];
                    if ([self syncCompare_LalClt:sel_clt serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
                else
                {
                    if ([sel_clt.sync_status integerValue] == 1)
                    {
                        [self serToLal_Clt:sel_clt serData:nil];
                    }
                    else
                    {
                        [self lalToSer_Rec:nil clt_lalData:sel_clt];
                    }
                }
            }
            //Invoice
            else if([updateObj isKindOfClass:[Invoice class]])
            {
                Invoice *sel_inv = (Invoice *)updateObj;
                if (sel_inv == nil || sel_inv.title == nil)
                {
                    continue;
                }
                
                DBTable *invTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
                NSArray *arr = [invTable query:[NSDictionary dictionaryWithObject:sel_inv.uuid forKey:INV_UUID] error:nil];
                if([arr count] != 0)
                {
                    DBRecord *record = [self getServerOnly_Data:arr tableName:DB_INVOICE_TABLE];
                    if ([self syncCompare_LalInv:sel_inv serData:record] == YES)
                    {
                        isRefresh = YES;
                    }
                }
                else
                {
                    if ([sel_inv.sync_status integerValue] == 1)
                    {
                        [self serToLal_Inv:sel_inv serData:nil];
                    }
                    else
                    {
                        [self lalToSer_Rec:nil inv_lalData:sel_inv];
                    }
                }
            }
            //Logs
            else if([updateObj isKindOfClass:[Logs class]])
            {
                Logs *sel_log = (Logs *)updateObj;
                if (sel_log == nil || sel_log.starttime == nil)
                {
                    continue;
                }
                
                DBTable *logTable = [self.dropbox_store getTable:DB_LOG_TABLE];
                NSArray *arr = [logTable query:[NSDictionary dictionaryWithObject:sel_log.uuid forKey:LOG_UUID] error:nil];
                if([arr count] != 0)
                {
                    DBRecord *record = [self getServerOnly_Data:arr tableName:DB_LOG_TABLE];
                    if ([self syncCompare_LalLog:sel_log serData:record])
                    {
                        isRefresh = YES;
                    }
                }
                else
                {
                    if ([sel_log.sync_status integerValue] == 1)
                    {
                        [self serToLal_Log:sel_log serData:nil];
                    }
                    else
                    {
                        [self lalToSer_Rec:nil log_lalData:sel_log];
                    }
                }
            }
            //property
            else if([updateObj isKindOfClass:[Invoiceproperty class]])
            {
                Invoiceproperty *sel_invpty = (Invoiceproperty *)updateObj;
                if (sel_invpty == nil || sel_invpty.name == nil)
                {
                    continue;
                }
                
                DBTable *invptyTable = [self.dropbox_store getTable:DB_INVOICEPERTY_TABLE];
                NSArray *arr = [invptyTable query:[NSDictionary dictionaryWithObject:sel_invpty.uuid forKey:INVPTY_UUID] error:nil];
                if([arr count] != 0)
                {
                    DBRecord *record = [self getServerOnly_Data:arr tableName:DB_INVOICEPERTY_TABLE];
                    if ([self syncCompare_LalInvpty:sel_invpty serData:record])
                    {
                        isRefresh = YES;
                    }
                }
                else
                {
                    if ([sel_invpty.sync_status integerValue] == 1)
                    {
                        [self serToLal_InvProty:sel_invpty serData:nil];
                    }
                    else
                    {
                        [self lalToSer_Rec:nil invproty_lalData:sel_invpty];
                    }
                }
            }
            
            if (countMax >= 1100)             //1157  实验超过此数 dropbox数据将崩溃！
            {
                break;
            }
        }
        needMax = NO;
        
        [[DataBaseManger getBaseManger] saveDataBase];

        if (countMax >= 1100)
        {
            [self isFlash_LocalToServer:nil];
        }
        
        return isRefresh;
    }
    else
    {
        return NO;
    }
}

/**
    获取本地的数据，当array是nil的时候，获取全部表格的数据
 */
-(NSMutableArray *)getDataSelect:(NSArray *)m_array
{
    NSMutableArray *m_dataArray = [[NSMutableArray alloc] init];
    if (m_array == nil)
    {
        [m_dataArray addObjectsFromArray:[[DataBaseManger getBaseManger] getDataArray_TableName:LC_CLIENT_TABLE searchSubPre:nil]];
        [m_dataArray addObjectsFromArray:[[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICE_TABLE searchSubPre:nil]];
        [m_dataArray addObjectsFromArray:[[DataBaseManger getBaseManger] getDataArray_TableName:LC_LOG_TABLE searchSubPre:nil]];
        [m_dataArray addObjectsFromArray:[[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICEPTY_TABLE searchSubPre:nil]];
    }
    else
    {
        NSMutableArray *dataObjectArray = [m_array objectAtIndex:0];
        NSNumber *releve = [m_array objectAtIndex:1];
        BOOL _isRelevance = releve.boolValue;
        
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        if (_isRelevance == YES)
        {
            for (NSManagedObject *dataObject in dataObjectArray)
            {
                if([dataObject isKindOfClass:[Clients class]])
                {
                    Clients *client = (Clients *)dataObject;
                    if (client.uuid != nil)
                    {
                        if ([m_dataArray containsObject:client] == NO)
                        {
                            [m_dataArray addObject:client];
                        }
                        for (Invoice *invoice in [appDelegate removeAlready_DeleteInv:[client.invoices allObjects]])
                        {
                            if (invoice.uuid != nil && [m_dataArray containsObject:invoice] == NO)
                            {
                                [m_dataArray addObject:invoice];
                            }
                        }
                        for (Logs *log in [appDelegate removeAlready_DeleteLog:[client.logs allObjects]])
                        {
                            if (log.uuid != nil && [m_dataArray containsObject:log] == NO)
                            {
                                [m_dataArray addObject:log];
                            }
                        }
                    }
                }
                else if([dataObject isKindOfClass:[Invoice class]])
                {
                    Invoice *invoice = (Invoice *)dataObject;
                    if (invoice.uuid != nil)
                    {
                        if ([m_dataArray containsObject:invoice] == NO)
                        {
                            [m_dataArray addObject:invoice];
                        }
                        for (Logs *log in [appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]])
                        {
                            if (log.uuid != nil && [m_dataArray containsObject:log] == NO)
                            {
                                [m_dataArray addObject:log];
                            }
                        }
                    }
                }
                else if([dataObject isKindOfClass:[Logs class]])
                {
                    Logs *log = (Logs *)dataObject;
                    if (log.uuid != nil)
                    {
                        if ([log.invoice allObjects] > 0)
                        {
                            Invoice *invoice = [[log.invoice allObjects] objectAtIndex:0];
                            if ([m_dataArray containsObject:invoice] == NO)
                            {
                                [m_dataArray addObject:invoice];
                            }
                        }
                        if ([m_dataArray containsObject:log] == NO)
                        {
                            [m_dataArray addObject:log];
                        }
                    }
                }
                else if([dataObject isKindOfClass:[Invoiceproperty class]])
                {
                    Invoiceproperty *invoiceProperty = (Invoiceproperty *)dataObject;
                    if (invoiceProperty.uuid != nil)
                    {
                        if (invoiceProperty.invoice != nil && [m_dataArray containsObject:invoiceProperty.invoice] == NO)
                        {
                            [m_dataArray addObject:invoiceProperty.invoice];
                        }
                        if ([m_dataArray containsObject:invoiceProperty] == NO)
                        {
                            [m_dataArray addObject:invoiceProperty];
                        }
                    }
                }
            }
        }
        else
        {
            [m_dataArray addObjectsFromArray:dataObjectArray];
        }
    }

    return m_dataArray;
}






-(int)secondCompare:(NSDate *)dt1 withDate:(NSDate *)dt2{
    if(dt1 == nil && dt2 == nil) return -2;
    else
        if(dt1 == nil &&dt2 !=nil) return 1;
        else  if(dt1 != nil &&dt2 ==nil) return -1;
    
    NSDateComponents *cmpday1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dt1];
    NSDateComponents *cmpday2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dt2];
    
    if([cmpday1 year] > [cmpday2 year])
        return 1;
    if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] > [cmpday2 month])
        return 1;
    if([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day] > [cmpday2 day])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day] == [cmpday2 day] && [cmpday1 hour]>[cmpday2 hour])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]>[cmpday2 minute])
        return 1;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]>[cmpday2 second])
        return 1;
    
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]==[cmpday2 second])
        return 0;
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]==[cmpday2 hour] && [cmpday1 minute]==[cmpday2 minute] && [cmpday1 second]<[cmpday2 second])
        return -1;
    
    return -1;
}




#pragma mark - compare
/**
    比较服务器端的一条数据 与 本地的一条数据，是谁替换谁
 */
-(BOOL)syncCompare_LalClt:(Clients *)sel_clt serData:(DBRecord *)sel_record
{
    BOOL isRefresh = NO;
    NSDate *localDate = sel_clt.accessDate;
    NSDate *serverDate = sel_record[CLT_ACCESSDATE];
    
    NSNumber *drop_status = sel_record[CLT_SYNCSTATUS];
    
    //如果server中的status==1表示 被删除了
    if([drop_status integerValue] == 1)
    {
        if ([sel_clt.sync_status integerValue] == 0)
        {
            isRefresh = YES;
        }
        //将本地的client传给这个方法
        [self serToLal_Clt:sel_clt serData:nil];
    }
    //如果local的status==1
    else if ([sel_clt.sync_status integerValue] == 1)
    {
        [self lalToSer_Rec:sel_record clt_lalData:sel_clt];
        [self serToLal_Clt:sel_clt serData:nil];
    }
    //local的时间比server的早，修改local
    else if ([localDate compare:serverDate] == NSOrderedAscending)
    {
        //以 server 为准
        if ([self tolocal_check_data:sel_record[CLT_UUID]] == nil)
        {
            [sel_record deleteRecord];
        }
        else
        {
            [self serToLal_Clt:sel_clt serData:sel_record];
            isRefresh = YES;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            //severTipStly ???
            if (appDelegate.severTipStly == 1)
            {
                appDelegate.severTipStly = 2;
            }
        }
    }
    else if ([localDate compare:serverDate] == NSOrderedDescending)
    {
        //以local 为准
        [self lalToSer_Rec:sel_record clt_lalData:sel_clt];
    }
    
    return isRefresh;
}

/**
    比较Invoice本地数据与服务器端数据
 */
-(BOOL)syncCompare_LalInv:(Invoice *)sel_inv serData:(DBRecord *)sel_record
{
    BOOL isRefresh = NO;
    NSDate *localDate = sel_inv.accessDate;
    NSDate *serverDate = sel_record[INV_ACCESSDATE];
    
    NSNumber *drop_status = sel_record[INV_SYNCSTATUS];
    if([drop_status integerValue] == 1)
    {
        if ([sel_inv.sync_status integerValue] == 0)
        {
            isRefresh = YES;
        }
        [self serToLal_Inv:sel_inv serData:nil];
    }
    else if ([sel_inv.sync_status integerValue] == 1)
    {
        [self lalToSer_Rec:sel_record inv_lalData:sel_inv];
        [self serToLal_Inv:sel_inv serData:nil];
    }
    else if ([localDate compare:serverDate] == NSOrderedAscending)
    {
        //以 server 为准
        if ([self tolocal_check_data:sel_record[INV_PARENTUUID]] == nil || [self tolocal_check_data:sel_record[INV_UUID]] == nil)
        {
            [sel_record deleteRecord];
        }
        else
        {
            [self serToLal_Inv:sel_inv serData:sel_record];
            isRefresh = YES;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.severTipStly == 1)
            {
                appDelegate.severTipStly = 2;
            }
        }
    }
    else if ([localDate compare:serverDate] == NSOrderedDescending)
    {
        //以local 为准
        [self lalToSer_Rec:sel_record inv_lalData:sel_inv];
    }
    
    return isRefresh;
}

-(BOOL)syncCompare_LalLog:(Logs *)sel_log serData:(DBRecord *)sel_record
{
    BOOL isRefresh = NO;
    NSDate *localDate = sel_log.accessDate;
    NSDate *serverDate = sel_record[LOG_ACCESSDATE];
    
    NSNumber *drop_status = sel_record[LOG_SYNCSTATUS];
    if([drop_status integerValue] == 1)
    {
        if ([sel_log.sync_status integerValue] == 0)
        {
            isRefresh = YES;
        }
        [self serToLal_Log:sel_log serData:nil];
    }
    else if ([sel_log.sync_status integerValue] == 1)
    {
        [self lalToSer_Rec:sel_record log_lalData:sel_log];
        [self serToLal_Log:sel_log serData:nil];
    }
    else if ([localDate compare:serverDate] == NSOrderedAscending)
    {
        //以 server 为准
        if ([self tolocal_check_data:sel_record[LOG_CLIENTUUID]] == nil || [self tolocal_check_data:sel_record[LOG_UUID]] == nil)
        {
            [sel_record deleteRecord];
        }
        else
        {
            [self serToLal_Log:sel_log serData:sel_record];
            isRefresh = YES;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.severTipStly == 1)
            {
                appDelegate.severTipStly = 2;
            }
        }
    }
    else if ([localDate compare:serverDate] == NSOrderedDescending)
    {
        //以local 为准
        [self lalToSer_Rec:sel_record log_lalData:sel_log];
    }
    
    return isRefresh;
}

-(BOOL)syncCompare_LalInvpty:(Invoiceproperty *)sel_invpty serData:(DBRecord *)sel_record
{
    BOOL isRefresh = NO;
    NSDate *localDate = sel_invpty.accessDate;
    NSDate *serverDate = sel_record[INVPTY_ACCESSDATE];
    
    NSNumber *drop_status = sel_record[INVPTY_SYNCSTATUS];
    if([drop_status integerValue] == 1)
    {
        if ([sel_invpty.sync_status integerValue] == 0)
        {
            isRefresh = YES;
        }
        [self serToLal_InvProty:sel_invpty serData:nil];
    }
    else if ([sel_invpty.sync_status integerValue] == 1)
    {
        [self lalToSer_Rec:sel_record invproty_lalData:sel_invpty];
        [self serToLal_InvProty:sel_invpty serData:nil];
    }
    else if ([localDate compare:serverDate] == NSOrderedAscending)
    {
        //以 server 为准
        if ([self tolocal_check_data:sel_record[INVPTY_PARENTUUID]] == nil || [self tolocal_check_data:sel_record[INVPTY_UUID]] == nil)
        {
            [sel_record deleteRecord];
        }
        else
        {
            [self serToLal_InvProty:sel_invpty serData:sel_record];
            isRefresh = YES;
            
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.severTipStly == 1)
            {
                appDelegate.severTipStly = 2;
            }
        }
    }
    else if ([localDate compare:serverDate] == NSOrderedDescending)
    {
        //以local 为准
        [self lalToSer_Rec:sel_record invproty_lalData:sel_invpty];
    }
    
    return isRefresh;
}





#pragma mark - ser-->loc
-(void)serToLal_Log:(Logs *)sel_log serData:(DBRecord *)sel_record
{
    if (sel_record == nil)
    {
        if (sel_log != nil)
        {
            [[DataBaseManger getBaseManger] deleleTAbleCell:sel_log];
        }
    }
    else
    {
        if (sel_log == nil)
        {
            sel_log = (Logs *)[[DataBaseManger getBaseManger] addTableCell:LC_LOG_TABLE];
            
            NSMutableDictionary* subs_client = [NSMutableDictionary dictionary];
            [subs_client setObject:[self tolocal_check_data:sel_record[LOG_CLIENTUUID]] forKey:@"uuid"];
            NSArray *clientArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_CLIENT_TABLE searchSubPre:subs_client];
            if ([clientArray count] > 0)
            {
                Clients *sel_client = [clientArray objectAtIndex:0];
                if (sel_client != nil)
                {
                    sel_log.client = sel_client;
                }
            }
        }
        
        
        sel_log.finalmoney = [self tolocal_check_data:sel_record[LOG_FINALMONEY]];
        sel_log.starttime = [self tolocal_check_data:sel_record[LOG_STARTTIME]];
        sel_log.endtime = [self tolocal_check_data:sel_record[LOG_ENDTIME]];
        sel_log.ratePerHour = [self tolocal_check_data:sel_record[LOG_RATEPERHOUR]];
        sel_log.totalmoney = [self tolocal_check_data:sel_record[LOG_TOTALMONEY]];
        sel_log.worked = [self tolocal_check_data:sel_record[LOG_WORKED]];
        sel_log.notes = [self tolocal_check_data:sel_record[LOG_NOTES]];
        sel_log.isInvoice = [self tolocal_check_data:sel_record[LOG_ISINVOICE]];
        sel_log.isPaid = [self tolocal_check_data:sel_record[LOG_ISPAID]];
        sel_log.uuid = [self tolocal_check_data:sel_record[LOG_UUID]];
        sel_log.invoice_uuid = [self tolocal_check_data:sel_record[LOG_INVOICEUUID]];
        sel_log.client_Uuid = [self tolocal_check_data:sel_record[LOG_CLIENTUUID]];
        sel_log.accessDate = [self tolocal_check_data:sel_record[LOG_ACCESSDATE]];
        sel_log.sync_status = [self tolocal_check_data:sel_record[LOG_SYNCSTATUS]];
        sel_log.overtimeFree = [self tolocal_check_data:sel_record[LOG_OVERTIMEFREE]];
        
        if (sel_log.invoice_uuid == nil)
        {
            if (sel_log.invoice != nil && [sel_log.invoice allObjects] > 0)
            {
                [sel_log removeInvoice:sel_log.invoice];
            }
        }
        else
        {
            NSMutableDictionary* subs_inv = [NSMutableDictionary dictionary];
            [subs_inv setObject:sel_log.invoice_uuid forKey:@"uuid"];
            NSArray *invArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICE_TABLE searchSubPre:subs_inv];
            if ([invArray count] > 0)
            {
                Invoice *sel_invoice = [invArray objectAtIndex:0];
                if (sel_invoice != nil)
                {
                    if (sel_log.invoice != nil && [sel_log.invoice allObjects] > 0)
                    {
                        [sel_log removeInvoice:sel_log.invoice];
                    }
                    
                    [sel_log addInvoiceObject:sel_invoice];
                }
            }
        }

        [[DataBaseManger getBaseManger] saveDataBase];

    }
}

/**
    ser 更新 local
 */
-(void)serToLal_Inv:(Invoice *)sel_inv serData:(DBRecord *)sel_record
{
    if (sel_record == nil)
    {
        if (sel_inv != nil)
        {
            [[DataBaseManger getBaseManger] deleleTAbleCell:sel_inv];
        }
    }
    else
    {
        if (sel_inv == nil)
        {
            sel_inv = (Invoice *)[[DataBaseManger getBaseManger] addTableCell:LC_INVOICE_TABLE];
        }
        
        sel_inv.title = [self tolocal_check_data:sel_record[INV_TITLE]];
        sel_inv.invoiceNO = [self tolocal_check_data:sel_record[INV_INVOICENO]];
        sel_inv.subtotal = [self tolocal_check_data:sel_record[INV_SUBTOTAL]];
        sel_inv.discount = [self tolocal_check_data:sel_record[INV_DISCOUNT]];
        sel_inv.tax = [self tolocal_check_data:sel_record[INV_TAX]];
        sel_inv.totalDue = [self tolocal_check_data:sel_record[INV_TOTALDUE]];
        sel_inv.paidDue = [self tolocal_check_data:sel_record[INV_PAIDDUE]];
        sel_inv.balanceDue = [self tolocal_check_data:sel_record[INV_BALANCEDUE]];
        sel_inv.dueDate = [self tolocal_check_data:sel_record[INV_DUEDATE]];
        sel_inv.terms = [self tolocal_check_data:sel_record[INV_TERMS]];
        sel_inv.message = [self tolocal_check_data:sel_record[INV_MESSAGE]];
        sel_inv.uuid = [self tolocal_check_data:sel_record[INV_UUID]];
        sel_inv.parentUuid = [self tolocal_check_data:sel_record[INV_PARENTUUID]];
        sel_inv.accessDate = [self tolocal_check_data:sel_record[INV_ACCESSDATE]];
        sel_inv.sync_status = [self tolocal_check_data:sel_record[INV_SYNCSTATUS]];
        
        NSMutableDictionary* subs_client = [NSMutableDictionary dictionary];
        [subs_client setObject:sel_inv.parentUuid forKey:@"uuid"];
        NSArray *clientArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_CLIENT_TABLE searchSubPre:subs_client];
        if ([clientArray count] > 0)
        {
            Clients *sel_client = [clientArray objectAtIndex:0];
            if (sel_client != nil)
            {
                sel_inv.client = sel_client;
            }
        }
        
        [[DataBaseManger getBaseManger] saveDataBase];

    }
}

/**
    server修改本地：
    如果server是nil:删除本地数据
    如果sel_client是nil的代表：local中没有这个数据，那么需要在本地新建一个数据
 */
-(void)serToLal_Clt:(Clients *)sel_clt serData:(DBRecord *)sel_record
{
    if (sel_record == nil)
    {
        if (sel_clt != nil)
        {
            [[DataBaseManger getBaseManger] deleleTAbleCell:sel_clt];
        }
    }
    else
    {
        if (sel_clt == nil)
        {
            sel_clt = (Clients *)[[DataBaseManger getBaseManger] addTableCell:LC_CLIENT_TABLE];
        }
        
        sel_clt.beginTime = [self tolocal_check_data:sel_record[CLT_BEGINTIME]];
        sel_clt.endTime = [self tolocal_check_data:sel_record[CLT_ENDTIME]];
        sel_clt.clientName = [self tolocal_check_data:sel_record[CLT_CLIENTNAME]];
        sel_clt.ratePerHour = [self tolocal_check_data:sel_record[CLT_RATEPERHOUR]];
        sel_clt.timeRoundTo = [self tolocal_check_data:sel_record[CLT_TIMEROUNDTO]];
        sel_clt.dailyOverFirstTax = [self tolocal_check_data:sel_record[CLT_DAILYFIRTAX]];
        sel_clt.dailyOverFirstHour = [self tolocal_check_data:sel_record[CLT_DAILYFIRHR]];
        sel_clt.dailyOverSecondTax = [self tolocal_check_data:sel_record[CLT_DAILYSECTAX]];
        sel_clt.dailyOverSecondHour = [self tolocal_check_data:sel_record[CLT_DAILYSECHR]];
        sel_clt.email = [self tolocal_check_data:sel_record[CLT_EMAIL]];
        sel_clt.phone = [self tolocal_check_data:sel_record[CLT_PHONE]];
        sel_clt.fax = [self tolocal_check_data:sel_record[CLT_FAX]];
        sel_clt.website = [self tolocal_check_data:sel_record[CLT_WEBSITE]];
        sel_clt.address = [self tolocal_check_data:sel_record[CLT_ADDRESS]];
        sel_clt.payPeriodStly = [self tolocal_check_data:sel_record[CLT_PAYSTLY]];
        sel_clt.payPeriodNum1 = [self tolocal_check_data:sel_record[CLT_PAYNUM1]];
        sel_clt.payPeriodNum2 = [self tolocal_check_data:sel_record[CLT_PAYNUM2]];
        sel_clt.payPeriodDate = [self tolocal_check_data:sel_record[CLT_PAYDATE]];
        sel_clt.uuid = [self tolocal_check_data:sel_record[CLT_UUID]];
        sel_clt.accessDate = [self tolocal_check_data:sel_record[CLT_ACCESSDATE]];

        sel_clt.sync_status = [self tolocal_check_data:sel_record[CLT_SYNCSTATUS]];
        sel_clt.r_isDaily = [self tolocal_check_data:sel_record[CLT_ISDAILY]];
        sel_clt.r_monRate = [self tolocal_check_data:sel_record[CLT_MONRATE]];
        sel_clt.r_tueRate = [self tolocal_check_data:sel_record[CLT_TUERATE]];
        sel_clt.r_wedRate = [self tolocal_check_data:sel_record[CLT_WEDRATE]];
        sel_clt.r_thuRate = [self tolocal_check_data:sel_record[CLT_THURATE]];
        sel_clt.r_friRate = [self tolocal_check_data:sel_record[CLT_FRIRATE]];
        sel_clt.r_satRate = [self tolocal_check_data:sel_record[CLT_SATRATE]];
        sel_clt.r_sunRate = [self tolocal_check_data:sel_record[CLT_SUNRATE]];
        sel_clt.weeklyOverFirstTax = [self tolocal_check_data:sel_record[CLT_WEEKLYFIRTAX]];
        sel_clt.weeklyOverFirstHour = [self tolocal_check_data:sel_record[CLT_WEEKLYFIRHR]];
        sel_clt.weeklyOverSecondTax = [self tolocal_check_data:sel_record[CLT_WEEKLYSECTAX]];
        sel_clt.weeklyOverSecondHour = [self tolocal_check_data:sel_record[CLT_WEEKLYSECHR]];
        sel_clt.r_weekRate = [self tolocal_check_data:sel_record[CLT_WEEKRATE]];
        
        [[DataBaseManger getBaseManger] saveDataBase];

        
    }
}

-(void)serToLal_InvProty:(Invoiceproperty *)sel_invpty serData:(DBRecord *)sel_record
{
    if (sel_record == nil)
    {
        if (sel_invpty != nil)
        {
            [[DataBaseManger getBaseManger] deleleTAbleCell:sel_invpty];
        }
    }
    else
    {
        if (sel_invpty == nil)
        {
            sel_invpty = (Invoiceproperty *)[[DataBaseManger getBaseManger] addTableCell:LC_INVOICEPTY_TABLE];
            
            NSMutableDictionary* subs_inv = [NSMutableDictionary dictionary];
            [subs_inv setObject:[self tolocal_check_data:sel_record[INVPTY_PARENTUUID]] forKey:@"uuid"];
            NSArray *invArray = [[DataBaseManger getBaseManger] getDataArray_TableName:LC_INVOICE_TABLE searchSubPre:subs_inv];
            if ([invArray count] > 0)
            {
                Invoice *sel_inv = [invArray objectAtIndex:0];
                if (sel_inv != nil)
                {
                    sel_invpty.invoice = sel_inv;
                }
            }
        }
        
        sel_invpty.quantity = [self tolocal_check_data:sel_record[INVPTY_QUANTITY]];
        sel_invpty.name = [self tolocal_check_data:sel_record[INVPTY_NAME]];
        sel_invpty.price = [self tolocal_check_data:sel_record[INVPTY_PRICE]];
        sel_invpty.tax = [self tolocal_check_data:sel_record[INVPTY_TAX]];
        sel_invpty.accessDate = [self tolocal_check_data:sel_record[INVPTY_ACCESSDATE]];
        sel_invpty.sync_status = [self tolocal_check_data:sel_record[INVPTY_SYNCSTATUS]];
        sel_invpty.uuid = [self tolocal_check_data:sel_record[INVPTY_UUID]];
        sel_invpty.parentUuid = [self tolocal_check_data:sel_record[INVPTY_PARENTUUID]];

        [[DataBaseManger getBaseManger] saveDataBase];
    }
}




#pragma mark - loc-->ser
-(void)lalToSer_Rec:(DBRecord *)sel_record log_lalData:(Logs *)sel_log
{
    if (needMax == YES)
    {
        countMax++;
    }
    DBTable *logTable = [self.dropbox_store getTable:DB_LOG_TABLE];
    if (sel_record == nil)
    {
        sel_record = [logTable insert:@{
                                            LOG_FINALMONEY      : [self todropbox_check_data:sel_log.finalmoney],
											LOG_STARTTIME		: [self todropbox_check_data:sel_log.starttime],
											LOG_ENDTIME         : [self todropbox_check_data:sel_log.endtime],
											LOG_RATEPERHOUR		: [self todropbox_check_data:sel_log.ratePerHour],
											LOG_TOTALMONEY		: [self todropbox_check_data:sel_log.totalmoney],
											LOG_WORKED			: [self todropbox_check_data:sel_log.worked],
											LOG_NOTES			: [self todropbox_check_data:sel_log.notes],
											LOG_ISINVOICE		: [self todropbox_check_data:sel_log.isInvoice],
                                            LOG_ISPAID          : [self todropbox_check_data:sel_log.isPaid],
                                            LOG_UUID            : [self todropbox_check_data:sel_log.uuid],
                                            LOG_INVOICEUUID     : [self todropbox_check_data:sel_log.invoice_uuid],
                                            LOG_CLIENTUUID      : [self todropbox_check_data:sel_log.client_Uuid],
                                            LOG_ACCESSDATE      : [self todropbox_check_data:sel_log.accessDate],
                                            LOG_SYNCSTATUS      : [self todropbox_check_data:sel_log.sync_status],
                                            LOG_OVERTIMEFREE    : [self todropbox_check_data:sel_log.overtimeFree]
                                        }
                      ];
    }
    else
    {
        sel_record[LOG_FINALMONEY] = [self todropbox_check_data:sel_log.finalmoney];
        sel_record[LOG_STARTTIME] = [self todropbox_check_data:sel_log.starttime];
        sel_record[LOG_ENDTIME] = [self todropbox_check_data:sel_log.endtime];
        sel_record[LOG_RATEPERHOUR] = [self todropbox_check_data:sel_log.ratePerHour];
        sel_record[LOG_TOTALMONEY] = [self todropbox_check_data:sel_log.totalmoney];
        sel_record[LOG_WORKED] = [self todropbox_check_data:sel_log.worked];
        sel_record[LOG_NOTES] = [self todropbox_check_data:sel_log.notes];
        sel_record[LOG_ISINVOICE] = [self todropbox_check_data:sel_log.isInvoice];
        sel_record[LOG_ISPAID] = [self todropbox_check_data:sel_log.isPaid];
        sel_record[LOG_UUID] = [self todropbox_check_data:sel_log.uuid];
        sel_record[LOG_INVOICEUUID] = [self todropbox_check_data:sel_log.invoice_uuid];
        sel_record[LOG_CLIENTUUID] = [self todropbox_check_data:sel_log.client_Uuid];
        sel_record[LOG_ACCESSDATE] = [self todropbox_check_data:sel_log.accessDate];
        sel_record[LOG_SYNCSTATUS] = [self todropbox_check_data:sel_log.sync_status];
        sel_record[LOG_OVERTIMEFREE] = [self todropbox_check_data:sel_log.overtimeFree];
    }
}

-(void)lalToSer_Rec:(DBRecord *)sel_record inv_lalData:(Invoice *)sel_inv
{
    if (needMax == YES)
    {
        countMax++;
    }
    DBTable *invTable = [self.dropbox_store getTable:DB_INVOICE_TABLE];
    if (sel_record == nil)
    {
        sel_record = [invTable insert:@{
                                            INV_TITLE           : [self todropbox_check_data:sel_inv.title],
                                            INV_INVOICENO       : [self todropbox_check_data:sel_inv.invoiceNO],
                                            INV_SUBTOTAL        : [self todropbox_check_data:sel_inv.subtotal],
                                            INV_DISCOUNT        : [self todropbox_check_data:sel_inv.discount],
                                            INV_TAX             : [self todropbox_check_data:sel_inv.tax],
                                            INV_TOTALDUE        : [self todropbox_check_data:sel_inv.totalDue],
                                            INV_PAIDDUE         : [self todropbox_check_data:sel_inv.paidDue],
                                            INV_BALANCEDUE      : [self todropbox_check_data:sel_inv.balanceDue],
                                            INV_DUEDATE         : [self todropbox_check_data:sel_inv.dueDate],
                                            INV_TERMS           : [self todropbox_check_data:sel_inv.terms],
                                            INV_MESSAGE         : [self todropbox_check_data:sel_inv.message],
                                            INV_UUID            : [self todropbox_check_data:sel_inv.uuid],
                                            INV_PARENTUUID      : [self todropbox_check_data:sel_inv.parentUuid],
                                            INV_ACCESSDATE      : [self todropbox_check_data:sel_inv.accessDate],
                                            INV_SYNCSTATUS      : [self todropbox_check_data:sel_inv.sync_status]
                                        }
                      ];
    }
    else
    {
        sel_record[INV_TITLE] = [self todropbox_check_data:sel_inv.title];
        sel_record[INV_INVOICENO] = [self todropbox_check_data:sel_inv.invoiceNO];
        sel_record[INV_SUBTOTAL] = [self todropbox_check_data:sel_inv.subtotal];
        sel_record[INV_DISCOUNT] = [self todropbox_check_data:sel_inv.discount];
        sel_record[INV_TAX] = [self todropbox_check_data:sel_inv.tax];
        sel_record[INV_TOTALDUE] = [self todropbox_check_data:sel_inv.totalDue];
        sel_record[INV_PAIDDUE] = [self todropbox_check_data:sel_inv.paidDue];
        sel_record[INV_BALANCEDUE] = [self todropbox_check_data:sel_inv.balanceDue];
        sel_record[INV_DUEDATE] = [self todropbox_check_data:sel_inv.dueDate];
        sel_record[INV_TERMS] = [self todropbox_check_data:sel_inv.terms];
        sel_record[INV_MESSAGE] = [self todropbox_check_data:sel_inv.message];
        sel_record[INV_UUID] = [self todropbox_check_data:sel_inv.uuid];
        sel_record[INV_PARENTUUID] = [self todropbox_check_data:sel_inv.parentUuid];
        sel_record[INV_ACCESSDATE] = [self todropbox_check_data:sel_inv.accessDate];
        sel_record[INV_SYNCSTATUS] = [self todropbox_check_data:sel_inv.sync_status];
    }
}

/**
    本地被删除了，将本地的数据同步到云端
    如果server为nil,添加一个数据到server中；
    如果server中有这个数据，就修改server中的数据
 */
-(void)lalToSer_Rec:(DBRecord *)sel_record clt_lalData:(Clients *)sel_clt
{
    if (needMax == YES)
    {
        countMax++;
    }
    DBTable *cltTable = [self.dropbox_store getTable:DB_CLIENT_TABLE];
    if (sel_record == nil)
    {
        sel_record = [cltTable insert:@{
                                            CLT_BEGINTIME       : [self todropbox_check_data:sel_clt.beginTime],
                                            CLT_ENDTIME         : [self todropbox_check_data:sel_clt.endTime],
                                            CLT_CLIENTNAME      : [self todropbox_check_data:sel_clt.clientName],
                                            CLT_RATEPERHOUR     : [self todropbox_check_data:sel_clt.ratePerHour],
                                            CLT_TIMEROUNDTO     : [self todropbox_check_data:sel_clt.timeRoundTo],
                                            CLT_DAILYFIRTAX     : [self todropbox_check_data:sel_clt.dailyOverFirstTax],
                                            CLT_DAILYFIRHR      : [self todropbox_check_data:sel_clt.dailyOverFirstHour],
                                            CLT_DAILYSECTAX     : [self todropbox_check_data:sel_clt.dailyOverSecondTax],
                                            CLT_DAILYSECHR      : [self todropbox_check_data:sel_clt.dailyOverSecondHour],
                                            CLT_EMAIL           : [self todropbox_check_data:sel_clt.email],
                                            CLT_PHONE           : [self todropbox_check_data:sel_clt.phone],
                                            CLT_FAX             : [self todropbox_check_data:sel_clt.fax],
                                            CLT_WEBSITE         : [self todropbox_check_data:sel_clt.website],
                                            CLT_ADDRESS         : [self todropbox_check_data:sel_clt.address],
                                            CLT_PAYSTLY         : [self todropbox_check_data:sel_clt.payPeriodStly],
                                            CLT_PAYNUM1         : [self todropbox_check_data:sel_clt.payPeriodNum1],
                                            CLT_PAYNUM2         : [self todropbox_check_data:sel_clt.payPeriodNum2],
                                            CLT_PAYDATE         : [self todropbox_check_data:sel_clt.payPeriodDate],
                                            CLT_UUID            : [self todropbox_check_data:sel_clt.uuid],
                                            CLT_ACCESSDATE      : [self todropbox_check_data:sel_clt.accessDate],
                                            CLT_SYNCSTATUS      : [self todropbox_check_data:sel_clt.sync_status],
                                            CLT_ISDAILY         : [self todropbox_check_data:sel_clt.r_isDaily],
                                            CLT_MONRATE         : [self todropbox_check_data:sel_clt.r_monRate],
                                            CLT_TUERATE         : [self todropbox_check_data:sel_clt.r_tueRate],
                                            CLT_WEDRATE         : [self todropbox_check_data:sel_clt.r_wedRate],
                                            CLT_THURATE         : [self todropbox_check_data:sel_clt.r_thuRate],
                                            CLT_FRIRATE         : [self todropbox_check_data:sel_clt.r_friRate],
                                            CLT_SATRATE         : [self todropbox_check_data:sel_clt.r_satRate],
                                            CLT_SUNRATE         : [self todropbox_check_data:sel_clt.r_sunRate],
                                            CLT_WEEKLYFIRTAX    : [self todropbox_check_data:sel_clt.weeklyOverFirstTax],
                                            CLT_WEEKLYFIRHR     : [self todropbox_check_data:sel_clt.weeklyOverFirstHour],
                                            CLT_WEEKLYSECTAX    : [self todropbox_check_data:sel_clt.weeklyOverSecondTax],
                                            CLT_WEEKLYSECHR     : [self todropbox_check_data:sel_clt.weeklyOverSecondHour],
                                            CLT_WEEKRATE         : [self todropbox_check_data:sel_clt.r_weekRate]
                                        }
                      ];
    }
    else
    {
        sel_record[CLT_BEGINTIME] = [self todropbox_check_data:sel_clt.beginTime];
        sel_record[CLT_ENDTIME] = [self todropbox_check_data:sel_clt.endTime];
        sel_record[CLT_CLIENTNAME] = [self todropbox_check_data:sel_clt.clientName];
        sel_record[CLT_RATEPERHOUR] = [self todropbox_check_data:sel_clt.ratePerHour];
        sel_record[CLT_TIMEROUNDTO] = [self todropbox_check_data:sel_clt.timeRoundTo];
        sel_record[CLT_DAILYFIRTAX] = [self todropbox_check_data:sel_clt.dailyOverFirstTax];
        sel_record[CLT_DAILYFIRHR] = [self todropbox_check_data:sel_clt.dailyOverFirstHour];
        sel_record[CLT_DAILYSECTAX] = [self todropbox_check_data:sel_clt.dailyOverSecondTax];
        sel_record[CLT_DAILYSECHR] = [self todropbox_check_data:sel_clt.dailyOverSecondHour];
        sel_record[CLT_EMAIL] = [self todropbox_check_data:sel_clt.email];
        sel_record[CLT_PHONE] = [self todropbox_check_data:sel_clt.phone];
        sel_record[CLT_FAX] = [self todropbox_check_data:sel_clt.fax];
        sel_record[CLT_WEBSITE] = [self todropbox_check_data:sel_clt.website];
        sel_record[CLT_ADDRESS] = [self todropbox_check_data:sel_clt.address];
        sel_record[CLT_PAYSTLY] = [self todropbox_check_data:sel_clt.payPeriodStly];
        sel_record[CLT_PAYNUM1] = [self todropbox_check_data:sel_clt.payPeriodNum1];
        sel_record[CLT_PAYNUM2] = [self todropbox_check_data:sel_clt.payPeriodNum2];
        sel_record[CLT_PAYDATE] = [self todropbox_check_data:sel_clt.payPeriodDate];
        sel_record[CLT_UUID] = [self todropbox_check_data:sel_clt.uuid];
        sel_record[CLT_ACCESSDATE] = [self todropbox_check_data:sel_clt.accessDate];
        sel_record[CLT_SYNCSTATUS] = [self todropbox_check_data:sel_clt.sync_status];
        sel_record[CLT_ISDAILY] = [self todropbox_check_data:sel_clt.r_isDaily];
        sel_record[CLT_MONRATE] = [self todropbox_check_data:sel_clt.r_monRate];
        sel_record[CLT_TUERATE] = [self todropbox_check_data:sel_clt.r_tueRate];
        sel_record[CLT_WEDRATE] = [self todropbox_check_data:sel_clt.r_wedRate];
        sel_record[CLT_THURATE] = [self todropbox_check_data:sel_clt.r_thuRate];
        sel_record[CLT_FRIRATE] = [self todropbox_check_data:sel_clt.r_friRate];
        sel_record[CLT_SATRATE] = [self todropbox_check_data:sel_clt.r_satRate];
        sel_record[CLT_SUNRATE] = [self todropbox_check_data:sel_clt.r_sunRate];
        sel_record[CLT_WEEKLYFIRTAX] = [self todropbox_check_data:sel_clt.weeklyOverFirstTax];
        sel_record[CLT_WEEKLYFIRHR] = [self todropbox_check_data:sel_clt.weeklyOverFirstHour];
        sel_record[CLT_WEEKLYSECTAX] = [self todropbox_check_data:sel_clt.weeklyOverSecondTax];
        sel_record[CLT_WEEKLYSECHR] = [self todropbox_check_data:sel_clt.weeklyOverSecondHour];
        sel_record[CLT_WEEKRATE] = [self todropbox_check_data:sel_clt.r_weekRate];
    }
}

-(void)lalToSer_Rec:(DBRecord *)sel_record invproty_lalData:(Invoiceproperty *)sel_invpty
{
    if (needMax == YES)
    {
        countMax++;
    }
    DBTable *invptyTable = [self.dropbox_store getTable:DB_INVOICEPERTY_TABLE];
    if (sel_record == nil)
    {
        sel_record = [invptyTable insert:@{
                                            INVPTY_QUANTITY           : [self todropbox_check_data:sel_invpty.quantity],
                                            INVPTY_NAME               : [self todropbox_check_data:sel_invpty.name],
                                            INVPTY_PRICE              : [self todropbox_check_data:sel_invpty.price],
                                            INVPTY_TAX                : [self todropbox_check_data:sel_invpty.tax],
                                            INVPTY_ACCESSDATE         : [self todropbox_check_data:sel_invpty.accessDate],
                                            INVPTY_SYNCSTATUS         : [self todropbox_check_data:sel_invpty.sync_status],
                                            INVPTY_UUID               : [self todropbox_check_data:sel_invpty.uuid],
                                            INVPTY_PARENTUUID         : [self todropbox_check_data:sel_invpty.parentUuid]
                                        }
                      ];
    }
    else
    {
        sel_record[INVPTY_QUANTITY] = [self todropbox_check_data:sel_invpty.quantity];
        sel_record[INVPTY_NAME] = [self todropbox_check_data:sel_invpty.name];
        sel_record[INVPTY_PRICE] = [self todropbox_check_data:sel_invpty.price];
        sel_record[INVPTY_TAX] = [self todropbox_check_data:sel_invpty.tax];
        sel_record[INVPTY_ACCESSDATE] = [self todropbox_check_data:sel_invpty.accessDate];
        sel_record[INVPTY_SYNCSTATUS] = [self todropbox_check_data:sel_invpty.sync_status];
        sel_record[INVPTY_UUID] = [self todropbox_check_data:sel_invpty.uuid];
        sel_record[INVPTY_PARENTUUID] = [self todropbox_check_data:sel_invpty.parentUuid];
    }
}




#pragma mark - security
-(id)getLocalOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name
{
    id returnID = nil;
    if ([dataArray count] == 1)
    {
        returnID = [dataArray objectAtIndex:0];
    }
    else
    {
        if ([table_name isEqualToString:DB_CLIENT_TABLE])
        {
            for (Clients *sel_data in dataArray)
            {
                if ([sel_data.sync_status integerValue] == 1)
                {
                    returnID = sel_data;
                    break;
                }
            }
            
            if (returnID == nil)
            {
                Clients *sel_data = [dataArray objectAtIndex:0];
                for (Clients *sel_red in dataArray)
                {
                    if ([sel_data.accessDate compare:sel_red.accessDate] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Clients *sel_data = (Clients *)returnID;
            for (Clients *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [self serToLal_Clt:sel_red serData:nil];
                }
            }
        }
        else if ([table_name isEqualToString:DB_INVOICE_TABLE])
        {
            for (Invoice *sel_data in dataArray)
            {
                if ([sel_data.sync_status integerValue] == 1)
                {
                    returnID = sel_data;
                    break;
                }
            }
            
            if (returnID == nil)
            {
                Invoice *sel_data = [dataArray objectAtIndex:0];
                for (Invoice *sel_red in dataArray)
                {
                    if ([sel_data.accessDate compare:sel_red.accessDate] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Invoice *sel_data = (Invoice *)returnID;
            for (Invoice *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [self serToLal_Inv:sel_red serData:nil];
                }
            }
        }
        else if ([table_name isEqualToString:DB_LOG_TABLE])
        {
            for (Logs *sel_data in dataArray)
            {
                if ([sel_data.sync_status integerValue] == 1)
                {
                    returnID = sel_data;
                    break;
                }
            }
            
            if (returnID == nil)
            {
                Logs *sel_data = [dataArray objectAtIndex:0];
                for (Logs *sel_red in dataArray)
                {
                    if ([sel_data.accessDate compare:sel_red.accessDate] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Logs *sel_data = (Logs *)returnID;
            for (Logs *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [self serToLal_Log:sel_red serData:nil];
                }
            }
        }
        else if ([table_name isEqualToString:DB_INVOICEPERTY_TABLE])
        {
            for (Invoiceproperty *sel_data in dataArray)
            {
                if ([sel_data.sync_status integerValue] == 1)
                {
                    returnID = sel_data;
                    break;
                }
            }
            
            if (returnID == nil)
            {
                Invoiceproperty *sel_data = [dataArray objectAtIndex:0];
                for (Invoiceproperty *sel_red in dataArray)
                {
                    if ([sel_data.accessDate compare:sel_red.accessDate] == NSOrderedAscending)
                    {
                        sel_data = sel_red;
                    }
                }
                returnID = sel_data;
            }
            
            Invoiceproperty *sel_data = (Invoiceproperty *)returnID;
            for (Invoiceproperty *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [self serToLal_InvProty:sel_red serData:nil];
                }
            }
        }
    }
    
    return returnID;
}

-(DBRecord *)getServerOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name
{
    DBRecord *sel_return = nil;
    if ([dataArray count] == 1)
    {
        sel_return = [dataArray objectAtIndex:0];
    }
    else
    {
        NSString *sel_syncStatu;
        if ([table_name isEqualToString:DB_CLIENT_TABLE])
        {
            sel_syncStatu = CLT_SYNCSTATUS;
        }
        else if ([table_name isEqualToString:DB_INVOICE_TABLE])
        {
            sel_syncStatu = INV_SYNCSTATUS;
        }
        else if ([table_name isEqualToString:DB_LOG_TABLE])
        {
            sel_syncStatu = LOG_SYNCSTATUS;
        }
        else if ([table_name isEqualToString:DB_INVOICEPERTY_TABLE])
        {
            sel_syncStatu = INVPTY_SYNCSTATUS;
        }
        
        for (DBRecord *sel_red in dataArray)
        {
            NSNumber *drop_status = sel_red[sel_syncStatu];
            if ([drop_status integerValue] == 1)
            {
                sel_return = sel_red;
                break;
            }
        }
        
        if (sel_return == nil)
        {
            NSString *sel_date;
            if ([table_name isEqualToString:DB_CLIENT_TABLE])
            {
                sel_date = CLT_ACCESSDATE;
            }
            else if ([table_name isEqualToString:DB_INVOICE_TABLE])
            {
                sel_date = INV_ACCESSDATE;
            }
            else if ([table_name isEqualToString:DB_LOG_TABLE])
            {
                sel_date = LOG_ACCESSDATE;
            }
            else if ([table_name isEqualToString:DB_INVOICEPERTY_TABLE])
            {
                sel_date = INVPTY_ACCESSDATE;
            }
            
            sel_return = [dataArray objectAtIndex:0];
            for (DBRecord *sel_red in dataArray)
            {
                NSDate *returnDate = sel_return[sel_date];
                NSDate *date2 = sel_red[sel_date];
                if ([returnDate compare:date2] == NSOrderedAscending)
                {
                    sel_return = sel_red;
                }
            }
        }
        
        for (DBRecord *sel_red in dataArray)
        {
            if (![sel_return isEqual:sel_red])
            {
                [sel_red deleteRecord];
            }
        }
    }
    
    return sel_return;
}

-(id)todropbox_check_data:(id)data;
{
    if (data == nil)
    {
        data = DROPBOX_NIL_DATA;
    }
    
    return data;
}

/**
    检测数据是不是正常的
 */
-(id)tolocal_check_data:(id)data
{
    if (data != nil && [data isKindOfClass:[NSString class]])
    {
        NSString *str = (NSString *)data;
        if ([str isEqualToString:DROPBOX_NIL_DATA])
        {
            return nil;
        }
    }
    
    return data;
}



@end
