//
//  XDDataManager.h
//  PocketExpense
//
//  Created by 晓东 on 2018/1/11.
//

#import <Foundation/Foundation.h>
@interface XDDataManager : NSObject

@property(nonatomic, strong,readonly)NSManagedObjectContext * backgroundContext;


+(XDDataManager*)shareManager;
-(NSManagedObjectModel*)managedObjectModel;
-(NSManagedObjectContext*)managedObjectContext;


-(id)insertObjectToTable:(NSString*)tableName;
-(NSArray *)getObjectsFromTable:(NSString *)tableName;
-(NSArray *)getObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray;

-(NSArray *)backgroundGetObjectsFromTable:(NSString *)tableName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortArray;
    
-(void)deleteTableObject:(id)object;

-(void)saveContext;


@end
