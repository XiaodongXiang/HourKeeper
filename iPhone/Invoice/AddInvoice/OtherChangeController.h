//
//  OtherChangeController.h
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-22.
//
//

#import <UIKit/UIKit.h>
#import "HMJInviocePropertyObject.h"

@class EditInvoiceNewViewController;
@class EditInvoiceNewViewController_ipad;

@interface OtherChangeController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
}
//input
@property(nonatomic,strong) HMJInviocePropertyObject *myInvoiceProperty;

@property(nonatomic,strong) IBOutlet UITableView *myTableView;

@property(nonatomic,strong) IBOutlet UITableViewCell *nameCell;
@property(nonatomic,strong) IBOutlet UITextField *nameField;

@property(nonatomic,strong) IBOutlet UITableViewCell *quantityCell;
@property(nonatomic,strong) IBOutlet UITextField *quantityField;

@property(nonatomic,strong) IBOutlet UITableViewCell *priceCell;
@property(nonatomic,strong) IBOutlet UITextField *priceField;
@property(nonatomic,strong) NSString *priceStr;

@property(nonatomic,strong) IBOutlet UITableViewCell *taxCell;
@property(nonatomic,strong) IBOutlet UISwitch *taxSwitch;

@property(nonatomic,strong) IBOutlet UITableViewCell *deleteCell;

@property (weak, nonatomic) IBOutlet UILabel *namelabel1;
@property (weak, nonatomic) IBOutlet UILabel *qualitylabel1;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel1;
@property (weak, nonatomic) IBOutlet UILabel *taxlabel1;

@property(nonatomic,strong)EditInvoiceNewViewController *editInvocieVC;
@property(nonatomic,strong)EditInvoiceNewViewController_ipad *editInvoiceVC_iPad;
-(void)initData;
-(void)save;
-(void)back;


@end
