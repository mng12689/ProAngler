//
//  FullSizeImageViewController.m
//  ProAngler
//
//  Created by Michael Ng on 9/12/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "FullSizeImageViewController.h"
#import "AlbumDetailViewController.h"
#import "Photo.h"

@interface FullSizeImageViewController ()

@property (strong) Photo *photo;
@property (strong) NSTimer *timer;

@end

@implementation FullSizeImageViewController

- (id)initWithPhoto:(Photo *)photo
{
    self = [super init];
    if (self)
    {
        self.photo = photo;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)loadView
{
    self.view = [[UIImageView alloc]initWithImage:[UIImage imageWithData:self.photo.screenSizeImage]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateNavBar)]];
    self.view.userInteractionEnabled = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)animation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    [self.navigationController.navigationBar setAlpha:0.0];
    [UIView commitAnimations];
         
    [self.timer invalidate];
}
         
-(void)animateNavBar
{
    [self.navigationController.navigationBar setAlpha:1.0];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(animation) userInfo:nil repeats:NO];
}

@end
