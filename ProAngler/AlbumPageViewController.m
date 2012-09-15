//
//  AlbumPageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/27/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "AlbumDetailViewController.h"
#import "Catch.h"

@interface AlbumPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property int previousPage;

@end

@implementation AlbumPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers)
        gR.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.previousPage = self.currentPage;
    
    if(self.currentPage == 0)
        self.currentPage = self.catches.count - 1;
    
    else
        self.currentPage--;
    
    NSLog(@"Will display previous page: %d",self.currentPage);
    
    Catch *catch = [self.catches objectAtIndex:self.currentPage];
    return [[AlbumDetailViewController alloc ]initWithNewCatch:catch];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.previousPage = self.currentPage;
    
    if(self.currentPage == self.catches.count - 1)
        self.currentPage = 0;
    
    else
        self.currentPage++;
    
    NSLog(@"Will display next page: %d",self.currentPage);
          
    Catch *catch = [self.catches objectAtIndex:self.currentPage];
    return [[AlbumDetailViewController alloc] initWithNewCatch:catch];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        [self setViewControllers:previousViewControllers direction:UIPageViewControllerNavigationOrientationHorizontal animated:YES completion:nil];

        self.currentPage = self.previousPage;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (CGRectContainsPoint([[[self.viewControllers objectAtIndex:0] addToWallOfFameButton]frame],touchPoint))
            return NO;
        else if (CGRectContainsPoint([[[self.viewControllers objectAtIndex:0] emailButton]frame],touchPoint))
            return NO;
        else if (CGRectContainsPoint([[[self.viewControllers objectAtIndex:0] twitterButton]frame],touchPoint))
            return NO;
        else if (CGRectContainsPoint([[[self.viewControllers objectAtIndex:0] mainImageView]frame],touchPoint))
            return NO;
    }
    return YES;
}

@end
