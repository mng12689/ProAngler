//
//  PresentImagePickerOptionsViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/13/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "PresentImagePickerOptionsViewController.h"

@interface PresentImagePickerOptionsViewController ()

- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseExisting:(id)sender;

@end

@implementation PresentImagePickerOptionsViewController

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

- (IBAction)takePhoto:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate optionChosen:@"takePhoto"];
    }];
}

- (IBAction)chooseExisting:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate optionChosen:@"chooseExisting"];
    }];
}
@end
