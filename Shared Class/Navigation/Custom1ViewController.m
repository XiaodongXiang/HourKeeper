//
//  Custom1ViewController.m
//  HoursKeeper
//
//  Created by XiaoweiYang on 14-9-17.
//
//

#import "Custom1ViewController.h"

@interface Custom1ViewController ()

@end

@implementation Custom1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	self.view.superview.backgroundColor = [UIColor clearColor];
	self.view.superview.layer.shadowColor = [UIColor clearColor].CGColor;
	self.view.superview.layer.cornerRadius = 0;

	[self.view setFrame:CGRectMake(0, 0, 500, 500)];
	[self.view setCenter:CGPointMake(self.view.superview.frame.size.width/2, self.view.superview.frame.size.height/2)];
}

@end
