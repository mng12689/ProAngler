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

@synthesize sizePickerView,venuePickerView,speciesPickerView,baitPickerView,structurePickerView, depthPickerView,waterTempPickerView,waterColorPickerView,waterLevelPickerView,spawningPickerView,baitDepthPickerView;

@synthesize speciesList,venueList,baitList,structureList,waterColorList,waterLevelList,spawningList,baitDepthList;

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
       
    venueList = [ProAnglerDataStore fetchEntity:@"Venue" sortBy:@"name" withPredicate:nil];
    speciesList = [ProAnglerDataStore fetchEntity:@"Species" sortBy:@"name" withPredicate:nil];
    baitList = [ProAnglerDataStore fetchEntity:@"Bait" sortBy:@"name" withPredicate:nil];
    structureList = [ProAnglerDataStore fetchEntity:@"Structure" sortBy:@"name" withPredicate:nil];
    waterColorList = [NSArray arrayWithObjects:@"Clear", @"Murky", nil];
    waterLevelList = [NSArray arrayWithObjects:@"Low", @"Normal", @"High", nil];
    spawningList = [NSArray arrayWithObjects:@"NO", @"YES", nil];
    baitDepthList = [NSArray arrayWithObjects:@"Topwater", @"Suspended", @"Bottom", nil];
       
    sizePickerView.delegate = self;
    sizePickerView.dataSource = self;
    venuePickerView.delegate = self;
    venuePickerView.dataSource = self;
    speciesPickerView.delegate = self;
    speciesPickerView.dataSource = self;
    baitPickerView.delegate = self;
    baitPickerView.dataSource = self;
    structurePickerView.delegate = self;
    structurePickerView.dataSource = self;
    depthPickerView.delegate = self;
    depthPickerView.dataSource = self;
    waterTempPickerView.delegate = self;
    waterTempPickerView.dataSource = self;
    waterColorPickerView.delegate = self;
    waterColorPickerView.dataSource = self;
    waterLevelPickerView.delegate = self;
    waterLevelPickerView.dataSource = self;
    spawningPickerView.delegate = self;
    spawningPickerView.dataSource = self;
    baitDepthPickerView.delegate = self;
    baitDepthPickerView.dataSource = self;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView.tag == 101){
        return 3;
    }
    else {
        return 1;
    }
}
       
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
       
{
    if(pickerView.tag == 101){
        if(component == 0){
            return 1002;
        }
        else if(component == 1){
            return 17;
        }
        else{
            return 122;
        }
    } 
    else if(pickerView.tag == 102){
        return [venueList count]+1;
    }
    else if(pickerView.tag == 103){  
        return [speciesList count]+1;
    } 
    else if(pickerView.tag == 104){
        return [baitList count]+1;
    }
    else if(pickerView.tag == 105) {
        return [structureList count]+1;
    }
    else if(pickerView.tag == 106) {
        return 152;
    }
    else if(pickerView.tag == 107) {
        return 70;
    }
    else if(pickerView.tag == 108) {
        return [waterColorList count]+1;
    }
    else if(pickerView.tag == 109) {
        return [waterLevelList count]+1;
    }
    else if(pickerView.tag == 110) {
        return [spawningList count]+1;
    }
    else if(pickerView.tag == 111) {
        return [baitDepthList count]+1;
    }
    else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if(row == 0){
        return @"-----";
    }
    else if(pickerView.tag == 101){
        return [[NSNumber numberWithInt:row-1] stringValue];
    } 
    else if(pickerView.tag == 102){
        return [[venueList objectAtIndex:row-1]name];
    }
    else if(pickerView.tag == 103){  
        return [[speciesList objectAtIndex:row-1]name];
    } 
    else if(pickerView.tag == 104){
        return [[baitList objectAtIndex:row-1]name];
    }
    else if(pickerView.tag == 105){
        return [[structureList objectAtIndex:row-1]name];
    }
    else if(pickerView.tag == 106){
        return [[NSNumber numberWithInt:row-1]stringValue];
    } 
    else if(pickerView.tag == 107){
        return [[NSNumber numberWithInt:row+31]stringValue];
    } 
    else if(pickerView.tag == 108){     
        return [waterColorList objectAtIndex:row-1];
    } 
    else if(pickerView.tag == 109){
        return [waterLevelList objectAtIndex:row-1];
    } 
    else if(pickerView.tag == 110){
        return [spawningList objectAtIndex:row-1];
    } 
    else if(pickerView.tag == 111){
        return [baitDepthList objectAtIndex:row-1];
    } 
    else {
        return @"";
    }
}

@end
