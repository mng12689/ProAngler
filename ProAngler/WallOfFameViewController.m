//
//  WallOfFameViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/25/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "WallOfFameViewController.h"
#import "ProAnglerDataStore.h"
#import "Catch.h"
#import "Photo.h"
#import "PictureView.h"
#import <QuartzCore/QuartzCore.h>
#import "FullSizeImageViewController.h"
#import "FullSizeImagePageViewController.h"
#import "PictureView.h"

@interface WallOfFameViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong) NSArray *trophyFish;
@property (strong) NSMutableArray *frameViewControllers;
-(void)populateWall;

@end

@implementation WallOfFameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_wall_texture.jpg"]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"AddToWOF" object:nil queue:nil usingBlock:^(NSNotification *note){
        [self populateWall];
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self populateWall];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 0.0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)populateWall
{
    self.trophyFish = [ProAnglerDataStore fetchEntity:@"Catch" sortBy:@"date" withPredicate:[NSPredicate predicateWithFormat:@"trophyFish == YES"]];
    
    BOOL toggle = YES;
    int index = 0;
    int row = 0;
    for (Catch *catch in self.trophyFish)
    {
        toggle = !toggle;
    
        PictureView *pictureView = [[PictureView alloc] initWithFrame:CGRectMake(20 + 150*toggle, 20 + 150*row, 130, 130) photo:[catch.photos anyObject] delegate:self];
        
        [self.scrollView addSubview:pictureView];
        
        if (index != 0 && index%2)
            row++;
        index++;
    }
}

-(void)showFullSizeImage:(UITapGestureRecognizer*)tapGesture
{
    UIImageView *imageView = (UIImageView*)tapGesture.view;
    FullSizeImageViewController *fullSizeImageViewController = [[FullSizeImageViewController alloc]initWithPhoto:[(PictureView*)imageView.superview photo]];
    
    FullSizeImagePageViewController *pageViewController = [[FullSizeImagePageViewController alloc]
                               initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options: nil];
    pageViewController.currentPage = [self.trophyFish indexOfObject:[[(PictureView*)imageView.superview photo]catch]];
    
    NSMutableArray *photos = [NSMutableArray new];
    for (Catch *catch in self.trophyFish) 
        [photos addObject:[catch.photos anyObject]];
    
    pageViewController.photosForPages = photos;
    pageViewController.showFullStatsOption = YES;
    [pageViewController setViewControllers:@[fullSizeImageViewController]
                                direction:UIPageViewControllerNavigationDirectionForward
                                animated:YES
                                completion:nil];
    
    [self.navigationController pushViewController:pageViewController animated:YES];
}

@end
