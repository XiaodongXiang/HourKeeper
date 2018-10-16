//
//  XDOffClockTableViewCell.m
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/6.
//

#import "XDOffClockTableViewCell.h"
#import "Clients.h"
#import "AppDelegate_Shared.h"
@interface XDOffClockTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *perHourLbl;
@property (weak, nonatomic) IBOutlet UIButton *clockInAtBtn;
@property (weak, nonatomic) IBOutlet UIButton *clockInNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailBtn;

@end

@implementation XDOffClockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setClients:(Clients *)clients{
    _clients = clients;
    

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    self.nameLbl.text = _clients.clientName;
    NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:_clients date:_clients.beginTime]];
    self.perHourLbl.text = [NSString stringWithFormat:@"%@/h",showMoney];
    
}

-(void)setOpen:(BOOL)open{
    _open = open;
    
    if (_open) {
        self.backgroundColor = RGBColor(248, 248, 248);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)viewDetailClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnOffClockClient:cell:operate:)]) {
        [self.xxDelegate returnOffClockClient:_clients cell:self operate:ViewClientDetail];
    }
}
- (IBAction)clockInNowClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnOffClockClient:cell:operate:)]) {
        [self.xxDelegate returnOffClockClient:_clients cell:self operate:ClockInNow];
    }
}
- (IBAction)clockInAtClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnOffClockClient:cell:operate:)]) {
        [self.xxDelegate returnOffClockClient:_clients cell:self operate:ClockInAt];
    }
}

@end
