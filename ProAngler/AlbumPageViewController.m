//
//  AlbumPageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/27/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "AlbumDetailViewController.h"
#import "Catch.h"

@interface AlbumPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@end

@implementation AlbumPageViewController

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
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        gR.delegate = self;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"current_page: %d",self.currentPage);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index;
    if(self.currentPage == 0){
        index = [self.fetchedObjects count]-1;
    }
    else{
        index = self.currentPage - 1;
    }
    NSLog(@"Will display previous page: %d",index);
    self.currentPage = index;
    Catch *catch = [self.fetchedObjects objectAtIndex:index];
    return [[AlbumDetailViewController alloc ]initWithNewCatch:catch atIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index;
    if(self.currentPage == [self.fetchedObjects count]-1){
        index = 0;
    }
    else{
        index = self.currentPage + 1;
    }
    NSLog(@"Will display next page: %d",index);
    self.currentPage = index;
    Catch *catch = [self.fetchedObjects objectAtIndex:index];
    return [[AlbumDetailViewController alloc] initWithNewCatch:catch atIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    AlbumDetailViewController *previousViewController = [previousViewControllers objectAtIndex:0];
    if (!completed) {
        [self setViewControllers:previousViewControllers direction:UIPageViewControllerNavigationOrientationHorizontal animated:YES completion:nil];
        if(previousViewController.currentPage < self.currentPage){
            NSLog(@"Current page -1");
            self.currentPage--;
        }
        else if(previousViewController.currentPage > self.currentPage){
            NSLog(@"Current page +1");
            self.currentPage++;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (CGRectContainsPoint([[[self.viewControllers objectAtIndex:0] addToWallOfFameButton]frame],touchPoint))
            return NO;
    }
    return YES;
}

@end
