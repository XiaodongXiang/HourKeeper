//
//  ClientRateController.h
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-26.
//
//

#import <UIKit/UIKit.h>

@protocol getClientRateDelegate <NSObject>

-(void)saveClientRate:(BOOL)_isDaily regular:(NSString *)_regularStr mon:(NSString *)_monStr tue:(NSString *)_tueStr wed:(NSString *)_wedStr thu:(NSString *)_thuStr fri:(NSString *)_friStr sat:(NSString *)_satStr sun:(NSString *)_sunStr week:(NSString *)_weekStr;

@end



@interface ClientRateController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
}
//input
@property(nonatomic,strong) id<getClientRateDelegate>   delegate;
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

@property(nonatomic,strong) IBOutlet UITableView        *myTableView;

@property(nonatomic,strong) IBOutlet UITableViewCell    *regularCell;
@property(nonatomic,strong) IBOutlet UITextField        *regularField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *dailyCell;
@property(nonatomic,strong) IBOutlet UISwitch           *dailySwitch;

@property(nonatomic,strong) IBOutlet UITableViewCell    *monCell;
@property(nonatomic,strong) IBOutlet UITextField        *monField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *tueCell;
@property(nonatomic,strong) IBOutlet UITextField        *tueField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *wedCell;
@property(nonatomic,strong) IBOutlet UITextField        *wedField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *thuCell;
@property(nonatomic,strong) IBOutlet UITextField        *thuField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *friCell;
@property(nonatomic,strong) IBOutlet UITextField        *friField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *satCell;
@property(nonatomic,strong) IBOutlet UITextField        *satField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *sunCell;
@property(nonatomic,strong) IBOutlet UITextField        *sunField;

@property(nonatomic,strong) IBOutlet UITableViewCell    *weeklyCell;
@property(nonatomic,strong) IBOutlet UITextField        *weeklyField;
@property(nonatomic,strong) IBOutlet UIView             *weekHeadView;

@property(nonatomic,strong) IBOutlet UILabel            *regularRateLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *dailyRateLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *mondayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *tuesdayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *wednesdayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *thursdayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *fridayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *saturdayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *sundayLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *weekLabel1;
@property(nonatomic,strong) IBOutlet UILabel            *headTextLabel1;

-(IBAction)doSwitch:(UISwitch *)sender;
-(void)initData;
-(void)back;


@end


