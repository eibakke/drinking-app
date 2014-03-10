//
//  HEALUser.m
//  drinkingApp
//
//  Created by Eivind Bakke on 3/3/14.
//  Copyright (c) 2014 Halealei. All rights reserved.
//

#import "HEALUser.h"
#import "HEALNight.h"

@interface HEALUser (){
    
    float userSexMetVal;
}

@end

@implementation HEALUser

-(void)makeNight:(HEALNight*)night
{
    userNight = night;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        userNight = [[HEALNight alloc] init];
        NSDate *myDate = [[NSDate alloc] init];
        userNight->startTime = [self getTimeSec:myDate];
    }
    return self;
}

-(float)getUserBAC
{
    if(userNight->drinks == 0)
    {
        NSDate *myDate = [[NSDate alloc] init];
        userNight->startTime = [self getTimeSec:myDate];
    }
    
    NSDate *cTime = [NSDate date];
    [self getTimeSec:cTime];
    
    return (((userNight->drinks * 3.084) / (userSexMetVal * [userWeight floatValue])) - (0.15 * ([self getTimeSec:cTime] - userNight->startTime)));
}

- (float)getTimeSec:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
    NSString *nicerDate = [dateFormat stringFromDate:date];
    NSDate *timeDate = [dateFormat dateFromString:nicerDate];
    return [timeDate timeIntervalSince1970];
}

            
- (void)setUserSex:(NSString *)sex
{
    userSex = sex;
    if([sex isEqualToString:@"F"])
    {
        userSexMetVal = 0.66;
    } else {
        userSexMetVal = 0.73;
    }
}

- (NSString*)getUserSex
{
    return userSex;
}

- (void)setUserName:(NSString *)name
{
    userName = name;
}

- (NSString*)getUserName
{
    return userName;
}

- (void)setUserWeight:(NSNumber *)weight
{
    userWeight = weight;
}

- (NSNumber*)getUserWeight
{
    return userWeight;
}

- (void)setDrinks:(int)drinks
{
    userNight->drinks = drinks;
}

- (int)getDrinks
{
    return userNight->drinks;
}



@end