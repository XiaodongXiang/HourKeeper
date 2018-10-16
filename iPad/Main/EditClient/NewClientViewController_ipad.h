//
//  NewClientViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Clients.h"

#import "TimeViewController_ipad.h"
#import "ClientRateController.h"




@protocol getClientDelegate <NSObject>

-(void)saveClient:(Clients *)_client;

@end





@interface NewClientViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,getTimeRoundDelegate_ipad,ABPeoplePickerNavigationControllerDelegate,getClientRateDelegate>
{
}
//input
@property (nonatomic,strong) Clients *myclient;
@property (nonatomic,strong) NSString *navTittle;
@property (nonatomic,strong) id<getClientDelegate> delegate;

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) IBOutlet UITableViewCell *clientCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *rateCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *timeRoundCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *dailyOverCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *weeklyOverCell;

@property (nonatomic,strong) IBOutlet UITableViewCell *phoneCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *addressCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *emailCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *faxCell;
@property (nonatomic,strong) IBOutlet UITableViewCell *websiteCell;

@property (nonatomic,strong) IBOutlet UITextField *clientField;
@property (nonatomic,strong) IBOutlet UILabel *rateL_Lbel;
@property (nonatomic,strong) IBOutlet UILabel *rateR_Lbel;

@property (nonatomic,strong) IBOutlet UILabel *timeRoundToLbel;
@property (nonatomic,strong) IBOutlet UILabel *dailyOvertimeLbel;
@property (nonatomic,strong) IBOutlet UILabel *dailyOvertimeLbel1;
@property (nonatomic,strong) IBOutlet UILabel *dailyOvertimeLbel2;
@property (nonatomic,strong) NSString *dayOverFirstTax;
@property (nonatomic,strong) NSString *dayOverFirstHour; 
@property (nonatomic,strong) NSString *dayOverSecondTax;
@property (nonatomic,strong) NSString *dayOverSecondHour;
@property (nonatomic,strong) IBOutlet UILabel *weeklyOvertimeLbel;
@property (nonatomic,strong) IBOutlet UILabel *weeklyOvertimeLbel1;
@property (nonatomic,strong) IBOutlet UILabel *weeklyOvertimeLbel2;
@property (nonatomic,strong) NSString *weekOverFirstTax;
@property (nonatomic,strong) NSString *weekOverFirstHour;
@property (nonatomic,strong) NSString *weekOverSecondTax;
@property (nonatomic,strong) NSString *weekOverSecondHour;

@property (nonatomic,strong) IBOutlet UITableViewCell *payPeriodCell;
@property (nonatomic,strong) IBOutlet UILabel *payPeriodStlyLbel;
@property (nonatomic,strong) IBOutlet UILabel *payPeriodEndLbel;
@property (nonatomic,assign) int payPeriodStly;
@property (nonatomic,assign) int payPeriodNum1;
@property (nonatomic,assign) int payPeriodNum2;
@property (nonatomic,strong) NSDate *payPeriodDate;

@property (nonatomic,strong) IBOutlet UITextField *phoneField;
@property (nonatomic,strong) IBOutlet UITextField *addressField;
@property (nonatomic,strong) IBOutlet UITextField *emailField;
@property (nonatomic,strong) IBOutlet UITextField *faxField;
@property (nonatomic,strong) IBOutlet UITextField *websiteField;

@property (nonatomic,strong) IBOutlet UIButton *showMoreOrLessBtn;
@property (nonatomic,assign) BOOL isMore;

@property(nonatomic,strong) NSString *regularStr;
@property(nonatomic,assign) BOOL isDaily;
@property(nonatomic,strong) NSString *monStr;
@property(nonatomic,strong) NSString *tueStr;
@property(nonatomic,strong) NSString *wedStr;
@property(nonatomic,strong) NSString *thuStr;
@property(nonatomic,strong) NSString *friStr;
@property(nonatomic,strong) NSString *satStr;
@property(nonatomic,strong) NSString *sunStr;
@property(nonatomic,strong) NSString *weekStr;





-(IBAction)isShowMoreOrLess;

-(void)saveBack;
-(void)back;
-(IBAction)AddressBtn;

-(void)savePayStly:(int)stly EndFlag1:(int)flag1 endFlag2:(int)flag2 endDate:(NSDate *)payDate;
-(void)peoplePickerController: (ABPeoplePickerNavigationController *)peoplePicker Person:(ABRecordRef)person;


@end
