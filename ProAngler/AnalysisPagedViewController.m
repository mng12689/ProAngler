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
#import "AppDelegate.h"

@interface AnalysisPagedViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UINavigationItem *customNavigationItem;
@property (strong) NSMutableArray *pagesViewControllers;

@property int pageCount;

- (IBAction)changePage;
- (IBAction)filter:(id)sender;

@end

@implementation AnalysisPagedViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.pageCount = 2;
        
        self.pagesViewControllers = [NSMutableArray new];
        
        PageOneMapViewController *pageOne = [PageOneMapViewController new];
        pageOne.analysisViewController = self;
        [self.pagesViewControllers addObject:pageOne];
        
        PageTwoStatsViewController *pageTwo = [PageTwoStatsViewController new];
        [self.pagesViewControllers addObject:pageTwo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood.jpg"]];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"Analysis" forNavItem:self.customNavigationItem];
    
    self.scrollView.delegate = self;
    
    for (UIViewController *viewController in self.pagesViewControllers) {
        [self.scrollView addSubview:viewController.view];
    }
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setCustomNavigationItem:nil];
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

- (IBAction)filter:(id)sender
{
    [[self.pagesViewControllers objectAtIndex:0] presentFilterModal];
}

@end
