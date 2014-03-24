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

-(id)init:(NSString*)name userSex:(NSString*)sex userWeight:(int)weight
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

-(float)BAC
{
    NSDate *cTime = [NSDate date];
    
    double timeDrinking = [self getTimeSec:cTime] - self.currentNight.startTime;
    float drinkFactor = self.currentNight.drinks * 3.084;
    float userFactor = userSexMetVal * self.weight;
    
    _BAC = (drinkFactor / userFactor) - (0.15 * timeDrinking);
    
    return(MAX(0, _BAC));
    
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