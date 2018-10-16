//
//  ParseSyncHelper.m
//  HoursKeeper
//
//  Created by humingjing on 15/4/29.
//
//

#import "ParseSyncHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate_Shared.h"
#import "ParseSyncDefine.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"

#import "FileController.h"

#import "Logs.h"
#import "Profile.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

#import "Reachability.h"

@interface ParseSyncHelper ()
{
     BOOL isSyncSuccess;
}

@end

@implementation ParseSyncHelper


-(id)init
{
    self = [super init];
    if (self)
    {
        isNeedFlesh = NO;
                
        /*
         Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        //Change the host name here to change the server you want to monitor.
        NSString *remoteHostName = @"www.apple.com";
//        NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
        
        _hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [_hostReachability startNotifier];
        [self updateInterfaceWithReachability:_hostReachability];

    }
    return self;
}


//数据库通知
-(void)mocDidSaveNotification:(NSNotification *)notification
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *saveCtx=[notification object];
    //如果是当前线程的context发生了改变，当前线程就不需要改变
    if (saveCtx==appDelegate.managedObjectContext) {
        return;
    }
    //如果发送通知的线程的coor 不是主线程的coor 当前线程就不需要改变？？？
//    if (appDelegate.managedObjectContext.persistentStoreCoordinator!=saveCtx.persistentStoreCoordinator) {
//        return;
//    }
    //主线程的context做出改变
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });

}

#pragma mark 数据增删改
/**
 Client
 */
-(void)updateClientFromLocal:(Clients *)oneClient
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneClient.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_CLIENT predicate:pre];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        NSLog(@"33333");
        if ([data count]>0)
        {
            PFObject *serData;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [data firstObject];
            
            for (int i=1; i<[data count]; i++)
            {
                PFObject *oneObject = [data objectAtIndex:i];
                [oneObject delete];
            }
            
            [self saveServerClient:serData FromLocalClient:oneClient];
            
            if ([oneClient.sync_status intValue] == 1)
            {
                [appDelegate.managedObjectContext deleteObject:oneClient];
                [appDelegate.managedObjectContext save:&error];
            }
        }
        else
        {
            PFObject *serData;
            [self saveServerClient:serData FromLocalClient:oneClient];
        }
    }];
}

-(void)saveServerClient:(PFObject *)object FromLocalClient:(Clients *)localClient
{
    
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_CLIENT];
    }
    if (localClient.address != nil)
        [object setObject:localClient.address forKey:PF_CLIENT_ADDRESS];
    
    if (localClient.beginTime != nil)
        [object setObject:localClient.beginTime forKey:PF_CLIENT_BEGINTIME];
    else
        [object removeObjectForKey:PF_CLIENT_BEGINTIME];
    
    if (localClient.clientName != nil)
        [object setObject:localClient.clientName forKey:PF_CLIENT_CLIENTNAME];
    
    if (localClient.dailyOverFirstHour != nil)
        [object setObject:localClient.dailyOverFirstHour forKey:PF_CLIENT_DAILYOVERFIRSTHOUR];
    
    if (localClient.dailyOverFirstTax != nil)
        [object setObject:localClient.dailyOverFirstTax forKey:PF_CLIENT_DAILYOVERFIRSTTAX];
    
    if (localClient.dailyOverSecondHour != nil)
        [object setObject:localClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];
    
    if (localClient.dailyOverSecondTax != nil)
        [object setObject:localClient.dailyOverSecondTax forKey:PF_CLIENT_DAILYOVERSECONDTAX];
    
    if (localClient.email != nil)
        [object setObject:localClient.email forKey:PF_CLIENT_EMAIL];
    
    if (localClient.endTime != nil)
        [object setObject:localClient.endTime forKey:PF_CLIENT_ENDTIME];
    else
        [object removeObjectForKey:PF_CLIENT_ENDTIME];
    
    
    if (localClient.fax != nil)
        [object setObject:localClient.fax forKey:PF_CLIENT_FAX];
    
    if (localClient.payPeriodDate != nil)
        [object setObject:localClient.payPeriodDate forKey:PF_CLIENT_PAYPERIODDATE];
    
    if (localClient.payPeriodNum1 != nil)
        [object setObject:localClient.payPeriodNum1 forKey:PF_CLIENT_PAYPERIODNUM1];
    
    if (localClient.payPeriodNum2 != nil)
        [object setObject:localClient.payPeriodNum2 forKey:PF_CLIENT_PAYPERIODNUM2];
    
    if (localClient.payPeriodStly != nil)
        [object setObject:localClient.payPeriodStly forKey:PF_CLIENT_PAYPERIODSTLY];
    
    if (localClient.phone != nil)
        [object setObject:localClient.phone forKey:PF_CLIENT_PHONE];
    
    if (localClient.r_friRate != nil)
        [object setObject:localClient.r_friRate forKey:PF_CLIENT_R_FRIRATE];
    
    if (localClient.r_isDaily != nil)
        [object setObject:localClient.r_isDaily forKey:PF_CLIENT_R_ISDAILY];
    
    if (localClient.r_monRate != nil)
        [object setObject:localClient.r_monRate forKey:PF_CLIENT_R_MONRATE];
    
    if (localClient.r_satRate != nil)
        [object setObject:localClient.r_satRate forKey:PF_CLIENT_R_SATRATE];
    
    if (localClient.r_sunRate != nil)
        [object setObject:localClient.r_sunRate forKey:PF_CLIENT_R_SUNRATE];
    
    if (localClient.r_thuRate != nil)
        [object setObject:localClient.r_thuRate forKey:PF_CLIENT_R_THURATE];
    
    if (localClient.r_tueRate != nil)
        [object setObject:localClient.r_tueRate forKey:PF_CLIENT_R_TUERATE];
    
    if (localClient.r_wedRate != nil)
        [object setObject:localClient.r_wedRate forKey:PF_CLIENT_R_WEDRATE];
    
    if (localClient.r_weekRate != nil)
        [object setObject:localClient.r_weekRate forKey:PF_CLIENT_R_WEEKRATE];
    
    if (localClient.ratePerHour != nil)
        [object setObject:localClient.ratePerHour forKey:PF_CLIENT_RATEPERHOUR];
    
    if (localClient.timeRoundTo != nil)
        [object setObject:localClient.timeRoundTo forKey:PF_CLIENT_TIMEROUNDTO];
    
    if (localClient.website != nil)
        [object setObject:localClient.website forKey:PF_CLIENT_WEBSITE];
    
    if (localClient.weeklyOverFirstHour)
        [object setObject:localClient.weeklyOverFirstHour forKey:PF_CLIENT_WEEKLYOVERFIRSTHOUR];
    
    if (localClient.weeklyOverFirstTax != nil)
        [object setObject:localClient.weeklyOverFirstTax forKey:PF_CLIENT_WEEKLYOVERFIRSTTAX];
    
    if (localClient.weeklyOverSecondHour != nil)
        [object setObject:localClient.weeklyOverSecondHour forKey:PF_CLIENT_WEEKLYOVERSECONDHOUR];
    
    if (localClient.weeklyOverSecondTax != nil)
        [object setObject:localClient.weeklyOverSecondTax forKey:PF_CLIENT_WEEKLYOVERSECONDTAX];
    
    if (localClient.lunchStart != nil)
    {
        [object setObject:localClient.lunchStart forKey:PF_CLIENT_LUNCHSTART];
    }
    else
        [object removeObjectForKey:PF_CLIENT_LUNCHSTART];
    
    if (localClient.lunchTime != nil)
    {
        [object setObject:localClient.lunchTime forKey:PF_CLIENT_LUNCHTIME];
    }
    else
        [object removeObjectForKey:PF_CLIENT_LUNCHTIME];
    
    //parse
    if (localClient.accessDate != nil)
    {
        [object setObject:localClient.accessDate forKey:PF_CLIENT_ACCESSDATE];
    }
    if (localClient.uuid != nil)
        [object setObject:localClient.uuid forKey:PF_CLIENT_UUID];
    
    if ([localClient.sync_status intValue] == 0)
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    [object setObject:[PFUser currentUser] forKey:PF_User];
    
    [object saveInBackground];
}
/**
 Log
 */
-(void)updateLogFromLocal:(Logs *)oneLog
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneLog.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_LOGS predicate:pre];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        if ([data count]>0)
        {
            PFObject *serData;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [data firstObject];
            
            for (int i=1; i<[data count]; i++)
            {
                PFObject *oneObject = [data objectAtIndex:i];
                [oneObject delete];
            }
            
            [self saveServerLog:serData FromLocalLog:oneLog];
            
            if ([oneLog.sync_status intValue] == 1)
            {
                [appDelegate.managedObjectContext deleteObject:oneLog];
                [appDelegate.managedObjectContext save:&error];
            }
        }
        else
        {
            PFObject *serData;
            [self saveServerLog:serData FromLocalLog:oneLog];
        }
    }];
}

-(void)saveServerLog:(PFObject *)object FromLocalLog:(Logs *)localLog
{
    
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_LOGS];
    }
    if (localLog.client_Uuid != nil)
        [object setObject:localLog.client_Uuid forKey:PF_LOGS_CLIENTUUID];
    
    if (localLog.endtime != nil)
        [object setObject:localLog.endtime forKey:PF_CLIENT_ENDTIME];
    
    if (localLog.finalmoney != nil)
        [object setObject:localLog.finalmoney forKey:PF_LOGS_FINALMONEY];
    
    if (localLog.invoice_uuid != nil)
        [object setObject:localLog.invoice_uuid forKey:PF_LOGS_INVOICEUUID];
    
    if (localLog.isInvoice != nil)
        [object setObject:localLog.isInvoice forKey:PF_LOGS_ISINVOICE];
    
    if (localLog.isPaid != nil)
        [object setObject:localLog.isPaid forKey:PF_LOGS_ISPAID];
    
    if (localLog.notes != nil)
        [object setObject:localLog.notes forKey:PF_LOGS_NOTES];
    
    if (localLog.overtimeFree != nil)
        [object setObject:localLog.overtimeFree forKey:PF_LOGS_OVERTIMEFREE];
    
    if (localLog.ratePerHour != nil)
        [object setObject:localLog.ratePerHour forKey:PF_LOGS_RATEPERHOUR];
    
    if (localLog.starttime != nil)
        [object setObject:localLog.starttime forKey:PF_LOGS_STARTTIME];
    
    if (localLog.totalmoney != nil)
        [object setObject:localLog.totalmoney forKey:PF_LOGS_TOTALMONSY];
    
    
    //parse need
    if (localLog.worked != nil)
        [object setObject:localLog.worked forKey:PF_LOGS_WORKED];
    
    //本地存在则ser为1，本地不存在则ser为0
    if (localLog.sync_status != nil && [localLog.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    if (localLog.uuid != nil)
        [object setObject:localLog.uuid forKey:PF_LOGS_UUID];
    
    if (localLog.accessDate != nil)
        [object setObject:localLog.accessDate forKey:PF_LOGS_ACCESSDATE];
    
    
    [object setObject:[PFUser currentUser] forKey:PF_User];
    [object saveInBackground];
}
/**
 Invoice
 */
-(void)updateInvoiceFromLocal:(Invoice *)oneInvoice
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneInvoice.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICE predicate:pre];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        if ([data count]>0)
        {
            PFObject *serData;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [data firstObject];
            
            for (int i=1; i<[data count]; i++)
            {
                PFObject *oneObject = [data objectAtIndex:i];
                [oneObject delete];
            }
            
            [self saveServerInvoice:serData FromLocalInvoice:oneInvoice];
            
            if ([oneInvoice.sync_status intValue] == 1)
            {
                [appDelegate.managedObjectContext deleteObject:oneInvoice];
                [appDelegate.managedObjectContext save:&error];
            }
//            [serData saveInBackground];
        }
        else
        {
            PFObject *serData;
            [self saveServerInvoice:serData FromLocalInvoice:oneInvoice];
//            [serData saveInBackground];
        }
    }];
}

-(void)saveServerInvoice:(PFObject *)object FromLocalInvoice:(Invoice *)localInvoice
{
    
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_INVOICE];
    }
    if (localInvoice.balanceDue != nil)
        [object setObject:localInvoice.balanceDue forKey:PF_INVOICE_BALANCEDUE];
    
    if (localInvoice.discount != nil)
        [object setObject:localInvoice.discount forKey:PF_INVOICE_DISCOUNT];
    
    if (localInvoice.dueDate != nil)
        [object setObject:localInvoice.dueDate forKey:PF_INVOICE_DUEDATE];
    
    if (localInvoice.invoiceNO != nil)
        [object setObject:localInvoice.invoiceNO forKey:PF_INVOICE_INVOICENO];
    
    if (localInvoice.message != nil)
        [object setObject:localInvoice.message forKey:PF_INVOICE_MESSAGE];
    
    if (localInvoice.paidDue != nil)
        [object setObject:localInvoice.paidDue forKey:PF_INVOICE_PAIDDUE];
    
    if (localInvoice.subtotal != nil)
        [object setObject:localInvoice.subtotal forKey:PF_INVOICE_SUBTOTAL];
    
    if (localInvoice.tax != nil)
        [object setObject:localInvoice.tax forKey:PF_INVOICE_TAX];
    
    if (localInvoice.terms != nil)
        [object setObject:localInvoice.terms forKey:PF_INVOICE_TERMS];
    
    if (localInvoice.title != nil)
        [object setObject:localInvoice.title forKey:PF_INVOICE_TITLE];
    
    if (localInvoice.toDate != nil)
        [object setObject:localInvoice.toDate forKey:PF_INVOICE_TODATE];
    
    if (localInvoice.totalDue != nil)
        [object setObject:localInvoice.totalDue forKey:PF_INVOICE_TOTALDUE];
    
    //外键
    if (localInvoice.client != nil)
        [object setObject:localInvoice.client.uuid forKey:PF_INVOICE_CLIENT];
    
    //parse need
    //本地存在则ser为1，本地不存在则ser为0
    if (localInvoice.sync_status != nil && [localInvoice.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    if (localInvoice.uuid != nil)
        [object setObject:localInvoice.uuid forKey:PF_INVOICE_UUID];
    
    if (localInvoice.accessDate != nil)
        [object setObject:localInvoice.accessDate forKey:PF_INVOICE_ACCESSDATE];
    
    [object setObject:[PFUser currentUser] forKey:PF_User];

    [object saveInBackground];
}
/**
 InvoiceProperty
 */
-(void)updateInvoicePropertyFromLocal:(Invoiceproperty *)oneInvoiceProperty
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneInvoiceProperty.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICEPROPERTY predicate:pre];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        if ([data count]>0)
        {
            PFObject *serData;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [data firstObject];
            
            for (int i=1; i<[data count]; i++)
            {
                PFObject *oneObject = [data objectAtIndex:i];
                [oneObject delete];
            }
            
            [self saveServerInvoiceProperty:serData FromLocalInvoiceProperty:oneInvoiceProperty];
            
            if ([oneInvoiceProperty.sync_status intValue] == 1)
            {
                [appDelegate.managedObjectContext deleteObject:oneInvoiceProperty];
                [appDelegate.managedObjectContext save:&error];
            }
//            [serData saveInBackground];
        }
        else
        {
            PFObject *serData;
            [self saveServerInvoiceProperty:serData FromLocalInvoiceProperty:oneInvoiceProperty];
//            [serData saveInBackground];
        }
    }];
}

-(void)saveServerInvoiceProperty:(PFObject *)object FromLocalInvoiceProperty:(Invoiceproperty *)localInvoiceProperty
{
    
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_INVOICEPROPERTY];
    }
    
    if (localInvoiceProperty.name!= nil)
        [object setObject:localInvoiceProperty.name forKey:PF_PROPERTY_NAME];
    
    if (localInvoiceProperty.price != nil)
        [object setObject:localInvoiceProperty.price forKey:PF_PROPERTY_PRICE];
    
    if (localInvoiceProperty.quantity != nil)
        [object setObject:localInvoiceProperty.quantity forKey:PF_PROPERTY_QUANTITY];
    
    if (localInvoiceProperty.tax != nil)
        [object setObject:localInvoiceProperty.tax forKey:PF_PROPERTY_TAX];
    
    //invoice外键
    if (localInvoiceProperty.invoice.uuid != nil)
        [object setObject:localInvoiceProperty.invoice.uuid forKey:PF_PROPERTY_INVOICE];
    
    //parse need
    if (localInvoiceProperty.uuid != nil)
        [object setObject:localInvoiceProperty.uuid forKey:PF_PROPERTY_UUID];
    
    if (localInvoiceProperty.accessDate != nil)
        [object setObject:localInvoiceProperty.accessDate forKey:PF_PROPERTY_ACCESSDATE];
    
    [object setObject:[PFUser currentUser] forKey:PF_User];

    
    //本地存在则ser为1，本地不存在则ser为0
    if (localInvoiceProperty.sync_status != nil && [localInvoiceProperty.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    [object saveInBackground];
}
-(void)updateProfileFromLocal:(Profile *)oneProfile
{
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneProfile.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *data,NSError *error){
        if ([data count]>0)
        {
            PFObject *serData;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [data sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [data firstObject];
            
            for (int i=1; i<[data count]; i++)
            {
                PFObject *oneObject = [data objectAtIndex:i];
                [oneObject delete];
            }
            
            [self saveServerProfile:serData FromLocalProfile:oneProfile];
            
            if ([oneProfile.sync_status intValue] == 1)
            {
                [appDelegate.managedObjectContext deleteObject:oneProfile];
                [appDelegate.managedObjectContext save:&error];
            }
            [serData saveInBackground];
        }
        else
        {
            PFObject *serData;
            [self saveServerProfile:serData FromLocalProfile:oneProfile];
            [serData saveInBackground];
        }
    }];
}
-(void)saveServerProfile:(PFObject *)object FromLocalProfile:(Profile *)localProfile
{
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_PROFILE];
    }
    
    if (localProfile.state != nil)
        [object setObject:localProfile.state forKey:PF_PROFILE_STATE];
    
    if (localProfile.city != nil)
        [object setObject:localProfile.city forKey:PF_PROFILE_CITY];
    
    if (localProfile.company != nil)
        [object setObject:localProfile.company forKey:PF_PROFILE_COMPANY];
    
    if (localProfile.email != nil)
        [object setObject:localProfile.email forKey:PF_PROFILE_EMAIL];
    
    if (localProfile.fax != nil)
        [object setObject:localProfile.fax forKey:PF_PROFILE_FAX];
    
    if (localProfile.firstName != nil)
    {
        [object setObject:localProfile.firstName forKey:PF_PROFILE_FIRSTNAME];
    }
    
    if (localProfile.lastName != nil)
    {
        [object setObject:localProfile.lastName forKey:PF_PROFILE_LASTNAME];
    }
    
    if (localProfile.phone != nil)
        [object setObject:localProfile.phone forKey:PF_PROFILE_PHONE];
    
    if (localProfile.street != nil)
        [object setObject:localProfile.street forKey:PF_PROFILE_STREET];
    
    if (localProfile.zip != nil)
        [object setObject:localProfile.zip forKey:PF_PROFILE_ZIP];
    
    //parse
    if (localProfile.uuid != nil)
    {
        [object setObject:localProfile.uuid forKey:PF_PROFILE_UUID];
    }
    if (localProfile.sync_status != nil && [localProfile.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    if (localProfile.accessDate != nil)
        [object setObject:localProfile.accessDate forKey:PF_PROFILE_ACCESSDATE];
    
    
    //head image
    NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:filepath];
        PFFile *headImageFile = [PFFile fileWithName:@"headImage" data:imageData];
        
        [object setObject:headImageFile forKey:PF_PROFILE_HEADIMAGE];
    }
    else
        [object removeObjectForKey:PF_PROFILE_HEADIMAGE];
    
    
    //save head image
    PFFile *imageFile;
    if (localProfile.headImage != nil)
    {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        NSString *nameString;
        if (ISPAD)
        {
            nameString = [NSString stringWithFormat:@"%@headImage.jpg",appDelegate_iPad.appUser.objectId];
        }
        else
            nameString = [NSString stringWithFormat:@"%@headImage.jpg",appDelegate.appUser.objectId];
        
        
        imageFile = [PFFile fileWithName:nameString data:UIImageJPEGRepresentation(localProfile.headImage, 1.0)];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [object setObject:[PFUser currentUser] forKey:PF_User];

                
                [object setObject:imageFile forKey:PF_PROFILE_HEADIMAGE];
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     ;
                 }];
            }

        }];
        
        
        
    }

}

#pragma mark Sync
/*
    isAutoSync:手动同步
    需要手动同步的地方有：
    1.还原时，将parse上数据state置为1;
    2.还原时，将parse上的数据下载下来;
 */

-(void)syncAllWithTip:(BOOL)isTip
{
//    Log(@"123456789");
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.isBackup)
    {
        appDelegate.isSyncing = NO;
        return;
    }
    
    //如果登出了，但是不需要登陆也可以用就不需要同步
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
    if ((ISPAD && appDelegate_iPad.appUser==nil)||(!ISPAD && appDelegate_iPhone.appUser==nil)) {
        return;
    }
    
    //创建数据库另外一个上下文上下文
    _childCtx = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _childCtx.persistentStoreCoordinator=appDelegate.persistentStoreCoordinator;

    
    [_childCtx performBlock:^{

        
        isSyncSuccess = YES;
        isNeedFlesh = NO;
        //监听其他线程的保存行为
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        
        //当前在上传被还原的数据时,不需要后台同步
        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
        
        if ([defaults2 integerForKey:@"IsRestore"] != 1)
        {
            //如果服务器端版本与本地数据库版本不一样提醒用户选择
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            PFObject *profile = [appDelegate.parseSync fetchServerProfile];

            
            //服务器端被还原过了，并且 本地有数据，并且服务器端有本地数据版本不一样，提醒用户
            if ([profile objectForKey:DATABASE_VERSION]!=nil
                 && [self isLocalDatabaseHasData]
                && ![[userDefault stringForKey:DATABASE_VERSION] isEqualToString:[profile objectForKey:DATABASE_VERSION]])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Database instance from local and server are not aligned. Which one do you want to set as primary database?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Local",@"Server",nil];
                appDelegate.close_PopView = alertView;
                [alertView show];
                return ;
            }
            else
            {
                //设置同步标志,如果用户正在同步的话，提醒用户等待。如果登出的时候，有数据没有被同步的话，提醒用户同步等待同步，或者手动同步。
                appDelegate.isSyncing = YES;
                
                //服务器端被还原过 && 本地是新下载的应用(无数据) && 本地没有被还原过 直接设置本地的版本信息
                if ([profile objectForKey:DATABASE_VERSION]!=nil
                    && ![self isLocalDatabaseHasData]
                    && [userDefault stringForKey:DATABASE_VERSION]==nil
                    ) {
                    [userDefault setObject:[profile objectForKey:DATABASE_VERSION] forKey:DATABASE_VERSION];
                    [userDefault synchronize];
                }
            
                
//                NSLog(@"同步开始...");

                
                
                if(!ISPAD)
                {
                    AppDelegate_iPhone *appDelegaet_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
                    [appDelegaet_iPhone.mainViewController.leftMenu syncAnimationBegain];
                }
                
                
                NSFetchRequest *fetchSetting = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
                NSError *error = nil;
                NSArray *settingArray = [_childCtx executeFetchRequest:fetchSetting error:&error];
                Settings *oneObject = (Settings *)[settingArray lastObject];
                
                NSDate *nowDate = [NSDate date];
                lastSyncTime = oneObject.lastSyncDate;
                Log(@"开始上传时间:%@",nowDate);
                Log(@"sync begin:%@",lastSyncTime);
                

//                if (lastSyncTime == nil)
//                {
//                    NSLog(@"最后同步时间为nil");
//                }
//                else
//                {
//                    NSLog(@"最后同步时间为%@",oneObject.lastSyncDate);
//
//                }
                
                
                
                AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
                AppDelegate_iPad    *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
                //只有当没有登出的时候才会同步
                if((!ISPAD && appDelegate.appUser != nil)  || (ISPAD && appDelegate_iPad.appUser!=nil))
                {
//                    [self syncProfileisChildContext:YES];
                    [self syncProfile];
                    [self syncClient];
                    [self syncInvoice];
                    [self syncInvoiceProperty];
                    [self syncLog];
                    
                    if (isSyncSuccess)
                    {
                        oneObject.lastSyncDate = nowDate;
                        [_childCtx save:nil];
                        Log(@"上传结束时间:%@\n\n",[NSDate date]);

                    }

                }
                
                
                if(!ISPAD)
                {
                    AppDelegate_iPhone *appDelegaet_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
                    [appDelegaet_iPhone.mainViewController.leftMenu syncAnimationEnd];
                }
                
//                NSLog(@"同步完成");
                

            }
        }
        

        
        
        //移除通知
        NSNotificationCenter *not=[NSNotificationCenter defaultCenter];
        [not removeObserver:self];

        
        //iphone
        if (!ISPAD)
        {
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
            
            
            if (appDelegate.appUser)
            {
                AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
                if (appDelegate.isBackup)
                {
                    appDelegate.isSyncing = NO;
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //自动同步
                    if (![appDelegate.appSetting.autoSync isEqualToString:@"NO"])
                    {
                        [self performSelector:@selector(syncAllWithTip:) withObject:nil afterDelay:30];
                        if (isNeedFlesh)
                        {
                            [appDelegate dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                            
                        }
                    }
                    //手动同步
                    else
                    {
                        if(isTip)
                            [appDelegate dropbox_ServToLacl_FlashDate_UI_WithTip:YES];
                        else
                            [appDelegate dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                    }
                    
                });
            }
            appDelegate.isSyncing = NO;

            appDelegate.mainViewController.leftMenu.syncBtn2.userInteractionEnabled = YES;
        }
        //ipad
        else
        {
            AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
            
            
            if (appDelegate_iPad.appUser)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (![appDelegate.appSetting.autoSync isEqualToString:@"NO"])
                    {
                        [self performSelector:@selector(syncAllWithTip:) withObject:nil afterDelay:30];
                        if (isNeedFlesh)
                        {
                            [appDelegate_iPad dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                            
                        }
                    }
                    else
                    {
                        if(isTip)
                            [appDelegate_iPad dropbox_ServToLacl_FlashDate_UI_WithTip:YES];
                        else
                            [appDelegate_iPad dropbox_ServToLacl_FlashDate_UI_WithTip:NO];
                    }
                    
                });
            }
            
        }
        
        //移除同步标签
        appDelegate.isSyncing = NO;

    }];

}

-(BOOL)isAnyDataWerenotSync
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchSetting = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    NSArray *settingArray = [appDelegate.managedObjectContext executeFetchRequest:fetchSetting error:&error];
    Settings *oneObject = (Settings *)[settingArray lastObject];
    NSDate *syncTime = oneObject.lastSyncDate;
    
    NSMutableArray *clientArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_CLIENT changedSince:syncTime context:appDelegate.managedObjectContext]];
    NSMutableArray *logdArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_LOGS changedSince:syncTime context:appDelegate.managedObjectContext]];
    NSMutableArray *invoiceArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICE changedSince:syncTime context:appDelegate.managedObjectContext]];
    NSMutableArray *propertyArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICEPROPERTY changedSince:syncTime context:appDelegate.managedObjectContext]];
//    NSMutableArray *profileArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_PROFILE changedSince:syncTime context:appDelegate.managedObjectContext]];
    
    if ([clientArray count]>0 ||
        [logdArray count]>0 ||
        [invoiceArray count]>0 ||
        [propertyArray count]>0
        )
    {
        return YES;
    }
    else
        return NO;

    
}
-(BOOL)isLocalDatabaseHasData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
//    NSFetchRequest *cilent = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_CLIENT];
//    NSArray *clientArray = [appDelegate.managedObjectContext executeFetchRequest:cilent error:&error];
    
    
    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_PROFILE];
    NSArray *profileArray = [appDelegate.managedObjectContext executeFetchRequest:fetchProfile error:&error];
    if ([profileArray count]>0)
    {
        return YES;
    }
    else
        return NO;
}
#pragma mark Client
/*
    Clients同步
 */
-(void)syncClient
{
    Log(@"sync Client");

    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_CLIENT changedSince:lastSyncTime context:_childCtx]];
    
    for (int i=0; i<[localChangedArray count]; i++)
    {
        Clients *oneClient = [localChangedArray objectAtIndex:i];
        [self updateEveryClientLocalWithChildContext:oneClient];
    }
    //获取server中变化的数据
    NSArray *serverArray = [self getServerObjectsOfClass:PF_TABLE_CLIENT updatedSince:lastSyncTime];
    if (serverArray != nil)
    {
        for (int i=0; i<[serverArray count]; i++)
        {
            PFObject *oneObject = [serverArray objectAtIndex:i];
            
            [self updateEveryClientServerWithChildContext:oneObject];
        }
    }
}

-(void)updateEveryClientLocalWithChildContext:(Clients *)localClient
{
        if (localClient.uuid == nil)
            return;

        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],localClient.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_CLIENT predicate:pre];
        

        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [localClient.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_CLIENT_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalClient:localClient withServerClient:serData isChildContext:YES];
            }
            else if (locDate > serDate)
                [self saveServerClient:serData withLocaldata:localClient isChildContext:YES];
            else
                ;
            
        }
        else
            [self saveServerClient:serData withLocaldata:localClient isChildContext:YES];
}

-(void)updateEveryClientServerWithChildContext:(PFObject *)serverClient
{
    if([serverClient objectForKey:PF_CLIENT_UUID]==nil)
    {
        [serverClient delete];
        return;
    }

    //查找本地
    Clients *localClient = [self fetchLocalDataWithClass:PF_TABLE_CLIENT uuid:[serverClient objectForKey:PF_CLIENT_UUID] isChildContext:YES];
    
    if(localClient != nil)
    {
        u_int64_t locDate = [localClient.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serverClient objectForKey:PF_CLIENT_ACCESSDATE] timeIntervalSince1970];

        if (locDate < serDate)
        {
            [self saveLocalClient:localClient withServerClient:serverClient isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerClient:serverClient withLocaldata:localClient isChildContext:YES];
        else
            ;
    }
    else
    {
        if([[serverClient objectForKey:PF_SYNCSTATUS]intValue] !=1)
        {
            [self saveLocalClient:nil withServerClient:serverClient isChildContext:YES];
        }
    }
}

/*
    本地往服务器端传，如果是删除，最后将本地的直接删除就好，不用关心级联。
 */
-(void)saveServerClient:(PFObject *)object withLocaldata:(Clients *)localClient isChildContext:(BOOL)isChildContext
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_CLIENT];
    }
    if (localClient.address != nil)
        [object setObject:localClient.address forKey:PF_CLIENT_ADDRESS];
    else
        [object removeObjectForKey:PF_CLIENT_ADDRESS];
    
    if (localClient.beginTime != nil)
        [object setObject:localClient.beginTime forKey:PF_CLIENT_BEGINTIME];
    else
        [object removeObjectForKey:PF_CLIENT_BEGINTIME];
    
    if (localClient.clientName != nil)
        [object setObject:localClient.clientName forKey:PF_CLIENT_CLIENTNAME];
    
    if (localClient.dailyOverFirstHour != nil)
        [object setObject:localClient.dailyOverFirstHour forKey:PF_CLIENT_DAILYOVERFIRSTHOUR];

    if (localClient.dailyOverFirstTax != nil)
        [object setObject:localClient.dailyOverFirstTax forKey:PF_CLIENT_DAILYOVERFIRSTTAX];

    if (localClient.dailyOverSecondHour != nil)
        [object setObject:localClient.dailyOverSecondHour forKey:PF_CLIENT_DAILYOVERSECONDHOUR];

    if (localClient.dailyOverSecondTax != nil)
        [object setObject:localClient.dailyOverSecondTax forKey:PF_CLIENT_DAILYOVERSECONDTAX];

    if (localClient.email != nil)
        [object setObject:localClient.email forKey:PF_CLIENT_EMAIL];
    else
        [object removeObjectForKey:PF_CLIENT_EMAIL];
    
    if (localClient.endTime != nil)
        [object setObject:localClient.endTime forKey:PF_CLIENT_ENDTIME];
    else
        [object removeObjectForKey:PF_CLIENT_ENDTIME];
    

    if (localClient.fax != nil)
        [object setObject:localClient.fax forKey:PF_CLIENT_FAX];
    else
        [object removeObjectForKey:PF_CLIENT_FAX];

    if (localClient.payPeriodDate != nil)
        [object setObject:localClient.payPeriodDate forKey:PF_CLIENT_PAYPERIODDATE];
    else
        [object removeObjectForKey:PF_CLIENT_PAYPERIODDATE];
    
    if (localClient.payPeriodNum1 != nil)
        [object setObject:localClient.payPeriodNum1 forKey:PF_CLIENT_PAYPERIODNUM1];
    
    if (localClient.payPeriodNum2 != nil)
        [object setObject:localClient.payPeriodNum2 forKey:PF_CLIENT_PAYPERIODNUM2];
    
    if (localClient.payPeriodStly != nil)
        [object setObject:localClient.payPeriodStly forKey:PF_CLIENT_PAYPERIODSTLY];
    
    if (localClient.phone != nil)
        [object setObject:localClient.phone forKey:PF_CLIENT_PHONE];
    else
        [object removeObjectForKey:PF_CLIENT_PHONE];
    
    if (localClient.r_friRate != nil)
        [object setObject:localClient.r_friRate forKey:PF_CLIENT_R_FRIRATE];
    
    if (localClient.r_isDaily != nil)
        [object setObject:localClient.r_isDaily forKey:PF_CLIENT_R_ISDAILY];
    
    if (localClient.r_monRate != nil)
        [object setObject:localClient.r_monRate forKey:PF_CLIENT_R_MONRATE];
    
    if (localClient.r_satRate != nil)
        [object setObject:localClient.r_satRate forKey:PF_CLIENT_R_SATRATE];
    
    if (localClient.r_sunRate != nil)
        [object setObject:localClient.r_sunRate forKey:PF_CLIENT_R_SUNRATE];
    
    if (localClient.r_thuRate != nil)
        [object setObject:localClient.r_thuRate forKey:PF_CLIENT_R_THURATE];
    
    if (localClient.r_tueRate != nil)
        [object setObject:localClient.r_tueRate forKey:PF_CLIENT_R_TUERATE];
    
    if (localClient.r_wedRate != nil)
        [object setObject:localClient.r_wedRate forKey:PF_CLIENT_R_WEDRATE];
    
    if (localClient.r_weekRate != nil)
        [object setObject:localClient.r_weekRate forKey:PF_CLIENT_R_WEEKRATE];
    
    if (localClient.ratePerHour != nil)
        [object setObject:localClient.ratePerHour forKey:PF_CLIENT_RATEPERHOUR];
    
    if (localClient.timeRoundTo != nil)
        [object setObject:localClient.timeRoundTo forKey:PF_CLIENT_TIMEROUNDTO];
    
    if (localClient.website != nil)
        [object setObject:localClient.website forKey:PF_CLIENT_WEBSITE];
    else
        [object removeObjectForKey:PF_CLIENT_WEBSITE];
    
    if (localClient.weeklyOverFirstHour)
        [object setObject:localClient.weeklyOverFirstHour forKey:PF_CLIENT_WEEKLYOVERFIRSTHOUR];
    
    if (localClient.weeklyOverFirstTax != nil)
        [object setObject:localClient.weeklyOverFirstTax forKey:PF_CLIENT_WEEKLYOVERFIRSTTAX];
    
    if (localClient.weeklyOverSecondHour != nil)
        [object setObject:localClient.weeklyOverSecondHour forKey:PF_CLIENT_WEEKLYOVERSECONDHOUR];
    
    if (localClient.weeklyOverSecondTax != nil)
        [object setObject:localClient.weeklyOverSecondTax forKey:PF_CLIENT_WEEKLYOVERSECONDTAX];
    
    if (localClient.lunchStart != nil)
    {
        [object setObject:localClient.lunchStart forKey:PF_CLIENT_LUNCHSTART];
    }
    else
        [object removeObjectForKey:PF_CLIENT_LUNCHSTART];
    
    if (localClient.lunchTime != nil)
    {
        [object setObject:localClient.lunchTime forKey:PF_CLIENT_LUNCHTIME];
    }
    else
        [object removeObjectForKey:PF_CLIENT_LUNCHTIME];
    
    //parse
    if (localClient.accessDate != nil)
    {
        [object setObject:localClient.accessDate forKey:PF_CLIENT_ACCESSDATE];
    }
    if (localClient.uuid != nil)
        [object setObject:localClient.uuid forKey:PF_CLIENT_UUID];
    
    if ([localClient.sync_status intValue] == 0)
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    [object setObject:[PFUser currentUser] forKey:PF_User];

    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            NSError *error = nil;
            
            if ([localClient.sync_status intValue]==1)
            {
                [context deleteObject:localClient];
            }
            [context save:&error];

        }
        else
        {
            if (error && isChildContext)
            {
                isSyncSuccess = NO;
            }
        }
    }];
    
}

-(void)saveLocalClient:(Clients *)localClient withServerClient:(PFObject *)pfClient isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    //删
    if ([[pfClient objectForKey:PF_SYNCSTATUS]intValue]==1)
    {
        if(localClient != nil)
        {
            [[DataBaseManger getBaseManger] do_deletClient:localClient withManual:NO];
        }
    }
    //增/改
    else
    {
        if (localClient == nil)
        {
            localClient = [NSEntityDescription insertNewObjectForEntityForName:PF_TABLE_CLIENT inManagedObjectContext:context];

        }
        localClient.address = [pfClient objectForKey:PF_CLIENT_ADDRESS];
        localClient.beginTime = [pfClient objectForKey:PF_CLIENT_BEGINTIME];
        localClient.clientName = [pfClient objectForKey:PF_CLIENT_CLIENTNAME];
        localClient.dailyOverFirstHour = [pfClient objectForKey:PF_CLIENT_DAILYOVERFIRSTHOUR];
        localClient.dailyOverFirstTax = [pfClient objectForKey:PF_CLIENT_DAILYOVERFIRSTTAX];
        localClient.dailyOverSecondHour = [pfClient objectForKey:PF_CLIENT_DAILYOVERSECONDHOUR];
        localClient.dailyOverSecondTax = [pfClient objectForKey:PF_CLIENT_DAILYOVERSECONDTAX];
        localClient.email = [pfClient objectForKey:PF_CLIENT_EMAIL];
        localClient.endTime = [pfClient objectForKey:PF_CLIENT_ENDTIME];
        localClient.fax = [pfClient objectForKey:PF_CLIENT_FAX];
        localClient.payPeriodDate = [pfClient objectForKey:PF_CLIENT_PAYPERIODDATE];
        localClient.payPeriodNum1 = [pfClient objectForKey:PF_CLIENT_PAYPERIODNUM1];
        localClient.payPeriodNum2 = [pfClient objectForKey:PF_CLIENT_PAYPERIODNUM2];
        localClient.payPeriodStly = [pfClient objectForKey:PF_CLIENT_PAYPERIODSTLY];
        localClient.phone = [pfClient objectForKey:PF_CLIENT_PHONE];
        localClient.r_friRate = [pfClient objectForKey:PF_CLIENT_R_FRIRATE];
        localClient.r_isDaily = [pfClient objectForKey:PF_CLIENT_R_ISDAILY];
        localClient.r_monRate = [pfClient objectForKey:PF_CLIENT_R_MONRATE];
        localClient.r_satRate = [pfClient objectForKey:PF_CLIENT_R_SATRATE];
        localClient.r_sunRate = [pfClient objectForKey:PF_CLIENT_R_SUNRATE];
        localClient.r_thuRate = [pfClient objectForKey:PF_CLIENT_R_THURATE];
        localClient.r_tueRate = [pfClient objectForKey:PF_CLIENT_R_TUERATE];
        localClient.r_wedRate = [pfClient objectForKey:PF_CLIENT_R_WEDRATE];
        localClient.r_weekRate = [pfClient objectForKey:PF_CLIENT_R_WEEKRATE];
        localClient.ratePerHour = [pfClient objectForKey:PF_CLIENT_RATEPERHOUR];
        localClient.timeRoundTo = [pfClient objectForKey:PF_CLIENT_TIMEROUNDTO];
        localClient.website = [pfClient objectForKey:PF_CLIENT_WEBSITE];
        localClient.weeklyOverFirstHour = [pfClient objectForKey:PF_CLIENT_WEEKLYOVERFIRSTHOUR];
        localClient.weeklyOverFirstTax = [pfClient objectForKey:PF_CLIENT_WEEKLYOVERFIRSTTAX];
        localClient.weeklyOverSecondHour = [pfClient objectForKey:PF_CLIENT_WEEKLYOVERSECONDHOUR];
        localClient.weeklyOverSecondTax = [pfClient objectForKey:PF_CLIENT_WEEKLYOVERSECONDTAX];
        
        localClient.lunchTime = [pfClient objectForKey:PF_CLIENT_LUNCHTIME];
        localClient.lunchStart = [pfClient objectForKey:PF_CLIENT_LUNCHSTART];
        
        //parse
        localClient.uuid = [pfClient objectForKey:PF_CLIENT_UUID];
        localClient.sync_status = [NSNumber numberWithInt:0];
        localClient.accessDate = [pfClient objectForKey:PF_CLIENT_ACCESSDATE];
        
        [context save:&error];
    }
    
    isNeedFlesh = YES;
}


#pragma mark Logs
/*
    Logs同步
 */
-(void)syncLog
{
    Log(@"sync Log");

    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_LOGS changedSince:lastSyncTime context:_childCtx]];
    
    for (int i=0; i<[localChangedArray count]; i++)
    {
        Logs *oneLog = [localChangedArray objectAtIndex:i];
        [self updateEveryLogLocalWithChildContext:oneLog];
    }
    //获取server中变化的数据
    NSArray *serverArray = [self getServerObjectsOfClass:PF_TABLE_LOGS updatedSince:lastSyncTime];
    if (serverArray != nil)
    {
        for (int i=0; i<[serverArray count]; i++)
        {
            PFObject *oneObject = [serverArray objectAtIndex:i];
            
            [self updateEveryLogServerWithChildContext:oneObject];
        }
    }

}
-(void)updateEveryLogLocalWithChildContext:(Logs *)localLog
{
    
    if (localLog.uuid == nil)
        return;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],localLog.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_LOGS predicate:pre];
    
    //会占用主线程
    NSError *error = nil;
    NSArray *objects = [query findObjects:&error];
    if (error)
    {
        isSyncSuccess = NO;
        return;
    }
    
    PFObject *serData;
    if ([objects count]>0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
        [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        serData = [objects firstObject];
    }
    
    for (int i=1; i<[objects count]; i++)
    {
        PFObject *oneObject = [objects objectAtIndex:i];
        [oneObject delete];
    }
    
    if (serData)
    {
        //比较时间
        u_int64_t locDate = [localLog.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serData objectForKey:PF_LOGS_ACCESSDATE] timeIntervalSince1970];
        if (locDate < serDate)
        {
            [self saveLocalLog:localLog withServerLog:serData isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerLog:serData withLocaldata:localLog isChildContext:YES];
        else
            ;
        
    }
    else
        [self saveServerLog:serData withLocaldata:localLog isChildContext:YES];
    

}

-(void)updateEveryLogServerWithChildContext:(PFObject *)serverLog
{
    if([serverLog objectForKey:PF_LOGS_UUID]==nil)
    {
        [serverLog delete];
        return;
    }
    //查找本地
    Logs *localLog = [self fetchLocalDataWithClass:PF_TABLE_LOGS uuid:[serverLog objectForKey:PF_LOGS_UUID] isChildContext:YES];
    if(localLog != nil)
    {
        u_int64_t locDate = [localLog.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serverLog objectForKey:PF_LOGS_ACCESSDATE] timeIntervalSince1970];

        if (locDate < serDate)
        {
            [self saveLocalLog:localLog withServerLog:serverLog isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerLog:serverLog withLocaldata:localLog isChildContext:YES];
        else
            ;
    }
    else
    {
        if ([[serverLog objectForKey:PF_SYNCSTATUS]intValue] ==0)
        {
            [self saveLocalLog:nil withServerLog:serverLog isChildContext:YES];
        }
        
    }
    
}


-(void)saveServerLog:(PFObject *)object withLocaldata:(Logs *)localLog isChildContext:(BOOL)isChildContext
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_LOGS];
    }
    if (localLog.client_Uuid != nil)
        [object setObject:localLog.client_Uuid forKey:PF_LOGS_CLIENTUUID];
    
    if (localLog.endtime != nil)
        [object setObject:localLog.endtime forKey:PF_CLIENT_ENDTIME];

    
    if (localLog.finalmoney != nil)
        [object setObject:localLog.finalmoney forKey:PF_LOGS_FINALMONEY];

    
    if (localLog.invoice_uuid != nil)
        [object setObject:localLog.invoice_uuid forKey:PF_LOGS_INVOICEUUID];
    else
        [object removeObjectForKey:PF_LOGS_INVOICEUUID];
    
    if (localLog.isInvoice != nil)
        [object setObject:localLog.isInvoice forKey:PF_LOGS_ISINVOICE];
    
    if (localLog.isPaid != nil)
        [object setObject:localLog.isPaid forKey:PF_LOGS_ISPAID];
    
    if (localLog.notes != nil)
        [object setObject:localLog.notes forKey:PF_LOGS_NOTES];
    else
        [object removeObjectForKey:PF_LOGS_NOTES];
    
    if (localLog.overtimeFree != nil)
        [object setObject:localLog.overtimeFree forKey:PF_LOGS_OVERTIMEFREE];
    
    if (localLog.ratePerHour != nil)
        [object setObject:localLog.ratePerHour forKey:PF_LOGS_RATEPERHOUR];

    if (localLog.starttime != nil)
        [object setObject:localLog.starttime forKey:PF_LOGS_STARTTIME];
    
    if (localLog.totalmoney != nil)
        [object setObject:localLog.totalmoney forKey:PF_LOGS_TOTALMONSY];
    
    
    //parse need
    if (localLog.worked != nil)
        [object setObject:localLog.worked forKey:PF_LOGS_WORKED];
    
    //本地存在则ser为1，本地不存在则ser为0
    if (localLog.sync_status != nil && [localLog.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    if (localLog.uuid != nil)
        [object setObject:localLog.uuid forKey:PF_LOGS_UUID];
    
    if (localLog.accessDate != nil)
        [object setObject:localLog.accessDate forKey:PF_LOGS_ACCESSDATE];
    

    [object setObject:[PFUser currentUser] forKey:PF_User];

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             if ([localLog.sync_status intValue]==1)
             {
                 [context deleteObject:localLog];
                 [context save:&error];
             }
         }
         else
         {
             isSyncSuccess = NO;

         }
     }];
}

-(void)saveLocalLog:(Logs *)localLog withServerLog:(PFObject *)pfLog isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    //删
    if ([[pfLog objectForKey:PF_SYNCSTATUS]intValue]==1)
    {
        if(localLog != nil)
        {
            [context deleteObject:localLog];
            [context save:&error];
        }
    }
    //增/改
    else
    {
        if (localLog == nil)
        {
            localLog = [NSEntityDescription insertNewObjectForEntityForName:PF_TABLE_LOGS inManagedObjectContext:context];
        }
        localLog.client_Uuid = [pfLog objectForKey:PF_LOGS_CLIENTUUID];
        localLog.endtime = [pfLog objectForKey:PF_LOGS_ENDTIME];
        localLog.finalmoney = [pfLog objectForKey:PF_LOGS_FINALMONEY];
        localLog.invoice_uuid = [pfLog objectForKey:PF_LOGS_INVOICEUUID];
        localLog.isInvoice = [pfLog objectForKey:PF_LOGS_ISINVOICE];
        localLog.isPaid = [pfLog objectForKey:PF_LOGS_ISPAID];
        localLog.notes = [pfLog objectForKey:PF_LOGS_NOTES];
        localLog.overtimeFree = [pfLog objectForKey:PF_LOGS_OVERTIMEFREE];
        localLog.ratePerHour = [pfLog objectForKey:PF_LOGS_RATEPERHOUR];
        localLog.starttime = [pfLog objectForKey:PF_LOGS_STARTTIME];
        localLog.totalmoney = [pfLog objectForKey:PF_LOGS_TOTALMONSY];
        localLog.worked = [pfLog objectForKey:PF_LOGS_WORKED];
        
        //parse
        localLog.uuid  = [pfLog objectForKey:PF_LOGS_UUID];
        localLog.sync_status = [NSNumber numberWithInt:0];
        localLog.accessDate = [pfLog objectForKey:PF_LOGS_ACCESSDATE];
        
        
        //外键
        Clients *oneClient = [self fetchLocalDataWithClass:PF_TABLE_CLIENT uuid:localLog.client_Uuid isChildContext:isChildContext];
        if (oneClient != nil)
        {
            localLog.client = oneClient;
        }
        
        Invoice *oneInvoice = [self fetchLocalDataWithClass:PF_TABLE_INVOICE uuid:localLog.invoice_uuid isChildContext:isChildContext];
        if (oneInvoice != nil)
        {
            if (localLog.invoice != nil && [localLog.invoice count]>0)
            {
                [localLog removeInvoice:localLog.invoice];
            }
            [localLog addInvoiceObject:oneInvoice];
        }

        [context save:&error];
        
    }
    
    isNeedFlesh = YES;
    
}

#pragma mark Invoice Property
-(void)syncInvoiceProperty
{
    Log(@"sync Property");

    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICEPROPERTY changedSince:lastSyncTime context:_childCtx]];
    for (int i=0; i<[localChangedArray count]; i++)
    {
        Invoiceproperty *oneProperty = [localChangedArray objectAtIndex:i];
        [self updateEveryInvoicePropertyLocalWithChildContext:oneProperty];
    }
    //获取server中变化的数据
    NSArray *serverArray = [self getServerObjectsOfClass:PF_TABLE_INVOICEPROPERTY updatedSince:lastSyncTime];
    if (serverArray != nil)
    {
        for (int i=0; i<[serverArray count]; i++)
        {
            PFObject *oneObject = [serverArray objectAtIndex:i];
            
            [self updateEveryInvoicePropertyServerWithChildContext:oneObject];
        }
    }

}

-(void)updateEveryInvoicePropertyLocalWithChildContext:(Invoiceproperty *)localProperty
{
    
    if (localProperty.uuid == nil)
        return;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],localProperty.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICEPROPERTY predicate:pre];
    
    //会占用主线程
    NSError *error = nil;
    NSArray *objects = [query findObjects:&error];
    if (error)
    {
        isSyncSuccess = NO;
        return;
    }
    
    PFObject *serData;
    if ([objects count]>0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
        [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        serData = [objects firstObject];
    }
    
    for (int i=1; i<[objects count]; i++)
    {
        PFObject *oneObject = [objects objectAtIndex:i];
        [oneObject delete];
    }
    
    if (serData)
    {
        //比较时间
        u_int64_t locDate = [localProperty.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serData objectForKey:PF_PROPERTY_ACCESSDATE] timeIntervalSince1970];
        if (locDate < serDate)
        {
            [self saveLocalInvoiceProperty:localProperty withServerInvoiceProperty:serData isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerInvoiceProperty:serData withLocaldata:localProperty isChildContext:YES];
        else
            ;
        
    }
    else
        [self saveServerInvoiceProperty:serData withLocaldata:localProperty isChildContext:YES];
    
    
}

-(void)updateEveryInvoicePropertyServerWithChildContext:(PFObject *)serverProperty
{
    if([serverProperty objectForKey:PF_PROPERTY_UUID]==nil)
    {
        [serverProperty delete];
        return;
    }

    //查找本地
    Invoiceproperty *localProperty = [self fetchLocalDataWithClass:PF_TABLE_INVOICEPROPERTY uuid:[serverProperty objectForKey:PF_PROPERTY_UUID] isChildContext:YES];
    if (localProperty != nil)
    {
        u_int64_t locDate = [localProperty.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serverProperty objectForKey:PF_PROPERTY_ACCESSDATE] timeIntervalSince1970];
        if (locDate < serDate)
        {
            [self saveLocalInvoiceProperty:localProperty withServerInvoiceProperty:serverProperty isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerInvoiceProperty:serverProperty withLocaldata:localProperty isChildContext:YES];
        else
            ;
    }
    else
    {
        if([[serverProperty objectForKey:PF_SYNCSTATUS]intValue] ==0)
            [self saveLocalInvoiceProperty:nil withServerInvoiceProperty:serverProperty isChildContext:YES];

    }
}


-(void)saveServerInvoiceProperty:(PFObject *)object withLocaldata:(Invoiceproperty *)localInvoicdeProperty isChildContext:(BOOL)isChildContext
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_INVOICEPROPERTY];
    }
    
    if (localInvoicdeProperty.name!= nil)
        [object setObject:localInvoicdeProperty.name forKey:PF_PROPERTY_NAME];
    
    if (localInvoicdeProperty.price != nil)
        [object setObject:localInvoicdeProperty.price forKey:PF_PROPERTY_PRICE];
    
    if (localInvoicdeProperty.quantity != nil)
        [object setObject:localInvoicdeProperty.quantity forKey:PF_PROPERTY_QUANTITY];
    
    if (localInvoicdeProperty.tax != nil)
        [object setObject:localInvoicdeProperty.tax forKey:PF_PROPERTY_TAX];
    
    //invoice外键
    if (localInvoicdeProperty.invoice.uuid != nil)
        [object setObject:localInvoicdeProperty.invoice.uuid forKey:PF_PROPERTY_INVOICE];
    
    //parse need
    if (localInvoicdeProperty.uuid != nil)
        [object setObject:localInvoicdeProperty.uuid forKey:PF_PROPERTY_UUID];
    
    if (localInvoicdeProperty.accessDate != nil)
        [object setObject:localInvoicdeProperty.accessDate forKey:PF_PROPERTY_ACCESSDATE];

    [object setObject:[PFUser currentUser] forKey:PF_User];

    //本地存在则ser为1，本地不存在则ser为0
    if (localInvoicdeProperty.sync_status != nil && [localInvoicdeProperty.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             
             if ([localInvoicdeProperty.sync_status intValue]==1)
             {
                 [context deleteObject:localInvoicdeProperty];
                 [context save:&error];
             }
         }
         else
         {
             isSyncSuccess = NO;

         }
     }];
}
-(void)saveLocalInvoiceProperty:(Invoiceproperty *)localInvoiceProperty withServerInvoiceProperty:(PFObject *)pfInvoiceProperty isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    //删
    if ([[pfInvoiceProperty objectForKey:PF_SYNCSTATUS]intValue]!=0)
    {
        if(localInvoiceProperty != nil)
        {
            [context deleteObject:localInvoiceProperty];
            [context save:nil];
            
        }
    }
    //增/改
    else
    {
        if (localInvoiceProperty == nil)
        {
            localInvoiceProperty = [NSEntityDescription insertNewObjectForEntityForName:PF_TABLE_INVOICEPROPERTY inManagedObjectContext:context];
        }
        localInvoiceProperty.name = [pfInvoiceProperty objectForKey:PF_PROPERTY_NAME];
        localInvoiceProperty.price = [pfInvoiceProperty objectForKey:PF_PROPERTY_PRICE];
        localInvoiceProperty.quantity = [pfInvoiceProperty objectForKey:PF_PROPERTY_QUANTITY];
        localInvoiceProperty.tax = [pfInvoiceProperty objectForKey:PF_PROPERTY_TAX];

        
        //parse
        localInvoiceProperty.uuid = [pfInvoiceProperty objectForKey:PF_PROPERTY_UUID];
        localInvoiceProperty.sync_status = [NSNumber numberWithInt:0];
        localInvoiceProperty.accessDate = [pfInvoiceProperty objectForKey:PF_PROPERTY_ACCESSDATE];
        
        
        //外键
        Invoice *oneInvoice = [self fetchLocalDataWithClass:PF_TABLE_INVOICE uuid:[pfInvoiceProperty objectForKey:PF_PROPERTY_INVOICE]  isChildContext:isChildContext];
        if (oneInvoice != nil)
        {
            localInvoiceProperty.invoice = oneInvoice;
        }
        
        [context save:&error];

        
    }
    
    isNeedFlesh = YES;

}

#pragma mark Invoice
/*
    Invoice 同步
 */
-(void)syncInvoice
{
    Log(@"sync Invoice");

    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICE changedSince:lastSyncTime context:_childCtx]];
    for (int i=0; i<[localChangedArray count]; i++)
    {
        Invoice *oneInvoice = [localChangedArray objectAtIndex:i];
        [self updateEveryInvoiceLocalWithChildContext:oneInvoice];
    }
    //获取server中变化的数据
    NSArray *serverArray = [self getServerObjectsOfClass:PF_TABLE_INVOICE updatedSince:lastSyncTime];
    if (serverArray != nil)
    {
        for (int i=0; i<[serverArray count]; i++)
        {
            PFObject *oneObject = [serverArray objectAtIndex:i];
            
            [self updateEveryInvoiceServerWithChildContext:oneObject];
        }
    }

}

-(void)updateEveryInvoiceLocalWithChildContext:(Invoice *)localInvoice
{
    
    if (localInvoice.uuid == nil)
        return;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],localInvoice.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICE predicate:pre];
    
    //会占用主线程
    NSError *error = nil;
    NSArray *objects = [query findObjects:&error];
    if (error)
    {
        isSyncSuccess = NO;
        return;
    }
    
    PFObject *serData;
    if ([objects count]>0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
        [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        serData = [objects firstObject];
    }
    
    for (int i=1; i<[objects count]; i++)
    {
        PFObject *oneObject = [objects objectAtIndex:i];
        [oneObject delete];
    }
    
    if (serData)
    {
        //比较时间
        u_int64_t locDate = [localInvoice.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serData objectForKey:PF_INVOICE_ACCESSDATE] timeIntervalSince1970];
        if (locDate < serDate)
        {
            [self saveLocalInvoice:localInvoice withServerInvoice:serData isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerInvoice:serData withLocaldata:localInvoice isChildContext:YES];
        else
            ;
        
    }
    else
        [self saveServerInvoice:serData withLocaldata:localInvoice isChildContext:YES];
    
    
}

-(void)updateEveryInvoiceServerWithChildContext:(PFObject *)serverInvoice
{
    if([serverInvoice objectForKey:PF_INVOICE_UUID]==nil)
    {
        [serverInvoice delete];
        return;
    }
    //查找本地
    Invoice *localInvoice = [self fetchLocalDataWithClass:PF_TABLE_INVOICE uuid:[serverInvoice objectForKey:PF_INVOICE_UUID] isChildContext:YES];
    if(localInvoice != nil)
    {
        u_int64_t locDate = [localInvoice.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serverInvoice objectForKey:PF_INVOICE_ACCESSDATE] timeIntervalSince1970];

        if (locDate < serDate)
        {
            [self saveLocalInvoice:localInvoice withServerInvoice:serverInvoice isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerInvoice:serverInvoice withLocaldata:localInvoice isChildContext:YES];
        else
            ;
    }
    else
    {
        if([[serverInvoice objectForKey:PF_SYNCSTATUS]intValue] ==0)
            [self saveLocalInvoice:nil withServerInvoice:serverInvoice isChildContext:YES];

    }
}

-(void)saveServerInvoice:(PFObject *)object withLocaldata:(Invoice *)localInvoicde isChildContext:(BOOL)isChildContext
{
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    //增加
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_INVOICE];
    }
    if (localInvoicde.balanceDue != nil)
        [object setObject:localInvoicde.balanceDue forKey:PF_INVOICE_BALANCEDUE];
    
    if (localInvoicde.discount != nil)
        [object setObject:localInvoicde.discount forKey:PF_INVOICE_DISCOUNT];
    
    if (localInvoicde.dueDate != nil)
        [object setObject:localInvoicde.dueDate forKey:PF_INVOICE_DUEDATE];
    
    if (localInvoicde.invoiceNO != nil)
        [object setObject:localInvoicde.invoiceNO forKey:PF_INVOICE_INVOICENO];
    
    if (localInvoicde.message != nil)
        [object setObject:localInvoicde.message forKey:PF_INVOICE_MESSAGE];
    else
        [object removeObjectForKey:PF_INVOICE_MESSAGE];
    
    if (localInvoicde.paidDue != nil)
        [object setObject:localInvoicde.paidDue forKey:PF_INVOICE_PAIDDUE];
    
    if (localInvoicde.subtotal != nil)
        [object setObject:localInvoicde.subtotal forKey:PF_INVOICE_SUBTOTAL];
    
    if (localInvoicde.tax != nil)
        [object setObject:localInvoicde.tax forKey:PF_INVOICE_TAX];
    
    if (localInvoicde.terms != nil)
        [object setObject:localInvoicde.terms forKey:PF_INVOICE_TERMS];
    else
        [object removeObjectForKey:PF_INVOICE_TERMS];
    
    if (localInvoicde.title != nil)
        [object setObject:localInvoicde.title forKey:PF_INVOICE_TITLE];
    
    if (localInvoicde.toDate != nil)
        [object setObject:localInvoicde.toDate forKey:PF_INVOICE_TODATE];
    
    if (localInvoicde.totalDue != nil)
        [object setObject:localInvoicde.totalDue forKey:PF_INVOICE_TOTALDUE];
    
    //外键
    if (localInvoicde.client != nil)
        [object setObject:localInvoicde.client.uuid forKey:PF_INVOICE_CLIENT];
    
    //parse need
    //本地存在则ser为1，本地不存在则ser为0
    if (localInvoicde.sync_status != nil && [localInvoicde.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    
    if (localInvoicde.uuid != nil)
        [object setObject:localInvoicde.uuid forKey:PF_INVOICE_UUID];
    
    if (localInvoicde.accessDate != nil)
        [object setObject:localInvoicde.accessDate forKey:PF_INVOICE_ACCESSDATE];
    
    [object setObject:[PFUser currentUser] forKey:PF_User];

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
             if ([localInvoicde.sync_status intValue]==1)
             {
                 [context deleteObject:localInvoicde];
                 [context save:nil];
             }
         }
         else
         {
             isSyncSuccess = NO;

         }
     }];
    
}

-(void)saveLocalInvoice:(Invoice *)localInvoice withServerInvoice:(PFObject *)pfInvoice isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    //删
    if ([[pfInvoice objectForKey:PF_SYNCSTATUS]intValue]==1)
    {
        if(localInvoice != nil)
        {
            [[DataBaseManger getBaseManger] do_deletInvoice:localInvoice withManual:NO fromServerDeleteAccount:NO isChildContext:YES];
        }
    }
    //增/改
    else
    {
        if (localInvoice == nil)
        {
            localInvoice = [NSEntityDescription insertNewObjectForEntityForName:PF_TABLE_INVOICE inManagedObjectContext:context];
        }
        localInvoice.balanceDue  = [pfInvoice objectForKey:PF_INVOICE_BALANCEDUE];
        localInvoice.discount = [pfInvoice objectForKey:PF_INVOICE_DISCOUNT];
        localInvoice.dueDate = [pfInvoice objectForKey:PF_INVOICE_DUEDATE];
        localInvoice.invoiceNO = [pfInvoice objectForKey:PF_INVOICE_INVOICENO];
        localInvoice.message = [pfInvoice objectForKey:PF_INVOICE_MESSAGE];
        localInvoice.paidDue = [pfInvoice objectForKey:PF_INVOICE_PAIDDUE];
        localInvoice.subtotal = [pfInvoice objectForKey:PF_INVOICE_SUBTOTAL];
        localInvoice.tax = [pfInvoice objectForKey:PF_INVOICE_TAX];
        localInvoice.terms = [pfInvoice objectForKey:PF_INVOICE_TERMS];
        localInvoice.title = [pfInvoice objectForKey:PF_INVOICE_TITLE];
        localInvoice.toDate = [pfInvoice objectForKey:PF_INVOICE_TODATE];
        localInvoice.totalDue = [pfInvoice objectForKey:PF_INVOICE_TOTALDUE];
        
        //parse
        localInvoice.uuid = [pfInvoice objectForKey:PF_INVOICE_UUID];
        localInvoice.sync_status = [NSNumber numberWithInt:0];
        localInvoice.accessDate = [pfInvoice objectForKey:PF_INVOICE_ACCESSDATE];
//        [context save:&error];

        //外键
        if ([pfInvoice objectForKey:PF_INVOICE_CLIENT] != nil)
        {
            Clients *oneClient = [self fetchLocalDataWithClass:PF_TABLE_CLIENT uuid:[pfInvoice objectForKey:PF_INVOICE_CLIENT] isChildContext:isChildContext];
            if (oneClient != nil)
            {
                localInvoice.client = oneClient;
            }
        }
        
        NSArray *logsArray = [self fetchLogsHasInvoiceWithUUID:localInvoice.uuid];
        if([logsArray count]>0)
            localInvoice.logs = [NSSet setWithArray:logsArray];
        
            
        [context save:&error];
    }
    isNeedFlesh = YES;

}

#pragma mark Profile
-(void)syncProfile
{
    Log(@"sync profile");
    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_PROFILE changedSince:nil context:_childCtx]];
    
    Profile *onlyProfile;
    if([localChangedArray count]>0)
    {
        onlyProfile = [self getLocalOnly_Data:localChangedArray tableName:PF_TABLE_PROFILE];
        [self updateEveryProfileLocalWithChildContext:onlyProfile];
    }
    
    //获取server中变化的数据
    NSArray *serverArray = [self getServerObjectsOfClass:PF_TABLE_PROFILE updatedSince:nil];
    
    if (serverArray != nil)
    {
        PFUser *user = [PFUser currentUser];
        for (int i=0; i<[serverArray count]; i++)
        {
            PFObject *oneObject = [serverArray objectAtIndex:i];
            if ([[oneObject objectForKey:PF_PROFILE_UUID] isEqualToString:user.objectId]) {
                [self updateEveryProfileServerWithChildContext:oneObject];
            }
            else
            {
                NSError *error = nil;
                [oneObject delete:&error];
            }
            
        }
    }
    
}

-(void)updateEveryProfileLocalWithChildContext:(Profile *)localProfile
{
    
    if (localProfile.uuid == nil)
        return;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],localProfile.uuid];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
    
    //会占用主线程
    NSError *error = nil;
    NSArray *objects = [query findObjects:&error];
    if (error)
    {
        isSyncSuccess = NO;
        return;
    }
    
    PFObject *serData;
    if ([objects count]>0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
        [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        serData = [objects firstObject];
    }
    
    for (int i=1; i<[objects count]; i++)
    {
        PFObject *oneObject = [objects objectAtIndex:i];
        [oneObject delete];
    }
    
    if (serData)
    {
        //比较时间
        u_int64_t locDate = [localProfile.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serData objectForKey:PF_PROFILE_ACCESSDATE] timeIntervalSince1970];
        if (locDate < serDate)
        {
            [self saveLocalProfile:localProfile withServerProfile:serData isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerProfile:serData withLocaldata:localProfile isChildContext:YES];
        else
            ;
        
    }
    else
        [self saveServerProfile:serData withLocaldata:localProfile isChildContext:YES];
    
}

-(void)updateEveryProfileServerWithChildContext:(PFObject *)serverProfile
{
    if([serverProfile objectForKey:PF_PROFILE_UUID]==nil)
    {
        [serverProfile delete];
        return;
    }
    //查找本地
    Profile *localProfile = [self fetchLocalDataWithClass:PF_TABLE_PROFILE uuid:[serverProfile objectForKey:PF_PROPERTY_UUID] isChildContext:YES];
    if(localProfile != nil)
    {
        u_int64_t locDate = [localProfile.accessDate timeIntervalSince1970];
        u_int64_t  serDate = [[serverProfile objectForKey:PF_PROFILE_ACCESSDATE] timeIntervalSince1970];
        
        if (locDate < serDate)
        {
            [self saveLocalProfile:localProfile withServerProfile:serverProfile isChildContext:YES];
        }
        else if (locDate > serDate)
            [self saveServerProfile:serverProfile withLocaldata:localProfile isChildContext:YES];
        else
            ;
    }
    else
    {
        if([[serverProfile objectForKey:PF_SYNCSTATUS]intValue] ==0)
            [self saveLocalProfile:localProfile withServerProfile:serverProfile isChildContext:YES];

        
    }
}

/*
-(void)syncProfileisChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    //server
    NSMutableArray  *allObjects = [[NSMutableArray alloc]init];
    PFUser *user = [PFUser currentUser];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uuid == %@",user.objectId];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
    unsigned long  limit = 1000;
    unsigned long  skip = 0;
    unsigned long count = 0;
    [query setLimit:limit];
    [query setSkip:skip];
    do
    {
        NSError *error = nil;
        NSArray *array = [query findObjects:&error];
        if (error!=nil)
        {
            isSyncSuccess = NO;
            return;
        }
        [allObjects addObjectsFromArray:array];
        count = [array count];
        skip = skip + count;
        [query setSkip:skip];
    }while (limit == count);
    
    //local
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Profile"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"accessDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]];
    NSMutableArray *localChangedArray = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    Profile *localProfile;
    if ([localChangedArray count]>0)
    {
        localProfile = [self getLocalOnly_Data:localChangedArray tableName:PF_TABLE_PROFILE];
    }
    
    NSMutableArray *serverProfileArray = [[NSMutableArray alloc]initWithArray:allObjects];
    
    PFObject *serverProfile;
    if ([serverProfileArray count]>0)
    {
        serverProfile = [serverProfileArray lastObject];
    }
    
    if ([serverProfileArray count]>1)
    {
        [serverProfileArray removeObject:serverProfile];
        [PFObject deleteAll:serverProfileArray];
    }
    
    
    
    if (localProfile== nil)
    {
        if (serverProfile == nil)
        {
            ;
        }
        else
        {
            localProfile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:appDelegate.managedObjectContext];
            
            [self saveLocalProfile:localProfile withServerProfile:serverProfile isChildContext:isChildContext];
        }
    }
    else
    {
        if (serverProfile == nil)
        {
            //同步到server上
            [self saveServerProfile:serverProfile withLocaldata:localProfile isChildContext:isChildContext];
            
        }
        //两个都不为nil
        else
        {
            //本地保存，直接覆盖云端
            if(!isChildContext)
                [self saveServerProfile:serverProfile withLocaldata:localProfile isChildContext:isChildContext];
            else
            {
                u_int64_t localDate = [localProfile.accessDate timeIntervalSince1970];
                u_int64_t  serverDate = [[serverProfile objectForKey:PF_PROFILE_ACCESSDATE] timeIntervalSince1970];
                
                if (localDate<serverDate)
                {
                    [self saveLocalProfile:localProfile withServerProfile:serverProfile isChildContext:isChildContext];
                }
                else if (localDate>serverDate)
                {
                    [self saveServerProfile:serverProfile withLocaldata:localProfile isChildContext:isChildContext];
                }
                else
                    ;

            }
                
            
        }
    }


}
*/

-(void)saveServerProfile:(PFObject *)object withLocaldata:(Profile *)localProfile isChildContext:(BOOL)isChildContext
{
    if(object == nil)
    {
        object = [PFObject objectWithClassName:PF_TABLE_PROFILE];
    }
    

    
    
    if (localProfile.state != nil)
        [object setObject:localProfile.state forKey:PF_PROFILE_STATE];
    
    if (localProfile.city != nil)
        [object setObject:localProfile.city forKey:PF_PROFILE_CITY];
    
    if (localProfile.company != nil)
        [object setObject:localProfile.company forKey:PF_PROFILE_COMPANY];
    
    if (localProfile.email != nil)
        [object setObject:localProfile.email forKey:PF_PROFILE_EMAIL];
    
    if (localProfile.fax != nil)
        [object setObject:localProfile.fax forKey:PF_PROFILE_FAX];
    
    if (localProfile.firstName != nil)
    {
        [object setObject:localProfile.firstName forKey:PF_PROFILE_FIRSTNAME];
    }
    
    if (localProfile.lastName != nil)
    {
        [object setObject:localProfile.lastName forKey:PF_PROFILE_LASTNAME];
    }
    
    if (localProfile.phone != nil)
        [object setObject:localProfile.phone forKey:PF_PROFILE_PHONE];
    
    if (localProfile.street != nil)
        [object setObject:localProfile.street forKey:PF_PROFILE_STREET];
    
    if (localProfile.zip != nil)
        [object setObject:localProfile.zip forKey:PF_PROFILE_ZIP];
    
    //parse
    if (localProfile.uuid != nil)
    {
        [object setObject:localProfile.uuid forKey:PF_PROFILE_UUID];
    }
    if (localProfile.sync_status != nil && [localProfile.sync_status intValue]==0)
    {
        [object setObject:[NSNumber numberWithInt:0] forKey:PF_SYNCSTATUS];
    }
    else
        [object setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
    if (localProfile.accessDate != nil)
        [object setObject:localProfile.accessDate forKey:PF_PROFILE_ACCESSDATE];
    
    
    
    //head image
    NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:filepath];
        PFFile *headImageFile = [PFFile fileWithName:@"headImage" data:imageData];

        [object setObject:headImageFile forKey:PF_PROFILE_HEADIMAGE];
    }
    else
        [object removeObjectForKey:PF_PROFILE_HEADIMAGE];
    
    
    //save head image
    PFFile *imageFile;
    if (localProfile.headImage != nil)
    {
        AppDelegate_iPad *appDelegate_iPad = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
        AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
        NSString *nameString;
        if (ISPAD)
        {
            nameString = [NSString stringWithFormat:@"%@headImage.jpg",appDelegate_iPad.appUser.objectId];
        }
        else
            nameString = [NSString stringWithFormat:@"%@headImage.jpg",appDelegate.appUser.objectId];

        
        imageFile = [PFFile fileWithName:nameString data:UIImageJPEGRepresentation(localProfile.headImage, 1.0)];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [object setObject:[PFUser currentUser] forKey:PF_User];

                [object setObject:imageFile forKey:PF_PROFILE_HEADIMAGE];
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (succeeded)
                     {
                         ;
                         
                     }
                     else if(isChildContext)
                     {
                         isSyncSuccess = NO;
                     }
                 }];
            }
            else{
                if(isChildContext)
                {
                    isSyncSuccess = NO;
                }
            }
        }];
     
        
        
    }
    
}
-(void)saveLocalProfile:(Profile *)localProfile withServerProfile:(PFObject *)pfProfile isChildContext:(BOOL)isChildContext
{
    if (_isConnecttoNetwork)
    {
        AppDelegate_Shared  *appDelegate = (AppDelegate_Shared  *)[[UIApplication sharedApplication]delegate];
        NSError *error = nil;
        NSManagedObjectContext *context;
        if (isChildContext)
            context = _childCtx;
        else
            context = appDelegate.managedObjectContext;
        
        if (localProfile == nil)
        {
            localProfile = [NSEntityDescription insertNewObjectForEntityForName:PF_TABLE_PROFILE inManagedObjectContext:context];
        }
        
        localProfile.state = [pfProfile objectForKey:PF_PROFILE_STATE];
        localProfile.city = [pfProfile objectForKey:PF_PROFILE_CITY];
        localProfile.company = [pfProfile objectForKey:PF_PROFILE_COMPANY];
        localProfile.email = [pfProfile objectForKey:PF_PROFILE_EMAIL];
        localProfile.fax = [pfProfile objectForKey:PF_PROFILE_FAX];
        localProfile.phone = [pfProfile objectForKey:PF_PROFILE_PHONE];
        localProfile.street = [pfProfile objectForKey:PF_PROFILE_STREET];
        localProfile.zip = [pfProfile objectForKey:PF_PROFILE_ZIP];
        
        localProfile.firstName = [pfProfile objectForKey:PF_PROFILE_FIRSTNAME];
        localProfile.lastName = [pfProfile objectForKey:PF_PROFILE_LASTNAME];
        
//        NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
//        }
//        
//        if ([pfProfile objectForKey:PF_PROFILE_HEADIMAGE] != nil)
//        {
//            PFFile *imageFile = [pfProfile objectForKey:PF_PROFILE_HEADIMAGE];
//            NSString *filepath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
//            [imageFile.getData writeToFile:filepath atomically:NO];
//        }
        
//        if (pfProfile[@"headImage"] != nil)
//        {
//            PFFile *photoFile=pfProfile[@"headImage"];
//            NSData *photoData=[photoFile getData:&error];
//            localProfile.headImage = photoData;
//        }
//        else
//            localProfile.headImage = nil;
        
        if ([pfProfile objectForKey:PF_PROFILE_HEADIMAGE] != nil)
        {
            PFFile *imageFile = [pfProfile objectForKey:PF_PROFILE_HEADIMAGE];
            
            localProfile.headImage = [UIImage imageWithData:[imageFile getData]];
        }
        else
            localProfile.headImage = nil;
        
        //parse
        localProfile.uuid = [pfProfile objectForKey:PF_PROFILE_UUID];
        localProfile.sync_status = [pfProfile objectForKey:PF_SYNCSTATUS];
        localProfile.accessDate = [pfProfile objectForKey:PF_PROFILE_ACCESSDATE];


        
        [context save:&error];
    }
    
}
///*----------------------------------------------------*/
//-(NSDate *)localLastUpdatedTimeforEntity:(NSString *)localEntity
//{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//    NSError *error = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:localEntity];
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"updatedAt" ascending:NO];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//    NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    
////    if ([localEntity isEqualToString:PF_TABLE_CLIENT])
////    {
////        return ((Clients *)[objects firstObject]).updatedAt;
////    }
////    else if ([localEntity isEqualToString:PF_TABLE_INVOICEPROPERTY])
////        return ((Invoiceproperty *)[objects firstObject]).updatedAt;
////    
////    else if ([localEntity isEqualToString:PF_TABLE_INVOICE])
////        return ((Invoice *)[objects firstObject]).updatedAt;
////    
////    else if ([localEntity isEqualToString:PF_TABLE_LOGS])
////        return ((Logs *)[objects firstObject]).updatedAt;
////    
////    else
//        return nil;
//}


#pragma mark Shared
-(NSArray *)getLocalObjectsofClass:(NSString *)className changedSince:(NSDate *)tmpLastSyncTime context:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:className];
    if (tmpLastSyncTime != nil)
    {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"accessDate > %@",tmpLastSyncTime];
        [fetchRequest setPredicate:pre];
    }

    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    return objects;
}

- (NSArray *)getServerObjectsOfClass:(NSString *)className updatedSince:(NSDate *)lastUpdate
{
    
    NSMutableArray  *allObjects = [[NSMutableArray alloc]init];
    PFQuery *query;
//    NSLog(@"lastSyncTime:%@",lastSyncTime);

    if (lastUpdate != nil)
    {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && updatedAt > %@",[PFUser currentUser],lastUpdate];
        query = [PFQuery queryWithClassName:className predicate:pre];
    }
    else
    {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@",[PFUser currentUser],lastUpdate];
//        Log(@"parseUser:%@",[PFUser currentUser]);
        query = [PFQuery queryWithClassName:className predicate:pre];
    }
    
    NSError *error = nil;
    
    NSInteger limit=1000;
    NSInteger skip=0;
    NSInteger count;
    [query setLimit:limit];
    [query setSkip:skip];
    do{
        NSArray *array=[query findObjects:&error];
        [allObjects addObjectsFromArray:array];
        skip+=limit;
        [query setSkip:skip];
        count=array.count;
    } while (count==limit);
    
    return allObjects;
}

-(id)fetchLocalDataWithClass:(NSString *)className uuid:(NSString *)serverUuid isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    NSManagedObjectContext *context;
    if (isChildContext)
        context = _childCtx;
    else
        context = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:className];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uuid == %@",serverUuid];
    [fetchRequest setPredicate:pre];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];

    if ([objects count]>0)
    {
        return [objects lastObject];
    }
    else
        return nil;
}

-(id)fetchLogsHasInvoiceWithUUID:(NSString *)invoiceUUID
{
    NSError *error = nil;
    NSManagedObjectContext *context = _childCtx;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_LOGS];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"invoice_uuid == %@",invoiceUUID];
    [fetchRequest setPredicate:pre];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
//    NSMutableArray *logsArray = [[NSMutableArray alloc]init];
    
//    for (int i=0; i<[objects count]; i++)
//    {
//        
//        Logs *oneLog = [objects objectAtIndex:i];
//        NSArray *invoiceArray = [[NSArray alloc]initWithArray:[oneLog.invoice allObjects]];
//        for (int m=0; m<[invoiceArray count]; m++)
//        {
//            Invoice *oneInvoice = [invoiceArray objectAtIndex:m];
//            if ([oneInvoice.uuid isEqualToString:invoiceUUID])
//            {
//                [logsArray addObject:oneLog];
//            }
//        }
//    }
    
    return objects;

    
}


#pragma mark Network
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
    
    NSURL *testURL = [NSURL URLWithString:@"https://www.parse.com"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        _isConnecttoNetwork = NO;
//        PokcetExpenseAppDelegate *appDelegate = (PokcetExpenseAppDelegate *)[[UIApplication sharedApplication]delegate];
//        [appDelegate hideSyncIndicator];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync Failed"
//                                                            message:@"Please check your network connection."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles: nil];
//        [alertView show];
//        alertView = nil;
    }
    NSLog(@"error-------------------------------------------%@",error);
}
#pragma mark Internet Method
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        if(netStatus != NotReachable)
        {
            _isConnecttoNetwork = YES;
        }
        else
        {
            _isConnecttoNetwork = NO;
        }
    }

}

+ (BOOL) validateEmail: (NSString *) email
{
    NSString * emailRegex = @ "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}" ;
    NSPredicate * emailTest = [NSPredicate predicateWithFormat: @ "SELF MATCHES% @", emailRegex];
    return [emailTest evaluateWithObject: email];
}


#pragma mark Restore 方法
-(void)deleteAllLocalDataBase
{
    //重新设置上次同步时间
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error =  nil;
    appDelegate.appSetting.lastSyncDate = nil;
    [appDelegate.managedObjectContext save:nil];
    
    //client
    NSFetchRequest  *fechClient = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_CLIENT];
    NSArray *clientArray = [appDelegate.managedObjectContext executeFetchRequest:fechClient error:&error];
    for (int i=0; i<[clientArray count]; i++)
    {
        Clients *oneClient = [clientArray objectAtIndex:i];
        
        [appDelegate.managedObjectContext deleteObject:oneClient];
    }
    
    //log
    NSFetchRequest  *fechLog = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_LOGS];
    NSArray *logArray = [appDelegate.managedObjectContext executeFetchRequest:fechLog error:&error];
    for (int i=0; i<[logArray count]; i++)
    {
        Logs *oneLog = [logArray objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneLog];
    }
    
    //invoice
    NSFetchRequest *fetchInvoice = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICE];
    NSArray *invoiceArray = [appDelegate.managedObjectContext executeFetchRequest:fetchInvoice error:&error];
    for (int i=0; i<[invoiceArray count]; i++)
    {
        Invoice *oneInvocie = [invoiceArray objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneInvocie];
    }
    
    //invoice property
    NSFetchRequest *fetchInvoiceProperty = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICEPROPERTY];
    NSArray *propertyArray = [appDelegate.managedObjectContext executeFetchRequest:fetchInvoiceProperty error:&error];
    for (int i=0; i<[propertyArray count]; i++)
    {
        Invoiceproperty *oneProperty = [propertyArray objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneProperty];
    }
    
    
    //profile
    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_PROFILE];
    NSArray *profileArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequestProfile error:&error];
    for (int i=0; i<[profileArray count]; i++)
    {
        Profile *oneProperty = [profileArray objectAtIndex:i];
        [appDelegate.managedObjectContext deleteObject:oneProperty];
    }
    
    
    NSString *headpath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
    if([[NSFileManager defaultManager] fileExistsAtPath:headpath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:headpath error:nil];
    }
    
    
    [appDelegate.managedObjectContext save:&error];
}
/**
 1.设置 local new database version
 2.设置云端 database version
 1.置parse上所有数据syncstate为1(删除)
 */
-(void)deleteAllDataonParse
{

    //property
    NSMutableArray  *allObjects = [[NSMutableArray alloc]init];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@",[PFUser currentUser]];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
    unsigned long  limit = 1000;
    unsigned long  skip = 0;
    unsigned long count = 0;
    [query setLimit:limit];
    [query setSkip:skip];
    do
    {
        NSError *error = nil;
        NSArray *array = [query findObjects:&error];
        if (error!=nil)
        {
            isSyncSuccess = NO;
            return;
        }
        [allObjects addObjectsFromArray:array];
        count = [array count];
        skip = skip + count;
        [query setSkip:skip];
    }while (limit == count);
    
    for (int i=0; i<[allObjects count]; i++)
    {
        PFObject *oneObject = [allObjects objectAtIndex:i];
        [oneObject setObject:[NSDate date] forKey:PF_PROFILE_ACCESSDATE];
        [oneObject setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
        [oneObject saveInBackground];
    }
    
    //client
    NSArray *clientArray = [self getServerObjectsOfClass:PF_TABLE_CLIENT updatedSince:nil];
    if (clientArray != nil)
    {
        for (int i=0; i<[clientArray count]; i++)
        {
            PFObject *oneObject = [clientArray objectAtIndex:i];
            [oneObject setObject:[NSDate date] forKey:PF_CLIENT_ACCESSDATE];
            [oneObject setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
            [oneObject saveInBackground];
        }
    }
    //log
    NSArray *logArray = [self getServerObjectsOfClass:PF_TABLE_LOGS updatedSince:nil];
    if (logArray != nil)
    {
        for (int i=0; i<[logArray count]; i++)
        {
            PFObject *oneObject = [logArray objectAtIndex:i];
            [oneObject setObject:[NSDate date] forKey:PF_LOGS_ACCESSDATE];
            [oneObject setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
            [oneObject saveInBackground];
        }
    }
    //invoiceProperty
    NSArray *invoicePropertyArray = [self getServerObjectsOfClass:PF_TABLE_INVOICEPROPERTY updatedSince:nil];
    if (invoicePropertyArray != nil)
    {
        for (int i=0; i<[invoicePropertyArray count]; i++)
        {
            PFObject *oneObject = [invoicePropertyArray objectAtIndex:i];
            [oneObject setObject:[NSDate date] forKey:PF_PROFILE_ACCESSDATE];
            [oneObject setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
            [oneObject saveInBackground];

        }
    }
    //invoice
    NSArray *invoiceArray = [self getServerObjectsOfClass:PF_TABLE_INVOICE updatedSince:nil];
    if (invoiceArray != nil)
    {
        for (int i=0; i<[invoiceArray count]; i++)
        {
            PFObject *oneObject = [invoiceArray objectAtIndex:i];
            [oneObject setObject:[NSDate date] forKey:PF_INVOICE_ACCESSDATE];
            [oneObject setObject:[NSNumber numberWithInt:1] forKey:PF_SYNCSTATUS];
            [oneObject saveInBackground];

        }
    }
    
}

/**
    将本地所有数据上传覆盖云端数据,更新时间
 */

-(void)saveAllLocalDatatoParse
{
    [self setLocalDataNewEditTime];
    
   

}

-(void)setLocalDataNewEditTime
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    
    NSFetchRequest *cilent = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_CLIENT];
    NSArray *clientArray = [appDelegate.managedObjectContext executeFetchRequest:cilent error:&error];
    for (int i=0; i<[clientArray count]; i++) {
        Clients *oneClient = [clientArray objectAtIndex:i];
        oneClient.accessDate = [NSDate date];
    }
    
    NSFetchRequest *fetchLogs = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_LOGS];
    NSArray *logsArray = [appDelegate.managedObjectContext executeFetchRequest:fetchLogs error:&error];
    for (int i=0; i<[logsArray count]; i++) {
        Logs *oneLog = [logsArray objectAtIndex:i];
        oneLog.accessDate = [NSDate date];
    }
    
    //会删掉budgetTemplate 和 budgetItem
    NSFetchRequest *fetchInvoice = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICE];
    NSArray *invoiceArray = [appDelegate.managedObjectContext executeFetchRequest:fetchInvoice error:&error];
    for (int i=0; i<[invoiceArray count]; i++) {
        Invoice *oneInvoice = [invoiceArray objectAtIndex:i];
        oneInvoice.accessDate = [NSDate date];
    }
    
    NSFetchRequest *fetchInvoiceProperty = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_INVOICEPROPERTY];
    NSArray *propertyArray = [appDelegate.managedObjectContext executeFetchRequest:fetchInvoiceProperty error:&error];
    for (int i=0; i<[propertyArray count]; i++) {
        Invoiceproperty *oneProperty = [propertyArray objectAtIndex:i];
        oneProperty.accessDate = [NSDate date];
    }
    
    
    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_PROFILE];
    NSArray *profileArray = [appDelegate.managedObjectContext executeFetchRequest:fetchProfile error:&error];
    for (int i=0; i<[profileArray count]; i++) {
        Profile *oneProfile = [profileArray objectAtIndex:i];
        oneProfile.accessDate = [NSDate date];
    }
    
    [appDelegate.managedObjectContext save:&error];
}

-(id)fetchServerProfile
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@",[PFUser currentUser]];
    PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
    //会占用主线程
    NSError *error = nil;
    NSArray *objects = [query findObjects:&error];
    PFObject *serData;
    if ([objects count]>0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
        [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        serData = [objects firstObject];
        return serData;
    }
    else
        return nil;
}

//没用到
-(id)getLocalOnly_Data:(NSArray *)dataArray tableName:(NSString *)table_name
{
    id returnID = nil;
    if ([dataArray count] == 1)
    {
        returnID = [dataArray objectAtIndex:0];
    }
    else
    {
        if ([table_name isEqualToString:PF_TABLE_CLIENT])
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
            
            sel_data = (Clients *)returnID;
            for (Clients *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [sel_red.managedObjectContext deleteObject:sel_red];
                    [sel_red.managedObjectContext save:nil];

                }
            }
        }
        else if ([table_name isEqualToString:PF_TABLE_INVOICE])
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
            sel_data = (Invoice *)returnID;
            for (Invoice *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [sel_red.managedObjectContext deleteObject:sel_red];
                    [sel_red.managedObjectContext save:nil];

                }
            }
        }
        else if ([table_name isEqualToString:PF_TABLE_LOGS])
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
            sel_data = (Logs *)returnID;
            for (Logs *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [sel_red.managedObjectContext deleteObject:sel_red];
                    [sel_red.managedObjectContext save:nil];

                }
            }
        }
        else if ([table_name isEqualToString:PF_TABLE_INVOICEPROPERTY])
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
            sel_data = (Invoiceproperty *)returnID;
            for (Invoiceproperty *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [sel_red.managedObjectContext deleteObject:sel_red];
                    [sel_red.managedObjectContext save:nil];

                }
            }
        }
        else
        {
            PFUser *user = [PFUser currentUser];
            Profile *sel_data = [dataArray objectAtIndex:0];
            for (Profile *one in dataArray) {
                if (![one.uuid isEqualToString:user.objectId]) {
                    [one.managedObjectContext deleteObject:one];
                    NSError *error = nil;
                    [one.managedObjectContext save:&error];
                }
            }
            for (Profile *sel_red in dataArray)
            {
                if ([sel_data.accessDate compare:sel_red.accessDate] == NSOrderedAscending)
                {
                    sel_data = sel_red;
                }
            }
            returnID = sel_data;
            sel_data = (Profile *)returnID;
            for (Profile *sel_red in dataArray)
            {
                if (![sel_data isEqual:sel_red])
                {
                    [sel_red.managedObjectContext deleteObject:sel_red];
                    [sel_red.managedObjectContext save:nil];
                }
            }

        }
    }
    
    
    return returnID;
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    //保存本机
    if(buttonIndex == 0)
    {
        //1.删除parse 2.强制上传本地
        [self deleteAllDataonParse];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *version = [userDefault objectForKey:DATABASE_VERSION];
        if (version == nil)
        {
            version = [appDelegate getUuid];
            [userDefault setObject:version forKey:DATABASE_VERSION];
            [userDefault synchronize];
        }
        
        PFObject *profile = [appDelegate.parseSync fetchServerProfile];
        if (profile)
        {
            [profile setObject:version forKey:DATABASE_VERSION];
            [profile save];
        }
        
        [self  saveAllLocalDatatoParse];
        return;
    }
    
    else
    {
        //1.删除本地 2.下载云端 3.设置本地database version
        [self deleteAllLocalDataBase];
        PFObject *profile = [appDelegate.parseSync fetchServerProfile];
        if (profile)
        {
            NSString *baseVersion = [profile objectForKey:DATABASE_VERSION];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:baseVersion forKey:DATABASE_VERSION];
            
        }
        [appDelegate.parseSync syncAllWithTip:NO];

        return;
    }

}


//登出或者第一次登陆的时候，将本地所有数据同步到云端
-(void)updateAllLocalDatatoServerBeforeLogout
{
    NSLog(@"上传本地数据 开始");
    NSFetchRequest *fetchSetting = [[NSFetchRequest alloc]initWithEntityName:@"Settings"];
    NSError *error = nil;
    NSArray *settingArray = [_childCtx executeFetchRequest:fetchSetting error:&error];
    Settings *oneObject = (Settings *)[settingArray lastObject];
    NSDate *tmpSyncDate = oneObject.lastSyncDate;
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    //client
    NSMutableArray *localClientdArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_CLIENT changedSince:tmpSyncDate context:appDelegate.managedObjectContext]];
    for (int i=0; i<[localClientdArray count]; i++)
    {
        Clients *oneClinet = [localClientdArray objectAtIndex:i];
        if (oneClinet.uuid == nil)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneClinet.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_CLIENT predicate:pre];
        
        
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [oneClinet.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_CLIENT_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalClient:oneClinet withServerClient:serData isChildContext:NO];
            }
            else if (locDate > serDate)
                [self saveServerClient:serData withLocaldata:oneClinet isChildContext:NO];
            else
                ;
            
        }
        else
            [self saveServerClient:serData withLocaldata:oneClinet isChildContext:NO];
    }
    
    //log
    NSMutableArray *localLogArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_LOGS changedSince:tmpSyncDate context:appDelegate.managedObjectContext]];
    
    for (int i=0; i<[localLogArray count]; i++)
    {
        Logs *oneLog = [localLogArray objectAtIndex:i];
        if (oneLog.uuid == nil)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneLog.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_LOGS predicate:pre];
        
        //会占用主线程
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [oneLog.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_LOGS_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalLog:oneLog withServerLog:serData isChildContext:NO];
            }
            else if (locDate > serDate)
                [self saveServerLog:serData withLocaldata:oneLog isChildContext:NO];
            else
                ;
            
        }
        else
            [self saveServerLog:serData withLocaldata:oneLog isChildContext:NO];
    }
    
    //invoice
    NSMutableArray *localInvoiceArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICE changedSince:tmpSyncDate context:appDelegate.managedObjectContext]];
    for (int i=0; i<[localInvoiceArray count]; i++)
    {
        Invoice *oneInvoice = [localInvoiceArray objectAtIndex:i];
        if (oneInvoice.uuid == nil)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneInvoice.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICE predicate:pre];
        
        //会占用主线程
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [oneInvoice.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_INVOICE_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalInvoice:oneInvoice withServerInvoice:serData isChildContext:NO];
            }
            else if (locDate > serDate)
                [self saveServerInvoice:serData withLocaldata:oneInvoice isChildContext:NO];
            else
                ;
            
        }
        else
            [self saveServerInvoice:serData withLocaldata:oneInvoice isChildContext:NO];
    }
    
    //property
    NSMutableArray *localPropertyArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICEPROPERTY changedSince:tmpSyncDate context:appDelegate.managedObjectContext]];
    for (int i=0; i<[localPropertyArray count]; i++)
    {
        Invoiceproperty *oneProperty = [localPropertyArray objectAtIndex:i];
        if (oneProperty.uuid == nil)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],oneProperty.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_INVOICEPROPERTY predicate:pre];
        
        //会占用主线程
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [oneProperty.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_PROPERTY_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalInvoiceProperty:oneProperty withServerInvoiceProperty:serData isChildContext:NO];
            }
            else if (locDate > serDate)
                [self saveServerInvoiceProperty:serData withLocaldata:oneProperty isChildContext:NO];
            else
                ;
            
        }
        else
            [self saveServerInvoiceProperty:serData withLocaldata:oneProperty isChildContext:NO];
    }
    
    //profile
    NSMutableArray *localProfileArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_PROFILE changedSince:tmpSyncDate context:appDelegate.managedObjectContext]];
    
    Profile *onlyProfile;
    if([localProfileArray count]>0)
    {
        onlyProfile = [self getLocalOnly_Data:localProfileArray tableName:PF_TABLE_PROFILE];
        if (onlyProfile.uuid == nil)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"parse_User==%@ && uuid == %@",[PFUser currentUser],onlyProfile.uuid];
        PFQuery *query = [PFQuery queryWithClassName:PF_TABLE_PROFILE predicate:pre];
        
        //会占用主线程
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if (error)
        {
            isSyncSuccess = NO;
            return;
        }
        
        PFObject *serData;
        if ([objects count]>0)
        {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
            [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            serData = [objects firstObject];
        }
        
        for (int i=1; i<[objects count]; i++)
        {
            PFObject *oneObject = [objects objectAtIndex:i];
            [oneObject delete];
        }
        
        if (serData)
        {
            //比较时间
            u_int64_t locDate = [onlyProfile.accessDate timeIntervalSince1970];
            u_int64_t  serDate = [[serData objectForKey:PF_PROFILE_ACCESSDATE] timeIntervalSince1970];
            if (locDate < serDate)
            {
                [self saveLocalProfile:onlyProfile withServerProfile:serData isChildContext:NO];
            }
            else if (locDate > serDate)
                [self saveServerProfile:serData withLocaldata:onlyProfile isChildContext:NO];
            else
                ;
            
        }
        else
            [self saveServerProfile:serData withLocaldata:NO isChildContext:YES];

    }

    NSLog(@"上传本地数据 结束");

}


//-(void)updateAllLocalDatatoServerAfterDropboxLinked
//{
//    NSLog(@"Dropbox上传本地数据 开始");
//    
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//    //client
//    NSMutableArray *localClientdArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_CLIENT changedSince:nil context:appDelegate.managedObjectContext]];
//    for (int i=0; i<[localClientdArray count]; i++)
//    {
//        Clients *oneClinet = [localClientdArray objectAtIndex:i];
//        [self updateClientFromLocal:oneClinet];
//    }
//    
//    //log
//    NSMutableArray *localLogArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_LOGS changedSince:nil context:appDelegate.managedObjectContext]];
//    
//    for (int i=0; i<[localLogArray count]; i++)
//    {
//        Logs *oneLog = [localLogArray objectAtIndex:i];
//        [self updateLogFromLocal:oneLog];
//    }
//    
//    //invoice
//    NSMutableArray *localInvoiceArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICE changedSince:nil context:appDelegate.managedObjectContext]];
//    for (int i=0; i<[localInvoiceArray count]; i++)
//    {
//        Invoice *oneInvoice = [localInvoiceArray objectAtIndex:i];
//        [self updateInvoiceFromLocal:oneInvoice];
//    }
//    
//    //property
//    NSMutableArray *localPropertyArray = [[NSMutableArray alloc]initWithArray:[self getLocalObjectsofClass:PF_TABLE_INVOICEPROPERTY changedSince:nil context:appDelegate.managedObjectContext]];
//    for (int i=0; i<[localPropertyArray count]; i++)
//    {
//        Invoiceproperty *oneProperty = [localPropertyArray objectAtIndex:i];
//        [self updateInvoicePropertyFromLocal:oneProperty];
//    }
//    
//    NSLog(@"Dropbox上传本地数据 结束");
//}
@end
