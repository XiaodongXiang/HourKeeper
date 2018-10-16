//
//  ShowPDFViewController_ipad.h
//  HoursKeeper
//
//  Created by xy_dev on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Invoice.h"
#import <MessageUI/MFMailComposeViewController.h>

@class PDFView_iphone2;

@interface ShowPDFViewController_ipad : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIPrintInteractionControllerDelegate,UIAlertViewDelegate>
{
    PDFView_iphone2 *pdfView2;
}

@property (nonatomic,strong) IBOutlet UIView *pdfView;
@property (nonatomic,strong) Invoice *selectInvoice;

@property (nonatomic,strong) UIPrintInteractionController *sel_printInteraction;



-(void)initFlashIvoiceData;

-(IBAction)doEdit;
-(IBAction)back;

-(IBAction)sentEmail;
-(IBAction)deleteInvoice;




@end
