//
//  UINavigationBar+CustomImage.m
//  PatientCom
//
//  Created by Shan Junqing on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)



-(void)drawNavigationBarForOS5
{
	if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
	{
        [self setBackgroundImage:[[UIImage imageNamed:@"nav_10.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarMetrics:UIBarMetricsDefault];
	}
}
- (void)drawRect:(CGRect)rect
{
	UIImage *image = [[UIImage imageNamed:@"nav_10.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}



@end
