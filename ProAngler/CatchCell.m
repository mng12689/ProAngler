//
//  CatchCell.m
//  ProAngler
//
//  Created by Michael Ng on 9/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "CatchCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CatchCell ()

@end

@implementation CatchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.customImageView.layer.cornerRadius = 3;
    self.customImageView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    UIView *selectedView = [[UIView alloc]initWithFrame:self.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.3];

    self.selectedBackgroundView = selectedView;
}

@end
