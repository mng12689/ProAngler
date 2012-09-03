//
//  AlbumViewController.h
//  ProAngler
//
//  Created by Michael Ng on 4/7/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumSettingsViewController.h"

@interface AlbumViewController : UITableViewController <AlbumSettingsViewControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) NSArray* fetchedObjects;
@property (nonatomic,strong) NSString* sortBy;

@end
