//
//  ShowPDFViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/**
    显示Invoice的PDF页面
 */
#import <UIKit/UIKit.h>

#import "Invoice.h"
#import <MessageUI/MFMailComposeViewController.h>


@class PDFView_iphone2;


@interface ShowPDFViewController : UIViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPrintInteractionControllerDelegate,UIAlertViewDelegate>
{
    //pdf在这上面绘图
    PDFView_iphone2 *pdfView2;
}

//显示pdf view的界面
@property (nonatomic,strong) IBOutlet UIView *pdfView;
//选择的invoice
@property (nonatomic,strong) Invoice *selectInvoice;

//左右两边的按钮
@property (nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *editButton;

//tabbar 支付按钮
@property (nonatomic,strong) IBOutlet UIButton *paymentBtn;

//支付小弹窗
@property (nonatomic,strong) IBOutlet UIView *payView;
@property (nonatomic,strong) IBOutlet UILabel *amountLable;
@property (nonatomic,strong) IBOutlet UITextField *inputField;


//答应控制器
@property (nonatomic,strong) UIPrintInteractionController *sel_printInteraction;



-(IBAction)doPayAmount_action:(UIButton *)sender;

-(void)initPDFdata;

-(void)doEdit;
-(void)back;

-(IBAction)sentEmail;
-(IBAction)deleteInvoice;
-(IBAction)addPayment;




@end
