//
//  AnalysisPagedViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/8/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AnalysisPagedViewController.h"
#import "PageOneMapViewController.h"
#import "PageTwoStatsViewController.h"

@interface AnalysisPagedViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong) NSMutableArray *pagesViewControllers;

@property int pageCount;

- (IBAction)changePage;

@end

@implementation AnalysisPagedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood_no_gradient.jpg"]];
    
    self.pageCount = 2;
    self.scrollView.delegate = self;
    
    self.pagesViewControllers = [NSMutableArray new];
    PageOneMapViewController *pageOne = [PageOneMapViewController new];
    pageOne.analysisViewController = self;
    [self.scrollView addSubview:pageOne.view];
    [self.pagesViewControllers addObject:pageOne];
    
    PageTwoStatsViewController *pageTwo = [PageTwoStatsViewController new];
    [self.scrollView addSubview:pageTwo.view];
    [self.pagesViewControllers addObject:pageTwo];    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount, self.scrollView.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
