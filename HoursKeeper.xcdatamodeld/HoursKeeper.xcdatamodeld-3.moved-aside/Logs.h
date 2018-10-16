//
//  Logs.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-18.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Clients;
@class Invoice;

@interface Logs :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * worked;
@property (nonatomic, retain) NSString * ratePerHour;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) Clients * client;
@property (nonatomic, retain) Invoice * invoice;

@end



