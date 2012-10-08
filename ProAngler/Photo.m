//
//  Photo.m
//  ProAngler
//
//  Created by Michael Ng on 9/18/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "Photo.h"
#import "Catch.h"

@implementation Photo

@dynamic fullSizeImage;
@dynamic screenSizeImage;
@dynamic thumbnail;
@dynamic trophyFish;
@dynamic createdAt;
@dynamic catch;
@dynamic inductionDate;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.createdAt = [NSDate date];
}

- (NSString*)inductionDateToString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    return [format stringFromDate:self.inductionDate];
}

@end
