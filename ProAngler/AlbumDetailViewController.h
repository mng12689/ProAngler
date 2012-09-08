//
//  AlbumDetailViewController.h
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class Catch;

@interface AlbumDetailViewController : UIViewController

@property int currentPage;
@property (strong) Catch *catch;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *speciesLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *baitLabel;
@property (weak, nonatomic) IBOutlet UILabel *structureLabel;
@property (weak, nonatomic) IBOutlet UILabel *depthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spawningLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;

@property (weak, nonatomic) IBOutlet UILabel *waterColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLevelLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mediaScrollView;

@property (weak, nonatomic) IBOutlet UIView *catchInfoView;
@property (weak, nonatomic) IBOutlet UIView *weatherConditionsView;
@property (weak, nonatomic) IBOutlet UIView *waterConditionsView;

@property (weak, nonatomic) IBOutlet UIButton *addToWallOfFameButton;
- (IBAction)addToWallOfFame:(id)sender;

- (AlbumDetailViewController*) initWithNewCatch:(Catch*)newCatch atIndex:(int)index;

@end
