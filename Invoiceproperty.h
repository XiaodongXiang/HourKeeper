//
//  Invoiceproperty.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invoice;

@interface Invoiceproperty : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSNumber * tax;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parentUuid;
@property (nonatomic, retain) Invoice *invoice;

@end
