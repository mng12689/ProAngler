//
//  AlbumDetailViewController.h
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NewCatch.h"

@interface AlbumDetailViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UILabel *speciesLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (strong, nonatomic) IBOutlet UILabel *baitLabel;
@property (strong, nonatomic) IBOutlet UILabel *structureLabel;
@property (strong, nonatomic) IBOutlet UILabel *depthLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *spawningLabel;

@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;

@property (strong, nonatomic) IBOutlet UILabel *waterColorLabel;
@property (strong, nonatomic) IBOutlet UILabel *waterTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *waterLevelLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIView *photoDisplayView;
@property (strong, nonatomic) IBOutlet UIScrollView *photoDisplayScrollView;

@property (strong, nonatomic) IBOutlet UIView *catchInfoView;
@property (strong, nonatomic) IBOutlet UIView *weatherConditionsView;
@property (strong, nonatomic) IBOutlet UIView *waterConditionsView;


+ (AlbumDetailViewController*) initWithNewCatch:(NewCatch*)newCatch atIndex:(NSInteger)index;

@end
