//
//  Jobs_Cell.m
//  HoursKeeper
//
//  Created by xy_dev on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Jobs_Cell.h"

@implementation Jobs_Cell


@synthesize dateLbel;
@synthesize totalMoneyLbel;
@synthesize totalTimerLbel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc
{
//    self.dateLbel;
//    self.totalTimerLbel;
//    self.totalMoneyLbel;
    
}



@end
