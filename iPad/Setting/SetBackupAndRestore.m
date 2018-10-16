//
//  SetBackupAndRestore.m
//  HoursKeeper
//
//  Created by xy_dev on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetBackupAndRestore.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "AppDelegate_Shared.h"


@implementation SetBackupAndRestore

#pragma mark Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)viewWillDisappear:(BOOL)animated
{
	[self.http stop];
}


// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated    
{
	self.http=[[Http alloc] initWithServer];
	self.http.delegate=self;
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
    
	[self.displayUrlLabel setText:info];
}

-(void)stop
{
    [self.showActivity startAnimating];
    [self.showActivity setHidden:NO];
    
    [self.displayUrlLabel setText:@""];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [appDelegate copyDatabase_widget_to_location];
    }
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 30);
    [backBtn setImage:[UIImage imageNamed:@"navi_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navi_back_sel.png"] forState:UIControlStateHighlighted];
//    backBtn.titleLabel.font = appDelegate.naviFont;
//    [backBtn setTitle:@"Settings" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [appDelegate setNaviGationItem:self isLeft:YES button:backBtn];
    
    [appDelegate setNaviGationTittle:self with:300 high:44 tittle:@"Backup and Restore"];
    
    
    [self.showActivity startAnimating];
    [self.showActivity setHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [appDelegate deleteDatabase_location];
    }
}




-(void)cancel
{
    [self.navigationController  popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return  (interfaceOrientation == UIDeviceOrientationLandscapeLeft)||(interfaceOrientation == UIDeviceOrientationLandscapeRight) ;
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



@end
