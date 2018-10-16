//
//  PasscodeViewController_iPd2.h
//  HoursKeeper
//
//  Created by xy_dev on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeViewController_iPd2 : UIViewController<UITextFieldDelegate>
{
}

@property (nonatomic,strong) IBOutlet UIImageView *imageV1;
@property (nonatomic,strong) IBOutlet UIImageView *imageV2;
@property (nonatomic,strong) IBOutlet UIImageView *imageV3;
@property (nonatomic,strong) IBOutlet UIImageView *imageV4;

@property (nonatomic,strong) NSString *firstPass;
@property (nonatomic,strong) NSString *myPass;
@property (nonatomic,strong) IBOutlet UITextField *ownField;
@property (nonatomic,strong) IBOutlet UILabel *tryLabel;

-(void)showImageV:(NSInteger)stly;


@end
