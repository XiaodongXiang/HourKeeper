//
//  Profile.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/30.
//
//

#import "Profile.h"
#import "UIImageToDataTransformer.h"


@implementation Profile

@dynamic uuid;
@dynamic state;
@dynamic lastName;
@dynamic phone;
@dynamic firstName;
@dynamic zip;
@dynamic sex;
@dynamic sync_status;
@dynamic name;
@dynamic street;
@dynamic parentUuid;
@dynamic company;
@dynamic fax;
@dynamic city;
@dynamic email;
@dynamic databaseVersion;
@dynamic accessDate;
@dynamic headImage;

+ (void)initialize {
    if (self == [Profile class])
    {
        UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
    }
}

@end
