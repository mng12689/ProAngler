//
//  Photo.h
//  ProAngler
//
//  Created by Michael Ng on 9/18/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * fullSizeImage;
@property (nonatomic, retain) NSData * screenSizeImage;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSNumber * trophyFish;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Catch *catch;

@end
