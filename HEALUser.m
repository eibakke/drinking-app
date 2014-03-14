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
    self.currentNight = night;
}

-(id)init:(NSString*)name userSex:(NSString*)sex userWeight:(NSNumber*)weight
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.weight = weight;
        self.sex = sex;
        self.currentNight = [[HEALNight alloc] init];
        if([sex isEqualToString:@"F"])
        {
            userSexMetVal = 0.66;
        } else {
            userSexMetVal = 0.73;
        }
    }
    return self;
}

-(NSNumber*)BAC
{
    NSDate *cTime = [NSDate date];
    
    _BAC = [NSNumber numberWithDouble:(([self.currentNight.drinks intValue] * 3.084) / (userSexMetVal * [self.weight floatValue])) - (0.15 * ([self getTimeSec:cTime] - [self.currentNight.startTime floatValue]))];
    return(MAX([NSNumber numberWithInt:0], _BAC));
    
}

- (float)getTimeSec:(NSDate*)date
{
    return [date timeIntervalSince1970];
}

-(void)sex:(NSString*)sex
{
    _sex = sex;
    if([sex isEqualToString:@"F"])
    {
        userSexMetVal = 0.66;
    } else {
        userSexMetVal = 0.73;
    }
}


@end