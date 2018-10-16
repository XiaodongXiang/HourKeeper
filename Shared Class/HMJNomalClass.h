//
//  HMJNomalClass.h
//  HoursKeeper
//
//  Created by humingjing on 15/6/18.
//
//

#import <Foundation/Foundation.h>

@interface HMJNomalClass : NSObject

//font
+(UIFont *)creatFont_AkzidenzGroteskCond_Size:(int)size;
+(UIFont *)creatFont_HelveticaNeue_Medium:(BOOL)isMedium Size:(int)size;

+(UIColor *)creatNavigationBarColor_69_153_242;
+(UIColor *)creatAmountColor;
+(UIColor *)creatTableViewHeaderColor;
+(UIColor *)creatLineColor_210_210_210;
+(UIColor *)creatCellVerticalLineColor_225_225_225;
+(UIColor *)creatAmountBlueColor_107_133_158;
+(UIColor *)creatBtnBlueColor_17_155_227;
+(UIColor *)creatGrayColor_164_164_164;
+(UIColor *)creatGrayColor_152_152_152;
+(UIColor *)creatBlackColor_20_20_20;
+(UIColor *)creatBlackColor_114_114_114;
+(UIColor *)creatRedColor_244_79_68;

-(BOOL)judgeifHasUnpaidInvoice;
-(NSMutableArray *)getAllOverTimeandMondy;


-(NSString *)changeStringtoDoubleString:(NSString *)amountString;

//-(BOOL)userNeedtoLoginParseorNot;

@end
