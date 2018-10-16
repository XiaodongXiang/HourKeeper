//
//  DashBoardTableViewCell.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/30.
//
//

#import "DashBoardTableViewCell.h"



#define DELETEBTN_WITH 66
@implementation DashBoardTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.height = 135;
        float left = 30;
        if(IS_IPHONE_6)
            left = 40;
        else if (IS_IPHONE_6PLUS)
            left = 50;

        
        
        //delete btn
        self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WITH-DELETEBTN_WITH, 0, DELETEBTN_WITH, self.height)];
        self.deleteBtn.backgroundColor = [UIColor redColor];
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:self.deleteBtn];
        
        //contentcontainview
        self.contentContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, self.height)];
        self.contentContainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentContainView];
        
        _leftContainView = [[UIView alloc]init];
        _leftContainView.width = 90;
        _leftContainView.height = 90;
        _leftContainView.top = (self.height - _leftContainView.height)/2.0;
        _leftContainView.left = left;
        [self.contentContainView addSubview:_leftContainView];
        
        _externalView = [[DashBoardExternalView alloc]initWithFrame:CGRectMake(0, 0, _leftContainView.bounds.size.width, _leftContainView.bounds.size.height)];
        [_leftContainView addSubview:_externalView];
        
        
        _timeLabel = [[UILabel  alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.width = 60;
        _timeLabel.height = 30;
        _timeLabel.left = (_leftContainView.width - _timeLabel.width)/2.0;
        _timeLabel.top = (_leftContainView.width - _timeLabel.height)/2.0;
        [_leftContainView addSubview:_timeLabel];
        
        
        float amountRight = 40;
        if(IS_IPHONE_6)
            amountRight = 50;
        else if(IS_IPHONE_6PLUS)
            amountRight = 60;
        _amountView = [[HMJLabel alloc]init];
        _amountView.backgroundColor = [UIColor clearColor];
        _amountView.left = (SCREEN_WITH*1.0/3.0)+20;
        _amountView.top = 12;
        _amountView.height = 70;
        _amountView.width = SCREEN_WITH - amountRight - _amountView.left;
        [self.contentContainView addSubview:_amountView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [HMJNomalClass creatBlackColor_20_20_20];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [HMJNomalClass creatFont_HelveticaNeue_Medium:YES Size:17];
        _nameLabel.left = _amountView.left;
        _nameLabel.width = _amountView.width;
        _nameLabel.top = 72;
        _nameLabel.height = 22;
        [self.contentContainView addSubview:_nameLabel];
        
        _perHourLabel = [[UILabel alloc]init];
        _perHourLabel.textColor = [HMJNomalClass creatGrayColor_164_164_164];
        _perHourLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:11];
        _perHourLabel.textAlignment = NSTextAlignmentRight;
        _perHourLabel.left = _amountView.left;
        _perHourLabel.top = 96;
        _perHourLabel.height = 10;
        _perHourLabel.width = _amountView.width;
        [self.contentContainView addSubview:_perHourLabel];
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-SCREEN_SCALE, SCREEN_WITH, SCREEN_SCALE)];
//        line.backgroundColor = [HMJNomalClass creatLineColor_210_210_210];
//        [self addSubview:line];
        
        //添加手势
        UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipFromRight:)];
        swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipLeft];
    }
    return self;
}


-(void)swipFromRight:(id)sender
{
    if (self.dashboardViewController != nil)
    {
        if (self.dashboardViewController.swipCellIndex == nil) {
            self.dashboardViewController.swipCellIndex = self.cellIndexPath;
            [self.dashboardViewController.myTableView reloadData];
            
        }
        else{
            self.dashboardViewController.swipCellIndex = nil;
            [self.dashboardViewController.myTableView reloadData];
        }

    }
}

-(void)layoutShowDeleteBtn:(BOOL)showTwoBtns
{
    if (showTwoBtns)
    {
        if (self.contentContainView.left==0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            self.contentContainView.left = 0-DELETEBTN_WITH;
            [UIView commitAnimations];
            
        }
    }
    else
    {
        if (self.contentContainView.left<0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            self.contentContainView.left = 0;
            [UIView commitAnimations];
        }
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
