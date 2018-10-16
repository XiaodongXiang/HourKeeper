//
//  PasscodeViewController.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-4.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasscodeViewController_iPhone3 : UIViewController <UITextFieldDelegate>
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
@property (nonatomic,strong) NSString *naiv_tittle;

-(void)back;
-(void)showImageV:(NSInteger)stly;

@end
