
//
//  DashBoardExternalView.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/1.
//
//

#import "DashBoardExternalView.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation DashBoardExternalView

//iPhone初始化
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _internalImageView = [[UIImageView alloc]init];
        _internalImageView.width = 68;
        if (ISPAD)
        {
            _internalImageView.width = 94;

        }
        _internalImageView.image = [UIImage imageNamed:@"blue_round"];
        _internalImageView.height = _internalImageView.width;
        _internalImageView.top = (self.width - _internalImageView.width)/2;
        _internalImageView.left = _internalImageView.top;
        [self addSubview:_internalImageView];
    }
    return self;
}
//iPad从xib初始化
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _internalImageView = [[UIImageView alloc]init];
    _internalImageView.width = 68;
    if (ISPAD)
    {
        _internalImageView.width = 94;
    }
    _internalImageView.image = [UIImage imageNamed:@"blue_round"];
    _internalImageView.height = _internalImageView.width;
    _internalImageView.top = (self.width - _internalImageView.width)/2;
    _internalImageView.left = _internalImageView.top;
    _internalImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_internalImageView];
    
}
-(void)drawRect:(CGRect)rect
{
    CGRect parentViewBounds = self.bounds;
    CGFloat x = CGRectGetWidth(parentViewBounds)/2;
    CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    float bluea = 17/255.0;
    float blueb = 155/255.0;
    float bluec = 227/255.0;
    
    float reda = 244/255.f;
    float redb = 79/255.f;
    float redc = 68/255.f;
    
    //没有预设时间，一直是蓝色
    double startdegrees = -90;
    if (self.isGray)
    {
        CGContextSetFillColor(context, CGColorGetComponents( [ [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f] CGColor]));
        CGContextMoveToPoint(context,x, y);
        CGContextAddArc(context, x, y , self.width/2,radians(startdegrees),radians(startdegrees+360), 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
        _internalImageView.image = [UIImage imageNamed:@"ipad_not_counting"];

    }
    else
    {
        if (_totalTime<=0)
        {
            CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:bluea green:blueb blue:bluec alpha:1.f] CGColor]));
            CGContextMoveToPoint(context,x, y);
            CGContextAddArc(context, x, y , self.width/2,radians(startdegrees),radians(startdegrees+360), 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
//            if (ISPAD)
//            {
//                _internalImageView.image = [UIImage imageNamed:@"ipad_blue_round"];
//
//            }
//            else
                _internalImageView.image = [UIImage imageNamed:@"blue_round"];
            
        }
        else
        {
            if (_totalTime>=_currentTime)
            {
                float percent = _currentTime*1.0/_totalTime;
                CGContextSetFillColor(context, CGColorGetComponents( [ [UIColor colorWithRed:bluea green:blueb blue:bluec alpha:1.f] CGColor]));
                CGContextMoveToPoint(context,x, y);
                CGContextAddArc(context, x, y , self.width/2, radians(startdegrees),radians(startdegrees+percent*360), 0);
                CGContextClosePath(context);
                CGContextFillPath(context);
                
                if(ISPAD)
                {
                    _internalImageView.image = [UIImage imageNamed:@"ipad_blue_round"];

                }
                else
                    _internalImageView.image = [UIImage imageNamed:@"blue_round"];
                
            }
            else
            {
                float percent = (_currentTime-_totalTime)*1.0/_totalTime;
                percent = percent>1?1:percent;
                CGContextSetFillColor(context, CGColorGetComponents( [ [UIColor colorWithRed:reda green:redb blue:redc alpha:1.f] CGColor]));
                CGContextMoveToPoint(context,x, y);
                CGContextAddArc(context, x, y , self.width/2, radians(startdegrees),radians(startdegrees+percent*360), 0);
                CGContextClosePath(context);
                CGContextFillPath(context);
                if (ISPAD)
                {
                    _internalImageView.image = [UIImage imageNamed:@"ipad_red_round"];

                }
                else
                    _internalImageView.image = [UIImage imageNamed:@"red_round"];
                
                
            }
        }

    }
    
    //white circle
    CGContextSetRGBFillColor(context, 1, 1,1, 1);
    CGContextMoveToPoint(context,x, y);
    int whiteCircleR = self.width/2-10;
    if (ISPAD)
    {
        whiteCircleR = self.width/2-14;
    }
    CGContextAddArc(context, x, y , whiteCircleR, radians(startdegrees),radians(startdegrees + 360), 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
