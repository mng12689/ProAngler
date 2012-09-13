//
//  FullSizePageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/6/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "FullSizePageViewController.h"
#import "FullSizeViewController.h"
#import "Photo.h"
#import "Catch.h"

@interface FullSizePageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation FullSizePageViewController

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
    int index;
    if(self.currentPage == 0){
        index = [self.trophyFish count]-1;
    }
    else{
        index = self.currentPage - 1;
    }
    NSLog(@"Will display previous page: %d",index);
    self.currentPage = index;

    UIImage *photo = [UIImage imageWithData:[[[[self.trophyFish objectAtIndex:index] photos] anyObject] fullSizeImage]];
    return [[FullSizeViewController alloc]initWithImage:photo];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index;
    if(self.currentPage == [self.trophyFish count]-1){
        index = 0;
    }
    else{
        index = self.currentPage + 1;
    }
    NSLog(@"Will display next page: %d",index);
    self.currentPage = index;
    UIImage *photo = [UIImage imageWithData:[[[[self.trophyFish objectAtIndex:index] photos] anyObject] fullSizeImage]];
    return [[FullSizeViewController alloc]initWithImage:photo];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    FullSizeViewController *previousViewController = [previousViewControllers objectAtIndex:0];
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


@end
