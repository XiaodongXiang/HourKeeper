//
//  ProfileDetailViewController_iPad.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/7.
//
//

#import <UIKit/UIKit.h>
#import "HMJCustomAnimationButton.h"

@class LogInViewController_iPad;
@interface ProfileDetailViewController_iPad : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    
}

@property(nonatomic,weak)IBOutlet   UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollVIew;

@property(weak,nonatomic)IBOutlet UIView       *contentView;

@property (strong, nonatomic) IBOutlet UIButton     *headIconBtn;
@property (weak, nonatomic) IBOutlet UITextField    *firstNameFiled;
@property (weak, nonatomic) IBOutlet UITextField    *lastNameFiled;
@property (strong, nonatomic) IBOutlet UIButton     *femaleBtn;
@property (strong, nonatomic) IBOutlet UIButton     *manBtn;
@property (strong, nonatomic) IBOutlet UITextField  *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField  *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField  *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField    *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField    *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField    *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField  *faxTextField;

@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (nonatomic, strong)UITextField *currentTextField;

@property (strong, nonatomic) HMJCustomAnimationButton     *doneBtn;

@property (strong, nonatomic) LogInViewController_iPad *logInViewController;
@property (assign, nonatomic)int                            ifRemovePhoto;
@property(nonatomic,assign)BOOL isSetupProfile;
@property(nonatomic,retain)UIPopoverController *popoverController;


@end
