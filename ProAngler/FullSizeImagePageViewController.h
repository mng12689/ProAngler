//
//  FullSizeImagePageViewController.h
//  ProAngler
//
//  Created by Michael Ng on 9/12/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullSizeImagePageViewController : UIPageViewController

@property (nonatomic,strong) NSArray *photosForPages;
@property int currentPage;
@property BOOL showFullStatsOption;

@end
