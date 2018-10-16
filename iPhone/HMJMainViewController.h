//
//  HMJMainViewController.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/17.
//
//

#import <UIKit/UIKit.h>
#import "HMJLeftMenu.h"

#import "DashBoardViewController.h"
#import "TimersViewController_iphone.h"
#import "TimeSheetViewController.h"
#import "InvoiceNewViewController.h"
#import "ChartViewController_new.h"
#import "SettingsViewController_New.h"



@interface HMJMainViewController : UIViewController<HMJLeftMenuDelegate>

@property (nonatomic, weak) UINavigationController *showingNavigationController;
@property(nonatomic,strong)DashBoardViewController *dashBoardVC;
@property(nonatomic,strong)TimersViewController_iphone  *clientsVC;
@property(nonatomic,strong)TimeSheetViewController      *payPeriodVC;
@property(nonatomic,strong)InvoiceNewViewController     *invoiceVC;
@property(nonatomic,strong)ChartViewController_new      *reportVC;
@property(nonatomic,strong)SettingsViewController_New   *settingVC;

@property(nonatomic,strong)HMJLeftMenu *leftMenu;

@end
