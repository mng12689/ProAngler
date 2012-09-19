//
//  PageOneMapViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/14/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "PageOneMapViewController.h"
#import "FilterViewController.h"
#import "Catch.h"
#import <QuartzCore/QuartzCore.h>
#import "ProAnglerDataStore.h"
#import <MapKit/MapKit.h>
#import "Species.h"
#import "ProAnglerDataStore.h"
#import "AlbumDetailViewController.h"
#import "CatchPointAnnotation.h"
#import "AnalysisPagedViewController.h"

@interface PageOneMapViewController () <FilterViewControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UITextView *additionalFiltersTextView;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong) NSArray* catchesToBeDisplayed;
@property (strong) NSPredicate *currentFilters;

- (IBAction)presentFilterModal:(id)sender;
-(void)annotateMap;
-(void)loadDataWithPredicate:(NSPredicate*)predicate;

@end

@implementation PageOneMapViewController
@synthesize filterButton = _filterButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CatchAddedOrModified" object:nil queue:nil usingBlock:^(NSNotification *note){
        [self loadDataWithPredicate:self.currentFilters];
    }];
    
    self.filterButton.layer.cornerRadius = 8;
    self.filterButton.layer.masksToBounds = YES;
    self.filterButton.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:.2];
    self.filterButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    
    self.mapView.layer.cornerRadius = 5;
    self.mapView.clipsToBounds = YES;
    [self.mapView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.mapView.layer setBorderWidth:2.0];
    
    NSArray *venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil];
    if(venueList && [venueList count]!=0){
        self.venueLabel.text = [[venueList objectAtIndex:0]name];
         self.currentFilters = [NSPredicate predicateWithFormat:@"venue.name like %@",self.venueLabel.text];
        [self loadDataWithPredicate:self.currentFilters];
    }
}

- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [super viewDidUnload];
    [self setMapView:nil];
    [self setVenueLabel:nil];
    [self setAdditionalFiltersTextView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)presentFilterModal:(id)sender
{
    FilterViewController *filterViewController = [FilterViewController new];
    filterViewController.delegate = self;
    
    [self.analysisViewController presentModalViewController:filterViewController animated:YES];
}

-(void)filterForVenue:(NSString *)venue withPredicate:(NSPredicate *)predicate andAdditionalFilters:(NSArray *)filters filterDate:(NSDictionary *)filterDate filterTime:(NSDictionary *)filterTime
{
    [self loadDataWithPredicate:predicate];
    
    if (filterDate) {
        self.catchesToBeDisplayed = [self.catchesToBeDisplayed filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Catch *evaluatedObject,NSDictionary *bindings)
        {
            int startMonth = [[filterDate objectForKey:@"startMonth"] intValue];
            int startDay = [[filterDate objectForKey:@"startDay"] intValue];
            int endMonth = [[filterDate objectForKey:@"endMonth"] intValue];
            int endDay = [[filterDate objectForKey:@"endDay"] intValue];
            
            return [evaluatedObject dateIsBetweenMonth:startMonth day:startDay andMonth:endMonth day:endDay];
        }]];
        [self annotateMap];
    }
    if (filterTime) {
        self.catchesToBeDisplayed = [self.catchesToBeDisplayed filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Catch *evaluatedObject,NSDictionary *bindings)
        {
            int startTime = [[filterTime objectForKey:@"startTime"] intValue];
            int endTime = [[filterTime objectForKey:@"endTime"] intValue];
            
            return [evaluatedObject timeBetweenHour:startTime andHour:endTime];
        }]];
        [self annotateMap];
    }

    
    self.venueLabel.text = venue;
    
    if ([filters count] == 0){
        self.additionalFiltersTextView.text = @"None";
        self.currentFilters = nil;
    }
    else{
        self.additionalFiltersTextView.text = [filters componentsJoinedByString:@"\n"];
        self.currentFilters = predicate;
    }
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
    if ([annotation isMemberOfClass:[CatchPointAnnotation class]]) {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    else
        return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CatchPointAnnotation *annotation = view.annotation;
    
    AlbumDetailViewController *albumDetailForCatch = [[AlbumDetailViewController alloc]initWithNewCatch:annotation.catch];
    albumDetailForCatch.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [UINavigationItem new];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    navBar.items = @[navItem];
    
    [albumDetailForCatch.view addSubview:navBar];
    
    albumDetailForCatch.scrollView.frame = CGRectMake(albumDetailForCatch.scrollView.frame.origin.x, albumDetailForCatch.scrollView.frame.origin.y + navBar.frame.size.height, albumDetailForCatch.scrollView.frame.size.width, albumDetailForCatch.scrollView.frame.size.height - navBar.frame.size.height);
    
    [self presentModalViewController:albumDetailForCatch animated:YES];
}

-(void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loadDataWithPredicate:(NSPredicate *)predicate
{
    self.catchesToBeDisplayed = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"venue" withPredicate:predicate];
    [self annotateMap];
}

@end

