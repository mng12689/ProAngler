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
#import "AppDelegate.h"

@interface FullSizeImagePageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UINavigationBarDelegate>

@property int previousPage;

@end

@implementation FullSizeImagePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers)
        gR.delegate = self;
    
    if (self.showFullStatsOption)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Full Stats" style:UIBarButtonItemStyleBordered target:self action:@selector(showFullStats)];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:[NSString stringWithFormat:@"Photo %d of %d",self.currentPage+1,self.photosForPages.count] forNavItem:self.navigationItem];
    
    self.hidesBottomBarWhenPushed = YES;
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
        self.currentPage = self.photosForPages.count - 1;
    
    else
        self.currentPage--;
    
    NSLog(@"Will display previous page: %d",self.currentPage);
    
    return [[FullSizeImageViewController alloc]initWithPhoto:[self.photosForPages objectAtIndex:self.currentPage]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.previousPage = self.currentPage;

    if(self.currentPage == self.photosForPages.count - 1)
        self.currentPage = 0;
    
    else
        self.currentPage++;
    
    NSLog(@"Will display next page: %d",self.currentPage);
    
    return [[FullSizeImageViewController alloc]initWithPhoto:[self.photosForPages objectAtIndex:self.currentPage]];;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        [self setViewControllers:previousViewControllers direction:UIPageViewControllerNavigationOrientationHorizontal animated:YES completion:nil];
        
        self.currentPage = self.previousPage;
    }
    else
    {
        AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
        [appDelegate setTitle:[NSString stringWithFormat:@"Photo %d of %d",self.currentPage+1,self.photosForPages.count] forNavItem:self.navigationItem];
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
    AlbumDetailViewController *albumDetailForCatch = [[AlbumDetailViewController alloc]initWithNewCatch:[[self.photosForPages objectAtIndex:self.currentPage] catch]];
    albumDetailForCatch.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [UINavigationItem new];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    navBar.items = @[navItem];

    [albumDetailForCatch.view addSubview:navBar];
    
    albumDetailForCatch.scrollView.frame = CGRectMake(albumDetailForCatch.scrollView.frame.origin.x, albumDetailForCatch.scrollView.frame.origin.y + navBar.frame.size.height, albumDetailForCatch.scrollView.frame.size.width, albumDetailForCatch.scrollView.frame.size.height - navBar.frame.size.height);
    
    [self presentModalViewController:albumDetailForCatch animated:YES];
}

-(void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    self.navigationController.navigationBar.alpha = 1.0;
}

@end
