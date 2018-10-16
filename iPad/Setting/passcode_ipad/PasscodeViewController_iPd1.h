//
//  PasscodeViewController_iPd1.h
//  HoursKeeper
//
//  Created by xy_dev on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasscodeViewController_iPd.h"

@interface PasscodeViewController_iPd1 : UIViewController <UITextFieldDelegate>
{
}

@property (nonatomic,strong) NSString *firstPass;
@property (nonatomic,strong) NSString *myPass;
@property (nonatomic,strong) IBOutlet UITextField *ownField;
@property (nonatomic,strong) PasscodeViewController_iPd *firstviewController;

@property (nonatomic,strong) IBOutlet UIImageView *imageV1;
@property (nonatomic,strong) IBOutlet UIImageView *imageV2;
@property (nonatomic,strong) IBOutlet UIImageView *imageV3;
@property (nonatomic,strong) IBOutlet UIImageView *imageV4;


-(void)showImageV:(NSInteger)stly;


@end
