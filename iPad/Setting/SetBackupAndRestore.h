//
//  SetBackupAndRestore.h
//  HoursKeeper
//
//  Created by xy_dev on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Http.h"

@interface SetBackupAndRestore : UIViewController<HttpDelegate>
{
}
@property (nonatomic, strong) IBOutlet UILabel *displayUrlLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *showActivity;
@property (nonatomic, strong) Http *http;

-(void)createZipFile;
-(void)cancel;

@end
