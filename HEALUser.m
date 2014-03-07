//
//  HEALUser.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALUser.h"
#import "HEALNight.h"

@implementation HEALUser

-(void)makeNight:(HEALNight*)night
{
    userNight = night;
}

//-(NSNumber*)getUserBAC
//{
//    if(userNight->drinks == 0)
//    {
//        NSDate *myDate = [[NSDate alloc] init];
//        userNight->startTime = [self getTimeSec:myDate];
//        return (((labelVal * 3.084) / (sexVal * weight)) - (0.15 * ((currentTime - startTime)/ 3600)))]
//    } else {
//        
//    }
//    return 0;
//}

- (float)getTimeSec:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
    NSString *nicerDate = [dateFormat stringFromDate:date];
    NSDate *timeDate = [dateFormat dateFromString:nicerDate];
    return [timeDate timeIntervalSince1970];
}

@end