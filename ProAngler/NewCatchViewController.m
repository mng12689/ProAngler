//
//  NewCatchViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/10/12.
//  Copyright (c) Michael Ng. All rights reserved.
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
#import "Species.h"
#import "RestKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FullSizeImagePageViewController.h"
#import "FullSizeImageViewController.h"
#import "WeatherDescription.h"
#import "AppDelegate.h"

@interface NewCatchViewController () < CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RKRequestDelegate, UIActionSheetDelegate>

@property (strong) CLLocationManager *locationManager;
@property (strong) NSTimer *locationManagerTimer;

@property (weak) IBOutlet UIScrollView *scrollView;
@property (weak) IBOutlet UIScrollView *mediaScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *showMoreOptionsButton;

@property (strong) Catch *currentCatch;

@property (strong) NSMutableArray *photos;
@property (strong) UIImageView *currentlySelectedImageView;

- (IBAction)addAttribute:(UIButton*)sender;
- (IBAction)saveNewCatch:(id)sender;
- (IBAction)toggleHiddenView:(id)sender;
- (IBAction)presentCameraActionSheet:(id)sender;

- (void)takePhoto;
- (void)chooseExisting;

@end

@implementation NewCatchViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://free.worldweatheronline.com"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood_slight_gradient.jpg"]];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"Record Catch" forNavItem:self.navigationItem];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.mediaScrollView.layer.cornerRadius = 5;
    self.mediaScrollView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:100 alpha:.2];
    
    self.photoButton.layer.cornerRadius = 8;
    self.photoButton.layer.masksToBounds = YES;
    
    self.showMoreOptionsButton.layer.cornerRadius = 8;
    self.showMoreOptionsButton.layer.masksToBounds = YES;
    self.showMoreOptionsButton.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:.2];
    self.showMoreOptionsButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    for (Photo *photo in self.photos){
        [self addImageToMediaScrollView:[UIImage imageWithData:photo.thumbnail]];
    } 
}

- (void)viewDidUnload
{
    [self setMediaScrollView:nil];
    [self setScrollView:nil];
    [self setDetailView:nil];
    [self setPhotoButton:nil];
    [self setShowMoreOptionsButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addAttribute:(UIButton*)sender 
{
    AddAttributeViewController *addAttributeViewController = [AddAttributeViewController new];

    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 201)
        addAttributeViewController.attributeType = @"Venue";
    
    else if(button.tag == 202)
        addAttributeViewController.attributeType = @"Species";
    
    else if(button.tag == 203)
        addAttributeViewController.attributeType = @"Bait";
    
    else if(button.tag == 204)
        addAttributeViewController.attributeType = @"Structure";
    
    [self presentModalViewController:addAttributeViewController animated:YES];
}

- (IBAction)saveNewCatch:(id)sender 
{
    if([super.venuePickerView selectedRowInComponent:0]!=0) {
               
        /********* create new catch entity **********/

        NSLog(@"Start save");
        Catch *catch = [ProAnglerDataStore createEntity:@"Catch"];
        self.currentCatch = catch;
        
        [self.locationManager startUpdatingLocation];
        self.locationManagerTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(stopLocationUpdates) userInfo:nil repeats:NO];
        
        catch.date = [NSDate date];
        catch.photos = [NSSet setWithArray:self.photos];

        if([super.sizePickerView selectedRowInComponent:0]!=0 && [super.sizePickerView selectedRowInComponent:1]!=0)
            catch.weightOZ = [NSNumber numberWithInt:(([super.sizePickerView selectedRowInComponent:0]-1)*16) + [super.sizePickerView selectedRowInComponent:1]-1];
        
        if([super.sizePickerView selectedRowInComponent:2]!=0)
            catch.length = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:2]-1];
        
        if([super.venuePickerView selectedRowInComponent:0]!=0)
            catch.venue = [super.venueList objectAtIndex:[super.venuePickerView selectedRowInComponent:0]-1];
        
        if([super.speciesPickerView selectedRowInComponent:0]!=0)
            catch.species = [super.speciesList objectAtIndex:[super.speciesPickerView selectedRowInComponent:0]-1];
        
        if([super.baitPickerView selectedRowInComponent:0]!=0)
            catch.bait = [super.baitList objectAtIndex:[super.baitPickerView selectedRowInComponent:0]-1];
        
        if([super.structurePickerView selectedRowInComponent:0]!=0)
            catch.structure = [super.structureList objectAtIndex:[super.structurePickerView selectedRowInComponent:0]-1];
        
        if([super.waterTempPickerView selectedRowInComponent:0]!=0)
            catch.waterTempF = [NSNumber numberWithInt:[super.waterTempPickerView selectedRowInComponent:0]+31];
        
        if([super.waterColorPickerView selectedRowInComponent:0]!=0)
            catch.waterColor = [super.waterColorList objectAtIndex:[super.waterColorPickerView selectedRowInComponent:0]-1];
        
        if([super.waterLevelPickerView selectedRowInComponent:0]!=0)
            catch.waterLevel = [super.waterLevelList objectAtIndex: [super.waterLevelPickerView selectedRowInComponent:0]-1];
            
        if([super.depthPickerView selectedRowInComponent:0]!=0)
            catch.depth = [NSNumber numberWithInt:[super.depthPickerView selectedRowInComponent:0]-1];
            
        if([super.spawningPickerView selectedRowInComponent:0]!=0)
            catch.spawning = [super.spawningList objectAtIndex:[super.spawningPickerView selectedRowInComponent:0]-1];
        
        if([super.baitDepthPickerView selectedRowInComponent:0]!=0)
            catch.baitDepth = [super.baitDepthList objectAtIndex:[super.baitDepthPickerView selectedRowInComponent:0]-1];
        
        /********* venue/species entities updates **********/
        if (catch.venue && catch.species) {
            [catch.venue addSpeciesObject:catch.species];
            [catch.species addVenuesObject:catch.venue];
        }
        
        NSError *error;
        [ProAnglerDataStore saveContext:&error];
        
        NSLog(@"Starting notification center");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CatchesModified" object:self];
        NSLog(@"Ended notification center");
        [self resetView];
        
        NSString *title;
        NSString *message;
        if(error){
            title = @"Catch not saved";
            message = [error localizedFailureReason];
        }
        else{
            title = @"Catch saved!";
            message = @"View all catches in your album.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"Done saving");
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Please select a venue (required)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)resetView
{
    [self.photos removeAllObjects];
    for (UIImageView *imageView in self.mediaScrollView.subviews)
        [imageView removeFromSuperview];
    
    self.mediaScrollView.contentSize = CGSizeMake(0, 0);
    
    if (!self.detailView.hidden) 
        [self toggleHiddenView:nil];
    
    [super.sizePickerView selectRow:0 inComponent:0 animated:NO];
    [super.sizePickerView selectRow:0 inComponent:1 animated:NO];
    [super.sizePickerView selectRow:0 inComponent:2 animated:NO];
    [super.venuePickerView selectRow:0 inComponent:0 animated:YES];
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
    if (newLocation.horizontalAccuracy <= 15)
    {
        [self stopLocationUpdates];
        
        self.currentCatch.location = newLocation;
        
        [ProAnglerDataStore saveContext:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CatchesModified" object:self];
        
        NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
        [self requestWeatherConditions:newLocation];
    }
}

- (void)stopLocationUpdates
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManagerTimer invalidate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } 
    else if(error.code == kCLErrorLocationUnknown) {
        // retry (automatic, no implementation needed)
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)presentCameraActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Camera Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)presentPhotoOptions:(UITapGestureRecognizer*)gesture
{
    self.currentlySelectedImageView = (UIImageView*)gesture.view;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Photo Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"View Full Size", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Camera Options"]) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self chooseExisting];
                break;
            default:
                break;
        }
    }
    else if ([actionSheet.title isEqualToString:@"Photo Options"]) {
        switch (buttonIndex) {
            case 0:
                [self deletePhoto];
                break;
            case 1:
                [self presentFullSizeImage];
                break;
            default:
                break;
        }
    }
}

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    imagePickerController.delegate = self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)chooseExisting
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    imagePickerController.delegate = self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)deletePhoto
{
    /********* remove selected image from view **********/

    double maxFrameWidth = self.currentlySelectedImageView.frame.origin.x + self.currentlySelectedImageView.frame.size.width;
    int indexInPhotosArray = maxFrameWidth/70;
    [self.photos removeObjectAtIndex:indexInPhotosArray];
    
    [self.currentlySelectedImageView removeFromSuperview];

    /********* shift all images left **********/

    for (UIImageView *imageView in self.mediaScrollView.subviews)
    {
        if (imageView.frame.origin.x > self.currentlySelectedImageView.frame.size.width)
        {
            CABasicAnimation *shiftLeftAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
            shiftLeftAnimation.duration = .25;
            shiftLeftAnimation.fromValue = [NSNumber numberWithInt:imageView.layer.position.x];
            shiftLeftAnimation.toValue = [NSNumber numberWithInt:imageView.layer.position.x - 66];
            [imageView.layer addAnimation:shiftLeftAnimation forKey:@"shiftLeftAnimation"];
            
            imageView.layer.position = CGPointMake(imageView.layer.position.x - 66, imageView.layer.position.y);
        }
    }
    
    /********* clean up **********/

    self.mediaScrollView.contentSize = CGSizeMake(self.mediaScrollView.contentSize.width - 70, self.mediaScrollView.contentSize.height);
    
    self.currentlySelectedImageView = nil;
}

- (void)presentFullSizeImage
{
    double maxFrameWidth = self.currentlySelectedImageView.frame.origin.x + self.currentlySelectedImageView.frame.size.width;
    int indexInPhotosArray = maxFrameWidth/70;
    
    FullSizeImageViewController *fullSizeImageViewController = [[FullSizeImageViewController alloc]initWithPhoto:[self.photos objectAtIndex:indexInPhotosArray]];
    self.navigationController.navigationBar.alpha = 0.0;
    
    FullSizeImagePageViewController *pageViewController = [[FullSizeImagePageViewController alloc]
                               initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options: nil];
    pageViewController.currentPage = indexInPhotosArray;
    pageViewController.photosForPages = self.photos;
    pageViewController.showFullStatsOption = NO;
    [pageViewController setViewControllers:@[fullSizeImageViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    [self.navigationController pushViewController:pageViewController animated:YES];
    self.currentlySelectedImageView = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!self.photos) 
        self.photos = [NSMutableArray new];
    
    Photo *photo = [ProAnglerDataStore createEntity:@"Photo"];
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    photo.fullSizeImage = UIImageJPEGRepresentation(newImage, 1);
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    UIImage *screenSizeImage;
    UIImage *thumbnail;
    if (newImage.size.width < newImage.size.height)
    {
        screenSizeImage = [self changeSizeOfImage:newImage withSize:CGSizeMake(640,960)];
        photo.screenSizeImage = UIImageJPEGRepresentation(screenSizeImage, 1);
        
        thumbnail = [self changeSizeOfImage:newImage withSize:CGSizeMake(160,240)];
        photo.thumbnail = UIImageJPEGRepresentation(thumbnail, 1);
    }
    else
    {
        screenSizeImage = [self changeSizeOfImage:newImage withSize:CGSizeMake(960,640)];
        photo.screenSizeImage = UIImageJPEGRepresentation(screenSizeImage, 1);
        
        thumbnail = [self changeSizeOfImage:newImage withSize:CGSizeMake(240,160)];
        photo.thumbnail = UIImageJPEGRepresentation(thumbnail, 1);
    }
                                                                           
    [self.photos addObject:photo];
    [self addImageToMediaScrollView:thumbnail];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)addImageToMediaScrollView:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 66*self.mediaScrollView.subviews.count, 4, 62, 62)];
    imageView.image = image;
    imageView.opaque = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentPhotoOptions:)]];
    
    self.mediaScrollView.contentSize = CGSizeMake(70+self.mediaScrollView.contentSize.width,self.mediaScrollView.contentSize.height);
    [self.mediaScrollView addSubview:imageView];
}

- (UIImage *)changeSizeOfImage:(UIImage *)image withSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)toggleHiddenView:(id)sender
{
    if (self.detailView.hidden) {
        self.detailView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.detailView.frame.origin.y + self.detailView.frame.size.height);
    }
    else{
        self.detailView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
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
    if(!error)
    {
        NSDictionary *currentConditions = [[[weatherResponse objectForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex:0];
        
        self.currentCatch.humidity = [NSNumber numberWithInt:[[currentConditions objectForKey:@"humidity"]intValue]];
        self.currentCatch.tempF = [NSNumber numberWithInt:[[currentConditions objectForKey:@"temp_F"]intValue]];
        self.currentCatch.visibility = [NSNumber numberWithInt:[[currentConditions objectForKey:@"visibility"]intValue]];
        self.currentCatch.windSpeedMPH = [NSNumber numberWithInt:[[currentConditions objectForKey:@"windspeedMiles"]intValue]];
        self.currentCatch.windDir = [currentConditions objectForKey:@"winddir16Point"];
        
        NSString *weatherDesc = [[[currentConditions objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
        NSArray *descriptions = [ProAnglerDataStore fetchEntity:@"WeatherDescription" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        
        WeatherDescription *descObject;
        if (descriptions.count == 0) {
            descObject = [ProAnglerDataStore createEntity:@"WeatherDescription"];
            descObject.name = weatherDesc;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WeatherDescriptionAdded" object:self];
        }
        else
            descObject = [descriptions objectAtIndex:0];
        
        self.currentCatch.weatherDescription = descObject;
            
        [ProAnglerDataStore saveContext:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CatchesModified" object:self];
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:viewController.navigationItem.title forNavItem:viewController.navigationItem];
}

@end
