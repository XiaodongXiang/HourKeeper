//
//  LogInViewController.h
//  HoursKeeper
//
//  Created by humingjing on 15/5/25.
//
//

#import <UIKit/UIKit.h>
#import "DRDynamicSlideShow.h"
#import "HMJCustomAnimationButton.h"


@interface LogInViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
//    UIView  *pageView1;
//    UIView  *pageView2;
//    UIView  *pageView3;
//    
//    UIImageView *page1iconImage;
//    UIImageView *page1titleImage;
//    
//    UIImageView *page2ImageView1;
//    UIImageView *page2ImageView2;
//    UIImageView *page2ImageView3;
//    
//    
//    UIImageView *page3ImageView1;
//    UIImageView *page3ImageView2;
//    UIImageView *page3ImageView3;

    BOOL isKeyboardUp;
    BOOL isNextTextFieldTouch;
}

//@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//@property (weak, nonatomic) IBOutlet UIImageView *iconTitleImage;
@property (weak, nonatomic) IBOutlet UIButton       *bgButton;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *topBgLine;
@property (weak, nonatomic) IBOutlet UIView *bottomBgLine;
@property (weak, nonatomic) IBOutlet UIView *leftBgLine;
@property (weak, nonatomic) IBOutlet UIView *rightBgLine;
@property (weak, nonatomic) IBOutlet UIView *middleBgLine;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextFiled;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;



@property (strong, nonatomic)HMJCustomAnimationButton *signInBtn;
//signIn 控件
//@property (weak, nonatomic) IBOutlet UIView *signInView;
//@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *signInSemicircle;
//@property (weak, nonatomic) IBOutlet UIImageView *signInRotate;
//@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIView   *signUpView;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIView     *signUpLine;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet    UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(nonatomic,strong)id <PFLogInViewControllerDelegate> delegate;
@property(nonatomic,strong)NSString *loadStyle;

//信息介绍页面
@property (strong, nonatomic) DRDynamicSlideShow * slideShow;
@property (strong, nonatomic) NSArray * viewsForPages;
-(IBAction)touchViewBg;
@end
