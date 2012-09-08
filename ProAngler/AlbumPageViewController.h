//
//  AlbumPageViewController.h
//  ProAngler
//
//  Created by Michael Ng on 6/27/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumPageViewController : UIPageViewController

@property (nonatomic,strong) NSArray *fetchedObjects;
@property int currentPage;

@end
