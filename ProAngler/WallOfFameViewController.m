//
//  WallOfFameViewController.m
//  ProAngler
//
//  Created by Michael Ng on 6/25/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "WallOfFameViewController.h"

@interface WallOfFameViewController ()

@end

@implementation WallOfFameViewController
@synthesize scrollView;
@synthesize navBar;

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

@end
