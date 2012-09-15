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
#import "CatchCell.h"

@interface AlbumViewController () <AlbumSettingsViewControllerDelegate>

@property (strong) NSArray* catches;
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
    CatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatchCell"];
    
    if (!cell)
        cell = [[CatchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CatchCell"];
    
	Catch *catch = [self.catches objectAtIndex:indexPath.row];
    if (cell.currentCatch == catch)
        return cell;
    cell.currentCatch = catch;
 
	cell.venueLabel.text = catch.venue.name ;
	cell.dateLabel.text = [catch dateToString];
	cell.timeLabel.text = [catch timeToString];
    cell.customImageView.image = nil;

    if ([catch.photos count] != 0)
    {
        UIImage *thumbnail = [UIImage imageWithData:[[[catch.photos allObjects] objectAtIndex:0] thumbnail]];
        cell.customImageView.image = thumbnail;
    }
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumPageViewController *albumPageViewController = [[AlbumPageViewController alloc]
                                    initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                    options: nil];
    albumPageViewController.catches = self.catches;
    albumPageViewController.currentPage = indexPath.row;
    
    Catch *catch = [self.catches objectAtIndex:indexPath.row];
    AlbumDetailViewController *albumDetailViewController = [[AlbumDetailViewController alloc]initWithNewCatch:catch atIndex:indexPath.row];
    [albumPageViewController setViewControllers:@[albumDetailViewController]
                            direction:UIPageViewControllerNavigationDirectionForward
                            animated:YES
                            completion:nil];
    
     [self.navigationController pushViewController:albumPageViewController animated:YES];
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
    for (Catch *catch in self.catches) {
        NSLog(@"%@", [catch timeToString]);
    }
}

@end
