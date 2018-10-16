//
//  XDDataManager.m
//  PocketExpense
//
//  Created by 晓东 on 2018/1/11.
//

#import "XDDataManager.h"
#import "AppDelegate_iPhone.h"
@implementation XDDataManager

@synthesize backgroundContext = _backgroundContext;

-(NSManagedObjectModel*)managedObjectModel{
    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    @synchronized(appDelegete.managedObjectModel) {
        return appDelegete.managedObjectModel;
    }
    return nil;
}

-(NSManagedObjectContext*)managedObjectContext{
    AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    @synchronized(appDelegete.managedObjectContext){
        return appDelegete.managedObjectContext;
    }
    return nil;
}

+(XDDataManager *)shareManager{
    static XDDataManager* g_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shareManager = [[XDDataManager alloc]init];
    });
    return g_shareManager;
}

-(NSManagedObjectContext *)backgroundContext{
    if (!_backgroundContext) {
        _backgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        AppDelegate_iPhone *appDelegete = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

        [_backgroundContext setPersistentStoreCoordinator:appDelegete.persistentStoreCoordinator];
    }
    return _backgroundContext;
}

#pragma mark - insert
-(id)insertObjectToTable:(NSString*)tableName
{
    id object = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.managedObjectContext];
    return object;
}

-(NSArray *)getObjectsFromTable:(NSString *)tableName
{

    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:tableName inManagedObjectContext:self. managedObjectContext];
    
    [request setEntity:entityDesc];
    NSError* error=nil;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
}





-(NSArray *)getObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortArray && sortArray.count > 0) {
        [request setSortDescriptors:sortArray];
    }
    
    NSError* error=nil;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
}

-(NSArray *)backgroundGetObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.backgroundContext];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortArray && sortArray.count > 0) {
        [request setSortDescriptors:sortArray];
    }
    
    NSError* error=nil;
    NSArray* objects = [self.backgroundContext executeFetchRequest:request error:&error];
    
    return objects;
}


-(void)deleteTableObject:(id)object{
    [self.managedObjectContext deleteObject:object];
    NSError* error=nil;
    [self.managedObjectContext save:&error];
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            // abort();
        }
    }
}


@end
