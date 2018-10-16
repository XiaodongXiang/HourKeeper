//
//  ClientCell.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/26.
//
//

#import "ClientCell.h"




@implementation ClientCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.height = 50;
        float left = 15;
        if (IS_IPHONE_6PLUS)
        {
            left = 20;
        }

        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, SCREEN_WITH/3*2 - left - 10, self.height)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
        _nameLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:15];

        [self addSubview:_nameLabel];
        
        _amountView = [[HMJClientAmountView alloc]init];
        _amountView.width = SCREEN_WITH/4 - left - 5;
        _amountView.left = SCREEN_WITH/4*3 + 5;
        _amountView.top = 0;
        _amountView.height = self.height;
        [self addSubview:_amountView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WITH/4*3, 7, SCREEN_SCALE, self.height-7*2)];
        line.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
        [self addSubview:line];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-SCREEN_SCALE, SCREEN_WITH*2, SCREEN_SCALE)];
        _bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        [self addSubview:_bottomLine];
        

        

    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
