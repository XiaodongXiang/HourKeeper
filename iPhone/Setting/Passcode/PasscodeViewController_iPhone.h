//
//  PasscodeViewController.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasscodeViewController_iPhone : UIViewController <UITextFieldDelegate>
{
}
@property (nonatomic,strong) UITextField *ownField;
@property (nonatomic,strong) UILabel *tryLabel;

@property (nonatomic,strong) NSString *navi_tittle;

@property (nonatomic,strong) IBOutlet UIImageView *imageV1;
@property (nonatomic,strong) IBOutlet UIImageView *imageV2;
@property (nonatomic,strong) IBOutlet UIImageView *imageV3;
@property (nonatomic,strong) IBOutlet UIImageView *imageV4;

-(void)back;

-(void)showImageV:(NSInteger)stly;


@end
