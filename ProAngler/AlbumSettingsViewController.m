//
//  AlbumSettingsViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "AlbumSettingsViewController.h"

@interface AlbumSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlIndexChanged:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation AlbumSettingsViewController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.segmentedControl.selectedSegmentIndex = self.index;
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
            self.index = 0;
            break;
        case 1:
            self.index = 1;
            break;
        case 2:
            self.index = 2;
            break;
        case 3:
            self.index = 3;
            break;
        default:
            break;
    }

}

- (IBAction)done:(id)sender
{
	[self.delegate albumSettingsViewControllerIsDone:self sortBy:self.index];
}

@end
