//
//  TimeStartViewCell.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import "TimeStartViewCell.h"


@implementation TimeStartViewCell

//- (void)awakeFromNib {
//    float left = 15;
//    if (IS_IPHONE_6PLUS)
//    {
//        left = 20;
//    }
//    _totalTimeLabel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
//    _totalTimeLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
//    
//    _totalTimeLabel.backgroundColor = [UIColor redColor];
//    
//    _verticalLine.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
//    _bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
//    
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _containView = [[UIView alloc]initWithFrame:self.frame];
        self.containView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.containView setClipsToBounds:YES];
        [self.contentView addSubview:self.containView];
        
        double finalScreenWith = SCREEN_WITH;
        if (ISPAD)
        {
            finalScreenWith = 320;
        }
        
        
        float left = 15;
//        if (IS_IPHONE_6PLUS)
//        {
//            left = 20;
//        }
        self.height = 65;
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
//        _totalTimeLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
        _totalTimeLabel.font = [UIFont fontWithName:FontSFUITextMedium size:16];
        _totalTimeLabel.top = 12;
        _totalTimeLabel.height = 19;
        _totalTimeLabel.width = finalScreenWith * 0.5 - 20 - left;
        _totalTimeLabel.left = left;
        [self.containView addSubview:_totalTimeLabel];
        
        
        
//        _verticalLine = [[UIView alloc]init];
//        _verticalLine.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
//        _verticalLine.top = 7;
//        _verticalLine.height = self.height - _verticalLine.top*2;
//        _verticalLine.left = finalScreenWith * 3.0/4.0;
//        _verticalLine.width = SCREEN_SCALE;
//        [self.containView addSubview:_verticalLine];
        
        
        _pointInTimeLabel = [[UILabel alloc]init];
        _pointInTimeLabel.backgroundColor = [UIColor clearColor];
        _pointInTimeLabel.textColor = [HMJNomalClass creatBlackColor_114_114_114];
//        _pointInTimeLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:11];
//        _pointInTimeLabel.textAlignment = NSTextAlignmentRight;
        _pointInTimeLabel.font = [UIFont fontWithName:FontSFUITextRegular size:14];
        _pointInTimeLabel.textColor = RGBColor(193, 197, 209);
        _pointInTimeLabel.top = 36;
        _pointInTimeLabel.height = 16;
        _pointInTimeLabel.left = left;
//        _pointInTimeLabel.width = finalScreenWith*3.0/4.0 - left - _pointInTimeLabel.left + (1-SCREEN_SCALE);
        _pointInTimeLabel.width = 105;

        
        [self.containView addSubview:_pointInTimeLabel];
        
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [HMJNomalClass creatGrayColor_152_152_152];
//        _dateLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:12];
//        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont fontWithName:FontSFUITextRegular size:14];
        _dateLabel.textColor = RGBColor(193, 197, 209);
        _dateLabel.top = 36;
        _dateLabel.height = 16;
        _dateLabel.left = CGRectGetMaxX(_pointInTimeLabel.frame);
        _dateLabel.width = _pointInTimeLabel.width;
        [self.containView addSubview:_dateLabel];
        
        
//        _bottomLine = [[UIView alloc]init];
//        _bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
//        _bottomLine.top = self.height - SCREEN_SCALE;
//        _bottomLine.left = left;
//        _bottomLine.width = finalScreenWith + 50;
//        _bottomLine.height = SCREEN_SCALE;
//        [self.containView addSubview:_bottomLine];
        
        _amountView = [[HMJLabel alloc]init];
        _amountView.backgroundColor = [UIColor clearColor];
        _amountView.top = 0;
        _amountView.height = self.height;
        _amountView.left = _verticalLine.left + 2;
        _amountView.width = finalScreenWith - left - _amountView.left;
        _amountView.centerY = self.height/2;

        [self.containView addSubview:_amountView];
        
        _clockImageV = [[UIImageView alloc]init];
        _clockImageV.image = [UIImage imageNamed:@"link_paid_34.png"];
        _clockImageV.backgroundColor = [UIColor clearColor];
        _clockImageV.left = finalScreenWith / 2.0;
        _clockImageV.width = _clockImageV.image.size.width;
        _clockImageV.height = _clockImageV.image.size.height;
        _clockImageV.top = (self.height - _clockImageV.height)/2;
        [self.containView addSubview:_clockImageV];
    
        [self.contentView setClipsToBounds:YES];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
