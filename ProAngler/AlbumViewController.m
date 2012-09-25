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
#import "AppDelegate.h"

@interface AlbumViewController () <AlbumSettingsViewControllerDelegate>

@property (strong) NSArray* catches;
-(void)loadDataSource;

@end

@implementation AlbumViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"CatchesModified" object:nil queue:nil usingBlock:^(NSNotification *note){
            [self loadDataSource];
            [self.tableView reloadData];
        }];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor brownColor];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"Album" forNavItem:self.navigationItem];
    
    [self loadDataSource];
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
    return self.catches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatchCell"];
    
    if (!cell)
        cell = [[CatchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CatchCell"];
    
	Catch *catch = [self.catches objectAtIndex:indexPath.row];
    cell.currentCatch = catch;
    
    cell.venueLabel.text = catch.venue.name;
	cell.dateLabel.text = [catch dateToString];
	cell.timeLabel.text = [catch timeToString];
    
    if (cell.customImageView.subviews.count != 0)
        [[cell.customImageView.subviews objectAtIndex:0] removeFromSuperview];

    if ([catch.photos count] != 0)
    {
        NSArray *photosByDateCreated = [catch.photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
        UIImage *thumbnail = [UIImage imageWithData:[[photosByDateCreated objectAtIndex:0]thumbnail]];
        
        UIImageView *mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.customImageView.frame.size.width, cell.customImageView.frame.size.height)];
        mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        mainImageView.image = thumbnail;
        
        [cell.customImageView addSubview:mainImageView];
    }
    else
    {
        UIView *placeHolderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.customImageView.frame.size.width, cell.customImageView.frame.size.height)];
        placeHolderView.backgroundColor = [UIColor lightGrayColor];
        placeHolderView.opaque = YES;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.customImageView.frame.size.width, 80)];
        label.layer.position = CGPointMake(cell.customImageView.frame.size.width/2,cell.customImageView.frame.size.height/2);
        label.text = @"No Photos";
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:10];
        label.shadowColor = [UIColor colorWithWhite:1.0 alpha:.5];
        label.shadowOffset = CGSizeMake(0, 1);
        
        [placeHolderView addSubview:label];
        [cell.customImageView addSubview:placeHolderView];
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
    AlbumDetailViewController *albumDetailViewController = [[AlbumDetailViewController alloc]initWithNewCatch:catch];
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

- (void)loadDataSource
{
    NSString *sortBy = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProAnglerAlbumSortTypePrefKey"];
    self.catches = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:sortBy withPredicate:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [ProAnglerDataStore deleteObject:[self.catches objectAtIndex:indexPath.row]];
        [self loadDataSource];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CatchesModified" object:self];
    }
}

@end
