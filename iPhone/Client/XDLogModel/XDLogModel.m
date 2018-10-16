//
//  XDLogModel.m
//  HoursKeeper
//
//  Created by 下大雨 on 2018/8/8.
//

#import "XDLogModel.h"
#import "AppDelegate_iPhone.h"


@implementation XDLogModel

-(float)totalAmount{
    
    Clients* client = _client;
    Logs* log = _log;
    
    double weekRate = [client.r_weekRate doubleValue] / 60;
    double dayRate = [self rateWithDay:log.starttime];
    //have weekly overtime
    if (([client.weeklyOverFirstHour integerValue] >= 0 && ![client.weeklyOverFirstTax isEqualToString:@"none"]) || ([client.weeklyOverSecondHour integerValue] >= 0 && ![client.weeklyOverSecondTax isEqualToString:@"none"])) {
        
        //获取周的开始时间
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        NSInteger firstDay = [appDelegate getFirstDayForWeek];
        
        NSDate *beginDate = nil;
        double interval = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:firstDay];//设定周首日
        [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:log.starttime];
        NSArray* dataArr = [client.logs allObjects];
        NSDate* initToday = [log.starttime initDate];

        
        NSArray* filterArr = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"starttime >= %@ and starttime < %@",beginDate,log.starttime]];
        NSArray* dayFilterArr = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"starttime >= %@ and starttime < %@",initToday,log.starttime]];
        float dayOverTime = 0;
        if (dayFilterArr) {
            for (Logs* filterLog in dayFilterArr) {
                
                NSArray* timeArr = [filterLog.worked componentsSeparatedByString:@":"];
                NSInteger hour = [timeArr.firstObject integerValue];
                NSInteger minute = [timeArr.lastObject integerValue];
                
                dayOverTime += hour * 60 + minute;
            }
        }
        
        float weekOverTime = 0;
        if (filterArr) {
            for (Logs* filterLog in filterArr) {
                
                NSArray* timeArr = [filterLog.worked componentsSeparatedByString:@":"];
                NSInteger hour = [timeArr.firstObject integerValue];
                NSInteger minute = [timeArr.lastObject integerValue];
                
                weekOverTime += hour * 60 + minute;
            }
        }

        NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
        NSInteger hour = [timeArr.firstObject integerValue];
        NSInteger minute = [timeArr.lastObject integerValue];
        NSInteger allMin = hour * 60 + minute;
        
        // weekly overtime and daily overtime
        if (([client.dailyOverFirstHour integerValue] >= 0 && ![client.dailyOverFirstTax isEqualToString:@"none"]) ||([client.dailyOverSecondHour integerValue] >= 0 && ![client.dailyOverSecondTax isEqualToString:@"none"])) {
            
            NSInteger dayFirstH = 0;
            NSInteger daySecondH = 0;
            NSInteger weekFirstH = 0;
            NSInteger weeksecondH = 0;
            double dayFirstTax = 0;
            double daySecondTax = 0;
            double weekFirstTax = 0;
            double weekSecondTax = 0;
            
            if ([client.dailyOverFirstHour integerValue] >= 0 && ![client.dailyOverFirstTax isEqualToString:@"none"]) {
                dayFirstH = [client.dailyOverFirstHour integerValue] * 60;
                NSString* myString = [client.dailyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                dayFirstTax = [myString doubleValue];
            }
            
            if ([client.dailyOverSecondHour integerValue] >= 0 && ![client.dailyOverSecondTax isEqualToString:@"none"]) {
                daySecondH = [client.dailyOverSecondHour integerValue] * 60;
                NSString* myString = [client.dailyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                daySecondTax = [myString doubleValue];
            }
            
            if ([client.weeklyOverFirstHour integerValue] >= 0 && ![client.weeklyOverFirstTax isEqualToString:@"none"]) {
                weekFirstH = [client.weeklyOverFirstHour integerValue] * 60;
                NSString* myString = [client.weeklyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                weekFirstTax = [myString doubleValue];
            }
            
            if ([client.weeklyOverSecondHour integerValue] >= 0 && ![client.weeklyOverSecondTax isEqualToString:@"none"]) {
                weeksecondH = [client.weeklyOverSecondHour integerValue] * 60;
                NSString* myString = [client.weeklyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                weekSecondTax = [myString doubleValue];
            }
            
            if (dayFirstTax != 0 && daySecondTax != 0 ) {
                
                //1.两个周加班时间 ， 两个日加班时间
                if(weekFirstTax != 0  && weekSecondTax != 0){
                    if (dayFirstH > daySecondH) {
                        NSInteger tempH = daySecondH;
                        double tempTax = daySecondTax;
                        
                        daySecondH = dayFirstH;
                        dayFirstH = tempH;
                        
                        daySecondTax = dayFirstTax;
                        dayFirstTax = tempTax;
                    }
                    if (weekFirstH > weeksecondH) {
                        NSInteger tempH = weeksecondH;
                        double tempTax = weekSecondTax;
                        
                        weeksecondH = weekFirstH;
                        weekFirstH = tempH;
                        
                        weekSecondTax = weekFirstTax;
                        weekFirstTax = tempTax;
                    }
                    //没有周加班时间
                    if (allMin <= (weekFirstH - weekOverTime)) {
                        //无日加班时间
                        if (allMin + dayOverTime <= dayFirstH) {
                            return allMin * dayRate;
                            
                            //加班时间夸日的不加班时间 和第一个加班时间
                        }else if((allMin + dayOverTime) > dayFirstH && (allMin + dayOverTime) <= daySecondH){
                            
                            return (dayFirstH - dayOverTime) * dayRate + (allMin - (dayFirstH - dayOverTime))* dayRate * dayFirstTax;
                            
                        }else if (dayOverTime >= dayFirstH && dayOverTime < daySecondH){
                            
                            if (allMin + dayOverTime <= daySecondH) {//加班时间在第一个日加班时间内
                                return allMin * dayFirstTax * dayRate;
                            }else if(allMin + dayOverTime > daySecondH){//大于第二个加班时间
                                return (daySecondH - dayOverTime) * dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }
                        }else if (dayOverTime >= daySecondH){
                            return allMin * dayRate * daySecondTax;

                        }else{//加班时间夸日的三个工作时间段
                            
                            return (dayFirstH - dayOverTime) * dayRate + (daySecondH - dayFirstH) * dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                        }
                        
                    }else if((allMin + weekOverTime) > weekFirstH && (allMin + weekOverTime) <= weeksecondH){
                        if(allMin + dayOverTime <= dayFirstH){
                            return (weekFirstH - weekOverTime) * dayRate + (allMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax;
                        }else if((allMin + dayOverTime) > dayFirstH && (allMin + dayOverTime) <= daySecondTax){
                            NSInteger dayFirstMin = dayFirstH - dayOverTime;
                            //第一段工作时间 不在周加班时间内
                            if (dayFirstMin <= (weekFirstH - weekOverTime)) {
                                return dayFirstMin * dayRate + (allMin - dayFirstMin) * dayRate * dayFirstTax;
                            }else{
                                return (weekFirstH - weekOverTime) * dayRate + (dayFirstMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (allMin - dayFirstMin) * dayRate * dayFirstTax;
                            }
                        }else{ //有两个日加班时间
                            NSInteger dayFirstMin = dayFirstH - dayOverTime;
                            if (dayFirstMin <= 0) { //超过第一个日加班时间
                                if (allMin + dayOverTime > daySecondH) {
                                    return (daySecondH - dayOverTime) * dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                                }
                            }else if (daySecondH - dayOverTime <= 0){//超过第二个日加班时间
                                return allMin * dayRate * daySecondTax;
                            }else if (dayFirstMin <= (weekFirstH - weekOverTime)) {
                                
                                return dayFirstMin * dayRate + (daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }else{
                                return (weekFirstH - weekOverTime) * dayRate +  (dayFirstMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }
                        }
                    }else if((allMin + weekOverTime) > weeksecondH && weekOverTime <= weeksecondH){
                        if (allMin + dayOverTime <= dayFirstH) {
                           return  (weekFirstH - weekOverTime) * dayRate + (weeksecondH - weekFirstH) * weekRate * weekFirstTax + (allMin + weekOverTime - weeksecondH)* weekRate * weekSecondTax;
                        }else if((allMin + dayOverTime) > dayFirstH && (allMin + dayOverTime) <= daySecondTax){
                            NSInteger dayFirstMin = dayFirstH - dayOverTime;
                            //第一段工作时间 不在周加班时间内
                            if (dayFirstMin <= (weekFirstH - weekOverTime)) {
                                return dayFirstMin * dayRate + (allMin - dayFirstMin) * dayRate * dayFirstTax;
                            }else if(dayFirstMin <= (weeksecondH - weekOverTime)){
                                return dayFirstMin * dayRate + (dayFirstH - weekFirstH) * weekFirstTax * weekRate +(daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }else{
                                return dayFirstMin * dayRate + (weeksecondH - weekFirstH) * weekFirstTax * weekRate + (dayFirstH - weeksecondH) * weekRate * weekSecondTax + (daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }
                        }
                    }else{
                        
                    }
                    
                }else{ //2.一个周加班时间 ， 两个日加班时间
                    if(weekSecondTax != 0 && weekFirstTax == 0){
                        weekFirstH = weeksecondH;
                        weekFirstTax = weekSecondTax;
                    }
                    
                    if (dayFirstH > daySecondH) {
                        NSInteger tempH = daySecondH;
                        double tempTax = daySecondTax;
                        
                        daySecondH = dayFirstH;
                        dayFirstH = tempH;
                        
                        daySecondTax = dayFirstTax;
                        dayFirstTax = tempTax;
                    }
                    //没有周加班时间
                    if (allMin + weekOverTime <= weekFirstH) {
                        
                        //无日加班时间
                        if (allMin + dayOverTime <= dayFirstH) {
                            return allMin * dayRate;
                            
                            //加班时间夸日的不加班时间 和第一个加班时间
                        }else if((allMin + dayOverTime) > dayFirstH && (allMin + dayOverTime) <= daySecondTax){
                            
                            return (dayFirstH - dayOverTime) * dayRate + (allMin - (dayFirstH - dayOverTime))* dayRate * dayFirstTax;
                            //加班时间夸日的三个工作时间段
                        }else{
                            
                            return (dayFirstH - dayOverTime) * dayRate + (daySecondH - dayFirstH) * dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                        }
                        
                    }else{//有周加班时间
                        
                        if(allMin + dayOverTime <= dayFirstH){
                            return (weekFirstH - weekOverTime) * dayRate + (allMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax;
                        }else if((allMin + dayOverTime) > dayFirstH && (allMin + dayOverTime) <= daySecondTax){
                            NSInteger dayFirstMin = dayFirstH - dayOverTime;
                            //第一段工作时间 不在周加班时间内
                            if (dayFirstMin <= (weekFirstH - weekOverTime)) {
                                return dayFirstMin * dayRate + (allMin - dayFirstMin) * dayRate * dayFirstTax;
                            }else{
                                return (weekFirstH - weekOverTime) * dayRate + (dayFirstMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (allMin - dayFirstMin) * dayRate * dayFirstTax;
                            }
                        }else{ //有两个日加班时间
                            NSInteger dayFirstMin = dayFirstH - dayOverTime;
                            if (dayFirstMin <= (weekFirstH - weekOverTime)) {
                                
                                return dayFirstMin * dayRate + (daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }else{
                               return (weekFirstH - weekOverTime) * dayRate +  (dayFirstMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (daySecondH - dayFirstH)*dayRate * dayFirstTax + (allMin + dayOverTime - daySecondH) * dayRate * daySecondTax;
                            }
                        }
                    }
                }
                
                
                
            }else{
                //3.两个周加班时间 ， 一个日加班时间
                
                if(weekFirstTax != 0  && weekSecondTax != 0 ){
                    if(daySecondTax != 0 && dayFirstTax == 0){
                        dayFirstH = daySecondH;
                        dayFirstTax = daySecondTax;
                    }
                    if (weekFirstH > weeksecondH) {
                        NSInteger tempH = weeksecondH;
                        double tempTax = weekSecondTax;
                        
                        weeksecondH = weekFirstH;
                        weekFirstH = tempH;
                        
                        weekSecondTax = weekFirstTax;
                        weekFirstTax = tempTax;
                    }
                    // 加班时间小于周开始加班时间
                    if (allMin <= (weekFirstH - weekOverTime)) {
                        //无日加班时间
                        if (allMin <= (dayFirstH - dayOverTime)) {
                            return allMin * dayRate;
                            //有第一段加班时
                        }else{
                            return (dayFirstH - dayOverTime) * dayRate + (allMin - (dayFirstH - dayOverTime)) * dayRate * dayFirstTax;
                        }
                        
                    }else if((allMin + weekOverTime) >  weekFirstH && (allMin + weekOverTime) < weeksecondH){ //加班结束时间在第一个周加班时间内
                        //无日加班时间
                        if (allMin <= (dayFirstH - dayOverTime)) {
                            return (weekFirstH - weekOverTime) * weekRate + (allMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax;
                        }else{//有日加班时间
                            
                            NSInteger dayFirstAllMin = dayFirstH - dayOverTime;
                            if (dayFirstAllMin <= (weekFirstH - weekOverTime)) {
                                return dayFirstAllMin * dayRate + (allMin - dayFirstAllMin) * dayRate * dayFirstTax;
                            }else{
                                return (weekFirstH - weekOverTime) * dayRate +  (dayFirstAllMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (allMin - dayFirstAllMin) * dayRate * dayFirstTax;
                            }
                        }
                        
                        
                    }else{//加班开始时间在第二个周加班时间内
                        
                        //无日加班时间
                        if (allMin <= (dayFirstH - dayOverTime)) {
                            return (weekFirstH - weekOverTime) * weekRate + (weeksecondH - weekFirstH) * weekRate * weekFirstTax + (allMin + weekOverTime - weeksecondH) * weekRate * weekSecondTax;
                            //有日加班时间
                        }else{
                            NSInteger dayFirstAllMin = dayFirstH - dayOverTime;
                            //日不加班时间可能跨分周的三个时间段
                            if (dayFirstAllMin <= (weekFirstH - weekOverTime)) {
                                return dayFirstAllMin * weekRate + (allMin - dayFirstAllMin) * dayRate * dayFirstTax;
                            }else if ((dayFirstAllMin + weekOverTime) >= weekFirstH && (dayFirstAllMin + weekOverTime) < weeksecondH){
                                return (weekFirstH - weekOverTime)* weekRate + (dayFirstAllMin - (weekFirstH - weekOverTime)) * weekRate * weekFirstTax + (allMin - dayFirstAllMin) * dayRate * dayFirstTax;
                            }else{
                                return (weekFirstH - weekOverTime)* weekRate + (weeksecondH - weekFirstH) * weekRate * weekFirstTax + (dayFirstAllMin + weekOverTime - weeksecondH) * weekRate * weekSecondTax + (allMin - dayFirstAllMin) * dayRate * dayFirstTax;
                            }
                        }
                    }
                }else{//4.一个周加班时间 ， 一个日加班时间
                    
                    if(daySecondTax != 0 && dayFirstTax == 0){
                        dayFirstH = daySecondH;
                        dayFirstTax = daySecondTax;
                    }
                    if(weekSecondTax != 0 && weekFirstTax == 0){
                        weekFirstH = weeksecondH;
                        weekFirstTax = weekSecondTax;
                    }
                    
                    //当加班时间在周加班时间范围内
                    if (allMin <= (weekFirstH - weekOverTime)) {
                        //无加班时间
                        if (allMin <= (dayFirstH - dayOverTime)) {
                            return allMin * dayRate;
                        }else{
                            return (dayFirstH - dayOverTime) * dayRate + (allMin - (dayFirstH - dayOverTime)) * dayRate * dayFirstTax;
                        }
                    }else{//加班时间超过了周加班时间
                        if (allMin <= (dayFirstH - dayOverTime)) {
                            return allMin * weekRate * weekFirstTax;
                        }else{
                            return (dayFirstH - dayOverTime) * weekRate + weekFirstTax + (allMin - (dayFirstH - dayOverTime)) * dayRate * dayFirstTax;
                        }
                    }
                }
            }
            
        }else{ //have weekly overtime and NO daily overtime
            if ([client.weeklyOverFirstHour integerValue]>=0 && ![client.weeklyOverFirstTax isEqualToString:@"none"] && [client.weeklyOverSecondHour integerValue] >= 0 && ![client.weeklyOverSecondTax isEqualToString:@"none"]) {//两个周加班时间
                NSInteger firstH = 0;
                NSInteger secondH = 0;
                float firstTax = 0;
                float secondTax = 0;
                if ([client.weeklyOverFirstHour integerValue] <= [client.weeklyOverSecondHour integerValue]) {
                    firstH = [client.weeklyOverFirstHour integerValue] * 60;
                    secondH = [client.weeklyOverSecondHour integerValue] * 60;
                    NSString* myString = [client.weeklyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                    NSString* myString2 = [client.weeklyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    secondTax = [myString2 doubleValue];
                }else{
                    firstH = [client.weeklyOverSecondHour integerValue] * 60;
                    secondH = [client.weeklyOverFirstHour integerValue] * 60;
                    NSString* myString = [client.weeklyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                    NSString* myString2 = [client.weeklyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    secondTax = [myString2 doubleValue];
                }
                if (weekOverTime <= firstH) {//工作开始时间在正常工作时间范围内
                    if (allMin <= (firstH - weekOverTime)) {//没加班
                        return allMin * weekRate;
                    }else{
                        NSInteger firstPeriod = firstH - weekOverTime;
                        if ((allMin - firstPeriod) <= (secondH - firstH)) {//加班到第一个加班时间
                            return firstPeriod * weekRate + (allMin - firstPeriod) * weekRate * firstTax;
                        }else{
                            NSInteger secondPeriod = allMin - firstPeriod - (secondH - firstH);
                            return firstPeriod * weekRate + (secondH - firstH) * weekRate * firstTax + secondPeriod * weekRate * secondTax;
                        }
                    }
                }else if (weekOverTime > firstH && weekOverTime <= secondH){//工作开始时间在第一个加班时间范围内
                    if (allMin <= (secondH - weekOverTime)) {//开始加班时间在第一个加班时间范围内
                        return  allMin * weekRate * firstTax;
                    }else{
                        return (secondH - weekOverTime) * weekRate * firstTax + (allMin - (secondH - weekOverTime)) * weekRate * secondTax;
                    }
                }else{//工作开始时间在第二个加班范围内
                    return allMin * weekRate * secondTax;
                }
                
                
            }else{//一个周加班时间
                NSInteger firstH = 0;
                float firstTax = 0;
                
                if ([client.weeklyOverFirstHour integerValue] >= 0 && ![client.weeklyOverFirstTax isEqualToString:@"none"] && [client.weeklyOverSecondTax isEqualToString:@"none"]) {
                    firstH = [client.weeklyOverFirstHour integerValue] * 60;
                    NSString* myString = [client.weeklyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                }else if([client.weeklyOverSecondHour integerValue] >= 0 && ![client.weeklyOverSecondTax isEqualToString:@"none"] && [client.weeklyOverFirstTax isEqualToString:@"none"]){
                    firstH = [client.weeklyOverSecondHour integerValue] * 60;
                    NSString* myString = [client.weeklyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                }
                if (weekOverTime <= firstH) {//工作时间在未超出加班时间范围内
                    if (allMin <= (firstH - weekOverTime)) {//没加班œ
                        return allMin * weekRate;
                    }else{//有加班
                        NSInteger firstPeriod = firstH - weekOverTime;
                        return firstPeriod * weekRate + (allMin -  firstPeriod) * weekRate* firstTax;
                    }
                }else{//超出加班时间
                    return allMin * weekRate * firstTax;
                }
            }
        }
        
    }else{ //no weekly overtime and have daily overtime
        if (([client.dailyOverFirstHour integerValue] >= 0 && ![client.dailyOverFirstTax isEqualToString:@"none"]) ||([client.dailyOverSecondHour integerValue] >= 0 && ![client.dailyOverSecondTax isEqualToString:@"none"])) {
            NSArray* dataArr = [client.logs allObjects];
            NSDate* initToday = [log.starttime initDate];
            NSArray* filterArr = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"starttime >= %@ and starttime < %@",initToday,log.starttime]];
            
            float overTime = 0;
            if (filterArr) {
                for (Logs* filterLog in filterArr) {
                    
                    NSArray* timeArr = [filterLog.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    
                    overTime += hour * 60 + minute;
                }
            }
            // 两个加班时间都有
            if ([client.dailyOverFirstHour integerValue] >= 0 && ![client.dailyOverFirstTax isEqualToString:@"none"] && ([client.dailyOverSecondHour integerValue] >= 0 && ![client.dailyOverSecondTax isEqualToString:@"none"])) {
                
                NSInteger firstH = 0;
                NSInteger secondH = 0;
                float firstTax = 0;
                float secondTax = 0;
                
                if ([client.dailyOverFirstHour integerValue] <= [client.dailyOverSecondHour integerValue]) {
                    firstH = [client.dailyOverFirstHour integerValue] * 60;
                    secondH = [client.dailyOverSecondHour integerValue] * 60;
                    
                    NSString* myString = [client.dailyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                    NSString* myString2 = [client.dailyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    secondTax = [myString2 doubleValue];
                }else{
                    secondH = [client.dailyOverFirstHour integerValue] * 60;
                    firstH = [client.dailyOverSecondHour integerValue] * 60;
                    
                    NSString* myString = [client.dailyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    firstTax = [myString doubleValue];
                    NSString* myString2 = [client.dailyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    secondTax = [myString2 doubleValue];
                }
                
                //小于加班时间
                if (overTime < firstH) {
                    NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    NSInteger allMin = hour * 60 + minute;
                    
                    NSInteger firstPeriod = firstH - overTime;
                    NSInteger firstCalcute = allMin - firstPeriod;
                    if (firstCalcute > 0) { // 工作时间超出了正常工作时间
                        float total = firstPeriod * dayRate;
                        
                        if (firstCalcute - (secondH - firstH) > 0) { // 加班时间超出了第二个加班时间
                            float secondMoney = (secondH - firstH) * dayRate * firstTax;
                            
                            total += secondMoney;

                            float thirdMonty = (allMin - firstPeriod - (secondH - firstH)) * dayRate * secondTax;
                            
                            total += thirdMonty;
                            
                        }else{//加班时间在第一个加班时间里
                            NSInteger secondPeriod = allMin - firstPeriod;
                            total += secondPeriod * dayRate * firstTax;
                            return total;
                        }
                        
                    }else{//正常工作时间
                        float total = dayRate * allMin;
                        return total;

                    }
                    
                    
                    
                }else if(overTime >= secondH){ //大于第二次加班时间
                    NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    NSInteger allMin = hour * 60 + minute;
                    
                    return allMin * dayRate * secondTax;
                    
                }else if (overTime >= firstH && overTime < secondH){ //大于第一次加班时间，小于第二次加班时间
                    NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    NSInteger allMin = hour * 60 + minute;
                    
                    if (overTime + allMin <= secondH) {//加班时间小于第二个加班时间
                        float total = allMin * dayRate * firstTax;
                        return total;
                    }else{//加班时间大于第二个加班时间
                        NSInteger firstPeriod = secondH - overTime;
                        float total = firstPeriod * dayRate * firstTax;
                        
                        total += (allMin - firstPeriod) * dayRate * secondTax;
                        return total;
                    }
                }
                
            }else{ //只有一个加班时间
                NSInteger hour = 0;
                float tax = 0;
                
                if ([client.dailyOverSecondHour integerValue] >= 0 && ![client.dailyOverSecondTax isEqualToString:@"none"] && [client.dailyOverFirstTax isEqualToString:@"none"]) {
                    hour = [client.dailyOverSecondHour integerValue] * 60;
                    NSString* myString = [client.dailyOverSecondTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    tax = [myString doubleValue];
                }else if ([client.dailyOverFirstHour integerValue] >= 0 && ![client.dailyOverFirstTax isEqualToString:@"none"] && [client.dailyOverSecondTax isEqualToString:@"none"]){
                    hour = [client.dailyOverFirstHour integerValue] * 60;
                    NSString* myString = [client.dailyOverFirstTax stringByReplacingOccurrencesOfString:@"X" withString:@""];
                    tax = [myString doubleValue];
                }
                if (overTime <= hour) {
                    NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    NSInteger allMin = hour * 60 + minute;
                    if (hour - overTime >= allMin) { //没有加班
                        float total = allMin * dayRate;
                        return total;
                    }else{//加班了
                        NSInteger firstPeriod = hour - overTime;
                        float total = firstPeriod * dayRate + (allMin - firstPeriod) * dayRate * tax;
                        
                        return total;
                    }
                   
                }else{ //加班时间大于正常工作时间
                    NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
                    NSInteger hour = [timeArr.firstObject integerValue];
                    NSInteger minute = [timeArr.lastObject integerValue];
                    NSInteger allMin = hour * 60 + minute;

                    float total = dayRate * allMin;
                    
                    return total * tax;
                    
                }
                
            }
            
        }else{ //no weekly overtime and NO daily overtime
            
            NSArray* timeArr = [log.worked componentsSeparatedByString:@":"];
            NSInteger hour = [timeArr.firstObject integerValue];
            NSInteger minute = [timeArr.lastObject integerValue];
            NSInteger allMin = hour * 60 + minute;

            float total = allMin * dayRate;
            
            return total;
        }
    }
    
    return 0.;
}

-(double)rateWithDay:(NSDate*)date{
    Clients* client = _client;
    if (![client.r_isDaily boolValue]) {
        return [client.ratePerHour floatValue] / 60;
    }else{
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comps = [cal components:NSCalendarUnitWeekday fromDate:date];
        NSInteger index = [comps weekday];
        double amount = 0;
        switch (index) {
            case 1:
                amount = [client.r_sunRate floatValue] / 60;
                break;
            case 2:
                amount = [client.r_monRate floatValue] / 60;
                break;
            case 3:
                amount = [client.r_tueRate floatValue] / 60;
                break;
            case 4:
                amount = [client.r_wedRate floatValue] / 60;
                break;
            case 5:
                amount = [client.r_thuRate floatValue] / 60;
                break;
            case 6:
                amount = [client.r_friRate floatValue] / 60;
                break;
            case 7:
                amount = [client.r_satRate floatValue] / 60;
                break;
            default:
                break;
        }
        
        if (amount == 0) {
            amount = [client.r_weekRate floatValue] / 60;
        }
        return amount;
    }
    
    return 0;
}

-(NSDate *)startTime{
    return _log.starttime;
}


@end
