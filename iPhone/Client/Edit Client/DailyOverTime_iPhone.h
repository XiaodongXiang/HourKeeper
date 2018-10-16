//
//  DailyOverTime_iPhone.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 12-1-10.
//  Copyright 2012 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewClientViewController_iphone.h"


@interface DailyOverTime_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{

}
//input
@property (nonatomic,strong) NewClientViewController_iphone *clientController;
//天加班还是周加班
@property (nonatomic,assign) BOOL                           isDaily;

@property (nonatomic,strong) IBOutlet UITableViewCell       *cell1;
@property (nonatomic,strong) IBOutlet UITableViewCell       *cell2;
@property (nonatomic,strong) IBOutlet UITableViewCell       *cell3;
@property (nonatomic,strong) IBOutlet UITableViewCell       *cell4;
//overtime1
@property (nonatomic,strong) IBOutlet UITextField           *afterField11;
//overtime2
@property (nonatomic,strong) IBOutlet UITextField           *afterField22;
//afterfield1
@property (nonatomic,strong) IBOutlet UITextField           *afterField1;
//afterfield2
@property (nonatomic,strong) IBOutlet UITextField           *afterField2;

@property (nonatomic,strong) IBOutlet UIView                *pickView;
@property (nonatomic,strong) IBOutlet UIPickerView          *picker;

@property (nonatomic,weak) IBOutlet UILabel                 *overlabel1;
@property (nonatomic,weak) IBOutlet UILabel                 *afterlabel1;
@property (nonatomic,weak) IBOutlet UILabel                 *overlabel2;
@property (nonatomic,weak) IBOutlet UILabel                 *afterlabel2;

@property (nonatomic,weak) IBOutlet UILabel                 *over1xlabel1;
@property (nonatomic,weak) IBOutlet UIImageView             *over1numberback1;
@property (nonatomic,weak) IBOutlet UILabel                 *over2xlabel1;
@property (nonatomic,weak) IBOutlet UIImageView             *over2numberback1;
@property (nonatomic,weak) IBOutlet UILabel                 *cell2hlabel1;
@property (nonatomic,weak) IBOutlet UIImageView             *cell2numberback1;
@property (nonatomic,weak) IBOutlet UILabel                 *cell4hlabel1;
@property (nonatomic,weak) IBOutlet UIImageView             *cell4numberback1;


-(void)doneAndBack;
-(void)initData;


@end
