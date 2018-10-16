//
//  TodayViewController.m
//  Hours Keepr
//
//  Created by XiaoweiYang on 14-12-29.
//
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayTableViewCell.h"

#import "AppDelegate_Shared.h"
#import "Clients.h"



@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSTimer *mainTimer;
@property (nonatomic, assign) float m_witd;
@property (nonatomic, assign) BOOL isPurchased;

-(void)doMainTimer;

@end



@implementation TodayViewController

-(float)getSystemVersion
{
	return [[[UIDevice currentDevice] systemVersion] floatValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isPurchased = YES;
	float sysVersion = [self getSystemVersion];
	if (sysVersion >= 10)
	{
		
//		self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
	}
	
    //widget版本区分
//    #ifdef FULL
//        self.isPurchased = YES;
//    #else
//        NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_Group];
//        if ([sharedUserDefaults integerForKey:LITE_UNLOCK_FLAG])
//        {
//            self.isPurchased = YES;
//        }
//        else
//        {
//            self.isPurchased = NO;
//        }
//    #endif
    
    
    //iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.m_witd = 600;
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=9) {
            self.m_witd = 328;
        }
    }
    //iPhone
    else
    {
        
        self.m_witd = self.view.frame.size.width;
    }
    
    //addBtn
    self.addBtn.layer.cornerRadius = 5;
    [self.addBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){62/255.0, 186/255.0, 255/255.0, 0.4 });
    [self.addBtn.layer setBorderColor:colorref];//边框颜色
    [self.addBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:186/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.addBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10];
    
    //colokBtn
    self.colokBtn.layer.cornerRadius = 5;
    [self.colokBtn.layer setBorderWidth:1.0]; //边框宽度
    [self.colokBtn.layer setBorderColor:colorref];//边框颜色
    [self.colokBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:186/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.colokBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10];

    
    self.colokBtn.frame = CGRectMake(15, self.colokBtn.frame.origin.y, (self.m_witd-50-19)/2-5, self.colokBtn.frame.size.height);
    self.addBtn.frame = CGRectMake(self.colokBtn.frame.origin.x+self.colokBtn.frame.size.width+10, self.addBtn.frame.origin.y, (self.m_witd-50-19)/2-5, self.addBtn.frame.size.height);
    
    
    
    
    [self.moreBtn setHidden:YES];
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.allDataArray = [NSMutableArray array];
    
    if (self.isPurchased == YES)
    {
        NSArray *requests = [self getAllClient];
        [self.allDataArray removeAllObjects];
        for (int i=0; i<[requests count]; i++)
        {
            Clients *_client = [requests objectAtIndex:i];
            
            if (_client.beginTime != nil)
            {
                [self.allDataArray addObject:_client];
            }
        }
        NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"clientName" ascending:YES];
        [self.allDataArray sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
        
        if (self.allDataArray.count > 0)
        {
            //160
            //4-(320,480) 336 4;  5-(320,568) 448-10 6;  6-(375,667) 560-20 8;  6p-(414,736) 616 9;
            int maxCount;
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                if ([UIScreen mainScreen].bounds.size.width > 400)
                {
                    maxCount = 9;
                }
                else if ([UIScreen mainScreen].bounds.size.width > 350)
                {
                    maxCount = 8;
                }
                else
                {
                    maxCount = 6;
                }
            }
            else
            {
                maxCount = 4;
            }
			
			if (sysVersion >= 10) {
				maxCount = 2;
			}
    
            if (maxCount < self.allDataArray.count)
            {
                int count2 = (int)self.allDataArray.count - maxCount;
                NSString *str;
                if (count2 == 1)
                {
                    str = @"client";
                }
                else
                {
                    str = @"clients";
                }
                [self.moreBtn setTitle:[NSString stringWithFormat:@"And %d more %@...",count2,str] forState:UIControlStateNormal];
                NSRange range = {self.allDataArray.count-count2,count2};
                [self.allDataArray removeObjectsInRange:range];
                self.lastCell.frame = CGRectMake(self.lastCell.frame.origin.x, self.lastCell.frame.origin.y, self.lastCell.frame.size.width, 38+56);
                self.moreBtn.frame = CGRectMake(self.moreBtn.frame.origin.x, 10, self.moreBtn.frame.size.width, 29);
                [self.moreBtn setHidden:NO];
                self.addBtn.frame = CGRectMake(self.addBtn.frame.origin.x, 48, self.addBtn.frame.size.width, 29);
                self.colokBtn.frame = CGRectMake(self.colokBtn.frame.origin.x, 48, self.colokBtn.frame.size.width, 29);
            }
			
			if (sysVersion >= 10 && self.allDataArray.count == 2) {
					self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

			}
            self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doMainTimer) userInfo:nil repeats:YES];
            
			self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, self.allDataArray.count*56+self.lastCell.frame.size.height+10);
//			self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
        }
    }
	
    [self.mainTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
//	[super viewWillAppear:animated];
//	if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
//		self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
//	}
//	self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
	if (activeDisplayMode == NCWidgetDisplayModeCompact) {
		
		NSLog(@"maxSize-%@",NSStringFromCGSize(maxSize));// maxSize-{359, 110}
		
		self.preferredContentSize = CGSizeMake(maxSize.width, 50);
		
	}else{
		
		NSLog(@"maxSize-%@",NSStringFromCGSize(maxSize));// maxSize-{359, 616}
		
		self.preferredContentSize = CGSizeMake(maxSize.width, 200);
		
	}
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    //UIEdgeInsets newMarginInsets = UIEdgeInsetsMake(defaultMarginInsets.top, defaultMarginInsets.left - 16, defaultMarginInsets.bottom, defaultMarginInsets.right);
    //return newMarginInsets;
    //return UIEdgeInsetsZero; // 完全靠到了左边....
    return UIEdgeInsetsMake(0, 35, 0, 0);
}





#pragma mark - Costom Methods
-(UIImage*)m_imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)doMainTimer
{
    for (int i=0;i<[self.allDataArray count];i++)
    {
        Clients *ontimerClient = [self.allDataArray objectAtIndex:i];
        
        TodayTableViewCell *mycell = (TodayTableViewCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:i inSection:0]];
        
        int totalSeconds;
        if ([ontimerClient.beginTime compare:[NSDate date]] == NSOrderedDescending)
        {
            mycell.timeLabel.text = [self conevrtTime3:0];
        }
        else
        {
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:ontimerClient.beginTime];
            totalSeconds = (int)timeInterval;
            mycell.timeLabel.text = [self conevrtTime3:totalSeconds];
        }
    }
}

-(IBAction)doAddEntry:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn .tag == 0 || btn.tag == 2)
    {
        [self.extensionContext  openURL:[NSURL URLWithString:WIDGET_URL0] completionHandler:nil];
    }
    else
    {
        [self.extensionContext  openURL:[NSURL URLWithString:WIDGET_URL1] completionHandler:nil];
    }
}

-(NSString *)conevrtTime3:(int)totalSeconds
{
    int seconds = totalSeconds%60;
    int minutes = (totalSeconds/60)%60;
    int hours = totalSeconds/3600;
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    
    return time;
}





#pragma mark - database Methods
-(NSArray *)getAllClient
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObjectModel *model = [self managedObjectModel];
    NSEntityDescription *clientsEntity = [[model entitiesByName] valueForKey:@"Clients"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *defaultClientName = @"#*Invisible%Default&Client*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientName != %@ AND (sync_status == 0)",defaultClientName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setEntity:clientsEntity];
    [fetchRequest setPredicate:predicate];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    return requests;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ != nil)
    {
        return managedObjectContext_;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HoursKeeper" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator_ != nil)
    {
        return persistentStoreCoordinator_;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSURL *storeURL2 = [self applicationDocumentsDirectory];
    NSURL *storeURL = [storeURL2 URLByAppendingPathComponent:@"HoursKeeper.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator_;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager]
            containerURLForSecurityApplicationGroupIdentifier:WIDGET_Group];
}






#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.allDataArray.count + 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.allDataArray.count)
    {
        return self.lastCell.frame.size.height;
    }
    else
    {
        return 56;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.allDataArray.count)
    {
        return self.lastCell;
    }
    else
    {
        NSString* identifier = @"widget-timerCell-Identifier";
        TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//		cell.backgroundColor = [UIColor blackColor];
        Clients *client  = self.allDataArray[indexPath.row];
        cell.nameLabel.text = client.clientName;
        
        float witd = self.m_witd - 35;
        cell.timeLabel.frame = CGRectMake(witd-19-98, 0, 98, 56);
        cell.nameLabel.frame = CGRectMake(15, 0, witd-cell.timeLabel.frame.size.width-15-3-19, 56);
		
		float version = [self getSystemVersion];
		if (version >= 0)
		{
			cell.timeLabel.textColor = [UIColor blackColor];
			cell.nameLabel.textColor = [UIColor blackColor];
		}
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != self.allDataArray.count)
    {
        NSString *str = [NSString stringWithFormat:@"%@%d",WIDGET_URL0,(int)indexPath.row];
        [self.extensionContext  openURL:[NSURL URLWithString:str] completionHandler:nil];
    }
}


@end

