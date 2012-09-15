//
//  PictureView.h
//  ProAngler
//
//  Created by Michael Ng on 9/11/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WallOfFameViewController;
@class Photo;

@interface PictureView : UIView

@property (strong) Photo *photo;

- (id)initWithFrame:(CGRect)frame photo:(Photo*)photo delegate:(WallOfFameViewController*)wallViewController;

@end
