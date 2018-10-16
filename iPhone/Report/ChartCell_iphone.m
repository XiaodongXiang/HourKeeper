//
//  ChartCell_iphone.m
//  HoursKeeper
//
//  Created by xy_dev on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartCell_iphone.h"


@implementation ChartCell_iphone

- (void)awakeFromNib
{

    
    
    
    float left = 15;
    if (IS_IPHONE_6PLUS)
    {
        left = 20;
        self.bottomLine.left = left;
        self.colorImageV.left = left;
        self.nameLbel.left = self.nameLbel.left + 5;
        self.amountLabel.left = self.amountLabel.left-5;
        self.midLbel.left =  self.midLbel.left - 5;
        
        self.percentageLbel.left = SCREEN_WITH*3.0/4.0 - left - 60 + (1-SCREEN_SCALE);

    }
    else
    {
        self.percentageLbel.left = SCREEN_WITH*3.0/4.0 - left - 60 + (1-SCREEN_SCALE);

    }
    
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
