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

-(id)init
{
    self = [super init];
    
    if (self) {
        self.currentNight = [[HEALNight alloc] init];
    }
    return self;
}

-(float)BAC
{
    NSDate *cTime = [NSDate date];
    
    double timeDrinking = ([cTime timeIntervalSince1970] - self.currentNight.startTime)/3600000;
    float drinkFactor = self.currentNight.drinks * 3.084;
    float userFactor = userSexMetVal * self.weight;
    
    _BAC = (drinkFactor / userFactor) - (0.15 * timeDrinking);
    
    return(MAX(0, _BAC));
}

-(void)sex:(sexes)sex
{
    _sex = sex;
    if(sex == FEMALE)
    {
        userSexMetVal = 0.66;
    }
    else
    {
        userSexMetVal = 0.73;
    }
}


@end