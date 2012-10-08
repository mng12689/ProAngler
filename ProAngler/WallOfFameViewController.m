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
@property (strong) NSArray *trophyFishPhotos;
@property (strong) NSMutableArray *frameViewControllers;
-(void)populateWall;

@end

@implementation WallOfFameViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"InductionToWOF" object:nil queue:nil usingBlock:^(NSNotification *note){
            [self populateWall];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"RemovalFromWOF" object:nil queue:nil usingBlock:^(NSNotification *note){
            [self populateWall];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood_wall_texture.jpg"]];
    
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
    for (PictureView *pictureView in self.scrollView.subviews) {
        [pictureView removeFromSuperview];
    }
    
    self.trophyFishPhotos = [ProAnglerDataStore fetchEntity:@"Photo" sortBy:@"catch.date" withPredicate:[NSPredicate predicateWithFormat:@"trophyFish == %@",[NSNumber numberWithBool:YES]] propertiesToFetch:@[@"thumbnail"]];
    
    BOOL toggle = YES;
    int index = 0;
    int row = 0;
    for (Photo *photo in self.trophyFishPhotos)
    {
        toggle = !toggle;
    
        PictureView *pictureView = [[PictureView alloc] initWithFrame:CGRectMake(20 + 150*toggle, 20 + 150*row, 130, 130) photo:photo delegate:self];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, pictureView.frame.origin.y + pictureView.frame.size.height + 20);
        [self.scrollView addSubview:pictureView];
        
        if (index != 0 && index%2){
            row++;
        }
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
    pageViewController.currentPage = [self.trophyFishPhotos indexOfObject:[(PictureView*)imageView.superview photo]];
        
    pageViewController.photosForPages = self.trophyFishPhotos;
    pageViewController.showFullStatsOption = YES;
    [pageViewController setViewControllers:@[fullSizeImageViewController]
                                direction:UIPageViewControllerNavigationDirectionForward
                                animated:YES
                                completion:nil];
    
    [self.navigationController pushViewController:pageViewController animated:YES];
}

@end
