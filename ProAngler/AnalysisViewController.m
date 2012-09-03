//
//  AnalysisViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AnalysisViewController.h"
#import "FilterViewController.h"
#import "NewCatch.h"
#import <QuartzCore/QuartzCore.h>
#import "ProAnglerDataStore.h"

@interface AnalysisViewController () <FilterViewControllerDelegate, MKMapViewDelegate>

@end

@implementation AnalysisViewController

@synthesize context;
@synthesize mapView;
@synthesize catchesToBeDisplayed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"graph_paper.png"]];
  
    NSArray *venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil];
    NSPredicate *predicate;
    if(venueList && [venueList count]!=0){
        predicate = [NSPredicate predicateWithFormat:@"(venue == %@)", [[venueList objectAtIndex:0]name]];
        catchesToBeDisplayed = [ProAnglerDataStore fetchEntity:@"NewCatch" sortBy:@"venue" withPredicate:predicate];
    }
    
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    
    self.mapView.layer.cornerRadius = 5;
    self.mapView.clipsToBounds = YES;
    [self.mapView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.mapView.layer setBorderWidth:2.0];

    [self annotateMap];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Filter"]) {
        
        FilterViewController *filterViewController = segue.destinationViewController;
        filterViewController.delegate = self;        
    }
}

- (void) filterSaved:(NSArray*)filteredCatches
{
    self.catchesToBeDisplayed = filteredCatches;
    [self annotateMap];
}

- (void)annotateMap
{
    if(mapView.annotations != nil){
        [mapView removeAnnotations:mapView.annotations];
    }
    
    CLLocationDegrees minLng;
    CLLocationDegrees maxLng;
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    
    for(int catch = 0; catch < catchesToBeDisplayed.count; catch++){
        NewCatch *newCatch = [catchesToBeDisplayed objectAtIndex:catch];
    
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    
        CLLocation *location = newCatch.location;
        annotation.coordinate = location.coordinate;
        annotation.title = newCatch.species;
        annotation.subtitle = [newCatch dateToString];
    
        [mapView addAnnotation:annotation];
        
        if(catch == 0){
            minLat = location.coordinate.latitude;
            maxLat = location.coordinate.latitude;
            minLng = location.coordinate.longitude;
            maxLng = location.coordinate.longitude;
        }
        else{
            if (location.coordinate.latitude < minLat) {
                minLat = location.coordinate.latitude;
            }
            if (location.coordinate.latitude > maxLat) {
                maxLat = location.coordinate.latitude;
            }
            if (location.coordinate.longitude < minLng) {
                minLng = location.coordinate.longitude;
            }
            if (location.coordinate.longitude > maxLng) {
                maxLng = location.coordinate.longitude;
            }
            NSLog(@"location: %f %f",location.coordinate.latitude,location.coordinate.longitude);
        }
    }
    [self zoomMapWithMinLng:minLng maxLng:maxLng minLat:minLat maxLat:maxLat];
}

- (void)zoomMapWithMinLng:(CLLocationDegrees)minLng maxLng:(CLLocationDegrees)maxLng minLat:(CLLocationDegrees)minLat maxLat:(CLLocationDegrees)maxLat
{
    if (!catchesToBeDisplayed || [catchesToBeDisplayed count] == 0){
        return;
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2, (minLng+maxLng)/2);
    MKCoordinateSpan span;
    
    if ([catchesToBeDisplayed count] == 1){
        span = MKCoordinateSpanMake(.03, .03);
    }
    else{
        span = MKCoordinateSpanMake(maxLat-minLat, maxLng-minLng);
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];

}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if ([annotation isMemberOfClass:[Annotation class]]) {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
   /* }
    else{
        return nil;
    }*/
}

@end
