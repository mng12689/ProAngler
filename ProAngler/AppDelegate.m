//
//  AppDelegate.m
//  ProAngler
//
//  Created by Michael Ng on 4/6/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:@"date" forKey:@"ProAnglerAlbumSortTypePrefKey"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"light_wood_nav_bar.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"light_wood_tab_bar.jpg"]];
    
    [self.window.rootViewController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"page_texture"]]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

- (void)setTitle:(NSString *)title forNavItem:(UINavigationItem*)navItem
{
    UILabel *titleView = (UILabel *)navItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:25];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:.2];
    titleView.shadowOffset = CGSizeMake(0, 1);
    titleView.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"engraved_wood_texture.jpg"]];

    navItem.titleView = titleView;
    
    titleView.text = title;
    [titleView sizeToFit];
}

/*- (UIView*)setTitle:(NSString *)title forNavItem:(UINavigationItem*)navItem
{
    UILabel *titleView = (UILabel *)navItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:25];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:.2];
    titleView.shadowOffset = CGSizeMake(0, 1);
    titleView.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"engraved_wood_texture.jpg"]];
    
    navItem.titleView = titleView;
    
    titleView.text = title;
    [titleView sizeToFit];
}*/
@end
