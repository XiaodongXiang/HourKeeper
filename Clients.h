//
//  Clients.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invoice, Logs;

@interface Clients : NSManagedObject

@property (nonatomic, retain) NSNumber * payPeriodNum1;
@property (nonatomic, retain) NSDate   * beginTime;
@property (nonatomic, retain) NSString * r_tueRate;
@property (nonatomic, retain) NSNumber * payPeriodStly;
@property (nonatomic, retain) NSNumber * isTaxableOn;
@property (nonatomic, retain) NSString * parentUuid;
@property (nonatomic, retain) NSString * r_wedRate;
@property (nonatomic, retain) NSString * r_satRate;
@property (nonatomic, retain) NSString * r_sunRate;
@property (nonatomic, retain) NSString * dailyOverFirstHour;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * weeklyOverSecondTax;
@property (nonatomic, retain) NSString * clientName;
@property (nonatomic, retain) NSString * timeRoundTo;
@property (nonatomic, retain) NSString * dailyOverFirstTax;
@property (nonatomic, retain) NSDate   * accessDate;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * lunchTime;
@property (nonatomic, retain) NSDate   * lunchEnd;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSDate * payPeriodDate;
@property (nonatomic, retain) NSString * taxRate;
@property (nonatomic, retain) NSString * r_thuRate;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * payPeriodNum2;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * dailyOverSecondHour;
@property (nonatomic, retain) NSDate * lunchStart;
@property (nonatomic, retain) NSString * r_friRate;
@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSString * weeklyOverFirstTax;
@property (nonatomic, retain) NSNumber * r_isDaily;
@property (nonatomic, retain) NSString * dailyOverSecondTax;
@property (nonatomic, retain) NSString * weeklyOverSecondHour;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * r_monRate;
@property (nonatomic, retain) NSString * ratePerHour;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * r_weekRate;
@property (nonatomic, retain) NSString * weeklyOverFirstHour;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSSet *logs;
@property (nonatomic, retain) NSSet *invoices;
@end

@interface Clients (CoreDataGeneratedAccessors)

- (void)addLogsObject:(Logs *)value;
- (void)removeLogsObject:(Logs *)value;
- (void)addLogs:(NSSet *)values;
- (void)removeLogs:(NSSet *)values;

- (void)addInvoicesObject:(Invoice *)value;
- (void)removeInvoicesObject:(Invoice *)value;
- (void)addInvoices:(NSSet *)values;
- (void)removeInvoices:(NSSet *)values;

@end
