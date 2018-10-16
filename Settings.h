//
//  Settings.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * havetouchid;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * istouchid;
@property (nonatomic, retain) NSDate * lastSyncDate;
@property (nonatomic, retain) NSNumber * sync_status;
@property (nonatomic, retain) NSNumber * isPasscodeOn;
@property (nonatomic, retain) NSString * dataBaseVersion;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * parentUuid;
@property (nonatomic, retain) NSString * autoSync;
@property (nonatomic, retain) NSDate * daliyStartTime;
@property (nonatomic, retain) NSNumber * isBadgeOn;
@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * lastUser;

@end
