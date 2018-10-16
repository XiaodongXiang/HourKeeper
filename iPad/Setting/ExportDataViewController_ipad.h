//
//  ExportDataViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 5/16/13.
//
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>
#import "Clients.h"
#import "ExportSelectClient_ipad.h"




@interface ExportDataViewController_ipad : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,getExportClientDelegate_ipad>
{
    UIButton *exportButton;
}

@property(nonatomic,strong) IBOutlet UITableView *myTableView;

@property(nonatomic,strong) IBOutlet UITableViewCell *fromDateCell;
@property(nonatomic,strong) IBOutlet UILabel *fromDateLbel;
@property(nonatomic,strong) IBOutlet UITableViewCell *toDateCell;
@property(nonatomic,strong) IBOutlet UILabel *toDateLbel;
@property(nonatomic,strong) IBOutlet UITableViewCell *clientCell;
@property(nonatomic,strong) IBOutlet UILabel *clientLbel;
@property(nonatomic,strong) IBOutlet UIDatePicker *datePicker;

@property(nonatomic,assign) NSInteger dateStly;            //  0: fromDate;  1: toDate;
@property(nonatomic,strong) NSDate *fromDate;
@property(nonatomic,strong) NSDate *toDate;
@property(nonatomic,strong) NSMutableArray *clientArray;
@property(nonatomic,assign) BOOL isAllClient;

@property(nonatomic,strong) NSMutableArray *logsArray;

//option
@property(nonatomic,assign) NSInteger isSetting;            //0:yes;  1:no;
@property(nonatomic,strong) Clients *sel_client;



-(void)exportData;
-(void)back;
-(IBAction)dateChange;


@end
