//
//  invoiceShow_Cell.m
//  HoursKeeper
//
//  Created by xy_dev on 5/22/13.
//
//

#import "invoiceShow_Cell.h"

@implementation invoiceShow_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        float left=0;
        if (IS_IPHONE_6PLUS)
            left = 20;
        else
            left = 15;
        
        float heigh = 50;
        _invoiceNameLbel = [[UILabel alloc]initWithFrame:CGRectMake(left, 3, SCREEN_WITH/4*3-20, 24)];
        _invoiceNameLbel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
        _invoiceNameLbel.backgroundColor = [UIColor clearColor];
        _invoiceNameLbel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:15];
        _invoiceNameLbel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_invoiceNameLbel];
        
        _clientNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(left, 23, _invoiceNameLbel.width, 23)];
        _clientNameLabel.textColor = [HMJNomalClass creatGrayColor_164_164_164];
        _clientNameLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:12];
        [self addSubview:_clientNameLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WITH/4.0*3, 7, SCREEN_SCALE, heigh-14)];
        line.backgroundColor = [HMJNomalClass creatCellVerticalLineColor_225_225_225];
        [self addSubview:line];
        
        _totalMoneyLbel = [[HMJLabel alloc]initWithFrame:CGRectMake(line.left, 0, SCREEN_WITH-line.left-left, heigh)];
        _totalMoneyLbel.backgroundColor = [UIColor clearColor];
        [self addSubview:_totalMoneyLbel];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, heigh-SCREEN_SCALE, SCREEN_WITH, SCREEN_SCALE)];
        _bottomLine.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
