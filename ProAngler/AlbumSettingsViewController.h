//
//  AlbumSettingsViewController.h
//  ProAngler
//
//  Created by Michael Ng on 4/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumSettingsViewController;

@protocol AlbumSettingsViewControllerDelegate <NSObject>
    - (void)albumSettingsViewControllerIsDone:(AlbumSettingsViewController *)controller sortBy:(NSUInteger)index;
@end

@interface AlbumSettingsViewController : UIViewController
    @property (nonatomic, weak) id <AlbumSettingsViewControllerDelegate> delegate;
    @property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
    @property NSUInteger index;

    - (IBAction)segmentedControlIndexChanged:(id)sender;
    - (IBAction)done:(id)sender;
@end
