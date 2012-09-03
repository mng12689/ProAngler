//
//  AlbumDetailViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumDetailViewController.h"

@interface AlbumDetailViewController ()

@end

@implementation AlbumDetailViewController
@synthesize speciesLabel;
@synthesize weightLabel;
@synthesize lengthLabel;
@synthesize venueLabel;
@synthesize baitLabel;
@synthesize structureLabel;
@synthesize depthLabel;
@synthesize timeLabel;
@synthesize spawningLabel;
@synthesize tempLabel;
@synthesize windLabel;
@synthesize humidityLabel;
@synthesize waterColorLabel;
@synthesize waterTempLabel;
@synthesize waterLevelLabel;
@synthesize dateLabel;
@synthesize scrollView;
@synthesize photoDisplayView;
@synthesize photoDisplayScrollView;
@synthesize mainImageView;
@synthesize catchInfoView;
@synthesize weatherConditionsView;
@synthesize waterConditionsView;
UIStoryboard *storyboard = nil;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_texture.png"]];

    scrollView.contentSize = CGSizeMake(320, 1500);
    
    //catchInfoView.backgroundColor = [UIColor colorWithRed:172 green:209 blue:233 alpha:.5];
    catchInfoView.layer.borderColor = [UIColor greenColor].CGColor; 
    catchInfoView.layer.borderWidth = 2.0f;
    catchInfoView.layer.cornerRadius = 10;
    catchInfoView.layer.masksToBounds = YES;
    
    weatherConditionsView.layer.borderColor = [UIColor greenColor].CGColor; 
    weatherConditionsView.layer.borderWidth = 3.0f;
    weatherConditionsView.layer.cornerRadius = 10;
    weatherConditionsView.layer.masksToBounds = YES;
    
    waterConditionsView.layer.borderColor = [UIColor greenColor].CGColor; 
    waterConditionsView.layer.borderWidth = 3.0f;
    waterConditionsView.layer.cornerRadius = 10;
    waterConditionsView.layer.masksToBounds = YES;
    
    mainImageView.layer.cornerRadius = 6;
    mainImageView.layer.masksToBounds = YES;
    
    photoDisplayView.layer.cornerRadius = 6;
    photoDisplayView.layer.masksToBounds = YES;

}

- (void)viewDidUnload
{
    [self setSpeciesLabel:nil];
    [self setWeightLabel:nil];
    [self setLengthLabel:nil];
    [self setVenueLabel:nil];
    [self setBaitLabel:nil];
    [self setDateLabel:nil];
    [self setPhotoDisplayView:nil];
    [self setMainImageView:nil];
    [self setPhotoDisplayScrollView:nil];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (AlbumDetailViewController*) initWithNewCatch:(NewCatch*)newCatch atIndex:(NSInteger)index
{
    NSLog(@"init");
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AlbumDetailViewController *albumDetailViewController = [storyboard instantiateViewControllerWithIdentifier: @"albumDetailViewController"];
    albumDetailViewController.view.backgroundColor = [UIColor clearColor];  
    albumDetailViewController.view.tag = index;
    
    NSLog(@"set index");
    //albumDetailViewController.dateLabel.text = [newCatch dateToString];
    albumDetailViewController.speciesLabel.text = newCatch.species;
    albumDetailViewController.weightLabel.text = [newCatch weightToString];
    albumDetailViewController.lengthLabel.text = [newCatch lengthToString];
    albumDetailViewController.venueLabel.text = newCatch.venue;
    albumDetailViewController.baitLabel.text = newCatch.bait;
    albumDetailViewController.structureLabel.text = newCatch.structure;
    albumDetailViewController.depthLabel.text = [newCatch depthToString];
    albumDetailViewController.timeLabel.text = [newCatch timeToString];
    albumDetailViewController.spawningLabel.text = newCatch.spawning;
    
    
    return albumDetailViewController;
}

@end
