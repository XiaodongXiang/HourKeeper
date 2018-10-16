//
//  RateViewController_iphone.h
//  HoursKeeper
//
//  Created by xy_dev on 11/25/13.
//
//

#import <UIKit/UIKit.h>

/**
    弹出评论
 */
@interface RateViewController_iphone : UIViewController<UIScrollViewDelegate>
{
}
//input
@property (nonatomic,assign) NSInteger stly;  //0 rate;    1 what's new;

@property (nonatomic,strong) IBOutlet UIView *bv;
@property (nonatomic,strong) IBOutlet UIImageView *bvImageV;

@property (nonatomic,strong) IBOutlet UIView *whatNewBv;
@property (nonatomic,strong) IBOutlet UIImageView *whatBvImagv;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *pageArray;

@property (nonatomic,strong) IBOutlet UIButton *Bt1;



-(void)setRateOrWhatNew;

-(IBAction)doAction:(UIButton *)sender;

-(IBAction)doWhatNewAction:(UIButton *)sender;
-(IBAction)onPangeChange;

@end
