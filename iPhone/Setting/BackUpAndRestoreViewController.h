//
//  BackUpAndRestoreViewController.h
//  BabyWatch
//
//  Created by SL02 on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Http.h"

@interface BackUpAndRestoreViewController : UIViewController<HttpDelegate>
{
}

@property (nonatomic, strong) IBOutlet UILabel *displayUrlLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *showActivity;
@property (nonatomic, strong) Http *http;



-(void)createZipFile;


@end
