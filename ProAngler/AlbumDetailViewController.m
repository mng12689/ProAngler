//
//  AlbumDetailViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "Catch.h"
#import "Venue.h"
#import "Species.h"
#import "Bait.h"
#import "Structure.h"
#import "Photo.h"
#import "ProAnglerDataStore.h"

@interface AlbumDetailViewController ()

@end

@implementation AlbumDetailViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];

    self.scrollView.contentSize = CGSizeMake(320, 1500);
    self.mediaScrollView.layer.cornerRadius = 5;
    self.mediaScrollView.alpha = .3;
    
    self.catchInfoView.layer.borderColor = [UIColor greenColor].CGColor;
    self.catchInfoView.layer.borderWidth = 2.0f;
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
    
    self.mainImageView.layer.cornerRadius = 6;
    self.mainImageView.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
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

- (AlbumDetailViewController*) initWithNewCatch:(Catch*)catch atIndex:(int)index
{
    self = [super init];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier: @"albumDetailViewController"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];
        
        self.currentPage = index;
        self.catch = catch;

        self.dateLabel.text = [catch dateToString];
        self.speciesLabel.text = catch.species.name;
        self.weightLabel.text = [catch weightToString];
        self.lengthLabel.text = [catch lengthToString];
        self.venueLabel.text = catch.venue.name;
        self.baitLabel.text = catch.bait.name;
        self.structureLabel.text = catch.structure.name;
        self.depthLabel.text = [catch depthToString];
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
        
        NSArray *photos = [catch.photos allObjects];
        if ([photos count] > 0) {
            self.mainImageView.image = [UIImage imageWithData:[[photos objectAtIndex:0] photo]];
            for (int i = 1; i < [photos count]; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + 70*([self.mediaScrollView.subviews count]-1), 0, 70, 70)];
                self.mediaScrollView.contentSize = CGSizeMake(70+self.mediaScrollView.contentSize.width,70);
                [self.mediaScrollView addSubview:imageView];
            }
        }
    }

    return self;
}

- (IBAction)addToWallOfFame:(id)sender
{
    self.catch.trophyFish = [NSNumber numberWithBool:YES];
    [ProAnglerDataStore saveContext];
}

@end
