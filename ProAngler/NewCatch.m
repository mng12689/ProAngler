//
//  NewCatch.m
//  ProAngler
//
//  Created by Michael Ng on 7/15/12.
//  Copyright (c) Michael Ng. All rights reserved.
//

#import "NewCatch.h"


@implementation NewCatch

@dynamic bait;
@dynamic date;
@dynamic depth;
@dynamic length;
@dynamic location;
@dynamic spawning;
@dynamic species;
@dynamic structure;
@dynamic venue;
@dynamic waterColor;
@dynamic waterLevel;
@dynamic waterTemp;
@dynamic weightLB;
@dynamic weightOZ;
@dynamic baitDepth;

-(NSString*)dateToString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    return [format stringFromDate:self.date];
}

-(NSString*)weightToString
{
    NSString* weightString = @"";
    
    if (([self.weightLB intValue] != 0) && ([self.weightOZ intValue] != 0)) {
        NSString* pounds = @"lb";
        if([self.weightLB intValue] != 1){
            pounds = [pounds stringByAppendingString:@"s"];
        }
        weightString = [NSString stringWithFormat:@"%d %@ %d oz",[self.weightLB intValue], pounds, [self.weightOZ intValue]];
    }
    return weightString;
}

-(NSString*)lengthToString
{
    NSString* lengthString = @"";

    if ([self.length intValue] != 0) {
        lengthString = [NSString stringWithFormat:@"%d in",[self.length intValue]];
    }
    return lengthString;
}

-(NSString*) depthToString
{
    NSString* depthString = @"";

    if([self.depth intValue] != 0){
        depthString = [NSString stringWithFormat:@"%d ft",[self.length intValue]];
    }
    return depthString;
}

-(NSString*) timeToString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    [format setTimeStyle:NSDateFormatterShortStyle];

    return[format stringFromDate:self.date];
}


@end
