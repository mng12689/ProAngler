//
//  Photo.h
//  ProAngler
//
//  Created by Michael Ng on 9/10/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * fullSizeImage;
@property (nonatomic, retain) NSData * screenSizeImage;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) Catch *catch;

@end
