//
//  HMJClientAmountView.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/26.
//
//

#import "HMJClientAmountView.h"
@interface HMJClientAmountView()
{
    BOOL isLeftAlignment;
}
@property(nonatomic,assign)int amountFontSize;
@property(nonatomic,assign)int pointFontSize;
@property(nonatomic,assign)int hourSize;

@property(nonatomic,strong)NSString *currencyString;
@property(nonatomic,strong)NSString *amountString;
@property(nonatomic,strong)NSString *pointString;
@property(nonatomic,strong)NSString *hourString;

@property(nonatomic,strong)UILabel  *amountLabel;
@end

@implementation HMJClientAmountView

-(CGSize)pointSize
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_pointFontSize],NSFontAttributeName,nil];
    CGSize pointSize = [_pointString sizeWithAttributes:dic];
    
    return pointSize;
}


-(CGSize)amountSize
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_amountFontSize],NSFontAttributeName,nil];
    CGSize amountSize = [[_amountString substringToIndex:(_amountString.length-3)] sizeWithAttributes:dic];
    return amountSize;
}

-(CGSize)perHourSize
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:_hourSize],NSFontAttributeName,nil];
    CGSize hourSize = [_hourString sizeWithAttributes:dic];
    return hourSize;
}


-(void)creatSubViewsisLeftAlignment:(BOOL)isLeft
{
    if (_amountLabel == nil)
    {
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_amountLabel];
    }
    
    if (isLeft)
    {
        isLeftAlignment = YES;
        _amountLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        isLeftAlignment = NO;
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    
}

-(void)setAmountSize:(int)amountSize pointSize:(int)pointSize hourSize:(int)perHourSize Currency:(NSString *)currency Amount:(NSString *)amount color:(UIColor *)color
{
    _amountFontSize = amountSize;
    _pointFontSize = pointSize;
    _hourSize = perHourSize;
    
    _currencyString = currency;
    _amountString = amount;
    _pointString = [amount substringFromIndex:([amount length]-3)];
    _hourString = @"/h";
    
    
    //金额
    NSString *allTextString = [NSString stringWithFormat:@"%@%@",self.currencyString,[NSString stringWithFormat:@"%@%@",_amountString,@"/h"]];
    NSMutableAttributedString *totalMoneyStringTmp = [[NSMutableAttributedString alloc]initWithString:allTextString];

    NSRange amountRange = NSMakeRange(0, [allTextString length]-5);
    NSRange pointRange = NSMakeRange([allTextString length]-5, 3);
    NSRange perHourRange = NSMakeRange([allTextString length]-2, 2);
    
    UIFont *amountFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_amountFontSize];
    UIFont *pointFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_pointFontSize];
    UIFont *perHourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:_hourSize];
    
    [totalMoneyStringTmp addAttribute:NSFontAttributeName value:amountFont range:amountRange];
    [totalMoneyStringTmp addAttribute:NSFontAttributeName value:pointFont range:pointRange];
    [totalMoneyStringTmp addAttribute:NSFontAttributeName value:perHourFont range:perHourRange];
    [totalMoneyStringTmp addAttribute:NSForegroundColorAttributeName value:[HMJNomalClass creatAmountColor] range:amountRange];
    [totalMoneyStringTmp addAttribute:NSForegroundColorAttributeName value:[HMJNomalClass creatAmountColor] range:pointRange];

    [totalMoneyStringTmp addAttribute:NSForegroundColorAttributeName value:[HMJNomalClass creatBlackColor_114_114_114] range:perHourRange];
    _amountLabel.attributedText = totalMoneyStringTmp;
    
}



//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    if([_amountLabel.text length]>0)
//    {
//        CGSize currencySize = [self currencySize];
//        CGSize pointSize = [self pointSize];
//        CGSize amountSizeTmp = [self amountSize];
//        CGSize perHourSize = [self perHourSize];
//        CGSize amountSize = CGSizeMake(amountSizeTmp.width+pointSize.width+perHourSize.width+1, amountSizeTmp.height);
//
//        
//        //金额
//        NSMutableAttributedString *totalMoneyStringTmp = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",_amountString,@"/h"]];
//        
//        NSRange amountRange = NSMakeRange(0, [totalMoneyStringTmp length]-5);
//        NSRange pointRange = NSMakeRange([totalMoneyStringTmp length]-5, 3);
//        NSRange perHourRange = NSMakeRange([totalMoneyStringTmp length]-2, 2);
//        
//        UIFont *amountFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_amountFontSize];
//        UIFont *pointFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_pointFontSize];
//        UIFont *perHourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:_hourSize];
//        
//        [totalMoneyStringTmp addAttribute:NSFontAttributeName value:amountFont range:amountRange];
//        [totalMoneyStringTmp addAttribute:NSFontAttributeName value:pointFont range:pointRange];
//        [totalMoneyStringTmp addAttribute:NSFontAttributeName value:perHourFont range:perHourRange];
//        [totalMoneyStringTmp addAttribute:NSForegroundColorAttributeName value:[HMJNomalClass creatBlackColor_114_114_114] range:perHourRange];
//        _amountLabel.attributedText = totalMoneyStringTmp;
//        
//        
//        float currencyTop = (self.height-amountSize.height)/2;
//        if (_currencyFontSize==15)
//        {
//            currencyTop = currencyTop +3;
//        }
//        else if (_currencyFontSize==11)
//        {
//            
//        }
//        else if (_currencyFontSize==9)
//        {
//            
//        }
//        if (amountSize.width+currencySize.width < self.width)
//        {
//            if (isLeftAlignment)
//            {
//                _currencyLabel.frame = CGRectMake(0, currencyTop, currencySize.width, currencySize.height);
//                
//                _amountLabel.frame = CGRectMake(_currencyLabel.width, (self.height-amountSize.height)/2, amountSize.width, amountSize.height);
//                
//            }
//            else
//            {
//                _amountLabel.frame = CGRectMake(self.width - amountSize.width, (self.height-amountSize.height)/2, amountSize.width, amountSize.height);
//                //左边
//                _currencyLabel.frame = CGRectMake(_amountLabel.left - currencySize.width, currencyTop, currencySize.width, currencySize.height);
//            }
//            
//            
//        }
//        else
//        {
//            
//            _currencyLabel.frame = CGRectMake(1, currencyTop, currencySize.width, currencySize.height);
//            float left = currencySize.width+_currencyLabel.left;
//            float with = self.width - left;
//            _amountLabel.frame = CGRectMake(left, (self.height-amountSize.height)/2, with, amountSize.height);
//            
////            if(_amountFontSize==25)
////                _currencyLabel.left = _currencyLabel.left+15;
//            
//        }
//        
//        
//    }
//    
//    
//}

@end
