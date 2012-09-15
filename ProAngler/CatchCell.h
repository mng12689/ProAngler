//
//  CatchCell.h
//  ProAngler
//
//  Created by Michael Ng on 9/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Catch;

@interface CatchCell : UITableViewCell

@property (strong) Catch *currentCatch;

@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *customImageView;

@end
