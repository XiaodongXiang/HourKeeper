//
//  DataBaseManger.m
//  HoursKeeper
//
//  Created by xy_dev on 10/12/13.
//
//

#import "DataBaseManger.h"

#import "AppDelegate_Shared.h"
#import "Logs.h"
#import "Clients.h"
#import "Logs.h"
#import "Invoice.h"
#import "Profile.h"

#import "FileController.h"


static DataBaseManger *app_dataManger = nil;

@implementation DataBaseManger



-(id)init
{
	self = [super init];
	if(self)
	{
	}
	return self;
}


+(DataBaseManger *)getBaseManger
{
    @synchronized(self)
    {
        if(app_dataManger == nil)
        {
            app_dataManger = [[self alloc] init];
        }
    }
    
    return app_dataManger;
}

-(void)deleleTAbleCell:(NSManagedObject *)table_cell
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if ([table_cell isKindOfClass:[Clients class]])
    {
        Clients *delectClient = (Clients *)table_cell;
        
        NSMutableArray *alllogs = [[NSMutableArray alloc] init];
        [alllogs addObjectsFromArray:[delectClient.logs allObjects]];
        for (int k=0; k<[alllogs count]; k++)
        {
            Logs *deletelog = [alllogs objectAtIndex:k];
            [context deleteObject:deletelog];
        }
        
        NSMutableArray *allinvoice = [[NSMutableArray alloc] init];
        [allinvoice addObjectsFromArray:[delectClient.invoices allObjects]];
        for (int i=0; i<[allinvoice count]; i++)
        {
            Invoice *deleteinvoice = [allinvoice objectAtIndex:i];
            [context deleteObject:deleteinvoice];
        }
    }
    
    
    [context deleteObject:table_cell];
    
    [self saveDataBase];
}

-(void)saveDataBase
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context save:nil];
}

-(NSArray *)getDataArray_TableName:(NSString *)m_tableName searchSubPre:(NSDictionary *)m_diction
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *dataEntity = [[appDelegate.managedObjectModel entitiesByName] valueForKey:m_tableName];
    [fetchRequest setEntity:dataEntity];
    
    if (m_diction != nil)
    {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"uuid == $uuid"];
        NSPredicate *predicate = [predicate1 predicateWithSubstitutionVariables:m_diction];

        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allresults = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allresults;
}

-(id)addTableCell:(NSString *)m_tableName
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    id tableCell = [NSEntityDescription insertNewObjectForEntityForName:m_tableName inManagedObjectContext:context];
    
    [self saveDataBase];
    
    return tableCell;
}



#pragma mark - database
/*
    获取选中invoice下所有的property  _copy参数:YES创建多一份的property数据但是不存到数据库中
 */
-(NSArray *)getAllInvpropertyByInvoice:(Invoice *)_invoice isCopy:(BOOL)_copy
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc2 = [NSEntityDescription entityForName:@"Invoiceproperty"
                                                   inManagedObjectContext:context];
    [request2 setEntity:entityDesc2];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(sync_status == 0) AND (parentUuid == '%@')",_invoice.uuid]];

    [request2 setPredicate:predicate2];
    NSArray *objects2 = [context executeFetchRequest:request2 error:&errors];
    

    if (_copy == NO)
    {
        return objects2;
    }
    else
    {
        NSMutableArray *copyArray = [[NSMutableArray alloc] init];
        for (Invoiceproperty *_invpty in objects2)
        {
            Invoiceproperty *property = [NSEntityDescription insertNewObjectForEntityForName:@"Invoiceproperty" inManagedObjectContext:context];
            
            property.uuid = _invpty.uuid;
            property.sync_status = _invpty.sync_status;
            property.accessDate = _invpty.accessDate;
            property.name = _invpty.name;
            property.quantity = _invpty.quantity;
            property.price = _invpty.price;
            property.tax = _invpty.tax;
            
            [copyArray addObject:property];
        }
        
        return copyArray;
    }
}

/*
 删除Client 及其 关联
 参数说明：（1）_client 删除的Client。
 (2)isManual  YES 手动删除:底下关联的数据设置删除状态，同步；Client设置删除状态，同步。 非手工删除启用多线程
              NO  同步删除:底下关联的数据设置删除状态，不同步；Client直接删除，不同步。

 */
-(void)do_deletClient:(Clients *)_client withManual:(BOOL)isManual
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context;
    NSError *error = nil;
    if (isManual)
        context = [appDelegate managedObjectContext];
    else
        context = appDelegate.parseSync.childCtx;
    
    //log
    NSMutableArray *alllogs = [[NSMutableArray alloc] init];
    [alllogs addObjectsFromArray:[appDelegate removeAlready_DeleteLog:[_client.logs allObjects]]];
    for (int k=0; k<[alllogs count]; k++)
    {
        Logs *deletelog = [alllogs objectAtIndex:k];
        deletelog.accessDate = [NSDate date];
        deletelog.sync_status = [NSNumber numberWithInteger:1];
        
        [context save:&error];
        if (isManual)
        {
            [appDelegate.parseSync updateLogFromLocal:deletelog];
        }
    }
    
    
    //invoice
    NSMutableArray *allinvoice = [[NSMutableArray alloc] init];
    [allinvoice addObjectsFromArray:[appDelegate removeAlready_DeleteInv:[_client.invoices allObjects]]];
    for (int i=0; i<[allinvoice count]; i++)
    {
        Invoice *deleteinvoice = [allinvoice objectAtIndex:i];
        [self do_deletInvoice:deleteinvoice withManual:isManual fromServerDeleteAccount:YES isChildContext:!isManual];
    }
    
    
    
    //client
    if(!isManual)
    {
        [_client.managedObjectContext deleteObject:_client];
        [_client.managedObjectContext save:nil];
    }
    else
    {
        _client.accessDate = [NSDate date];
        _client.sync_status = [NSNumber numberWithInteger:1];
        [_client.managedObjectContext save:nil];
        [appDelegate.parseSync updateClientFromLocal:_client];
    }
    
}

/*
    删除Invoice及其关联
    isManual:YES 手动删除
            NO  同步删除
    isFromAccount:YES 删除client时被调用该方法
                    NO 不是被级联删除
 
 删除Invocie有三种情况：（1）手动删除本地: 设置Invoice删除状态，同步,级联设置删除状态，同步。（2）同步删除: 删除Invoice本地,级联设置删除状态，不同步。(3)同步删除Client时:设置删除状态,不同步；级联删除状态，不同步
 */
-(void)do_deletInvoice:(Invoice *)_invoice withManual:(BOOL)isManual fromServerDeleteAccount:(BOOL)isFromAccount isChildContext:(BOOL)isChildContext
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context;
    if (isChildContext)
        context = appDelegate.parseSync.childCtx;
    else
        context = [appDelegate managedObjectContext];
    NSError *error = nil;
    
    Invoice *invoice = _invoice;
    
    //log:invoice对应的log是没支付的log
    NSArray *logArray = [appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]];
    for (Logs *log in logArray)
    {
        log.isInvoice = [NSNumber numberWithBool:NO];
        [log removeInvoiceObject:invoice];
        
        log.accessDate = [NSDate date];
        log.invoice_uuid = nil;
        [context save:&error];
        
        //parse update local
        if (isManual)
            [appDelegate.parseSync updateLogFromLocal:log];
    }
    
    //invoiceproperty 有问题
    NSArray *invptyArray = [appDelegate removeAlready_DeleteLog:[invoice.invoicepropertys allObjects]];
    for (Invoiceproperty *invpty in invptyArray)
    {
        invpty.sync_status = [NSNumber numberWithInteger:1];
        invpty.accessDate = [NSDate date];
        [context save:&error];
        //parse update local
        if (isManual)
            [appDelegate.parseSync updateInvoicePropertyFromLocal:invpty];
    }
    
    
    if(isManual)
    {
        invoice.accessDate = [NSDate date];
        invoice.sync_status = [NSNumber numberWithInteger:1];
        [context save:nil];
        [appDelegate.parseSync updateInvoiceFromLocal:invoice];
    }
    else
    {
        //(3)
        if (isFromAccount)
        {
            invoice.accessDate = [NSDate date];
            invoice.sync_status = [NSNumber numberWithInteger:1];
            [context save:&error];
        }
        //(2)
        else
        {
            [context deleteObject:_invoice];
            [context save:&error];
            
        }
    }
}



/*
    根据传进来的log修改对应invoice的信息 & syncInvoice
 */
-(void)do_changeLogToInvoice:(Logs *)_log stly:(int)_isDelete
{
    if ([_log.isInvoice boolValue] == YES && [[_log.invoice allObjects] count] > 0)
    {
        Invoice *sel_invoice = [[_log.invoice allObjects] objectAtIndex:0];
        if (sel_invoice != nil)
        {
            AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            NSError *error = nil;
            
            double getSubtotalMoney = 0.0;
            NSMutableArray *logs = [appDelegate removeAlready_DeleteLog:[sel_invoice.logs allObjects]];
            if (_isDelete == 1)
            {
                [_log removeInvoiceObject:sel_invoice];
                [logs removeObject:_log];
                [appDelegate.managedObjectContext save:nil];
            }
            
            //subtotal
            for (Logs *_log in logs)
            {
                getSubtotalMoney = getSubtotalMoney + [_log.totalmoney doubleValue];
            }
            NSString *subtotalStr = [appDelegate appMoneyShowStly4:getSubtotalMoney];
            
            
            //overmoney
            double over_money = 0;
            if (_log.client != nil && [[_log.invoice allObjects]count]>0)
            {
                Invoice *sel_invoice = [[_log.invoice allObjects]firstObject];
                NSArray *backArray = [appDelegate overTimeMoney_logs:[sel_invoice.logs  allObjects]];
                over_money = [[backArray objectAtIndex:0]doubleValue];
            }
            

            
            //tax
            double getTaxMoney = 0.0;
            getTaxMoney = [subtotalStr doubleValue]*[sel_invoice.tax doubleValue]/100;
            
            //other charge
            double getOterMoney = 0.0;
            double otherTax;
            for (Invoiceproperty *_invpty in [appDelegate removeAlready_DeleteInvpty:[sel_invoice.invoicepropertys allObjects]])
            {
                otherTax = 1.0;
                if (_invpty.tax.intValue == 1)
                {
                    otherTax = otherTax + [sel_invoice.tax doubleValue]/100;
                }
                getOterMoney = getOterMoney + _invpty.price.doubleValue*_invpty.quantity.intValue*otherTax;
            }
            
            //total due
            double getTotalMoney = 0.0;
            getTotalMoney = getOterMoney + [subtotalStr doubleValue] + getTaxMoney +over_money - [sel_invoice.discount doubleValue];
            NSString *totalStr = [appDelegate appMoneyShowStly4:getTotalMoney];
            
            //balance due
            double getBalanceDueMoney = 0.0;
            getBalanceDueMoney = [totalStr doubleValue] - [sel_invoice.paidDue doubleValue];
            NSString *balanceDueStr;
            if (getBalanceDueMoney < 0)
            {
                balanceDueStr = ZERO_NUM;
            }
            else
            {
                balanceDueStr = [appDelegate appMoneyShowStly4:getBalanceDueMoney];
            }
            
            sel_invoice.subtotal = subtotalStr;
            sel_invoice.totalDue = totalStr;
            sel_invoice.balanceDue = balanceDueStr;
            
            sel_invoice.accessDate = [NSDate date];
            
            if([sel_invoice.logs count]==0 && _isDelete==1)
                sel_invoice.sync_status = [NSNumber numberWithInt:1];
           else
               sel_invoice.sync_status = [NSNumber numberWithInt:0];
            
            [appDelegate.managedObjectContext save:&error];
            //parse update local
            [appDelegate.parseSync updateInvoiceFromLocal:sel_invoice];
        }
    }
}

/**
    获取所有存在的Invoice的数据，按照dueDate排序
 */
-(NSArray *)do_getInvoiceData
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectModel *model = [appDelegate managedObjectModel];
    NSEntityDescription *InvoiceEntity = [[model entitiesByName] valueForKey:@"Invoice"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:InvoiceEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status == 0"];

    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}







/*
    比较秒，如果是
 */
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
    if ([cmpday1 year] == [cmpday2 year]&&[cmpday1 month] ==[cmpday2 month]&&[cmpday1 day]== [cmpday2 day] && [cmpday1 hour]>[cmpday2 hour])
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
@end


