//
//  SelectedClientCell.m
//  HoursKeeper
//
//  Created by humingjing on 15/9/8.
//
//

#import "SelectedClientCell.h"

@implementation SelectedClientCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 30)];
        self.nameLabel.textColor = [UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:227.0/255.0 alpha:1];
        self.nameLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:13];
        [self.nameLabel setHighlightedTextColor:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1]];
        [self addSubview:self.nameLabel];
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 30-SCREEN_SCALE, self.frame.size.width, SCREEN_SCALE)];
//        line.backgroundColor = [UIColor blackColor];
//        [self addSubview:line];
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
