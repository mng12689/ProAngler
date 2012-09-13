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

@interface AlbumDetailViewController () <MFMailComposeViewControllerDelegate>

@property (strong) Catch *catch;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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

@property (strong) FullSizeImagePageViewController *pageViewController;
@property (strong) NSMutableArray *photos;
@property (strong) Photo *currentlySelectedPhoto;

- (IBAction)addToWallOfFame:(id)sender;
- (IBAction)composeEmail:(id)sender;
- (IBAction)composeTwitterMessage:(id)sender;

@end

@implementation AlbumDetailViewController
@synthesize baitDepthLabel = _baitDepthLabel;

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
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToWOF" object:self];

    self.pageViewController = [[FullSizeImagePageViewController alloc]
                               initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options: nil];
    
    self.twitterButton.layer.cornerRadius = 8;
    self.twitterButton.layer.masksToBounds = YES;
    self.emailButton.layer.cornerRadius = 8;
    self.emailButton.layer.masksToBounds = YES;
    
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
    self.mainImageView.userInteractionEnabled = YES;
    [self.mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullSizeImage)]];
}

- (void)viewDidUnload
{
    [self setEmailButton:nil];
    [self setTwitterButton:nil];
    [self setBaitDepthLabel:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setAlpha:1.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (AlbumDetailViewController*) initWithNewCatch:(Catch*)catch atIndex:(int)index
{
    self = [super init];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier: @"albumDetailViewController"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];
        
        self.catch = catch;
        self.currentPage = index;
        
        self.dateLabel.text = [catch dateToString];
        self.speciesLabel.text = catch.species.name;
        self.weightLabel.text = [catch weightToString];
        self.lengthLabel.text = [catch lengthToString];
        self.venueLabel.text = catch.venue.name;
        self.baitLabel.text = catch.bait.name;
        self.structureLabel.text = catch.structure.name;
        self.depthLabel.text = [catch depthToString];
        self.baitDepthLabel.text = catch.baitDepth;
        self.timeLabel.text = [catch timeToString];
        self.spawningLabel.text = catch.spawning;
        
        self.weatherDescriptionLabel.text = catch.weatherDesc;
        self.tempLabel.text = [catch tempFToString];
        self.windLabel.text = [catch windToString];
        self.humidityLabel.text = [catch humidityToString];
        self.visibilityLabel.text = [catch visibilityToString];
        
        self.waterColorLabel.text = catch.waterColor;
        self.waterTempLabel.text = [catch waterTempFToString];
        self.waterLevelLabel.text = catch.waterLevel;
        
        self.photos = [NSMutableArray arrayWithArray:[catch.photos allObjects]];
        if ([self.photos count] > 0)
        {
            self.mainImageView.image = [UIImage imageWithData:[[self.photos objectAtIndex:0] fullSizeImage]];
            self.currentlySelectedPhoto = [self.photos objectAtIndex:0];
            
            int column = 0;
            BOOL toggle = YES;
            for (int i = 0; i < [self.photos count]; i++)
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
        if ([self.photos count] == 0)
            self.addToWallOfFameButton.userInteractionEnabled = NO;
    }

    return self;
}

- (IBAction)addToWallOfFame:(id)sender
{
    self.catch.trophyFish = [NSNumber numberWithBool:YES];
    [ProAnglerDataStore saveContext:nil];
}

- (IBAction)composeEmail:(id)sender
{
    MFMailComposeViewController *emailViewController = [MFMailComposeViewController new];
    emailViewController.mailComposeDelegate = self;
    
    [emailViewController setSubject:[NSString stringWithFormat:@"%@ - %@ (Sent from my Pro Angler iPhone app)",self.dateLabel.text,self.venueLabel.text]];
    
    [emailViewController setMessageBody:@"test" isHTML:NO];
    
    NSArray *photos = [self.catch.photos allObjects];
    int counter = 0;
    for (Photo *photo in  photos) {
        [emailViewController addAttachmentData:photo.fullSizeImage mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@_%@_%d",self.dateLabel.text,self.venueLabel.text,counter]];
        counter++;
    }
    
    [self presentModalViewController:emailViewController animated:YES];
}

- (IBAction)composeTwitterMessage:(id)sender
{
    TWTweetComposeViewController *twitterViewController = [TWTweetComposeViewController new];
    
    if (![self.weightLabel.text isEqualToString:@""]) 
        [twitterViewController setInitialText:[NSString stringWithFormat:@"%@ - %@\n%@",self.dateLabel.text,self.venueLabel.text,self.weightLabel.text]];
    else
        [twitterViewController setInitialText:[NSString stringWithFormat:@"%@ - %@",self.dateLabel.text,self.venueLabel.text]];
    
    if (self.catch.photos) 
        [twitterViewController addImage:[UIImage imageWithData:[[self.catch.photos anyObject] fullSizeImage]]];

    [twitterViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                break;
            case TWTweetComposeViewControllerResultDone:
                break;
            default:
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [self presentModalViewController:twitterViewController animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)showFullSizeImage
{
    if (self.mainImageView.image)
    {
        FullSizeImageViewController *fullSizeImageViewController = [[FullSizeImageViewController alloc]initWithPhoto:self.currentlySelectedPhoto];
        self.navigationController.navigationBar.alpha = 0.0;
        
        self.pageViewController.currentPage = 0;
        self.pageViewController.photosForPages = [self.catch.photos allObjects];
        self.pageViewController.showFullStatsOption = NO;
        [self.pageViewController setViewControllers:@[fullSizeImageViewController]
                                        direction:UIPageViewControllerNavigationDirectionForward
                                        animated:YES
                                        completion:nil];
        
        [self.navigationController pushViewController:self.pageViewController animated:YES];
    }
}

-(void)moveThumbnailToMainView:(UITapGestureRecognizer*)tapGesure
{
    for (int i = 0; i < [self.mediaScrollView.subviews count]; i++)
    {
        UIImageView *imageView = [self.mediaScrollView.subviews objectAtIndex:i];
        if (CGRectContainsPoint(imageView.frame, [tapGesure locationInView:self.mediaScrollView])){
            //imageView.highlighted = YES;
            self.currentlySelectedPhoto = [self.photos objectAtIndex:i];
            self.mainImageView.image = [UIImage imageWithData:[self.currentlySelectedPhoto screenSizeImage]];
            break;
        }
    }
}

@end
