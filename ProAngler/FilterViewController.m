//
//  FilterViewController.m
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "FilterViewController.h"
#import "ProAnglerDataStore.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize delegate;
@synthesize scrollView;

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
    
    scrollView.contentSize = CGSizeMake(320, 4000);

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    NSString *titleForRow;
    NSString *conditional;
    NSInteger row;
    
    //set venue conditional
    row = [super.venuePickerView selectedRowInComponent:0];
    titleForRow = [[super.venueList objectAtIndex:row]name];
    conditional = @"venue == \"%@\"";
    
    if([super.speciesPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.speciesList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND species == %@",titleForRow]];    }
    /*(if([super.weatherConditionsPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.weathList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:@" AND species == %@",titleForRow]; 
    }
    if([super.tempPickerView selectedRowInComponent:0]!=0){
    titleForRow = [[super.speciesList objectAtIndex:row-1]name];
    [conditional stringByAppendingString:@" AND species == %@",titleForRow]; 
    }*/
    /*if([super.waterTempPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.waterTempList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND waterTemp == %@",titleForRow]];
    }*/
    if([super.waterColorPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.waterColorList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND waterColor == %@",titleForRow]];    } 
    if([super.waterLevelPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.waterLevelList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND waterLevel == %@",titleForRow]];
    }
    if([super.baitPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.baitList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND bait == %@",titleForRow]];    }
    if([super.baitDepthPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.baitDepthList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND baitDepth == %@",titleForRow]];    }
    if([super.spawningPickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.spawningList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND spawning == %@",titleForRow]];
    }
    /*if([super.sizePickerView selectedRowInComponent:0]!=0){
        
    }
    if([super.sizePickerView selectedRowInComponent:1]!=0){
        newCatch.weightOZ = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:1]-1];
    }
    if([super.sizePickerView selectedRowInComponent:2]!=0){
        newCatch.length = [NSNumber numberWithInt:[super.sizePickerView selectedRowInComponent:2]-1];
    }*/
    if([super.structurePickerView selectedRowInComponent:0]!=0){
        titleForRow = [[super.structureList objectAtIndex:row-1]name];
        [conditional stringByAppendingString:[NSString stringWithFormat:@" AND structure == %@",titleForRow]];
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:conditional];
    NSArray *filteredCatches = [ProAnglerDataStore fetchEntity:@"New Catch" sortBy:@"venue" withPredicate:predicate];
    [self cancelModal:nil];
    [self.delegate filterSaved:filteredCatches];
}

@end
