//
//  HMJLeftMenu.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/17.
//
//

#import "HMJLeftMenu.h"
#import "HMJLeftMenuButton.h"
#import "HMJNomalClass.h"
#import "AppDelegate_Shared.h"
#import "AppDelegate_iPhone.h"
#import "HMJNomalClass.h"
#import "HMJLabel.h"
#import "LogInViewController.h"

@interface HMJLeftMenu()

@end

@implementation HMJLeftMenu

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:37.f/255.f green:40.f/255.f blue:52.f/255.f alpha:1];
   
        ////////////////
//        if (IS_IPHONE_4 || IS_IPHONE_5)
//        {
//            //head bg
//            UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
//            headBgView.backgroundColor = [UIColor blackColor];
//            headBgView.alpha = 0.15;
//            [self addSubview:headBgView];
//
//            UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(0, headBgView.height-SCREEN_SCALE, frame.size.width, SCREEN_SCALE)];
//            headLine.backgroundColor = [UIColor whiteColor];
//            headLine.alpha = 0.1;
//            [self addSubview:headLine];
//
//            //head btn
//            CGRect headFrame = CGRectMake(15, 33, 55, 55);
//            _headIconBtn = [[UIButton alloc]initWithFrame:headFrame];
//            _headIconBtn.layer.borderWidth = 1 + (1-SCREEN_SCALE);
//            _headIconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//            _headIconBtn.layer.cornerRadius = headFrame.size.width/2;
//            _headIconBtn.layer.masksToBounds = YES;
//            [self addSubview:_headIconBtn];
//
//            float nameLabelLeft = 80;
//            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, 31, self.width-nameLabelLeft-15, 30)];
//            _nameLabel.textAlignment = 30;
//            _nameLabel.textColor = [UIColor whiteColor];
//            _nameLabel.backgroundColor = [UIColor clearColor];
//            UIFont *nameFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:18];
//            _nameLabel.font = nameFont;
//            [self addSubview:_nameLabel];
//
//            //提示文字
//            float overtimeLabelW = (self.width-nameLabelLeft-15)/3;
//            float overtimeLabel1Y = 63;
//            float overtimeLabel1H = 8;
//            float secondLabelL = 127;
//            float thirdLabelL = 167;
//            float firstLabelWith = 35;
//            UIFont *overtimeLabel1Font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:7];
//            UILabel *overTimeLabel1= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            overTimeLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            overTimeLabel1.backgroundColor = [UIColor clearColor];
//            overTimeLabel1.text = @"OVERTIME";
//            [self addSubview:overTimeLabel1];
//
//            UILabel *totalLabel1= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelL, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            totalLabel1.backgroundColor = [UIColor clearColor];
//            totalLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            totalLabel1.text = @"TOTAL";
//            [self addSubview:totalLabel1];
//
//            UILabel *earendLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(thirdLabelL, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            earendLabel1.backgroundColor = [UIColor clearColor];
//            earendLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            earendLabel1.text = @"EARNED";
//            [self addSubview:earendLabel1];
//
//
//            overTimeLabel1.font = overtimeLabel1Font;
//            totalLabel1.font = overtimeLabel1Font;
//            earendLabel1.font = overtimeLabel1Font;
//
//            //显示时间金额
//            float overtimeLabelY = 63.5;
//            float overtimeLabelH = 30;
//            UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:12];
//
//            _overtimeLabel= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabelY, overtimeLabelW, overtimeLabelH)];
//            _overtimeLabel.textColor = [UIColor whiteColor];
//            _overtimeLabel.backgroundColor = [UIColor clearColor];
//            _overtimeLabel.text = @"0";
//            [self addSubview:_overtimeLabel];
//
//            _totalLabel= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelL, overtimeLabelY, firstLabelWith, overtimeLabelH)];
//            _totalLabel.backgroundColor = [UIColor clearColor];
//            _totalLabel.textColor = [UIColor whiteColor];
//            _totalLabel.text = @"0";
//            [self addSubview:_totalLabel];
//
//             _earendAmountLabel = [[HMJLabel alloc]initWithFrame:CGRectMake(thirdLabelL, overtimeLabelY, firstLabelWith, overtimeLabelH)];
//
//            _earendAmountLabel.backgroundColor = [UIColor clearColor];
//            [self addSubview:_earendAmountLabel];
//            [_earendAmountLabel creatSubViewsisLeftAlignment:YES];
//
//            _overtimeLabel.font = overFont;
//            _totalLabel.font = overFont;
//
//            //显示分割线
//            float lineY = 64;
//            float lineH = 19;
//            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(120, lineY, SCREEN_SCALE, lineH)];
//            line1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line1.alpha = 0.4;
//            [self addSubview:line1];
//
//            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(160, lineY, SCREEN_SCALE, lineH)];
//            line2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line2.alpha = 0.4;
//            [self addSubview:line2];
//
//            //bottom
//            UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, self.width, SCREEN_SCALE)];
//            btnLine.backgroundColor = [UIColor colorWithRed:41.f/255.f green:131.f/255.f blue:227.f/255.f alpha:0.3];
//            [self addSubview:btnLine];
//
//            float btnWith = 40;
//            _syncBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateNormal];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateDisabled];
//            _syncBtn.userInteractionEnabled = NO;
//            [self addSubview:_syncBtn];
//
//            _syncBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];;
//            _syncBtn2.frame = _syncBtn.frame;
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateNormal];
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateDisabled];
//            _syncBtn2.center = _syncBtn.center;
//            [_syncBtn2 addTarget:self action:@selector(syncBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:_syncBtn2];
//        }
//        else if (IS_IPHONE_6)
//        {
//            //head bg
//            UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
//            headBgView.backgroundColor = [UIColor blackColor];
//            headBgView.alpha = 0.15;
//            [self addSubview:headBgView];
//
//            UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(0, headBgView.height-SCREEN_SCALE, frame.size.width, SCREEN_SCALE)];
//            headLine.backgroundColor = [UIColor whiteColor];
//            headLine.alpha = 0.1;
//            [self addSubview:headLine];
//
//            //head btn
//            CGRect headFrame = CGRectMake(15, 33, 55, 55);
//            _headIconBtn = [[UIButton alloc]initWithFrame:headFrame];
//            _headIconBtn.layer.borderWidth = 1 + (1-SCREEN_SCALE);
//            _headIconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//            _headIconBtn.layer.cornerRadius = headFrame.size.width/2;
//            _headIconBtn.layer.masksToBounds = YES;
//            [self addSubview:_headIconBtn];
//
//            float nameLabelLeft = 80;
//            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, 31, self.width-nameLabelLeft-15, 30)];
//            _nameLabel.textAlignment = 30;
//            _nameLabel.textColor = [UIColor whiteColor];
//            _nameLabel.backgroundColor = [UIColor clearColor];
//            UIFont *nameFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:18];
//            _nameLabel.font = nameFont;
//            [self addSubview:_nameLabel];
//
//            //提示文字
//            float overtimeLabelW = (self.width-nameLabelLeft-15)/3;
//            float overtimeLabel1Y = 63;
//            float overtimeLabel1H = 8;
//            float secondLabelL = 137.5;
//            float thirdLabelL = 187.5;
//            float firstLabelWith = 45;
//            UIFont *overtimeLabel1Font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:7];
//            UILabel *overTimeLabel1= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            overTimeLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            overTimeLabel1.backgroundColor = [UIColor clearColor];
//            overTimeLabel1.text = @"OVERTIME";
//            [self addSubview:overTimeLabel1];
//
//            UILabel *totalLabel1= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelL, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            totalLabel1.backgroundColor = [UIColor clearColor];
//            totalLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            totalLabel1.text = @"TOTAL";
//            [self addSubview:totalLabel1];
//
//            UILabel *earendLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(thirdLabelL, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            earendLabel1.backgroundColor = [UIColor clearColor];
//            earendLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            earendLabel1.text = @"EARNED";
//            [self addSubview:earendLabel1];
//
//
//            overTimeLabel1.font = overtimeLabel1Font;
//            totalLabel1.font = overtimeLabel1Font;
//            earendLabel1.font = overtimeLabel1Font;
//
//            //显示时间金额
//            float overtimeLabelY = 63.5;
//            float overtimeLabelH = 30;
//            UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:12];
//
//            _overtimeLabel= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabelY, overtimeLabelW, overtimeLabelH)];
//            _overtimeLabel.textColor = [UIColor whiteColor];
//            _overtimeLabel.backgroundColor = [UIColor clearColor];
//            _overtimeLabel.text = @"0";
//            [self addSubview:_overtimeLabel];
//
//            _totalLabel= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelL, overtimeLabelY, firstLabelWith, overtimeLabelH)];
//            _totalLabel.backgroundColor = [UIColor clearColor];
//            _totalLabel.textColor = [UIColor whiteColor];
//            _totalLabel.text = @"0";
//            [self addSubview:_totalLabel];
//
//            _earendAmountLabel = [[HMJLabel alloc]initWithFrame:CGRectMake(thirdLabelL, overtimeLabelY, firstLabelWith, overtimeLabelH)];
//
//            _earendAmountLabel.backgroundColor = [UIColor clearColor];
//            [self addSubview:_earendAmountLabel];
//            [_earendAmountLabel creatSubViewsisLeftAlignment:YES];
//
//            _overtimeLabel.font = overFont;
//            _totalLabel.font = overFont;
//
//            //显示分割线
//            float lineY = 64;
//            float lineH = 19;
//            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(130, lineY, SCREEN_SCALE, lineH)];
//            line1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line1.alpha = 0.4;
//            [self addSubview:line1];
//
//            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(180, lineY, SCREEN_SCALE, lineH)];
//            line2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line2.alpha = 0.4;
//            [self addSubview:line2];
//
//            //bottom
//            UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, self.width, SCREEN_SCALE)];
//            btnLine.backgroundColor = [UIColor colorWithRed:41.f/255.f green:131.f/255.f blue:227.f/255.f alpha:0.3];
//            [self addSubview:btnLine];
//
//            float btnWith = 40;
//            _syncBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateNormal];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateDisabled];
//            _syncBtn.userInteractionEnabled = NO;
//            [self addSubview:_syncBtn];
//
//            _syncBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];;
//            _syncBtn2.frame = _syncBtn.frame;
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateNormal];
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateDisabled];
//            _syncBtn2.center = _syncBtn.center;
//            [_syncBtn2 addTarget:self action:@selector(syncBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:_syncBtn2];
//
//        }
//        else
//        {
//            //head bg
//            UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 110)];
//            headBgView.backgroundColor = [UIColor blackColor];
//            headBgView.alpha = 0.15;
//            [self addSubview:headBgView];
//
//            UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(0, headBgView.height-SCREEN_SCALE, frame.size.width, SCREEN_SCALE)];
//            headLine.backgroundColor = [UIColor whiteColor];
//            headLine.alpha = 0.1;
//            [self addSubview:headLine];
//
//            //head btn
//            CGRect headFrame = CGRectMake(20, 36, 60, 60);
//            _headIconBtn = [[UIButton alloc]initWithFrame:headFrame];
//            _headIconBtn.layer.borderWidth = 1+ (1-SCREEN_SCALE);
//            _headIconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//            _headIconBtn.layer.cornerRadius = headFrame.size.width/2;
//            _headIconBtn.layer.masksToBounds = YES;
//            [self addSubview:_headIconBtn];
//
//            float nameLabelLeft = 91;
//            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, 36, self.width-nameLabelLeft-15, 30)];
//            _nameLabel.textAlignment = 30;
//            _nameLabel.textColor = [UIColor whiteColor];
//            _nameLabel.backgroundColor = [UIColor clearColor];
//            UIFont *nameFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:20];
//            _nameLabel.font = nameFont;
//            [self addSubview:_nameLabel];
//
//            //提示文字
//            float overtimeLabelW = (self.width-nameLabelLeft-15)/3;
//            float overtimeLabel1Y = 69;
//            float overtimeLabel1H = 8;
//            float secondLabelLeft = 154;
//            float thirdLabelLeft = 210;
//
//            UIFont *overtimeLabel1Font = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:8];
//
//            UILabel *overTimeLabel1= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            overTimeLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            overTimeLabel1.backgroundColor = [UIColor clearColor];
//            overTimeLabel1.text = @"OVERTIME";
//            [self addSubview:overTimeLabel1];
//
//            UILabel *totalLabel1= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelLeft, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            totalLabel1.backgroundColor = [UIColor clearColor];
//            totalLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            totalLabel1.text = @"TOTAL";
//            [self addSubview:totalLabel1];
//
//            UILabel *earendLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(thirdLabelLeft, overtimeLabel1Y, overtimeLabelW, overtimeLabel1H)];
//            earendLabel1.backgroundColor = [UIColor clearColor];
//            earendLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.4];
//            earendLabel1.text = @"EARNED";
//            [self addSubview:earendLabel1];
//
//
//            overTimeLabel1.font = overtimeLabel1Font;
//            totalLabel1.font = overtimeLabel1Font;
//            earendLabel1.font = overtimeLabel1Font;
//
//            //显示时间金额
//            float overtimeLabelY = 70;
//            float overtimeLabelH = 30;
//            float overtimeLabelWith = 50;
//            UIFont *overFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:NO Size:14];
//
//            _overtimeLabel= [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, overtimeLabelY, overtimeLabelWith, overtimeLabelH)];
//            _overtimeLabel.textColor = [UIColor whiteColor];
//            _overtimeLabel.backgroundColor = [UIColor clearColor];
//            _overtimeLabel.text = @"0";
//            [self addSubview:_overtimeLabel];
//
//            _totalLabel= [[UILabel alloc]initWithFrame:CGRectMake(secondLabelLeft, overtimeLabelY, overtimeLabelWith, overtimeLabelH)];
//            _totalLabel.backgroundColor = [UIColor clearColor];
//            _totalLabel.textColor = [UIColor whiteColor];
//            _totalLabel.text = @"0";
//            [self addSubview:_totalLabel];
//
//            _earendAmountLabel = [[HMJLabel alloc]initWithFrame:CGRectMake(thirdLabelLeft, overtimeLabelY, overtimeLabelWith, overtimeLabelH)];
//            _earendAmountLabel.backgroundColor = [UIColor clearColor];
//            [self addSubview:_earendAmountLabel];
//            [_earendAmountLabel creatSubViewsisLeftAlignment:YES];
//
//            _overtimeLabel.font = overFont;
//            _totalLabel.font = overFont;
//
//            //显示分割线
//            float lineY = 70;
//            float lineH = 21;
//            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(147, lineY, SCREEN_SCALE, lineH)];
//            line1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line1.alpha = 0.4;
//            [self addSubview:line1];
//
//            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(202, lineY, SCREEN_SCALE, lineH)];
//            line2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//            line2.alpha = 0.4;
//            [self addSubview:line2];
//
//            //bottom
//            UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, self.width, SCREEN_SCALE)];
//            btnLine.backgroundColor = [UIColor colorWithRed:41.f/255.f green:131.f/255.f blue:227.f/255.f alpha:0.3];
//            [self addSubview:btnLine];
//
//            float btnWith = 40;
//            _syncBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateNormal];
//            [_syncBtn setImage:[UIImage imageNamed:@"icon_sync"] forState:UIControlStateDisabled];
//            _syncBtn.userInteractionEnabled = NO;
//            [self addSubview:_syncBtn];
//
//            _syncBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, btnWith, btnWith)];;
//            _syncBtn2.frame = _syncBtn.frame;
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateNormal];
//            [_syncBtn2 setImage:[UIImage imageNamed:@"icon_sync2"] forState:UIControlStateDisabled];
//            _syncBtn2.center = _syncBtn.center;
//            [_syncBtn2 addTarget:self action:@selector(syncBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:_syncBtn2];
//        }
        
        UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(10, 130, frame.size.width-20, SCREEN_SCALE)];
        headLine.backgroundColor = [UIColor whiteColor];
        headLine.alpha = 0.2;
        [self addSubview:headLine];
        
        CGRect headFrame = CGRectMake(20, 56, 50, 50);
        _headIconBtn = [[UIButton alloc]initWithFrame:headFrame];
//        _headIconBtn.layer.borderWidth = 1+ (1-SCREEN_SCALE);
//        _headIconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _headIconBtn.layer.cornerRadius = headFrame.size.width/2;
        _headIconBtn.layer.masksToBounds = YES;
        [self addSubview:_headIconBtn];

        float nameLabelLeft = 91;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelLeft, 36, self.width-nameLabelLeft-15, 30)];
        _nameLabel.centerY = _headIconBtn.centerY;
        _nameLabel.textAlignment = 30;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        UIFont *nameFont = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:20];
        _nameLabel.font = nameFont;
        [self addSubview:_nameLabel];
        
        
        //阴影
        UIImage *shadowImage = [UIImage imageNamed:@"leftMenu_shadow"];
        UIImageView *shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-shadowImage.size.width, 0, shadowImage.size.width, self.height)];
        shadowImageView.image = shadowImage;
        [self addSubview:shadowImageView];
        
        
        //VC
        float vy = 129;
        float heigh = 64;
        _dashBoardBtn = [self setupBtnWithFrame:CGRectMake(15, vy+10, frame.size.width-30, heigh-20) Icon:@"Dashboard" selectedIcon:@"Dashboard_press" title:@"Dashboard" rightImage:@"icon_tag1" tag:1];
        _clientsBtn = [self setupBtnWithFrame:CGRectMake(15, vy+heigh, frame.size.width-30, heigh-20) Icon:@"Clients" selectedIcon:@"Clients Copy" title:@"Clients" rightImage:nil tag:2];
        [self setupBtnWithFrame:CGRectMake(15, vy+heigh*2, frame.size.width-30, heigh-20) Icon:@"Pay Period" selectedIcon:@"Pay Period_press" title:@"Pay Period" rightImage:nil tag:3];
        _invoiceBtn = [self setupBtnWithFrame:CGRectMake(15, vy+heigh*3, frame.size.width-30, heigh-20) Icon:@"Invoices" selectedIcon:@"Invoices_press" title:@"Invoices" rightImage:@"icon_tag2" tag:4];
        [self setupBtnWithFrame:CGRectMake(15, vy+heigh*4, frame.size.width-30, heigh-20) Icon:@"Rettings" selectedIcon:@"Rettings_press" title:@"Reports" rightImage:nil tag:5];
        [self setupBtnWithFrame:CGRectMake(15, vy+heigh*5, frame.size.width-30, heigh-20) Icon:@"Settings" selectedIcon:@"Settings" title:@"Settings" rightImage:nil tag:6];
    }
    
    return self;
}


- (HMJLeftMenuButton *)setupBtnWithFrame:(CGRect)frame Icon:(NSString *)icon selectedIcon:(NSString *)selIcon title:(NSString *)title rightImage:(NSString *)rightImage tag:(int)tmpTag
{
    HMJLeftMenuButton *btn = [[HMJLeftMenuButton alloc]initWithFrame:frame];
    btn.tag = tmpTag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (btn.tag==1)
    {
        btn.selected = YES;
        _selectedBtn = btn;
    }
    else
        btn.selected = NO;
    
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selIcon] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    [btn setAdjustsImageWhenDisabled:NO];
    
    if (rightImage!=nil)
    {
        UIImage *tmpImage = [UIImage imageNamed:rightImage];
        btn.rightImageView.image = tmpImage;
        btn.rightImageView.frame = CGRectMake(btn.width-tmpImage.size.width-20, 0, tmpImage.size.width, btn.height);
        if(IS_IPHONE_6PLUS)
            btn.rightImageView.frame = CGRectMake(btn.width-tmpImage.size.width-27, 0, tmpImage.size.width, btn.height);
        [btn.rightImageView setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    if (IS_IPHONE_6PLUS)
    {
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    return btn;
    
}

-(UIButton *)loginBtn
{
    if (_loginBtn==nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        UIImage *loginImage = [UIImage imageNamed:@"sign"];

        _loginBtn.frame = CGRectMake(self.width - 10 - loginImage.size.width, (self.height-40 + (40 - loginImage.size.height)/2), loginImage.size.width, loginImage.size.height);
        [_loginBtn setImage:loginImage forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_loginBtn];
    }
    
    return _loginBtn;
}

-(void)loginBtnPressed:(id)sender
{
    [self btnClick:_clientsBtn];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    LogInViewController  *logInViewController = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    logInViewController.loadStyle = @"Present";
    // Present the log in view controller
    logInViewController.view.tag = 999;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:logInViewController];
    
    [appDelegate.mainViewController presentViewController:navi animated:YES completion:nil];
}

#pragma mark Action
-(void)btnClick:(HMJLeftMenuButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(leftMenu:didSelectedButtonFromIndex:toIndex:)]) {
        [self.delegate leftMenu:self didSelectedButtonFromIndex:(int)_selectedBtn.tag toIndex:(int)sender.tag];
    }
    
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
}


-(void)syncBtnPressed:(UIButton *)sender
{
    NSLog(@"点击了同步按钮");
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate_iPhone.appUser==nil) {
        Log(@"没有登陆，不能同步");
        return;
    }
    if ([appDelegate.appSetting.autoSync isEqualToString:@"NO"]) {
        _syncBtn2.userInteractionEnabled = NO;
        [appDelegate.parseSync syncAllWithTip:YES];

    }
    else
    {
        NSLog(@"自动同步状态开启，不能手动同步");
    }
}



-(void)syncAnimationBegain
{
    CABasicAnimation *animation = [CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.4;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = YES;
    [_syncBtn2.layer addAnimation:animation forKey:nil ];
}

-(void)syncAnimationEnd
{
    [_syncBtn2.layer removeAllAnimations];
}

#pragma mark Set & Get
-(void)setDelegate:(id<HMJLeftMenuDelegate>)delegate
{
    _delegate = delegate;
    [self btnClick:(HMJLeftMenuButton *)[self viewWithTag:1]];
}


-(void)setLeftMenuDashboardandInvoiceRightImageView
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    
    //head
    NSMutableArray *dataArray = [appDelegate.nomalClass  getAllOverTimeandMondy];
    _overtimeLabel.text = [NSString stringWithFormat:@"%d",[[dataArray firstObject]intValue]];
    _totalLabel.text = [NSString stringWithFormat:@"%d",[[dataArray objectAtIndex:1] intValue]];
    
    double amount = [[dataArray lastObject]doubleValue];
    if(IS_IPHONE_6PLUS)
        [_earendAmountLabel setAmountSize:15 pointSize:11 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",amount] color:[HMJNomalClass creatAmountColor]];
    else
        [_earendAmountLabel setAmountSize:13 pointSize:10 Currency:appDelegate.currencyStr Amount:[NSString stringWithFormat:@"%.2f",amount] color:[HMJNomalClass creatAmountColor]];
    [_earendAmountLabel setNeedsDisplay];
    
    //图片
    if ([[appDelegate getDashBoardClient]count]>0)
    {
        _dashBoardBtn.rightImageView.hidden = NO;
        
        CABasicAnimation *animation = [ CABasicAnimation
                                       animationWithKeyPath: @"transform" ];
        
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        //围绕Z轴旋转，垂直与屏幕
        animation.toValue = [ NSValue valueWithCATransform3D:
                             CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.4;
        //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
        animation.cumulative = YES;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = YES;
        [_dashBoardBtn.rightImageView.layer addAnimation:animation forKey:nil ];
        
    }
    else
    {
        _dashBoardBtn.rightImageView.hidden = YES;
        [_dashBoardBtn.rightImageView.layer removeAllAnimations];
    }
    
    
    _invoiceBtn.rightImageView.hidden = ![appDelegate.nomalClass judgeifHasUnpaidInvoice];
    
    //登陆按钮
    AppDelegate_iPhone *appDelegate_iPhone = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
    if(appDelegate_iPhone.appUser==nil)
    {
        self.loginBtn.hidden = NO;
    }
    else
        self.loginBtn.hidden = YES;
        
}

@end
