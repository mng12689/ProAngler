//
//  WallOfFamePageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/12/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "WallOfFamePageViewController.h"

@interface WallOfFamePageViewController ()

@end

@implementation WallOfFamePageViewController

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
	// Do any additional setup after loading the view.
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

@end
