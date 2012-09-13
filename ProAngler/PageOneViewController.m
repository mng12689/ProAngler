//
//  AnalysisViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AnalysisViewController.h"
#import "FilterViewController.h"
#import "Catch.h"
#import <QuartzCore/QuartzCore.h>
#import "ProAnglerDataStore.h"
#import <MapKit/MapKit.h>
#import "Species.h"
#import "ProAnglerDataStore.h"
#import "AlbumDetailViewController.m"
#import "CatchPointAnnotation.h"

@interface AnalysisViewController () <FilterViewControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *page1;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSArray* catchesToBeDisplayed;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UITextView *additionalFiltersTextView;

@end

@implementation AnalysisViewController

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
    self.mapView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
  
    NSArray *venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil];
    NSPredicate *predicate;
    if(venueList && [venueList count]!=0){
        predicate = [NSPredicate predicateWithFormat:@"venue.name like %@", [[venueList objectAtIndex:0]name]];
        self.catchesToBeDisplayed = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"venue" withPredicate:predicate];
        self.venueLabel.text = [[venueList objectAtIndex:0] name];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.page1.frame.size.width, self.page1.frame.size.height);
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
    [super viewDidUnload];
    [self setMapView:nil];
    [self setVenueLabel:nil];
    [self setAdditionalFiltersTextView:nil];
    [self setScrollView:nil];
    [self setPage1:nil];
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

-(void)filterForVenue:(NSString *)venue withPredicate:(NSPredicate *)predicate andAdditionalFilters:(NSArray *)filters
{
    self.catchesToBeDisplayed = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"venue" withPredicate:predicate];
    [self annotateMap];
    
    self.venueLabel.text = venue;
    if ([filters count] == 0) 
        self.additionalFiltersTextView.text = @"None";
    else
        self.additionalFiltersTextView.text = [filters componentsJoinedByString:@"\n"];
}

- (void)annotateMap
{
    if(self.mapView.annotations != nil)
        [self.mapView removeAnnotations:self.mapView.annotations];
    
    CLLocationDegrees minLng;
    CLLocationDegrees maxLng;
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    
    for(Catch *catch in self.catchesToBeDisplayed){
    
        CatchPointAnnotation *annotation = [CatchPointAnnotation new];
    
        CLLocation *location = catch.location;
        annotation.coordinate = location.coordinate;
        annotation.title = catch.species.name;
        annotation.subtitle = [catch dateToString];
        annotation.catch = catch;
    
        [self.mapView addAnnotation:annotation];
        
        if([catch isEqual:[self.catchesToBeDisplayed objectAtIndex:0]]){
            minLat = location.coordinate.latitude;
            maxLat = location.coordinate.latitude;
            minLng = location.coordinate.longitude;
            maxLng = location.coordinate.longitude;
        }
        else{
            if (location.coordinate.latitude < minLat) 
                minLat = location.coordinate.latitude;
            
            if (location.coordinate.latitude > maxLat) 
                maxLat = location.coordinate.latitude;
            
            if (location.coordinate.longitude < minLng) 
                minLng = location.coordinate.longitude;
            
            if (location.coordinate.longitude > maxLng) 
                maxLng = location.coordinate.longitude;
            
            NSLog(@"location: %f %f",location.coordinate.latitude,location.coordinate.longitude);
        }
    }
    [self zoomMapWithMinLng:minLng maxLng:maxLng minLat:minLat maxLat:maxLat];
}

- (void)zoomMapWithMinLng:(CLLocationDegrees)minLng maxLng:(CLLocationDegrees)maxLng minLat:(CLLocationDegrees)minLat maxLat:(CLLocationDegrees)maxLat
{
    if (!self.catchesToBeDisplayed || [self.catchesToBeDisplayed count] == 0){
        return;
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0, (minLng+maxLng)/2.0);
    MKCoordinateSpan span;
    
    if ([self.catchesToBeDisplayed count] == 1){
        span = MKCoordinateSpanMake(.01, .01);
    }
    else{
        span = MKCoordinateSpanMake(maxLat-minLat + .005, maxLng-minLng + .005);
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];

}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if ([annotation isMemberOfClass:[Annotation class]]) {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.animatesDrop = YES;
    return annotationView;
   /* }
    else{
        return nil;
    }*/
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CatchPointAnnotation *annotationView = (CatchPointAnnotation*)view;
    [self presentModalViewController:[[AlbumDetailViewController alloc]initWithNewCatch:annotationView.catch atIndex:0] animated:YES];
}

@end
