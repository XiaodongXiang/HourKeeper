//
//  XDDashBoardTableViewCell.m
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/1.
//

#import "XDDashBoardTableViewCell.h"
#import "Clients.h"
#import "AppDelegate_Shared.h"
#import "StartTimeViewController_iPhone.h"
@interface XDDashBoardTableViewCell()
//时间背景
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
// : 背景
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *perHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *recurringLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringLabel2;
@property (weak, nonatomic) IBOutlet UIButton *clockOutAtBtn;
@property (weak, nonatomic) IBOutlet UIButton *ClockOutNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *UndoClockInBtn;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *allAmountLbl;

@property (weak, nonatomic) IBOutlet UILabel *hourLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet UILabel *minuteLbl;

@property(nonatomic, strong)NSTimer * timer;
@end

@implementation XDDashBoardTableViewCell

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
}

-(void)refreshTime{
    if (!_clients) {
        return;
    }
    float totalSeconds = 0;
    NSString *totalTimeString = @"";
    NSDate *nowTime = [NSDate date];

    if ([_clients.beginTime compare:nowTime] == NSOrderedDescending) {
        totalTimeString = [self conevrtTime5:0];
    }else{
        NSTimeInterval timeInterval = [nowTime timeIntervalSinceDate:_clients.beginTime];
        int allSeconds = (int)timeInterval;
        int breakTime = 0;
        if (_clients.lunchStart != nil)
        {
            NSTimeInterval tmpBreak = [nowTime timeIntervalSinceDate:_clients.lunchStart];
            breakTime = tmpBreak>0?tmpBreak:0;
        }
        if ([_clients.lunchTime intValue]>0)
        {
            breakTime += [_clients.lunchTime intValue];
        }
        totalSeconds = (allSeconds - breakTime)>0?(allSeconds - breakTime):0;
        
        totalTimeString = [self conevrtTime5:totalSeconds];
    }
    
    
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    //计算总工作时间正常时间下的报酬
    NSArray *backArray = [appDelegate getRoundWorkAndMoney_ByClient:_clients rate:[appDelegate getRateByClient:_clients date:_clients.beginTime] totalTime:nil totalTimeInt:totalSeconds];
    NSString *money = [backArray objectAtIndex:0];
    //    double money1 = [[appDelegate appMoneyShowStly:money]doubleValue];
    
    NSArray *overAllMoneyArray = [appDelegate overTimeMoney_Clients:_clients totalTime:totalSeconds rate:[appDelegate getRateByClient:_clients date:_clients.beginTime]];
    NSString *overMoney = [overAllMoneyArray objectAtIndex:0];
    
    double allMoney = [money doubleValue]+[overMoney doubleValue];

    self.allAmountLbl.text = [NSString stringWithFormat:@"%.2f",allMoney];
    
    
    //多长时间以后算加班
    double overTime = 0;
    double dayTax1 = [appDelegate getMultipleNumber:_clients.dailyOverFirstHour];
    double dayTax2 = [appDelegate getMultipleNumber:_clients.dailyOverFirstHour];
    if (dayTax1<=0 && dayTax2<=0)
    {
        overTime = 0;
    }
    else if (dayTax1>0 && dayTax2>0)
    {
        overTime = dayTax1<dayTax2?dayTax1:dayTax2;
    }
    else
    {
        overTime = dayTax1>dayTax2?dayTax1:dayTax2;
    }
    NSMutableAttributedString *totalTimeAttr = [[NSMutableAttributedString alloc]initWithString:totalTimeString];
    UIFont *hourFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:16];
    UIFont *secsFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:10];
    NSRange hourRange = NSMakeRange(0, [totalTimeString length]-3);
    NSRange secsRange = NSMakeRange([totalTimeString length]-3, 3);
    [totalTimeAttr addAttribute:NSFontAttributeName value:hourFont range:hourRange];
    [totalTimeAttr addAttribute:NSFontAttributeName value:secsFont range:secsRange];
    float totalTime = overTime*3600;
    float currentTime = totalSeconds;
    
    if (totalTime<=0)
    {
        self.img1.image = self.img2.image = self.img3.image = [UIImage imageNamed:@"Group 7"];
        self.img4.image = self.img5.image = [UIImage imageNamed:@"："];
    }
    else
    {
        if (totalTime>=currentTime)
        {
            self.img1.image = self.img2.image = self.img3.image = [UIImage imageNamed:@"Group 7"];
            self.img4.image = self.img5.image = [UIImage imageNamed:@"："];        }
        else
        {
            self.img1.image = self.img2.image = self.img3.image = [UIImage imageNamed:@"Group 7overTime"];
            self.img4.image = self.img5.image = [UIImage imageNamed:@"：overtime"];        }
    }
    
    NSInteger hour = totalSeconds / 3600;
    NSInteger minute = (totalSeconds - hour * 3600) / 60;
    NSInteger second = (int)totalSeconds % 60;
    
    self.hourLbl.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ld",(long)hour] attributes:@{NSKernAttributeName:@(0.5f)}];
    self.minuteLbl.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ld",(long)minute] attributes:@{NSKernAttributeName:@(0.5f)}];
    self.secondLbl.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%02ld",(long)second] attributes:@{NSKernAttributeName:@(0.5f)}];
    

}

-(NSString*)timeStrWithDate:(NSDate*)date{
    NSDateFormatter* dateF = [[NSDateFormatter alloc]init];
//    [dateF setDateFormat:@"HH:MM mm/d"];
    [dateF setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateF stringFromDate:date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self startTimer];

    self.clockOutAtBtn.layer.cornerRadius = 2;
    self.clockOutAtBtn.layer.masksToBounds = YES;
    self.clockOutAtBtn.layer.borderColor = RGBColor(255, 107, 85).CGColor;
    self.clockOutAtBtn.layer.borderWidth = 1.5;
    
    self.UndoClockInBtn.layer.cornerRadius = 2;
    self.UndoClockInBtn.layer.masksToBounds = YES;
    self.UndoClockInBtn.layer.borderColor = RGBColor(255, 107, 85).CGColor;
    self.UndoClockInBtn.layer.borderWidth = 1.5;
    
    self.viewDetailBtn.layer.cornerRadius = 2;
    self.viewDetailBtn.layer.masksToBounds = YES;
    self.viewDetailBtn.layer.borderColor = RGBColor(67, 113, 255).CGColor;
    self.viewDetailBtn.layer.borderWidth = 1.5;
    
    self.ClockOutNowBtn.layer.cornerRadius = 2;
    self.ClockOutNowBtn.layer.masksToBounds = YES;
}

-(void)setClients:(Clients *)clients{

    _clients = clients;
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];

    self.nameLabel.text = _clients.clientName;
    NSString *showMoney = [appDelegate appMoneyShowStly2:[appDelegate getRateByClient:_clients date:_clients.beginTime]];
    self.perHourLabel.text = [NSString stringWithFormat:@"%@/h",showMoney];
    self.timeLabel.text = [NSString stringWithFormat:@"Started %@",[self timeStrWithDate:_clients.beginTime]];
    [self refreshTime];
}

-(void)setOpen:(BOOL)open{
    _open = open;
    
    if (_open) {
        self.backgroundColor = RGBColor(248, 248, 248);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (IBAction)clockOutNowClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnClientOperate:client:cell:)]) {
        [self.xxDelegate returnClientOperate:ClockOutNow client:_clients cell:self];
    }
}
- (IBAction)undoClockInClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnClientOperate:client:cell:)]) {
        [self.xxDelegate returnClientOperate:UndoClockIn client:_clients cell:self];
    }
}
- (IBAction)viewDetailClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnClientOperate:client:cell:)]) {
        [self.xxDelegate returnClientOperate:ViewClientDetail client:_clients cell:self];
    }
}
- (IBAction)clockOutAtClick:(id)sender {
    if ([self.xxDelegate respondsToSelector:@selector(returnClientOperate:client:cell:)]) {
        [self.xxDelegate returnClientOperate:ClockOutAt client:_clients cell:self];
    }
}


-(NSString *)conevrtTime5:(int)totalSeconds
{
    int seconds = totalSeconds%60;
    int minutes = (totalSeconds/60)%60;
    int hours = totalSeconds/3600;
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    
    return time;
}


@end
