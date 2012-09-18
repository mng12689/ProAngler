//
//  PictureView.m
//  ProAngler
//
//  Created by Michael Ng on 9/11/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "PictureView.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"

@interface PictureView ()

@property (strong, nonatomic) IBOutlet UIView *frameView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PictureView

- (id)initWithFrame:(CGRect)frame photo:(Photo*)photo delegate:(WallOfFameViewController*)wallViewController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.photo = photo;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = [UIImage imageWithData:photo.screenSizeImage];

        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:wallViewController action:@selector(showFullSizeImage:)]];
        
        // portrait image
        if (self.imageView.image.size.height > self.imageView.image.size.width) {
            double imageWidth = self.imageView.frame.size.height * self.imageView.image.size.width / self.imageView.image.size.height;
            self.frameView = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageWidth + 20,self.imageView.frame.size.height + 20)];
        }
        
        // landscape image
        else {
            double imageHeight = self.imageView.frame.size.width * self.imageView.image.size.height / self.imageView.image.size.width;
            self.frameView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.imageView.frame.size.width + 20,imageHeight + 20)];
        }
        self.frameView.center = self.imageView.center;
        self.frameView.backgroundColor = [UIColor brownColor];
        
        [self addSubview:self.frameView];
        [self addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
