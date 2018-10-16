//
//  LogInViewController_iPad.h
//  HoursKeeper
//
//  Created by humingjing on 15/7/28.
//
//

#import <UIKit/UIKit.h>
#import "DRDynamicSlideShow_ipad.h"
#import "HMJCustomAnimationButton.h"


@interface LogInViewController_iPad : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
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

@property (weak, nonatomic) IBOutlet UIButton       *bgButton;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *topBgLine;
@property (weak, nonatomic) IBOutlet UIView *bottomBgLine;
@property (weak, nonatomic) IBOutlet UIView *leftBgLine;
@property (weak, nonatomic) IBOutlet UIView *rightBgLine;
@property (weak, nonatomic) IBOutlet UIView *middleBgLine;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextFiled;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet    UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic,strong)NSString *loadStyle;


@property (strong, nonatomic) HMJCustomAnimationButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIView   *signUpView;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property(nonatomic,strong)id <PFLogInViewControllerDelegate> delegate;


//信息介绍页面
@property (strong, nonatomic) DRDynamicSlideShow_ipad * slideShow;
@property (strong, nonatomic) NSArray * viewsForPages;
-(IBAction)touchViewBg;
@end
