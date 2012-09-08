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
#import "Catch.h"
#import "ProAnglerDataStore.h"
#import "Venue.h"
#import "Photo.h"
#import "RestKit.h"

@interface NewCatchViewController () < CLLocationManagerDelegate, AddAttributeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RKRequestDelegate>

@property (strong) CLLocationManager *locationManager;
@property (strong) CLLocation *currentLocation;
//@property (strong, nonatomic) NSTimer *locationTimer;
@property (weak) IBOutlet UIScrollView *scrollView;
@property (weak) IBOutlet UIScrollView *mediaScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (strong) NSMutableArray *photos;
@property (strong) Catch *currentCatch;

- (IBAction)addAttribute:(UIButton*)sender;
- (IBAction)saveNewCatch:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)toggleHiddenView:(id)sender;

@end

@implementation NewCatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_water_droplets.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.scrollView.contentSize = CGSizeMake(320, 450);
    self.mediaScrollView.layer.cornerRadius = 5;
    self.mediaScrollView.alpha = .3;
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://free.worldweatheronline.com"]];
}

- (void)viewDidUnload
{
    [self setMediaScrollView:nil];
    [self setScrollView:nil];
    [self setDetailView:nil];
    [self setDetailView:nil];
    [super viewDidUnload];
}

 - (void) viewWillAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
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
    Catch *catch = [ProAnglerDataStore createEntity:@"Catch"];
    
    catch.date = [NSDate date];
    catch.location = self.currentLocation;
    [self requestWeatherConditions:catch.location];

    for (Photo *photo in self.photos) {
        photo.catch = catch;
    }
    catch.photos = [NSSet setWithArray:self.photos];
    
    if([super.sizePickerView selectedRowInComponent:0]!=0){
        catch.weightLB = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:0]-1];
    }
    else{
        catch.weightLB = [NSNumber numberWithInt:-1];
    }
    if([super.sizePickerView selectedRowInComponent:1]!=0){
        catch.weightOZ = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:1]-1];
    }
    else{
        catch.weightOZ = [NSNumber numberWithInt:-1];
    }
    if([super.sizePickerView selectedRowInComponent:2]!=0){
        catch.length = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:2]-1];
    }
    else{
        catch.length = [NSNumber numberWithInt:-1];
    }
    if([super.venuePickerView selectedRowInComponent:0]!=0)
    {
        NSString *venueString = [[super.venueList objectAtIndex:[super.venuePickerView selectedRowInComponent:0]-1]name];
        NSArray *venues = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:[NSPredicate predicateWithFormat:@"name like %@",venueString]];
        
        if ([venues count] == 0) {
            Venue *venue = [ProAnglerDataStore createEntity:@"Venue"];
            venue.name = venueString;
            catch.venue = venue;
        }
        else{
            catch.venue = [venues objectAtIndex:0];
        }
    }
    if([super.speciesPickerView selectedRowInComponent:0]!=0){
        NSString *species = [[super.speciesList objectAtIndex:[super.speciesPickerView selectedRowInComponent:0]-1]name];
        catch.species = [[ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:[NSPredicate predicateWithFormat:@"name like %@",species]] objectAtIndex:0];
    }
    if([super.baitPickerView selectedRowInComponent:0]!=0){
        NSString *bait = [[super.baitList objectAtIndex:[super.baitPickerView selectedRowInComponent:0]-1]name];
        catch.bait = [[ProAnglerDataStore fetchEntity:@"Bait" sortBy:@"name" withPredicate:[NSPredicate predicateWithFormat:@"name like %@",bait]] objectAtIndex:0];
    }
    if([super.structurePickerView selectedRowInComponent:0]!=0){
        NSString *structure = [[super.structureList objectAtIndex:[super.structurePickerView selectedRowInComponent:0]-1]name];
        catch.structure = [[ProAnglerDataStore fetchEntity:@"Structure" sortBy:@"name" withPredicate:[NSPredicate predicateWithFormat:@"name like %@",structure]] objectAtIndex:0];
    }
    if([super.depthPickerView selectedRowInComponent:0]!=0){
        catch.depth = [NSNumber numberWithInt:[super.depthPickerView selectedRowInComponent:0]-1];
    }
    else{
        catch.depth = [NSNumber numberWithInt:-1];
    }
    if([super.waterTempPickerView selectedRowInComponent:0]!=0){
        catch.waterTempF = [NSNumber numberWithInt:[super.waterTempPickerView selectedRowInComponent:0]+31];
     }
    else{
        catch.waterTempF = [NSNumber numberWithInt:-1];
    }
    if([super.waterColorPickerView selectedRowInComponent:0]!=0){
        catch.waterColor = [super.waterColorList objectAtIndex:[super.waterColorPickerView selectedRowInComponent:0]-1];
    }
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0){
        catch.waterLevel = [super.waterLevelList objectAtIndex: [super.waterLevelPickerView selectedRowInComponent:0]-1];
    }
    if([super.spawningPickerView selectedRowInComponent:0]!=0){
    catch.spawning = [super.spawningList objectAtIndex:[super.spawningPickerView selectedRowInComponent:0]-1];
    }
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0){
        catch.baitDepth = [super.baitDepthList objectAtIndex:[super.baitDepthPickerView selectedRowInComponent:0]-1];
    }
    
    self.currentCatch = catch;
    
    [ProAnglerDataStore saveContext];
    [self resetView];
    
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

- (void)resetView
{
    self.photos = nil;
    for (int i = 1; i < [self.mediaScrollView.subviews count]; i++) {
        [[self.mediaScrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    if (!self.detailView.hidden) {
        [self toggleHiddenView:nil];
    }
    
    [super.sizePickerView selectRow:0 inComponent:0 animated:YES];
    [super.sizePickerView selectRow:0 inComponent:1 animated:YES];
    [super.sizePickerView selectRow:0 inComponent:2 animated:YES];
    [super.venuePickerView selectRow:0 inComponent:0 animated:NO];
    [super.speciesPickerView selectRow:0 inComponent:0 animated:NO];
    [super.baitPickerView selectRow:0 inComponent:0 animated:NO];
    [super.structurePickerView selectRow:0 inComponent:0 animated:NO];
    [super.depthPickerView selectRow:0 inComponent:0 animated:NO];
    [super.waterTempPickerView selectRow:0 inComponent:0 animated:NO];
    [super.waterColorPickerView selectRow:0 inComponent:0 animated:NO];
    [super.waterLevelPickerView selectRow:0 inComponent:0 animated:NO];
    [super.spawningPickerView selectRow:0 inComponent:0 animated:NO];
    [super.baitDepthPickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy > self.currentLocation.horizontalAccuracy) {
        self.currentLocation = newLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
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
    
    //if (CFStringCompare((__bridge CFStringRef) [info objectForKey:UIImagePickerControllerMediaType], kUTTypeImage, 0) == kCFCompareEqualTo){
    if (!self.photos) {
        self.photos = [NSMutableArray new];
    }
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    Photo *image = [ProAnglerDataStore createEntity:@"Photo"];
    image.photo = UIImageJPEGRepresentation(newImage, 1);
    [self.photos addObject:image];
    
    imageView.image = newImage;
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

-(void)requestWeatherConditions:(CLLocation*)location
{
   
    RKClient *client = [RKClient sharedClient];
    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"q", [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude],
                            @"format", @"json",
                            @"num_of_days", @"2",
                            @"key", @"66a46b14b5045801120509",
                            nil];
    
    [client get:@"/feed/weather.ashx" queryParameters:params delegate:self];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSError *error = nil;
    NSDictionary *weatherResponse = [response parsedBody:&error];
    NSLog(@"%@",[weatherResponse description]);
    if(error){
        self.currentCatch.humidity = [NSNumber numberWithInt:-1];
        self.currentCatch.tempF = [NSNumber numberWithInt:-1];
        self.currentCatch.visibility = [NSNumber numberWithInt:-1];
        self.currentCatch.windSpeedMPH = [NSNumber numberWithInt:-1];
    }
    else{
        NSDictionary *currentConditions = [[[weatherResponse objectForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex:0];
        self.currentCatch.humidity = [NSNumber numberWithInt:[[currentConditions objectForKey:@"humidity"]intValue]];
        self.currentCatch.tempF = [NSNumber numberWithInt:[[currentConditions objectForKey:@"temp_F"]intValue]];
        self.currentCatch.visibility = [NSNumber numberWithInt:[[currentConditions objectForKey:@"visibility"]intValue]];
        self.currentCatch.weatherDesc = [[[currentConditions objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
        self.currentCatch.windSpeedMPH = [NSNumber numberWithInt:[[currentConditions objectForKey:@"windspeedMiles"]intValue]];
        self.currentCatch.windDir = [currentConditions objectForKey:@"winddir16Point"];
        
        [ProAnglerDataStore saveContext];
    }

}

@end
