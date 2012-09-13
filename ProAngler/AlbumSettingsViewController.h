//
//  AlbumSettingsViewController.h
//  ProAngler
//
//  Created by Michael Ng on 4/14/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumSettingsViewController;

@protocol AlbumSettingsViewControllerDelegate <NSObject>
- (void)settingsChanged;
@end

@interface AlbumSettingsViewController : UIViewController

@property (nonatomic, weak) id <AlbumSettingsViewControllerDelegate> delegate;

@end
