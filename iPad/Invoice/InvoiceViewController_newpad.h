//
//  InvoiceViewController_newpad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShowPDFViewController_ipad.h"


/**
    iPad中主界面Invoice界面
 */
@interface InvoiceViewController_newpad : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}

@property(nonatomic,strong) NSMutableArray *openArray;
@property(nonatomic,strong) NSMutableArray *paidArray;

@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@property(nonatomic,strong) IBOutlet UIImageView *tipImagV;

@property(nonatomic,strong) ShowPDFViewController_ipad *pdfShowView;



-(void)newInvoice;
-(void)initViewControllData;
-(void)pop_invoice:(UIButton *)sender;



@end
