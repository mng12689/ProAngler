//
//  AlbumSettingsViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumSettingsViewController.h"

@interface AlbumSettingsViewController ()

@end

@implementation AlbumSettingsViewController

@synthesize delegate;
@synthesize segmentedControl;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.segmentedControl.selectedSegmentIndex = index;
}

- (void)viewDidUnload
{
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segmentedControlIndexChanged:(id)sender 
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            index = 0;
            break;
        case 1:
            index = 1;
            break;
        case 2:
            index = 2;
            break;
        case 3:
            index = 3;
            break;
        default:
            break;
    }

}

- (IBAction)done:(id)sender
{
	[self.delegate albumSettingsViewControllerIsDone:self sortBy:index];
}

@end
