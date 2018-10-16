    //
//  FileController.m
//  HoursKeeper
//
//  Created by Chenxiaoting on 11-12-31.
//  Copyright 2011 xiaoting.com. All rights reserved.
//

#import "FileController.h"
#import "AppDelegate_Shared.h"


@implementation FileController

+ (NSString *) documentPath
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSString *documentDir = [appDelegate applicationDocumentsDirectory_location].relativePath;
	return documentDir;
} 
+ (NSString *) readFromFile:(NSString *)filepath
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:filepath];
		NSString *text = [array objectAtIndex:0];
		return text;
	}else {
		return nil;
	}
}
+ (void) writeToFile:(NSString *)text writeFileName:(NSString *)filepath
{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:text];
	[array writeToFile:filepath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
