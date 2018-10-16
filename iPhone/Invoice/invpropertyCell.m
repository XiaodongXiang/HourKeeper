//
//  invpropertyCell.m
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-22.
//
//

#import "invpropertyCell.h"


@implementation invpropertyCell


@synthesize nameLbel;
@synthesize priceLbel;
@synthesize totalLbel;

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

//-(void)dealloc
//{
//    self.nameLbel;
//    self.priceLbel;
//    self.totalLbel;
//    
//}


@end
