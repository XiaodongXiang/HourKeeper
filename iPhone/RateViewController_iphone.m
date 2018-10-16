//
//  RateViewController_iphone.m
//  HoursKeeper
//
//  Created by xy_dev on 11/25/13.
//
//

#import "RateViewController_iphone.h"
#import "Appirater.h"


#define degreesToRadians(x) (M_PI  * (x) / 180.0)



@implementation RateViewController_iphone


@synthesize bv;
@synthesize bvImageV;

@synthesize whatNewBv;
@synthesize whatBvImagv;
@synthesize scrollView;
@synthesize pageControl;
@synthesize pageArray;

@synthesize stly;

@synthesize Bt1;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRateOrWhatNew];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            return;
        }
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        {
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
            self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0);
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
            self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
        }
        else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
            self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1024.0);
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
            self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
        }
    }
}






-(void)setRateOrWhatNew
{
    if (self.stly == 0)
    {
        [self.bv setHidden:NO];
        [self.whatNewBv setHidden:YES];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            #ifdef LITE
                if ([UIScreen mainScreen].bounds.size.width > 400)
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_lite_1126_1747.png"];
                }
                else if ([UIScreen mainScreen].bounds.size.width >350)
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_lite_680_1055.png"];
                }
                else
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_lite_290_450.png"];
                }
            #else
                if ([UIScreen mainScreen].bounds.size.width > 400)
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_1126_1747.png"];
                    self.Bt1.frame = CGRectMake(self.Bt1.frame.origin.x, self.Bt1.frame.origin.y-4, self.Bt1.frame.size.width, self.Bt1.frame.size.height);
                }
                else if ([UIScreen mainScreen].bounds.size.width >350)
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_680_1055.png"];
                    self.Bt1.frame = CGRectMake(self.Bt1.frame.origin.x, self.Bt1.frame.origin.y-2, self.Bt1.frame.size.width, self.Bt1.frame.size.height);
                }
                else
                {
                    self.bvImageV.image = [UIImage imageNamed:@"rate_290_450.png"];
                }
            #endif
            
            if ([UIScreen mainScreen].bounds.size.height < 500)
            {
                self.bv.frame = CGRectMake(self.bv.frame.origin.x, 25, self.bv.frame.size.width, self.bv.frame.size.height);
            }
        }
        else
        {
            #ifdef LITE
                        self.bvImageV.image = [UIImage imageNamed:@"rate_lite_380_500.png"];
            #else
                        self.bvImageV.image = [UIImage imageNamed:@"rate_380_500.png"];
            #endif
        }
    }
    else
    {
        [self.bv setHidden:YES];
        [self.whatNewBv setHidden:NO];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            if ([UIScreen mainScreen].bounds.size.width > 400)
            {
                [self.whatBvImagv setImage:[UIImage imageNamed:@"what_new_1242_2208.png"]];
                if (self.pageArray == nil)
                {
                    self.pageArray = [[NSMutableArray alloc] initWithObjects:@"what_new_1_1242_2208.png",nil];
                }
            }
            else if ([UIScreen mainScreen].bounds.size.width >350)
            {
                [self.whatBvImagv setImage:[UIImage imageNamed:@"what_new_750_1334.png"]];
                if (self.pageArray == nil)
                {
                    self.pageArray = [[NSMutableArray alloc] initWithObjects:@"what_new_1_750_1334.png",nil];
                }
            }
            else
            {
                if ([UIScreen mainScreen].bounds.size.height < 500)
                {
                    self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, 460);
                    
                    [self.whatBvImagv setImage:[UIImage imageNamed:@"what_new_320_460.png"]];
                    if (self.pageArray == nil)
                    {
                        self.pageArray = [[NSMutableArray alloc] initWithObjects:@"what_new_1_320_460.png",nil];
                    }
                }
                else
                {
                    [self.whatBvImagv setImage:[UIImage imageNamed:@"what_new_320_568.png"]];
                    if (self.pageArray == nil)
                    {
                        self.pageArray = [[NSMutableArray alloc] initWithObjects:@"what_new_1_320_568.png",nil];
                    }
                }
            }
        }
        else
        {
            if (self.pageArray == nil)
            {
                self.pageArray = [[NSMutableArray alloc] initWithObjects:@"what_new_1_380_500.png",nil];
            }
        }
        
        
        int count = 1;
        
        [self.scrollView setContentSize:CGSizeMake(count*self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        
        for (UIView *v in self.scrollView.subviews)
        {
            [v removeFromSuperview];
        }
        for (int i=0; i<count; i++)
        {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
            [imageV setImage:[UIImage imageNamed:[self.pageArray objectAtIndex:i]]];
            [self.scrollView addSubview:imageV];
        }
    }
}





-(IBAction)doAction:(UIButton *)sender
{
    [Appirater rateFinish:sender.tag];
    [self.view removeFromSuperview];
}





-(IBAction)doWhatNewAction:(UIButton *)sender
{
    [Appirater whatNawFinish:sender.tag];
    [self.view removeFromSuperview];
}

-(IBAction)onPangeChange
{
    int page = (int)self.pageControl.currentPage;
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
}



@end
