//
//  Logs.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clients, Invoice;

@interface Logs : NSManagedObject

@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSString * totalmoney;
@property (nonatomic, retain) NSNumber * isInvoice;
@property (nonatomic, retain) NSString * worked;
@property (nonatomic, retain) NSString * taxmoney;
@property (nonatomic, retain) NSDate * starttime;
@property (nonatomic, retain) NSNumber * overtimeFree;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * endtime;
@property (nonatomic, retain) NSNumber * isPaid;
@property (nonatomic, retain) NSNumber * isOverTime;
@property (nonatomic, retain) NSString * invoice_uuid;
@property (nonatomic, retain) NSString * ratePerHour;
@property (nonatomic, retain) NSNumber * isNowTimeOn;
@property (nonatomic, retain) NSNumber * isAlreadyFinish;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * finalmoney;
@property (nonatomic, retain) NSString * client_Uuid;
@property (nonatomic, retain) NSSet *invoice;
@property (nonatomic, retain) Clients *client;
@end

@interface Logs (CoreDataGeneratedAccessors)

- (void)addInvoiceObject:(Invoice *)value;
- (void)removeInvoiceObject:(Invoice *)value;
- (void)addInvoice:(NSSet *)values;
- (void)removeInvoice:(NSSet *)values;

@end
