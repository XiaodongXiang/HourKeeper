//
//  HMJMainViewController.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/17.
//
//

#import "HMJMainViewController.h"
#import "HMJLeftMenu.h"
#import "AppDelegate_Shared.h"
#import "AppDelegate_iPhone.h"
#import "FileController.h"
#import "UIBarButtonItem+Extension.h"
#import "ProfileDetailViewController_iPhone.h"

#import "Profile.h"

#define HMNavShowAnimDuration 0.25


@interface HMJMainViewController ()

{
    UIButton *cover;
}
@end


@implementation HMJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dashBoardVC = [[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
    [self setupVC:_dashBoardVC];
    
    _clientsVC = [[TimersViewController_iphone alloc]init];
    [self setupVC:_clientsVC];
    
    _payPeriodVC = [[TimeSheetViewController alloc]init];
    [self setupVC:_payPeriodVC];
    
    _invoiceVC = [[InvoiceNewViewController alloc]init];
    [self setupVC:_invoiceVC];
    
    _reportVC = [[ChartViewController_new alloc]init];
    [self setupVC:_reportVC];
    
    _settingVC = [[SettingsViewController_New alloc]init];
    [self setupVC:_settingVC];
    
    
    _leftMenu = [[HMJLeftMenu alloc]initWithFrame:CGRectMake(-SCREEN_WITH*0.2, 0, SCREEN_WITH*0.78, SCREEN_HEIGHT)];
    [_leftMenu.headIconBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    _leftMenu.delegate = self;
    [self.view insertSubview:_leftMenu atIndex:0];
    
//    [_leftMenu.syncBtn addTarget:self action:@selector(syncBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}



-(void)setupVC:(UIViewController *)vc
{
//    vc.view.backgroundColor = HMRandomColor;

    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [leftButton setImage:[UIImage imageNamed:@"navigation"] forState:UIControlStateNormal];
//    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [leftButton addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.backgroundColor = [UIColor blackColor];
    
//    appDelegate.naviBarWitd = -16;
    [appDelegate setNaviGationItem:vc isLeft:YES button:leftButton];

    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
//    navi.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addChildViewController:navi];
}

#pragma mark Action
- (void)leftMenuPressed:(id)sender
{

    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        _leftMenu.x = 0;
    }];
    
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    Profile *localProfile;
    
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_PROFILE];
    NSArray *objects = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0)
    {
        localProfile = [appDelegate_iPhone.parseSync getLocalOnly_Data:objects tableName:PF_TABLE_PROFILE];
//        localProfile = [objects lastObject];
    }
//    if (appDelegate_iPhone.appUser)
//    {
        if (localProfile != nil && [localProfile.firstName length]>0)
        {
            _leftMenu.nameLabel.text = localProfile.firstName;
        }
        else
            _leftMenu.nameLabel.text = appDelegate_iPhone.appUser.username;

        
        //head image new
        if (localProfile.headImage != nil)
        {
            [_leftMenu.headIconBtn setImage:localProfile.headImage forState:UIControlStateNormal];
        }
        else
        {
            [_leftMenu.headIconBtn setImage:[UIImage imageNamed:@"defaulthead_portrait"] forState:UIControlStateNormal];

        }
        
//    }

    

    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        // 取出正在显示的导航控制器的view
        UIView *showingView = self.showingNavigationController.view;
        
        CGAffineTransform translateForm = CGAffineTransformMakeTranslation(_leftMenu.width, 0);
        
        showingView.transform = translateForm;
        
        // 添加一个遮盖
        cover = [[UIButton alloc] init];
        cover.tag = 101;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = showingView.bounds;
        [showingView addSubview:cover];
    }];
    
    [_leftMenu setLeftMenuDashboardandInvoiceRightImageView];
}

- (void)coverClick:(UIButton *)cover
{
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        self.showingNavigationController.view.transform = CGAffineTransformIdentity;
        _leftMenu.x = -SCREEN_WITH*0.2;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

//弹出profile页面
-(void)headBtnPressed:(UIButton *)sender
{
    [self coverClick:nil];
    [[self.showingNavigationController.view viewWithTag:101] removeFromSuperview];
    ProfileDetailViewController_iPhone *profileVC = [[ProfileDetailViewController_iPhone alloc]initWithNibName:@"ProfileDetailViewController_iPhone" bundle:nil];
    [self.showingNavigationController pushViewController:profileVC animated:YES];
}

#pragma mark - HMLeftMenuDelegate
- (void)leftMenu:(HMJLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{

    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        _leftMenu.x = - SCREEN_WITH*0.2;
    }];
    [cover removeFromSuperview];

//    if (fromIndex <= 1 || toIndex <= 1) {
//        return;
//    }
    // 0.移除旧控制器的view
    UINavigationController *oldNav = self.childViewControllers[fromIndex-1];
    [oldNav.view removeFromSuperview];
    
    // 1.显示新控制器的view
    UINavigationController *newNav = self.childViewControllers[toIndex-1];
    // 设置新控制的transform跟旧控制器一样
    newNav.view.transform = oldNav.view.transform;
    // 设置阴影
    newNav.view.layer.shadowColor = [UIColor blackColor].CGColor;
    newNav.view.layer.shadowOffset = CGSizeMake(-3, 0);
    newNav.view.layer.shadowOpacity = 0.2;
    [self.view addSubview:newNav.view];
    
    // 2.设置当前正在显示的控制器
    self.showingNavigationController = newNav;
    
    // 3.清空transform
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        newNav.view.transform = CGAffineTransformIdentity;
    }];
    
}

@end
