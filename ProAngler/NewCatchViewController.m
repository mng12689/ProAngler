//
//  NewCatchViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/10/12.
//  Copyright (c) 2012 Michael Ng. All rights reserved.
//

#import "NewCatchViewController.h"
#import "ProAnglerDataStore.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "AddAttributeViewController.h"
#import "NewCatch.h"
#import "DetailView.h"

@interface NewCatchViewController () < CLLocationManagerDelegate, AddAttributeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSTimer *locationTimer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *mediaScrollView;
@property (weak, nonatomic) IBOutlet DetailView *detailView;

- (IBAction)addAttribute:(UIButton*)sender;
- (IBAction)saveNewCatch:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)toggleHiddenView:(id)sender;


@end

@implementation NewCatchViewController
@synthesize detailView;
@synthesize scrollView;
@synthesize mediaScrollView;
@synthesize locationManager,currentLocation,locationTimer;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_water_droplets.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.scrollView.contentSize = CGSizeMake(320, 450);
    self.mediaScrollView.layer.cornerRadius = 5;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
}

- (void)viewDidUnload
{
    [self setMediaScrollView:nil];
    [self setScrollView:nil];
    [self setDetailView:nil];
    [super viewDidUnload];
}

 - (void) viewWillAppear:(BOOL)animated
{
    [locationManager startUpdatingLocation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addAttribute:(UIButton*)sender 
{
    [self performSegueWithIdentifier:@"addAttributeSegue" sender:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddAttributeViewController *addAttributeViewController = segue.destinationViewController;
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 201) {
        addAttributeViewController.attributeType = @"Venue";
    }
    else if(button.tag == 202){
        addAttributeViewController.attributeType = @"Species";
    }
    else if(button.tag == 203){
        addAttributeViewController.attributeType = @"Bait";
    }
    else if(button.tag == 204){
        addAttributeViewController.attributeType = @"Structure";
    }
    addAttributeViewController.delegate = self;
}

- (void)attributeSaved:(NSString*)entity
{
    if ([entity isEqualToString:@"Venue"]){
        super.venueList = [ProAnglerDataStore fetchEntity:entity sortBy:@"name" withPredicate:nil];
        [super.venuePickerView reloadComponent:0];
    }
    else if([entity isEqualToString:@"Species"]){
        super.speciesList = [ProAnglerDataStore fetchEntity:entity sortBy:@"name" withPredicate:nil];
        [super.speciesPickerView reloadComponent:0];
    }
    else if([entity isEqualToString:@"Bait"]){
        super.baitList = [ProAnglerDataStore fetchEntity:entity sortBy:@"name" withPredicate:nil];
        [super.baitPickerView reloadComponent:0];
    }
    else if([entity isEqualToString:@"Structure"]){
        super.structureList = [ProAnglerDataStore fetchEntity:entity sortBy:@"name" withPredicate:nil];
        [super.structurePickerView reloadComponent:0];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNewCatch:(id)sender 
{
    NewCatch *newCatch = [ProAnglerDataStore createNewCatch];
    
    newCatch.date = [NSDate date];
    newCatch.location = self.currentLocation;
    newCatch.media = self.media
    
    if([super.sizePickerView selectedRowInComponent:0]!=0){
        newCatch.weightLB = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:0]-1];
    }
    if([super.sizePickerView selectedRowInComponent:1]!=0){
        newCatch.weightOZ = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:1]-1];
    }
    if([super.sizePickerView selectedRowInComponent:2]!=0){
        newCatch.length = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:2]-1];
    }
    /*if([super.venuePickerView selectedRowInComponent:0]!=0){
        newCatch.venue = [[super.venueList objectAtIndex:[super.venuePickerView selectedRowInComponent:0]-1]name];
    }*/
    if([super.speciesPickerView selectedRowInComponent:0]!=0){
        newCatch.species = [[super.speciesList objectAtIndex:[super.speciesPickerView selectedRowInComponent:0]-1]name];
    }
    if([super.baitPickerView selectedRowInComponent:0]!=0){
        newCatch.bait = [[super.baitList objectAtIndex:[super.baitPickerView selectedRowInComponent:0]-1]name];
    }
    if([super.structurePickerView selectedRowInComponent:0]!=0){
        newCatch.structure = [[super.structureList objectAtIndex:[super.structurePickerView selectedRowInComponent:0]-1]name];
    }
    if([super.depthPickerView selectedRowInComponent:0]!=0){
        newCatch.depth = [NSNumber numberWithInt:[super.depthPickerView selectedRowInComponent:0]-1];
    }
    if([super.waterTempPickerView selectedRowInComponent:0]!=0){
        newCatch.waterTemp = [NSNumber numberWithInt:[super.waterTempPickerView selectedRowInComponent:0]+31];
     }
    if([super.waterColorPickerView selectedRowInComponent:0]!=0){
        newCatch.waterColor = [super.waterColorList objectAtIndex:[super.waterColorPickerView selectedRowInComponent:0]-1];
    }
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0){
        newCatch.waterLevel = [super.waterLevelList objectAtIndex: [super.waterLevelPickerView selectedRowInComponent:0]-1];
    }
    if([super.spawningPickerView selectedRowInComponent:0]!=0){
    newCatch.spawning = [super.spawningList objectAtIndex:[super.spawningPickerView selectedRowInComponent:0]-1];
    }
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0){
        newCatch.baitDepth = [super.baitDepthList objectAtIndex:[super.baitDepthPickerView selectedRowInComponent:0]-1];
    }
    
    [ProAnglerDataStore saveContext];
    
    /*NSError *error;
    if(![ProAnglerDataStore saveContext:&error])
        NSLog(@"Error: %@", [error localizedFailureReason]);
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Catch saved!"
                                                  message:nil
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
    }*/
    //reset picker views and pictures
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy > currentLocation.horizontalAccuracy) {
        self.currentLocation = newLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } 
    else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                              message:[error description]
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)takePhoto:(id)sender
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePickerController.delegate = self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + 70*([self.mediaScrollView.subviews count]-1), 0, 70, 70)];
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //if (CFStringCompare((__bridge CFStringRef) [info objectForKey:UIImagePickerControllerMediaType], kUTTypeImage, 0) == kCFCompareEqualTo){
        
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.opaque = YES;
    self.mediaScrollView.contentSize = CGSizeMake(70+self.mediaScrollView.contentSize.width,70);
    [self.mediaScrollView addSubview:imageView];
    //}
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)toggleHiddenView:(id)sender
{
    if (self.detailView.hidden) {
        self.detailView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(320, self.detailView.frame.origin.y + self.detailView.frame.size.height);
    }
    else{
        self.detailView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(320, 450);
    }
}

@end
