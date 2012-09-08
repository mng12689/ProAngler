//
//  FilterViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

- (IBAction)saveFilter:(id)sender;
- (IBAction)cancelModal:(id)sender;
- (IBAction)toggleHiddenView:(id)sender;

@end

@implementation FilterViewController

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
    
    self.scrollView.contentSize = CGSizeMake(320, 460);
}

- (void)viewDidUnload
{
    [self setDetailView:nil];
    [self setDetailView:nil];
    [super viewDidUnload];
    [self setScrollView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelModal:(id)sender 
{
   	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveFilter:(id)sender
{
    NSString *conditional;
    NSMutableArray *filters = [NSMutableArray new];
    
    //set venue conditional
    int row = [super.venuePickerView selectedRowInComponent:0];
    NSString *venue = [[super.venueList objectAtIndex:row-1]name];
    conditional = [NSString stringWithFormat:@"venue.name like \"%@\"",venue];
    
    if([super.speciesPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.speciesPickerView selectedRowInComponent:0];
        NSString *titleForRow = [[super.speciesList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND species.name like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Species: %@",titleForRow]];
    }
    
    /*if([super.dateRangePickerView selectedRowInComponent:0]!=0){
        row = [super.dateRangePickerView selectedRowInComponent:0];
        titleForRow = [[super.dateRangesList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND (date > %@ date < %@",titleForRow]];
        [filters addObject:titleForRow];
    }
    
    if([super.timeRangePickerView selectedRowInComponent:0]!=0){
        row = [super.timeRangePickerView selectedRowInComponent:0];
        titleForRow = [[super.dateRangesList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND (date > %@ date < %@",titleForRow]];
        [filters addObject:titleForRow];
    }*/

    /*if([super.weatherConditionsPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.weatherConditionsPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.weatherConditionsList objectAtIndex:row-1];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND weatherConditions like %@",titleForRow]];
        [filters addObject:[NSString stringWithFormat:@"Weather Conditions: %@",titleForRow]];
    }*/

    if([super.temperatureRangePickerView selectedRowInComponent:0]!=0 && [super.temperatureRangePickerView selectedRowInComponent:1]!=0)
    {
        int row1 = [super.temperatureRangePickerView selectedRowInComponent:0];
        int row2 = [super.temperatureRangePickerView selectedRowInComponent:1];

        NSString *titleForRow1 = [NSString stringWithFormat:@"%d",row1-1];
        NSString *titleForRow2 = [NSString stringWithFormat:@"%d",row2-1];

        conditional = [conditional stringByAppendingFormat:@" AND tempF >= %@ AND tempF =< %@",titleForRow1,titleForRow2];
        [filters addObject:[NSString stringWithFormat:@"Temperature in range: %@ - %@",titleForRow1,titleForRow2]];
    }
    
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0 && [super.baitDepthPickerView selectedRowInComponent:1]!=0)
    {
        int row = [super.baitDepthPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.baitDepthList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND baitDepth like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Bait Depth: %@",titleForRow]];
    }
    
    if([super.spawningPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.spawningPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.spawningList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND spawning == %@",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Spawning: %@",titleForRow]];
    }
    
    if([super.depthRangePickerView selectedRowInComponent:0]!=0 && [super.depthRangePickerView selectedRowInComponent:1]!=0)
    {
        int row1 = [super.spawningPickerView selectedRowInComponent:0];
        int row2 = [super.spawningPickerView selectedRowInComponent:1];

        NSString *titleForRow1 = [super.spawningList objectAtIndex:row1-1];
        NSString *titleForRow2 = [super.spawningList objectAtIndex:row2-1];

        conditional = [conditional stringByAppendingFormat:@" AND depth >= %@ AND depth <= %@",titleForRow1,titleForRow2];
        [filters addObject:[NSString stringWithFormat:@"Depth in range: %@ - %@",titleForRow1,titleForRow2]];
    }

    if([super.waterTempRangePickerView selectedRowInComponent:0]!=0 && [super.waterTempRangePickerView selectedRowInComponent:1]!=0)
    {
        int row1 = [super.spawningPickerView selectedRowInComponent:0];
        int row2 = [super.spawningPickerView selectedRowInComponent:1];

        NSString *titleForRow1 = [super.spawningList objectAtIndex:row1-1];
        NSString *titleForRow2 = [super.spawningList objectAtIndex:row2-1];

        conditional = [conditional stringByAppendingFormat:@" AND waterTemp >= %@ AND waterTemp <= %@)",titleForRow1,titleForRow2];
        [filters addObject:[NSString stringWithFormat:@"Water temp in range: %@ - %@",titleForRow1,titleForRow2]];
    }

    if([super.waterColorPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.waterColorPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.waterColorList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND waterColor like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Water color: %@",titleForRow]];
    }
    
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.waterLevelPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.waterLevelList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND waterLevel like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Water level: %@",titleForRow]];
    }

    if([super.weightRangePickerView selectedRowInComponent:0]!=0 && [super.weightRangePickerView selectedRowInComponent:1]!=0)
    {
        int row1 = [super.weightRangePickerView selectedRowInComponent:0];
        int row2 = [super.weightRangePickerView selectedRowInComponent:1];

        NSString *titleForRow1 = [super.waterLevelList objectAtIndex:row1-1];
        NSString *titleForRow2 = [super.waterLevelList objectAtIndex:row2-1];

        conditional = [conditional stringByAppendingFormat:@" AND weightLB >= %@ AND weightLB <= %@",titleForRow1,titleForRow2];
        [filters addObject:[NSString stringWithFormat:@"Weight in range: %@ - %@",titleForRow1,titleForRow2]];
    }

    if([super.lengthRangePickerView selectedRowInComponent:0]!=0 && [super.lengthRangePickerView selectedRowInComponent:1]!=0)
    {
        int row1 = [super.lengthRangePickerView selectedRowInComponent:0];
        int row2 = [super.lengthRangePickerView selectedRowInComponent:1];

        NSString *titleForRow1 = [super.waterLevelList objectAtIndex:row1-1];
        NSString *titleForRow2 = [super.waterLevelList objectAtIndex:row2-1];

        conditional = [conditional stringByAppendingFormat:@" AND length >= %@ AND length <= %@",titleForRow1,titleForRow2];
        [filters addObject:[NSString stringWithFormat:@"Length in range: %@ - %@",titleForRow1,titleForRow2]];
    }
    
    if([super.baitPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.baitPickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.baitList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND bait.name like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Bait: %@",titleForRow]];
    }
    
    if([super.structurePickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.structurePickerView selectedRowInComponent:0];
        NSString *titleForRow = [super.structureList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND structure.name like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Structure: %@",titleForRow]];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:conditional];
    [self cancelModal:nil];
    [self.delegate filterForVenue:venue withPredicate:predicate andAdditionalFilters:filters];
}

- (IBAction)toggleHiddenView:(id)sender
{
    if (self.detailView.hidden) {
        self.detailView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(320, self.detailView.frame.origin.y + self.detailView.frame.size.height);
    }
    else{
        self.detailView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(320, 450);
    }
}
@end
