//
//  CatchCell.m
//  ProAngler
//
//  Created by Michael Ng on 9/14/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "CatchCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CatchCell
@synthesize customImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
