//
//  AlbumDetailViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "Catch.h"
#import "Venue.h"
#import "Species.h"
#import "Bait.h"
#import "Structure.h"
#import "Photo.h"
#import "ProAnglerDataStore.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import "FullSizeImageViewController.h"
#import "FullSizeImagePageViewController.h"
#import "EditModeDetailViewController.h"
#import "WeatherDescription.h"
#import "AppDelegate.h"

@interface AlbumDetailViewController () <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (strong) Catch *catch;

@property (weak, nonatomic) IBOutlet UIScrollView *mediaScrollView;

@property (weak, nonatomic) IBOutlet UIView *catchInfoView;
@property (weak, nonatomic) IBOutlet UIView *weatherConditionsView;
@property (weak, nonatomic) IBOutlet UIView *waterConditionsView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *speciesLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *baitLabel;
@property (weak, nonatomic) IBOutlet UILabel *structureLabel;
@property (weak, nonatomic) IBOutlet UILabel *depthLabel;
@property (weak, nonatomic) IBOutlet UILabel *baitDepthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spawningLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;

@property (weak, nonatomic) IBOutlet UILabel *waterColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLevelLabel;

@property (strong) NSArray *photos;
@property (strong) Photo *currentlySelectedPhoto;

- (IBAction)addToWallOfFame:(id)sender;
- (IBAction)presentEmailActionSheet:(id)sender;
- (IBAction)presentTwitterActionSheet:(id)sender;

@end

@implementation AlbumDetailViewController

- (AlbumDetailViewController*) initWithNewCatch:(Catch*)catch
{
    self = [super init];
    if (self)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier: @"albumDetailViewController"];
        
        self.catch = catch;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"CatchAddedOrModified" object:nil queue:nil usingBlock:^(NSNotification *note){
            [self loadCatchData];
        }];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.twitterButton.layer.cornerRadius = 8;
    self.twitterButton.layer.masksToBounds = YES;
    
    self.emailButton.layer.cornerRadius = 8;
    self.emailButton.layer.masksToBounds = YES;
    
    self.addToWallOfFameButton.layer.cornerRadius = 8;
    self.addToWallOfFameButton.layer.masksToBounds = YES;
    
    UIView *mainView = [self.scrollView.subviews objectAtIndex:0];
    self.scrollView.contentSize = CGSizeMake(mainView.frame.size.width, mainView.frame.size.height);
        
    self.mediaScrollView.layer.cornerRadius = 5;
    self.mediaScrollView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:100 alpha:.2];
    self.mediaScrollView.contentSize = CGSizeMake(self.mediaScrollView.frame.size.width, self.mediaScrollView.frame.size.height);
    [self.mediaScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveThumbnailToMainView:)]];
    
    self.catchInfoView.layer.borderColor = [UIColor greenColor].CGColor;
    self.catchInfoView.layer.borderWidth = 3.0f;
    self.catchInfoView.layer.cornerRadius = 10;
    self.catchInfoView.layer.masksToBounds = YES;
    
    self.weatherConditionsView.layer.borderColor = [UIColor greenColor].CGColor;
    self.weatherConditionsView.layer.borderWidth = 3.0f;
    self.weatherConditionsView.layer.cornerRadius = 10;
    self.weatherConditionsView.layer.masksToBounds = YES;
    
    self.waterConditionsView.layer.borderColor = [UIColor greenColor].CGColor;
    self.waterConditionsView.layer.borderWidth = 3.0f;
    self.waterConditionsView.layer.cornerRadius = 10;
    self.waterConditionsView.layer.masksToBounds = YES;
    
    self.mainImageView.layer.cornerRadius = 5;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.layer.borderColor = [[UIColor brownColor]CGColor];
    self.mainImageView.layer.borderWidth = 2;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];
    
    [self loadCatchData];    
}

- (void)viewDidUnload
{
    [self setEmailButton:nil];
    [self setTwitterButton:nil];
    [self setBaitDepthLabel:nil];
    [self setMainImageView:nil];
    [super viewDidUnload];
    [self setSpeciesLabel:nil];
    [self setWeightLabel:nil];
    [self setLengthLabel:nil];
    [self setVenueLabel:nil];
    [self setBaitLabel:nil];
    [self setDateLabel:nil];
    [self setMainImageView:nil];
    [self setMediaScrollView:nil];
    [self setScrollView:nil];
    [self setWeatherConditionsView:nil];
    [self setWeatherConditionsView:nil];
    [self setWaterConditionsView:nil];
    [self setStructureLabel:nil];
    [self setDepthLabel:nil];
    [self setTimeLabel:nil];
    [self setSpawningLabel:nil];
    [self setTempLabel:nil];
    [self setWindLabel:nil];
    [self setHumidityLabel:nil];
    [self setWaterColorLabel:nil];
    [self setWaterTempLabel:nil];
    [self setWaterLevelLabel:nil];
    [self setDateLabel:nil];
    [self setWeatherDescriptionLabel:nil];
    [self setVisibilityLabel:nil];
    [self setAddToWallOfFameButton:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadCatchData
{
    self.dateLabel.text = [self.catch dateToString];
    self.speciesLabel.text = self.catch.species.name;
    self.weightLabel.text = [self.catch weightToString];
    self.lengthLabel.text = [self.catch lengthToString];
    self.venueLabel.text = self.catch.venue.name;
    self.baitLabel.text = self.catch.bait.name;
    self.structureLabel.text = self.catch.structure.name;
    self.depthLabel.text = [self.catch depthToString];
    self.baitDepthLabel.text = self.catch.baitDepth;
    self.timeLabel.text = [self.catch timeToString];
    self.spawningLabel.text = self.catch.spawning;
    
    self.weatherDescriptionLabel.text = self.catch.weatherDescription.name;
    self.tempLabel.text = [self.catch tempFToString];
    self.windLabel.text = [self.catch windToString];
    self.humidityLabel.text = [self.catch humidityToString];
    self.visibilityLabel.text = [self.catch visibilityToString];
    
    self.waterColorLabel.text = self.catch.waterColor;
    self.waterTempLabel.text = [self.catch waterTempFToString];
    self.waterLevelLabel.text = self.catch.waterLevel;
    
    self.photos = [[self.catch.photos allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];;

    if (self.photos.count > 0)
    {
        [self populateMainImageView];
        [self populateMediaScrollView];
    }
    
    else
    {
        UIView *placeHolderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height)];
        placeHolderView.backgroundColor = [UIColor lightGrayColor];
        [self.mainImageView addSubview:placeHolderView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mainImageView.frame.size.width, 80)];
        label.layer.position = CGPointMake(self.mainImageView.frame.size.width/2,self.mainImageView.frame.size.height/2);
        label.text = @"No Photos";
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.shadowColor = [UIColor colorWithWhite:1.0 alpha:.5];
        label.shadowOffset = CGSizeMake(0, 1);
    
        [self.mainImageView addSubview:label];
        
        self.addToWallOfFameButton.userInteractionEnabled = NO;
    }
}

- (void)populateMainImageView
{
    for (UIView *view in self.mainImageView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height)];
    mainImageView.image = [UIImage imageWithData:[[self.photos objectAtIndex:0] fullSizeImage]];
    mainImageView.userInteractionEnabled = YES;
    mainImageView.opaque = YES;
    [mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullSizeImage)]];
    
    [self.mainImageView addSubview:mainImageView];
    self.currentlySelectedPhoto = [self.photos objectAtIndex:0];
    
    if ([[self.currentlySelectedPhoto trophyFish] boolValue] == YES){
        self.addToWallOfFameButton.userInteractionEnabled = NO;
        [self addInductionLabel];
    }
    else
        self.addToWallOfFameButton.userInteractionEnabled = YES;
}

- (void)populateMediaScrollView
{
    for (UIImageView *imageView in self.mediaScrollView.subviews){
        [imageView removeFromSuperview];
    }
    
    int column = 0;
    BOOL toggle = YES;
    for (int i = 0; i < self.photos.count; i++)
    {
        toggle = !toggle;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4 + 56*column, 4 + 56*toggle, 52, 52)];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageWithData:[[self.photos objectAtIndex:i] thumbnail]];
        
        if (i != 0 && i % 5 == 0)
            self.mediaScrollView.contentSize = CGSizeMake(58+self.mediaScrollView.contentSize.width,self.mediaScrollView.contentSize.height);
        if (i % 2)
            column++;
        
        [self.mediaScrollView addSubview:imageView];
    }
}

- (IBAction)addToWallOfFame:(id)sender
{
    self.currentlySelectedPhoto.trophyFish = [NSNumber numberWithBool:YES];
    self.currentlySelectedPhoto.inductionDate = [NSDate date];
    self.addToWallOfFameButton.userInteractionEnabled = NO;
    [self addInductionLabel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToWOF" object:self];
    [ProAnglerDataStore saveContext:nil];
}

-(IBAction)presentEmailActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Email Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Easy Email", @"Blank Template", nil];
    
    if (self.tabBarController.tabBar) 
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheet showInView:self.view];

}

-(IBAction)presentTwitterActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Twitter Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Easy Tweet", @"Blank Template", nil];
    
    if (self.tabBarController.tabBar)
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Email Options"]) {
        switch (buttonIndex) {
            case 0:
                [self composeEmailAutofill:YES];
                break;
            case 1:
                [self composeEmailAutofill:NO];
                break;
            default:
                break;
        }
    }
    else if ([actionSheet.title isEqualToString:@"Twitter Options"]){
        switch (buttonIndex) {
            case 0:
                [self composeTwitterAutofill:YES];
                break;
            case 1:
                [self composeTwitterAutofill:NO];
                break;
            default:
                break;
        }
    }
}

- (void)composeEmailAutofill:(BOOL)autofill
{
    MFMailComposeViewController *emailViewController = [MFMailComposeViewController new];
    emailViewController.mailComposeDelegate = self;
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"hi" forNavItem:emailViewController.navigationBar.topItem];
    
    if (autofill){
        [emailViewController setSubject:[NSString stringWithFormat:@"%@ - %@",self.dateLabel.text,self.venueLabel.text]];
        
        NSArray *photos = [self.catch.photos allObjects];
        int counter = 0;
        for (Photo *photo in photos) {
            [emailViewController addAttachmentData:photo.fullSizeImage mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@_%@_%d",self.dateLabel.text,self.venueLabel.text,counter]];
            counter++;
        }
    }
    
    [emailViewController setMessageBody:@"\n\nSent from my ProAngler© fishing app\n\n" isHTML:NO];
    
    [self presentModalViewController:emailViewController animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)composeTwitterAutofill:(BOOL)autofill
{
    TWTweetComposeViewController *twitterViewController = [TWTweetComposeViewController new];
    
    if (autofill){
        if (![self.weightLabel.text isEqualToString:@""]) 
            [twitterViewController setInitialText:[NSString stringWithFormat:@"%@ - %@\n%@",self.dateLabel.text,self.venueLabel.text,self.weightLabel.text]];
        else
            [twitterViewController setInitialText:[NSString stringWithFormat:@"%@ - %@",self.dateLabel.text,self.venueLabel.text]];
        
        if (self.catch.photos) {
            UIImage *mainImage = [[self.mainImageView.subviews objectAtIndex:0] image];
            [twitterViewController addImage:mainImage];
        }
    }

    [twitterViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [self presentModalViewController:twitterViewController animated:YES];
}

-(void)showFullSizeImage
{
    UIImageView *mainImageView = [self.mainImageView.subviews objectAtIndex:0];
    if (mainImageView.image)
    {
        FullSizeImageViewController *fullSizeImageViewController = [[FullSizeImageViewController alloc]initWithPhoto:self.currentlySelectedPhoto];
        self.navigationController.navigationBar.alpha = 0.0;
        
        FullSizeImagePageViewController *pageViewController = [[FullSizeImagePageViewController alloc]
                                   initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                   options: nil];
        pageViewController.currentPage = 0;
        pageViewController.photosForPages = self.photos;
        pageViewController.showFullStatsOption = NO;
        [pageViewController setViewControllers:@[fullSizeImageViewController]
                                        direction:UIPageViewControllerNavigationDirectionForward
                                        animated:YES
                                        completion:nil];
        
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
}

-(void)moveThumbnailToMainView:(UITapGestureRecognizer*)tapGesure
{
    UIImageView *mainImageView = [self.mainImageView.subviews objectAtIndex:0];

    for (int i = 0; i < self.mediaScrollView.subviews.count; i++)
    {
        UIImageView *imageView = [self.mediaScrollView.subviews objectAtIndex:i];
        if (CGRectContainsPoint(imageView.frame, [tapGesure locationInView:self.mediaScrollView]))
        {
            self.currentlySelectedPhoto = [self.photos objectAtIndex:i];
            mainImageView.image = [UIImage imageWithData:[self.currentlySelectedPhoto screenSizeImage]];
            
            if ([[self.currentlySelectedPhoto trophyFish] boolValue] == YES){
                self.addToWallOfFameButton.userInteractionEnabled = NO;
                [self addInductionLabel];
            }
            else
                self.addToWallOfFameButton.userInteractionEnabled = YES;
            
            break;
        }
    }
}

-(void)editMode
{
    EditModeDetailViewController *editViewController =[EditModeDetailViewController new];
    editViewController.catch = self.catch;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:editViewController];

    [self presentModalViewController:navController animated:YES];
}

-(void)addInductionLabel
{
    UILabel *inductedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.addToWallOfFameButton.frame.size.width, self.addToWallOfFameButton.frame.size.height)];
    inductedLabel.textAlignment = UITextAlignmentCenter;
    inductedLabel.text = [NSString stringWithFormat:@"Inducted to Wall of Fame\n%@", [self.currentlySelectedPhoto inductionDateToString]];
    inductedLabel.font = [UIFont fontWithName:@"Cochin" size:10];
    inductedLabel.numberOfLines = 2;
    inductedLabel.layer.zPosition = 1;
    inductedLabel.backgroundColor = [UIColor clearColor];
    [self.addToWallOfFameButton addSubview:inductedLabel];
}

@end
