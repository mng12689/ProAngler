//
//  FullSizeImageViewController.h
//  ProAngler
//
//  Created by Michael Ng on 9/12/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Catch;
@class Photo;

@interface FullSizeImageViewController : UIViewController

@property int currentPage;
-(id)initWithPhoto:(Photo*)photo;

@end
