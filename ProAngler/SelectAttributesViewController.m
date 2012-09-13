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
       
    self.venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil];
    self.speciesList = [ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:nil];
    self.baitList = [ProAnglerDataStore fetchEntity:@"Bait" sortBy:@"name" withPredicate:nil];
    self.structureList = [ProAnglerDataStore fetchEntity:@"Structure" sortBy:@"name" withPredicate:nil];
    self.waterColorList = [NSArray arrayWithObjects:@"Clear", @"Murky", nil];
    self.waterLevelList = [NSArray arrayWithObjects:@"Low", @"Normal", @"High", nil];
    self.spawningList = [NSArray arrayWithObjects:@"NO", @"YES", nil];
    self.baitDepthList = [NSArray arrayWithObjects:@"Topwater", @"Suspended", @"Bottom", nil];
       
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
    //self.timeRangePickerView.delegate = self;
    //self.timeRangePickerView.dataSource = self;
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
    if(pickerView.tag == 101)
        return 3;
    
    else if (pickerView.tag == 118)
        return 4;
    
    else if (pickerView.tag >= 115)
        return 2;
    
    else 
        return 1;
}
       
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
       
{
    if(pickerView.tag == 101)
        
        if(component == 0)
            return 1002;
        
        else if(component == 1)
            return 17;
        
        else
            return 122;
        
    else if(pickerView.tag == 102)
        return [self.venueList count]+1;
    
    else if(pickerView.tag == 103) 
        return [self.speciesList count]+1;
    
    else if(pickerView.tag == 104)
        return [self.baitList count]+1;
    
    else if(pickerView.tag == 105) 
        return [self.structureList count]+1;
    
    else if(pickerView.tag == 106 || pickerView.tag == 116)
        return 152;
    
    else if(pickerView.tag == 107 || pickerView.tag == 117)
        return 70;
    
    else if(pickerView.tag == 108) 
        return [self.waterColorList count]+1;
    
    else if(pickerView.tag == 109) 
        return [self.waterLevelList count]+1;
    
    else if(pickerView.tag == 110) 
        return [self.spawningList count]+1;
    
    else if(pickerView.tag == 111)
        return [self.baitDepthList count]+1;
    
    
    else if (pickerView.tag == 115)
        return 132;
    
    else if (pickerView.tag == 118)
        
        if (component == 0 || component == 2)
            return 1002;
        else
            return 17;
        
    else if (pickerView.tag == 119)
        return 122;

    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if(row == 0)
        return @"";
    
    else if(pickerView.tag == 101 || pickerView.tag == 118 || pickerView.tag == 119)
        return [[NSNumber numberWithInt:row-1] stringValue];
    
    else if(pickerView.tag == 102)
        return [[self.venueList objectAtIndex:row-1]name];
    
    else if(pickerView.tag == 103)  
        return [[self.speciesList objectAtIndex:row-1]name];
    
    else if(pickerView.tag == 104)
        return [[self.baitList objectAtIndex:row-1]name];
    
    else if(pickerView.tag == 105)
        return [[self.structureList objectAtIndex:row-1]name];
    
    else if(pickerView.tag == 106 || pickerView.tag == 116)
        return [[NSNumber numberWithInt:row-1]stringValue];
    
    else if(pickerView.tag == 107 || pickerView.tag == 117)
        return [[NSNumber numberWithInt:row+31]stringValue];
    
    else if(pickerView.tag == 108)     
        return [self.waterColorList objectAtIndex:row-1];
    
    else if(pickerView.tag == 109)
        return [self.waterLevelList objectAtIndex:row-1];
    
    else if(pickerView.tag == 110)
        return [self.spawningList objectAtIndex:row-1];
    
    else if(pickerView.tag == 111)
        return [self.baitDepthList objectAtIndex:row-1];
    
    else if(pickerView.tag == 115)
        return [[NSNumber numberWithInt:row-1]stringValue];
    
    else 
        return @"";
    
}

@end
