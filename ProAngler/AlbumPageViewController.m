//
//  AlbumPageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/27/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "AlbumDetailViewController.h"
#import "NewCatch.h"

@interface AlbumPageViewController ()

@end

@implementation AlbumPageViewController

@synthesize fetchedObjects;
@synthesize currentPage;

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
    
    self.delegate = self;
    self.dataSource = self;        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index;
    if(currentPage == 0){
        index = [fetchedObjects count]-1;
    }
    else{
        index = currentPage - 1;
    }
    NewCatch *newCatch = [fetchedObjects objectAtIndex:index];
    viewController = [AlbumDetailViewController initWithNewCatch:newCatch atIndex:index];
    //set variables
    return viewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index;
    if(currentPage == [fetchedObjects count]-1){
        index = 0;
    }
    else{
        index = currentPage + 1;
    }

    NewCatch *newCatch = [fetchedObjects objectAtIndex:index];
    viewController = [AlbumDetailViewController initWithNewCatch:newCatch atIndex:index];;
    //set variables
    return viewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *previousViewController = [previousViewControllers objectAtIndex:0];
    if((previousViewController.view.tag < currentPage) && completed){
        currentPage++;
    }
    else if((previousViewController.view.tag > currentPage) && completed){
        currentPage--;
    }
    NSLog(@"currentPage: %d",currentPage);
}

@end
