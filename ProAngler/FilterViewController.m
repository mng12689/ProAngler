//
//  FilterViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "FilterViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreOptionsButton;

- (IBAction)saveFilter:(id)sender;
- (IBAction)cancelModal:(id)sender;
- (IBAction)toggleHiddenView:(id)sender;

@end

@implementation FilterViewController
@synthesize showMoreOptionsButton = _showMoreOptionsButton;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood.jpg"]];
    
    AppDelegate *appDelegate  = [[UIApplication sharedApplication] delegate];
    [appDelegate setTitle:@"Filter" forNavItem:self.navigationItem];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.showMoreOptionsButton.layer.cornerRadius = 8;
    self.showMoreOptionsButton.layer.masksToBounds = YES;
    self.showMoreOptionsButton.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:.2];
    self.showMoreOptionsButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
}

- (void)viewDidUnload
{
    [self setDetailView:nil];
    [self setShowMoreOptionsButton:nil];
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
    NSString *conditional = @"";
    NSMutableArray *filters = [NSMutableArray new];
    
    NSString *venue;
    NSDictionary *filterDate;
    NSDictionary *filterTime;
    
    BOOL invalidInput = NO;
    NSString *invalidInputMessage = @"";
    
    //set venue conditional
    if ([super.venuePickerView selectedRowInComponent:0] == 0) {
        invalidInput = YES;
        invalidInputMessage = [invalidInputMessage stringByAppendingString:@"You must select a venue\n"];
    }
    else {
        int row = [super.venuePickerView selectedRowInComponent:0];
        venue = [[super.venueList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@"venue.name like \"%@\"",venue];
    }
    
    if([super.speciesPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.speciesPickerView selectedRowInComponent:0];
        NSString *titleForRow = [[super.speciesList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND species.name like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Species: %@",titleForRow]];
    }
    
    if([super.dateRangePickerView selectedRowInComponent:0]!=0 && [super.dateRangePickerView selectedRowInComponent:1]!=0 && [super.dateRangePickerView selectedRowInComponent:2]!=0 && [super.dateRangePickerView selectedRowInComponent:3]!=0 )
    {
        NSDateFormatter *df = [NSDateFormatter new];
        NSArray *months = [df monthSymbols];
        
        int startMonth = [super.dateRangePickerView selectedRowInComponent:0];
        int startDay = [super.dateRangePickerView selectedRowInComponent:1];
        
        int endMonth = [super.dateRangePickerView selectedRowInComponent:2];
        int endDay = [super.dateRangePickerView selectedRowInComponent:3];
        
        filterDate = [NSDictionary dictionaryWithObjects:@[@(startMonth),@(startDay),@(endMonth),@(endDay)] forKeys:@[@"startMonth",@"startDay",@"endMonth",@"endDay"]];
        [filters addObject:[NSString stringWithFormat:@"Date in range: %@ %d - %@ %d",[months objectAtIndex:startMonth], startDay,[months objectAtIndex:endMonth], endDay]];
    }

    if([super.timeRangePickerView selectedRowInComponent:0]!=0 && [super.timeRangePickerView selectedRowInComponent:1]!=0 && [super.timeRangePickerView selectedRowInComponent:2]!=0 && [super.timeRangePickerView selectedRowInComponent:3]!=0)
    {
        int startTime = [super.timeRangePickerView selectedRowInComponent:0];
        if (startTime == 12)
            startTime = 0;
        
        int militaryStartTime = startTime;
        NSString *startIndicator = @"AM";
        if ([super.timeRangePickerView selectedRowInComponent:1] == 2){
            militaryStartTime += 12;
            startIndicator = @"PM";
        }
        
        int endTime = [super.timeRangePickerView selectedRowInComponent:2];
        int militaryEndTime = endTime;
        NSString *endIndicator = @"AM";
        if ([super.timeRangePickerView selectedRowInComponent:3] == 2){
            militaryEndTime += 12;
            endIndicator = @"PM";
        }
        
        filterTime = [NSDictionary dictionaryWithObjects:@[@(militaryStartTime),@(militaryEndTime)] forKeys:@[@"startTime",@"endTime"]];
        [filters addObject:[NSString stringWithFormat:@"Time in range: %d %@  - %d %@",startTime,startIndicator,endTime,endIndicator]];
    }

    if([super.weatherConditionsPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.weatherConditionsPickerView selectedRowInComponent:0];
        NSString *titleForRow = [[super.weatherDescriptionsList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND weatherDescription.name like \"%@\"",titleForRow];
        [filters addObject:[NSString stringWithFormat:@"Weather Conditions: %@",titleForRow]];
    }

    if([super.temperatureRangePickerView selectedRowInComponent:0]!=0 && [super.temperatureRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.temperatureRangePickerView selectedRowInComponent:0] >[super.temperatureRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Temperature range: Min > Max\n"];
        }
        else {
            int row1 = [super.temperatureRangePickerView selectedRowInComponent:0];
            int row2 = [super.temperatureRangePickerView selectedRowInComponent:1];

            conditional = [conditional stringByAppendingFormat:@" AND tempF >= %d AND tempF =< %d",row1-1,row2-1];
            [filters addObject:[NSString stringWithFormat:@"Temperature in range: %d - %d",row1-1,row2-1]];
        }
    }
    
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0)
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
        if ([super.depthRangePickerView selectedRowInComponent:0] >[super.depthRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Depth range: Min > Max\n"];
        }
        else {
            int row1 = [super.depthRangePickerView selectedRowInComponent:0];
            int row2 = [super.depthRangePickerView selectedRowInComponent:1];

            conditional = [conditional stringByAppendingFormat:@" AND depth >= %d AND depth <= %d",row1-1,row2-1];
            [filters addObject:[NSString stringWithFormat:@"Depth in range: %d - %d",row1-1,row2-1]];
        }
    }

    if([super.waterTempRangePickerView selectedRowInComponent:0]!=0 && [super.waterTempRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.waterTempRangePickerView selectedRowInComponent:0] >[super.waterTempRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Water temp range: Min > Max\n"];
        }
        else {
            int row1 = [super.waterTempPickerView selectedRowInComponent:0];
            int row2 = [super.waterTempPickerView selectedRowInComponent:1];

            conditional = [conditional stringByAppendingFormat:@" AND waterTemp >= %d AND waterTemp <= %d",row1-1,row2-1];
            [filters addObject:[NSString stringWithFormat:@"Water temp in range: %d - %d",row1-1,row2-1]];
        }
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

    /*if([super.weightRangePickerView selectedRowInComponent:0]!=0 && [super.weightRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.weightRangePickerView selectedRowInComponent:0] >[super.weightRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Weight range: Min > Max"];
        }
        else {
            int row1 = [super.weightRangePickerView selectedRowInComponent:0];
            int row2 = [super.weightRangePickerView selectedRowInComponent:1];

            NSString *titleForRow1 = [NSString stringWithFormat:@"%d",row1-1];
            NSString *titleForRow2 = [NSString stringWithFormat:@"%d",row2-1];

            conditional = [conditional stringByAppendingFormat:@" AND weightLB >= %@ AND weightLB <= %@",titleForRow1,titleForRow2];
            [filters addObject:[NSString stringWithFormat:@"Weight in range: %@ - %@",titleForRow1,titleForRow2]];
        }
    }*/

    if([super.lengthRangePickerView selectedRowInComponent:0]!=0 && [super.lengthRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.lengthRangePickerView selectedRowInComponent:0] >[super.lengthRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Length range: Min > Max"];
        }
        else {
            int row1 = [super.lengthRangePickerView selectedRowInComponent:0];
            int row2 = [super.lengthRangePickerView selectedRowInComponent:1];

            conditional = [conditional stringByAppendingFormat:@" AND length >= %d AND length <= %d",row1-1,row2-1];
            [filters addObject:[NSString stringWithFormat:@"Length in range: %d - %d",row1-1,row2-1]];
        }
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
    
    if (invalidInput) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid input" message:invalidInputMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:conditional];
        [self cancelModal:nil];
        [self.delegate filterForVenue:venue withPredicate:predicate andAdditionalFilters:filters filterDate:filterDate filterTime:filterTime];
    }
}

- (IBAction)toggleHiddenView:(id)sender
{
    if (self.detailView.hidden) {
        self.detailView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.detailView.frame.origin.y + self.detailView.frame.size.height);
    }
    else{
        self.detailView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
}
@end
