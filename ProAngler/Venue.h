//
//  Venue.h
//  ProAngler
//
//  Created by Michael Ng on 9/9/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch, Species;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *catches;
@property (nonatomic, retain) NSSet *species;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addCatchesObject:(Catch *)value;
- (void)removeCatchesObject:(Catch *)value;
- (void)addCatches:(NSSet *)values;
- (void)removeCatches:(NSSet *)values;

- (void)addSpeciesObject:(Species *)value;
- (void)removeSpeciesObject:(Species *)value;
- (void)addSpecies:(NSSet *)values;
- (void)removeSpecies:(NSSet *)values;

@end
