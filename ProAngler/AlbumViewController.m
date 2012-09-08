//
//  AlbumViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/7/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumViewController.h"
#import "Catch.h"
#import "AlbumPageViewController.h"
#import "AlbumDetailViewController.h"
#import "ProAnglerDataStore.h"
#import "AlbumSettingsViewController.h"
#import "Venue.h"
#import "Photo.h"

@interface AlbumViewController () <AlbumSettingsViewControllerDelegate>

@property (strong) NSArray* fetchedObjects;
@property (strong) NSString* sortBy;
@property (strong) NSArray *sorters;
@property (strong) AlbumPageViewController *albumPageViewController;

@end

@implementation AlbumViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.albumPageViewController = [[AlbumPageViewController alloc]
                                    initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                    options: nil];
    
    self.sorters = [NSArray arrayWithObjects:@"date", @"weight", @"venue.name", @"species.name", nil];
    self.sortBy = [self.sorters objectAtIndex:0];
    self.fetchedObjects = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:self.sortBy withPredicate:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture.png"]];
    //fetchedResultsController.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatchCell"];
	Catch *catch = [self.fetchedObjects objectAtIndex:indexPath.row];
    
    UILabel *venueLabel = (UILabel *)[cell viewWithTag:103];
	venueLabel.text = catch.venue.name ;
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
	dateLabel.text = [catch dateToString];
	
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:105];
    imageView.image = [UIImage imageWithData:[((Photo*)[catch.photos anyObject]) photo]];
    
    return cell;    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.albumPageViewController.fetchedObjects = self.fetchedObjects;
    self.albumPageViewController.currentPage = indexPath.row;
    
    Catch *catch = [self.fetchedObjects objectAtIndex:indexPath.row];
    AlbumDetailViewController *albumDetailViewController = [[AlbumDetailViewController alloc ]initWithNewCatch:catch atIndex:indexPath.row];
    NSArray *viewControllers = [NSArray arrayWithObject:albumDetailViewController];
    [self.albumPageViewController setViewControllers:viewControllers
                            direction:UIPageViewControllerNavigationDirectionForward
                            animated:YES
                            completion:nil];
    
     [self.navigationController pushViewController:self.albumPageViewController animated:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"NewCatch"
                                        inManagedObjectContext:context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:sortBy ascending:YES selector:nil];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    NSError __autoreleasing *error;
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:context
                                sectionNameKeyPath:nil cacheName:@"Root"];
    if(![fetchedResultsController performFetch:&error])
        NSLog(@"Error: %@", [error localizedFailureReason]);*/
    //add reloadData support
}

#pragma mark - AlbumSettingsViewControllerDelegate
- (void)albumSettingsViewControllerIsDone:(AlbumSettingsViewController *)controller sortBy:(NSUInteger)index
{
    if(![self.sortBy isEqualToString:[self.sorters objectAtIndex:index]]){
        self.sortBy = [self.sorters objectAtIndex:index];
        self.fetchedObjects = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:[self.sorters objectAtIndex:index] withPredicate:nil];
        [self.tableView reloadData];
    }
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AlbumSettings"])
	{
		AlbumSettingsViewController *albumSettingsViewController = 
        segue.destinationViewController;
        albumSettingsViewController.delegate = self;
        albumSettingsViewController.index = [self.sorters indexOfObject:self.sortBy];
    } 
}   

@end
