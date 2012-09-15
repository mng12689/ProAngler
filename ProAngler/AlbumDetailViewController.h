//
//  AlbumDetailViewController.h
//  ProAngler
//
//  Created by Michael Ng on 6/28/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Catch;

@interface AlbumDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *addToWallOfFameButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (AlbumDetailViewController*) initWithNewCatch:(Catch*)newCatch;

@end
