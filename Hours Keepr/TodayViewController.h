//
//  TodayViewController.h
//  Hours Keepr
//
//  Created by XiaoweiYang on 14-12-29.
//
//

#import <UIKit/UIKit.h>


@interface TodayViewController : UIViewController
{
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UITableViewCell *lastCell;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *colokBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(IBAction)doAddEntry:(id)sender;
-(UIImage*)m_imageWithColor:(UIColor *)color size:(CGSize)size;

@end
