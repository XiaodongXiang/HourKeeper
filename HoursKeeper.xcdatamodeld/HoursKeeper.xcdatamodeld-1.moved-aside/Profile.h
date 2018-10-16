//
//  Profile.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-5.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Profile :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Street;
@property (nonatomic, retain) NSString * Company;
@property (nonatomic, retain) NSString * State;
@property (nonatomic, retain) NSNumber * Zip;
@property (nonatomic, retain) NSNumber * Phone;
@property (nonatomic, retain) NSNumber * Fax;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * City;

@end



