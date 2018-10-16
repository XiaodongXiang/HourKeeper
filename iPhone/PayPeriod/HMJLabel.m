//
//  HMJLabel.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/23.
//
//

#import "HMJLabel.h"
#import "HMJNomalClass.h"

@interface HMJLabel()
{
}
@property(nonatomic,assign)BOOL isLeftAlignment;
@property(nonatomic,assign)int amountFontSize;
@property(nonatomic,assign)int pointFontSize;

@property(nonatomic,strong)NSString *currencyString;
@property(nonatomic,strong)NSString *amountString;
@property(nonatomic,strong)NSString *pointString;

@property(nonatomic,strong)UILabel  *amountLabel;


//@property(nonatomic,strong)UILabel  *pointLabel;
@end

@implementation HMJLabel

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
        _isLeftAlignment = YES;
        _amountLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        _isLeftAlignment = NO;
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    
    

}

-(void)setAmountSize:(int)amountSize pointSize:(int)pointSize Currency:(NSString *)currency Amount:(NSString *)amount color:(UIColor *)color
{
    _amountFontSize = amountSize;
    _pointFontSize = pointSize;
    
    _currencyString = currency;
    _amountString = amount;
    _pointString = [amount substringFromIndex:([amount length]-3)];
    
    _amountLabel.textColor = color;
    
    
    NSString *allTextString = [NSString stringWithFormat:@"%@%@",self.currencyString,[NSString stringWithFormat:@"%.2f",[_amountString doubleValue]]];
    //金额
    NSMutableAttributedString *totalMoneyStringTmp = [[NSMutableAttributedString alloc]initWithString:allTextString];
    
    NSRange amountRange = NSMakeRange(0, [allTextString length]-3);
    NSRange pointRange = NSMakeRange([allTextString length]-3, 3);
//    UIFont *currencyFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_amountFontSize-3];

    UIFont *amountFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_amountFontSize];

    UIFont *pointFont = [HMJNomalClass creatFont_AkzidenzGroteskCond_Size:_pointFontSize];

    
    [totalMoneyStringTmp addAttribute:NSFontAttributeName value:amountFont range:amountRange];
    [totalMoneyStringTmp addAttribute:NSFontAttributeName value:pointFont range:pointRange];
    _amountLabel.attributedText = totalMoneyStringTmp;
    

}






@end
