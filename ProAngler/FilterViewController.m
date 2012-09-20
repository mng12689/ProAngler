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

@interface FilterViewController () <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreOptionsButton;

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
        NSString *species = [[super.speciesList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND species.name like \"%@\"",species];
        [filters addObject:[NSString stringWithFormat:@"Species: %@",species]];
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
        [filters addObject:[NSString stringWithFormat:@"Date in range: %@ %d - %@ %d",[months objectAtIndex:startMonth-1], startDay,[months objectAtIndex:endMonth-1], endDay]];
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
        if (endTime == 12)
            endTime = 0;
        
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
        NSString *weatherDescription = [[super.weatherDescriptionsList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND weatherDescription.name like \"%@\"",weatherDescription];
        [filters addObject:[NSString stringWithFormat:@"Weather Conditions: %@",weatherDescription]];
    }

    if([super.temperatureRangePickerView selectedRowInComponent:0]!=0 && [super.temperatureRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.temperatureRangePickerView selectedRowInComponent:0] >[super.temperatureRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Temperature range: Min > Max\n"];
        }
        else {
            int minTemp = [super.temperatureRangePickerView selectedRowInComponent:0]-1;
            int maxTemp = [super.temperatureRangePickerView selectedRowInComponent:1]-1;

            conditional = [conditional stringByAppendingFormat:@" AND tempF >= %d AND tempF =< %d",minTemp,maxTemp];
            [filters addObject:[NSString stringWithFormat:@"Temperature in range: %dºF - %dºF", minTemp,maxTemp]];
        }
    }
    
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.baitDepthPickerView selectedRowInComponent:0];
        NSString *baitDepth = [super.baitDepthList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND baitDepth like \"%@\"",baitDepth];
        [filters addObject:[NSString stringWithFormat:@"Bait Depth: %@",baitDepth]];
    }
    
    if([super.spawningPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.spawningPickerView selectedRowInComponent:0];
        NSString *spawning = [super.spawningList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND spawning == %@",spawning];
        [filters addObject:[NSString stringWithFormat:@"Spawning: %@",spawning]];
    }
    
    if([super.depthRangePickerView selectedRowInComponent:0]!=0 && [super.depthRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.depthRangePickerView selectedRowInComponent:0] >[super.depthRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Depth range: Min > Max\n"];
        }
        else {
            int minDepth = [super.depthRangePickerView selectedRowInComponent:0]-1;
            int maxDepth = [super.depthRangePickerView selectedRowInComponent:1]-1;

            conditional = [conditional stringByAppendingFormat:@" AND depth >= %d AND depth <= %d",minDepth,maxDepth];
            [filters addObject:[NSString stringWithFormat:@"Depth in range: %d ft - %d ft",minDepth, maxDepth]];
        }
    }

    if([super.waterTempRangePickerView selectedRowInComponent:0]!=0 && [super.waterTempRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.waterTempRangePickerView selectedRowInComponent:0] >[super.waterTempRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Water temp range: Min > Max\n"];
        }
        else {
            int minTemp = [super.waterTempRangePickerView selectedRowInComponent:0]+31;
            int maxTemp = [super.waterTempRangePickerView selectedRowInComponent:1]+31;

            conditional = [conditional stringByAppendingFormat:@" AND waterTempF >= %d AND waterTempF <= %d",minTemp,maxTemp];
            [filters addObject:[NSString stringWithFormat:@"Water temp in range: %dºF - %dºF",minTemp,maxTemp]];
        }
    }

    if([super.waterColorPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.waterColorPickerView selectedRowInComponent:0];
        NSString *waterColor = [super.waterColorList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND waterColor like \"%@\"",waterColor];
        [filters addObject:[NSString stringWithFormat:@"Water color: %@",waterColor]];
    }
    
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.waterLevelPickerView selectedRowInComponent:0];
        NSString *waterLevel = [super.waterLevelList objectAtIndex:row-1];
        conditional = [conditional stringByAppendingFormat:@" AND waterLevel like \"%@\"",waterLevel];
        [filters addObject:[NSString stringWithFormat:@"Water level: %@",waterLevel]];
    }

    if([super.weightRangePickerView selectedRowInComponent:0]!=0 && [super.weightRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.weightRangePickerView selectedRowInComponent:0] >[super.weightRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Weight range: Min > Max"];
        }
        else
        {
            int minOZ = ([super.weightRangePickerView selectedRowInComponent:0]-1)*16;
            int maxOZ = ([super.weightRangePickerView selectedRowInComponent:1]-1)*16;

            conditional = [conditional stringByAppendingFormat:@" AND weightOZ >= %d AND weightOZ <= %d",minOZ,maxOZ];
            [filters addObject:[NSString stringWithFormat:@"Weight in range: %d LB - %d LB",(int)(minOZ/16),(int)(maxOZ/16)]];
        }
    }

    if([super.lengthRangePickerView selectedRowInComponent:0]!=0 && [super.lengthRangePickerView selectedRowInComponent:1]!=0)
    {
        if ([super.lengthRangePickerView selectedRowInComponent:0] >[super.lengthRangePickerView selectedRowInComponent:1]) {
            invalidInput = YES;
            invalidInputMessage = [invalidInputMessage stringByAppendingString:@"Length range: Min > Max"];
        }
        else {
            int minLength = [super.lengthRangePickerView selectedRowInComponent:0]-1;
            int maxLength = [super.lengthRangePickerView selectedRowInComponent:1]-1;

            conditional = [conditional stringByAppendingFormat:@" AND length >= %d AND length <= %d",minLength,maxLength];
            [filters addObject:[NSString stringWithFormat:@"Length in range: %d in - %d in",minLength,maxLength]];
        }
    }
    
    if([super.baitPickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.baitPickerView selectedRowInComponent:0];
        NSString *bait = [[super.baitList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND bait.name like \"%@\"",bait];
        [filters addObject:[NSString stringWithFormat:@"Bait: %@",bait]];
    }
    
    if([super.structurePickerView selectedRowInComponent:0]!=0)
    {
        int row = [super.structurePickerView selectedRowInComponent:0];
        NSString *structure = [[super.structureList objectAtIndex:row-1]name];
        conditional = [conditional stringByAppendingFormat:@" AND structure.name like \"%@\"",structure];
        [filters addObject:[NSString stringWithFormat:@"Structure: %@",structure]];
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == super.dateRangePickerView)
    {
        if (component == 0) 
            [pickerView reloadComponent:1];
        
        else if (component == 2)
            [pickerView reloadComponent:3];
    }
}

@end
