//
//  OverTimeViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 11/26/13.
//
//

#import <UIKit/UIKit.h>

#import "OverClientViewController.h"
#import "OverDateViewController.h"

#import "Clients.h"



@interface OverTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,getOverClientDelegate,getOverDateDelegate>
{
}
//option
@property(nonatomic,strong) Clients                     *sel_client;
//0:date;  1:payperiod;  2:custom;
@property(nonatomic,assign) NSInteger                   dateStly;
@property(nonatomic,strong) NSDate                      *startDate;
@property(nonatomic,strong) NSDate                      *endDate;

@property(nonatomic,strong) IBOutlet UITableView        *myTableView;

@property(nonatomic,strong) IBOutlet UITableViewCell    *dateCell;

@property(nonatomic,strong) IBOutlet UITableViewCell    *clientCell;
@property(nonatomic,strong) IBOutlet UILabel            *clientNameLbel;
@property(nonatomic,strong) IBOutlet UILabel            *day1Lbel;
@property(nonatomic,strong) IBOutlet UILabel            *day2Lbel;
@property(nonatomic,strong) IBOutlet UILabel            *week1Lbel;
@property(nonatomic,strong) IBOutlet UILabel            *week2Lbel;
@property(nonatomic,strong) IBOutlet UIImageView        *lineImageV;//横线
@property(nonatomic,strong) IBOutlet UILabel            *dateLbel;

@property(nonatomic,strong) IBOutlet UITableViewCell *totalCell;
@property(nonatomic,strong) IBOutlet UILabel            *totalTimeLbel;
@property(nonatomic,strong) IBOutlet UILabel            *totalMoneyLbel;



@property(nonatomic,weak) IBOutlet UILabel              *clientlabel1;
@property(nonatomic,weak) IBOutlet UILabel              *datelabel1;
@property(nonatomic,weak) IBOutlet UIView               *line1;

-(void)initData;
-(void)back;
-(void)doCalculate;
-(void)saveSelectDate:(NSDate *)_startDate second:(NSDate *)_endDate dateStly:(NSInteger)_dateStly;

@end


