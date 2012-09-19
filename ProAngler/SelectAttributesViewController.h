//
//  SelectAttributesViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAttributesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *sizePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *venuePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *speciesPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *baitPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *structurePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *depthPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *waterTempPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *waterColorPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *waterLevelPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *spawningPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *baitDepthPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *dateRangePickerView; 
@property (weak, nonatomic) IBOutlet UIPickerView *timeRangePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *weatherConditionsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *temperatureRangePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *depthRangePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *waterTempRangePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *weightRangePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *lengthRangePickerView;

@property (strong, nonatomic) NSArray *speciesList;
@property (strong, nonatomic) NSArray *venueList;
@property (strong, nonatomic) NSArray *baitList;
@property (strong, nonatomic) NSArray *structureList;
@property (strong, nonatomic) NSArray *waterColorList;
@property (strong, nonatomic) NSArray *waterLevelList;
@property (strong, nonatomic) NSArray *spawningList;
@property (strong, nonatomic) NSArray *baitDepthList;
@property (strong, nonatomic) NSArray *weatherDescriptionsList;

@end
