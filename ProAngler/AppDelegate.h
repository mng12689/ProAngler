//
//  AppDelegate.h
//  ProAngler
//
//  Created by Michael Ng on 4/6/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setTitle:(NSString *)title forNavItem:(UINavigationItem*)navItem;

@end
