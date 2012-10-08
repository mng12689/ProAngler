//
//  SelectAttributesViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Michael Ng. All rights reserved.
//

#import "SelectAttributesViewController.h"
#import "ProAnglerDataStore.h"

@interface SelectAttributesViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation SelectAttributesViewController

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"VenueAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        self.venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        [self.venuePickerView reloadAllComponents];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SpeciesAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        self.speciesList = [ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        [self.speciesPickerView reloadAllComponents];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"BaitAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        self.baitList = [ProAnglerDataStore fetchEntity:@"Bait" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        [self.baitPickerView reloadAllComponents];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"StructureAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        self.structureList = [ProAnglerDataStore fetchEntity:@"Structure" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        [self.structurePickerView reloadAllComponents];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"WeatherDescriptionAdded" object:nil queue:nil usingBlock:^(NSNotification *note){
        self.weatherDescriptionsList = [ProAnglerDataStore fetchEntity:@"WeatherDescription" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
        [self.weatherConditionsPickerView reloadAllComponents];
    }];
    
    self.venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
    self.speciesList = [ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
    self.baitList = [ProAnglerDataStore fetchEntity:@"Bait" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
    self.structureList = [ProAnglerDataStore fetchEntity:@"Structure" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
    self.waterColorList = [NSArray arrayWithObjects:@"Clear", @"Murky", nil];
    self.waterLevelList = [NSArray arrayWithObjects:@"Low", @"Normal", @"High", nil];
    self.spawningList = [NSArray arrayWithObjects:@"NO", @"YES", nil];
    self.baitDepthList = [NSArray arrayWithObjects:@"Topwater", @"Suspended", @"Bottom", nil];
    self.weatherDescriptionsList = [ProAnglerDataStore fetchEntity:@"WeatherDescription" sortBy:@"name" withPredicate:nil propertiesToFetch:nil];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sizePickerView.delegate = self;
    self.sizePickerView.dataSource = self;
    self.venuePickerView.delegate = self;
    self.venuePickerView.dataSource = self;
    self.speciesPickerView.delegate = self;
    self.speciesPickerView.dataSource = self;
    self.baitPickerView.delegate = self;
    self.baitPickerView.dataSource = self;
    self.structurePickerView.delegate = self;
    self.structurePickerView.dataSource = self;
    self.depthPickerView.delegate = self;
    self.depthPickerView.dataSource = self;
    self.waterTempPickerView.delegate = self;
    self.waterTempPickerView.dataSource = self;
    self.waterColorPickerView.delegate = self;
    self.waterColorPickerView.dataSource = self;
    self.waterLevelPickerView.delegate = self;
    self.waterLevelPickerView.dataSource = self;
    self.spawningPickerView.delegate = self;
    self.spawningPickerView.dataSource = self;
    self.baitDepthPickerView.delegate = self;
    self.baitDepthPickerView.dataSource = self;
    
    self.dateRangePickerView.delegate = self;
    self.dateRangePickerView.dataSource = self;
    self.timeRangePickerView.delegate = self;
    self.timeRangePickerView.dataSource = self;
    self.weatherConditionsPickerView.delegate = self;
    self.weatherConditionsPickerView.dataSource = self;
    self.temperatureRangePickerView.delegate = self;
    self.temperatureRangePickerView.dataSource = self;
    self.depthRangePickerView.delegate = self;
    self.depthRangePickerView.dataSource = self;
    self.waterTempRangePickerView.delegate = self;
    self.waterTempRangePickerView.dataSource = self;
    self.weightRangePickerView.delegate = self;
    self.weightRangePickerView.dataSource = self;
    self.lengthRangePickerView.delegate = self;
    self.lengthRangePickerView.dataSource = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setSizePickerView:nil];
    [self setVenuePickerView:nil];
    [self setSpeciesPickerView:nil];
    [self setBaitPickerView:nil];
    [self setStructurePickerView:nil];
    [self setDepthPickerView:nil];
    [self setWaterTempPickerView:nil];
    [self setWaterColorPickerView:nil];
    [self setWaterLevelPickerView:nil];
    [self setSpawningPickerView:nil];
    [self setBaitDepthPickerView:nil];
    
    [self setDateRangePickerView:nil];
    [self setTimeRangePickerView:nil];
    [self setWeatherConditionsPickerView:nil];
    [self setTemperatureRangePickerView:nil];
    [self setDepthRangePickerView:nil];
    [self setWaterTempRangePickerView:nil];
    [self setWeightRangePickerView:nil];
    [self setLengthRangePickerView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(pickerView == self.sizePickerView)
        return 3;
    
    else if (pickerView == self.timeRangePickerView || pickerView == self.dateRangePickerView)
        return 4;
    
    else if (pickerView.tag >= 115)
        return 2;
    
    else 
        return 1;
}
       
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
       
{
    if(pickerView == self.sizePickerView)
    {
        if(component == 0)
            return 1002;
        
        else if(component == 1)
            return 17;
        
        else
            return 122;
    }
        
    else if(pickerView == self.venuePickerView)
        return [self.venueList count]+1;
    
    else if(pickerView == self.speciesPickerView)
        return [self.speciesList count]+1;
    
    else if(pickerView == self.baitPickerView)
        return [self.baitList count]+1;
    
    else if(pickerView == self.structurePickerView)
        return [self.structureList count]+1;
    
    else if(pickerView == self.depthPickerView || pickerView == self.depthRangePickerView)
        return 152;
    
    else if(pickerView == self.waterTempPickerView || pickerView == self.waterTempRangePickerView)
        return 70;
    
    else if(pickerView == self.waterColorPickerView)
        return [self.waterColorList count]+1;
    
    else if(pickerView == self.waterLevelPickerView)
        return [self.waterLevelList count]+1;
    
    else if(pickerView == self.spawningPickerView)
        return [self.spawningList count]+1;
    
    else if(pickerView == self.baitDepthPickerView)
        return [self.baitDepthList count]+1;
    
    else if(pickerView == self.dateRangePickerView)
    {
        
        if (component == 0 || component == 2)
            return 13;
        
        /****** return correct number of days based on month ****/
        
        else
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *dateComps = [NSDateComponents new];
            
            if (component == 1)
                dateComps.month = [pickerView selectedRowInComponent:0];
            else if (component == 3)
                dateComps.month = [pickerView selectedRowInComponent:2];
            
            NSRange daysInSelectedMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:dateComps]];
            return daysInSelectedMonth.length + 1;
        }
    }
    
    else if (pickerView == self.timeRangePickerView){
        
        if (component == 0 || component == 2)
            return 13;
        else
            return 3;
    }
    
    else if (pickerView == self.weatherConditionsPickerView)
        return [self.weatherDescriptionsList count] +1;
    
    else if (pickerView == self.temperatureRangePickerView)
        return 132;
    
    else if (pickerView == self.weightRangePickerView)
        return 1002;
        
    else if (pickerView == self.lengthRangePickerView)
        return 122;

    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if(row == 0)
        return @"";
    
    else if(pickerView == self.sizePickerView || pickerView == self.weightRangePickerView || pickerView == self.lengthRangePickerView)
        return [[NSNumber numberWithInt:row-1] stringValue];
    
    else if(pickerView == self.venuePickerView)
        return [[self.venueList objectAtIndex:row-1]name];
    
    else if(pickerView == self.speciesPickerView)
        return [[self.speciesList objectAtIndex:row-1]name];
    
    else if(pickerView == self.baitPickerView)
        return [[self.baitList objectAtIndex:row-1]name];
    
    else if(pickerView == self.structurePickerView)
        return [[self.structureList objectAtIndex:row-1]name];
    
    else if(pickerView == self.depthPickerView || pickerView == self.depthRangePickerView)
        return [[NSNumber numberWithInt:row-1]stringValue];
    
    else if(pickerView == self.waterTempPickerView || pickerView == self.waterTempRangePickerView)
        return [[NSNumber numberWithInt:row+31]stringValue];
    
    else if(pickerView == self.waterColorPickerView)
        return [self.waterColorList objectAtIndex:row-1];
    
    else if(pickerView == self.waterLevelPickerView)
        return [self.waterLevelList objectAtIndex:row-1];
    
    else if(pickerView == self.spawningPickerView)
        return [self.spawningList objectAtIndex:row-1];
    
    else if(pickerView == self.baitDepthPickerView)
        return [self.baitDepthList objectAtIndex:row-1];
    
    else if(pickerView == self.temperatureRangePickerView)
        return [[NSNumber numberWithInt:row-1]stringValue];
    
    else if(pickerView == self.weatherConditionsPickerView)
        return [[self.weatherDescriptionsList objectAtIndex:row-1]name];
    
    else if (pickerView == self.timeRangePickerView) {
        if (component == 0 || component == 2) 
            return [[NSNumber numberWithInt:row] stringValue];
        else {
            if (row == 1)
                return @"AM";
            else
                return @"PM";
        }
    }
             
    else if (pickerView == self.dateRangePickerView) {
        if (component == 0 || component == 2)
        {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            return [[dateFormatter shortMonthSymbols] objectAtIndex:row-1];
        }
        else
            return [[NSNumber numberWithInt:row] stringValue];
    }
    
    return @"";
    
}

@end
