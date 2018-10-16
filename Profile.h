//
//  Profile.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * parentUuid;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * databaseVersion;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) id headImage;

@end
