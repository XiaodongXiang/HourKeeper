//
//  HMJCustomAnimationButton.m
//  ButtonAnimationSample
//
//  Created by humingjing on 15/7/13.
//  Copyright (c) 2015年 humingjing. All rights reserved.
//

#import "HMJCustomAnimationButton.h"
#import "UIViewAdditions_ipad.h"


@interface HMJCustomAnimationButton ()
{
    CGRect selfFrame;
}
@property (assign,nonatomic)BOOL    isEndAnimation;

@property (strong, nonatomic) UILabel *signInLabel;
@property (strong, nonatomic) UIImageView *signInSemicircle;

@end

@implementation HMJCustomAnimationButton

-(id)initWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)bgColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.backgroundColor = bgColor;
        self.contentMode = UIViewContentModeCenter;
        self.frame = frame;
        selfFrame = frame;
        //text
        _signInLabel = [[UILabel alloc]init];
        
        _signInLabel.textAlignment = NSTextAlignmentCenter;
        _signInLabel.frame = selfFrame;
        
        _signInLabel.width = 80;
        _signInLabel.left = (self.width - _signInLabel.width)/2;
        _signInLabel.top = 0;
        _signInLabel.height = self.height;
        _signInLabel.text = title;
        _signInLabel.textColor = [UIColor whiteColor];
        _signInLabel.backgroundColor = [UIColor clearColor];
        _signInLabel.textAlignment = NSTextAlignmentCenter;
        _signInLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _signInLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        [self addSubview:_signInLabel];
        
        
        //signInSemicircle
        UIImage *tmpImage = [UIImage imageNamed:@"Semicircle1"];
        _signInSemicircle = [[UIImageView alloc]initWithImage:tmpImage];
        _signInSemicircle.width = tmpImage.size.width;
        _signInSemicircle.height = tmpImage.size.height;
        _signInSemicircle.left = (self.width - tmpImage.size.width)/2;
        _signInSemicircle.top = (self.height - tmpImage.size.height)/2;
        _signInSemicircle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _signInSemicircle.alpha = 0;
        [self addSubview:_signInSemicircle];
        
//        _signInRotateLastImage.top = (selfFrame.size.height- tmpImage.size.height)/2;
        
        //signInRotateLastImage
        UIImage *lastImage = [UIImage imageNamed:@"Semicircle16"];
        _signInRotateLastImage = [[UIImageView alloc]initWithImage:lastImage];
        _signInRotateLastImage.width = tmpImage.size.width;
        _signInRotateLastImage.height = tmpImage.size.height;
        _signInRotateLastImage.left = (self.width - tmpImage.size.width)/2;
        _signInRotateLastImage.top = (self.height - tmpImage.size.height)/2;
        _signInRotateLastImage.backgroundColor = [UIColor clearColor];
        _signInRotateLastImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _signInRotateLastImage.alpha = 0;
        [self addSubview:_signInRotateLastImage];
        

    }
    
    return self;
}


#pragma mark Action
-(void)begainAnimation
{
    _isEndAnimation = NO;
    if (_isEndAnimation)
        return;
    
    float width=self.height;
    float y=self.frame.origin.y;
    
    NSLog(@"selfFrame.size.width/2 : %f",selfFrame.size.width/2);
    NSLog(@"width/2.0 : %f",width/2.0);
    
    float superViewWith = self.superview.width;
    [UIView beginAnimations:@"btnAnimation" context:nil];
    [UIView setAnimationDuration:0.25];
    _signInLabel.alpha=0;
    self.layer.cornerRadius = width/2;
    self.frame=CGRectMake(superViewWith/2.0-width/2.0, y, width, width);
    [self performSelector:@selector(circleIn) withObject:nil afterDelay:0.25];
    [UIView commitAnimations];
    
    
    
    
    //    //按钮变小
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //        float width=_signInView.height;
    //        float y=_signInView.frame.origin.y;
    //        _signInView.frame=CGRectMake(SCREEN_WIDTH/2-width/2, y, width, width);
    //        CALayer *layer=_signInView.layer;
    //        [layer setCornerRadius:_signInView.width/2];
    //    } completion:^(BOOL finished){
    //        //显示进度
    //        [self circleIn];
    //    }];
}

-(void)circleIn
{
    if (_isEndAnimation)
        return;
    _signInSemicircle.alpha = 1;
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Semicircle1"],
                         [UIImage imageNamed:@"Semicircle2"],
                         [UIImage imageNamed:@"Semicircle3"],
                         [UIImage imageNamed:@"Semicircle4"],
                         [UIImage imageNamed:@"Semicircle5"],
                         [UIImage imageNamed:@"Semicircle6"],
                         [UIImage imageNamed:@"Semicircle7"],
                         [UIImage imageNamed:@"Semicircle8"],
                         [UIImage imageNamed:@"Semicircle9"],
                         [UIImage imageNamed:@"Semicircle10"],
                         [UIImage imageNamed:@"Semicircle11"],
                         [UIImage imageNamed:@"Semicircle12"],
                         [UIImage imageNamed:@"Semicircle13"],
                         [UIImage imageNamed:@"Semicircle14"],
                         [UIImage imageNamed:@"Semicircle15"],
                         [UIImage imageNamed:@"Semicircle16"],nil];
    _signInSemicircle.animationImages=gifArray;
    _signInSemicircle.animationDuration=0.2;
    _signInSemicircle.animationRepeatCount=1;
    [_signInSemicircle startAnimating];
    [self performSelector:@selector(rotate) withObject:self afterDelay:0.2];
}

//转圈动画
-(void)rotate
{
    //    _signInRotate.alpha=1;
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.01];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    //    _signInRotate.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180));
    //    [UIView commitAnimations];
    
    if (_isEndAnimation)
        return;
    
    _signInRotateLastImage.alpha = 1;
    _signInSemicircle.alpha = 0;
    
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(-M_PI/2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.3;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = YES;
    [_signInRotateLastImage.layer addAnimation:animation forKey:nil ];
    
}


//结束动画
-(void)endAnimation
{
    _isEndAnimation = YES;
    [_signInRotateLastImage.layer removeAllAnimations];
    _signInRotateLastImage.alpha = 0;
    _signInSemicircle.alpha = 0;
    
    //按钮变大
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.cornerRadius = 3;
        self.width = selfFrame.size.width;
        self.left = 0;
        
        double screenWith;
        if (ISPAD)
        {
            screenWith = 1024;
        }
        else
            screenWith = SCREEN_WITH;
        
        self.frame=CGRectMake(screenWith/2.0-self.width/2.0, self.top, selfFrame.size.width, selfFrame.size.height);
        
//        self.size = selfFrame.size;
//        self.center = CGPointMake(screenWith/2.0, self.center.y);
        _signInLabel.alpha=1;
    } completion:^(BOOL finished) {
        //显示提示语句Label
    }];
    
}

//-(void)setSelfFrame:(CGRect)frame
//{
////    self.frame = frame;
//    
//}

@end
