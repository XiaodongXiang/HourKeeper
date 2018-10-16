//
//  HMJLeftMenuButton.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/17.
//
//

#import "HMJLeftMenuButton.h"


@interface HMJLeftMenuButton()
{
//    UIView  *blueView;
}
@property(nonatomic,strong)UIButton *btn;
@end

@implementation HMJLeftMenuButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, frame.size.height)];
//        blueView.backgroundColor = [UIColor colorWithRed:63.f/255.f green:171.f/255.f blue:227.f/255.f alpha:1];
//        [self addSubview:blueView];
        
        float with = 18;
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-with, (frame.size.height-with)/2, with, with)];
        [self addSubview:_rightImageView];
        
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
//
        [self setBackgroundImage:[UIImage createImageWithColor:RGBColor(67, 113, 255)] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage createImageWithColor:RGBColor(37, 40 , 52)] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
//
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//        self.selected = NO;
    }
    
    return self;
}

/*
    自定义selected方法
 */
-(void)setSelected:(BOOL)selected
{
    
    [super setSelected:selected];
    if (selected)
    {
//        blueView.hidden = NO;
//        self.backgroundColor = RGBColor(67, 113, 255);
    }
    else
    {
//        blueView.hidden = YES;
//        self.backgroundColor = [UIColor clearColor];
    }
}


@end
