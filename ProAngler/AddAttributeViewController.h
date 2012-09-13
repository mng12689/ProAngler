//
//  AddAttributeViewController.h
//  ProAngler
//
//  Created by Michael Ng on 7/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAttributeViewController;

@protocol AddAttributeViewControllerDelegate <NSObject>
- (void)attributeSaved:(NSString*)attributeType;
@end

@interface AddAttributeViewController : UIViewController

@property (nonatomic, weak) id <AddAttributeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* attributeType;

@end
