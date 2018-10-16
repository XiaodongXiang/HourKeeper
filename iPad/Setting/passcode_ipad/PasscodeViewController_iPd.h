//
//  PasscodeViewController_iPd.h
//  HoursKeeper
//
//  Created by xy_dev on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasscodeViewController_iPd : UIViewController <UITextFieldDelegate>
{
}

@property (nonatomic,strong) IBOutlet UITextField *ownField;
@property (nonatomic,strong) IBOutlet UILabel *tryLabel;
@property (nonatomic,strong) NSString *pass;

@property (nonatomic,strong) IBOutlet UIImageView *imageV1;
@property (nonatomic,strong) IBOutlet UIImageView *imageV2;
@property (nonatomic,strong) IBOutlet UIImageView *imageV3;
@property (nonatomic,strong) IBOutlet UIImageView *imageV4;


-(void)showImageV:(NSInteger)stly;


@end

