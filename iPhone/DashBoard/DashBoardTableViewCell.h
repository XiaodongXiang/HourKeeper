//
//  DashBoardTableViewCell.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import <UIKit/UIKit.h>
#import "HMJLabel.h"
#import "DashBoardExternalView.h"
#import "DashBoardViewController.h"

@interface DashBoardTableViewCell : UITableViewCell


@property(nonatomic,strong)UIView *contentContainView;
@property (nonatomic,strong)UIView *leftContainView;
@property (nonatomic,strong)DashBoardExternalView  *externalView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)HMJLabel    *amountView;
@property (nonatomic,strong)UILabel     *nameLabel;
@property (nonatomic,strong)UILabel     *perHourLabel;
@property(nonatomic,strong)UIButton *deleteBtn;


@property(nonatomic,strong)DashBoardViewController  *dashboardViewController;
@property(nonatomic,strong)NSIndexPath  *cellIndexPath;

-(void)layoutShowDeleteBtn:(BOOL)showTwoBtns;
@end
