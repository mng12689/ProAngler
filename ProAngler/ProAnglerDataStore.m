//
//  ProAnglerDataStore.m
//  ProAngler
//
//  Created by Michael Ng on 9/2/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "ProAnglerDataStore.h"
#import "Catch.h"

NSManagedObjectContext *_context;
NSManagedObjectModel *_model;
NSPersistentStoreCoordinator *_psc;

@interface ProAnglerDataStore ()
+(NSManagedObjectContext*)context;
+(NSManagedObjectModel*)model;
+(NSPersistentStoreCoordinator*)psc;
@end

@implementation ProAnglerDataStore

+ (NSArray*)fetchEntity:(NSString*)entity sortBy:(NSString*)sortBy withPredicate:(NSPredicate *)predicate propertiesToFetch:(NSArray*)propertiesToFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [[ProAnglerDataStore model].entitiesByName objectForKey:entity];
    
    BOOL ascending = YES;
    if ([sortBy isEqualToString:@"date"] || [sortBy isEqualToString:@"weightOZ"]) 
        ascending = NO;
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:sortBy ascending:ascending selector:nil];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    if (propertiesToFetch)
        fetchRequest.propertiesToFetch = propertiesToFetch;
    
    if (predicate) 
        fetchRequest.predicate = predicate;
    
    NSError *error;
    NSArray *results = [[ProAnglerDataStore context] executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"error");
    }
    return results;
}

+ (id) createNewAttribute:(NSString*)attributeType
{
    return [NSEntityDescription insertNewObjectForEntityForName:attributeType inManagedObjectContext:[ProAnglerDataStore context]];
}

+ (id) createEntity:(NSString*)entity
{
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:[ProAnglerDataStore context]];
}

+ (void) deleteObject:(NSManagedObject*)object
{
    [[self context] deleteObject:object];
    [self saveContext:nil];
}

+ (void)saveContext:(NSError**)error
{
    NSManagedObjectContext *context = [self context];
    if (context != nil) {
        if ([context hasChanges] && ![context save:error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self psc];
    if (coordinator != nil) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    }
    return _context;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)model
{
    if (_model != nil) {
        return _model;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProAngler" withExtension:@"momd"];
    _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _model;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)psc
{
    if (_psc != nil) {
        return _psc;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProAngler.sqlite"];
    
    NSError *error = nil;
    _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    if (![_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _psc;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
