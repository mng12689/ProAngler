//
//  Catch.m
//  ProAngler
//
//  Created by Michael Ng on 9/3/12.
//  Copyright (c) 2012 Amherst College. All rights reserved.
//

#import "Catch.h"
#import "Bait.h"
#import "Photo.h"
#import "Species.h"
#import "Structure.h"
#import "Venue.h"


@implementation Catch

@dynamic baitDepth;
@dynamic date;
@dynamic depth;
@dynamic length;
@dynamic location;
@dynamic spawning;
@dynamic waterColor;
@dynamic waterLevel;
@dynamic waterTempF;
@dynamic weightOZ;
@dynamic bait;
@dynamic photos;
@dynamic species;
@dynamic structure;
@dynamic venue;
@dynamic humidity;
@dynamic tempF;
@dynamic visibility;
@dynamic weatherDescription;
@dynamic windSpeedMPH;
@dynamic windDir;


-(void)awakeFromInsert
{
    self.weightOZ = @-1;
    self.length = @-1;
    self.waterTempF = @-1;
    self.depth = @-1;
    
    self.humidity = @-1;
    self.tempF = @-1;
    self.visibility = @-1;
    self.windSpeedMPH = @-1;
}

-(NSString*)dateToString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    return [format stringFromDate:self.date];
}

- (BOOL)dateIsBetweenMonth:(int)startMonth day:(int)startDay andMonth:(int)endMonth day:(int)endDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *catchDateComponents = [calendar components:NSDayCalendarUnit fromDate:self.date];
    
    NSDateComponents *startDateComponents = [NSDateComponents new];
    startDateComponents.day = startDay;
    startDateComponents.month = startMonth;
    startDateComponents.year = 2001;
    
    NSDate *startDate = [calendar dateFromComponents:startDateComponents];
    startDateComponents = [calendar components:NSDayCalendarUnit fromDate:startDate];
    
    NSDateComponents *endDateComponents = [NSDateComponents new];
    endDateComponents.day = endDay;
    endDateComponents.month = endMonth;
    endDateComponents.year = 2001;
    
    NSDate *endDate = [calendar dateFromComponents:endDateComponents];
    endDateComponents = [calendar components:NSDayCalendarUnit fromDate:endDate];
    
    if ([self daysElapsedStart:startDateComponents.day end:catchDateComponents.day] <= [self daysElapsedStart:startDateComponents.day end:endDateComponents.day])
        return YES;
    
    return NO;
}

-(int)daysElapsedStart:(int)startDay end:(int)endDay
{
    return ((endDay-startDay)+366)%366;
}

- (BOOL)timeBetweenHour:(int)startHour andHour:(int)endHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *catchDateComponents = [calendar components:NSHourCalendarUnit fromDate:self.date];

    if ([self timeElapsedStart:startHour end:catchDateComponents.hour] <= [self timeElapsedStart:startHour end:endHour])
        return YES;
    
    return NO;
}

-(int)timeElapsedStart:(int)startHour end:(int)endHour
{
    return ((endHour-startHour)+24)%24;
}

-(NSString*)weightToString
{
    NSString *weightString = @"";
    
    if ([self.weightOZ intValue] != -1) {
        NSString* pounds;
        if ([self.weightOZ intValue] == 16)
            pounds = @"lb";
        else if ([self.weightOZ intValue] > 16)
            pounds = @"lbs";
        weightString = [NSString stringWithFormat:@"%d %@ %d oz",[self.weightOZ intValue]/16, pounds, [self.weightOZ intValue]%16];
    }
    return weightString;
}

-(NSString*)lengthToString
{
    NSString *lengthString = @"";
    if ([self.length intValue] != -1) {
        lengthString = [NSString stringWithFormat:@"%d in",[self.length intValue]];
    }
    return lengthString;
}

-(NSString*)depthToString
{
    NSString *depthString = @"";
    if([self.depth intValue] != -1){
        depthString = [NSString stringWithFormat:@"%d ft",[self.depth intValue]];
    }
    return depthString;
}

-(NSString*)timeToString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    [format setTimeStyle:NSDateFormatterShortStyle];
    
    return[format stringFromDate:self.date];
}

-(NSString*)humidityToString
{
    NSString *humidityString = @"";
    if ([self.humidity intValue] != -1) {
        humidityString = [NSString stringWithFormat:@"%d%%",[self.humidity intValue]];
    }
    return humidityString;
}

-(NSString*)tempFToString
{
    NSString *tempString = @"";
    if ([self.tempF intValue] != -1) {
        tempString = [NSString stringWithFormat:@"%d ºF",[self.tempF intValue]];
    }
    return tempString;
}

-(NSString*)visibilityToString
{
    NSString *visibilityString = @"";
    if ([self.visibility intValue] != -1) {
        visibilityString = [NSString stringWithFormat:@"%d%%",[self.visibility intValue]];
    }
    return visibilityString;
}

-(NSString*)windToString
{
    NSString *windString = @"";
    if (self.windDir && [self.windSpeedMPH intValue] != -1) {
        windString = [NSString stringWithFormat:@"%@ at %d MPH",self.windDir,[self.windSpeedMPH intValue]];
    }
    return windString;
}

-(NSString *)waterTempFToString
{
    NSString *waterTempString = @"";
    if ([self.waterTempF intValue] != -1) {
        waterTempString = [NSString stringWithFormat:@"%d ºF",[self.waterTempF intValue]];
    }
    return waterTempString;
}

@end
