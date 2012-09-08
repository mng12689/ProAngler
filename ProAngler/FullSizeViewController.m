//
//  FullSizeImageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/6/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "FullSizeViewController.h"

@interface FullSizeViewController ()

@end

@implementation FullSizeViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

-(id)initWithImage:(UIImage*)image{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
