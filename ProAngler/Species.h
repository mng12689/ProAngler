//
//  Species.h
//  ProAngler
//
//  Created by Michael Ng on 9/9/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch, Venue;

@interface Species : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * totalCatches;
@property (nonatomic, retain) NSSet *catches;
@property (nonatomic, retain) NSSet *venues;
@property (nonatomic, retain) Catch *largestCatch;
@end

@interface Species (CoreDataGeneratedAccessors)

- (void)addCatchesObject:(Catch *)value;
- (void)removeCatchesObject:(Catch *)value;
- (void)addCatches:(NSSet *)values;
- (void)removeCatches:(NSSet *)values;

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
