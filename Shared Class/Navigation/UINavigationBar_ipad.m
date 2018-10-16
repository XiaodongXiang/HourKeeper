//
//  UINavigationBar_ipad.m
//  HoursKeeper
//
//  Created by xy_dev on 5/23/13.
//
//

#import "UINavigationBar_ipad.h"

@implementation UINavigationBar (CustomImage)

-(void)drawNavigationBarFor_ipad
{
	if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
	{
        [self setBackgroundImage:[[UIImage imageNamed:@"nav_10.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarMetrics:UIBarMetricsDefault];
	}
}
- (void)drawRect:(CGRect)rect
{
	UIImage *image;
    
    image = [[UIImage imageNamed:@"nav_10.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end