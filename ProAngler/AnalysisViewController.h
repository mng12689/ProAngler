//
//  AnalysisViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FilterViewController.h"

@interface AnalysisViewController : UIViewController 

@property (nonatomic,strong) NSManagedObjectContext* context;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) NSArray* catchesToBeDisplayed;

@end
