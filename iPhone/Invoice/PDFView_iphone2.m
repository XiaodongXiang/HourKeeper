//
//  PDFView_iphone2.m
//  HoursKeeper
//
//  Created by xy_dev on 8/21/13.
//
//

#import "PDFView_iphone2.h"

#import "FileController.h"
#import "AppDelegate_Shared.h"

#import "Logs.h"
#import "Clients.h"
#import "Profile.h"




@implementation PDFView_iphone2


@synthesize _invoice;

@synthesize theScrollView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        theScrollView = [[ReaderScrollView alloc] initWithFrame:frame];
        theScrollView.userInteractionEnabled = TRUE;
        theScrollView.pagingEnabled = TRUE;
        theScrollView.scrollsToTop = NO;
        theScrollView.directionalLockEnabled = YES;
        theScrollView.showsVerticalScrollIndicator = NO;
        theScrollView.showsHorizontalScrollIndicator = NO;
        theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        theScrollView.contentSize = theScrollView.bounds.size;
        theScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:theScrollView ];
        
        
        self.backgroundColor = [UIColor clearColor];
        page1 = 17;
        pageN = 29;
        pdfWith = 600;
        pdfHigh = 800;
    }
    
    return self;
}






/**
    绘图
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    NSString *saveDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;
    NSString *saveFileName = @"myPDF.pdf";
    NSString *newFilePath = [saveDirectory stringByAppendingPathComponent:saveFileName];
    const char *filename = [newFilePath UTF8String];
    
    CFStringRef path;
    CFURLRef url;
    CFMutableDictionaryRef myDictionary = NULL;
    path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    CFRelease(myDictionary);
    CFRelease(url);
    
    CGRect pageRect = CGRectMake(0, 0, pdfWith, pdfHigh);
    UIGraphicsBeginPDFContextToFile(newFilePath, pageRect, [NSDictionary dictionary]);
	
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(pdfContext, FALSE);
    
    [self doCreate_Pdf:self._invoice _CGContextRef:pdfContext];
    
    
    
    //view
    {
        NSString *saveDirectory = [appDelegate applicationDocumentsDirectory_location].relativePath;
        NSString *saveFileName = @"myPDF.pdf";
        NSString *newFilePath = [saveDirectory stringByAppendingPathComponent:saveFileName];
        const char *filename = [newFilePath UTF8String];
        
        CFStringRef path;
        CFURLRef url;
        path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
        url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL (url);
        CFRelease (path);
        CFRelease(url);
        
        int pdfPageCount = (int)CGPDFDocumentGetNumberOfPages (pdf);

        NSURL *fileURL = [NSURL fileURLWithPath:newFilePath];
        theScrollView.contentSize = CGSizeMake(pdfPageCount*theScrollView.frame.size.width,0);
        for (UIView *_tmpview in [theScrollView subviews])
        {
            [_tmpview removeFromSuperview];
        }

        for (int i=1; i<=pdfPageCount; i++)
        {
            ReaderContentView	*thePDFView1 = [[ReaderContentView alloc] initWithFrame:CGRectMake(theScrollView.frame.size.width*(i-1),0,theScrollView.frame.size.width, theScrollView.frame.size.height) fileURL:fileURL page:i password:nil];
            
            [theScrollView addSubview:thePDFView1];
        }
    }
}







- (void)doCreate_Pdf:(Invoice *)invoice _CGContextRef:(CGContextRef)_context
{
    UIGraphicsBeginPDFPage();
    
    //画首部
    float middleFirst = [self drawFirst:invoice _CGContextRef:_context];
    
    //画中部
    float lastHigh = [self drawMiddle:invoice _CGContextRef:_context _beginHigh:middleFirst];
    
    //画尾部
    [self drawLast:invoice _CGContextRef:_context _beginHigh:lastHigh];
    
    UIGraphicsEndPDFContext();
}

- (float)drawFirst:(Invoice *)invoice _CGContextRef:(CGContextRef)_context
{
    
    float middleFirst = 311;

    float startHigh = 30;
    
    AppDelegate_Shared *appDelegate_iPhone = (AppDelegate_Shared *)[[UIApplication sharedApplication]delegate];
    NSError *error = nil;
    Profile *localProfile;
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:PF_TABLE_PROFILE];
    NSArray *objects = [appDelegate_iPhone.managedObjectContext executeFetchRequest:fetch error:&error];
    if ([objects count]>0)
    {
        localProfile = [appDelegate_iPhone.parseSync getLocalOnly_Data:objects tableName:PF_TABLE_PROFILE];
    }
    
    UIImage *headImage = nil;
    if (localProfile.headImage != nil)
    {
        headImage = localProfile.headImage;
    }
    else
    {
        headImage = [UIImage imageNamed:@"defaulthead_portrait"];
        
    }
    [headImage drawInRect:CGRectMake(30.0, startHigh, 105.0, 105.0)];
    
    //head image
//    NSString *headpath = [[FileController documentPath] stringByAppendingPathComponent:@"head.png"];
//	if ([[NSFileManager defaultManager] fileExistsAtPath:headpath])
//    {
//		UIImage *headImage = [UIImage imageWithContentsOfFile:headpath];
//        [headImage drawInRect:CGRectMake(30.0, startHigh, 105.0, 105.0)];
//
//	}
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
	NSManagedObjectModel *model = [appDelegate managedObjectModel];
	NSManagedObjectContext *datacontext = [appDelegate managedObjectContext];
    
    //获取所有的profile
	NSEntityDescription *profileEntity = [[model entitiesByName] valueForKey:@"Profile"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:profileEntity];
	NSArray *result = [datacontext executeFetchRequest:fetchRequest error:nil];
	NSString *username = @"";
	NSString *usercompany = @"";
	NSString *userphone = @"";
	NSString *useremail = @"";
    NSString *userfax = @"";
    NSString *useraddress1 = @"";
    NSString *useraddress2 = @"";
    
    //设置第一个profile参数为一个变量的参数
	if ([result count]>0)
    {
		Profile *profile = [result objectAtIndex:0];
        if([profile.firstName length]>0 && [profile.lastName length]>0)
        {
            username = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        }
        else if ([profile.firstName length]>0)
        {
            username = [NSString stringWithFormat:@"%@",profile.firstName];
        }
        else if([profile.lastName length]>0)
        {
            username = [NSString stringWithFormat:@"%@",profile.lastName];
        }
        

		usercompany = profile.company;
		userphone = profile.phone;
        userfax = profile.fax;
        useremail = profile.email;
        
        if (profile.street != nil && ![profile.street isEqualToString:@""])
        {
            useraddress1 = profile.street;
        }
        
        if (profile.city != nil && ![profile.city isEqualToString:@""])
        {
            useraddress2 = profile.city;
        }
        if (profile.state != nil && ![profile.state isEqualToString:@""])
        {
            if ([useraddress2 isEqualToString:@""])
            {
                useraddress2 = profile.state;
            }
            else
            {
                useraddress2 = [NSString stringWithFormat:@"%@,%@",useraddress2,profile.state];
            }
        }
        if (profile.zip != nil && ![profile.zip isEqualToString:@""])
        {
            if ([useraddress2 isEqualToString:@""])
            {
                useraddress2 = profile.zip;
            }
            else
            {
                useraddress2 = [NSString stringWithFormat:@"%@,%@",useraddress2,profile.zip];
            }
        }
	}
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentRight;
    paragraph2.lineBreakMode = NSLineBreakByTruncatingTail;

    //name
    [username drawInRect:CGRectMake(145, startHigh+5, 250, 60) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : [UIColor colorWithRed:43.0/255 green:43.0/255 blue:43.0/255 alpha:1]}];
    
    //INVOICE
    [@"INVOICE" drawAtPoint:CGPointMake(415,startHigh+5) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:28],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : [UIColor colorWithRed:54.0/255 green:157.0/255 blue:251.0/255 alpha:1]}];
    
    UIColor *color1 = [UIColor colorWithRed:33.0/255 green:33.0/255 blue:33.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:22.0/255 green:35.0/255 blue:49.0/255 alpha:1];
    
    //usercompany,useremail
    [usercompany drawInRect:CGRectMake(145, startHigh+65, 250, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color1}];
    [useremail drawInRect:CGRectMake(145, startHigh+85, 250, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color1}];
    
    [@"Invoice#:" drawAtPoint:CGPointMake(415, startHigh+65) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color1}];
    NSString *invoiceNO = invoice.invoiceNO;
    [invoiceNO drawInRect:CGRectMake(440, startHigh+65, 130, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color1}];
    
    [@"Invoice Date:" drawAtPoint:CGPointMake(415, startHigh+85) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMddyyyy" options:0 locale:[NSLocale currentLocale]]];
    [[dateFormatter stringFromDate:invoice.dueDate] drawInRect:CGRectMake(440, startHigh+85, 130, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color2}];
    
    CGContextSetRGBFillColor(_context, 219.0/255, 236.0/255, 255.0/255, 1);
    CGContextFillRect(_context, CGRectMake(20, startHigh+115, 276, 26));
    CGContextFillRect(_context, CGRectMake(307, startHigh+115, 276, 26));
    
    [@"from" drawAtPoint:CGPointMake(30, startHigh+120) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color3}];
    [[NSString stringWithFormat:@"to:  %@",invoice.client.clientName] drawInRect:CGRectMake(314, startHigh+120, 256, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color3}];
    
    float beginHigh = startHigh+150;
    if (useraddress1 != nil && ![useraddress1 isEqualToString:@""])
    {
        [useraddress1 drawInRect:CGRectMake(30, beginHigh, 263, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
        beginHigh = beginHigh + 20;
    }
    if (useraddress2 != nil && ![useraddress2 isEqualToString:@""])
    {
        float unitHigh = [useraddress2 boundingRectWithSize:CGSizeMake(263, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:12], NSFontAttributeName, nil] context:nil].size.height;
        
        if (unitHigh > 25)
        {
            unitHigh = 35;
        }
        else
        {
            unitHigh = 20;
        }
        
        [useraddress2 drawInRect:CGRectMake(30, beginHigh, 263, unitHigh) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
        beginHigh = beginHigh + unitHigh;
    }
    if (userphone != nil && ![userphone isEqualToString:@""])
    {
        [userphone drawInRect:CGRectMake(30, beginHigh, 263, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
        beginHigh = beginHigh + 20;
    }
    if (userfax != nil && ![userfax isEqualToString:@""])
    {
        [userfax drawInRect:CGRectMake(30, beginHigh, 263, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
    }
    
    beginHigh = startHigh+150;
    NSString *clientAddress = invoice.client.address;
    NSString *clientPhone = invoice.client.phone;
    NSString *clientFax = invoice.client.fax;
    if (clientAddress != nil && ![clientAddress isEqualToString:@""])
    {
        float unitHigh = [clientAddress boundingRectWithSize:CGSizeMake(253, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:12], NSFontAttributeName, nil] context:nil].size.height;
        
        if (unitHigh > 25)
        {
            unitHigh = 35;
        }
        else
        {
            unitHigh = 20;
        }
        
        [clientAddress drawInRect:CGRectMake(317, beginHigh, 253, unitHigh) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
        beginHigh = beginHigh + unitHigh;
    }
    if (clientPhone != nil && ![clientPhone isEqualToString:@""])
    {
        [clientPhone drawInRect:CGRectMake(317, beginHigh, 253, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
        beginHigh = beginHigh + 20;
    }
    if (clientFax != nil && ![clientFax isEqualToString:@""])
    {
        [clientFax drawInRect:CGRectMake(317, beginHigh, 253, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
    }
    
    CGContextSetRGBFillColor(_context, 219.0/255, 236.0/255, 255.0/255, 1);
    CGContextFillRect(_context, CGRectMake(20, startHigh+255, 560, 26));
    
    [@"Date" drawAtPoint:CGPointMake(30, startHigh+260) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color3}];
    [@"Worked" drawInRect:CGRectMake(220, startHigh+260, 100, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color3}];
    [@"Rate" drawInRect:CGRectMake(325, startHigh+260, 120, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color3}];
    [@"Amount" drawInRect:CGRectMake(450, startHigh+260, 120, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color3}];
    
    return middleFirst;
     
}

- (float)drawMiddle:(Invoice *)invoice _CGContextRef:(CGContextRef)_context _beginHigh:(float)beginY
{
    float lastY = 0;

    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    //log
    NSMutableArray *logsAndItem = [[NSMutableArray alloc] initWithArray:[appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]]];
    NSSortDescriptor* logsOrder = [NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:NO];
    [logsAndItem sortUsingDescriptors:[NSArray arrayWithObject:logsOrder]];
    
    //invoiceperproty
    NSArray *invpropertyArray = [appDelegate removeAlready_DeleteInvpty:[invoice.invoicepropertys allObjects]];
    if (invpropertyArray.count > 0)
    {
        [logsAndItem addObject:@"invicepropertys"];
        [logsAndItem addObjectsFromArray:invpropertyArray];
    }
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentLeft;
    paragraph2.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableParagraphStyle *paragraph3 = [[NSMutableParagraphStyle alloc] init];
    paragraph3.alignment = NSTextAlignmentRight;
    paragraph3.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIColor *color = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:22.0/255 green:35.0/255 blue:49.0/255 alpha:1];
    
    
    float headHigh = 20;
    float bottomHigh = 15;
    float logHigh = 15;
    float logBlankHigh = 6;
    float logNoteWith = 250;
    
    UIFont *noteFont = [UIFont systemFontOfSize:10];
    float unitHigh = 0;
    Logs *log;
    BOOL haveNote;
    Invoiceproperty *invpty;
    NSString *dateStr;
    NSString *quantityStr;
    NSString *rateStr;
    NSString *amountStr;
    int i = 0;
	for (int j=0; j<[logsAndItem count]; j++)
	{
        unitHigh = 0;
        log = nil;
        haveNote = NO;
        invpty = nil;
        
        id data = [logsAndItem objectAtIndex:j];
        if ([data isKindOfClass:[Logs class]])
        {
            log = (Logs *)data;
            if (!(log.notes == nil || [log.notes isEqualToString:@""]))
            {
                unitHigh = [log.notes boundingRectWithSize:CGSizeMake(logNoteWith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: noteFont, NSFontAttributeName, nil] context:nil].size.height;
                haveNote = YES;
            }
            unitHigh = unitHigh+logBlankHigh*2+logHigh;
        }
        else
        {
            if ([data isKindOfClass:[Invoiceproperty class]])
            {
                invpty = (Invoiceproperty *)data;
                unitHigh = logBlankHigh*2+logHigh;
            }
            else
            {
                unitHigh = 26;
            }
        }
        
        if (unitHigh+beginY > pdfHigh-bottomHigh)
        {
            UIGraphicsBeginPDFPage();
            beginY = headHigh;
        }
        
        if (i%2==1)
        {
            CGContextSetRGBFillColor(_context, 240.0/255, 240.0/255, 240.0/255, 1);
            CGContextFillRect(_context, CGRectMake(20, beginY, 560, unitHigh));
        }
        
        if (log != nil || invpty != nil)
        {
            if (log != nil)
            {
                if (haveNote == YES)
                {
                    [log.notes drawInRect:CGRectMake(30, beginY+logBlankHigh+logHigh, logNoteWith, unitHigh-logBlankHigh*2-logHigh) withAttributes:@{NSFontAttributeName : noteFont,NSParagraphStyleAttributeName : paragraph,NSForegroundColorAttributeName : color2}];
                }
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMddyyyy" options:0 locale:[NSLocale currentLocale]]];
                dateStr = [dateFormatter stringFromDate:log.starttime];
                
                quantityStr= [appDelegate conevrtTime:log.worked];
                
                NSString *showMoney = [appDelegate appMoneyShowStly2:log.ratePerHour];
                rateStr = [NSString stringWithFormat:@"%@%@/h",appDelegate.currencyStr,showMoney];
                
                amountStr = [appDelegate appMoneyShowStly:log.totalmoney];
            }
            else
            {
                dateStr = invpty.name;
                
                quantityStr= [NSString stringWithFormat:@"%dp",invpty.quantity.intValue];
                
                NSString *showMoney = [appDelegate appMoneyShowStly2:invpty.price];
                rateStr = [NSString stringWithFormat:@"%@%@/p",appDelegate.currencyStr,showMoney];
                
                NSString *showMoney2 = [NSNumber numberWithDouble:[invpty.price doubleValue]*invpty.quantity.intValue].stringValue;
                amountStr = [appDelegate appMoneyShowStly:showMoney2];
            }
            
            [dateStr drawInRect:CGRectMake(30, beginY+logBlankHigh-1, 180, logHigh+3) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color3}];
            [quantityStr drawInRect:CGRectMake(220, beginY+logBlankHigh, 100, logHigh) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color}];
            [rateStr drawInRect:CGRectMake(325, beginY+logBlankHigh, 120, logHigh) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color}];
            [amountStr drawInRect:CGRectMake(450, beginY+logBlankHigh, 120, logHigh) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color}];
        }
        else
        {
            i=1;
            CGContextSetRGBFillColor(_context, 219.0/255, 236.0/255, 255.0/255, 1);
            CGContextFillRect(_context, CGRectMake(20, beginY, 560, 26));
            
            [@"Name" drawAtPoint:CGPointMake(30, beginY+5) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color3}];
            [@"Quantity" drawInRect:CGRectMake(220, beginY+5, 100, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
            [@"Rate" drawInRect:CGRectMake(325, beginY+5, 120, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
            [@"Amount" drawInRect:CGRectMake(450, beginY+5, 120, 20) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
        }
        
        i++;
        beginY = beginY+unitHigh;
        
        if (j == [logsAndItem count]-1)
        {
            lastY = beginY;
        }
	}
    
    
    return lastY;
}

- (void)drawLast:(Invoice *)invoice _CGContextRef:(CGContextRef)_context _beginHigh:(float)beginY
{
    CGPoint point;
    float bottomHigh = 225;
    if (pdfHigh-beginY < bottomHigh)
    {
        UIGraphicsBeginPDFPage();
        point = CGPointMake(30, 30);
    }
    else
    {
        point = CGPointMake(30, pdfHigh-bottomHigh);
        point.y = point.y+30;
    }
    
    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentLeft;
    paragraph2.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableParagraphStyle *paragraph3 = [[NSMutableParagraphStyle alloc] init];
    paragraph3.alignment = NSTextAlignmentRight;
    paragraph3.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIColor *color1 = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:33.0/255 green:33.0/255 blue:33.0/255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:245.0/255 green:44.0/255 blue:44.0/255 alpha:1];
    
    [@"Terms & Note:" drawAtPoint:CGPointMake(point.x, point.y) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : paragraph2,NSForegroundColorAttributeName : color1}];
    
    NSString *mymessage;
    if (invoice.terms != nil && ![invoice.terms isEqualToString:@""])
    {
        mymessage = [NSString stringWithFormat:@"%@\n%@",invoice.terms,invoice.message];
    }
	else
    {
        mymessage = invoice.message;
    }
    
    NSMutableParagraphStyle *notesParagraph = [[NSMutableParagraphStyle alloc] init];
    notesParagraph.alignment = NSTextAlignmentLeft;
    notesParagraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    [mymessage drawInRect:CGRectMake(point.x, point.y+20, 295, 120) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName : notesParagraph,NSForegroundColorAttributeName : color2}];

    point.x = point.x-10;
    [@"Sub Total:" drawInRect:CGRectMake(point.x+320, point.y, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color1}];
    
    invoice.subtotal = (invoice.subtotal==nil)?ZERO_NUM:invoice.subtotal;
    NSString *subValue1 = [appDelegate appMoneyShowStly:invoice.subtotal];
    [subValue1 drawInRect:CGRectMake(point.x+420, point.y, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
    
    [@"Overtime Pay:" drawInRect:CGRectMake(point.x+320, point.y+25, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];

    NSMutableArray *logsAndItem = [[NSMutableArray alloc] initWithArray:[appDelegate removeAlready_DeleteLog:[invoice.logs allObjects]]];
    NSArray *backArray = [appDelegate overTimeMoney_logs:logsAndItem];
    NSNumber *over_money = [backArray objectAtIndex:0];
    NSString *overmoneyStr = [appDelegate appMoneyShowStly3:[over_money doubleValue]];
    [overmoneyStr drawInRect:CGRectMake(point.x+420, point.y+25, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
    
    [@"Discount:" drawInRect:CGRectMake(point.x+320, point.y+50, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color4}];
    invoice.discount = (invoice.discount==nil)?ZERO_NUM:invoice.discount;
    NSString *disountValue1 = [appDelegate appMoneyShowStly:invoice.discount];
    [disountValue1 drawInRect:CGRectMake(point.x+420, point.y+50, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
    
    NSString *taxStr = [NSString stringWithFormat:@"Tax(%@%%):",invoice.tax];
    [taxStr drawInRect:CGRectMake(point.x+320, point.y+75, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color4}];
    invoice.tax = (invoice.tax==nil)?ZERO_NUM:invoice.tax;
    double taxmoney = 0.0;
    taxmoney = ([invoice.subtotal doubleValue]+[over_money doubleValue])*[invoice.tax doubleValue]/100;
    NSString *taxValue1 = [appDelegate appMoneyShowStly3:taxmoney];
    [taxValue1 drawInRect:CGRectMake(point.x+420, point.y+75, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
    
    //other charges
    double otherTax;
    double getOterMoney=0;
    for (Invoiceproperty *_invpty in [_invoice.invoicepropertys allObjects])
    {
        if ([_invpty.sync_status integerValue]==0)
        {
            otherTax = 1.0;
            if (_invpty.tax.intValue == 1)
            {
                otherTax = otherTax + [_invoice.tax doubleValue]/100;
            }
            getOterMoney = getOterMoney + _invpty.price.doubleValue*_invpty.quantity.intValue*otherTax;
        }
        
    }
    
    [@"Other Charges:"drawInRect:CGRectMake(point.x+320, point.y+100, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color4}];
//    double chargeAmount = [invoice.totalDue doubleValue] - [invoice.subtotal doubleValue] - [over_money doubleValue]-taxmoney+[invoice.discount doubleValue];
    double chargeAmount = getOterMoney;
    NSString *chargeStr = [appDelegate appMoneyShowStly3:chargeAmount];
    [chargeStr drawInRect:CGRectMake(point.x+420, point.y+100, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
	
    [@"Total Amount:" drawInRect:CGRectMake(point.x+320, point.y+125, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color1}];
	invoice.totalDue = (invoice.totalDue==nil)?ZERO_NUM:invoice.totalDue;
    NSString *dueValue1 = [appDelegate appMoneyShowStly:invoice.totalDue];
    [dueValue1 drawInRect:CGRectMake(point.x+420, point.y+125, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];
    
    [@"Paid:" drawInRect:CGRectMake(point.x+320, point.y+150, 100, 20) withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color1}];
    invoice.paidDue = (invoice.paidDue==nil)?ZERO_NUM:invoice.paidDue;
    NSString *payValue1 = [appDelegate appMoneyShowStly:invoice.paidDue];
    [payValue1 drawInRect:CGRectMake(point.x+420, point.y+150, 130, 20) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color3}];

    [@"Balance Due:" drawInRect:CGRectMake(point.x+320, point.y+175, 100, 25) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color1}];
    invoice.balanceDue = (invoice.balanceDue==nil)?ZERO_NUM:invoice.balanceDue;
    NSString *balanceValue1 = [appDelegate appMoneyShowStly:invoice.balanceDue];
    [balanceValue1 drawInRect:CGRectMake(point.x+420, point.y+175, 130, 25) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSParagraphStyleAttributeName : paragraph3,NSForegroundColorAttributeName : color5}];
}




@end


