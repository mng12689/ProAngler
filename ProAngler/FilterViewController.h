//
//  FilterViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/8/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAttributesViewController.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>
- (void)filterSaved:(NSArray*)filteredCatches;
@end

@interface FilterViewController : SelectAttributesViewController

@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cancelModal:(id)sender;

@end
