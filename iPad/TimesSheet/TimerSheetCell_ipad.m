//
//  TimerSheetCell_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerSheetCell_ipad.h"



@implementation TimerSheetCell_ipad

#pragma mark Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.bv.top = 39 - SCREEN_SCALE;
        self.bv.height = SCREEN_SCALE;
        
        self.blueBgView.width = 75-SCREEN_SCALE;
    }
    return self;
}

-(void)awakeFromNib
{
    // Initialization code
    self.bv.top = 39 - SCREEN_SCALE;
    self.bv.height = SCREEN_SCALE;
    
    self.blueBgView.width = 75-SCREEN_SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
