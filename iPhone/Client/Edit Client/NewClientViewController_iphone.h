//
//  NewClientViewController_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Clients.h"

#import "TimeViewController_iPhone.h"
#import "ClientRateController.h"



///**
//    编辑Client页面
// */
//@protocol getNewClientDelegate <NSObject>
//
//-(void)saveNewClient:(Clients *)sel_client;
//
//@end



@interface NewClientViewController_iphone : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,getTimeRoundDelegate,ABPeoplePickerNavigationControllerDelegate,getClientRateDelegate>
{
}
//input
@property (nonatomic,strong) Clients                    *myclient;
//@property (nonatomic,strong) id<getNewClientDelegate> delegate;
@property (nonatomic,strong) NSString                   *navi_tittle;

@property (nonatomic,strong) IBOutlet UITableView       *myTableView;

@property (nonatomic,strong) IBOutlet UITableViewCell   *clientCell;
@property (nonatomic,strong) IBOutlet UITextField       *clientField;
@property (nonatomic,strong) IBOutlet UIButton          *addBtn;

@property (nonatomic,strong) IBOutlet UITableViewCell   *rateCell;
@property (nonatomic,strong) IBOutlet UILabel           *rateL_Lbel;
@property (nonatomic,strong) IBOutlet UILabel           *rateR_Lbel;

@property (nonatomic,strong) IBOutlet UITableViewCell   *timeRoundCell;
@property (nonatomic,strong) IBOutlet UILabel           *timeRoundToLbel;

@property (nonatomic,strong) IBOutlet UITableViewCell   *dailyOverCell;
@property (nonatomic,strong) IBOutlet UILabel           *dailyOvertimeLbel;
@property (nonatomic,strong) IBOutlet UILabel           *dailyOvertimeLbel1;
@property (nonatomic,strong) IBOutlet UILabel           *dailyOvertimeLbel2;

@property (nonatomic,strong) IBOutlet UITableViewCell   *weeklyOverCell;
@property (nonatomic,strong) IBOutlet UILabel           *weeklyOvertimeLbel;
@property (nonatomic,strong) IBOutlet UILabel           *weeklyOvertimeLbel1;
@property (nonatomic,strong) IBOutlet UILabel           *weeklyOvertimeLbel2;

@property (nonatomic,strong) IBOutlet UITableViewCell   *payPeriodCell;
@property (nonatomic,strong) IBOutlet UILabel           *payPeriodStlyLbel;
@property (nonatomic,strong) IBOutlet UILabel           *payPeriodEndLbel;

@property (nonatomic,strong) IBOutlet UITableViewCell   *phoneCell;
@property (nonatomic,strong) IBOutlet UITextField       *phoneField;
@property (nonatomic,strong) IBOutlet UITableViewCell   *addressCell;
@property (nonatomic,strong) IBOutlet UITextField       *addressField;
@property (nonatomic,strong) IBOutlet UITableViewCell   *emailCell;
@property (nonatomic,strong) IBOutlet UITextField       *emailField;
@property (nonatomic,strong) IBOutlet UITableViewCell   *faxCell;
@property (nonatomic,strong) IBOutlet UITextField       *faxField;
@property (nonatomic,strong) IBOutlet UITableViewCell   *websiteCell;
@property (nonatomic,strong) IBOutlet UITextField       *websiteField;


@property (nonatomic,strong) NSString                   *dayOverFirstTax;
@property (nonatomic,strong) NSString                   *dayOverFirstHour;
@property (nonatomic,strong) NSString                   *dayOverSecondTax;
@property (nonatomic,strong) NSString                   *dayOverSecondHour;

@property (nonatomic,strong) NSString                   *weekOverFirstTax;
@property (nonatomic,strong) NSString                   *weekOverFirstHour;
@property (nonatomic,strong) NSString                   *weekOverSecondTax;
@property (nonatomic,strong) NSString                   *weekOverSecondHour;

//???
@property (nonatomic,assign) int                        payPeriodStly;
@property (nonatomic,assign) int                        payPeriodNum1;
@property (nonatomic,assign) int                        payPeriodNum2;
@property (nonatomic,strong) NSDate                     *payPeriodDate;


@property (nonatomic,strong) IBOutlet UIButton          *showMoreOrLessBtn;
@property (nonatomic,assign) BOOL                       isMore;

@property(nonatomic,strong) NSString                    *regularStr;
@property(nonatomic,assign) BOOL                        isDaily;
@property(nonatomic,strong) NSString                    *monStr;
@property(nonatomic,strong) NSString                    *tueStr;
@property(nonatomic,strong) NSString                    *wedStr;
@property(nonatomic,strong) NSString                    *thuStr;
@property(nonatomic,strong) NSString                    *friStr;
@property(nonatomic,strong) NSString                    *satStr;
@property(nonatomic,strong) NSString                    *sunStr;
@property(nonatomic,strong) NSString                    *weekStr;


@property (nonatomic,strong) IBOutlet UILabel           *addressLabel1;
@property (nonatomic,strong) IBOutlet UILabel           *phoneLabel1;
@property (nonatomic,strong) IBOutlet UILabel           *emailLabel1;
@property (nonatomic,strong) IBOutlet UILabel           *faxLabel1;
@property (nonatomic,strong) IBOutlet UILabel           *websiteLabel1;
@property (nonatomic,strong) IBOutlet UIImageView       *regularRateArrowImageView1;
@property (nonatomic,strong) IBOutlet UILabel           *timeRoundLabel1;
@property (nonatomic,strong) IBOutlet UIImageView       *timeRoundArrowImageView1;
@property (nonatomic,strong) IBOutlet UILabel           *dailyoverLabel1;
@property (nonatomic,strong) IBOutlet UIImageView       *dailyoverArrowImageView1;
@property (nonatomic,strong) IBOutlet UILabel           *payperiodLabel1;
@property (nonatomic,strong) IBOutlet UIImageView       *payperiodArrowImageView1;
@property (nonatomic,strong) IBOutlet UILabel           *weeklyovertimeLabel1;
@property (nonatomic,strong) IBOutlet UIImageView       *weeklyouverArrowImageView1;

-(IBAction)isShowMoreOrLess;
-(void)saveBack;
-(void)back;

-(IBAction)AddressBtn;
-(void)savePayStly:(int)stly EndFlag1:(int)flag1 endFlag2:(int)flag2 endDate:(NSDate *)payDate;
-(void)peoplePickerController: (ABPeoplePickerNavigationController *)peoplePicker Person:(ABRecordRef)person;

@end
