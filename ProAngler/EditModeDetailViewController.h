//
//  EditModeDetailViewController.h
//  ProAngler
//
//  Created by Michael Ng on 9/15/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAttributesViewController.h"
@class Catch;

@interface EditModeDetailViewController : SelectAttributesViewController

@property (strong) Catch *catch;

@end
