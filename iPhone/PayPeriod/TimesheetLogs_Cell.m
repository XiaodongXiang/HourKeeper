//
//  TimesheetLogs_Cell.m
//  HoursKeeper
//
//  Created by xy_dev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimesheetLogs_Cell.h"



@implementation TimesheetLogs_Cell



@synthesize dateLbel;

@synthesize totalMoneyLbel;
@synthesize totalTimerLbel;
@synthesize overTimerLbel;

@synthesize logCountLabel;



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    
    float left = 15;
//    if (IS_IPHONE_6PLUS)
//    {
//        left = 20;
//    }
    self.totalTimerLbel.left = SCREEN_WITH*3.0/4.0 - left - 60 + (1-SCREEN_SCALE);
    self.overTimerLbel.left = SCREEN_WITH*3.0/4.0 - left - 60 + (1-SCREEN_SCALE);
    
}



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



@end
