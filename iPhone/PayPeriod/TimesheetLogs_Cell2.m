//
//  TimesheetLogs_Cell2.m
//  HoursKeeper
//
//  Created by xy_dev on 6/7/13.
//
//

#import "TimesheetLogs_Cell2.h"

@implementation TimesheetLogs_Cell2



@synthesize dateLbel;

@synthesize startDateLbel;

@synthesize totalMoneyLbel;
@synthesize totalTimerLbel;

@synthesize clockImageV;

@synthesize high;



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


-(void)awakeFromNib
{
    self.bottomLine.top = 50-SCREEN_SCALE;
}



@end
