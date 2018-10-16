//
//  TimesheetLogs_Cell_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 8/19/13.
//
//

#import "TimesheetLogs_Cell_ipad.h"

@implementation TimesheetLogs_Cell_ipad

#pragma mark Init
-(void)awakeFromNib
{
    self.line.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
    self.line.width = SCREEN_SCALE;
    
    self.bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
    self.bottomLine.top = self.height - SCREEN_SCALE;
    self.bottomLine.height = SCREEN_SCALE;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.line.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
        self.line.width = SCREEN_SCALE;
        
        self.bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        self.bottomLine.top = self.height - SCREEN_SCALE;
        self.bottomLine.height = SCREEN_SCALE;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
