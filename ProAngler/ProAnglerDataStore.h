//
//  ProAnglerDataStore.h
//  ProAngler
//
//  Created by Michael Ng on 9/2/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Catch;

@interface ProAnglerDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (void)saveContext:(NSError**)error;
+ (NSURL*)applicationDocumentsDirectory;

+ (NSArray*) fetchEntity:(NSString*)entity sortBy:(NSString*)sortBy withPredicate:(NSPredicate*)predicate;
+ (id) createEntity:(NSString*)entity;
+ (id) createNewAttribute:(NSString*)attributeType;

@end
