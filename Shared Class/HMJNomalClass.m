//
//  HMJNomalClass.m
//  HoursKeeper
//
//  Created by humingjing on 15/6/18.
//
//

#import "HMJNomalClass.h"
#import "AppDelegate_Shared.h"
#import "TimeSheetViewController.h"

@implementation HMJNomalClass

#pragma mark Custom Fonts
+(UIFont *)creatFont_AkzidenzGroteskCond_Size:(int)size
{
//    NSLog(@"creatFont_AkzidenzGroteskCond_Size == font:%@",[UIFont familyNames]);
    UIFont *font;
    if(IS_IPHONE_4)
        font = [UIFont fontWithName:@"Akzidenz-Grotesk BQ Condensed A" size:size];
    else
        font = [UIFont fontWithName:FontSFUITextMedium size:size];
	
	if (font == nil)
		font = [UIFont systemFontOfSize:size];
    return font;
}

+(UIFont *)creatFont_HelveticaNeue_Medium:(BOOL)isMedium Size:(int)size
{
	UIFont *font = nil;
    if (isMedium)
    {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
        return font;
    }
    else
    {
        font = [UIFont fontWithName:@"HelveticaNeue" size:size];
        return font;
    }
	
	
	if (font == nil)
		font = [UIFont systemFontOfSize:size];
	return font;
}

+(UIColor *)creatNavigationBarColor_69_153_242
{
    UIColor *navColor = [UIColor colorWithRed:69.f/255.f green:153.f/255.f blue:242.f/255.f alpha:1];
    return navColor;
}

+(UIColor *)creatAmountColor
{
    UIColor *amountColor = [UIColor colorWithRed:255.f/255.f green:168.f/255.f blue:0.f/255.f alpha:1];
    return amountColor;
}
+(UIColor *)creatTableViewHeaderColor
{
    UIColor *headerColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1];
    return headerColor;
}

+(UIColor *)creatLineColor_210_210_210
{
    UIColor *lineColor = [UIColor colorWithRed:210.f/255.f green:210.f/255.f blue:210.f/255.f alpha:1];
    return lineColor;
}

+(UIColor *)creatCellVerticalLineColor_225_225_225
{
    UIColor *lineColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1];
    return lineColor;
}
+(UIColor *)creatGrayColor_152_152_152
{
    UIColor *lineColor = [UIColor colorWithRed:152/255.f green:152/255.f blue:152/255.f alpha:1];
    return lineColor;
}

+(UIColor *)creatAmountBlueColor_107_133_158
{
    UIColor *amountBlueColor = [UIColor colorWithRed:107/255.0 green:133/255.0 blue:158/255.0 alpha:1];
    return amountBlueColor;
}
+(UIColor *)creatBtnBlueColor_17_155_227
{
    UIColor *amountBlueColor = [UIColor colorWithRed:17/255.0 green:177/255.0 blue:227/255.0 alpha:1];
    return amountBlueColor;
}

+(UIColor *)creatGrayColor_164_164_164
{
    UIColor *grayColor = [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1];
    return grayColor;
}

+(UIColor *)creatBlackColor_20_20_20
{
    UIColor *blackColor = [UIColor colorWithRed:20.f/255.0 green:20/255.0 blue:20/255.0 alpha:1];
    return blackColor;
}

+(UIColor *)creatBlackColor_114_114_114
{
    UIColor *black = [UIColor colorWithRed:114.f/255.f green:114.f/255.f blue:114.f/255.f alpha:1];
    return black;
}

+(UIColor *)creatRedColor_244_79_68
{
    UIColor *black = [UIColor colorWithRed:244.f/255.f green:79.f/255.f blue:68.f/255.f alpha:1];
    return black;
}

-(BOOL)judgeifHasUnpaidInvoice
{
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectModel *model = [appDelegate managedObjectModel];
    NSEntityDescription *InvoiceEntity = [[model entitiesByName] valueForKey:@"Invoice"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:InvoiceEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync_status == 0"];
    
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *requests = [context executeFetchRequest:fetchRequest error:nil];
    
    
    //获取到的存在的invoice数组
    NSMutableArray *invoiceArray = [[NSMutableArray alloc] initWithArray:requests];
    for (int i=0; i<[invoiceArray count]; i++)
    {
        //如果该invoice中不存在合法的log，标明这个invoice中没有一个log，那么这个invoice是不应该存在的，应该删除该invoice及其关联
        Invoice *_invoice = [invoiceArray objectAtIndex:i];
        if ([_invoice.balanceDue doubleValue] > 0)
        {
            return YES;
        }
    }
    
    return NO;
    
}

-(NSMutableArray *)getAllOverTimeandMondy
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    long  app_allseconds = 0;
    double app_allmoney = 0.0;
    
    
    //获取所有有效的client
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //over Hours
    NSArray *backArray = [appDelegate overTimeMoney_logs:[appDelegate getOverTime_Log:nil startTime:nil endTime:nil isAscendingOrder:NO]];
    NSNumber *back_money = [backArray objectAtIndex:0];
    NSNumber *back_time = [backArray objectAtIndex:1];
    long seconds = (long)([back_time doubleValue]*3600);
    int overMinutes = (seconds/60)%60;
    long overHours = seconds/3600;
    if (overMinutes>=30)
    {
        overHours = overHours+1;
    }
    [dataArray addObject:[NSNumber numberWithLong:overHours]];

    
    //total hours
    NSArray *requests = [appDelegate getAllClient];
    
    NSMutableArray *all_clientUnitArray = [[NSMutableArray alloc] init];
    NSMutableArray *clientsArray = [[NSMutableArray alloc] initWithArray:requests];
    NSString *client_timelength;
    NSArray *client_timeArray;
    int unit_hours;
    int unit_minutes;
    
    for (Clients *sel_client in clientsArray)
    {
        NSArray *logArray = [appDelegate removeAlready_DeleteLog:[sel_client.logs allObjects]];
        if (logArray> 0)
        {
            NSMutableArray *client_logsArray = [[NSMutableArray alloc] initWithArray:logArray];
            NSSortDescriptor* Order = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
            [client_logsArray sortUsingDescriptors:[NSArray arrayWithObject:Order]];
            
            
            for (; [client_logsArray count]>0 ;)
            {
                Logs *sel_log = [client_logsArray objectAtIndex:0];
                
                Client_Unit *clientData = [[Client_Unit alloc] init];
                
                client_timelength = (sel_log.worked == nil) ? @"0:00":sel_log.worked;
                client_timeArray = [client_timelength componentsSeparatedByString:@":"];
                unit_hours = [[client_timeArray objectAtIndex:0] intValue];
                unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
                clientData.allseconds = unit_hours*3600+unit_minutes*60;
                clientData.allmoney = [sel_log.totalmoney doubleValue];
                
                [clientData.logsArray addObject:sel_log];
                clientData.client = sel_log.client;
                [client_logsArray removeObject:sel_log];
                
                
                NSDate *sel_firstDate = nil;
                NSDate *sel_endDate = nil;
                //设置这个log需要支付的时间段
                [appDelegate getPayPeroid_selClient:sel_client payPeroidDate:sel_log.starttime backStartDate:&sel_firstDate backEndDate:&sel_endDate];
                clientData.client_startDate = sel_firstDate;
                clientData.client_endDate = sel_endDate;
                
                
                for (; [client_logsArray count]>0 ;)
                {
                    Logs *_log = [client_logsArray objectAtIndex:0];
                    
                    if ([sel_firstDate compare:_log.starttime] == NSOrderedDescending)
                    {
                        break;
                    }
                    else
                    {
                        client_timelength = (_log.worked == nil) ? @"0:00":_log.worked;
                        client_timeArray = [client_timelength componentsSeparatedByString:@":"];
                        unit_hours = [[client_timeArray objectAtIndex:0] intValue];
                        unit_minutes = [[client_timeArray objectAtIndex:1] intValue];
                        clientData.allseconds = clientData.allseconds +unit_hours*3600+unit_minutes*60;
                        clientData.allmoney = clientData.allmoney + [_log.totalmoney doubleValue];
                        
                        [clientData.logsArray addObject:_log];
                        [client_logsArray removeObject:_log];
                    }
                }
                
                
                app_allseconds =  + clientData.allseconds;
                app_allmoney = app_allmoney + clientData.allmoney;
                
                
                [all_clientUnitArray addObject:clientData];
            }
            
            
        }
        
    }
    
    //total
    int minutes = (app_allseconds/60)%60;
    long hours = app_allseconds/3600;
    if (minutes>=30)
    {
        hours = hours + 1;
    }
    [dataArray addObject:[NSNumber numberWithLong:hours]];
  
    
    //total money
    double totalMoney = [back_money doubleValue] + app_allmoney;
    [dataArray addObject:[NSNumber numberWithDouble:totalMoney]];
    
    return dataArray;
    
}

#pragma mark string 转换 可用double类型string
-(NSString *)changeStringtoDoubleString:(NSString *)amountString
{
    if ([amountString length]>0)
    {
        while ([amountString rangeOfString:@","].length>0)
        {
            NSString *firstString = [amountString substringWithRange:NSMakeRange(0, [amountString rangeOfString:@","].location)];
            
            NSRange secondRange = NSMakeRange([amountString rangeOfString:@","].location+1, [amountString length]-([amountString rangeOfString:@","].location+1));
            NSString *secondString = [amountString substringWithRange:secondRange];
            
            amountString = [NSString stringWithFormat:@"%@%@",firstString,secondString];
        }
        
        return amountString;
    }
    else
        return amountString;
}


//判断用户是否可以不登陆parse也可以使用app
//-(BOOL)userNeedtoLoginParseorNot
//{
//    
//}

@end
