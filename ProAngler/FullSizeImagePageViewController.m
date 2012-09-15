//
//  FullSizeImagePageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/12/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "FullSizeImagePageViewController.h"
#import "Catch.h"
#import "FullSizeImageViewController.h"
#import "Photo.h"
#import "AlbumDetailViewController.h"

@interface FullSizeImagePageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@end

@implementation FullSizeImagePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers)
        gR.delegate = self;
    
    if (self.showFullStatsOption)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Full Stats" style:UIBarButtonItemStyleBordered target:self action:@selector(showFullStats)];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
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
        index = [self.photosForPages count]-1;
    }
    else{
        index = self.currentPage - 1;
    }
    NSLog(@"Will display previous page: %d",index);
    self.currentPage = index;
    
    return [[FullSizeImageViewController alloc]initWithPhoto:[self.photosForPages objectAtIndex:self.currentPage]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index;
    if(self.currentPage == [self.photosForPages count]-1){
        index = 0;
    }
    else{
        index = self.currentPage + 1;
    }
    NSLog(@"Will display next page: %d",index);
    self.currentPage = index;
    
    return [[FullSizeImageViewController alloc]initWithPhoto:[self.photosForPages objectAtIndex:self.currentPage]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    FullSizeImageViewController *previousViewController = [previousViewControllers objectAtIndex:0];
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
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
        return NO;
    
    return YES;
}

-(void)showFullStats
{
    AlbumDetailViewController *albumDetailForCatch = [[AlbumDetailViewController alloc]initWithNewCatch:[[self.photosForPages objectAtIndex:self.currentPage] catch] atIndex:0];
    albumDetailForCatch.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [UINavigationItem new];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    navBar.items = @[navItem];
    
    albumDetailForCatch.scrollView.frame = CGRectMake(albumDetailForCatch.scrollView.frame.origin.x, albumDetailForCatch.scrollView.frame.origin.y + navBar.frame.size.height, albumDetailForCatch.scrollView.frame.size.width, albumDetailForCatch.view.frame.size.height - navBar.frame.size.height);
    [albumDetailForCatch.view addSubview:navBar];
    
    [self presentModalViewController:albumDetailForCatch animated:YES];
}

-(void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
