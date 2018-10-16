//
//  PayperiodCell.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/6.
//
//

#import "PayperiodCell.h"
#import "HMJLabel.h"

@implementation PayperiodCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float left = 15;
        if (IS_IPHONE_6PLUS)
        {
            left = 20;
        }
        self.height = 50;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 0, SCREEN_WITH*2.0/5-10, self.height-1)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
        _nameLabel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
        [self addSubview:_nameLabel];
        
        
        _verticalLine = [[UIView alloc]init];
        _verticalLine.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
        _verticalLine.top = 7;
        _verticalLine.height = self.height - _verticalLine.top*2;
        _verticalLine.left = SCREEN_WITH * 3.0/4.0;
        _verticalLine.width = SCREEN_SCALE;
        [self addSubview:_verticalLine];
        
        _pointInTimeLabel = [[UILabel alloc]init];
        _pointInTimeLabel.backgroundColor = [UIColor clearColor];
        _pointInTimeLabel.textColor = [HMJNomalClass creatBlackColor_114_114_114];
        _pointInTimeLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
        _pointInTimeLabel.textAlignment = NSTextAlignmentRight;
        _pointInTimeLabel.top = 3;
        _pointInTimeLabel.height = 25;
        _pointInTimeLabel.left = SCREEN_WITH*2/5.0;
        //14是与竖线的间距
        _pointInTimeLabel.width = SCREEN_WITH*3/4.0 -  _pointInTimeLabel.left - left + (1-SCREEN_SCALE);
        [self addSubview:_pointInTimeLabel];

        
        
        
        
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textColor = [HMJNomalClass creatGrayColor_152_152_152];
        _totalTimeLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:13];
        _totalTimeLabel.textAlignment = NSTextAlignmentRight;
        _totalTimeLabel.top = 17;
        _totalTimeLabel.height = self.height - _totalTimeLabel.top;
        _totalTimeLabel.left = _pointInTimeLabel.left;
        _totalTimeLabel.width = _pointInTimeLabel.width;
        [self addSubview:_totalTimeLabel];
        
        
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        _bottomLine.top = self.height - SCREEN_SCALE;
        _bottomLine.left = left;
        _bottomLine.width = SCREEN_WITH + 50;
        _bottomLine.height = SCREEN_SCALE;
        [self addSubview:_bottomLine];
        
        _amountView = [[HMJLabel alloc]init];
        _amountView.backgroundColor = [UIColor clearColor];
        _amountView.top = 0;
        _amountView.height = self.height;
        _amountView.left = _verticalLine.left + 2;
        _amountView.width = SCREEN_WITH - left - _amountView.left;
        [self addSubview:_amountView];
        
        _clockImageV = [[UIImageView alloc]init];
        _clockImageV.image = [UIImage imageNamed:@"link_paid_34.png"];
        _clockImageV.backgroundColor = [UIColor clearColor];
        _clockImageV.left = SCREEN_WITH / 2.0;
        _clockImageV.width = _clockImageV.image.size.width;
        _clockImageV.height = _clockImageV.image.size.height;
        _clockImageV.top = (self.height - _clockImageV.height)/2;
        [self addSubview:_clockImageV];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
