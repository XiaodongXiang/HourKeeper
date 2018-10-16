//
//  Invoice.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clients, Invoiceproperty, Logs;

@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSString * totalDue;//所有支出的总金额
@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * parentUuid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * invoiceNO;
@property (nonatomic, retain) NSString * tax;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSString * terms;
@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * balanceDue;//最后剩余需要支付的金额
@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSString * subtotal; //不加加班等的总金额
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSString * credit;
@property (nonatomic, retain) NSString * paidDue;//支付的金额
@property (nonatomic, retain) Clients *client;
@property (nonatomic, retain) NSSet *logs;
@property (nonatomic, retain) NSSet *invoicepropertys;
@end

@interface Invoice (CoreDataGeneratedAccessors)

- (void)addLogsObject:(Logs *)value;
- (void)removeLogsObject:(Logs *)value;
- (void)addLogs:(NSSet *)values;
- (void)removeLogs:(NSSet *)values;

- (void)addInvoicepropertysObject:(Invoiceproperty *)value;
- (void)removeInvoicepropertysObject:(Invoiceproperty *)value;
- (void)addInvoicepropertys:(NSSet *)values;
- (void)removeInvoicepropertys:(NSSet *)values;

@end
