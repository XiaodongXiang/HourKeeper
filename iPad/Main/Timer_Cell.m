//
//  Timer_Cell.m
//  HoursKeeper
//
//  Created by xy_dev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Timer_Cell.h"

@implementation Timer_Cell

-(void)awakeFromNib
{
    [self.amountView creatSubViewsisLeftAlignment:NO];
    [self.totalMoneyView creatSubViewsisLeftAlignment:NO];
    
    self.verticalLine.width = SCREEN_SCALE;
    self.bottomLine.top = self.frame.size.height - SCREEN_SCALE;
    self.bottomLine.height = SCREEN_SCALE;
    
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
