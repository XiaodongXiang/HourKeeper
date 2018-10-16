//
//  SetProfile.h
//  HoursKeeper
//
//  Created by xy_dev on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetProfile : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
}

@property(nonatomic,strong)UIPopoverController *popoverController;

@property (nonatomic,strong)IBOutlet UIButton *imageButton;
@property (nonatomic,strong)IBOutlet UITextField *nameField;
@property (nonatomic,strong)IBOutlet UITextField *companyField;
@property (nonatomic,strong)IBOutlet UITextField *phoneField;
@property (nonatomic,strong)IBOutlet UITextField *faxField;
@property (nonatomic,strong)IBOutlet UITextField *emailField;
@property (nonatomic,strong)IBOutlet UITextField *streetField;
@property (nonatomic,strong)IBOutlet UITextField *cityField;
@property (nonatomic,strong)IBOutlet UITextField *stateField;
@property (nonatomic,strong)IBOutlet UITextField *zipField;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;



-(IBAction)clickImage_presentActionSheet:(id)sender;
-(void)cancel_Btn;
-(void)saveandback_Btn;

@end

