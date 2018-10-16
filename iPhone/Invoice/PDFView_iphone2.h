//
//  PDFView_iphone2.h
//  HoursKeeper
//
//  Created by xy_dev on 8/21/13.
//
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

#import "ReaderScrollView.h"
#import "ReaderContentView.h"


@interface PDFView_iphone2 : UIView
{
    float pdfWith;
    float pdfHigh;
    
    int page1;
    int pageN;
}
@property(nonatomic,strong) Invoice *_invoice;

//view 显示
@property(nonatomic,strong) ReaderScrollView   *theScrollView;


- (void)doCreate_Pdf:(Invoice *)invoice _CGContextRef:(CGContextRef)_context;
- (float)drawFirst:(Invoice *)invoice _CGContextRef:(CGContextRef)_context;
- (float)drawMiddle:(Invoice *)invoice _CGContextRef:(CGContextRef)_context _beginHigh:(float)beginY;
- (void)drawLast:(Invoice *)invoice _CGContextRef:(CGContextRef)_context _beginHigh:(float)beginY;


@end
