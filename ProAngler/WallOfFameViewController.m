//
//  WallOfFameViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/25/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "WallOfFameViewController.h"
#import "ProAnglerDataStore.h"
#import "Catch.h"
#import "Photo.h"
#import "FullSizePageViewController.h"
#import "FullSizeViewController.h"
#import "FrameView.h"
#import <QuartzCore/QuartzCore.h>

@interface WallOfFameViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar* navBar;
@property (strong) FullSizePageViewController *fullSizePageViewController;
@property (strong) NSArray *trophyFish;

@end

@implementation WallOfFameViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_wall_texture.jpg"]];

    UIImage *image = [UIImage imageNamed:@"wood_beam.png"];
    [self.navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.trophyFish = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"date" withPredicate:[NSPredicate predicateWithFormat:@"trophyFish == YES"]];
    
    self.fullSizePageViewController = [FullSizePageViewController new];
    
    BOOL toggle = YES;
    /*for (Catch *catch in self.trophyFish)
    {
        toggle = !toggle;
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(20 + 150*toggle, 20, 130, 130)];
        containerView.contentMode = UIViewContentModeScaleAspectFit;
        containerView.layer.masksToBounds = YES;
        
        FrameView *frameView = [[FrameView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        frameView.contentMode = UIViewContentModeScaleAspectFit;
        frameView.layer.masksToBounds = YES;
        
        frameView.imageView.image = [UIImage imageWithData:[[catch.photos anyObject] photo]];
        
        [containerView addSubview:frameView];
        [self.view addSubview:containerView];
    }*/
    for (Catch *catch in self.trophyFish)
    {
        toggle = !toggle;
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(20 + 150*toggle, 20, 130, 130)];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.contentMode = UIViewContentModeCenter;
        containerView.layer.masksToBounds = YES;
        [self.view addSubview:containerView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:containerView.frame];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageWithData:[[catch.photos anyObject] photo]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        
        [containerView addSubview:imageView];
        
        /*UIView *frameView = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x - 10, imageView.frame.origin.y - 10, imageView.frame.size.width +20, imageView.frame.size.height + 20)];
        frameView.backgroundColor = [UIColor redColor];
        [containerView addSubview:frameView];*/
                
        /*FrameView *frameView = [[FrameView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        frameView.contentMode = UIViewContentModeScaleAspectFit;
        frameView.layer.masksToBounds = YES;
        
        frameView.imageView.image = [UIImage imageWithData:[[catch.photos anyObject] photo]];
        
        [containerView addSubview:frameView];
        [self.view addSubview:containerView];*/
    }

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)fullSizeImage:(Catch*)catch
{
    self.fullSizePageViewController.trophyFish = self.trophyFish;
    self.fullSizePageViewController.currentPage = [self.trophyFish indexOfObject:catch];
    
    UIImage *photo = [UIImage imageWithData:[[[[self.trophyFish objectAtIndex:self.fullSizePageViewController.currentPage] photos] anyObject] photo]];
    FullSizeViewController *fullSizeViewController = [[FullSizeViewController alloc]initWithImage:photo];
    NSArray *viewControllers = [NSArray arrayWithObject:fullSizeViewController];
    [self.fullSizePageViewController setViewControllers:viewControllers
                                           direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                           completion:nil];
    
    [self.navigationController pushViewController:self.fullSizePageViewController animated:YES];
}

@end
