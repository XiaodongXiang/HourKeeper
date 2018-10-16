//
//  ChartCell_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartCell_ipad.h"

@implementation ChartCell_ipad


-(void)awakeFromNib
{
    self.verticalLine.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
    self.verticalLine.width = SCREEN_SCALE;
    
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
