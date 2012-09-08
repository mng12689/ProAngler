//
//  FrameView.m
//  ProAngler
//
//  Created by Michael Ng on 9/7/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "FrameView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.layer.masksToBounds = YES;
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
