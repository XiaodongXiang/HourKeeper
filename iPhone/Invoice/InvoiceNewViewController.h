//
//  InvoiceNewViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShowPDFViewController.h"

/**
    InvoiceNewViewController Incvoice的列表视图
 */
@interface InvoiceNewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
}

@property(nonatomic,strong) IBOutlet UITableView        *myTableView;
@property(nonatomic,strong) IBOutlet UIImageView        *tipImagV;

//没支付的Invoice数组和支付的Invoice数组
@property(nonatomic,strong) NSMutableArray              *openArray;
@property(nonatomic,strong) NSMutableArray              *paidArray;

//显示Invoice的PDF
@property(nonatomic,strong) ShowPDFViewController       *dropboxShowPDFContor;

@property(nonatomic,strong) IBOutlet UIButton           *lite_Btn;

@property(nonatomic,weak)IBOutlet UIView                *rightBarView;
@property(nonatomic,weak)IBOutlet   UIButton            *searchBtn;
@property(nonatomic,weak)IBOutlet   UIButton            *addBtn;

//1.初始化Invoice的数组 2.添加Invoice
-(void)initInvoiceData;
-(void)addInvoice;

//解锁免费版 以及解锁之后的通知
-(IBAction)doLiteBtn;
-(void)pop_system_UnlockLite; //统一的 UnLock action 名


@end
