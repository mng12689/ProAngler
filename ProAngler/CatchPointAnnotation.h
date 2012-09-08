//
//  CatchPointAnnotation.h
//  ProAngler
//
//  Created by Michael Ng on 9/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Catch;

@interface CatchPointAnnotation : MKPointAnnotation

@property (strong) Catch *catch;

@end
