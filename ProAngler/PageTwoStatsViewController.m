//
//  PageTwoStatsViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "PageTwoStatsViewController.h"
#import "ProAnglerDataStore.h"
#import "Catch.h"
#import "Species.h"
#import "Venue.h"

@interface PageTwoStatsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
-(void)loadData;

@end

@implementation PageTwoStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"CatchesModified" object:nil queue:nil usingBlock:^(NSNotification *note){
            [self loadData];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.textView.editable = NO;
    self.textView.textColor = [UIColor whiteColor];
    [self loadData];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadData
{
    NSMutableArray *stats = [NSMutableArray new];
    NSArray *allCatches = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"species" withPredicate:nil propertiesToFetch:nil];

    /********* totals **********/

    NSString *totals = @"Totals";

    NSString *totalCatches = [NSString stringWithFormat:@"\n\tTotal Catches: %d",[allCatches count]];

    NSDate *oneYearAgo = [[NSDate date] dateByAddingTimeInterval:-31556926];
    NSString *catchesThisYear = [NSString stringWithFormat:@"\n\tCatches this year: %d", [[allCatches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date > %@",oneYearAgo]]count]];
     
    int totalWeightOZ = [[allCatches valueForKeyPath:@"@sum.weightOZ"] intValue];
    NSString *totalWeight = [NSString stringWithFormat:@"\n\tTotal Weight: %.2f lbs",totalWeightOZ/16.0];

    [stats addObjectsFromArray:@[totals,totalCatches,catchesThisYear,totalWeight]];

    /********* stats by species **********/

    NSArray *allSpecies = [ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];

    NSString *species = [NSString stringWithFormat:@"\n\nSpecies (%d)", allSpecies.count];
    [stats addObject:species];

    for (Species *species in allSpecies)
    {
        NSString *speciesString = [NSString stringWithFormat:@"\n\t%@",species.name];

        NSNumber *largestCatchWeight = [species.catches valueForKeyPath:@"@max.weightOZ"];
        NSString *largestCatchString;
        if (largestCatchWeight && [largestCatchWeight intValue] != -1)
            largestCatchString = [NSString stringWithFormat:@"\n\t\tLargest Catch: %d lbs %d oz",[largestCatchWeight intValue]/16, [largestCatchWeight intValue]%16];
        else
            largestCatchString = @"\n\t\tLargest Catch:";

        NSString *totalCatches = [NSString stringWithFormat:@"\n\t\tTotal catches: %d",species.catches.count];
        [stats addObjectsFromArray: [NSArray arrayWithObjects:speciesString,largestCatchString,totalCatches, nil]];
    }

    /********* stats by venue **********/

    NSArray *allVenues = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];

    NSString *venues = [NSString stringWithFormat:@"\n\nVenues (%d)", allVenues.count];
    [stats addObject:venues];

    for (Venue *venue in allVenues)
    {
        NSString *venueString = [NSString stringWithFormat:@"\n\t%@",venue.name];
        [stats addObject:venueString];
        
        NSArray *speciesForVenue = [[venue.species allObjects] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES]]];
        NSArray *catchesForVenue = [venue.catches allObjects];
        
        for (Species *species in speciesForVenue)
        {
            NSString *speciesString = [NSString stringWithFormat:@"\n\t\t%@",species.name];
            
            NSArray *catchesPerSpeciesAtVenue = [catchesForVenue filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"species == %@",species]];
            
            NSNumber *largestCatchWeight = [catchesPerSpeciesAtVenue valueForKeyPath:@"@max.weightOZ"];
            NSString *largestCatchString;
            if (largestCatchWeight && [largestCatchWeight intValue] != -1)
                largestCatchString = [NSString stringWithFormat:@"\n\t\t\tLargest Catch: %d lbs %d oz",[largestCatchWeight intValue]/16, [largestCatchWeight intValue]%16];
            else
                largestCatchString = @"\n\t\t\tLargest Catch:";
            
            NSString *totalCatchesString = [NSString stringWithFormat:@"\n\t\t\tTotal catches: %d",catchesPerSpeciesAtVenue.count];
            
            [stats addObjectsFromArray: [NSArray arrayWithObjects:speciesString,largestCatchString,totalCatchesString, nil]];
        }
    }

    self.textView.text = [stats componentsJoinedByString:@""];
}

@end
