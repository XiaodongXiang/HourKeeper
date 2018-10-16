//
//  HMJLeftMenu.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/17.
//
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"

@class HMJLeftMenu;
@protocol HMJLeftMenuDelegate <NSObject>

@optional
- (void)leftMenu:(HMJLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex;

@end


@class HMJLeftMenuButton;
@interface HMJLeftMenu : UIView

@property(nonatomic,weak)id <HMJLeftMenuDelegate> delegate;

@property(nonatomic,strong)UIButton         *headIconBtn;
@property(nonatomic,strong)UILabel          *nameLabel;
@property(nonatomic,strong)UILabel          *overtimeLabel;
@property(nonatomic,strong)UILabel          *totalLabel;
@property(nonatomic,strong)HMJLabel          *earendAmountLabel;
@property(nonatomic,strong)UIButton         *syncBtn;
@property(nonatomic,strong)UIButton      *syncBtn2;
@property(nonatomic,strong)UIButton         *loginBtn;

@property(nonatomic,weak)HMJLeftMenuButton  *selectedBtn;
@property(nonatomic,strong)HMJLeftMenuButton *dashBoardBtn;
@property(nonatomic,strong)HMJLeftMenuButton    *clientsBtn;
@property(nonatomic,strong)HMJLeftMenuButton *invoiceBtn;

-(void)setLeftMenuDashboardandInvoiceRightImageView;
-(void)syncAnimationBegain;
-(void)syncAnimationEnd;
-(void)btnClick:(HMJLeftMenuButton *)sender;
@end
