//
//  BackUpAndRestoreViewController.m
//  BabyWatch
//
//  Created by SL02 on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BackUpAndRestoreViewController.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "AppDelegate_Shared.h"

@implementation BackUpAndRestoreViewController
@synthesize displayUrlLabel;
@synthesize showActivity;
@synthesize http;




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [appDelegate copyDatabase_widget_to_location];
    }
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:150 high:44 tittle:@"Backup & Restore"];
    
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    [self.showActivity startAnimating];
    [self.showActivity setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:YES isBottom:NO];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    [appDelegate customFingerMove:self canMove:NO isBottom:NO];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [appDelegate deleteDatabase_location];
    }
}






-(void)Back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(CGSize)contentSizeForViewInPopoverView
{
	return CGSizeMake(320.0, 416.0);
}
-(void)createZipFile
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;//去处需要的路径
	NSError * error;
	NSArray *array = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/HoursKeeperBak.zip"];
	ZipArchive* zipFile = [[ZipArchive alloc] init];
	BOOL ret=[zipFile CreateZipFile2:path2];
	while(!ret)
	{
		[fileManager createFileAtPath:path2 contents:nil attributes:nil];
		ret=[zipFile CreateZipFile2:path2];
	}
	
    for (NSString *fname in array)
    {
		//NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[documentsDirectory stringByAppendingPathComponent:fname] error:&error];
		NSLog(@"fname....................%@.....................", fname);
        
        
		NSString* a=[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", fname]];
		ret =[zipFile addFileToZip:a newname:[fname stringByAppendingString:@".p"]];
	}
	if( ret)
	{
		[zipFile CloseZipFile2];
	}
	else
	{
	}
}


#pragma mark system method
-(void)viewWillDisappear:(BOOL)animated
{
	[http stop];
}
- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
	http=[[Http alloc] initWithServer];
	http.delegate=self;
}
-(void)setServerPort:(UInt16)port
{
	
}
-(void)uploadFinished
{
	
}
-(void)displayInfo:(NSString*)info
{
    [self.showActivity stopAnimating];
    [self.showActivity setHidden:YES];
    
	[displayUrlLabel setText:info];
}


-(void)stop
{
    [self.showActivity startAnimating];
    [self.showActivity setHidden:NO];
    
    [displayUrlLabel setText:@""];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


@end
