//
//  PresentImagePickerOptionsViewController.h
//  ProAngler
//
//  Created by Michael Ng on 9/13/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentImagePickerOptionsViewController <NSObject>
- (void) optionChosen:(NSString*)option;
@end

@interface PresentImagePickerOptionsViewController : UIViewController

@property (strong) id<PresentImagePickerOptionsViewController> delegate;

@end
