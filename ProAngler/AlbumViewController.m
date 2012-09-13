//
//  AlbumViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/7/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AlbumViewController.h"
#import "Catch.h"
#import "AlbumPageViewController.h"
#import "AlbumDetailViewController.h"
#import "ProAnglerDataStore.h"
#import "AlbumSettingsViewController.h"
#import "Venue.h"
#import "Photo.h"
#import "Species.h"
#import <QuartzCore/QuartzCore.h>

@interface AlbumViewController () <AlbumSettingsViewControllerDelegate>

@property (strong) NSArray* catches;
@property (strong) AlbumPageViewController *albumPageViewController;
-(void)loadData;

@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CatchAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        [self loadData];
        [self.tableView reloadData];
    }];
    
    self.albumPageViewController = [[AlbumPageViewController alloc]
                                    initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                    options: nil];
    
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatchCell"];
	Catch *catch = [self.catches objectAtIndex:indexPath.row];
    
    UILabel *speciesLabel = (UILabel *)[cell viewWithTag:101];
	speciesLabel.text = catch.species.name ;
    
    UILabel *venueLabel = (UILabel *)[cell viewWithTag:103];
	venueLabel.text = catch.venue.name ;
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
	dateLabel.text = [catch dateToString];
	
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:105];
    if ([catch.photos count] != 0) {
        NSData *thumbnail = [[[catch.photos allObjects] objectAtIndex:0] thumbnail];
        imageView.image = [UIImage imageWithData:thumbnail];
        imageView.layer.cornerRadius = 2;
        imageView.layer.masksToBounds = YES;
    }
    else
        imageView = nil;
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.albumPageViewController.catches = self.catches;
    self.albumPageViewController.currentPage = indexPath.row;
    
    Catch *catch = [self.catches objectAtIndex:indexPath.row];
    AlbumDetailViewController *albumDetailViewController = [[AlbumDetailViewController alloc]initWithNewCatch:catch atIndex:indexPath.row];
    [self.albumPageViewController setViewControllers:@[albumDetailViewController]
                            direction:UIPageViewControllerNavigationDirectionForward
                            animated:YES
                            completion:nil];
    
     [self.navigationController pushViewController:self.albumPageViewController animated:YES];
}


#pragma mark - AlbumSettingsViewControllerDelegate

- (void)settingsChanged
{
    NSString *sortBy = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProAnglerAlbumSortTypePrefKey"];
        
    BOOL ascending;
    if ([sortBy isEqualToString:@"date"] || [sortBy isEqualToString:@"weightOZ"])
        ascending = NO;
    else
        ascending = YES;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortBy ascending:ascending];
    self.catches = [self.catches sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self.tableView reloadData];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AlbumSettings"])
	{
		AlbumSettingsViewController *albumSettingsViewController = 
        segue.destinationViewController;
        albumSettingsViewController.delegate = self;
    } 
}   

- (void)loadData
{
    NSString *sortBy = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProAnglerAlbumSortTypePrefKey"];
    self.catches = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:sortBy withPredicate:nil];

}

@end
