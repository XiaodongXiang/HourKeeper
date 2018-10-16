//
//  FileController.h
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-31.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileController : UIViewController {

}
+ (NSString *)documentPath;
+ (NSString *)readFromFile:(NSString *)filepath;
+ (void)writeToFile:(NSString *)text
	  writeFileName:(NSString *)filepath;
@end
