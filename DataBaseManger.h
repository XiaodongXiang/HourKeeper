//
//  DataBaseManger.h
//  HoursKeeper
//
//  Created by xy_dev on 10/12/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Invoice.h"

@interface DataBaseManger : NSObject
{
    
}

+(DataBaseManger *)getBaseManger;
-(NSArray *)getDataArray_TableName:(NSString *)m_tableName searchSubPre:(NSDictionary *)m_diction;
-(id)addTableCell:(NSString *)m_tableName;
-(void)saveDataBase;
-(void)deleleTAbleCell:(NSManagedObject *)table_cell;

//database
-(NSArray *)getAllInvpropertyByInvoice:(Invoice *)_invoice isCopy:(BOOL)_copy;
-(void)do_deletClient:(Clients *)_client withManual:(BOOL)isManual;
-(void)do_deletInvoice:(Invoice *)_invoice withManual:(BOOL)isManual fromServerDeleteAccount:(BOOL)isFromAccount isChildContext:(BOOL)isChildContext;
-(void)do_changeLogToInvoice:(Logs *)_log stly:(int)_isDelete;
-(NSArray *)do_getInvoiceData;

@end


