//
//  Photo.h
//  ProAngler
//
//  Created by Michael Ng on 9/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) Catch *catch;

@end
