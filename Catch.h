//
//  Catch.h
//  ProAngler
//
//  Created by Michael Ng on 9/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bait, Photo, Species, Structure, Venue;

@interface Catch : NSManagedObject

@property (nonatomic, retain) NSString * baitDepth;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * spawning;
@property (nonatomic, retain) NSString * waterColor;
@property (nonatomic, retain) NSString * waterLevel;
@property (nonatomic, retain) NSNumber * waterTempF;
@property (nonatomic, retain) NSNumber * weightOZ;
@property (nonatomic, retain) Bait *bait;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Species *species;
@property (nonatomic, retain) Structure *structure;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * tempF;
@property (nonatomic, retain) NSNumber * trophyFish;
@property (nonatomic, retain) NSNumber * visibility;
@property (nonatomic, retain) NSString * weatherDesc;
@property (nonatomic, retain) NSNumber * windSpeedMPH;
@property (nonatomic, retain) NSString * windDir;

-(NSString*)dateToString;
-(NSString*)weightToString;
-(NSString*)lengthToString;
-(NSString*)depthToString;
-(NSString*)timeToString;
-(NSString*)humidityToString;
-(NSString*)tempFToString;
-(NSString*)visibilityToString;
-(NSString*)windToString;
-(NSString*)waterTempFToString;

@end

@interface Catch (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
