//
//  OverDateViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 11/27/13.
//
//

#import <UIKit/UIKit.h>
#import "Clients.h"


@protocol getOverDateDelegate <NSObject>

-(void)saveSelectDate:(NSDate *)_startDate second:(NSDate *)_endDate dateStly:(NSInteger)_dateStly;

@end


@interface OverDateViewController : UIViewController
{
}
//input
@property(nonatomic,strong) Clients                 *sel_client;
// 0:day;   1:week;   2:custom;
@property(nonatomic,assign) NSInteger               dateStly;
@property(nonatomic,strong) id<getOverDateDelegate> delegate;

//option
@property(nonatomic,strong) NSDate                  *startDate;
@property(nonatomic,strong) NSDate                  *endDate;

@property(nonatomic,assign) NSInteger               isFirstStly;      // 0:first;   1:second;

//三个按钮
@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic,strong) IBOutlet UIButton           *leftBtn;
@property(nonatomic,strong) IBOutlet UIButton           *rightBtn;

//custome:end view
@property(nonatomic,strong) IBOutlet UIView             *secondView;
@property(nonatomic,strong) IBOutlet UIButton           *secondBtn;

//custome:start label
@property(nonatomic,strong) IBOutlet UILabel            *startLbel;
@property(nonatomic,strong) IBOutlet UIButton           *firstBtn;

@property(nonatomic,strong) IBOutlet UIDatePicker       *sel_datePicker;
@property(nonatomic,strong) IBOutlet UIView             *datePickerBvView;
@property(nonatomic,strong) IBOutlet UIImageView        *segmentImagV;



-(void)backAndSave;

-(IBAction)doSegment:(UISegmentedControl *)sender;
-(void)showSegmentImage;

-(IBAction)doLeftOrRightBtn:(UIButton *)sender;
-(IBAction)doFirOrSecBtn:(UIButton *)sender;
-(IBAction)doPickerDate;
-(void)showSecondDateStly:(NSDate *)duDate;


@end

