//
//  NewCatch.h
//  ProAngler
//
//  Created by Michael Ng on 7/15/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewCatch : NSManagedObject

@property (nonatomic, retain) NSString * bait;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * spawning;
@property (nonatomic, retain) NSString * species;
@property (nonatomic, retain) NSString * structure;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * waterColor;
@property (nonatomic, retain) NSString * waterLevel;
@property (nonatomic, retain) NSNumber * waterTemp;
@property (nonatomic, retain) NSNumber * weightLB;
@property (nonatomic, retain) NSNumber * weightOZ;
@property (nonatomic, retain) NSString * baitDepth;

-(NSString*) dateToString;
-(NSString*) weightToString;
-(NSString*) lengthToString;
-(NSString*) depthToString;
-(NSString*) timeToString;

@end
