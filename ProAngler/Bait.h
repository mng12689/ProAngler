//
//  Bait.h
//  ProAngler
//
//  Created by Michael Ng on 9/17/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch;

@interface Bait : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *catches;
@end

@interface Bait (CoreDataGeneratedAccessors)

- (void)addCatchesObject:(Catch *)value;
- (void)removeCatchesObject:(Catch *)value;
- (void)addCatches:(NSSet *)values;
- (void)removeCatches:(NSSet *)values;

@end
