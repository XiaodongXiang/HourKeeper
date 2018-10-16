//
//  This class was created by Nonnus,
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import "MyHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "AsyncSocket.h"
#import "ZipArchive.h"
#import <sqlite3.h>

#import "AppDelegate_Shared.h"




@implementation MyHTTPConnection
@synthesize isNext;
@synthesize isRestore;
/**
 * Returns whether or not the requested resource is browseable.
**/
- (BOOL)isBrowseable:(NSString *)path
{
	// Override me to provide custom configuration...
	// You can configure it for the entire server, or based on the current request
	
	return YES;
}


/**
 * This method creates a html browseable page.
 * Customize to fit your needs
**/
-(void)createZipFile:(NSString*)path
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSError * error=nil;
	NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:&error];
	NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/HoursKeeperBak.zip"];
	
	//NSLog(path2);
	ZipArchive* zipFile = [[ZipArchive alloc] init];
	BOOL ret=[zipFile CreateZipFile2:path2];
	while(!ret)
	{
		[fileManager createFileAtPath:path2 contents:nil attributes:nil];
		ret=[zipFile CreateZipFile2:path2];
	}
	
    for (NSString *fname in array)
    {
		if(![fname isEqualToString:@"HoursKeeperBak.zip"])
		{
			NSString* a=[path stringByAppendingString:[NSString stringWithFormat:@"/%@", fname]];
			ret =[zipFile addFileToZip:a newname:[fname stringByAppendingString:@".p"]];
		}
	}
	if( ret)
	{
		[zipFile CloseZipFile2];
		[zipFile release];
	}
	else
	{
		[zipFile release];
	}
	
	//把图标写进去
	
	NSString *dds = [appDelegate applicationDocumentsDirectory_location].relativePath;
	if (!dds)
    {
		NSLog(@"Documents directory not found!");
	}
	NSString *pathimageBackup = [dds stringByAppendingPathComponent:@"/btn_backup.png"];	
	UIImage* imageBackup=[UIImage imageNamed:@"btn_backup.png"];
	NSData *dataBackup = UIImagePNGRepresentation(imageBackup);
	[dataBackup writeToFile:pathimageBackup atomically:YES];
	
	NSString *pathrestore = [dds stringByAppendingPathComponent:@"/btn_restore.png"];	
	UIImage* imagerestore=[UIImage imageNamed:@"btn_restore.png"];
	NSData *datarestore = UIImagePNGRepresentation(imagerestore);
	[datarestore writeToFile:pathrestore atomically:YES];
	
	NSString *pathIconBackupimage = [dds stringByAppendingPathComponent:@"/icon_backup.png"];	
	UIImage* imageIconBackup=[UIImage imageNamed:@"icon_backup.png"];
	NSData *dataIconBackup = UIImagePNGRepresentation(imageIconBackup);
	[dataIconBackup writeToFile:pathIconBackupimage atomically:YES];
	
	NSString *pathIconRestoreimage = [dds stringByAppendingPathComponent:@"/icon_restore.png"];	
	UIImage* imageRestore=[UIImage imageNamed:@"icon_restore.png"];
	NSData *dataRestore = UIImagePNGRepresentation(imageRestore);
	[dataRestore writeToFile:pathIconRestoreimage atomically:YES];
	
	NSString *pathbg = [dds stringByAppendingPathComponent:@"/html_bg.png"];	
	UIImage* imagebg=[UIImage imageNamed:@"html_bg.png"];
	NSData *databg = UIImagePNGRepresentation(imagebg);
	[databg writeToFile:pathbg atomically:YES];
	
	NSString *pathlogo = [dds stringByAppendingPathComponent:@"/logo.png"];	
	UIImage* imagelogo=[UIImage imageNamed:@"logo.png"];
	NSData *datalogo = UIImagePNGRepresentation(imagelogo);
	[datalogo writeToFile:pathlogo atomically:YES];
}
-(BOOL)hasZipFile:(NSString*)path
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* a=[[path stringByAppendingString:@"/"] stringByAppendingString:@"HoursKeeperBak.zip"];
	BOOL relust=[fileManager fileExistsAtPath:a];
	return relust;
}
- (NSString *)createBrowseableIndex:(NSString *)path
{
	NSError * error = nil;
	static BOOL isFrist=YES;
	if(!isRestore)
	{
		dpath=path;
		if([self hasZipFile:path])
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString* a=[[path stringByAppendingString:@"/"] stringByAppendingString:@"HoursKeeperBak.zip"];
			[fileManager removeItemAtPath:a error:&error];
		}
		[self createZipFile:path];
		isFrist=NO;
	}
	NSMutableString *outdata = [NSMutableString new];
	
	if ([self supportsPOST:path withSize:0])
    {
		
		NSString *path3 = [[NSBundle mainBundle] pathForResource:@"keeper" ofType:@"html"];
		NSString * str = [NSString stringWithContentsOfFile:path3 encoding: NSUTF8StringEncoding error: &error];
		[outdata appendFormat:str,nil];
	}
	
    return [outdata autorelease];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)relativePath
{
	if ([@"POST" isEqualToString:method])
	{
		return YES;
	}
	
	return [super supportsMethod:method atPath:relativePath];
}


/**
 * Returns whether or not the server will accept POSTs.
 * That is, whether the server will accept uploaded data for the given URI.
**/
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
	dataStartIndex = 0;
	multipartData = [[NSMutableArray alloc] init];
	postHeaderOK = FALSE;
	return YES;
}


/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResopnse is a wrapper for an NSData object, and may be used to send a custom response.
**/
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	NSLog(@"httpResponseForURI: method:%@ path:%@", method, path);
	NSData *requestData = [(NSData *)CFHTTPMessageCopySerializedMessage(request) autorelease];
	
	NSString *requestStr = [[[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"\n=== Request ====================\n%@\n================================", requestStr);
	
	if (requestContentLength > 0)  // Process POST data
	{
		NSLog(@"processing post data: %llu", requestContentLength);
		
		if ([multipartData count] < 2) return nil;
		
		NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes]
													  length:[[multipartData objectAtIndex:1] length]
													encoding:NSUTF8StringEncoding];
		
		NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
		postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
		postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
		NSString* filename = [postInfoComponents lastObject];
		
		if (![filename isEqualToString:@""]) //this makes sure we did not submitted upload form without selecting file
		{
			UInt16 separatorBytes = 0x0A0D;
			NSMutableData* separatorData = [NSMutableData dataWithBytes:&separatorBytes length:2];
			[separatorData appendData:[multipartData objectAtIndex:0]];
			int l = (int)[separatorData length];
			int count = 2;	//number of times the separator shows up at the end of file data
			
			NSFileHandle* dataToTrim = [multipartData lastObject];
			NSLog(@"data: %@", dataToTrim);
			
			for (unsigned long long i = [dataToTrim offsetInFile] - l; i > 0; i--)
			{
				[dataToTrim seekToFileOffset:i];
				if ([[dataToTrim readDataOfLength:l] isEqualToData:separatorData])
				{
					[dataToTrim truncateFileAtOffset:i];
					i -= l;
					if (--count == 0) break;
				}
			}
			
			NSLog(@"NewFileUploaded");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NewFileUploaded" object:nil];
		}
		
		for (int n = 1; n < [multipartData count] - 1; n++)
			NSLog(@"%@", [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:n] bytes] length:[[multipartData objectAtIndex:n] length] encoding:NSUTF8StringEncoding]);
		
		[postInfo release];
		[multipartData release];
		requestContentLength = 0;
		
	}
	
	NSString *filePath = [self filePathForURI:path];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return [[[HTTPFileResponse alloc] initWithFilePath:filePath] autorelease];
	}
	else
	{
		NSString *folder = [[server documentRoot] path];//[path isEqualToString:@"/"] ? [[server documentRoot] path] : [NSString stringWithFormat: @"%@%@", [[server documentRoot] path], path];
		
		if ([self isBrowseable:folder])
		{
			NSData *browseData = [[self createBrowseableIndex:folder] dataUsingEncoding:NSUTF8StringEncoding];
			return [[[HTTPDataResponse alloc] initWithData:browseData] autorelease];
		}
	}
	
	return nil;
}


/**
 * This method is called to handle data read from a POST.
 * The given data is part of the POST body.
**/
- (void)processDataChunk:(NSData *)postDataChunk
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	self.isRestore = TRUE;
	multipartData = [[NSMutableArray alloc] init];
	[multipartData removeAllObjects];
	if (!postHeaderOK)
	{
		UInt16 separatorBytes = 0x0A0D;
		NSData* separatorData = [NSData dataWithBytes:&separatorBytes length:2];
		
		int l = (int)[separatorData length];
		for (int i = 0; i < [postDataChunk length] - l; i++)
		{
			NSRange searchRange = {i, l};
			
			if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
			{
				NSRange newDataRange = {dataStartIndex, i - dataStartIndex};
				dataStartIndex = i + l;
				i += l - 1;
				NSData *newData = [postDataChunk subdataWithRange:newDataRange];
				
				if ([newData length])
				{
					[multipartData addObject:newData];
				}
				else
				{
					postHeaderOK = TRUE;
					NSError * errors;
					NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;//去处需要的路径
					NSString *path = [appDelegate applicationDocumentsDirectory_location].relativePath;
					NSError * error=nil;
					NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
					NSFileManager *fileManager = [NSFileManager defaultManager];
					
					for (NSString *fname in array)
					{
						if([fname length]>4)
						{
							if([[fname substringFromIndex:[fname length]-4] isEqualToString:@".zip"])
							{
								[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fname] error:&errors];
							}
						}
					}
					NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
					NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
					
					postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
					postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];//					NSFileManager *fileManager = [NSFileManager defaultManager];
					
					NSString* filename = [[[server documentRoot] path] stringByAppendingPathComponent:[postInfoComponents lastObject]];
					//获取文件路径
					[postInfo stringByReplacingOccurrencesOfString:filename withString:@"Update.zip"];
					
					NSRange fileDataRange = {dataStartIndex, [postDataChunk length] - dataStartIndex};
					[[NSFileManager defaultManager] createFileAtPath:filename contents:[postDataChunk subdataWithRange:fileDataRange] attributes:nil];
					NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filename] retain];
					
					if (file)
					{
						[file seekToEndOfFile];
						[multipartData addObject:file];
					}
					[postInfo release];
					[self writeSqliteFile];
					[self sureFileRight];
					break;
				}
			}
		}
	}
	else
	{
		[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
	}
	
}
-(void)writeSqliteFile
{
	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Confirm restore"
													 message:@"Do you want to restore Hours Keeper with the uploaded backup? All current data will be ERASED and REPLACED with the backup, this cannot be undone."
													delegate:self
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"Restore",nil];
	alert.tag = 0;
	[alert show];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    appDelegate.close_PopView = alert;
    
	[alert release];
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	if(alertView.tag == 0)
	{
		if(buttonIndex == 0)
			return;
		else 
		{
//            [self performSelector:@selector(showIndicator)];
            
            appDelegate.isBackup = YES;
            
            //将自动同步关闭
            appDelegate.appSetting.autoSync = @"NO";
            [appDelegate.managedObjectContext save:nil];
            
			//获取文件路径
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;//去处需要的路径
			
			NSError * errors;
			NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"/HoursKeeperBak.zip"];
			ZipArchive* zipFile = [[ZipArchive alloc] init];
			[zipFile UnzipOpenFile:path2];
			
			BOOL ret=[zipFile UnzipFileTo:documentsDirectory overWrite:YES];
			[zipFile UnzipCloseFile];
			[zipFile release];
			[self deleteCutemFile];
			if(ret)
			{
				NSString *path = [appDelegate applicationDocumentsDirectory_location].relativePath;
				NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
				NSString * newPath = nil;
				for (NSString *fname in array)
				{
					if([fname length]>=20)
					{
						if([[fname substringFromIndex:[fname length]-20] isEqualToString:@"HoursKeeper.sqlite.p"])
						{
							newPath = fname;
							break;
						}
					}
				}
                //数据库是可以还原的
				if(newPath!=nil)
				{
                    
                    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                    [defaults2 setInteger:1 forKey:@"IsRestore"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //delete all parse data
//                    AppDelegate_Shared *appDelegate_Shared = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
//                    [appDelegate_Shared.parseSync deleteAllDataonParse];
                    
                    //delete all local data
					newPath = [documentsDirectory stringByAppendingPathComponent:newPath];
					NSDateFormatter * format = [[NSDateFormatter alloc] init];
					[format setDateStyle:NSDateFormatterMediumStyle];
					[format setTimeStyle:NSDateFormatterShortStyle];
					BOOL IsRight = TRUE;
					
					if(IsRight == TRUE)
					{
                        //删除服务器数据
                        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
                        [appDelegate.parseSync deleteAllDataonParse];
                        
						
						NSString * sqlPath = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
						[fileManager removeItemAtPath:sqlPath error:&errors];
						NSString *NewToFilePath = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite"];
						[fileManager moveItemAtPath:newPath toPath:NewToFilePath error:&errors];
                        
                        
                        NSString * newPath2 = nil;
                        for (NSString *fname in array)
                        {
                            if([fname length]>=24)
                            {
                                if([[fname substringFromIndex:[fname length]-24] isEqualToString:@"HoursKeeper.sqlite-wal.p"])
                                {
                                    newPath2 = fname;
                                    break;
                                }
                            }
                        }
                        if (newPath2 != nil)
                        {
                            NSString * sqlPath2 = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
                            [fileManager removeItemAtPath:sqlPath2 error:&errors];
                            NSString *NewToFilePath2 = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-wal"];
                            [fileManager moveItemAtPath:newPath2 toPath:NewToFilePath2 error:&errors];
                        }
                        
                        
                        
                        NSString * newPath3 = nil;
                        for (NSString *fname in array)
                        {
                            if([fname length]>=24)
                            {
                                if([[fname substringFromIndex:[fname length]-24] isEqualToString:@"HoursKeeper.sqlite-shm.p"])
                                {
                                    newPath3 = fname;
                                    break;
                                }
                            }
                        }
                        if (newPath3 != nil)
                        {
                            NSString * sqlPath3 = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
                            [fileManager removeItemAtPath:sqlPath3 error:&errors];
                            NSString *NewToFilePath3 = [documentsDirectory stringByAppendingPathComponent:@"HoursKeeper.sqlite-shm"];
                            [fileManager moveItemAtPath:newPath3 toPath:NewToFilePath3 error:&errors];
                        }
                        
                        
                        [fileManager removeItemAtPath:path2 error:&errors];
						[fileManager removeItemAtPath:newPath error:&errors];
                        
                        
                        //widget 数据转移
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                        {
                            [appDelegate copyDatabase_location_to_widget];
                        }
                        
						UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Hours Keeper data restore complete"
																		  message:@"You must now quit Hours Keeper and re-launch for the new changes to take effect." 
																		 delegate:self
																cancelButtonTitle:@"OK"
																otherButtonTitles:nil];
						alertView.tag = 1;
						[alertView show];
                        
                        appDelegate.close_PopView = alertView;
                        
//						[alertView release];
						
                        
//                        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
//                        [defaults2 setInteger:1 forKey:@"IsRestore"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
						
						NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
												
						for (NSString *fname in array)
						{
							if([fname length]>6)
							{
								if([[fname substringFromIndex:[fname length]-6] isEqualToString:@".jpg.p"])
								{
									NSString * strName = [fname substringToIndex:[fname length]-2];
									[fileManager moveItemAtPath:fname toPath:strName error:&errors];	
								}
							}
						}
						for (NSString *fname in array)
						{
							if([fname length]>2)
							{
								if([[fname substringFromIndex:[fname length]-2] isEqualToString:@".p"])
								{
									[fileManager removeItemAtPath:fname error:&errors];
								}
							}
						}

                        
					}
					else 
					{
						UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Restore Cancelled" 
																		 message:@"The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure." 
																		delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
						[alert show];
                        
                        appDelegate.close_PopView = alert;
                        
						[alert release];
					}
				}
				else 
				{
					UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Restore Cancelled" 
																	 message:@"The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure." 
																	delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					[alert show];
                    
                    appDelegate.close_PopView = alert;
                    
					[alert release];
				}
			}
			else 
			{
				UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Restore Cancelled" 
																 message:@"The current database and the backup should be the same file. Modifying data is always risky so the restore process has been cancelled as a safety measure." 
																delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];

                appDelegate.close_PopView = alert;
                
				[alert release];
			}
		
//            [self hideIndicator];
}
	}
	else if(alertView.tag == 1)
	{
        appDelegate.isBackup = NO;
		exit(1);
	}
}

-(void)showIndicator
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    [appDelegate showIndicator];
}

-(void)hideIndicator
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    [appDelegate hideIndicator];
}
-(BOOL)sureFileRight
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	BOOL relust=NO;
	return YES;
	NSString*	fileName;
	
	NSString*	filepath = [[NSBundle mainBundle] pathForResource:@"Version" ofType:@"plist"];
	NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filepath];
	
	NSString *path = [appDelegate applicationDocumentsDirectory_location].relativePath;
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
    for (NSString *fname in array)
    {
		fileName=fname;
		for(id version in dictionary)
		{
			NSString* v=(NSString*)version;
			NSString*	value=[dictionary valueForKey:v];
			if([fileName compare:value]==NSOrderedSame)
			{
				relust=YES;
			}
		}
	}
	[dictionary release];
	return relust;
	
}
-(void)deleteCutemFile
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	//创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString* path=[appDelegate applicationDocumentsDirectory_location].relativePath;
	NSError * errors = nil;
	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&errors];
	
	NSString *documentsDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;//去处需要的路径
	//更改到待操作的目录下
	[fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
	//获取文件路径
	
	for (NSString *fname in array)
    {
		if([fname compare:@"Update.zip"]==NSOrderedSame)
		{
			[fileManager removeItemAtPath:fname error:nil];
		}
	}
	
}

@end