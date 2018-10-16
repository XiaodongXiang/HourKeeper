//
//  CustomNavigationViewController.m
//  HoursKeeper
//
//  Created by humingjing on 15/7/28.
//
//

#import "CustomNavigationViewController.h"
#import "AppDelegate_iPad.h"

@implementation CustomNavigationViewController

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AppDelegate_iPad * appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.passViewController != nil)
    {
        [appDelegate.passViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    if(appDelegate.rateControl != nil)
    {
        [appDelegate.rateControl willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
