//
//  OverClientViewController.h
//  HoursKeeper
//
//  Created by xy_dev on 11/26/13.
//
//

#import <UIKit/UIKit.h>

#import "Clients.h"


@protocol getOverClientDelegate <NSObject>

-(void)saveSelectClient:(Clients *)_selectClient;

@end


@interface OverClientViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
//input
@property(nonatomic,strong) Clients                     *selectClient;
@property(nonatomic,strong) id<getOverClientDelegate>   delegate;

@property(nonatomic,strong) IBOutlet UITableView        *myTableView;

@property(nonatomic,strong) IBOutlet UIView             *regularView;
@property(nonatomic,strong) IBOutlet UILabel            *regularRateLbel;

@property(nonatomic,strong) IBOutlet UIView             *dailyView;
@property(nonatomic,strong) IBOutlet UILabel            *monRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *tueRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *wedRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *thuRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *friRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *satRateLbel;
@property(nonatomic,strong) IBOutlet UILabel            *sunRateLbel;


@property(nonatomic,strong) NSMutableArray              *clientList;

@property(nonatomic,weak) IBOutlet UILabel              *regularratelabel1;

-(void)backAndSave;

@end
