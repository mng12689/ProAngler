//
//  AlbumSettingsViewController.m
//  ProAngler
//
//  Created by Michael Ng on 4/14/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AlbumSettingsViewController.h"

@interface AlbumSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong) NSArray *sorters;

- (IBAction)done:(id)sender;

@end

@implementation AlbumSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.sorters = @[@"date",@"weightOZ",@"venue.name",@"species.name"];
    NSString *sortBy= [[NSUserDefaults standardUserDefaults] objectForKey:@"ProAnglerAlbumSortTypePrefKey"];
    
    for (int i = 0; i < [self.sorters count]; i++) {
        if ([sortBy isEqualToString:[self.sorters objectAtIndex:i]]){
            self.segmentedControl.selectedSegmentIndex = i;
            break;
        }
    }
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

- (IBAction)done:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[self.sorters objectAtIndex:self.segmentedControl.selectedSegmentIndex] forKey:@"ProAnglerAlbumSortTypePrefKey"];
	[self.delegate settingsChanged];
}

@end
