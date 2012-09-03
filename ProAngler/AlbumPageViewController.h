//
//  AlbumPageViewController.h
//  ProAngler
//
//  Created by Michael Ng on 6/27/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic,strong) NSArray *fetchedObjects;
@property NSInteger currentPage;

@end
