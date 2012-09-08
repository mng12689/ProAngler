//
//  NewCatch.h
//  ProAngler
//
//  Created by Michael Ng on 9/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bait, Species;

@interface NewCatch : NSManagedObject

@property (nonatomic, retain) NSString * baitDepth;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * spawning;
@property (nonatomic, retain) NSString * waterColor;
@property (nonatomic, retain) NSString * waterLevel;
@property (nonatomic, retain) NSNumber * waterTemp;
@property (nonatomic, retain) NSNumber * weightLB;
@property (nonatomic, retain) NSNumber * weightOZ;
@property (nonatomic, retain) Bait *bait;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Species *species;
@property (nonatomic, retain) NSManagedObject *structure;
@property (nonatomic, retain) NSManagedObject *venue;
@end

@interface NewCatch (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(NSManagedObject *)value;
- (void)removePhotosObject:(NSManagedObject *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
