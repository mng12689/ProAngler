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

@interface PictureView () <UIAlertViewDelegate>

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
        [self.imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(removePhotoFromWall:)]];
        
        BOOL portrait = NO;
        if (self.imageView.image.size.height > self.imageView.image.size.width) 
            portrait = YES;

        if (portrait) {
            double imageWidth = self.imageView.frame.size.height * self.imageView.image.size.width / self.imageView.image.size.height;
            self.frameView = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageWidth + 20,self.imageView.frame.size.height + 20)];
        }
        else {
            double imageHeight = self.imageView.frame.size.width * self.imageView.image.size.height / self.imageView.image.size.width;
            self.frameView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.imageView.frame.size.width + 20,imageHeight + 20)];
        }
        self.frameView.center = self.imageView.center;
        
        // create custom frame
        UIImageView *leftFrameSide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, self.frameView.frame.size.height)];
        UIImage *leftImage = [UIImage imageNamed:@"wood_frame_left_side.png"];
        leftFrameSide.image = leftImage;
        if (portrait)
            leftFrameSide.layer.zPosition = 1;
        
        [self.frameView addSubview:leftFrameSide];
        
        UIImageView *rightFrameSide = [[UIImageView alloc]initWithFrame:CGRectMake(self.frameView.frame.size.width-10, 0, 10, self.frameView.frame.size.height)];
        UIImage *rightImage = [UIImage imageNamed:@"wood_frame_right_side.png"];
        rightFrameSide.image = rightImage;
        if (portrait)
            rightFrameSide.layer.zPosition = 1;
        
        [self.frameView addSubview:rightFrameSide];
        
        UIImageView *topFrameSide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frameView.frame.size.width, 10)];
        UIImage *topImage = [UIImage imageNamed:@"wood_frame_top_side.png"];
        topFrameSide.image = topImage;
        if (!portrait)
            topFrameSide.layer.zPosition = 1;
        
        [self.frameView addSubview:topFrameSide];

        UIImageView *bottomFrameSide = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frameView.frame.size.height - 10, self.frameView.frame.size.width, 10)];
        UIImage *bottomImage = [UIImage imageNamed:@"wood_frame_bottom_side.png"];
        bottomFrameSide.image = bottomImage;
        if (!portrait)
            bottomFrameSide.layer.zPosition = 1;

        [self.frameView addSubview:bottomFrameSide];
        
        [self addSubview:self.frameView];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)shakeAnimation
{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    [self.layer addAnimation:anim forKey:@"Shake"];
}

- (void)removePhotoFromWall:(UILongPressGestureRecognizer*)gesture
{
    [self shakeAnimation];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Remove photo" message:@"Are you sure you want to remove this photo from your Wall Of Fame?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.photo.trophyFish = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemovalFromWOF" object:nil];
    }
    [self.layer removeAllAnimations];
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
