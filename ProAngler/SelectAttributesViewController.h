//
//  SelectAttributesViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAttributesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *sizePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *venuePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *speciesPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *baitPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *structurePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *depthPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *waterTempPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *waterColorPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *waterLevelPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *spawningPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *baitDepthPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *dateRangePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeRangePickerView;
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

/*@property (strong, nonatomic) NSMutableArray *speciesList;
@property (strong, nonatomic) NSMutableArray *venueList;
@property (strong, nonatomic) NSMutableArray *baitList;
@property (strong, nonatomic) NSMutableArray *structureList;
@property (strong, nonatomic) NSMutableArray *waterColorList;
@property (strong, nonatomic) NSMutableArray *waterLevelList;
@property (strong, nonatomic) NSMutableArray *spawningList;
@property (strong, nonatomic) NSMutableArray *baitDepthList;*/


@end
