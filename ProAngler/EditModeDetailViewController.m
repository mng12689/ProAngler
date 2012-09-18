//
//  EditModeDetailViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/15/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "EditModeDetailViewController.h"
#import "AddAttributeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProAnglerDataStore.h"
#import "Catch.h"
#import "Species.h"
#import "Venue.h"
#import "Bait.h"
#import "Structure.h"
#import "Photo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FullSizeImagePageViewController.h"
#import "FullSizeImageViewController.h"
#import "AppDelegate.h"

@interface EditModeDetailViewController () <AddAttributeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak) IBOutlet UIScrollView *scrollView;
@property (weak) IBOutlet UIScrollView *mediaScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (strong) NSMutableArray *photos;
@property (strong) UIImageView *currentlySelectedImageView;

- (IBAction)addAttribute:(UIButton*)sender;
- (IBAction)presentCameraActionSheet:(id)sender;

- (void)saveChanges;
- (void)takePhoto;
- (void)chooseExisting;

@end

@implementation EditModeDetailViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood.jpg"]];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.detailView.frame.origin.y + self.detailView.frame.size.height);
    self.mediaScrollView.layer.cornerRadius = 5;
    self.mediaScrollView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:100 alpha:.2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveChanges)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"Edit Catch" forNavItem:self.navigationItem];
    
    for (Photo *photo in self.catch.photos)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 66*self.mediaScrollView.subviews.count, 4, 62, 62)];
        imageView.image = [UIImage imageWithData:photo.thumbnail];
        imageView.opaque = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentPhotoOptions:)]];
        
        self.mediaScrollView.contentSize = CGSizeMake(70+self.mediaScrollView.contentSize.width,self.mediaScrollView.contentSize.height);
        [self.mediaScrollView addSubview:imageView];
        
        if (!self.photos)
            self.photos = [NSMutableArray new];
        
        [self.photos addObject:photo];
    }
    
    /********* set up size picker **********/

    if ([self.catch.weightOZ intValue] != -1)
    {
        int weightLB = [self.catch.weightOZ intValue]/16;
        int weightOZ = [self.catch.weightOZ intValue]%16;
        [super.sizePickerView selectRow:weightLB+1 inComponent:0 animated:NO];
        [super.sizePickerView selectRow:weightOZ+1 inComponent:1 animated:NO];
    }
    
    if ([self.catch.length intValue] != -1)
        [super.sizePickerView selectRow:[self.catch.length intValue]+1 inComponent:2 animated:NO];
    
    /********* set up venue picker **********/
    
    if (self.catch.venue) 
        [super.venuePickerView selectRow:[self.venueList indexOfObject:self.catch.venue]+1 inComponent:0 animated:YES];
    
    if (self.catch.species)
        [super.speciesPickerView selectRow:[self.speciesList indexOfObject:self.catch.species]+1 inComponent:0 animated:YES];
    
    if (self.catch.bait)
        [super.baitPickerView selectRow:[self.baitList indexOfObject:self.catch.bait]+1 inComponent:0 animated:NO];
    
    if (self.catch.structure)
        [super.structurePickerView selectRow:[self.structureList indexOfObject:self.catch.structure]+1 inComponent:0 animated:NO];

    if ([self.catch.depth intValue] != -1)
        [super.depthPickerView selectRow:[self.catch.depth intValue]+1 inComponent:0 animated:NO];
    
    if ([self.catch.waterTempF intValue] != -1)
        [super.waterTempPickerView selectRow:[self.catch.waterTempF intValue]-31 inComponent:0 animated:NO];
    
    if (self.catch.waterColor)
        [super.waterColorPickerView selectRow:[self.waterColorList indexOfObject:self.catch.waterColor]+1 inComponent:0 animated:NO];
    
    if (self.catch.waterLevel)
        [super.waterLevelPickerView selectRow:[self.waterLevelList indexOfObject:self.catch.waterLevel]+1 inComponent:0 animated:NO];
    
    if (self.catch.spawning)
        [super.spawningPickerView selectRow:[self.spawningList indexOfObject:self.catch.spawning]+1 inComponent:0 animated:NO];
    
    if (self.catch.baitDepth)
        [super.baitDepthPickerView selectRow:[self.baitDepthList indexOfObject:self.catch.baitDepth]+1 inComponent:0 animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMediaScrollView:nil];
    [self setScrollView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addAttribute:(UIButton*)sender
{
    AddAttributeViewController *addAttributeViewController = [AddAttributeViewController new];
    addAttributeViewController.delegate = self;
    
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
    
    [self presentModalViewController:addAttributeViewController animated:YES];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AttributeAdded" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveChanges
{
    Species *newSpecies;
    
    /********* edit catch entity **********/
    
    for (Photo *photo in self.photos)
        photo.catch = self.catch;
    self.catch.photos = [NSSet setWithArray:self.photos];
    
    if([super.sizePickerView selectedRowInComponent:0]!=0 && [super.sizePickerView selectedRowInComponent:1]!=0)
        self.catch.weightOZ = [NSNumber numberWithInt:(([super.sizePickerView selectedRowInComponent:0]-1)*16) + [super.sizePickerView selectedRowInComponent:1]-1];
    else
        self.catch.weightOZ = @-1;
    
    if([super.sizePickerView selectedRowInComponent:2]!=0)
        self.catch.length = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:2]-1];
    else
        self.catch.length = @-1;
    
    if([super.venuePickerView selectedRowInComponent:0]!=0)
        self.catch.venue = [super.venueList objectAtIndex:[super.venuePickerView selectedRowInComponent:0]-1];
    else {
        [self.catch.venue removeCatchesObject:self.catch];
        self.catch.venue = nil;
    }
    
    if([super.speciesPickerView selectedRowInComponent:0]!=0)
        newSpecies = [super.speciesList objectAtIndex:[super.speciesPickerView selectedRowInComponent:0]-1];
    else {
        [self.catch.species removeCatchesObject:self.catch];
        self.catch.species = nil;
    }
    
    if([super.baitPickerView selectedRowInComponent:0]!=0)
        self.catch.bait = [super.baitList objectAtIndex:[super.baitPickerView selectedRowInComponent:0]-1];
    else {
        [self.catch.bait removeCatchesObject:self.catch];
        self.catch.bait = nil;
    }
    
    if([super.structurePickerView selectedRowInComponent:0]!=0)
        self.catch.structure = [super.structureList objectAtIndex:[super.structurePickerView selectedRowInComponent:0]-1];
    else {
        [self.catch.structure removeCatchesObject:self.catch];
        self.catch.structure = nil;
    }
    
    if([super.waterTempPickerView selectedRowInComponent:0]!=0)
        self.catch.waterTempF = [NSNumber numberWithInt:[super.waterTempPickerView selectedRowInComponent:0]+31];
    else
        self.catch.waterTempF = @-1;
    
    if([super.waterColorPickerView selectedRowInComponent:0]!=0)
        self.catch.waterColor = [super.waterColorList objectAtIndex:[super.waterColorPickerView selectedRowInComponent:0]-1];
    else
        self.catch.waterColor = nil;
    
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0)
        self.catch.waterLevel = [super.waterLevelList objectAtIndex: [super.waterLevelPickerView selectedRowInComponent:0]-1];
    else
        self.catch.waterLevel = nil;
    
    if([super.depthPickerView selectedRowInComponent:0]!=0)
        self.catch.depth = [NSNumber numberWithInt:[super.depthPickerView selectedRowInComponent:0]-1];
    else
        self.catch.depth = @-1;
    
    if([super.spawningPickerView selectedRowInComponent:0]!=0)
        self.catch.spawning = [super.spawningList objectAtIndex:[super.spawningPickerView selectedRowInComponent:0]-1];
    else
        self.catch.spawning = nil;
    
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0)
        self.catch.baitDepth = [super.baitDepthList objectAtIndex:[super.baitDepthPickerView selectedRowInComponent:0]-1];
    else
        self.catch.baitDepth = nil;
    
    /********* species entity updates **********/
    
    if (newSpecies)
    {
        int newTotal = [newSpecies.totalCatches intValue] + 1;
        newSpecies.totalCatches = [NSNumber numberWithInt:newTotal];
        
        if (self.catch.weightOZ){
            if ([newSpecies.largestCatch.weightOZ intValue] < [self.catch.weightOZ intValue])
                newSpecies.largestCatch = self.catch;
        }
    }
    
    /********* venue/species entities updates **********/
    if (self.catch.venue && newSpecies && ![self.catch.venue.species containsObject:newSpecies] && ![newSpecies.venues containsObject:self.catch.venue]) {
        [self.catch.venue addSpeciesObject:newSpecies];
        [newSpecies addVenuesObject:self.catch.venue];
    }
    
    self.catch.species = newSpecies;
    
    NSError *error;
    [ProAnglerDataStore saveContext:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CatchAddedOrModified" object:self];
    
    NSString *title;
    NSString *message;
    if(error){
        title = @"Edited catch not saved";
        message = [error localizedFailureReason];
    }
    else{
        title = @"Edited catch saved!";
        message = @"View all catches in your album.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)presentCameraActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Camera Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    [actionSheet showInView:self.view];
}

- (void)presentPhotoOptions:(UITapGestureRecognizer*)gesture
{
    self.currentlySelectedImageView = (UIImageView*)gesture.view;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Photo Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"View Full Size", nil];
    [actionSheet showInView:self.view];
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
    if (newImage.size.width < newImage.size.height) {
        screenSizeImage = [self changeSizeOfImage:newImage withSize:CGSizeMake(640,960)];
        photo.screenSizeImage = UIImageJPEGRepresentation(screenSizeImage, 1);
        
        thumbnail = [self changeSizeOfImage:newImage withSize:CGSizeMake(64,96)];
        photo.thumbnail = UIImageJPEGRepresentation(thumbnail, 1);
    }
    else{
        screenSizeImage = [self changeSizeOfImage:newImage withSize:CGSizeMake(960,640)];
        photo.screenSizeImage = UIImageJPEGRepresentation(screenSizeImage, 1);
        
        thumbnail = [self changeSizeOfImage:newImage withSize:CGSizeMake(96,64)];
        photo.thumbnail = UIImageJPEGRepresentation(thumbnail, 1);
    }
    
    [self.photos addObject:photo];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 66*self.mediaScrollView.subviews.count, 4, 62, 62)];
    imageView.image = thumbnail;
    imageView.opaque = YES;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentPhotoOptions:)]];
    
    self.mediaScrollView.contentSize = CGSizeMake(70+self.mediaScrollView.contentSize.width,self.mediaScrollView.contentSize.height);
    [self.mediaScrollView addSubview:imageView];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (UIImage *)changeSizeOfImage:(UIImage *)image withSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
