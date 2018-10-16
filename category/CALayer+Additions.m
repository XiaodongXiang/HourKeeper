//
//  CALayer+Additions.m
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/6.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
