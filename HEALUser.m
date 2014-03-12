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
    float bac;
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
        self.userName = name;
        self.userWeight = weight;
        self.userSex = sex;
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

-(float)getUserBAC
{
    NSDate *cTime = [NSDate date];
    
    bac = (([self.currentNight.drinks intValue] * 3.084) / (userSexMetVal * [self.userWeight floatValue])) - (0.15 * ([self getTimeSec:cTime] - [self.currentNight.startTime floatValue]));
    
    if(bac < 0){
        return (0);
    }
    
    else{
        return (bac);
    }
    
}

- (float)getTimeSec:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMMM dd, yyyy, hh:mm aa"];
    NSString *nicerDate = [dateFormat stringFromDate:date];
    NSDate *timeDate = [dateFormat dateFromString:nicerDate];
    return [timeDate timeIntervalSince1970];
}

- (void)setDrinks:(int)drinks
{
    self.currentNight.drinks = [NSNumber numberWithInt:drinks];
}

- (int)getDrinks
{
    return [self.currentNight.drinks intValue];
}



@end